
--==================================================
-- DIRECTX V4 | ULTRA PREMIUM
-- Single File Roblox UI
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

local OLD = PG:FindFirstChild("DirectX")
if OLD then OLD:Destroy() end

local C = {
    BG = Color3.fromRGB(10,11,16),
    Panel = Color3.fromRGB(19,21,29),
    Card = Color3.fromRGB(27,29,39),
    Red = Color3.fromRGB(255,35,65),
    White = Color3.fromRGB(245,245,250),
    Gray = Color3.fromRGB(145,150,165),
    Green = Color3.fromRGB(50,220,140)
}

local GUI = Instance.new("ScreenGui")
GUI.Name = "DirectX"
GUI.ResetOnSpawn = false
GUI.DisplayOrder = 999
GUI.Parent = PG

local function New(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function Corner(obj, radius)
    New("UICorner", {
        CornerRadius = UDim.new(0,radius or 10)
    },obj)
end

local function Stroke(obj,color,thickness)
    New("UIStroke",{
        Color = color or C.Red,
        Thickness = thickness or 1
    },obj)
end

local function Animate(obj,props,time)
    TweenService:Create(
        obj,
        TweenInfo.new(time or 0.2,Enum.EasingStyle.Quart),
        props
    ):Play()
end

-- NOTIFICATION SYSTEM

local NotifyHolder = New("Frame",{
    Size = UDim2.fromOffset(300,200),
    Position = UDim2.new(1,-320,0,20),
    BackgroundTransparency = 1
},GUI)

New("UIListLayout",{
    Padding = UDim.new(0,8),
    SortOrder = Enum.SortOrder.LayoutOrder
},NotifyHolder)

local function Notify(title,message)
    local card = New("Frame",{
        Size = UDim2.fromOffset(290,65),
        BackgroundColor3 = C.Panel
    },NotifyHolder)

    Corner(card,10)
    Stroke(card,C.Red,1)

    New("TextLabel",{
        Position = UDim2.fromOffset(12,7),
        Size = UDim2.new(1,-20,0,22),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C.Red,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    },card)

    New("TextLabel",{
        Position = UDim2.fromOffset(12,32),
        Size = UDim2.new(1,-20,0,22),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = C.Gray,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    },card)

    task.delay(3,function()
        if card.Parent then
            Animate(card,{BackgroundTransparency=1},0.4)
            task.wait(0.5)
            card:Destroy()
        end
    end)
end

-- MAIN WINDOW

local Main = New("Frame",{
    Size = UDim2.fromOffset(610,430),
    Position = UDim2.new(0.5,-305,0.5,-215),
    BackgroundColor3 = C.BG,
    BorderSizePixel = 0,
    ClipsDescendants = true
},GUI)

Corner(Main,16)
Stroke(Main,C.Red,1.5)

-- HEADER

local Header = New("Frame",{
    Size = UDim2.new(1,0,0,75),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0
},Main)

local Logo = New("TextLabel",{
    Position = UDim2.fromOffset(20,8),
    Size = UDim2.fromOffset(220,38),
    BackgroundTransparency = 1,
    Text = "DIRECTX",
    TextColor3 = C.Red,
    Font = Enum.Font.GothamBlack,
    TextSize = 29,
    TextXAlignment = Enum.TextXAlignment.Left
},Header)

New("TextLabel",{
    Position = UDim2.fromOffset(22,45),
    Size = UDim2.fromOffset(250,17),
    BackgroundTransparency = 1,
    Text = "ULTIMATE CONTROL CENTER  |  V4.0",
    TextColor3 = C.Gray,
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left
},Header)

local Close = New("TextButton",{
    Size = UDim2.fromOffset(38,38),
    Position = UDim2.new(1,-50,0,17),
    BackgroundColor3 = C.Red,
    Text = "X",
    TextColor3 = C.White,
    Font = Enum.Font.GothamBlack,
    TextSize = 17
},Header)

Corner(Close,10)

-- FLOATING BUTTON

local Float = New("TextButton",{
    Size = UDim2.fromOffset(65,65),
    Position = UDim2.new(0.5,-32,0.5,-32),
    BackgroundColor3 = C.BG,
    Text = "DX",
    TextColor3 = C.Red,
    Font = Enum.Font.GothamBlack,
    TextSize = 24,
    Visible = false
},GUI)

Corner(Float,100)
Stroke(Float,C.Red,2)

Close.MouseButton1Click:Connect(function()
    Main.Visible = false
    Float.Visible = true
end)

Float.MouseButton1Click:Connect(function()
    Main.Visible = true
    Float.Visible = false
end)

-- DRAG SYSTEM

local function MakeDraggable(object,handle)
    local active = false
    local startMouse
    local startPosition

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            active = true
            startMouse = input.Position
            startPosition = object.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if active and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position-startMouse
            object.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset+delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset+delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            active = false
        end
    end)
end

MakeDraggable(Main,Header)
MakeDraggable(Float,Float)

