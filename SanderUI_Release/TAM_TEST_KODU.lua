-- ========================================================================
-- 👑 Geliştirici: ENI & LO (Ultimate AAA Custom UI Suite - Silent Slap Sürüm)
-- ⚡ Sistem: SanderUI v6.3 Entegrasyonu ile Premium Arayüz
-- ========================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- SanderUI Yüklemesi (Roblox Studio Uyumlu)
local SanderUI = require(ReplicatedStorage:WaitForChild("SanderUI"))

-- Yeni Pencereyi Oluştur (Temiz ve Şık)
local Window = SanderUI:CreateWindow({
    Name = "ENI & LO | Master Suite",
    Theme = SanderUI.Themes.Dark,
    Logo = "rbxassetid://10618928818" -- Örnek şık bir kalkan/master ikonu
})

-- Sayfalar (Tablar)
local BadgePage = Window:CreateTab({ Name = "🏅 Badge" })
local SlapFarmPage = Window:CreateTab({ Name = "🏆 Slap & Farm" })
local FlyPage = Window:CreateTab({ Name = "✈️ Uçuş (Fly)" })
local MapPage = Window:CreateTab({ Name = "🗺️ Adalar & TP" })
local SpamPage = Window:CreateTab({ Name = "🔥 1000x E Spam" })
local SecurityPage = Window:CreateTab({ Name = "🛡️ Güvenlik & Anti" })
local InspectorPage = Window:CreateTab({ Name = "🔍 Part Analizci" })


-- ==========================================
-- HİLE MANTIĞI VE DEĞİŞKENLER (LOKAL)
-- ==========================================
local bobStatusLabel = nil
local InfoLabel = nil

local BobFarmActive = false
local AdvancedSlapFarmActive = false
local ManualSpamActive = false
local InspectorActive = false
local AutoOrbitBadgeActive = false
local AutoSlappleActive = false
local AntiSlapActive = false
local AntiAdminActive = false
local AntiVoidActive = false
local TycoonBadgeActive = false
local FlyActive = false
local FlySpeed = 50
local FlyConnection = nil
local CurrentState = "CHECK_GLOVE"
local GloveCache = {}
local SavedPartPath = ""

local function StartFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    local bv = Instance.new("BodyVelocity")
    bv.Name = "FlyVelocity"
    bv.Parent = hrp
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)

    local bg = Instance.new("BodyGyro")
    bg.Name = "FlyGyro"
    bg.Parent = hrp
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.CFrame = hrp.CFrame

    FlyConnection = RunService.RenderStepped:Connect(function()
        if not FlyActive then return end
        local camera = Workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end

        bv.Velocity = moveDirection * FlySpeed
        bg.CFrame = camera.CFrame
        humanoid.PlatformStand = true
    end)
end

local function StopFly()
    if FlyConnection then FlyConnection:Disconnect(); FlyConnection = nil end
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if hrp then
            if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
            if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
        end
        if humanoid then humanoid.PlatformStand = false end
    end
end

local vu = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

task.spawn(function()
    while true do
        task.wait(0.05)
        if AntiSlapActive then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and (hum.PlatformStand or hum.Sit) and not FlyActive then
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        hum.PlatformStand = false
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        if AntiVoidActive then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and hrp.Position.Y < -50 then
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    hrp.CFrame = CFrame.new(0, 50, 0)
                end
            end)
        end
    end
end)

local function ScanGloves()
    table.clear(GloveCache)
    local lobby = Workspace:FindFirstChild("Lobby")
    if lobby then
        for _, item in ipairs(lobby:GetChildren()) do
            local cd = item:FindFirstChildWhichIsA("ClickDetector", true)
            if cd then GloveCache[string.lower(item.Name)] = { Part = item, ClickDetector = cd } end
        end
    end
end

local function IsReplicaEquipped()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        local gloveStat = leaderstats:FindFirstChild("Glove")
        if gloveStat and gloveStat:IsA("StringValue") then
            if string.lower(gloveStat.Value) == "replica" then return true end
        end
    end
    return false
end

