--[[
    GB HUB V2 - GREEN EDITION
    Interface visual para teste.
    Os botoes de farm sao apenas placeholders: nao automatizam o jogo.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
if not player then
    warn("GB HUB: jogador local nao encontrado.")
    return
end

-- Evita duplicar a interface ao executar novamente
local parentGui
if typeof(gethui) == "function" then
    local ok, result = pcall(gethui)
    if ok and result then
        parentGui = result
    end
end
parentGui = parentGui or CoreGui

pcall(function()
    local old = parentGui:FindFirstChild("GB_HUB_V2")
    if old then old:Destroy() end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "GB_HUB_V2"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local okParent = pcall(function()
    gui.Parent = parentGui
end)
if not okParent then
    gui.Parent = player:WaitForChild("PlayerGui")
end

local GREEN = Color3.fromRGB(0, 220, 85)
local DARK = Color3.fromRGB(10, 16, 12)
local PANEL = Color3.fromRGB(19, 29, 22)
local WHITE = Color3.fromRGB(240, 255, 244)
local MUTED = Color3.fromRGB(160, 190, 168)

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(270, 315)
main.Position = UDim2.new(0.5, -135, 0.5, -157)
main.BackgroundColor3 = DARK
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = GREEN
mainStroke.Thickness = 2
mainStroke.Parent = main

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 48)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 82, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(12, 0)
title.Size = UDim2.new(1, -24, 1, 0)
title.Font = Enum.Font.GothamBlack
title.Text = "GB HUB  V2"
title.TextColor3 = WHITE
title.TextSize = 22
title.Parent = titleBar

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(0, 51)
subtitle.Size = UDim2.new(1, 0, 0, 22)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "GREEN EDITION  •  MOBILE"
subtitle.TextColor3 = MUTED
subtitle.TextSize = 10
subtitle.Parent = main

local status = Instance.new("TextLabel")
status.Name = "Status"
status.BackgroundColor3 = PANEL
status.Position = UDim2.fromOffset(15, 278)
status.Size = UDim2.new(1, -30, 0, 25)
status.Font = Enum.Font.Gotham
status.Text = "Status: pronto"
status.TextColor3 = GREEN
status.TextSize = 11
status.Parent = main

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 7)
statusCorner.Parent = status

local function setStatus(message)
    status.Text = "Status: " .. message
    print("[GB HUB] " .. message)
end

local function makeButton(label, y, callback, color)
    local button = Instance.new("TextButton")
    button.Name = label:gsub("%W", "") .. "Button"
    button.Size = UDim2.new(1, -30, 0, 42)
    button.Position = UDim2.fromOffset(15, y)
    button.BackgroundColor3 = color or Color3.fromRGB(0, 112, 48)
    button.BorderSizePixel = 0
    button.AutoButtonColor = true
    button.Font = Enum.Font.GothamBold
    button.Text = label
    button.TextColor3 = WHITE
    button.TextSize = 14
    button.Parent = main

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = button

    button.Activated:Connect(callback)
    return button
end

makeButton("⚔  FARM LEVEL", 82, function()
    setStatus("Farm Level: botao visual")
end)

makeButton("🌊  FARM SEA BEAST", 130, function()
    setStatus("Sea Beast: botao visual")
end)

makeButton("🔥  FARM MAESTRIA", 178, function()
    setStatus("Maestria: botao visual")
end)

makeButton("■  STOP ALL", 226, function()
    setStatus("nenhuma automacao ativa")
end, Color3.fromRGB(115, 35, 35))

-- Botao flutuante para esconder/mostrar a janela
local toggle = Instance.new("TextButton")
toggle.Name = "ToggleButton"
toggle.Size = UDim2.fromOffset(105, 38)
toggle.Position = UDim2.new(0, 12, 0.5, -19)
toggle.BackgroundColor3 = Color3.fromRGB(0, 100, 42)
toggle.BorderSizePixel = 0
toggle.Font = Enum.Font.GothamBold
toggle.Text = "GB HUB  ◉"
toggle.TextColor3 = WHITE
toggle.TextSize = 13
toggle.Parent = gui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggle

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = GREEN
toggleStroke.Thickness = 1.5
toggleStroke.Parent = toggle

toggle.Activated:Connect(function()
    main.Visible = not main.Visible
    toggle.Text = main.Visible and "GB HUB  ◉" or "GB HUB  ○"
end)

-- Arrastar a janela pela barra superior (mouse ou toque)
local dragging = false
local dragInput
local dragStart
local startPosition

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

print("GB HUB V2 carregado. Os botoes de farm sao apenas visuais.")