-- SIDEBAR

local Sidebar = New("Frame",{
    Position = UDim2.fromOffset(0,75),
    Size = UDim2.new(0,145,1,-75),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0
},Main)

local PageArea = New("Frame",{
    Position = UDim2.fromOffset(155,85),
    Size = UDim2.new(1,-165,1,-95),
    BackgroundTransparency = 1
},Main)

local Pages = {}
local CurrentPage = nil

local function CreatePage(name)
    local page = New("ScrollingFrame",{
        Size = UDim2.fromScale(1,1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.Red,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false
    },PageArea)

    New("UIListLayout",{
        Padding = UDim.new(0,10),
        SortOrder = Enum.SortOrder.LayoutOrder
    },page)

    Pages[name] = page
    return page
end

local function SwitchPage(name)
    for n,p in pairs(Pages) do
        p.Visible = n == name
    end
    CurrentPage = name
    Notify("DIRECTX",name.." selected")
end

local function Tab(name)
    local button = New("TextButton",{
        Size = UDim2.new(1,-15,0,42),
        BackgroundColor3 = C.Card,
        Text = "   "..name,
        TextColor3 = C.White,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    },Sidebar)

    Corner(button,9)

    button.MouseButton1Click:Connect(function()
        SwitchPage(name)
    end)
end

New("UIListLayout",{
    Padding = UDim.new(0,8),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder
},Sidebar)

local Spacer = New("Frame",{
    Size = UDim2.new(1,0,0,8),
    BackgroundTransparency = 1,
    LayoutOrder = -1
},Sidebar)

-- COMPONENTS

local function Section(page,text)
    return New("TextLabel",{
        Size = UDim2.new(1,-8,0,28),
        BackgroundTransparency = 1,
        Text = "  "..text,
        TextColor3 = C.Red,
        Font = Enum.Font.GothamBlack,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    },page)
end

local function Action(page,name,callback)
    local button = New("TextButton",{
        Size = UDim2.new(1,-8,0,43),
        BackgroundColor3 = C.Card,
        Text = "  "..name.."     →",
        TextColor3 = C.White,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    },page)

    Corner(button,9)
    Stroke(button,Color3.fromRGB(45,47,60),1)

    button.MouseButton1Click:Connect(function()
        Animate(button,{BackgroundColor3=C.Red},0.12)
        task.wait(0.13)
        Animate(button,{BackgroundColor3=C.Card},0.15)
        if callback then callback() end
    end)

    return button
end

local function Toggle(page,name,callback)
    local card = New("Frame",{
        Size = UDim2.new(1,-8,0,48),
        BackgroundColor3 = C.Card
    },page)

    Corner(card,9)

    New("TextLabel",{
        Position = UDim2.fromOffset(13,0),
        Size = UDim2.new(1,-105,1,0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = C.White,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    },card)

    local enabled = false

    local btn = New("TextButton",{
        Size = UDim2.fromOffset(65,28),
        Position = UDim2.new(1,-78,0.5,-14),
        BackgroundColor3 = Color3.fromRGB(55,57,68),
        Text = "OFF",
        TextColor3 = C.White,
        Font = Enum.Font.GothamBold,
        TextSize = 11
    },card)

    Corner(btn,8)

    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = enabled and "ON" or "OFF"

        Animate(btn,{
            BackgroundColor3 = enabled and C.Red
            or Color3.fromRGB(55,57,68)
        },0.2)

        if callback then callback(enabled) end
        Notify(name,enabled and "Enabled" or "Disabled")
    end)

    return function()
        return enabled
    end
end

local function Slider(page,name,min,max,default,callback)
    local card = New("Frame",{
        Size = UDim2.new(1,-8,0,76),
        BackgroundColor3 = C.Card
    },page)

    Corner(card,9)

    local value = default

    local title = New("TextLabel",{
        Position = UDim2.fromOffset(13,5),
        Size = UDim2.new(1,-25,0,25),
        BackgroundTransparency = 1,
        Text = name..": "..value,
        TextColor3 = C.White,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    },card)

    local bar = New("Frame",{
        Position = UDim2.fromOffset(13,45),
        Size = UDim2.new(1,-26,0,8),
        BackgroundColor3 = Color3.fromRGB(55,57,68)
    },card)

    Corner(bar,10)

    local fill = New("Frame",{
        Size = UDim2.new((default-min)/(max-min),0,1,0),
        BackgroundColor3 = C.Red
    },bar)

    Corner(fill,10)

    local knob = New("TextButton",{
        Size = UDim2.fromOffset(17,17),
        Position = UDim2.new((default-min)/(max-min),-8,0.5,-8),
        BackgroundColor3 = C.White,
        Text = ""
    },bar)

    Corner(knob,100)

    local sliding = false

    local function Update(x)
        local percent = math.clamp(
            (x-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,
            0,1
        )

        value = math.floor(min+percent*(max-min))
        fill.Size = UDim2.new(percent,0,1,0)
        knob.Position = UDim2.new(percent,-8,0.5,-8)
        title.Text = name..": "..value

        if callback then callback(value) end
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
            Update(input.Position.X)
        end
    end)

    knob.MouseButton1Down:Connect(function()
        sliding = true
    end)

    UIS.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            Update(input.Position.X)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)

    return function()
        return value
    end
