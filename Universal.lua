local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local PlayerService = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")

local LocalPlayer = PlayerService.LocalPlayer
local Aimbot, SilentAim = false, nil

ZORKA.Config = ZORKA.Utilities.Config:ReadJSON(ZORKA.Current, {
    PlayerESP = {
        AllyColor = {0.3333333432674408,1,1,0,false},
        EnemyColor = {1,1,1,0,false},

        TeamColor = false,
        TeamCheck = false,
        Highlight = {
            Enabled = false,
            Transparency = 0.5,
            OutlineColor = {0,0,0,0.5,false}
        },
        Box = {
            Enabled = false,
            Outline = true,
            Filled = false,
            Thickness = 1,
            Transparency = 1,
            Info = {
                Enabled = false,
                AutoScale = true,
                Transparency = 1,
                Size = 16
            }
        },
        Other = {
            Head = {
                Enabled = false,
                AutoScale = true,
                Filled = true,
                Radius = 8,
                NumSides = 4,
                Thickness = 1,
                Transparency = 1
            },
            Tracer = {
                Enabled = false,
                Thickness = 1,
                Transparency = 1,
                From = "ScreenBottom"
            },
            Arrow = {
                Enabled = false,
                Filled = true,
                Width = 16,
                Height = 16,
                Thickness = 1,
                Transparency = 1,
                DistanceFromCenter = 80
            }
        }
    },
    AimAssist = {
        TeamCheck = false,
        SilentAim = {
            Enabled = false,
            WallCheck = false,
            HitChance = 100,
            FieldOfView = 50,
            Priority = {"Head"},
            Circle = {
                Visible = true,
                Transparency = 0.5,
                Color = {0.6666666865348816,1,1,0.5,false},
                Thickness = 1,
                NumSides = 100,
                Filled = false
            }
        },
        Aimbot = {
            Enabled = false,
            WallCheck = false,
            Sensitivity = 0.25,
            FieldOfView = 100,
            Priority = {"Head","HumanoidRootPart"},
            Prediction = {
                Enabled = false,
                Velocity = 1,
            },
            Circle = {
                Visible = true,
                Transparency = 0.5,
                Color = {1,1,1,0.5,false},
                Thickness = 1,
                NumSides = 100,
                Filled = false
            }
        }
    },
    UI = {
        Enabled = true,
        Keybind = "RightShift",
        Color = {0.8333333134651184,0.5,0.5,0,false},
        TileSize = 74,
        Watermark = true,
        Background = "Floral",
        BackgroundId = "rbxassetid://5553946656",
        BackgroundColor = {1,0,0,0,false},
        BackgroundTransparency = 0,
        Cursor = {
            Enabled = false,
            Length = 16,
            Width = 11,

            Crosshair = {
                Enabled = false,
                Color = {1,1,1,0,false},
                Size = 4,
                Gap = 2,
            }
        }
    },
    Binds = {
        Aimbot = "MouseButton2",
        SilentAim = "NONE"
    }
})

