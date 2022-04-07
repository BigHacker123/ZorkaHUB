local Config = {
    WindowName = "ZØRKA.XYZ",
	Color = Color3.fromRGB(255,128,64),
	Keybind = Enum.KeyCode.RightControl
}

function SwitchToKnife()
game:GetService("VirtualInputManager"):SendKeyEvent(true, 51, false, game)
game:GetService("VirtualInputManager"):SendKeyEvent(false, 51, false, game)	
end

function NoGui()
game.Players.LocalPlayer.PlayerGui.GUI.Enabled = true
game.Players.LocalPlayer.PlayerGui.GUI.TeamSelection.Visible = false
game.Players.LocalPlayer.PlayerGui.GUI.BottomFrame.Visible = false
game.Players.LocalPlayer.PlayerGui.GUI.Interface.Visible = true
end

local OldNameCall
OldNameCall = hookmetamethod(game, "__newindex", function(A, B, ...)
    if not checkcaller()  and (B == "WalkSpeed" or B == "JumpPower") then
        return
    end
    return OldNameCall(A, B, ...)
end)
function GetPart()
    if getgenv().AimPart == 'Head' then
        return 'Head'
    end
    if getgenv().AimPart == 'HumanoidRootPart' then
        return 'HumanoidRootPart'
    end
    if getgenv().AimPart == 'UpperTorso' then
        return 'UpperTorso'
    end
    if getgenv().AimPart == 'LowerTorso' then
        return 'LowerTorso'
    end
    if getgenv().AimPart == 'Random' then
        if math.random(1,4) == 1 then
            return 'Head'
        else
            return 'HumanoidRootPart'
        end
    end
end

game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 23 
game.Players.LocalPlayer.Character.Humanoid.JumpPower = 15




local function fuckyou()
local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end

function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end

-- If you'd like to use a script before server hopping (Like a Automatic Chest collector you can put the Teleport() after it collected everything.
Teleport()
end
function getUserRole(i, v)
    return i:GetRoleInGroup(v)
end
game.Players.PlayerAdded:Connect(function(v)
    if getUserRole(v, 2613928) == "Game Moderators" or getUserRole(v, 2613928) == "Interns" or getUserRole(v, 2613928) == "Contractors" or getUserRole(v, 2613928) == "Contributors" or getUserRole(v, 2613928) == "Beloved" or getUserRole(v, 2613928) == "Main Developers" or getUserRole(v, 2613928) == "Founder/Main Developer" then
      fuckyou() 
    end
end)

local Circle = Drawing.new("Circle")
Circle.Color =  Color3.fromRGB(22, 13, 56)
Circle.Thickness = 1
Circle.Radius = 250
Circle.Visible = false
Circle.NumSides = 1000
Circle.Filled = false
Circle.Transparency = 1

game:GetService("RunService").RenderStepped:Connect(function()
    local Mouse = game:GetService("UserInputService"):GetMouseLocation()
    Circle.Position = Vector2.new(Mouse.X, Mouse.Y)
end)

getgenv().AimBot = {
FreeForAll= false,
WallCheck = false,
Enabled = false,
FOV = 250,
}
local Shoot = false

function FreeForAll(v)
    if getgenv().AimBot.FreeForAll == false or getgenv().TriggerBot.FreeForAll == false then
        if game.Players.LocalPlayer.Team == v.Team then return false
        else return true end
    else return true end
end

function NotObstructing(i, v)
    if getgenv().AimBot.WallCheck then
        c = workspace.CurrentCamera.CFrame.p
        a = Ray.new(c, i- c)
        f = workspace:FindPartOnRayWithIgnoreList(a, v)
        return f == nil
    else
        return true
    end
end
game:GetService("UserInputService").InputBegan:Connect(function(v)
    if v.UserInputType == Enum.UserInputType.MouseButton2 then
        Shoot = true
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(v)
    if v.UserInputType == Enum.UserInputType.MouseButton2 then
        Shoot = false
    end
end)


