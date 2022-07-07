repeat task.wait() until game.GameId ~= 0
if ZORKA and ZORKA.Loaded then
	ZORKA.Utilities.UI:Notification({
		Title = "ZORKA Hub",
		Description = "Script already executed!",
		Duration = 5
	})
	return
end

getgenv().ZORKA = {
	Loaded = true,
	Debug = false,
	Current = "Loader",
	Utilities = {},
	Config = {}
}

ZORKA.Utilities.UI = ZORKA.Debug and loadfile("ZorkaHUB/Utilities/UI.lua")() or loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/Utilities/UI.lua"))()
ZORKA.Utilities.Config = ZORKA.Debug and loadfile("ZorkaHUB/Utilities/Config.lua")() or loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/Utilities/Config.lua"))()
ZORKA.Utilities.Drawing = ZORKA.Debug and loadfile("ZorkaHUB/Utilities/Drawing.lua")() or loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/Utilities/Drawing.lua"))()
ZORKA.Utilities.ThreadLoop = function(Wait,Function)
	coroutine.wrap(function()
		while task.wait(Wait) do
			Function()
		end
	end)()
end

ZORKA.Games = {
	["1054526971"] = {
		Name = "Blackhawk Rescue Mission 5",
		Script = ZORKA.Debug and readfile("ZorkaHUB/BRM5/ClientBRM5.lua") or game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/BRM5/ClientBRM5.lua")
	},
	["115797356"] = {
		Name = "Counter Blox",
		Script = ZORKA.Debug and readfile("ZorkaHUB/CounterBlox/ClientCB.lua") or game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/CounterBlox/ClientCB.lua")
	},
	["111958650"] = {
		Name = "Arsenal ~ alpha test",
		Script = ZORKA.Debug and readfile("ZorkaHUB/Arsenal/ArsenalAlpha.lua") or game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/Arsenal/ArsenalAlpha")
	},
	["1359573625"] = {
		Name = "Deep Woken",
		Script = ZORKA.Debug and readfile("ZorkaHUB/DeepWoken/ClientDW.lua") or game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/DeepWoken/ClientDW.lua")
	},
	["113491250"] = {
		Name = "Phantom Forces",
		Script = ZORKA.Debug and readfile("ZorkaHUB/Phantom/PHalpha.lua") or game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/Phantom/PHalpha.lua")
	},
	["2404080894"] = {
		Name = "FunkyFriday",
		Script = ZORKA.Debug and readfile("ZorkaHUB/Funky-Friday/ClientFF.lua") or game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/Funky-Friday/ClientFF.lua")
	},
	["2619619496"] = {
		Name = "Vape V4 ~ BedWars",
		Script = ZORKA.Debug and readfile("VapeV4ForRoblox/NewMainScript.lua") or game:HttpGetAsync("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua")
	},
	["2162282815"] = {
		Name = "Afo ~ Rush Point",
		Script = ZORKA.Debug and readfile("script/rush_point.lua") or game:HttpGetAsync("https://hub.afo.xyz/script/rush_point.lua")
	}
}

local PlayerService = game:GetService("Players")
local LocalPlayer = PlayerService.LocalPlayer
local function getGameInfo()
	for Id,Info in pairs(ZORKA.Games) do
		if tostring(game.GameId) == Id then
			return Info
		end
	end
end

LocalPlayer.OnTeleport:Connect(function(State)
	if State == Enum.TeleportState.Started then
		getgenv().ZORKA.Loaded = false
		local QueueOnTeleport = (syn and syn.queue_on_teleport) or queue_on_teleport
		QueueOnTeleport(ZORKA.Debug and readfile("ZorkaHUB/Loader.lua") or game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/Loader.lua"))
	end
end)

local Info = getGameInfo()
if Info then
	ZORKA.Current = Info.Name
	ZORKA.Utilities.UI:Notification({
		Title = "ZORKA Hub",
		Description = ZORKA.Current .. " loaded!",
		Duration = 5
	})
	loadstring(Info.Script)()
else
	ZORKA.Current = "Universal"
	ZORKA.Utilities.UI:Notification({
		Title = "ZORKA Hub",
		Description = ZORKA.Current .. " loaded!",
		Duration = 5
	})
	loadstring(ZORKA.Debug and readfile("ZorkaHUB/Universal.lua") or game:HttpGetAsync("https://raw.githubusercontent.com/ZuhuInc/ZorkaHUB/main/Universal.lua"))()
end