ZORKA.Utilities.Drawing:Cursor(ZORKA.Config.UI.Cursor)
ZORKA.Utilities.Drawing:FoVCircle(ZORKA.Config.AimAssist.Aimbot)
ZORKA.Utilities.Drawing:FoVCircle(ZORKA.Config.AimAssist.SilentAim)
local Window = ZORKA.Utilities.UI:Window({Name = "ZØRKA Hub — " .. ZORKA.Current,Enabled = ZORKA.Config.UI.Enabled,
Color = ZORKA.Utilities.Config:TableToColor(ZORKA.Config.UI.Color),Position = UDim2.new(0.2,-248,0.5,-248)}) do
    local AimAssistTab = Window:Tab({Name = "Combat"}) do
        local AimbotSection = AimAssistTab:Section({Name = "Aimbot",Side = "Left"}) do
            AimbotSection:Toggle({Name = "Enabled",Value = ZORKA.Config.AimAssist.Aimbot.Enabled,Callback = function(Bool)
                ZORKA.Config.AimAssist.Aimbot.Enabled = Bool
            end})
            AimbotSection:Toggle({Name = "Visibility Check",Value = ZORKA.Config.AimAssist.Aimbot.WallCheck,Callback = function(Bool)
                ZORKA.Config.AimAssist.Aimbot.WallCheck = Bool
            end})
            AimbotSection:Keybind({Name = "Keybind",Key = ZORKA.Config.Binds.Aimbot,Mouse = true,Callback = function(Bool,Key)
                ZORKA.Config.Binds.Aimbot = Key or "NONE"
                Aimbot = ZORKA.Config.AimAssist.Aimbot.Enabled and Bool
            end})
            AimbotSection:Slider({Name = "Smoothness",Min = 0,Max = 100,Value = ZORKA.Config.AimAssist.Aimbot.Sensitivity * 100,Unit = "%",Callback = function(Number)
                ZORKA.Config.AimAssist.Aimbot.Sensitivity = Number / 100
            end})
            AimbotSection:Slider({Name = "Field of View",Min = 0,Max = 500,Value = ZORKA.Config.AimAssist.Aimbot.FieldOfView,Callback = function(Number)
                ZORKA.Config.AimAssist.Aimbot.FieldOfView = Number
            end})
            AimbotSection:Dropdown({Name = "Priority",Default = ZORKA.Config.AimAssist.Aimbot.Priority,List = {
                {Name = "Head",Mode = "Toggle",Callback = function(Selected)
                    ZORKA.Config.AimAssist.Aimbot.Priority = Selected
                end},
                {Name = "HumanoidRootPart",Mode = "Toggle",Callback = function(Selected)
                    ZORKA.Config.AimAssist.Aimbot.Priority = Selected
                end}
            }})
        end
        local AFoVSection = AimAssistTab:Section({Name = "Aimbot FoV Circle",Side = "Left"}) do
            AFoVSection:Toggle({Name = "Enabled",Value = ZORKA.Config.AimAssist.Aimbot.Circle.Visible,Callback = function(Bool)
                ZORKA.Config.AimAssist.Aimbot.Circle.Visible = Bool
            end})
            AFoVSection:Toggle({Name = "Filled",Value = ZORKA.Config.AimAssist.Aimbot.Circle.Filled,Callback = function(Bool)
                ZORKA.Config.AimAssist.Aimbot.Circle.Filled = Bool
            end})
            AFoVSection:Colorpicker({Name = "Color",HSVAR = ZORKA.Config.AimAssist.Aimbot.Circle.Color,Callback = function(HSVAR)
                ZORKA.Config.AimAssist.Aimbot.Circle.Color = HSVAR
            end})
            AFoVSection:Slider({Name = "NumSides",Min = 3,Max = 100,Value = ZORKA.Config.AimAssist.Aimbot.Circle.NumSides,Callback = function(Number)
                ZORKA.Config.AimAssist.Aimbot.Circle.NumSides = Number
            end})
            AFoVSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = ZORKA.Config.AimAssist.Aimbot.Circle.Thickness,Callback = function(Number)
                ZORKA.Config.AimAssist.Aimbot.Circle.Thickness = Number
            end})
        end
        local SilentAimSection = AimAssistTab:Section({Name = "Silent Aim(broken)",Side = "Right"}) do
            SilentAimSection:Toggle({Name = "Enabled",Value = ZORKA.Config.AimAssist.SilentAim.Enabled,Callback = function(Bool)
                ZORKA.Config.AimAssist.SilentAim.Enabled = Bool
            end}):Keybind({Key = ZORKA.Config.Binds.SilentAim,Mouse = true,Callback = function(Bool,Key)
                ZORKA.Config.Binds.SilentAim = Key or "NONE"
            end})
            SilentAimSection:Toggle({Name = "Visibility Check",Value = ZORKA.Config.AimAssist.SilentAim.WallCheck,Callback = function(Bool)
                ZORKA.Config.AimAssist.SilentAim.WallCheck = Bool
            end})
            SilentAimSection:Slider({Name = "Hit Chance",Min = 0,Max = 100,Value = ZORKA.Config.AimAssist.SilentAim.HitChance,Unit = "%",Callback = function(Number)
                ZORKA.Config.AimAssist.SilentAim.HitChance = Number
            end})
            SilentAimSection:Slider({Name = "Field of View",Min = 0,Max = 500,Value = ZORKA.Config.AimAssist.SilentAim.FieldOfView,Callback = function(Number)
                ZORKA.Config.AimAssist.SilentAim.FieldOfView = Number
            end})
            SilentAimSection:Dropdown({Name = "Priority",Default = ZORKA.Config.AimAssist.SilentAim.Priority,List = {
                {Name = "Head",Mode = "Toggle",Callback = function(Selected)
                    ZORKA.Config.AimAssist.SilentAim.Priority = Selected
                end},
                {Name = "HumanoidRootPart",Mode = "Toggle",Callback = function(Selected)
                    ZORKA.Config.AimAssist.SilentAim.Priority = Selected
                end}
            }})
        end
        local SAFoVSection = AimAssistTab:Section({Name = "Silent Aim FoV Circle",Side = "Right"}) do
            SAFoVSection:Toggle({Name = "Enabled",Value = ZORKA.Config.AimAssist.SilentAim.Circle.Visible,Callback = function(Bool)
                ZORKA.Config.AimAssist.SilentAim.Circle.Visible = Bool
            end})
            SAFoVSection:Toggle({Name = "Filled",Value = ZORKA.Config.AimAssist.SilentAim.Circle.Filled,Callback = function(Bool)
                ZORKA.Config.AimAssist.SilentAim.Circle.Filled = Bool
            end})
            SAFoVSection:Colorpicker({Name = "Color",HSVAR = ZORKA.Config.AimAssist.SilentAim.Circle.Color,Callback = function(HSVAR)
                ZORKA.Config.AimAssist.SilentAim.Circle.Color = HSVAR
            end})
            SAFoVSection:Slider({Name = "NumSides",Min = 3,Max = 100,Value = ZORKA.Config.AimAssist.SilentAim.Circle.NumSides,Callback = function(Number)
                ZORKA.Config.AimAssist.SilentAim.Circle.NumSides = Number
            end})
            SAFoVSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = ZORKA.Config.AimAssist.SilentAim.Circle.Thickness,Callback = function(Number)
                ZORKA.Config.AimAssist.SilentAim.Circle.Thickness = Number
            end})
        end
        local MiscSection = AimAssistTab:Section({Name = "Misc",Side = "Right"}) do
            MiscSection:Toggle({Name = "Team Check",Side = "Left",Value = ZORKA.Config.AimAssist.TeamCheck,Callback = function(Bool)
                ZORKA.Config.AimAssist.TeamCheck = Bool
            end}):ToolTip("Affects Aimbot and Silent Aim")
            MiscSection:Toggle({Name = "Prediction",Value = ZORKA.Config.AimAssist.Aimbot.Prediction.Enabled,Callback = function(Bool)
                ZORKA.Config.AimAssist.Aimbot.Prediction.Enabled = Bool
            end}):ToolTip("Affects Only Aimbot")
            MiscSection:Slider({Name = "Velocity",Min = 1,Max = 20,Value = ZORKA.Config.AimAssist.Aimbot.Prediction.Velocity,Callback = function(Number)
                ZORKA.Config.AimAssist.Aimbot.Prediction.Velocity = Number
            end}):ToolTip("Prediction Velocity")
        end
    end
    local VisualsTab = Window:Tab({Name = "Visuals"}) do
        local GlobalSection = VisualsTab:Section({Name = "Global",Side = "Left"}) do
            GlobalSection:Colorpicker({Name = "Ally Color",HSVAR = ZORKA.Config.PlayerESP.AllyColor,Callback = function(HSVAR)
                ZORKA.Config.PlayerESP.AllyColor = HSVAR
            end})
            GlobalSection:Colorpicker({Name = "Enemy Color",HSVAR = ZORKA.Config.PlayerESP.EnemyColor,Callback = function(HSVAR)
                ZORKA.Config.PlayerESP.EnemyColor = HSVAR
            end})
            GlobalSection:Toggle({Name = "Team Check",Value = ZORKA.Config.PlayerESP.TeamCheck,Callback = function(Bool)
                ZORKA.Config.PlayerESP.TeamCheck = Bool
            end})
            GlobalSection:Toggle({Name = "Use Team Color",Value = ZORKA.Config.PlayerESP.TeamColor,Callback = function(Bool)
                ZORKA.Config.PlayerESP.TeamColor = Bool
            end})
        end
        local BoxSection = VisualsTab:Section({Name = "Boxes",Side = "Left"}) do
            BoxSection:Toggle({Name = "Enabled",Value = ZORKA.Config.PlayerESP.Box.Enabled,Callback = function(Bool)
                ZORKA.Config.PlayerESP.Box.Enabled = Bool
            end})
            BoxSection:Toggle({Name = "Filled",Value = ZORKA.Config.PlayerESP.Box.Filled,Callback = function(Bool)
                ZORKA.Config.PlayerESP.Box.Filled = Bool
            end})
            BoxSection:Toggle({Name = "Outline",Value = ZORKA.Config.PlayerESP.Box.Outline,Callback = function(Bool)
                ZORKA.Config.PlayerESP.Box.Outline = Bool
            end})
            BoxSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = ZORKA.Config.PlayerESP.Box.Thickness,Callback = function(Number)
                ZORKA.Config.PlayerESP.Box.Thickness = Number
            end})
            BoxSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = ZORKA.Config.PlayerESP.Box.Transparency,Callback = function(Number)
                ZORKA.Config.PlayerESP.Box.Transparency = Number
            end})
            BoxSection:Divider({Text = "Text / Info"})
            BoxSection:Toggle({Name = "Enabled",Value = ZORKA.Config.PlayerESP.Box.Info.Enabled,Callback = function(Bool)
                ZORKA.Config.PlayerESP.Box.Info.Enabled = Bool
            end})
            BoxSection:Toggle({Name = "Autoscale",Value = ZORKA.Config.PlayerESP.Box.Info.AutoScale,Callback = function(Bool)
                ZORKA.Config.PlayerESP.Box.Info.AutoScale = Bool
            end})
            BoxSection:Slider({Name = "Size",Min = 14,Max = 28,Value = ZORKA.Config.PlayerESP.Box.Info.Size,Callback = function(Number)
                ZORKA.Config.PlayerESP.Box.Info.Size = Number
            end})
            BoxSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = ZORKA.Config.PlayerESP.Box.Info.Transparency,Callback = function(Number)
                ZORKA.Config.PlayerESP.Box.Info.Transparency = Number
            end})
        end
        local OoVSection = VisualsTab:Section({Name = "Offscreen Arrows",Side = "Left"}) do
            OoVSection:Toggle({Name = "Enabled",Value = ZORKA.Config.PlayerESP.Other.Arrow.Enabled,Callback = function(Bool)
                ZORKA.Config.PlayerESP.Other.Arrow.Enabled = Bool
            end})
            OoVSection:Toggle({Name = "Filled",Value = ZORKA.Config.PlayerESP.Other.Arrow.Filled,Callback = function(Bool)
                ZORKA.Config.PlayerESP.Other.Arrow.Filled = Bool
            end})
            OoVSection:Slider({Name = "Height",Min = 14,Max = 28,Value = ZORKA.Config.PlayerESP.Other.Arrow.Height,Callback = function(Number)
                ZORKA.Config.PlayerESP.Other.Arrow.Height = Number
            end})
            OoVSection:Slider({Name = "Width",Min = 14,Max = 28,Value = ZORKA.Config.PlayerESP.Other.Arrow.Width,Callback = function(Number)
                ZORKA.Config.PlayerESP.Other.Arrow.Width = Number
            end})
            OoVSection:Slider({Name = "Distance From Center",Min = 80,Max = 200,Value = ZORKA.Config.PlayerESP.Other.Arrow.DistanceFromCenter,Callback = function(Number)
                ZORKA.Config.PlayerESP.Other.Arrow.DistanceFromCenter = Number
            end})
            OoVSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = ZORKA.Config.PlayerESP.Other.Arrow.Thickness,Callback = function(Number)
                ZORKA.Config.PlayerESP.Other.Arrow.Thickness = Number
            end})
            OoVSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = ZORKA.Config.PlayerESP.Other.Arrow.Transparency,Callback = function(Number)
                ZORKA.Config.PlayerESP.Other.Arrow.Transparency = Number
            end})
        end
        local HeadSection = VisualsTab:Section({Name = "Head Circles",Side = "Right"}) do
            HeadSection:Toggle({Name = "Enabled",Value = ZORKA.Config.PlayerESP.Other.Head.Enabled,Callback = function(Bool)
                ZORKA.Config.PlayerESP.Other.Head.Enabled = Bool
            end})
            HeadSection:Toggle({Name = "Filled",Value = ZORKA.Config.PlayerESP.Other.Head.Filled,Callback = function(Bool)
                ZORKA.Config.PlayerESP.Other.Head.Filled = Bool
            end})
            HeadSection:Toggle({Name = "Autoscale",Value = ZORKA.Config.PlayerESP.Other.Head.AutoScale,Callback = function(Bool)
                ZORKA.Config.PlayerESP.Other.Head.AutoScale = Bool
            end})
            HeadSection:Slider({Name = "Radius",Min = 1,Max = 10,Value = ZORKA.Config.PlayerESP.Other.Head.Radius,Callback = function(Number)
                ZORKA.Config.PlayerESP.Other.Head.Radius = Number
            end})
            HeadSection:Slider({Name = "NumSides",Min = 3,Max = 100,Value = ZORKA.Config.PlayerESP.Other.Head.NumSides,Callback = function(Number)
                ZORKA.Config.PlayerESP.Other.Head.NumSides = Number
            end})
            HeadSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = ZORKA.Config.PlayerESP.Other.Head.Thickness,Callback = function(Number)
                ZORKA.Config.PlayerESP.Other.Head.Thickness = Number
            end})
            HeadSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = ZORKA.Config.PlayerESP.Other.Head.Transparency,Callback = function(Number)
                ZORKA.Config.PlayerESP.Other.Head.Transparency = Number
            end})
        end
        local TracerSection = VisualsTab:Section({Name = "Tracers",Side = "Right"}) do
            TracerSection:Toggle({Name = "Enabled",Value = ZORKA.Config.PlayerESP.Other.Tracer.Enabled,Callback = function(Bool)
                ZORKA.Config.PlayerESP.Other.Tracer.Enabled = Bool
            end})
            TracerSection:Dropdown({Name = "Mode",Default = {
                ZORKA.Config.PlayerESP.Other.Tracer.From == "ScreenBottom" and "From Bottom" or "From Mouse"
            },List = {
                {Name = "From Bottom",Mode = "Button",Callback = function()
                    ZORKA.Config.PlayerESP.Other.Tracer.From = "ScreenBottom"
                end},
                {Name = "From Mouse",Mode = "Button",Callback = function()
                    ZORKA.Config.PlayerESP.Other.Tracer.From = "Mouse"
                end}
            }})
            TracerSection:Slider({Name = "Thickness",Min = 1,Max = 10,Value = ZORKA.Config.PlayerESP.Other.Tracer.Thickness,Callback = function(Number)
                ZORKA.Config.PlayerESP.Other.Tracer.Thickness = Number
            end})
            TracerSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = ZORKA.Config.PlayerESP.Other.Tracer.Transparency,Callback = function(Number)
                ZORKA.Config.PlayerESP.Other.Tracer.Transparency = Number
            end})
        end
        local HighlightSection = VisualsTab:Section({Name = "Highlights",Side = "Right"}) do
            HighlightSection:Toggle({Name = "Enabled",Value = ZORKA.Config.PlayerESP.Highlight.Enabled,Callback = function(Bool)
                ZORKA.Config.PlayerESP.Highlight.Enabled = Bool
            end})
            HighlightSection:Slider({Name = "Transparency",Min = 0,Max = 1,Precise = 2,Value = ZORKA.Config.PlayerESP.Highlight.Transparency,Callback = function(Number)
                ZORKA.Config.PlayerESP.Highlight.Transparency = Number
            end})
            HighlightSection:Colorpicker({Name = "Outline Color",HSVAR = ZORKA.Config.PlayerESP.Highlight.OutlineColor,Callback = function(HSVAR)
                ZORKA.Config.PlayerESP.Highlight.OutlineColor = HSVAR
            end})
        end
    end
    local SettingsTab = Window:Tab({Name = "Settings"}) do
        local MenuSection = SettingsTab:Section({Name = "Menu",Side = "Left"}) do
            MenuSection:Toggle({Name = "Enabled",Value = Window.Enabled,Callback = function(Bool) 
                Window:Toggle(Bool)
            end}):Keybind({Key = ZORKA.Config.UI.Keybind,Callback = function(Bool,Key)
                ZORKA.Config.UI.Keybind = Key or "NONE"
            end})
            MenuSection:Toggle({Name = "Watermark",Value = ZORKA.Config.UI.Watermark,Callback = function(Bool) 
                ZORKA.Config.UI.Watermark = Bool
                if not ZORKA.Config.UI.Watermark then
                    ZORKA.Utilities.UI:Watermark()
                end
            end})
            MenuSection:Toggle({Name = "Close On Exec",Value = not ZORKA.Config.UI.Enabled,Callback = function(Bool) 
                ZORKA.Config.UI.Enabled = not Bool
            end})
            MenuSection:Toggle({Name = "Custom Mouse",Value = ZORKA.Config.UI.Cursor.Enabled,Callback = function(Bool) 
                ZORKA.Config.UI.Cursor.Enabled = Bool
            end})
            MenuSection:Colorpicker({Name = "Color",HSVAR = ZORKA.Config.UI.Color,Callback = function(HSVAR,Color)
                ZORKA.Config.UI.Color = HSVAR
                Window:SetColor(Color)
            end})
        end
        local CrosshairSection = SettingsTab:Section({Name = "Custom Crosshair",Side = "Left"}) do
            CrosshairSection:Toggle({Name = "Enabled",Value = ZORKA.Config.UI.Cursor.Crosshair.Enabled,Callback = function(Bool) 
                ZORKA.Config.UI.Cursor.Crosshair.Enabled = Bool
            end})
            CrosshairSection:Colorpicker({Name = "Color",HSVAR = ZORKA.Config.UI.Cursor.Crosshair.Color,Callback = function(HSVAR)
                ZORKA.Config.UI.Cursor.Crosshair.Color = HSVAR
            end})
            CrosshairSection:Slider({Name = "Size",Min = 0,Max = 100,Value = ZORKA.Config.UI.Cursor.Crosshair.Size,Callback = function(Number)
                ZORKA.Config.UI.Cursor.Crosshair.Size = Number
            end})
            CrosshairSection:Slider({Name = "Gap",Min = 0,Max = 100,Value = ZORKA.Config.UI.Cursor.Crosshair.Gap,Callback = function(Number)
                ZORKA.Config.UI.Cursor.Crosshair.Gap = Number
            end})
        end
        SettingsTab:Button({Name = "Rejoin",Side = "Left",Callback = function()
            if #PlayerService:GetPlayers() <= 1 then
                LocalPlayer:Kick("\nRejoining...")
                task.wait()
                game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
            else
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end
        end})
        SettingsTab:Button({Name = "Server Hop",Side = "Left",Callback = function()
            local Servers = {}
            local Request = game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
            local DataDecoded = HttpService:JSONDecode(Request).data
            for Index,ServerData in ipairs(DataDecoded) do
                if type(ServerData) == "table" and ServerData.id ~= game.JobId then
                    table.insert(Servers,ServerData.id)
                end
            end
            if #Servers > 0 then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Servers[math.random(1, #Servers)])
            else
                ZORKA.Utilities.UI:Notification({
                    Title = "ZORKA Hub",
                    Description = "Couldn't find a server",
                    Duration = 5
                })
            end
        end})
        SettingsTab:Button({Name = "Join Discord Server",Side = "Left",Callback = function()
            local Request = (syn and syn.request) or request
            Request({
                ["Url"] = "http://localhost:6463/rpc?v=1",
                ["Method"] = "POST",
                ["Headers"] = {
                    ["Content-Type"] = "application/json",
                    ["Origin"] = "https://discord.com"
                },
                ["Body"] = HttpService:JSONEncode({
                    ["cmd"] = "INVITE_BROWSER",
                    ["nonce"] = string.lower(HttpService:GenerateGUID(false)),
                    ["args"] = {
                        ["code"] = "YVaaSQbrgg"
                    }
                })
            })
        end}):ToolTip("Join for support, updates and more!")
        local BackgroundSection = SettingsTab:Section({Name = "Background",Side = "Right"}) do
            BackgroundSection:Dropdown({Name = "Image",Default = {ZORKA.Config.UI.Background},List = {
                {Name = "Legacy",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://2151741365"
                    ZORKA.Config.UI.BackgroundId = "rbxassetid://2151741365"
                end},
                {Name = "Hearts",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6073763717"
                    ZORKA.Config.UI.BackgroundId = "rbxassetid://6073763717"
                end},
                {Name = "Abstract",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6073743871"
                    ZORKA.Config.UI.BackgroundId = "rbxassetid://6073743871"
                end},
                {Name = "Hexagon",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6073628839"
                    ZORKA.Config.UI.BackgroundId = "rbxassetid://6073628839"
                end},
                {Name = "Circles",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6071579801"
                    ZORKA.Config.UI.BackgroundId = "rbxassetid://6071579801"
                end},
                {Name = "Lace With Flowers",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://6071575925"
                    ZORKA.Config.UI.BackgroundId = "rbxassetid://6071575925"
                end},
                {Name = "Floral",Mode = "Button",Callback = function()
                    Window.Background.Image = "rbxassetid://5553946656"
                    ZORKA.Config.UI.BackgroundId = "rbxassetid://5553946656"
                end}
            }})
            Window.Background.Image = ZORKA.Config.UI.BackgroundId
            Window.Background.ImageTransparency = ZORKA.Config.UI.BackgroundColor[4]
            Window.Background.TileSize = UDim2.new(0,ZORKA.Config.UI.TileSize,0,ZORKA.Config.UI.TileSize)
            Window.Background.ImageColor3 = ZORKA.Utilities.Config:TableToColor(ZORKA.Config.UI.BackgroundColor)
            BackgroundSection:Textbox({Name = "Custom Image",Text = "",Placeholder = "ImageId",Callback = function(String)
                Window.Background.Image = "rbxassetid://" .. String
                ZORKA.Config.UI.BackgroundId = "rbxassetid://" .. String
            end})
            BackgroundSection:Colorpicker({Name = "Color",HSVAR = ZORKA.Config.UI.BackgroundColor,Callback = function(HSVAR,Color)
                ZORKA.Config.UI.BackgroundColor = HSVAR
                Window.Background.ImageColor3 = Color
                Window.Background.ImageTransparency = HSVAR[4]
            end})
            BackgroundSection:Slider({Name = "Tile Offset",Min = 74, Max = 296,Value = Window.Background.TileSize.X.Offset,Callback = function(Number)
                ZORKA.Config.UI.TileSize = Number
                Window.Background.TileSize = UDim2.new(0,Number,0,Number)
            end})
        end
        local CreditsSection = SettingsTab:Section({Name = "Credits",Side = "Right"}) do
            CreditsSection:Label({Text = "This script was made by ZuhuInc."})
            CreditsSection:Divider()
            CreditsSection:Label({Text = "Special Thanks To Zorax"})
            CreditsSection:Label({Text = "Special Thanks To LTW."})
            CreditsSection:Label({Text = "Special Thanks To IceQbe."})
            CreditsSection:Divider()
            CreditsSection:Label({Text = "ZØRKA ~ ゾルカ"})
            CreditsSection:Label({Text = "❤️ ❤️ ❤️ ❤️"})
        end
    end