function GetClosestToCuror()
    Closest = math.huge
    Target = nil
    for _,v in pairs(game:GetService("Players"):GetPlayers()) do
        if FreeForAll(v) then
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0  then
                Point,OnScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if OnScreen and NotObstructing(v.Character.HumanoidRootPart.Position,{game.Players.LocalPlayer.Character,v.Character}) then
                    Distance = (Vector2.new(Point.X,Point.Y) - Vector2.new(game.Players.LocalPlayer:GetMouse().X, game.Players.LocalPlayer:GetMouse().Y)).magnitude
                      if Distance <= getgenv().AimBot.FOV then
                          Closest = Distance
                       Target = v
                     end
                  end
               end
            end
         end
    return Target
end 

game:GetService('RunService').Stepped:connect(function()
pcall(function()
    if getgenv().AimBot.Enabled == false or Shoot == false then return end
    ClosestPlayer = GetClosestToCuror()
    if ClosestPlayer then
     workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p,ClosestPlayer.Character[getgenv().AimPart].CFrame.p)
    end 
end)
end)
getgenv().TriggerBot = {
   TeamCheck = false;
   Delay = 0.01;
   Enabled = false;
}

local Aim = false
game:GetService("UserInputService").InputBegan:connect(function(v)
   if v.UserInputType  == Enum.UserInputType.MouseButton2 and getgenv().TriggerBot.Enabled then
       Aim = true
       while Aim do wait()
           if game:GetService("Players").LocalPlayer:GetMouse().Target and game:GetService("Players"):FindFirstChild(game:GetService("Players").LocalPlayer:GetMouse().Target.Parent.Name) then
            local Person = game:GetService("Players"):FindFirstChild(game:GetService("Players").LocalPlayer:GetMouse().Target.Parent.Name)
               if Person.Team ~= game:GetService("Players").LocalPlayer.Team or not getgenv().TriggerBot.TeamCheck then
                   if getgenv().TriggerBot.Delay > 0 then wait(getgenv().TriggerBot.Delay) end
                   mouse1press(); wait(); mouse1release()
               end
           end
           if not getgenv().TriggerBot.Enabled then break end
       end
   end
end)

game:GetService("UserInputService").InputEnded:connect(function(v)
   if v.KeyCode == Enum.UserInputType.MouseButton2 and getgenv().TriggerBot.Enabled then
       Aim = false
   end
end)

--[[
function KillAll()
local getenemys=function()--simple get enemys function (with proper ffa detection)
    local a={}
    if not game.ReplicatedStorage.wkspc.Status.RoundOver.Value and not game.ReplicatedStorage.wkspc.Status.Preparation.Value and game.Players.LocalPlayer.Status.Team.Value~="Spectator"then--do nothing on round over aswell as when the client is in spectator
        for _,v in pairs(game.Players:GetChildren())do--get players
            if(v.Team~=game.Players.LocalPlayer.Team or game.ReplicatedStorage.wkspc.FFA.Value)and v~=game.Players.LocalPlayer then--ffa detection aswell as when its ffa it dosent target the client
                if v.Character and not v.Character:FindFirstChild("ShuckyHAX")and v.Character:FindFirstChild("Spawned")then--check if the player can be damage
                    table.insert(a,v)--insert the player into a table
                end
            end
        end
    end
    return a
end

    for _,v in pairs(getenemys())do
        local Partpos=v.Character.Head.Position+Vector3.new(math.random(),math.random(),math.random())--get head pos with random position to prevent ss detection(old kill all had it so i added it)
        local Packedstring=string.pack(
                        debug.getconstant(require(game:GetService("ReplicatedStorage").Modules.ClientFunctions).CreateProjectile,105),
                        Partpos.X,
                        Partpos.Y,
                        Partpos.Z,
                        tostring(game.Players.LocalPlayer.PlayerGui.GUI.Client.Variables.gun.Value),
                        0,--headshot=1 none=0
                        0,--unknown
                        0,--backstab=1 none=0
                        0,--forcecrit=1 none=0
                        0,--morecrit=1 none=0
                        0,--spoof=2 none=0
                        0,--unkown
                        0,--Player Distance
                        1,--Current Spell
                        0,--scope=1 noscope=0
                        0--aircrit=1 none=0
                    )
        game.ReplicatedStorage.Events.HitPart:FireServer(v.Character.Head,Packedstring)
    end 
end]]--
 