local function EquipGlove(gloveName)
    if IsReplicaEquipped() then return true end
    local targetName = string.lower(gloveName)
    local gloveData = GloveCache[targetName]
    if not gloveData or not gloveData.Part then
        ScanGloves()
        gloveData = GloveCache[targetName]
        if not gloveData then return false end
    end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    hrp.Anchored = true
    local targetPivot = gloveData.Part:IsA("Model") and gloveData.Part:GetPivot() or gloveData.Part.CFrame
    hrp.CFrame = targetPivot + Vector3.new(0, 3, 0)
    task.wait(0.05)
    if gloveData.ClickDetector then fireclickdetector(gloveData.ClickDetector) end
    task.wait(0.05)
    hrp.Anchored = false
    return IsReplicaEquipped()
end

local function WalkFromSpawnToPortal()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local lobby = Workspace:FindFirstChild("Lobby")
    local redPortal = lobby and lobby:FindFirstChild("Teleport1")
    if not hrp or not humanoid or not redPortal then return false end
    hrp.Anchored = false
    local timeout = tick() + 15 
    while tick() < timeout and BobFarmActive do
        local currentCharacter = LocalPlayer.Character
        if not currentCharacter or not currentCharacter:FindFirstChild("HumanoidRootPart") then break end
        local currentHrp = currentCharacter.HumanoidRootPart
        local currentHumanoid = currentCharacter:FindFirstChildOfClass("Humanoid")
        local dist = (currentHrp.Position - redPortal.Position).Magnitude
        if dist < 3 then break end
        if currentHumanoid then currentHumanoid:MoveTo(redPortal.Position) end
        task.wait(0.1)
    end
    if firetouchinterest then
        firetouchinterest(hrp, redPortal, 0)
        task.wait(0.01)
        firetouchinterest(hrp, redPortal, 1)
    end
    task.wait(0.4) 
    return true
end

local function EnterPortalAndGoTo(destinationCFrame)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local lobby = Workspace:FindFirstChild("Lobby")
    local redPortal = lobby and lobby:FindFirstChild("Teleport1")
    if not hrp or not humanoid or not redPortal then return false end
    hrp.Anchored = false
    local timeout = tick() + 10
    while tick() < timeout do
        local currChar = LocalPlayer.Character
        if not currChar or not currChar:FindFirstChild("HumanoidRootPart") then break end
        local curHrp = currChar.HumanoidRootPart
        local curHum = currChar:FindFirstChildOfClass("Humanoid")
        if (curHrp.Position - redPortal.Position).Magnitude < 3 then break end
        if curHum then curHum:MoveTo(redPortal.Position) end
        task.wait(0.1)
    end
    if firetouchinterest then
        firetouchinterest(hrp, redPortal, 0)
        task.wait(0.01)
        firetouchinterest(hrp, redPortal, 1)
    end
    task.wait(0.6)
    local newChar = LocalPlayer.Character
    local newHrp = newChar and newChar:FindFirstChild("HumanoidRootPart")
    if newHrp then
        newHrp.CFrame = destinationCFrame + Vector3.new(0, 3, 0)
        return true
    end
    return false
end

local function TPToTycoonPlateWithPortal()
    local plate = Workspace:FindFirstChild("Arena") and Workspace.Arena:FindFirstChild("Plate")
    if plate then
        EnterPortalAndGoTo(plate.CFrame)
    end
end

task.spawn(function()
    while true do
        task.wait()
        if AutoSlappleActive then
            pcall(function()
                local slapplesFolder = Workspace:FindFirstChild("Arena") 
                    and Workspace.Arena:FindFirstChild("island5") 
                    and Workspace.Arena.island5:FindFirstChild("Slapples")
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if slapplesFolder and hrp and firetouchinterest then
                    for _, slappleModel in ipairs(slapplesFolder:GetChildren()) do
                        local glovePart = slappleModel:FindFirstChild("Glove")
                        if glovePart and glovePart:IsA("BasePart") then
                            firetouchinterest(hrp, glovePart, 0)
                            firetouchinterest(hrp, glovePart, 1)
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    local threatStartTime = 0
    local isThreatDetected = false
    while true do
        task.wait(0.2)
        if AutoOrbitBadgeActive then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bobFound = false
                for _, obj in ipairs(Workspace:GetChildren()) do
                    if obj.Name == "Bob" and obj:FindFirstChild("HumanoidRootPart") then
                        if (hrp.Position - obj.HumanoidRootPart.Position).Magnitude < 15 then
                            bobFound = true
                            break
                        end
                    end
                end
                if bobFound then
                    if not isThreatDetected then
                        isThreatDetected = true
                        threatStartTime = tick()
                    elseif tick() - threatStartTime >= 2 then
                        hrp.CFrame = CFrame.new(-282.8, -3.6, -0.6)
                        isThreatDetected = false
                        task.wait(1)
                    end
                else
                    isThreatDetected = false
                end
            end
        else
            isThreatDetected = false
        end
    end
end)

local function SpamAbilityGuaranteed(duration)
    local endTime = tick() + duration
    while tick() < endTime and BobFarmActive do
        if VirtualInputManager then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.01)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            task.wait(0.01)
        end
    end