end

local LastIteration
local FrameUpdate = {}
local Start = os.clock()
local function GetFPS()
	LastIteration = os.clock()
	for Index = #FrameUpdate, 1, -1 do
		FrameUpdate[Index + 1] = FrameUpdate[Index] >= LastIteration - 1 and FrameUpdate[Index] or nil
	end
	FrameUpdate[1] = LastIteration
	return os.clock() - Start >= 1 and #FrameUpdate or #FrameUpdate / (os.clock() - Start)
end

local function TeamCheck(Target)
    if ZORKA.Config.AimAssist.TeamCheck then
        return LocalPlayer.Team ~= Target.Team
    end
    return true
end

local function WallCheck(Enabled,Hitbox,Character)
	if not Enabled then return true end
	local Camera = Workspace.CurrentCamera
	return not Camera:GetPartsObscuringTarget({Hitbox.Position},{
        LocalPlayer.Character,
        Character
    })[1]
end

local function GetTarget(Config)
    if not Config.Enabled then return end
	local Camera = Workspace.CurrentCamera
	local FieldOfView = Config.FieldOfView
	local ClosestTarget = nil

	for Index, Target in pairs(PlayerService:GetPlayers()) do
		local Character = Target.Character
		local Health = Character and (Character:FindFirstChildOfClass("Humanoid") and Character:FindFirstChildOfClass("Humanoid").Health > 0)
		if Target ~= LocalPlayer and Health and TeamCheck(Target) then
			for Index, BodyPart in pairs(Config.Priority) do
				local Hitbox = Character and Character:FindFirstChild(BodyPart)
				if Hitbox then
					local ScreenPosition, OnScreen = Camera:WorldToViewportPoint(Hitbox.Position)
					local Magnitude = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
					if OnScreen and FieldOfView > Magnitude and WallCheck(Config.WallCheck,Hitbox,Character) then
						FieldOfView = Magnitude
						ClosestTarget = Hitbox
					end
				end
			end
		end
	end

	return ClosestTarget