-- dont ask about the code above thats The3Bakers kill all it dosen't work anymore
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/1201for/V.G-Hub/main/test"))()
local Window = Library:CreateWindow(Config, game:GetService("CoreGui"))

local Tab1 = Window:CreateTab("Arsenal")
local Tab2 = Window:CreateTab("UI Settings")

local Section1 = Tab1:CreateSection("")
local Section2 = Tab1:CreateSection("")
local Section5 = Tab1:CreateSection("")
local Section3 = Tab2:CreateSection("Menu")
local Section4 = Tab2:CreateSection("Background")

local Toggle1 = Section1:CreateToggle("Aimbot", nil, function(State)
    getgenv().AimBot.Enabled = State
end)


local Dropdown1 = Section1:CreateDropdown("HitPart", {"HumanoidRootPart","Head","UpperTorso","LowerTorso","Random"}, function(String)
	getgenv().AimPart = String
end)
Dropdown1:AddToolTip("Select AimPart")
Dropdown1:SetOption("HumanoidRootPart")


local Toggle1 = Section1:CreateToggle("FreeForAll", nil, function(State)
    getgenv().AimBot.FreeForAll = State
    getgenv().TriggerBot.TeamCheck = State
end)

local Toggle1 = Section1:CreateToggle("TriggerBot", nil, function(State)
    getgenv().TriggerBot.Enabled = State
end)

local Toggle1 = Section1:CreateToggle("WallCheck", nil, function(State)
    getgenv().AimBot.WallCheck = State
end)

local Slider2 = Section1:CreateSlider("Aimbot Radius", 0,1000,nil,false, function(Value)
    getgenv().AimBot.FOV = Value
    Circle.Radius = Value
end)

local Toggle1 = Section1:CreateToggle("Circle Visible", nil, function(State)
   Circle.Visible = State
end)

local Colorpicker3 = Section1:CreateColorpicker("Circle Color", function(Color)
    Circle.Color = Color
end)


local Toggle1 = Section1:CreateToggle("SilentAim", nil, function(State)
getgenv().SilentAim = State
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
function ClosestPlayerToCurser()
    local MaxDistance, Closest = math.huge
    for i,v in pairs(Players.GetPlayers(Players)) do
        if v ~= LocalPlayer and v.Team ~= LocalPlayer.Team and v.Character then
            local H = v.Character.FindFirstChild(v.Character, "Head")
            if H then 
                local Pos, Vis = workspace.CurrentCamera.WorldToScreenPoint(workspace.CurrentCamera, H.Position)
                if Vis then
                    local A1, A2 = Vector2.new(Mouse.X, Mouse.Y), Vector2.new(Pos.X, Pos.Y)
                    local Dist = (A2 - A1).Magnitude
                    if Dist < MaxDistance and Dist <= 2500 then
                        MaxDistance = Dist
                        Closest = v
                    end
                end
            end
        end
    end
    return Closest
end
loadstring(game:HttpGet("https://raw.githubusercontent.com/1201for/V.G_Hub_Extras/main/RayCast_Method"))()
end)


