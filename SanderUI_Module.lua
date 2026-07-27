--[[
    ========================================================================
    SANDER UI v6.2 - FIXED ZINDEXBEHAVIOR & ZERO PROPERTY MISMATCHES
    ========================================================================
    Fixes:
    - Fixed Line 158: Moved ZIndexBehavior property from TextLabel (tip) to ScreenGui (screenGui).
    - Set tip.ZIndex = 100 on TextLabel.
    - Verified all 20 components against Roblox API specs.
    - Preserved Rule 1 (MainFrame size untouched) & Rule 2 (LogoText RichText/TextScaled = true, title SanderUI).
    ========================================================================
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")

local SanderUI = {
    Version = "6.3.0",
    Windows = {},
    Notifications = {},
    Flags = {},
    FlagComponents = {},
    CurrentTheme = "Emerald",

    Themes = {
        Emerald = {
            MainBackground = Color3.fromRGB(20, 20, 24),
            SidebarBackground = Color3.fromRGB(16, 16, 20),
            CardBackground = Color3.fromRGB(28, 28, 34),
            CardHover = Color3.fromRGB(36, 36, 44),
            Accent = Color3.fromRGB(51, 102, 74),
            AccentHover = Color3.fromRGB(61, 122, 89),
            TextColor = Color3.fromRGB(245, 245, 250),
            SubTextColor = Color3.fromRGB(160, 160, 175),
            BorderColor = Color3.fromRGB(42, 42, 50),
            Font = Enum.Font.GothamMedium,
            BoldFont = Enum.Font.GothamBold,
        }
    }
}
SanderUI.__index = SanderUI

local DEFAULT_CONFIG = {
    Title = "SanderUI",
    Alignment = "Center",
    Position = nil,

    TopRightCounter = {
        Enabled = true,
        Title = "FPS",
        ShowFPS = true,
        ShowPing = true,
        CustomValue = nil,
    },

    Theme = SanderUI.Themes.Emerald,

    Layout = {
        PaddingLeft = 12,
        PaddingRight = 12,
        PaddingTop = 14,
        PaddingBottom = 14,
        ItemSpacing = 8,
        ButtonHeight = 38,
        MiniButtonHeight = 28,
        ToggleHeight = 40,
        MiniToggleHeight = 28,
        SliderHeight = 46,
        DropdownHeight = 40,
        KeybindHeight = 40,
        SectionHeight = 28,
        InputHeight = 40,
    }
}

local function MergeTables(defaults, options)
    options = options or {}
    local result = {}
    for k, v in pairs(defaults) do
        if type(v) == "table" then
            result[k] = MergeTables(v, options[k] or {})
        else
            result[k] = (options[k] ~= nil) and options[k] or v
        end
    end
    for k, v in pairs(options) do
        if result[k] == nil then
            result[k] = v
        end
    end
    return result
end

local function SafeCallback(fn, ...)
    if type(fn) == "function" then
        local args = {...}
        task.spawn(function()
            local success, err = pcall(fn, unpack(args))
            if not success then
                warn("[SanderUI Callback Error]:", err)
            end
        end)
    end
end

local function GetOrCreateScale(frame)
    return frame:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", frame)
end

local function Tween(instance, tweenInfo, goals)
    local t = TweenService:Create(instance, tweenInfo, goals)
    t:Play()
    return t
end

local function ClearTemplateExtras(clonedFrame, primaryLabel)
    if (clonedFrame:IsA("TextButton") or clonedFrame:IsA("TextLabel")) and clonedFrame ~= primaryLabel then
        clonedFrame.Text = ""
    end
    for _, child in pairs(clonedFrame:GetChildren()) do
        if child ~= primaryLabel and not child:IsA("UIBase") and not child:IsA("UICorner") and not child:IsA("UIStroke") and not child:IsA("UIScale") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
end

local function CalculateCardHeight(text, font, textSize, maxTextWidth, baseHeight)
    baseHeight = baseHeight or 40
    local size = TextService:GetTextSize(text, textSize or 13, font or SanderUI.Themes.Emerald.Font, Vector2.new(maxTextWidth, 10000))
    return math.max(baseHeight, size.Y + 16)
end

local function FormatTitleText(textLabel, text, font, textColor, wrap)
    if not textLabel or (not textLabel:IsA("TextLabel") and not textLabel:IsA("TextButton")) then return end
    textLabel.Text = text
    textLabel.Font = font or SanderUI.Themes.Emerald.Font
    textLabel.TextColor3 = textColor or SanderUI.Themes.Emerald.TextColor
    textLabel.TextWrapped = (wrap == nil and true or wrap)
    if not textLabel.TextWrapped then
        textLabel.TextTruncate = Enum.TextTruncate.AtEnd
    else
        textLabel.TextTruncate = Enum.TextTruncate.None
    end
    textLabel.TextYAlignment = Enum.TextYAlignment.Center
    textLabel.BackgroundTransparency = 1
end

local function EnsureTextTemplate(frame)
    local txt = frame:FindFirstChild("TextTemplate", true) or frame:FindFirstChildOfClass("TextLabel")
    if not txt then
        txt = Instance.new("TextLabel")
        txt.Name = "TextTemplate"
        txt.Parent = frame
        txt.Size = UDim2.new(1, -24, 1, 0)
        txt.Position = UDim2.new(0, 12, 0, 0)
        txt.BackgroundTransparency = 1
        txt.TextXAlignment = Enum.TextXAlignment.Left
    end
    return txt
end

local function ApplyPremiumStroke(guiObject, theme)
    local stroke = guiObject:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
    stroke.Parent = guiObject
    stroke.Color = theme and theme.BorderColor or Color3.fromRGB(42, 42, 50)
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Transparency = 0.5
    return stroke
end

-- TOOLTIP ENGINE (CORRECT PROPERTY ASSIGNMENT FOR SCREENGUI VS TEXTLABEL)
local TooltipFrame = nil

local function EnsureTooltip()
    if TooltipFrame and TooltipFrame.Parent then return TooltipFrame end
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = playerGui:FindFirstChild("SanderUI_Notifications")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "SanderUI_Notifications"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = playerGui
    else
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    end

    local tip = Instance.new("TextLabel")
    tip.Name = "Tooltip"
    tip.Parent = screenGui
    tip.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    tip.TextColor3 = Color3.fromRGB(230, 230, 240)
    tip.Font = Enum.Font.GothamMedium
    tip.TextSize = 11
    tip.Size = UDim2.new(0, 160, 0, 24)
    tip.Visible = false
    tip.ZIndex = 100
    Instance.new("UICorner", tip).CornerRadius = UDim.new(0, 4)
    local stroke = Instance.new("UIStroke", tip)
    stroke.Color = Color3.fromRGB(60, 60, 70)

    TooltipFrame = tip
    return TooltipFrame
end

local function AttachTooltip(element, text)
    if not text or text == "" then return end
    local tip = EnsureTooltip()

    element.MouseEnter:Connect(function()
        tip.Text = "  " .. text .. "  "
        tip.Visible = true
    end)

    element.MouseLeave:Connect(function()
        tip.Visible = false
    end)

    UserInputService.InputChanged:Connect(function(input)
        if tip.Visible and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = input.Position
            tip.Position = UDim2.new(0, mousePos.X + 15, 0, mousePos.Y + 15)
        end
    end)
end

local function MakeDraggable(handle, target)
    local dragging = false
    local dragStart = nil
    local startPos = nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function AddHoverScale(element, hoverScale, normalScale)
    hoverScale = hoverScale or 1.015
    normalScale = normalScale or 1.0
    local scaleObj = GetOrCreateScale(element)

    element.MouseEnter:Connect(function()
        Tween(scaleObj, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = hoverScale})
    end)
    element.MouseLeave:Connect(function()
        Tween(scaleObj, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = normalScale})
    end)
end

local function AddPressScale(element, pressCallback)
    local scaleObj = GetOrCreateScale(element)
    element.MouseButton1Down:Connect(function()
        Tween(scaleObj, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.98})
    end)
    element.MouseButton1Up:Connect(function()
        Tween(scaleObj, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1.01})
        task.wait(0.08)
        Tween(scaleObj, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1.0})
        if pressCallback then SafeCallback(pressCallback) end
    end)
end

-- NOTIFICATION ENGINE
local NotificationContainer = nil

local function EnsureNotificationContainer()
    if NotificationContainer and NotificationContainer.Parent then return NotificationContainer end
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local screenGui = playerGui:FindFirstChild("SanderUI_Notifications")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "SanderUI_Notifications"
        screenGui.ResetOnSpawn = false
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.Parent = playerGui
    end

    local holder = Instance.new("Frame")
    holder.Name = "NotificationHolder"
    holder.AnchorPoint = Vector2.new(1, 1)
    holder.Position = UDim2.new(1, -20, 1, -20)
    holder.Size = UDim2.new(0, 300, 1, -40)
    holder.BackgroundTransparency = 1
    holder.Parent = screenGui

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Padding = UDim.new(0, 8)
    layout.Parent = holder

    NotificationContainer = holder
    return NotificationContainer
end