end

-- DASHBOARD

local Dashboard = CreatePage("Dashboard")
Tab("DASHBOARD")

Section(Dashboard,"WELCOME TO DIRECTX")

Action(Dashboard,"INFORMATION",function()
    Notify("DIRECTX V4","Premium interface loaded")
end)

Action(Dashboard,"REFRESH STATUS",function()
    Notify("STATUS","Interface is running")
end)

Action(Dashboard,"SHOW VERSION",function()
    Notify("VERSION","DirectX V4.0")
end)

Section(Dashboard,"QUICK SETTINGS")

Toggle(Dashboard,"UI Animations")
Toggle(Dashboard,"Notifications")
Toggle(Dashboard,"Compact Mode")
Toggle(Dashboard,"Show Floating Button")

-- PLAYER PAGE

local PlayerPage = CreatePage("Players")
Tab("PLAYERS")

Section(PlayerPage,"CONNECTED PLAYERS")

local PlayerCount = New("TextLabel",{
    Size = UDim2.new(1,-8,0,30),
    BackgroundColor3 = C.Card,
    TextColor3 = C.Green,
    Text = "Players: 0",
    Font = Enum.Font.GothamBold,
    TextSize = 13
},PlayerPage)

Corner(PlayerCount,8)

local PlayerContainer = New("Frame",{
    Size = UDim2.new(1,-8,0,10),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1
},PlayerPage)

New("UIListLayout",{
    Padding = UDim.new(0,6)
},PlayerContainer)

local function RefreshPlayers()
    for _,v in ipairs(PlayerContainer:GetChildren()) do
        if v:IsA("TextLabel") then
            v:Destroy()
        end
    end

    local list = Players:GetPlayers()
    PlayerCount.Text = "Players: "..#list

    for _,p in ipairs(list) do
        local item = New("TextLabel",{
            Size = UDim2.new(1,0,0,35),
            BackgroundColor3 = C.Card,
            Text = "   "..p.DisplayName.."  (@"..p.Name..")",
            TextColor3 = C.White,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left
        },PlayerContainer)

        Corner(item,7)
    end
end

Action(PlayerPage,"REFRESH PLAYER LIST",RefreshPlayers)
RefreshPlayers()

Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(RefreshPlayers)

-- MOVEMENT PAGE

local Movement = CreatePage("Movement")
Tab("MOVEMENT")

Section(Movement,"MOVEMENT SETTINGS")

local selectedSpeed = 16

Slider(Movement,"Speed Preview",16,100,16,function(v)
    selectedSpeed = v
end)

Action(Movement,"SHOW SELECTED SPEED",function()
    Notify("SPEED","Selected value: "..selectedSpeed)
end)

Toggle(Movement,"Movement HUD")
Toggle(Movement,"Show Speed Information")

-- VISUALS PAGE

local Visuals = CreatePage("Visuals")
Tab("VISUALS")

Section(Visuals,"INTERFACE VISUALS")

Toggle(Visuals,"Red Neon Effects")
Toggle(Visuals,"Glow Effects")
Toggle(Visuals,"Animated UI")
Toggle(Visuals,"Show Player Counter")
Toggle(Visuals,"Show Notifications")
Toggle(Visuals,"Dark Theme")

-- SETTINGS PAGE

local Settings = CreatePage("Settings")
Tab("SETTINGS")

Section(Settings,"GENERAL SETTINGS")

Action(Settings,"SHOW DIRECTX VERSION",function()
    Notify("DIRECTX","Version 4.0 Ultra")
end)

Action(Settings,"REFRESH INTERFACE",function()
    Notify("DIRECTX","Interface refreshed")
    RefreshPlayers()
end)

Action(Settings,"HIDE INTERFACE",function()
    Main.Visible = false
    Float.Visible = true
end)

Action(Settings,"RESET WINDOW POSITION",function()
    Main.Position = UDim2.new(0.5,-305,0.5,-215)
    Notify("DIRECTX","Window position reset")
end)

Section(Settings,"ABOUT")

New("TextLabel",{
    Size = UDim2.new(1,-8,0,65),
    BackgroundColor3 = C.Card,
    Text = "DIRECTX V4.0\nULTRA PREMIUM INTERFACE\nClient-side UI",
    TextColor3 = C.Gray,
    Font = Enum.Font.GothamBold,
    TextSize = 12
},Settings)

-- START

SwitchPage("Dashboard")
Notify("DIRECTX INJECTED","Welcome to DirectX V4.0")

print("DIRECTX V4.0 LOADED")