local Toggle1 = Section1:CreateToggle("dosen't work", nil, function(State)
getgenv().WALLBANG = State
local OldNameCall
OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
    local Arguments = {...}
    if getnamecallmethod() == 'FindPartOnRayWithIgnoreList' and getgenv().WALLBANG then
        table.insert(Arguments[2], game.GetService(game, 'Workspace').Map)
        return OldNameCall(self, unpack(Arguments))
    end
    return OldNameCall(self,...)
end)
end)

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/1201for/V.G-Hub/main/Karrot-Esp"))()

local Toggle1 = Section1:CreateToggle("Player Esp", nil, function(State)
ESP:Toggle(State)
end)

local Toggle1 = Section1:CreateToggle("Tracers Esp", nil, function(State)
ESP.Tracers = State
end)

local Toggle1 = Section1:CreateToggle("Name Esp", nil, function(State)
ESP.Names = State
end)

local Toggle1 = Section1:CreateToggle("Boxes Esp", nil, function(State)
ESP.Boxes = State
end)


local Toggle1 = Section1:CreateToggle("BHop", nil, function(State)
BHop = State
while wait() and BHop do
    game.Players.LocalPlayer.Character.Humanoid.Jump = true
end
end)


local Toggle1 = Section1:CreateToggle("InstantRespawn", nil, function(State)
InstantRespawn = State
while InstantRespawn do wait()
        if
            not game.Players.LocalPlayer.Character:FindFirstChild("Spawned") and
                game:GetService("Players").LocalPlayer.Character:FindFirstChild("Cam")
         then
            if game.Players.LocalPlayer.PlayerGui.Menew.Enabled == false then
                game:GetService("ReplicatedStorage").Events.LoadCharacter:FireServer()
                wait(0.5)
            end
        end
    end
end)

local Toggle1 = Section1:CreateToggle("RainBow Gun", nil, function(State)
getgenv().RainBowGun = State
local x = 1
function maths(X)
    return math.acos(math.cos(X * math.pi)) / math.pi
end
game:GetService("RunService").RenderStepped:Connect(
    function()
        if getgenv().RainBowGun then
            if game.Workspace.Camera:FindFirstChild("Arms") then
                for i, v in pairs(game.Workspace.Camera.Arms:GetChildren()) do 
                    if v.ClassName == "MeshPart" then
                        v.Color = Color3.fromHSV(maths(x), 1, 1) -- changes Color
                        x = x + .0001
                    end
                end
            end
        end
    end
)
end)
local Toggle1 = Section1:CreateToggle("Auto Burn All", nil, function(State)
soso = State
while wait() and soso do
pcall(function()
for i,v in pairs(game.Players:GetPlayers()) do
    if v.Character and v.Character:FindFirstChild("Hitbox") and v ~= game.Players.LocalPlayer then wait(0.5)
        game.ReplicatedStorage.Events.Fire:FireServer(
            v.Character.HumanoidRootPart.CFrame.p
        )
    end
end
end)
end
end)

local Toggle1 = Section1:CreateToggle("Auto Heal", nil, function(State)
wow1 = State
while wow1 do
    wait()
    pcall(
        function()
            for i, v in pairs(game:GetService("Workspace").Debris:GetChildren()) do
                if v.Name == "DeadHP" then
                    v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                end
            end
        end
    )
end
end)

local Toggle1 = Section2:CreateToggle("Infinite Ammo", nil, function(State)
getgenv().Infinite = State
game:GetService("RunService").Stepped:connect(
    function()
        pcall(
            function()
                if getgenv().Infinite then
                    game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount.Value = 999
                    game:GetService("Players").LocalPlayer.PlayerGui.GUI.Client.Variables.ammocount2.Value = 999
                end
            end
        )
    end
)
end)

getgenv().Message = "ZØRKA.XYZ Winning"
local Toggle1 = Section1:CreateToggle("Spam Chat", nil, function(State)
chat = State
game:GetService("RunService").RenderStepped:Connect(
    function()
        if chat then
            local args = {
                [1] = "Trolling42",
                [2] = getgenv().Message,
                [3] = false,
                [4] = true,
                [5] = true
            }

            game:GetService("ReplicatedStorage").Events.PlayerChatted:FireServer(unpack(args))
        end
    end
)
end)