end

local function AimAt(Target,Config)
	if not Target then return end
	local Camera = Workspace.CurrentCamera
	local Mouse = UserInputService:GetMouseLocation()
	local TargetPrediction = ((Target.Position - Camera.CFrame.Position).Magnitude * Target.AssemblyLinearVelocity * (Config.Prediction.Velocity / 10)) / 100
	local TargetOnScreen = Camera:WorldToViewportPoint(Config.Prediction.Enabled and Target.Position + TargetPrediction or Target.Position)
	mousemoverel(
		(TargetOnScreen.X - Mouse.X) * Config.Sensitivity,
		(TargetOnScreen.Y - Mouse.Y) * Config.Sensitivity
	)
end

local __namecall
__namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    if ZORKA.Config.AimAssist.SilentAim.Enabled and SilentAim then
        local Camera = Workspace.CurrentCamera
        local HitChance = math.random(0,100) <= ZORKA.Config.AimAssist.SilentAim.HitChance
        if getnamecallmethod() == "Raycast" and HitChance then
            args[2] = SilentAim.Position - Camera.CFrame.Position
        elseif getnamecallmethod() == "FindPartOnRayWithIgnoreList" and HitChance then
            args[1] = Ray.new(args[1].Origin,SilentAim.Position - Camera.CFrame.Position)
        end
    end
    return __namecall(self, unpack(args))