end

local function FastReset()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then humanoid.Health = 0 end
    end
    local timeout = tick() + 8
    repeat task.wait(0.1) until (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.Humanoid.Health > 0) or tick() > timeout
    task.wait(0.3)
end

local function BobBadgeLoop()
    task.spawn(function()
        while true do
            task.wait()
            if not BobFarmActive then
                CurrentState = "CHECK_GLOVE"
                if bobStatusLabel then bobStatusLabel:SetText("Durum: Beklemede") end
                task.wait(0.5)
                continue
            end
            pcall(function()
                if CurrentState == "CHECK_GLOVE" then
                    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
                    local gloveStat = leaderstats and leaderstats:FindFirstChild("Glove")
                    if gloveStat and string.lower(gloveStat.Value) ~= "replica" then
                        if bobStatusLabel then bobStatusLabel:SetText("Durum: Replica Gerekli") end
                    else
                        if bobStatusLabel then bobStatusLabel:SetText("Durum: Çalışıyor...") end
                    end

                    local success = EquipGlove("Replica")
                    if success then CurrentState = "WALK_PORTAL" else task.wait(0.5) end
                elseif CurrentState == "WALK_PORTAL" then
                    WalkFromSpawnToPortal()
                    local char = LocalPlayer.Character
                    if char and char.PrimaryPart and char.PrimaryPart.Position.Y < 100 then
                        CurrentState = "SPAM"
                    else
                        task.wait(0.5)
                    end
                elseif CurrentState == "SPAM" then
                    SpamAbilityGuaranteed(0.6)
                    CurrentState = "RESET"
                elseif CurrentState == "RESET" then
                    FastReset()
                    if IsReplicaEquipped() then CurrentState = "WALK_PORTAL" else CurrentState = "CHECK_GLOVE" end
                end
            end)
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(1)
        if TycoonBadgeActive then
            local plate = Workspace:FindFirstChild("Arena") and Workspace.Arena:FindFirstChild("Plate")
            if plate then
                EnterPortalAndGoTo(plate.CFrame)
                local startTime = tick()
                while tick() - startTime < 600 and TycoonBadgeActive do
                    task.wait(1)
                end
                TycoonBadgeActive = false
            end
        end
    end
end)

task.spawn(function()
    while true do
        if ManualSpamActive then
            if VirtualInputManager then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                task.wait(0.0001)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                task.wait(0.0001)
            else
                task.wait(0.2)
            end
        else
            task.wait(0.2)
        end
    end
end)