local Toggle1 = Section2:CreateToggle("Always Auto", nil, function(State)
getgenv().Automatic = State
for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
    if v.Name == "Auto" then
        if getgenv().Automatic then
            v.Value = true -- always auto
        else
            v.Value = false
        end
    end
end
end)

local Toggle1 = Section2:CreateToggle("FastFire Rate", nil, function(State)
getgenv().FireRate = State
for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
    if v.Name == "FireRate" then
        if getgenv().FireRate then
            v.Value = 0.02 -- Fast Firerate
        else
            v.Value = 0.8
        end
    end
end
end)

local Toggle1 = Section2:CreateToggle("NoRecoil/Spread", nil, function(State)
getgenv().Recoil = State
for i, v in pairs(game:GetService("ReplicatedStorage").Weapons:GetDescendants()) do
    if v.Name == "MaxSpread" or v.Name == "Spread" or v.Name == "RecoilControl" then
        if getgenv().Recoil then
            v.Value = 0 -- no spread or recoil
        else
            v.Value = 1
        end
    end
end
end)

local Toggle1 = Section1:CreateToggle("Anti Aim", nil, function(State)
yes = State
while wait(1) and yes do
        getsenv(game.Players.LocalPlayer.PlayerGui.GUI.Client).lastlook = 10000
        if game.Players.LocalPlayer.Character then
            --remove legs
            for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if string.find(string.lower(v.Name), "foot") or string.find(string.lower(v.Name), "leg") then
                    if v:IsA("BasePart") then
                        v:Destroy()
                    end
                end
            end

            if game.Players.LocalPlayer.Character:FindFirstChild("HeadHB") then
                game.Players.LocalPlayer.Character:FindFirstChild("HeadHB"):Destroy()
            end
            if game.Players.LocalPlayer.Character:FindFirstChild("FakeHead") then
                game.Players.LocalPlayer.Character:FindFirstChild("FakeHead"):Destroy()
            end
        end
end

local NewAnimation = Instance.new("Animation")
NewAnimation.AnimationId = "rbxassetid://0"

local OldNameCall = nil
OldNameCall =
    hookmetamethod(game,"__namecall",function(A, B, C, ...)
        local Args = {...}
        local Self = Args[1]
        if getnamecallmethod() == "FireServer" and tostring(A) == "ControlTurn" then
            B = math.rad(math.random(-360, 360))
            C = Vector3.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position) *
                CFrame.Angles(0, math.rad(math.random(-360, 360)), 0)
        elseif getnamecallmethod() == "LoadAnimation" and tostring(A) == "Humanoid" then
            B = NewAnimation
        end
        return OldNameCall(A, B, C, ...)
    end
)
local OldNameCall = nil
OldNameCall = hookmetamethod(game,"__namecall",function(A, B, C, ...)
        if tostring(A) == "Humanoid" and B == "AutoRotate" then
            return oldnewIndex(A, B, false)
        end
        return oldnewIndex(A, B, C, ...)
    end
)
end)

local Slider2 = Section2:CreateSlider("Hitbox Radius", 0,50,nil,false, function(Value)
head = Value
end)
local Togglefly = Section2:CreateToggle("HitBox", nil, function(State)
doodoo = State

while doodoo do
    wait(1)
     pcall(function()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v.Character then
            v.Character.LowerTorso.CanCollide = false
            v.Character.LowerTorso.Material = "Neon"
            v.Character.LowerTorso.Transparency = 0.5
            v.Character.LowerTorso.Size = Vector3.new(head, head, head)
            v.Character.HumanoidRootPart.Size = Vector3.new(head, head, head)
        end
    end
end)
end

end)