end)

RunService.Heartbeat:Connect(function()
    SilentAim = GetTarget(ZORKA.Config.AimAssist.SilentAim)
    if Aimbot then AimAt(GetTarget(ZORKA.Config.AimAssist.Aimbot),
        ZORKA.Config.AimAssist.Aimbot)
    end

    if ZORKA.Config.UI.Watermark then
        ZORKA.Utilities.UI:Watermark({
            Enabled = true,
            Title = string.format(
                "ZORKA Hub — %s\nTime: %s - %s\nFPS: %i/s\nPing: %i ms",
                ZORKA.Current,os.date("%X"),os.date("%x"),GetFPS(),math.round(Stats.PerformanceStats.Ping:GetValue())
            )
        })
    end
end)

for Index, Player in pairs(PlayerService:GetPlayers()) do
    if Player ~= LocalPlayer then
        ZORKA.Utilities.Drawing:AddESP("Player", Player, ZORKA.Config.PlayerESP)
    end
end
PlayerService.PlayerAdded:Connect(function(Player)
    ZORKA.Utilities.Drawing:AddESP("Player", Player, ZORKA.Config.PlayerESP)
end)
PlayerService.PlayerRemoving:Connect(function(Player)
    if Player == LocalPlayer then ZORKA.Utilities.Config:WriteJSON(ZORKA.Current,ZORKA.Config) end
    ZORKA.Utilities.Drawing:RemoveESP(Player)
end)