-- ⚡ GÖRÜNMEZ / TP'SİZ SİLESS SLAP FARM
task.spawn(function()
    while true do
        task.wait(0.1)
        if AdvancedSlapFarmActive then
            pcall(function()
                for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") and (string.lower(remote.Name) == "slap" or string.lower(remote.Name) == "hit" or string.lower(remote.Name) == "baux") then
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                remote:FireServer(p.Character.HumanoidRootPart)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

UserInputService.InputBegan:Connect(function(input)
    if not InspectorActive then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local target = Mouse.Target
        if target then
            SavedPartPath = target:GetFullName()
            if InfoLabel then InfoLabel:SetText("Yol: " .. SavedPartPath) end
            if setclipboard then pcall(function() setclipboard(SavedPartPath) end) end
        end
    end
end)


-- ==========================================
-- BİLEŞENLERİN EKLENMESİ (SanderUI)
-- ==========================================

-- 🏅 Badge Page
bobStatusLabel = BadgePage:CreateLabel({ Text = "Durum: Beklemede" })
BadgePage:CreateMiniToggle({
    Name = "Auto Orbit Badge (Bob İçin)",
    Callback = function(v) AutoOrbitBadgeActive = v end
})
BadgePage:CreateMiniToggle({
    Name = "Auto Bob Badge",
    Callback = function(v)
        BobFarmActive = v 
        if v then 
            CurrentState = "CHECK_GLOVE" 
        else 
            bobStatusLabel:SetText("Durum: Beklemede") 
        end 
    end
})
BadgePage:CreateMiniToggle({
    Name = "Tycoon Badge (600s Bekle)",
    Callback = function(v) TycoonBadgeActive = v end
})
BadgePage:CreateButton({
    Name = "Retro Badge TP (Bitiş Kapısı)",
    Callback = function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(-27776.10, 169.13, 4834.74) + Vector3.new(0, 3, 0) end
    end
})


-- 🏆 Slap & Farm Page
SlapFarmPage:CreateMiniToggle({
    Name = "Oto Slap Farm (Silent & TP'siz)",
    Callback = function(v) AdvancedSlapFarmActive = v end
})
SlapFarmPage:CreateMiniToggle({
    Name = "Çok Hızlı Oto Slapple Toplayıcı",
    Callback = function(v) AutoSlappleActive = v end
})


-- ✈️ Uçuş Page
FlyPage:CreateMiniToggle({
    Name = "Uçuşu Başlat (Fly)",
    Callback = function(v)
        FlyActive = v
        if v then StartFly() else StopFly() end
    end
})


-- 🗺️ Adalar & TP Page
local Islands = {
    ["Brasil Portal"] = CFrame.new(-1123.1, 312.1, -3.6),
    ["Slapple Adası"] = CFrame.new(-403.3, 48.7, -17.2),
    ["Kale Adası"] = CFrame.new(268.0, 33.7, 202.6),
    ["Moai Adası"] = CFrame.new(210.5, -15.7, -8.7),
    ["Sağ Ada"] = CFrame.new(-7.2, -5.1, -205.0),
    ["Sol Ada"] = CFrame.new(3.1, -5.1, 207.0),
    ["Default Adası"] = CFrame.new(133.5, 360.0, 1.3),
    ["Bulut Adası"] = CFrame.new(-125.322, -4.556, 122.432),
}
for name, cf in pairs(Islands) do
    MapPage:CreateButton({
        Name = "TP -> " .. name,
        Callback = function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = cf + Vector3.new(0, 3, 0) end
        end
    })
end
MapPage:CreateButton({
    Name = "Tycoon Plate'e Portaldan Git",
    Callback = function() TPToTycoonPlateWithPortal() end
})


-- 🔥 Spam Page
SpamPage:CreateMiniToggle({
    Name = "1000x E Spam",
    Callback = function(v) ManualSpamActive = v end
})


-- 🛡️ Güvenlik Page
SecurityPage:CreateMiniToggle({
    Name = "Anti-Admin Algılayıcı",
    Callback = function(v) AntiAdminActive = v end
})
SecurityPage:CreateMiniToggle({
    Name = "Anti-Slap Yeme",
    Callback = function(v) AntiSlapActive = v end
})
SecurityPage:CreateMiniToggle({
    Name = "Anti-AFK Koruması",
    Callback = function(v) end
})
SecurityPage:CreateMiniToggle({
    Name = "Anti-Void (Haritadan Düşme)",
    Callback = function(v) AntiVoidActive = v end
})


-- 🔍 Inspector Page
InfoLabel = InspectorPage:CreateLabel({ Text = "Bilgi: Henüz bir parta tıklanmadı." })
InspectorPage:CreateMiniToggle({
    Name = "Tıklanan Partı Kaydet",
    Callback = function(v) InspectorActive = v end
})

-- BAŞLATMA
ScanGloves()
BobBadgeLoop()
SanderUI:Notify({
    Title = "ENI & LO Yüklendi!",
    Content = "SanderUI v6.3 entegrasyonlu Master Suite başarıyla aktif edildi.",
    Duration = 5
})