function SanderUI:Notify(notifConfig)
    notifConfig = notifConfig or {}
    local title = notifConfig.Title or "Notification"
    local content = notifConfig.Content or ""
    local duration = notifConfig.Duration or 4

    local holder = EnsureNotificationContainer()

    local card = Instance.new("Frame")
    card.Name = "NotificationCard"
    card.Size = UDim2.new(1, 0, 0, 65)
    card.BackgroundColor3 = SanderUI.Themes.Emerald.CardBackground
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.Position = UDim2.new(1, 350, 0, 0)
    card.Parent = holder

    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", card)
    stroke.Color = SanderUI.Themes.Emerald.BorderColor
    stroke.Thickness = 1

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Parent = card
    titleLbl.Position = UDim2.new(0, 12, 0, 8)
    titleLbl.Size = UDim2.new(1, -24, 0, 20)
    FormatTitleText(titleLbl, title, SanderUI.Themes.Emerald.BoldFont, SanderUI.Themes.Emerald.TextColor, false)
    titleLbl.TextSize = 14
    titleLbl.BackgroundTransparency = 1

    local contentLbl = Instance.new("TextLabel")
    contentLbl.Parent = card
    contentLbl.Position = UDim2.new(0, 12, 0, 28)
    contentLbl.Size = UDim2.new(1, -24, 0, 24)
    contentLbl.Text = content
    contentLbl.Font = SanderUI.Themes.Emerald.Font
    contentLbl.TextSize = 12
    contentLbl.TextColor3 = SanderUI.Themes.Emerald.SubTextColor
    contentLbl.TextXAlignment = Enum.TextXAlignment.Left
    contentLbl.TextWrapped = true
    contentLbl.BackgroundTransparency = 1

    local progressBar = Instance.new("Frame")
    progressBar.Parent = card
    progressBar.AnchorPoint = Vector2.new(0, 1)
    progressBar.Position = UDim2.new(0, 0, 1, 0)
    progressBar.Size = UDim2.new(1, 0, 0, 3)
    progressBar.BackgroundColor3 = SanderUI.Themes.Emerald.Accent
    progressBar.BorderSizePixel = 0

    Tween(card, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
    Tween(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Size = UDim2.new(0, 0, 0, 3)})

    task.delay(duration, function()
        local slideOut = Tween(card, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 350, 0, 0)})
        slideOut.Completed:Connect(function()
            card:Destroy()
        end)
    end)
end

-- SAVE / LOAD CONFIG ENGINE
function SanderUI:SaveConfig(configName)
    configName = configName or "default"
    local dataToSave = {}
    for k, v in pairs(SanderUI.Flags) do
        if typeof(v) == "Color3" then
            dataToSave[k] = { __type = "Color3", R = v.R, G = v.G, B = v.B }
        elseif typeof(v) == "EnumItem" then
            local enumTypeStr = tostring(v.EnumType)
            if enumTypeStr:sub(1,5) == "Enum." then enumTypeStr = enumTypeStr:sub(6) end
            dataToSave[k] = { __type = "EnumItem", EnumType = enumTypeStr, Name = v.Name }
        else
            dataToSave[k] = v
        end
    end
    
    local jsonStr = ""
    pcall(function() jsonStr = HttpService:JSONEncode(dataToSave) end)
    if writefile then
        pcall(function() writefile("SanderUI_" .. configName .. ".json", jsonStr) end)
        SanderUI:Notify({ Title = "Kaydedildi", Content = configName .. " konfigürasyonu kaydedildi.", Duration = 3 })
    end
end

function SanderUI:LoadConfig(configName)
    configName = configName or "default"
    if readfile and isfile and isfile("SanderUI_" .. configName .. ".json") then
        pcall(function()
            local content = readfile("SanderUI_" .. configName .. ".json")
            local data = HttpService:JSONDecode(content)
            for flag, val in pairs(data) do
                local parsedVal = val
                if type(val) == "table" and val.__type == "Color3" then
                    parsedVal = Color3.new(val.R, val.G, val.B)
                elseif type(val) == "table" and val.__type == "EnumItem" then
                    pcall(function()
                        parsedVal = Enum[val.EnumType][val.Name]
                    end)
                end
                
                SanderUI.Flags[flag] = parsedVal
                if SanderUI.FlagComponents[flag] then
                    SanderUI.FlagComponents[flag]:Set(parsedVal)
                end
            end
            SanderUI:Notify({ Title = "Yüklendi", Content = configName .. " konfigürasyonu yüklendi.", Duration = 3 })
        end)
    end
end

-- THEME UPDATE ENGINE
function SanderUI:SetTheme(themeConfig)
    if not themeConfig then return end
    for k, v in pairs(themeConfig) do
        SanderUI.Themes.Emerald[k] = v
    end
    -- Temanın güncellendiğini bildiren sistem
    SanderUI:Notify({ Title = "Tema Güncellendi", Content = "Yeni tema ayarları uygulandı. Sonraki pencerelerde aktif olacaktır.", Duration = 4 })
end