if syn then
local TextBox1 = Section2:CreateTextBox("Fps Cap", "Only numbers", true, function(Value)
    getgenv().Fps = Value
    pcall(function()
setfpscap(getgenv().Fps)
end)
end)
end


local TextBox1 = Section2:CreateTextBox("WalkSpeed", "Only numbers", true, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
end)

local TextBox1 = Section2:CreateTextBox("JumpPower", "Only numbers", true, function(Value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
end)

local Toggle1 = Section2:CreateToggle("Infinite Jump", nil, function(State)
Infinite = State
game:GetService("UserInputService").JumpRequest:connect(function()
	if Infinite then
		game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
	end
end) end)


local Toggle1 = Section2:CreateToggle("B Noclip", nil, function(State)
sex = State
noclip = false
game:GetService("RunService").Stepped:connect(
    function()
        if noclip then
            game.Players.LocalPlayer.Character:WaitForChild("Humanoid"):ChangeState(11)
        end
    end
)

game.Players.LocalPlayer:GetMouse().KeyDown:connect(function(v)
        if v == "b" then
            if sex then
                noclip = not noclip
                game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
            end
        end
    end
)
end)


local Toggle1 = Section2:CreateToggle("K Fly", nil, function(State)
sex2 = State
local Max = 0
local Players = game.Players
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
Mouse.KeyDown:connect(
    function(k)
        if k:lower() == "k" then
            Max = Max + 1
            getgenv().Fly = false
            if sex2 then
                local T = LP.Character.UpperTorso
                local S = {
                    F = 0,
                    B = 0,
                    L = 0,
                    R = 0
                }
                local S2 = {
                    F = 0,
                    B = 0,
                    L = 0,
                    R = 0
                }
                local SPEED = 5
                local function FLY()
                    getgenv().Fly = true
                    local BodyGyro = Instance.new("BodyGyro", T)
                    local BodyVelocity = Instance.new("BodyVelocity", T)
                    BodyGyro.P = 9e4
                    BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                    BodyGyro.cframe = T.CFrame
                    BodyVelocity.velocity = Vector3.new(0, 0.1, 0)
                    BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
                    spawn(
                        function()
                            repeat
                                wait()
                                LP.Character.Humanoid.PlatformStand = false
                                if S.L + S.R ~= 0 or S.F + S.B ~= 0 then
                                    SPEED = 200
                                elseif not (S.L + S.R ~= 0 or S.F + S.B ~= 0) and SPEED ~= 0 then
                                    SPEED = 0
                                end
                                if (S.L + S.R) ~= 0 or (S.F + S.B) ~= 0 then
                                    BodyVelocity.velocity =
                                        ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (S.F + S.B)) +
                                        ((game.Workspace.CurrentCamera.CoordinateFrame *
                                            CFrame.new(S.L + S.R, (S.F + S.B) * 0.2, 0).p) -
                                            game.Workspace.CurrentCamera.CoordinateFrame.p)) *
                                        SPEED
                                    S2 = {
                                        F = S.F,
                                        B = S.B,
                                        L = S.L,
                                        R = S.R
                                    }
                                elseif (S.L + S.R) == 0 and (S.F + S.B) == 0 and SPEED ~= 0 then
                                    BodyVelocity.velocity =
                                        ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (S2.F + S2.B)) +
                                        ((game.Workspace.CurrentCamera.CoordinateFrame *
                                            CFrame.new(S2.L + S2.R, (S2.F + S2.B) * 0.2, 0).p) -
                                            game.Workspace.CurrentCamera.CoordinateFrame.p)) *
                                        SPEED
                                else
                                    BodyVelocity.velocity = Vector3.new(0, 0.1, 0)
                                end
                                BodyGyro.cframe = game.Workspace.CurrentCamera.CoordinateFrame
                            until not getgenv().Fly
                            S = {
                                F = 0,
                                B = 0,
                                L = 0,
                                R = 0
                            }
                            S2 = {
                                F = 0,
                                B = 0,
                                L = 0,
                                R = 0
                            }
                            SPEED = 0
                            BodyGyro:destroy()
                            BodyVelocity:destroy()
                            LP.Character.Humanoid.PlatformStand = false
                        end
                    )
                end
                Mouse.KeyDown:connect(
                    function(k)
                        if k:lower() == "w" then
                            S.F = 1
                        elseif k:lower() == "s" then
                            S.B = -1
                        elseif k:lower() == "a" then
                            S.L = -1
                        elseif k:lower() == "d" then
                            S.R = 1
                        end
                    end
                )
                Mouse.KeyUp:connect(
                    function(k)
                        if k:lower() == "w" then
                            S.F = 0
                        elseif k:lower() == "s" then
                            S.B = 0
                        elseif k:lower() == "a" then
                            S.L = 0
                        elseif k:lower() == "d" then
                            S.R = 0
                        end
                    end
                )
                FLY()
                if Max == 2 then
                    getgenv().Fly = false
                    Max = 0
                end
            end
        end
    end
)

