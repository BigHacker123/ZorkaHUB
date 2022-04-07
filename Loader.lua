repeat task.wait() until game.GameId ~= 0
if ZØRKA and ZØRKA.Loaded then
	ZØRKA.Utilities.UI:Notification({
		Title = "ZØRKA Hub",
		Description = "Script already executed!",
		Duration = 5
	})
	return
end

getgenv().ZØRKA = {
	Loaded = true,
	Debug = false,
	Current = "Loader",
	Utilities = {},
	Config = {}
}

ZØRKA.Utilities.UI = ZØRKA.Debug and loadfile("ZorkaHUB/Utilities/UI.lua")() or loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/Utilities/UI.lua"))()
ZØRKA.Utilities.Config = ZØRKA.Debug and loadfile("ZorkaHUB/Utilities/Config.lua")() or loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/Utilities/Config.lua"))()
ZØRKA.Utilities.Drawing = ZØRKA.Debug and loadfile("ZorkaHUB/Utilities/Drawing.lua")() or loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/Utilities/Drawing.lua"))()
ZØRKA.Utilities.ThreadLoop = function(Wait,Function)
	coroutine.wrap(function()
		while task.wait(Wait) do
			Function()
		end
	end)()
end

ZØRKA.Games = {
	["1054526971"] = {
		Name = "Blackhawk Rescue Mission 5",
		Script = ZØRKA.Debug and readfile("ZorkaHUB/BRM5/ClientBRM5.lua") or game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/BRM5/ClientBRM5.lua")
	},
	["301549746"] = {
		Name = "Counter Blox",
		Script = ZØRKA.Debug and readfile("ZorkaHUB/CounterBlox/ClientCB.lua") or game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/CounterBlox/ClientCB.lua")
	},
	["286090429"] = {
		Name = "Arsenal",
		Script = ZØRKA.Debug and readfile("ZorkaHUB/Arsenal/ClientASL.lua") or game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/Arsenal/ClientASL.lua")
	},
	--[[
	["1168263273"] = {
		Name = "Deep Woken",
		Script = ZØRKA.Debug and readfile("ZorkaHUB/DeepWoken/ClientDW.lua") or game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/DeepWoken/ClientDW.lua")
	},
	["292439477"] = {
		Name = "Phantom Forces",
		Script = ZØRKA.Debug and readfile("ZorkaHUB/Phantom/ClientPH.lua") or game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/Phantom/ClientPH.lua")
	}
	]]
}

local PlayerService = game:GetService("Players")
local LocalPlayer = PlayerService.LocalPlayer
local function getGameInfo()
	for Id,Info in pairs(ZØRKA.Games) do
		if tostring(game.GameId) == Id then
			return Info
		end
	end
end

LocalPlayer.OnTeleport:Connect(function(State)
	if State == Enum.TeleportState.Started then
		getgenv().ZØRKA.Loaded = false
		local QueueOnTeleport = (syn and syn.queue_on_teleport) or queue_on_teleport
		QueueOnTeleport(ZØRKA.Debug and readfile("ZorkaHUB/Loader.lua") or game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/Loader.lua"))
	end
end)

local Info = getGameInfo()
if Info then
	ZØRKA.Current = Info.Name
	ZØRKA.Utilities.UI:Notification({
		Title = "ZØRKA Hub",
		Description = ZØRKA.Current .. " loaded!",
		Duration = 5
	})
	loadstring(Info.Script)()
else
	ZØRKA.Current = "Universal"
	ZØRKA.Utilities.UI:Notification({
		Title = "ZØRKA Hub",
		Description = ZØRKA.Current .. " loaded!",
		Duration = 5
	})
	loadstring(ZØRKA.Debug and readfile("ZorkaHUB/Universal.lua") or game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/Universal.lua"))()
end