-- MAIN WINDOW ENGINE
function SanderUI:CreateWindow(userConfig)
    local cfg = MergeTables(DEFAULT_CONFIG, userConfig or {})

    local player = game.Players.LocalPlayer
    
    -- Executor (CoreGui) vs Studio (PlayerGui) tespiti
    local screenGui = nil
    local coreGui = game:GetService("CoreGui")
    
    if coreGui:FindFirstChild("SanderUI") then
        screenGui = coreGui.SanderUI
    else
        local playerGui = player:WaitForChild("PlayerGui", 5)
        if playerGui and playerGui:FindFirstChild("SanderUI") then
            screenGui = playerGui.SanderUI
        end
    end

    if not screenGui then
        warn("SanderUI Error: Arayüz (ScreenGui) bulunamadı! Lütfen arayüzün CoreGui veya PlayerGui içinde yüklü olduğundan emin olun.")
        return
    end

    local mainFrame = screenGui:WaitForChild("MainFrame")
    local topBar = mainFrame:WaitForChild("TopBar")
    local closeBtn = mainFrame:WaitForChild("CloseBtn")
    local minimizeBtn = mainFrame:WaitForChild("MinimizeBtn")

    local miniFrame = screenGui:WaitForChild("Mini Frame")
    local miniTopBar = miniFrame:FindFirstChild("TopBAR") or miniFrame
    local miniCloseBtn = miniFrame:FindFirstChild("CloseBTN")
    local maximizeBtn = miniFrame:FindFirstChild("MinimizeBTN") or miniFrame:FindFirstChild("MinimizeBtn")

    local sidebar = mainFrame:WaitForChild("Sidebar")
    local contentContainer = mainFrame:FindFirstChild("ContentArea") or mainFrame:FindFirstChild("PortFrame") or mainFrame
    local pageTemplate = mainFrame:WaitForChild("PageTemplate")

    local templates = screenGui:WaitForChild("Templates")
    local tabTemplate = templates:WaitForChild("TabTemplate")
    local buttonTemplate = templates:WaitForChild("ButtonTemplate")
    local toggleTemplate = templates:WaitForChild("ToggleTemplate")

    if templates:IsA("GuiObject") then templates.Visible = false end
    for _, child in pairs(templates:GetChildren()) do
        if child:IsA("GuiObject") then child.Visible = false end
    end

    tabTemplate.Visible = false
    pageTemplate.Visible = false

    local mainScale = GetOrCreateScale(mainFrame)
    local miniScale = GetOrCreateScale(miniFrame)

    if cfg.Position then
        mainFrame.Position = cfg.Position
    elseif cfg.Alignment then
        local align = string.lower(tostring(cfg.Alignment))
        if align == "left" then
            mainFrame.Position = UDim2.new(0.05, 0, 0.5, - (mainFrame.Size.Y.Offset/2))
        elseif align == "right" then
            mainFrame.Position = UDim2.new(0.95, - mainFrame.Size.X.Offset, 0.5, - (mainFrame.Size.Y.Offset/2))
        elseif align == "center" then
            mainFrame.Position = UDim2.new(0.5, - (mainFrame.Size.X.Offset/2), 0.5, - (mainFrame.Size.Y.Offset/2))
        end
    end

    local originalMainPos = mainFrame.Position
    local originalMiniSize = miniFrame.Size

    mainFrame.ClipsDescendants = true
    miniFrame.Visible = false
    miniFrame.ClipsDescendants = true

    -- RULE 2: LOGOTEXT IS ALWAYS RICHTEXT = TRUE, TEXTSCALED = TRUE, AND OUR BRAND NAME IS ALWAYS SanderUI
    local logoText = mainFrame:FindFirstChild("LogoText", true)
    if logoText and logoText:IsA("TextLabel") then
        logoText.RichText = true
        logoText.TextScaled = true
        logoText.Text = cfg.Title or "SanderUI"
        -- Kullanıcının Studio'da belirlediği renk (TextColor3) ve Font ayarlarına KESİNLİKLE DOKUNULMUYOR!
    end

    local toggleKey = cfg.ToggleKey or Enum.KeyCode.RightShift
    local uiVisible = true
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == toggleKey then
            uiVisible = not uiVisible
            screenGui.Enabled = uiVisible
        end
    end)

    -- Opening Animation
    mainFrame.Position = UDim2.new(originalMainPos.X.Scale, originalMainPos.X.Offset, originalMainPos.Y.Scale, originalMainPos.Y.Offset + 80)
    mainScale.Scale = 0.96

    task.spawn(function()
        task.wait(0.05)
        Tween(mainFrame, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = originalMainPos})
        Tween(mainScale, TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = 1.01})
        task.wait(0.25)
        Tween(mainScale, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1.0})
    end)

    -- Counter
    local fpsTitleLabel = screenGui:FindFirstChild("CustomText", true)
    local fpsValueLabel = screenGui:FindFirstChild("CustomTxt", true)
    local counterConnection = nil

    if cfg.TopRightCounter and cfg.TopRightCounter.Enabled then
        if fpsTitleLabel and fpsTitleLabel:IsA("TextLabel") then
            fpsTitleLabel.Visible = true
            FormatTitleText(fpsTitleLabel, cfg.TopRightCounter.Title or "FPS", cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, false)
            fpsTitleLabel.TextSize = 12
        end

        if fpsValueLabel and fpsValueLabel:IsA("TextLabel") then
            fpsValueLabel.Visible = true
            FormatTitleText(fpsValueLabel, "", cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, false)
            fpsValueLabel.TextSize = 12

            if cfg.TopRightCounter.CustomValue then
                fpsValueLabel.Text = tostring(cfg.TopRightCounter.CustomValue)
            else
                local sec, frames = 0, 0
                counterConnection = RunService.RenderStepped:Connect(function(dt)
                    sec = sec + dt
                    frames = frames + 1
                    if sec >= 0.5 then
                        local fps = math.floor(frames / sec)
                        local ping = 0
                        pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)

                        local outputText = ""
                        if cfg.TopRightCounter.ShowFPS and cfg.TopRightCounter.ShowPing then
                            outputText = tostring(fps) .. " (" .. tostring(ping) .. "ms)"
                        elseif cfg.TopRightCounter.ShowPing then
                            outputText = tostring(ping) .. "ms"
                        else
                            outputText = tostring(fps)
                        end

                        fpsValueLabel.Text = outputText
                        sec = 0; frames = 0
                    end
                end)
            end
        end
    else
        if fpsTitleLabel then fpsTitleLabel.Visible = false end
        if fpsValueLabel then fpsValueLabel.Visible = false end
    end

    MakeDraggable(topBar, mainFrame)
    MakeDraggable(miniTopBar, miniFrame)

    local function CloseAnimation(frame, scale)
        if counterConnection and typeof(counterConnection) == "RBXScriptConnection" then
            counterConnection:Disconnect()
            counterConnection = nil
        end
        local easeIn = TweenInfo.new(0.22, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
        local upPos = UDim2.new(frame.Position.X.Scale, frame.Position.X.Offset, frame.Position.Y.Scale, frame.Position.Y.Offset - 60)
        Tween(scale, TweenInfo.new(0.06), {Scale = 0.98})
        task.wait(0.06)
        Tween(scale, easeIn, {Scale = 0})
        Tween(frame, easeIn, {Position = upPos})
        task.wait(0.22)
        screenGui:Destroy()
    end

    closeBtn.MouseButton1Click:Connect(function() CloseAnimation(mainFrame, mainScale) end)
    if miniCloseBtn then miniCloseBtn.MouseButton1Click:Connect(function() CloseAnimation(miniFrame, miniScale) end) end

    minimizeBtn.MouseButton1Click:Connect(function()
        local easeIn = TweenInfo.new(0.22, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
        local currentMainPos = mainFrame.Position
        local shiftPos = UDim2.new(currentMainPos.X.Scale, currentMainPos.X.Offset + 30, currentMainPos.Y.Scale, currentMainPos.Y.Offset + 30)

        Tween(mainScale, easeIn, {Scale = 0})
        Tween(mainFrame, easeIn, {Position = shiftPos})
        task.wait(0.22)
        mainFrame.Visible = false
        mainFrame.Position = currentMainPos
        mainScale.Scale = 1

        miniFrame.Position = UDim2.new(currentMainPos.X.Scale, currentMainPos.X.Offset + (mainFrame.Size.X.Offset/2) - (originalMiniSize.X.Offset/2), currentMainPos.Y.Scale, currentMainPos.Y.Offset - 40)
        miniFrame.Size = originalMiniSize
        miniScale.Scale = 0.85
        miniFrame.Visible = true

        local easeOut = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        Tween(miniFrame, easeOut, {Position = UDim2.new(currentMainPos.X.Scale, currentMainPos.X.Offset + (mainFrame.Size.X.Offset/2) - (originalMiniSize.X.Offset/2), currentMainPos.Y.Scale, currentMainPos.Y.Offset)})
        Tween(miniScale, easeOut, {Scale = 1.03})
        task.wait(0.3)
        Tween(miniScale, TweenInfo.new(0.08), {Scale = 1.0})
    end)

    if maximizeBtn then
        maximizeBtn.MouseButton1Click:Connect(function()
            local currentMiniPos = miniFrame.Position
            local easeIn = TweenInfo.new(0.22, Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
            Tween(miniScale, easeIn, {Scale = 0})
            task.wait(0.22)
            miniFrame.Visible = false
            miniScale.Scale = 1

            local restorePos = UDim2.new(currentMiniPos.X.Scale, currentMiniPos.X.Offset - (mainFrame.Size.X.Offset/2) + (originalMiniSize.X.Offset/2), currentMiniPos.Y.Scale, currentMiniPos.Y.Offset)
            mainFrame.Position = UDim2.new(restorePos.X.Scale, restorePos.X.Offset, restorePos.Y.Scale, restorePos.Y.Offset + 80)
            mainScale.Scale = 0.96
            mainFrame.Visible = true

            local easeOutQuart2 = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
            Tween(mainFrame, easeOutQuart2, {Position = restorePos})
            Tween(mainScale, easeOutQuart2, {Scale = 1.01})
            task.wait(0.25)
            Tween(mainScale, TweenInfo.new(0.08), {Scale = 1.0})
        end)
    end

    local searchBox = nil
    for _, child in pairs(mainFrame:GetDescendants()) do
        if (child.Name == "SearchBar" or child.Name == "SearchBox") and child:IsA("TextBox") then
            searchBox = child
            searchBox.Font = cfg.Theme.Font or Enum.Font.GothamMedium
            break
        end
    end

    local WindowObj = { Tabs = {}, ActivePage = nil, Config = cfg }
    table.insert(SanderUI.Windows, WindowObj)

    function WindowObj:SetTitle(newTitle)
        if logoText and logoText:IsA("TextLabel") then
            logoText.RichText = true
            logoText.TextScaled = true
            logoText.Text = newTitle
        end
    end

    function WindowObj:SetCounterTitle(newCounterTitle)
        if fpsTitleLabel and fpsTitleLabel:IsA("TextLabel") then fpsTitleLabel.Text = newCounterTitle end
    end

    function WindowObj:SetCounterValue(customValText)
        if counterConnection and typeof(counterConnection) == "RBXScriptConnection" then
            counterConnection:Disconnect()
            counterConnection = nil
        end
        if fpsValueLabel and fpsValueLabel:IsA("TextLabel") then fpsValueLabel.Text = tostring(customValText) end
    end

    local function FilterActivePage()
        if not searchBox or not WindowObj.ActivePage then return end
        local searchText = string.lower(searchBox.Text)

        for _, item in pairs(WindowObj.ActivePage:GetChildren()) do
            if item:IsA("Frame") or item:IsA("TextButton") or item:IsA("ImageButton") then
                if item.Name == "UIListLayout" or item.Name == "UIPadding" then continue end
                local textLabel = item:FindFirstChild("TextTemplate", true) or item:FindFirstChild("ToggleText", true) or item:FindFirstChild("TextLabel", true) or item:FindFirstChild("Text1", true) or item
                local itemText = ""
                if textLabel:IsA("TextLabel") or textLabel:IsA("TextButton") then
                    itemText = string.lower(textLabel.Text)
                end

                if searchText == "" or string.find(itemText, searchText) then
                    item.Visible = true
                else
                    item.Visible = false
                end
            end
        end
    end

    if searchBox then
        searchBox:GetPropertyChangedSignal("Text"):Connect(FilterActivePage)
    end

    -- TAB CREATION ENGINE
    function WindowObj:CreateTab(tabConfig)
        local tabName = (type(tabConfig) == "table" and tabConfig.Name) or tostring(tabConfig or "Tab")
        local tabIcon = (type(tabConfig) == "table" and tabConfig.Icon) or nil

        local tabBtn = tabTemplate:Clone()
        tabBtn.Name = tabName
        tabBtn.Parent = sidebar
        tabBtn.Visible = true

        local textLabel = tabBtn:FindFirstChild("TextTemplate", true) or tabBtn:FindFirstChild("TextLabel", true) or tabBtn:FindFirstChild("Text1", true) or tabBtn
        if textLabel:IsA("TextLabel") or textLabel:IsA("TextButton") then
            FormatTitleText(textLabel, (tabIcon and tabIcon .. " " or "") .. tabName, cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, false)
            textLabel.TextSize = 13
        end

        local tabPage = pageTemplate:Clone()
        tabPage.Name = tabName
        tabPage.Parent = contentContainer
        tabPage.Visible = false
        tabPage.Position = pageTemplate.Position
        tabPage.ClipsDescendants = true

        local listLayout = tabPage:FindFirstChildOfClass("UIListLayout")
        if not listLayout then
            listLayout = Instance.new("UIListLayout")
            listLayout.Parent = tabPage
        end
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, cfg.Layout.ItemSpacing)
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local uiPadding = tabPage:FindFirstChildOfClass("UIPadding")
        if not uiPadding then
            uiPadding = Instance.new("UIPadding")
            uiPadding.Parent = tabPage
        end
        uiPadding.PaddingTop = UDim.new(0, cfg.Layout.PaddingTop)
        uiPadding.PaddingBottom = UDim.new(0, cfg.Layout.PaddingBottom)
        uiPadding.PaddingLeft = UDim.new(0, cfg.Layout.PaddingLeft)
        uiPadding.PaddingRight = UDim.new(0, cfg.Layout.PaddingRight)

        if tabPage:IsA("ScrollingFrame") then
            tabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
            tabPage.ScrollBarThickness = 4
            listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                tabPage.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + cfg.Layout.PaddingTop + cfg.Layout.PaddingBottom + 14)
            end)
        end

        local myIndicator = tabBtn:FindFirstChild("Indicator")
        if myIndicator then myIndicator.BackgroundTransparency = 1 end

        AddHoverScale(tabBtn)

        tabBtn.MouseButton1Click:Connect(function()
            if WindowObj.ActivePage == tabPage then return end

            if WindowObj.ActivePage then
                WindowObj.ActivePage.Visible = false
            end

            for _, tab in pairs(WindowObj.Tabs) do
                local ind = tab.Button:FindFirstChild("Indicator")
                if ind then Tween(ind, TweenInfo.new(0.2), {BackgroundTransparency = 1}) end
            end
            if myIndicator then Tween(myIndicator, TweenInfo.new(0.2), {BackgroundTransparency = 0}) end

            tabPage.Position = UDim2.new(pageTemplate.Position.X.Scale, pageTemplate.Position.X.Offset + 20, pageTemplate.Position.Y.Scale, pageTemplate.Position.Y.Offset)
            tabPage.Visible = true
            Tween(tabPage, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = pageTemplate.Position})

            WindowObj.ActivePage = tabPage

            if searchBox then
                searchBox.Text = ""
                FilterActivePage()
            end
        end)

        local TabObj = { Page = tabPage, Button = tabBtn, ElementCount = 0 }
        table.insert(WindowObj.Tabs, TabObj)

        if #WindowObj.Tabs == 1 then
            tabPage.Visible = true
            WindowObj.ActivePage = tabPage
            if myIndicator then myIndicator.BackgroundTransparency = 0 end
        end

        local function GetNextLayoutOrder()
            TabObj.ElementCount = TabObj.ElementCount + 1
            return TabObj.ElementCount
        end

        -- 1. CREATE BUTTON
        function TabObj:CreateButton(btnConfig)
            btnConfig = btnConfig or {}
            local btnName = btnConfig.Name or "Button"
            local newBtn = buttonTemplate:Clone()
            newBtn.Name = btnName
            newBtn.Parent = tabPage
            newBtn.Visible = true
            newBtn.LayoutOrder = GetNextLayoutOrder()

            local btnText = EnsureTextTemplate(newBtn)
            ApplyPremiumStroke(newBtn, cfg.Theme)
            ClearTemplateExtras(newBtn, btnText)

            local cardWidth = newBtn.AbsoluteSize.X > 0 and newBtn.AbsoluteSize.X or 220
            local autoH = CalculateCardHeight(btnName, cfg.Theme.Font, 13, cardWidth - 20, cfg.Layout.ButtonHeight)
            newBtn.Size = UDim2.new(1, 0, 0, autoH)

            if btnText and btnText:IsA("TextLabel") then
                FormatTitleText(btnText, btnName, cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, true)
                btnText.Size = UDim2.new(1, -20, 1, 0)
                btnText.Position = UDim2.new(0.5, 0, 0.5, 0)
                btnText.AnchorPoint = Vector2.new(0.5, 0.5)
                btnText.TextXAlignment = Enum.TextXAlignment.Center
                btnText.TextSize = 13
            end

            if btnConfig.Tooltip then AttachTooltip(newBtn, btnConfig.Tooltip) end
            AddHoverScale(newBtn)
            AddPressScale(newBtn, btnConfig.Callback)
            FilterActivePage()

            return { SetText = function(_, txt) if btnText then btnText.Text = txt end end }
        end

        -- 1.5 CREATE LABEL
        function TabObj:CreateLabel(labelConfig)
            labelConfig = labelConfig or {}
            local labelTextStr = labelConfig.Text or "Label"

            local newLabel = Instance.new("Frame")
            newLabel.Name = "Label_" .. string.sub(labelTextStr, 1, 10)
            newLabel.Parent = tabPage
            newLabel.Visible = true
            newLabel.LayoutOrder = GetNextLayoutOrder()
            newLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
            newLabel.BackgroundTransparency = 1
            newLabel.BorderSizePixel = 0

            local cardWidth = 220
            if tabPage.AbsoluteSize.X > 0 then cardWidth = tabPage.AbsoluteSize.X end
            local autoH = CalculateCardHeight(labelTextStr, cfg.Theme.Font, 13, cardWidth - 20, 25)
            newLabel.Size = UDim2.new(1, 0, 0, autoH)

            local lblText = Instance.new("TextLabel")
            lblText.Parent = newLabel
            lblText.Size = UDim2.new(1, -20, 1, 0)
            lblText.Position = UDim2.new(0, 10, 0, 0)
            lblText.BackgroundTransparency = 1
            FormatTitleText(lblText, labelTextStr, cfg.Theme.Font or Enum.Font.Gotham, cfg.Theme.SubTextColor or Color3.fromRGB(170, 170, 185), false)
            lblText.TextXAlignment = Enum.TextXAlignment.Left
            lblText.TextSize = 12

            FilterActivePage()

            return {
                SetText = function(_, txt)
                    if lblText then
                        lblText.Text = txt
                        local newH = CalculateCardHeight(txt, cfg.Theme.Font, 13, cardWidth - 20, 25)
                        newLabel.Size = UDim2.new(1, 0, 0, newH)
                    end
                end
            }
        end

        -- 2. CREATE ICON BUTTON
        function TabObj:CreateIconButton(btnConfig)
            btnConfig = btnConfig or {}
            local btnName = btnConfig.Name or "Icon Button"
            local iconAsset = btnConfig.Icon or "rbxassetid://6031075931"

            local newBtn = buttonTemplate:Clone()
            newBtn.Name = "Icon_" .. btnName
            newBtn.Parent = tabPage
            newBtn.Visible = true
            newBtn.LayoutOrder = GetNextLayoutOrder()

            local btnText = EnsureTextTemplate(newBtn)
            ApplyPremiumStroke(newBtn, cfg.Theme)
            ClearTemplateExtras(newBtn, btnText)

            local cardWidth = newBtn.AbsoluteSize.X > 0 and newBtn.AbsoluteSize.X or 220
            local autoH = CalculateCardHeight(btnName, cfg.Theme.Font, 13, cardWidth - 50, cfg.Layout.ButtonHeight)
            newBtn.Size = UDim2.new(1, 0, 0, autoH)

            local iconImg = Instance.new("ImageLabel")
            iconImg.Parent = newBtn
            iconImg.Position = UDim2.new(0, 10, 0.5, 0)
            iconImg.AnchorPoint = Vector2.new(0, 0.5)
            iconImg.Size = UDim2.new(0, 20, 0, 20)
            iconImg.Image = iconAsset
            iconImg.BackgroundTransparency = 1

            if btnText and btnText:IsA("TextLabel") then
                FormatTitleText(btnText, btnName, cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, true)
                btnText.Position = UDim2.new(0, 38, 0.5, 0)
                btnText.AnchorPoint = Vector2.new(0, 0.5)
                btnText.Size = UDim2.new(1, -48, 1, 0)
                btnText.TextXAlignment = Enum.TextXAlignment.Left
                btnText.TextSize = 13
            end

            if btnConfig.Tooltip then AttachTooltip(newBtn, btnConfig.Tooltip) end
            AddHoverScale(newBtn)
            AddPressScale(newBtn, btnConfig.Callback)
            FilterActivePage()
        end

        -- 3. CREATE BADGE BUTTON
        function TabObj:CreateBadgeButton(btnConfig)
            local btnConfig = btnConfig or {}
            local btnName = btnConfig.Name or "Badge Button"
            local badgeText = btnConfig.BadgeText or "NEW"
            local badgeColor = btnConfig.BadgeColor or cfg.Theme.Accent

            local newBtn = buttonTemplate:Clone()
            newBtn.Name = "Badge_" .. btnName
            newBtn.Parent = tabPage
            newBtn.Visible = true
            newBtn.LayoutOrder = GetNextLayoutOrder()

            local btnText = EnsureTextTemplate(newBtn)
            ApplyPremiumStroke(newBtn, cfg.Theme)
            ClearTemplateExtras(newBtn, btnText)

            local cardWidth = newBtn.AbsoluteSize.X > 0 and newBtn.AbsoluteSize.X or 220
            local autoH = CalculateCardHeight(btnName, cfg.Theme.Font, 13, cardWidth - 85, cfg.Layout.ButtonHeight)
            newBtn.Size = UDim2.new(1, 0, 0, autoH)

            local badgeLbl = Instance.new("TextLabel")
            badgeLbl.Parent = newBtn
            badgeLbl.AnchorPoint = Vector2.new(1, 0.5)
            badgeLbl.Position = UDim2.new(1, -10, 0.5, 0)
            badgeLbl.Size = UDim2.new(0, 60, 0, 20)
            FormatTitleText(badgeLbl, badgeText, cfg.Theme.BoldFont or Enum.Font.GothamBold, Color3.fromRGB(255, 255, 255), false)
            badgeLbl.BackgroundColor3 = badgeColor
            badgeLbl.TextSize = 11
            badgeLbl.TextXAlignment = Enum.TextXAlignment.Center
            Instance.new("UICorner", badgeLbl).CornerRadius = UDim.new(0, 4)

            if btnText and btnText:IsA("TextLabel") then
                FormatTitleText(btnText, btnName, cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, true)
                btnText.Position = UDim2.new(0, 12, 0.5, 0)
                btnText.AnchorPoint = Vector2.new(0, 0.5)
                btnText.Size = UDim2.new(1, -85, 1, 0)
                btnText.TextXAlignment = Enum.TextXAlignment.Left
                btnText.TextSize = 13
            end

            if btnConfig.Tooltip then AttachTooltip(newBtn, btnConfig.Tooltip) end
            AddHoverScale(newBtn)
            AddPressScale(newBtn, btnConfig.Callback)
            FilterActivePage()
        end

        -- 4. CREATE MINI BUTTON
        function TabObj:CreateMiniButton(btnConfig)
            btnConfig = btnConfig or {}
            local btnName = btnConfig.Name or "Mini Button"
            local newBtn = buttonTemplate:Clone()
            newBtn.Name = "Mini_" .. btnName
            newBtn.Parent = tabPage
            newBtn.Visible = true
            newBtn.LayoutOrder = GetNextLayoutOrder()

            local btnText = EnsureTextTemplate(newBtn)
            ApplyPremiumStroke(newBtn, cfg.Theme)
            ClearTemplateExtras(newBtn, btnText)
            newBtn.Size = UDim2.new(1, 0, 0, cfg.Layout.MiniButtonHeight)

            if btnText and btnText:IsA("TextLabel") then
                FormatTitleText(btnText, btnName, cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, false)
                btnText.Size = UDim2.new(1, -16, 1, 0)
                btnText.Position = UDim2.new(0.5, 0, 0.5, 0)
                btnText.AnchorPoint = Vector2.new(0.5, 0.5)
                btnText.TextXAlignment = Enum.TextXAlignment.Center
                btnText.TextSize = 12
            end

            if btnConfig.Tooltip then AttachTooltip(newBtn, btnConfig.Tooltip) end
            AddHoverScale(newBtn)
            AddPressScale(newBtn, btnConfig.Callback)
            FilterActivePage()
        end

        -- 5. CREATE TOGGLE
        function TabObj:CreateToggle(toggleConfig)
            toggleConfig = toggleConfig or {}
            local toggleName = toggleConfig.Name or "Toggle"
            local flag = toggleConfig.Flag
            local defaultState = (flag and SanderUI.Flags[flag] ~= nil) and SanderUI.Flags[flag] or (toggleConfig.Default or false)

            local newTog = toggleTemplate:Clone()
            newTog.Name = toggleName
            newTog.Parent = tabPage
            newTog.Visible = true
            newTog.LayoutOrder = GetNextLayoutOrder()

            local tText = EnsureTextTemplate(newTog)
            ApplyPremiumStroke(newTog, cfg.Theme)
            local cardWidth = newTog.AbsoluteSize.X > 0 and newTog.AbsoluteSize.X or 220
            local autoH = CalculateCardHeight(toggleName, cfg.Theme.Font, 13, cardWidth - 65, cfg.Layout.ToggleHeight)
            newTog.Size = UDim2.new(1, 0, 0, autoH)

            if tText and (tText:IsA("TextLabel") or tText:IsA("TextButton")) then
                FormatTitleText(tText, toggleName, cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, true)
                tText.AnchorPoint = Vector2.new(0, 0.5)
                tText.Position = UDim2.new(0, 12, 0.5, 0)
                tText.Size = UDim2.new(1, -65, 0.9, 0)
                tText.TextXAlignment = Enum.TextXAlignment.Left
                tText.TextSize = 13
            end

            local buttons = {}
            for _, child in pairs(newTog:GetChildren()) do
                if child.Name == "ToggleButton" or (child:IsA("GuiObject") and child ~= tText and not child:IsA("UIBase")) then
                    table.insert(buttons, child)
                end
            end

            table.sort(buttons, function(a, b)
                local aX = a.Position.X.Scale * 1000 + a.Position.X.Offset
                local bX = b.Position.X.Scale * 1000 + b.Position.X.Offset
                return aX < bX
            end)

            local offButton = buttons[1]
            local onButton = buttons[2]

            
            -- PREMIUM TOGGLE DESIGN
            local toggleBg = Instance.new("Frame")
            toggleBg.Name = "PremiumToggleBg"
            toggleBg.Parent = newTog
            toggleBg.AnchorPoint = Vector2.new(1, 0.5)
            toggleBg.Position = UDim2.new(1, -12, 0.5, 0)
            toggleBg.Size = UDim2.new(0, 42, 0, 22)
            toggleBg.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
            Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
            
            local toggleKnob = Instance.new("Frame")
            toggleKnob.Name = "PremiumToggleKnob"
            toggleKnob.Parent = toggleBg
            toggleKnob.AnchorPoint = Vector2.new(0, 0.5)
            toggleKnob.Position = UDim2.new(0, 2, 0.5, 0)
            toggleKnob.Size = UDim2.new(0, 18, 0, 18)
            toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", toggleKnob).CornerRadius = UDim.new(1, 0)

            -- Hide original buttons if any
            if offButton then offButton.Visible = false end
            if onButton then onButton.Visible = false end

            local state = defaultState
            if flag then SanderUI.Flags[flag] = state end

            local function UpdateToggleState(anim)
                if state then
                    Tween(toggleBg, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = cfg.Theme.Accent})
                    Tween(toggleKnob, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 0.5, 0)})
                else
                    Tween(toggleBg, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(35, 35, 42)})
                    Tween(toggleKnob, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 2, 0.5, 0)})
                end
            end
            UpdateToggleState(false)


            local clickArea = Instance.new("TextButton")
            clickArea.Name = "Hitbox"
            clickArea.Parent = newTog
            clickArea.Size = UDim2.new(1, 0, 1, 0)
            clickArea.BackgroundTransparency = 1
            clickArea.Text = ""
            clickArea.ZIndex = 10

            clickArea.MouseButton1Click:Connect(function()
                state = not state
                if flag then SanderUI.Flags[flag] = state end
                UpdateToggleState(true)
                SafeCallback(toggleConfig.Callback, state)
            end)

            if toggleConfig.Tooltip then AttachTooltip(newTog, toggleConfig.Tooltip) end
            AddHoverScale(newTog)
            FilterActivePage()

            local ret = {
                Set = function(_, newState)
                    state = newState
                    if flag then SanderUI.Flags[flag] = state end
                    UpdateToggleState(true)
                    SafeCallback(toggleConfig.Callback, state)
                end
            }
            if flag then
                SanderUI.FlagComponents[flag] = ret
            end
            return ret
        end

        -- 6. CREATE MINI TOGGLE
        function TabObj:CreateMiniToggle(toggleConfig)
            toggleConfig = toggleConfig or {}
            local toggleName = toggleConfig.Name or "Mini Toggle"
            local flag = toggleConfig.Flag
            local defaultState = (flag and SanderUI.Flags[flag] ~= nil) and SanderUI.Flags[flag] or (toggleConfig.Default or false)

            local newTog = toggleTemplate:Clone()
            newTog.Name = "Mini_" .. toggleName
            newTog.Parent = tabPage
            newTog.Visible = true
            newTog.LayoutOrder = GetNextLayoutOrder()
            newTog.Size = UDim2.new(1, 0, 0, cfg.Layout.MiniToggleHeight)

            local tText = EnsureTextTemplate(newTog)
            ApplyPremiumStroke(newTog, cfg.Theme)
            if tText and (tText:IsA("TextLabel") or tText:IsA("TextButton")) then
                FormatTitleText(tText, toggleName, cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, false)
                tText.AnchorPoint = Vector2.new(0, 0.5)
                tText.Position = UDim2.new(0, 10, 0.5, 0)
                tText.Size = UDim2.new(1, -55, 0.9, 0)
                tText.TextXAlignment = Enum.TextXAlignment.Left
                tText.TextSize = 12
            end

            local buttons = {}
            for _, child in pairs(newTog:GetChildren()) do
                if child.Name == "ToggleButton" or (child:IsA("GuiObject") and child ~= tText and not child:IsA("UIBase")) then
                    table.insert(buttons, child)
                end
            end

            table.sort(buttons, function(a, b)
                local aX = a.Position.X.Scale * 1000 + a.Position.X.Offset
                local bX = b.Position.X.Scale * 1000 + b.Position.X.Offset
                return aX < bX
            end)

            local offButton = buttons[1]
            local onButton = buttons[2]

            
            -- PREMIUM TOGGLE DESIGN
            local toggleBg = Instance.new("Frame")
            toggleBg.Name = "PremiumToggleBg"
            toggleBg.Parent = newTog
            toggleBg.AnchorPoint = Vector2.new(1, 0.5)
            toggleBg.Position = UDim2.new(1, -12, 0.5, 0)
            toggleBg.Size = UDim2.new(0, 42, 0, 22)
            toggleBg.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
            Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
            
            local toggleKnob = Instance.new("Frame")
            toggleKnob.Name = "PremiumToggleKnob"
            toggleKnob.Parent = toggleBg
            toggleKnob.AnchorPoint = Vector2.new(0, 0.5)
            toggleKnob.Position = UDim2.new(0, 2, 0.5, 0)
            toggleKnob.Size = UDim2.new(0, 18, 0, 18)
            toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Instance.new("UICorner", toggleKnob).CornerRadius = UDim.new(1, 0)

            -- Hide original buttons if any
            if offButton then offButton.Visible = false end
            if onButton then onButton.Visible = false end

            local state = defaultState
            if flag then SanderUI.Flags[flag] = state end

            local function UpdateToggleState(anim)
                if state then
                    Tween(toggleBg, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = cfg.Theme.Accent})
                    Tween(toggleKnob, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -20, 0.5, 0)})
                else
                    Tween(toggleBg, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(35, 35, 42)})
                    Tween(toggleKnob, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 2, 0.5, 0)})
                end
            end
            UpdateToggleState(false)


            local clickArea = Instance.new("TextButton")
            clickArea.Name = "Hitbox"
            clickArea.Parent = newTog
            clickArea.Size = UDim2.new(1, 0, 1, 0)
            clickArea.BackgroundTransparency = 1
            clickArea.Text = ""
            clickArea.ZIndex = 10

            clickArea.MouseButton1Click:Connect(function()
                state = not state
                if flag then SanderUI.Flags[flag] = state end
                UpdateToggleState(true)
                SafeCallback(toggleConfig.Callback, state)
            end)

            if toggleConfig.Tooltip then AttachTooltip(newTog, toggleConfig.Tooltip) end
            AddHoverScale(newTog)
            FilterActivePage()

            local ret = {
                Set = function(_, newState)
                    state = newState
                    if flag then SanderUI.Flags[flag] = state end
                    UpdateToggleState(true)
                    SafeCallback(toggleConfig.Callback, state)
                end
            }
            if flag then
                SanderUI.FlagComponents[flag] = ret
            end
            return ret
        end

        -- 7. CREATE STEP BUTTON
        function TabObj:CreateStepButton(stepConfig)
            stepConfig = stepConfig or {}
            local stepName = stepConfig.Name or "Stepper"
            local minVal = stepConfig.Min or 0
            local maxVal = stepConfig.Max or 100
            local step = stepConfig.Step or 1
            local value = math.clamp(stepConfig.Default or minVal, minVal, maxVal)

            local newStep = buttonTemplate:Clone()
            newStep.Name = "Step_" .. stepName
            newStep.Parent = tabPage
            newStep.Visible = true
            newStep.LayoutOrder = GetNextLayoutOrder()

            local titleText = EnsureTextTemplate(newStep)
            ApplyPremiumStroke(newStep, cfg.Theme)
            ClearTemplateExtras(newStep, titleText)

            local cardWidth = newStep.AbsoluteSize.X > 0 and newStep.AbsoluteSize.X or 220
            local autoH = CalculateCardHeight(stepName .. ": " .. tostring(value), cfg.Theme.Font, 13, cardWidth - 95, cfg.Layout.ButtonHeight)
            newStep.Size = UDim2.new(1, 0, 0, autoH)

            if titleText then
                FormatTitleText(titleText, stepName .. ": " .. tostring(value), cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, true)
                titleText.Position = UDim2.new(0, 12, 0.5, 0)
                titleText.AnchorPoint = Vector2.new(0, 0.5)
                titleText.Size = UDim2.new(1, -95, 0.9, 0)
                titleText.TextXAlignment = Enum.TextXAlignment.Left
                titleText.TextSize = 13
            end

            local minusBtn = Instance.new("TextButton")
            minusBtn.Parent = newStep
            minusBtn.AnchorPoint = Vector2.new(1, 0.5)
            minusBtn.Position = UDim2.new(1, -48, 0.5, 0)
            minusBtn.Size = UDim2.new(0, 32, 0, 22)
            FormatTitleText(minusBtn, "-", cfg.Theme.BoldFont or Enum.Font.GothamBold, cfg.Theme.TextColor, false)
            minusBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
            minusBtn.TextSize = 15
            Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 4)

            local plusBtn = Instance.new("TextButton")
            plusBtn.Parent = newStep
            plusBtn.AnchorPoint = Vector2.new(1, 0.5)
            plusBtn.Position = UDim2.new(1, -10, 0.5, 0)
            plusBtn.Size = UDim2.new(0, 32, 0, 22)
            FormatTitleText(plusBtn, "+", cfg.Theme.BoldFont or Enum.Font.GothamBold, cfg.Theme.TextColor, false)
            plusBtn.BackgroundColor3 = cfg.Theme.Accent
            plusBtn.TextSize = 15
            Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 4)

            local function UpdateVal(delta)
                value = math.clamp(value + delta, minVal, maxVal)
                if titleText then titleText.Text = stepName .. ": " .. tostring(value) end
                SafeCallback(stepConfig.Callback, value)
            end

            minusBtn.MouseButton1Click:Connect(function() UpdateVal(-step) end)
            plusBtn.MouseButton1Click:Connect(function() UpdateVal(step) end)

            if stepConfig.Tooltip then AttachTooltip(newStep, stepConfig.Tooltip) end
            AddHoverScale(newStep)
            FilterActivePage()
        end

        -- 8. CREATE SEGMENTED CONTROL
        function TabObj:CreateSegmentedControl(segConfig)
            segConfig = segConfig or {}
            local segName = segConfig.Name or "Segment"
            local options = segConfig.Options or {"Low", "Medium", "High"}
            local selected = segConfig.Default or options[1] or ""

            local segFrame = buttonTemplate:Clone()
            segFrame.Name = "Segment_" .. segName
            segFrame.Parent = tabPage
            segFrame.Visible = true
            segFrame.LayoutOrder = GetNextLayoutOrder()

            local titleText = EnsureTextTemplate(segFrame)
            ApplyPremiumStroke(segFrame, cfg.Theme)
            ClearTemplateExtras(segFrame, titleText)

            segFrame.Size = UDim2.new(1, 0, 0, 56)

            if titleText then
                FormatTitleText(titleText, segName, cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, false)
                titleText.Position = UDim2.new(0, 12, 0, 6)
                titleText.Size = UDim2.new(1, -24, 0, 18)
                titleText.TextXAlignment = Enum.TextXAlignment.Left
                titleText.TextSize = 13
            end

            local barFrame = Instance.new("Frame")
            barFrame.Parent = segFrame
            barFrame.Position = UDim2.new(0, 10, 0, 26)
            barFrame.Size = UDim2.new(1, -20, 0, 24)
            barFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            barFrame.BorderSizePixel = 0
            Instance.new("UICorner", barFrame).CornerRadius = UDim.new(0, 4)

            local count = #options
            for i, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Parent = barFrame
                optBtn.Size = UDim2.new(1 / count, 0, 1, 0)
                optBtn.Position = UDim2.new((i - 1) / count, 0, 0, 0)
                FormatTitleText(optBtn, tostring(opt), cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, false)
                optBtn.TextSize = 11
                optBtn.BackgroundColor3 = (opt == selected) and cfg.Theme.Accent or Color3.fromRGB(35, 35, 40)
                optBtn.BorderSizePixel = 0
                Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)

                optBtn.MouseButton1Click:Connect(function()
                    selected = opt
                    for _, child in pairs(barFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child.BackgroundColor3 = (child.Text == opt) and cfg.Theme.Accent or Color3.fromRGB(35, 35, 40)
                        end
                    end
                    SafeCallback(segConfig.Callback, selected)
                end)
            end

            if segConfig.Tooltip then AttachTooltip(segFrame, segConfig.Tooltip) end
            AddHoverScale(segFrame)
            FilterActivePage()
        end

        -- 9. CREATE COPY BUTTON
        function TabObj:CreateCopyButton(copyConfig)
            copyConfig = copyConfig or {}
            local copyName = copyConfig.Name or "Copy Text"
            local copyTextStr = copyConfig.TextToCopy or "https://discord.gg/sanderui"

            local newBtn = buttonTemplate:Clone()
            newBtn.Name = "Copy_" .. copyName
            newBtn.Parent = tabPage
            newBtn.Visible = true
            newBtn.LayoutOrder = GetNextLayoutOrder()

            local btnText = EnsureTextTemplate(newBtn)
            ApplyPremiumStroke(newBtn, cfg.Theme)
            ClearTemplateExtras(newBtn, btnText)

            newBtn.Size = UDim2.new(1, 0, 0, cfg.Layout.ButtonHeight)

            if btnText and btnText:IsA("TextLabel") then
                FormatTitleText(btnText, "📋 " .. copyName, cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, true)
                btnText.Size = UDim2.new(1, -20, 1, 0)
                btnText.Position = UDim2.new(0.5, 0, 0.5, 0)
                btnText.AnchorPoint = Vector2.new(0.5, 0.5)
                btnText.TextXAlignment = Enum.TextXAlignment.Center
                btnText.TextSize = 13
            end

            newBtn.MouseButton1Click:Connect(function()
                if setclipboard then pcall(function() setclipboard(copyTextStr) end) end
                SanderUI:Notify({ Title = "Kopyalandı!", Content = copyTextStr .. " panoya aktarıldı.", Duration = 3 })
                SafeCallback(copyConfig.Callback, copyTextStr)
            end)

            if copyConfig.Tooltip then AttachTooltip(newBtn, copyConfig.Tooltip) end
            AddHoverScale(newBtn)
            FilterActivePage()
        end

        -- 10. CREATE SLIDER
        function TabObj:CreateSlider(sliderConfig)
            sliderConfig = sliderConfig or {}
            local sliderName = sliderConfig.Name or "Slider"
            local minVal = sliderConfig.Min or 0
            local maxVal = sliderConfig.Max or 100
            local step = sliderConfig.Step or 1
            local flag = sliderConfig.Flag
            local defaultVal = (flag and SanderUI.Flags[flag] ~= nil) and SanderUI.Flags[flag] or math.clamp(sliderConfig.Default or minVal, minVal, maxVal)

            local newSlider = buttonTemplate:Clone()
            newSlider.Name = sliderName
            newSlider.Parent = tabPage
            newSlider.Visible = true
            newSlider.LayoutOrder = GetNextLayoutOrder()

            local titleText = EnsureTextTemplate(newSlider)
            ApplyPremiumStroke(newSlider, cfg.Theme)
            ClearTemplateExtras(newSlider, titleText)

            local cardWidth = newSlider.AbsoluteSize.X > 0 and newSlider.AbsoluteSize.X or 220
            local autoH = CalculateCardHeight(sliderName .. ": " .. tostring(defaultVal), cfg.Theme.Font, 13, cardWidth - 24, cfg.Layout.SliderHeight)
            newSlider.Size = UDim2.new(1, 0, 0, autoH)

            if titleText then
                titleText.AnchorPoint = Vector2.new(0, 0)
                titleText.Position = UDim2.new(0, 12, 0, 5)
                titleText.Size = UDim2.new(1, -24, 0, autoH - 18)
                FormatTitleText(titleText, sliderName .. ": " .. tostring(defaultVal), cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, false)
                titleText.TextXAlignment = Enum.TextXAlignment.Left
                titleText.TextSize = 13
            end

            local trackFrame = Instance.new("Frame")
            trackFrame.Name = "SliderTrack"
            trackFrame.Parent = newSlider
            trackFrame.AnchorPoint = Vector2.new(0, 1)
            trackFrame.Position = UDim2.new(0, 12, 1, -8)
            trackFrame.Size = UDim2.new(1, -24, 0, 8)
            trackFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            trackFrame.BorderSizePixel = 0
            Instance.new("UICorner", trackFrame).CornerRadius = UDim.new(1, 0)

            local fillFrame = Instance.new("Frame")
            fillFrame.Name = "SliderFill"
            fillFrame.Parent = trackFrame
            fillFrame.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
            fillFrame.BackgroundColor3 = cfg.Theme.Accent
            fillFrame.BorderSizePixel = 0
            Instance.new("UICorner", fillFrame).CornerRadius = UDim.new(1, 0)

            local value = defaultVal
            if flag then SanderUI.Flags[flag] = value end
            local dragging = false

            local function Snap(val)
                if step > 0 then return math.floor((val - minVal) / step + 0.5) * step + minVal end
                return val
            end

            local function UpdateSlider(inputPos)
                local percent = math.clamp((inputPos.X - trackFrame.AbsolutePosition.X) / trackFrame.AbsoluteSize.X, 0, 1)
                local rawVal = minVal + (maxVal - minVal) * percent
                value = Snap(rawVal)
                value = math.clamp(value, minVal, maxVal)
                if flag then SanderUI.Flags[flag] = value end

                fillFrame.Size = UDim2.new((value - minVal) / (maxVal - minVal), 0, 1, 0)
                if titleText then titleText.Text = sliderName .. ": " .. tostring(value) end
                SafeCallback(sliderConfig.Callback, value)
            end

            trackFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    UpdateSlider(input.Position)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateSlider(input.Position)
                end
            end)

            if sliderConfig.Tooltip then AttachTooltip(newSlider, sliderConfig.Tooltip) end
            AddHoverScale(newSlider)
            FilterActivePage()

            local ret = {
                Set = function(_, newVal)
                    value = math.clamp(Snap(newVal), minVal, maxVal)
                    if flag then SanderUI.Flags[flag] = value end
                    fillFrame.Size = UDim2.new((value - minVal) / (maxVal - minVal), 0, 1, 0)
                    if titleText then titleText.Text = sliderName .. ": " .. tostring(value) end
                    SafeCallback(sliderConfig.Callback, value)
                end
            }
            if flag then
                SanderUI.FlagComponents[flag] = ret
            end
            return ret
        end

        -- 11. CREATE DROPDOWN
        function TabObj:CreateDropdown(dropdownConfig)
            dropdownConfig = dropdownConfig or {}
            local dropName = dropdownConfig.Name or "Dropdown"
            local options = dropdownConfig.Options or {"Option 1", "Option 2"}
            local isMulti = dropdownConfig.MultiSelect or false
            local selected = dropdownConfig.Default or (isMulti and {} or options[1] or "")

            local dropFrame = buttonTemplate:Clone()
            dropFrame.Name = dropName
            dropFrame.Parent = tabPage
            dropFrame.Visible = true
            dropFrame.LayoutOrder = GetNextLayoutOrder()

            local titleText = EnsureTextTemplate(dropFrame)
            ApplyPremiumStroke(dropFrame, cfg.Theme)
            ClearTemplateExtras(dropFrame, titleText)

            local initialValStr = isMulti and table.concat(selected, ", ") or tostring(selected)
            local cardWidth = dropFrame.AbsoluteSize.X > 0 and dropFrame.AbsoluteSize.X or 220
            local autoH = CalculateCardHeight(dropName .. ": " .. initialValStr, cfg.Theme.Font, 13, cardWidth - 40, cfg.Layout.DropdownHeight)
            dropFrame.Size = UDim2.new(1, 0, 0, autoH)
            dropFrame.ClipsDescendants = true

            if titleText then
                FormatTitleText(titleText, dropName .. ": " .. initialValStr, cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, false)
                titleText.TextXAlignment = Enum.TextXAlignment.Left
                titleText.Position = UDim2.new(0, 12, 0, 0)
                titleText.Size = UDim2.new(1, -40, 0, autoH)
                titleText.TextSize = 13
            end

            local arrowIcon = Instance.new("TextLabel")
            arrowIcon.Name = "ArrowIcon"
            arrowIcon.Parent = dropFrame
            arrowIcon.AnchorPoint = Vector2.new(1, 0)
            arrowIcon.Position = UDim2.new(1, -12, 0, 0)
            arrowIcon.Size = UDim2.new(0, 24, 0, autoH)
            arrowIcon.BackgroundTransparency = 1
            arrowIcon.Text = "▼"
            arrowIcon.TextColor3 = cfg.Theme.SubTextColor or Color3.fromRGB(160, 160, 175)
            arrowIcon.Font = Enum.Font.GothamMedium
            arrowIcon.TextSize = 14

            local container = Instance.new("Frame")
            container.Name = "OptionsContainer"
            container.Parent = dropFrame
            container.Position = UDim2.new(0, 0, 0, autoH)
            container.Size = UDim2.new(1, 0, 0, #options * 30)
            container.BackgroundTransparency = 1

            local list = Instance.new("UIListLayout", container)
            list.SortOrder = Enum.SortOrder.LayoutOrder

            local isOpen = false

            local function UpdateOptionVisuals()
                for _, child in pairs(container:GetChildren()) do
                    if child:IsA("TextButton") then
                        local optText = string.sub(child.Text, 5) -- Remove "  • "
                        local check = child:FindFirstChild("CheckIcon")
                        if check then
                            if isMulti then
                                check.Visible = table.find(selected, optText) ~= nil
                            else
                                check.Visible = (selected == optText)
                            end
                        end
                    end
                end
            end

            for _, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Parent = container
                optBtn.Size = UDim2.new(1, 0, 0, 30)
                FormatTitleText(optBtn, "  • " .. tostring(opt), cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, false)
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                optBtn.BorderSizePixel = 0
                optBtn.TextSize = 13

                local checkIcon = Instance.new("TextLabel")
                checkIcon.Name = "CheckIcon"
                checkIcon.Parent = optBtn
                checkIcon.AnchorPoint = Vector2.new(1, 0.5)
                checkIcon.Position = UDim2.new(1, -12, 0.5, 0)
                checkIcon.Size = UDim2.new(0, 20, 0, 20)
                checkIcon.BackgroundTransparency = 1
                checkIcon.Text = "✓"
                checkIcon.TextColor3 = cfg.Theme.Accent
                checkIcon.Font = Enum.Font.GothamBold
                checkIcon.TextSize = 14
                checkIcon.Visible = false

                optBtn.MouseButton1Click:Connect(function()
                    if isMulti then
                        local idx = table.find(selected, opt)
                        if idx then table.remove(selected, idx) else table.insert(selected, opt) end
                        if flag then SanderUI.Flags[flag] = selected end
                        if titleText then titleText.Text = dropName .. ": " .. table.concat(selected, ", ") end
                    else
                        selected = opt
                        if flag then SanderUI.Flags[flag] = selected end
                        if titleText then titleText.Text = dropName .. ": " .. tostring(selected) end
                        isOpen = false
                        Tween(dropFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, autoH) })
                        Tween(arrowIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Rotation = 0 })
                    end
                    UpdateOptionVisuals()
                    SafeCallback(dropdownConfig.Callback, selected)
                end)
            end
            UpdateOptionVisuals()

            dropFrame.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                local targetH = isOpen and (autoH + #options * 30) or autoH
                Tween(dropFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, targetH) })
                Tween(arrowIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Rotation = isOpen and 180 or 0 })
            end)

            if dropdownConfig.Tooltip then AttachTooltip(dropFrame, dropdownConfig.Tooltip) end
            AddHoverScale(dropFrame)
            FilterActivePage()

            local ret = {
                SetOptions = function(_, newOptions)
                    options = newOptions
                    for _, child in pairs(container:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    for _, opt in ipairs(options) do
                        local optBtn = Instance.new("TextButton")
                        optBtn.Parent = container
                        optBtn.Size = UDim2.new(1, 0, 0, 30)
                        FormatTitleText(optBtn, "  • " .. tostring(opt), cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, false)
                        optBtn.TextXAlignment = Enum.TextXAlignment.Left
                        optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                        optBtn.BorderSizePixel = 0
                        optBtn.TextSize = 13
                        optBtn.MouseButton1Click:Connect(function()
                            selected = opt
                            if flag then SanderUI.Flags[flag] = selected end
                            if titleText then titleText.Text = dropName .. ": " .. tostring(selected) end
                            isOpen = false
                            Tween(dropFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, autoH) })
                            SafeCallback(dropdownConfig.Callback, selected)
                        end)
                    end
                end,
                Set = function(_, newVal)
                    selected = newVal
                    if flag then SanderUI.Flags[flag] = selected end
                    local valStr = isMulti and table.concat(selected, ", ") or tostring(selected)
                    if titleText then titleText.Text = dropName .. ": " .. valStr end
                    SafeCallback(dropdownConfig.Callback, selected)
                end
            }
            if flag then
                SanderUI.Flags[flag] = selected
                SanderUI.FlagComponents[flag] = ret
            end
            return ret
        end

        -- 12. CREATE COLOR PICKER
        function TabObj:CreateColorPicker(cpConfig)
            cpConfig = cpConfig or {}
            local cpName = cpConfig.Name or "Color Picker"
            local color = cpConfig.Default or Color3.fromRGB(255, 0, 0)

            local cpFrame = buttonTemplate:Clone()
            cpFrame.Name = cpName
            cpFrame.Parent = tabPage
            cpFrame.Visible = true
            cpFrame.LayoutOrder = GetNextLayoutOrder()

            local titleText = EnsureTextTemplate(cpFrame)
            ApplyPremiumStroke(cpFrame, cfg.Theme)
            ClearTemplateExtras(cpFrame, titleText)

            local cardWidth = cpFrame.AbsoluteSize.X > 0 and cpFrame.AbsoluteSize.X or 220
            local autoH = CalculateCardHeight(cpName, cfg.Theme.Font, 13, cardWidth - 60, 42)
            cpFrame.Size = UDim2.new(1, 0, 0, autoH)

            if titleText then
                FormatTitleText(titleText, cpName, cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, true)
                titleText.TextXAlignment = Enum.TextXAlignment.Left
                titleText.Position = UDim2.new(0, 12, 0.5, 0)
                titleText.AnchorPoint = Vector2.new(0, 0.5)
                titleText.Size = UDim2.new(1, -60, 0.9, 0)
                titleText.TextSize = 13
            end

            local colorPreview = Instance.new("Frame")
            colorPreview.Name = "ColorPreview"
            colorPreview.Parent = cpFrame
            colorPreview.AnchorPoint = Vector2.new(1, 0.5)
            colorPreview.Position = UDim2.new(1, -12, 0.5, 0)
            colorPreview.Size = UDim2.new(0, 36, 0, 22)
            colorPreview.BackgroundColor3 = color
            colorPreview.BorderSizePixel = 0
            Instance.new("UICorner", colorPreview).CornerRadius = UDim.new(0, 4)

            if cpConfig.Tooltip then AttachTooltip(cpFrame, cpConfig.Tooltip) end
            AddHoverScale(cpFrame)
            FilterActivePage()

            local ret = {
                Set = function(_, newColor)
                    color = newColor
                    if flag then SanderUI.Flags[flag] = color end
                    colorPreview.BackgroundColor3 = color
                    SafeCallback(cpConfig.Callback, color)
                end
            }
            if flag then
                SanderUI.Flags[flag] = color
                SanderUI.FlagComponents[flag] = ret
            end
            return ret
        end

        -- 13. CREATE KEYBIND
        function TabObj:CreateKeybind(keybindConfig)
            keybindConfig = keybindConfig or {}
            local kbName = keybindConfig.Name or "Keybind"
            local currentKey = keybindConfig.Default or Enum.KeyCode.E

            local kbFrame = buttonTemplate:Clone()
            kbFrame.Name = kbName
            kbFrame.Parent = tabPage
            kbFrame.Visible = true
            kbFrame.LayoutOrder = GetNextLayoutOrder()

            local titleText = EnsureTextTemplate(kbFrame)
            ApplyPremiumStroke(kbFrame, cfg.Theme)
            ClearTemplateExtras(kbFrame, titleText)

            local cardWidth = kbFrame.AbsoluteSize.X > 0 and kbFrame.AbsoluteSize.X or 220
            local autoH = CalculateCardHeight(kbName, cfg.Theme.Font, 13, cardWidth - 100, cfg.Layout.KeybindHeight)
            kbFrame.Size = UDim2.new(1, 0, 0, autoH)

            if titleText then
                FormatTitleText(titleText, kbName, cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, true)
                titleText.TextXAlignment = Enum.TextXAlignment.Left
                titleText.Position = UDim2.new(0, 12, 0.5, 0)
                titleText.AnchorPoint = Vector2.new(0, 0.5)
                titleText.Size = UDim2.new(1, -100, 0.9, 0)
                titleText.TextSize = 13
            end

            local keyLabel = Instance.new("TextLabel")
            keyLabel.Parent = kbFrame
            keyLabel.AnchorPoint = Vector2.new(1, 0.5)
            keyLabel.Position = UDim2.new(1, -12, 0.5, 0)
            keyLabel.Size = UDim2.new(0, 80, 0, 24)
            FormatTitleText(keyLabel, "[" .. currentKey.Name .. "]", cfg.Theme.BoldFont or Enum.Font.GothamBold, cfg.Theme.Accent, false)
            keyLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            keyLabel.TextSize = 12
            keyLabel.TextXAlignment = Enum.TextXAlignment.Center
            Instance.new("UICorner", keyLabel).CornerRadius = UDim.new(0, 4)

            local listening = false

            kbFrame.MouseButton1Click:Connect(function()
                listening = true
                keyLabel.Text = "[...]"
            end)

            UserInputService.InputBegan:Connect(function(input, gpe)
                if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                    currentKey = input.KeyCode
                    listening = false
                    keyLabel.Text = "[" .. currentKey.Name .. "]"
                    SafeCallback(keybindConfig.Callback, currentKey)
                elseif not gpe and input.KeyCode == currentKey then
                    SafeCallback(keybindConfig.Callback, currentKey)
                end
            end)

            if keybindConfig.Tooltip then AttachTooltip(kbFrame, keybindConfig.Tooltip) end
            AddHoverScale(kbFrame)
            FilterActivePage()

            local ret = {
                Set = function(_, newKey)
                    currentKey = newKey
                    if flag then SanderUI.Flags[flag] = currentKey end
                    keyLabel.Text = "[" .. currentKey.Name .. "]"
                end
            }
            if flag then
                SanderUI.Flags[flag] = currentKey
                SanderUI.FlagComponents[flag] = ret
            end
            return ret
        end

        -- 14. CREATE INPUT
        function TabObj:CreateInput(inputConfig)
            inputConfig = inputConfig or {}
            local inputName = inputConfig.Name or "Input"
            local placeholder = inputConfig.Placeholder or "Metin..."

            local inputFrame = buttonTemplate:Clone()
            inputFrame.Name = inputName
            inputFrame.Parent = tabPage
            inputFrame.Visible = true
            inputFrame.LayoutOrder = GetNextLayoutOrder()

            local titleText = EnsureTextTemplate(inputFrame)
            ApplyPremiumStroke(inputFrame, cfg.Theme)
            ClearTemplateExtras(inputFrame, titleText)

            local cardWidth = inputFrame.AbsoluteSize.X > 0 and inputFrame.AbsoluteSize.X or 220
            local autoH = CalculateCardHeight(inputName, cfg.Theme.Font, 13, cardWidth - 140, cfg.Layout.InputHeight)
            inputFrame.Size = UDim2.new(1, 0, 0, autoH)

            if titleText then
                FormatTitleText(titleText, inputName, cfg.Theme.Font or Enum.Font.GothamMedium, cfg.Theme.TextColor, true)
                titleText.TextXAlignment = Enum.TextXAlignment.Left
                titleText.Position = UDim2.new(0, 12, 0.5, 0)
                titleText.AnchorPoint = Vector2.new(0, 0.5)
                titleText.Size = UDim2.new(1, -140, 0.9, 0)
                titleText.TextSize = 13
            end

            local textBox = Instance.new("TextBox")
            textBox.Parent = inputFrame
            textBox.AnchorPoint = Vector2.new(1, 0.5)
            textBox.Position = UDim2.new(1, -12, 0.5, 0)
            textBox.Size = UDim2.new(0, 120, 0, 24)
            textBox.PlaceholderText = placeholder
            textBox.Text = ""
            textBox.TextColor3 = cfg.Theme.TextColor
            textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            textBox.Font = cfg.Theme.Font or Enum.Font.GothamMedium
            textBox.TextSize = 12
            Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 4)

            textBox.FocusLost:Connect(function(enterPressed)
                if flag then SanderUI.Flags[flag] = textBox.Text end
                SafeCallback(inputConfig.Callback, textBox.Text, enterPressed)
            end)

            if inputConfig.Tooltip then AttachTooltip(inputFrame, inputConfig.Tooltip) end
            AddHoverScale(inputFrame)
            FilterActivePage()

            local ret = {
                Set = function(_, text)
                    textBox.Text = text
                    if flag then SanderUI.Flags[flag] = text end
                    SafeCallback(inputConfig.Callback, text, false)
                end
            }
            if flag then
                SanderUI.Flags[flag] = defaultText
                SanderUI.FlagComponents[flag] = ret
            end
            return ret
        end

        -- 15. CREATE SECTION
        function TabObj:CreateSection(secName)
            local secFrame = Instance.new("Frame")
            secFrame.Name = "Section_" .. secName
            secFrame.Parent = tabPage
            secFrame.LayoutOrder = GetNextLayoutOrder()
            secFrame.Size = UDim2.new(1, 0, 0, cfg.Layout.SectionHeight)
            secFrame.BackgroundTransparency = 1

            local secLabel = Instance.new("TextLabel")
            secLabel.Parent = secFrame
            secLabel.Size = UDim2.new(1, 0, 1, 0)
            FormatTitleText(secLabel, "--- " .. tostring(secName) .. " ---", cfg.Theme.Font or Enum.Font.GothamMedium, Color3.fromRGB(150, 150, 160), false)
            secLabel.TextSize = 12
            secLabel.TextXAlignment = Enum.TextXAlignment.Center
            secLabel.BackgroundTransparency = 1

            FilterActivePage()
        end

        -- 16. CREATE PARAGRAPH
        function TabObj:CreateParagraph(paraConfig)
            paraConfig = paraConfig or {}
            local pTitle = paraConfig.Title or "Info"
            local pContent = paraConfig.Content or ""

            local card = buttonTemplate:Clone()
            card.Name = "Paragraph_" .. pTitle
            card.Parent = tabPage
            card.Visible = true
            card.LayoutOrder = GetNextLayoutOrder()

            local titleLabel = card:FindFirstChild("TextTemplate", true) or card:FindFirstChildOfClass("TextLabel")
            ClearTemplateExtras(card, titleLabel)

            if titleLabel then
                FormatTitleText(titleLabel, pTitle, cfg.Theme.BoldFont or Enum.Font.GothamBold, cfg.Theme.TextColor, false)
                titleLabel.TextXAlignment = Enum.TextXAlignment.Left
                titleLabel.Position = UDim2.new(0, 12, 0, 6)
                titleLabel.Size = UDim2.new(1, -24, 0, 18)
                titleLabel.TextSize = 13
            end

            local pageWidth = card.AbsoluteSize.X > 0 and card.AbsoluteSize.X or 220
            local contentHeight = TextService:GetTextSize(pContent, 12, cfg.Theme.Font or Enum.Font.GothamMedium, Vector2.new(pageWidth - 24, 10000)).Y
            local cardHeight = math.max(50, 6 + 18 + 4 + contentHeight + 10)

            card.Size = UDim2.new(1, 0, 0, cardHeight)

            local bodyLabel = Instance.new("TextLabel")
            bodyLabel.Parent = card
            bodyLabel.Position = UDim2.new(0, 12, 0, 26)
            bodyLabel.Size = UDim2.new(1, -24, 0, contentHeight + 4)
            bodyLabel.Text = pContent
            bodyLabel.TextColor3 = Color3.fromRGB(165, 165, 180)
            bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
            bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
            bodyLabel.TextWrapped = true
            bodyLabel.BackgroundTransparency = 1
            bodyLabel.Font = cfg.Theme.Font or Enum.Font.GothamMedium
            bodyLabel.TextSize = 12

            FilterActivePage()

            return {
                Set = function(_, newTitle, newContent)
                    if titleLabel then titleLabel.Text = newTitle end
                    if bodyLabel then bodyLabel.Text = newContent end
                    local newH = TextService:GetTextSize(newContent, 12, cfg.Theme.Font or Enum.Font.GothamMedium, Vector2.new(card.AbsoluteSize.X - 24, 10000)).Y
                    card.Size = UDim2.new(1, 0, 0, math.max(50, 28 + newH + 10))
                end
            }
        end

        -- 17. CREATE DIVIDER
        function TabObj:CreateDivider()
            local lineFrame = Instance.new("Frame")
            lineFrame.Name = "Divider"
            lineFrame.Parent = tabPage
            lineFrame.LayoutOrder = GetNextLayoutOrder()
            lineFrame.Size = UDim2.new(1, 0, 0, 2)
            lineFrame.BackgroundColor3 = Color3.fromRGB(42, 42, 50)
            lineFrame.BorderSizePixel = 0
            FilterActivePage()
        end

        return TabObj
    end

    return WindowObj
end

return SanderUI