end)
Togglefly:AddToolTip("Enable then press K")
-------------

local Button1 = Section2:CreateButton("Lag Switch F3", function()
local X = false
local B = settings()

game.UserInputService.InputEnded:connect(
    function(v)
        if v.KeyCode == Enum.KeyCode.F3 then
            X = not X
            B.Network.IncomingReplicationLag = X and 10 or 0
        end
    end
)
end)
-------------
local Button1 = Section2:CreateButton("ServerHop", function()
fuckyou()
end)
-------------
local Button1 = Section2:CreateButton("Rejoin", function()
game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer) 
end)
local Toggle3 = Section3:CreateToggle("UI Toggle", nil, function(State)
	Window:Toggle(State)
end)
Toggle3:CreateKeybind(tostring(Config.Keybind):gsub("Enum.KeyCode.", ""), function(Key)
	Config.Keybind = Enum.KeyCode[Key]
end)
Toggle3:SetState(true)
Section3:CreateLabel("Credits ZoraX")
Section3:CreateLabel("Credits IceQbe")
Section3:CreateLabel("Credits LTW")
Section3:CreateLabel("Credits Zuhu")

local Colorpicker3 = Section3:CreateColorpicker("UI Color", function(Color)
	Window:ChangeColor(Color)
end)
Colorpicker3:UpdateColor(Config.Color)
-- credits to jan for patterns
local Dropdown3 = Section4:CreateDropdown("Image")
local Option7 = Dropdown3:AddOption("Default", function(String)
	Window:SetBackground("2151741365")
end)
local Option8 = Dropdown3:AddOption("Hearts", function(String)
	Window:SetBackground("6073763717")
end)
local Option9 = Dropdown3:AddOption("Abstract", function(String)
	Window:SetBackground("6073743871")
end)
local Option10 = Dropdown3:AddOption("Hexagon", function(String)
	Window:SetBackground("6073628839")
end)
local Option11 = Dropdown3:AddOption("Circles", function(String)
	Window:SetBackground("6071579801")
end)
local Option12 = Dropdown3:AddOption("Lace With Flowers", function(String)
	Window:SetBackground("6071575925")
end)
local Option13 = Dropdown3:AddOption("Floral", function(String)
	Window:SetBackground("5553946656")
end)
Option7:SetOption()

local Colorpicker4 = Section4:CreateColorpicker("Color", function(Color)
	Window:SetBackgroundColor(Color)
end)
Colorpicker4:UpdateColor(Color3.new(1,1,1))

local Slider3 = Section4:CreateSlider("Transparency",0,1,nil,false, function(Value)
	Window:SetBackgroundTransparency(Value)
end)
Slider3:SetValue(0)

local Slider4 = Section4:CreateSlider("Tile Scale",0,1,nil,false, function(Value)
	Window:SetTileScale(Value)
end)
Slider4:SetValue(0.5)


-- if you see this your gay :b
