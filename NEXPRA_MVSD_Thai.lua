--// NEXPRA | MVSD GUI | ระบบคีย์ถูกนำออกแล้ว
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local SoundService = game:GetService("SoundService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ShootGun = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ShootGun")
local StabRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Stab")
local ThrowStart = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("ThrowStart")
local ThrowHit = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("ThrowHit")

local soundsassets = {
	["Rust HS"]           = "rbxassetid://5043539486",
	["Neverlose"]         = "rbxassetid://97643101798871",
	["Minecraft Bow"]     = "rbxassetid://3442683707",
	["Minecraft Hit"]     = "rbxassetid://8766809464",
	["CSGO"]              = "rbxassetid://5764885315",
	["Bubble"]            = "rbxassetid://6534947588",
	["Lazer"]             = "rbxassetid://130791043",
	["Pick"]              = "rbxassetid://1347140027",
	["Pop"]               = "rbxassetid://198598793",
	["Rust"]              = "rbxassetid://1255040462",
	["Sans"]              = "rbxassetid://3188795283",
	["Fart"]              = "rbxassetid://130833677",
	["Big"]               = "rbxassetid://5332005053",
	["Vine"]              = "rbxassetid://5332680810",
	["UwU"]               = "rbxassetid://8679659744",
	["Bruh"]              = "rbxassetid://4578740568",
	["Skeet"]             = "rbxassetid://5633695679",
	["Fatality"]          = "rbxassetid://6534947869",
	["Bonk"]              = "rbxassetid://5766898159",
	["Minecraft"]         = "rbxassetid://5869422451",
	["Gamesense"]         = "rbxassetid://4817809188",
	["RIFK7"]             = "rbxassetid://9102080552",
	["Bamboo"]            = "rbxassetid://3769434519",
	["Crowbar"]           = "rbxassetid://546410481",
	["Weeb"]              = "rbxassetid://6442965016",
	["Beep"]              = "rbxassetid://8177256015",
	["Bambi"]             = "rbxassetid://8437203821",
	["Stone"]             = "rbxassetid://3581383408",
	["Old Fatality"]      = "rbxassetid://6607142036",
	["Click"]             = "rbxassetid://8053704437",
	["Ding"]              = "rbxassetid://7149516994",
	["Snow"]              = "rbxassetid://6455527632",
	["Laser"]             = "rbxassetid://7837461331",
	["Mario"]             = "rbxassetid://2815207981",
	["Steve"]             = "rbxassetid://4965083997",
	["Call of Duty"]      = "rbxassetid://5952120301",
	["Bat"]               = "rbxassetid://3333907347",
	["TF2 Critical"]      = "rbxassetid://296102734",
	["Saber"]             = "rbxassetid://8415678813",
	["Baimware"]          = "rbxassetid://3124331820",
	["Osu"]               = "rbxassetid://7149255551",
	["TF2"]               = "rbxassetid://2868331684",
	["Slime"]             = "rbxassetid://6916371803",
	["Among Us"]          = "rbxassetid://5700183626",
	["One"]               = "rbxassetid://7380502345",
	["Soft Bell"]         = "rbxassetid://9114487369",
	["Minecraft Bow Hit"] = "rbxassetid://1053296915",
}

local SoundNames = {}
for name in pairs(soundsassets) do
	table.insert(SoundNames, name)
end
table.sort(SoundNames)

local hmndbreaker = {
	Active = false,
	Track = nil,
	Heartbeat = nil,
	AnimConnection = nil,
	EmoteId = "rbxassetid://70883871260184",
	FreezeTime = 0.1265,
	SpinSpeed = 120,
	Gap = 0.025,
	BounceIntensity = 4,
	BouncePhase = 0,
	Mode = "vertical",
	SolarAngle = 0,
	SolarRadius = 5,
	HeadHidden = {},
}

-- Snapshot existing GUI objects so the floating cat can hide/show this window.
local CoreGui = game:GetService("CoreGui")
local function getGuiRoot()
    if type(gethui) == "function" then
        local ok, root = pcall(gethui)
        if ok and root then return root end
    end
    return CoreGui
end
local GuiRoot = getGuiRoot()
local ExistingGuis = {}
for _, obj in ipairs(GuiRoot:GetChildren()) do
    if obj:IsA("ScreenGui") then ExistingGuis[obj] = true end
end

local Window = Library:CreateWindow({
	Title = "NEXPRA | MVSD",
	Footer = "ต่อสู้ • แสดงผล • โลก",
	NotifySide = "Right",
	ShowCustomCursor = true,
})

--// ปุ่มแมวเปิด/ปิด GUI สีฟ้า + ปุ่ม Discord
local PlayersForGui = game:GetService("Players")
local LocalPlayerForGui = PlayersForGui.LocalPlayer
local PlayerGuiForGui = LocalPlayerForGui:WaitForChild("PlayerGui")
local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "NEXPRA_CatToggle"
ToggleGui.ResetOnSpawn = false
ToggleGui.IgnoreGuiInset = true
ToggleGui.DisplayOrder = 999999
ToggleGui.Parent = PlayerGuiForGui

local CatButton = Instance.new("ImageButton")
CatButton.Name = "CatToggle"
CatButton.Size = UDim2.fromOffset(58, 58)
CatButton.Position = UDim2.new(0, 16, 0.55, 0)
CatButton.BackgroundColor3 = Color3.fromRGB(35, 145, 255)
CatButton.AutoButtonColor = true
CatButton.Image = "rbxassetid://119290932517877"
CatButton.ScaleType = Enum.ScaleType.Fit
CatButton.Parent = ToggleGui
local CatCorner = Instance.new("UICorner")
CatCorner.CornerRadius = UDim.new(1, 0)
CatCorner.Parent = CatButton
local CatStroke = Instance.new("UIStroke")
CatStroke.Color = Color3.fromRGB(150, 220, 255)
CatStroke.Thickness = 2
CatStroke.Parent = CatButton

local DiscordButton = Instance.new("TextButton")
DiscordButton.Name = "DiscordButton"
DiscordButton.Size = UDim2.fromOffset(86, 27)
DiscordButton.Position = UDim2.new(0, 2, 0.55, 64)
DiscordButton.BackgroundColor3 = Color3.fromRGB(35, 110, 235)
DiscordButton.Text = "ดิสคอร์ด"
DiscordButton.TextColor3 = Color3.new(1, 1, 1)
DiscordButton.TextSize = 13
DiscordButton.Font = Enum.Font.GothamBold
DiscordButton.Parent = ToggleGui
local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 8)
DiscordCorner.Parent = DiscordButton

local LibraryGuis = {}
for _, obj in ipairs(GuiRoot:GetChildren()) do
    if obj:IsA("ScreenGui") and not ExistingGuis[obj] and obj ~= ToggleGui then
        table.insert(LibraryGuis, obj)
    end
end
-- Fallback: look for newly created ScreenGuis under CoreGui as well.
if #LibraryGuis == 0 then
    for _, obj in ipairs(CoreGui:GetChildren()) do
        if obj:IsA("ScreenGui") and obj.Name ~= ToggleGui.Name then
            local lowerName = string.lower(obj.Name)
            if string.find(lowerName, "obsidian") or string.find(lowerName, "library") then
                table.insert(LibraryGuis, obj)
            end
        end
    end
end
local GuiVisible = true
CatButton.Activated:Connect(function()
    GuiVisible = not GuiVisible
    for _, gui in ipairs(LibraryGuis) do
        pcall(function() gui.Enabled = GuiVisible end)
    end
    CatButton.BackgroundColor3 = GuiVisible and Color3.fromRGB(35, 145, 255) or Color3.fromRGB(75, 85, 100)
end)
DiscordButton.Activated:Connect(function()
    local link = "https://discord.gg/Qdaj957G4"
    local copied = false
    pcall(function()
        if type(setclipboard) == "function" then setclipboard(link); copied = true end
    end)
    if not copied then
        pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title="NEXPRA / ดิสคอร์ด", Text=link, Duration=5}) end)
    end
end)

local Tabs = {
	Combat = Window:AddTab("ต่อสู้", "crosshair"),
	Visuals = Window:AddTab("แสดงผล", "eye"),
	World = Window:AddTab("โลก", "globe"),
	["UI Settings"] = Window:AddTab("ตั้งค่า GUI", "settings"),
}

local AimbotLeft = Tabs.Combat:AddLeftGroupbox("เล็งเป้าอัตโนมัติ")
local SilentLeft = Tabs.Combat:AddLeftGroupbox("เล็งเป้าเงียบ")
local RageLeft = Tabs.Combat:AddLeftGroupbox("ยิงอัตโนมัติ")
local TriggerRight = Tabs.Combat:AddRightGroupbox("ยิงเมื่อเล็งโดน")

AimbotLeft:AddToggle("AimbotEnabled", { Text = "เปิดเล็งเป้าอัตโนมัติ", Default = false })
AimbotLeft:AddDropdown("AimbotMethod", { Values = {"Camera", "Mouse"}, Default = 1, Multi = false, Text = "วิธีเล็งเป้า" })
AimbotLeft:AddSlider("AimbotSmoothing", { Text = "ความนุ่มนวลในการเล็ง", Default = 5, Min = 1, Max = 20, Rounding = 1 })
AimbotLeft:AddDropdown("TargetMethod", { Values = {"Closest to Center", "Distance"}, Default = 1, Multi = false, Text = "วิธีเลือกเป้าหมาย" })
AimbotLeft:AddLabel("ปุ่มควบคุมการเล็ง"):AddKeyPicker("AimbotKeybind", { Default = "E", Mode = "Hold", Text = "ปุ่มเล็งเป้า" })
AimbotLeft:AddToggle("FovEnabled", { Text = "เปิดขอบเขต FOV", Default = false })
AimbotLeft:AddToggle("FovDraw", { Text = "แสดงวง FOV", Default = false }):AddColorPicker("FovColor", { Default = Color3.fromRGB(255, 255, 255), Title = "สีวง FOV" })
AimbotLeft:AddSlider("FovSize", { Text = "ขนาดวง FOV", Default = 150, Min = 10, Max = 500, Rounding = 0 })
AimbotLeft:AddToggle("FovGlow", { Text = "เรืองแสงวง FOV", Default = false }):AddColorPicker("FovGlowColor", { Default = Color3.fromRGB(255, 255, 255), Title = "สีเรืองแสง FOV" })
AimbotLeft:AddToggle("TeamCheck", { Text = "ตรวจสอบทีม", Default = true })

SilentLeft:AddToggle("SilentAimEnabled", { Text = "เปิดเล็งเป้าเงียบ", Default = false })
SilentLeft:AddDropdown("SilentHitPart", { Values = {"Head", "HumanoidRootPart", "UpperTorso"}, Default = 1, Multi = false, Text = "ส่วนที่ใช้เล็ง" })
SilentLeft:AddSlider("SilentHitChance", { Text = "โอกาสโดน", Default = 100, Min = 0, Max = 100, Rounding = 0, Suffix = "%" })
SilentLeft:AddToggle("SilentWallCheck", { Text = "ตรวจสอบสิ่งกีดขวาง", Default = true })
SilentLeft:AddToggle("SilentPrediction", { Text = "คาดการณ์ตำแหน่ง", Default = true })
SilentLeft:AddToggle("SilentAutoPrediction", { Text = "คาดการณ์ตามค่า Ping", Default = true })
SilentLeft:AddSlider("SilentPredictionAmount", { Text = "ระดับการคาดการณ์", Default = 0.12, Min = 0, Max = 0.3, Rounding = 3, Suffix = " วินาที" })
SilentLeft:AddToggle("SilentFovEnabled", { Text = "เปิดขอบเขตเล็งเงียบ", Default = true })
SilentLeft:AddToggle("SilentFovDraw", { Text = "แสดงวงเล็งเงียบ", Default = false }):AddColorPicker("SilentFovColor", { Default = Color3.fromRGB(255, 80, 80), Title = "สีวงเล็งเงียบ" })
SilentLeft:AddSlider("SilentFovSize", { Text = "ขนาดวงเล็งเงียบ", Default = 200, Min = 10, Max = 500, Rounding = 0 })
SilentLeft:AddToggle("SilentFovGlow", { Text = "เรืองแสงวงเล็งเงียบ", Default = false }):AddColorPicker("SilentFovGlowColor", { Default = Color3.fromRGB(255, 80, 80), Title = "เรืองแสงวงเล็งเงียบ" })

RageLeft:AddToggle("RagebotEnabled", { Text = "เปิดยิงอัตโนมัติ", Default = false })
RageLeft:AddSlider("RagebotDelay", { Text = "ระยะหน่วงการยิง", Default = 0.03, Min = 0, Max = 0.5, Rounding = 2, Suffix = " วินาที" })
RageLeft:AddDropdown("RagebotHitPart", { Values = {"Head", "HumanoidRootPart", "UpperTorso"}, Default = 1, Multi = false, Text = "ส่วนที่ใช้เล็ง" })
RageLeft:AddDropdown("RagebotTargetMethod", { Values = {"Closest to Center", "Distance"}, Default = 1, Multi = false, Text = "วิธีเลือกเป้าหมาย" })
RageLeft:AddToggle("RagebotVisualizer", { Text = "แสดงสถานะการยิง", Default = true })
RageLeft:AddToggle("RagebotNotify", { Text = "แจ้งเตือนเมื่อยิงโดน", Default = true })
RageLeft:AddToggle("RagebotVoid", { Text = "ซ่อนตัวใต้แผนที่", Default = false })
RageLeft:AddSlider("RagebotVoidY", { Text = "ระดับความสูง Y", Default = -100000, Min = -100000, Max = -200, Rounding = 0 })

TriggerRight:AddToggle("TriggerbotEnabled", { Text = "เปิดยิงเมื่อเล็งโดน", Default = false })
TriggerRight:AddSlider("TriggerbotDelay", { Text = "ระยะหน่วงก่อนยิง", Default = 0.05, Min = 0, Max = 0.5, Rounding = 2, Suffix = " วินาที" })
TriggerRight:AddDropdown("TriggerbotMethod", { Values = {"Mouse", "Center of Screen"}, Default = 1, Multi = false, Text = "วิธีตรวจจับเป้าหมาย" })
TriggerRight:AddDropdown("TriggerbotHitPart", { Values = {"Head", "HumanoidRootPart", "UpperTorso"}, Default = 1, Multi = false, Text = "ส่วนที่ใช้เล็ง" })
TriggerRight:AddToggle("TriggerbotWallCheck", { Text = "ตรวจสอบสิ่งกีดขวาง", Default = true })

local WorldLeft = Tabs.World:AddLeftGroupbox("ปรับแต่งปืน")
local WorldSounds = Tabs.World:AddLeftGroupbox("เสียง")
local WorldHitbox = Tabs.World:AddRightGroupbox("ขยายกรอบตัวละคร")
local WorldAA = Tabs.World:AddRightGroupbox("ปั่นทิศทางตัวละคร")
local WorldKnife = Tabs.World:AddLeftGroupbox("มีด")

WorldLeft:AddToggle("NoGunCooldown", { Text = "ปิดเวลารอของปืน", Default = false })
WorldLeft:AddToggle("AutoEquipGun", { Text = "ถือปืนอัตโนมัติ", Default = false })
WorldLeft:AddToggle("ForceGunEnabled", { Text = "บังคับเปิดใช้งานปืน", Default = false })
WorldLeft:AddSlider("CustomCooldown", { Text = "กำหนดเวลารอเอง", Default = 0, Min = 0, Max = 1, Rounding = 2, Suffix = " วินาที" })
WorldLeft:AddToggle("UseCustomCooldown", { Text = "ใช้เวลารอที่กำหนด", Default = false })

WorldSounds:AddToggle("HitSoundsEnabled", { Text = "เสียงเมื่อยิงโดน", Default = false })
WorldSounds:AddDropdown("HitSoundType", { Values = SoundNames, Default = 1, Multi = false, Text = "เสียงเมื่อยิงโดน" })
WorldSounds:AddSlider("HitSoundVolume", { Text = "ระดับเสียงเมื่อยิงโดน", Default = 1, Min = 0, Max = 5, Rounding = 1 })
WorldSounds:AddToggle("KillSoundsEnabled", { Text = "เสียงเมื่อกำจัดได้", Default = false })
WorldSounds:AddDropdown("KillSoundType", { Values = SoundNames, Default = 1, Multi = false, Text = "เสียงเมื่อกำจัดได้" })
WorldSounds:AddSlider("KillSoundVolume", { Text = "ระดับเสียงเมื่อกำจัดได้", Default = 1, Min = 0, Max = 5, Rounding = 1 })
WorldSounds:AddToggle("OverrideGameHitSound", { Text = "แทนที่เสียงยิงโดนของเกม", Default = false })

WorldHitbox:AddToggle("HitboxExpander", { Text = "ขยายกรอบตัวละคร", Default = false })
WorldHitbox:AddSlider("HitboxSize", { Text = "ขนาดกรอบตัวละคร", Default = 2, Min = 1, Max = 60, Rounding = 1 })

WorldAA:AddToggle("AntiAimEnabled", { Text = "เปิดระบบปั่นทิศทาง", Default = false })
WorldAA:AddDropdown("AntiAimMode", { Values = {"Spin", "Jitter", "Invert", "Random", "Breaker"}, Default = 1, Multi = false, Text = "โหมดปั่นทิศทาง" })
WorldAA:AddSlider("AntiAimSpeed", { Text = "ความเร็วปั่นทิศทาง", Default = 20, Min = 1, Max = 50, Rounding = 0 })
WorldAA:AddToggle("AntiAimYaw", { Text = "ปรับมุม Yaw", Default = true })
WorldAA:AddSlider("AntiAimYawAmount", { Text = "องศา Yaw", Default = 180, Min = 0, Max = 360, Rounding = 0 })
WorldAA:AddToggle("BreakerHideHead", { Text = "ซ่อนศีรษะโหมด Breaker", Default = true })
WorldAA:AddSlider("BreakerSpinSpeed", { Text = "ความเร็วหมุน Breaker", Default = 120, Min = 10, Max = 300, Rounding = 0 })
WorldAA:AddSlider("BreakerBounce", { Text = "ระดับเด้ง Breaker", Default = 4, Min = 0, Max = 15, Rounding = 1 })
WorldAA:AddDropdown("BreakerMode", { Values = {"vertical", "solar"}, Default = 1, Multi = false, Text = "โหมด Breaker" })

WorldKnife:AddToggle("KnifeKillAura", { Text = "โจมตีด้วยมีดรอบตัว", Default = false })
WorldKnife:AddSlider("KnifeAuraRange", { Text = "ระยะโจมตีรอบตัว", Default = 12, Min = 3, Max = 30, Rounding = 1 })
WorldKnife:AddSlider("KnifeAuraDelay", { Text = "ระยะหน่วงโจมตี", Default = 0.1, Min = 0, Max = 0.5, Rounding = 2, Suffix = " วินาที" })
WorldKnife:AddToggle("KnifeAutoThrow", { Text = "ขว้างมีดอัตโนมัติ", Default = false })
WorldKnife:AddSlider("KnifeThrowRange", { Text = "ระยะขว้างมีด", Default = 80, Min = 10, Max = 200, Rounding = 0 })
WorldKnife:AddSlider("KnifeThrowDelay", { Text = "ระยะหน่วงขว้างมีด", Default = 0.4, Min = 0.1, Max = 2, Rounding = 2, Suffix = " วินาที" })
WorldKnife:AddToggle("KnifeSilentThrow", { Text = "ขว้างมีดแบบเงียบ", Default = true })
WorldKnife:AddToggle("AutoEquipKnife", { Text = "ถือมีดอัตโนมัติ", Default = false })

local EspLeft = Tabs.Visuals:AddLeftGroupbox("แสดงข้อมูลผู้เล่น")
local ClientRight = Tabs.Visuals:AddRightGroupbox("ภาพฝั่งเครื่องเรา")

EspLeft:AddToggle("EspEnabled", { Text = "เปิดแสดงข้อมูลผู้เล่น", Default = false }):AddColorPicker("EspEnabledColor", { Default = Color3.fromRGB(255, 255, 255), Title = "สีข้อมูลผู้เล่น" })
EspLeft:AddToggle("EspTeamCheck", { Text = "ตรวจสอบทีมใน ESP", Default = false })
EspLeft:AddSlider("EspLimit", { Text = "ระยะสูงสุดของ ESP", Default = 300, Min = 50, Max = 1000, Rounding = 0, Suffix = " หน่วย" })
EspLeft:AddToggle("EspName", { Text = "แสดงชื่อ", Default = false }):AddColorPicker("EspNameColor", { Default = Color3.fromRGB(255, 255, 255), Title = "สีชื่อ" })
EspLeft:AddToggle("EspBox", { Text = "แสดงกรอบ", Default = false }):AddColorPicker("EspBoxColor", { Default = Color3.fromRGB(255, 255, 255), Title = "สีกรอบ" })
EspLeft:AddToggle("BoxFilled", { Text = "เติมสีในกรอบ", Default = false }):AddColorPicker("BoxFilledColor", { Default = Color3.fromRGB(255, 255, 255), Title = "สีเติมกรอบ" })
EspLeft:AddDropdown("BoxType", { Values = {"2D", "3D", "Corner"}, Default = 1, Multi = false, Text = "รูปแบบกรอบ" })
EspLeft:AddToggle("BoxGlow", { Text = "เรืองแสงกรอบ", Default = false }):AddColorPicker("BoxGlowColor", { Default = Color3.fromRGB(255, 255, 255), Title = "สีเรืองแสง" })
EspLeft:AddToggle("EspHealth", { Text = "แสดงพลังชีวิต", Default = false }):AddColorPicker("EspHealthColor", { Default = Color3.fromRGB(0, 255, 0), Title = "สีพลังชีวิต" })
EspLeft:AddDropdown("HealthType", { Values = {"Text", "Dynamic Health Bar"}, Default = 2, Multi = false, Text = "รูปแบบพลังชีวิต" })
EspLeft:AddToggle("EspDistance", { Text = "แสดงระยะห่าง", Default = false }):AddColorPicker("EspDistanceColor", { Default = Color3.fromRGB(255, 255, 255), Title = "สีระยะห่าง" })
EspLeft:AddToggle("EspTracer", { Text = "แสดงเส้นชี้เป้า", Default = false }):AddColorPicker("EspTracerColor", { Default = Color3.fromRGB(255, 255, 255), Title = "สีเส้นชี้เป้า" })
EspLeft:AddToggle("EspSkeleton", { Text = "แสดงโครงกระดูก", Default = false }):AddColorPicker("EspSkeletonColor", { Default = Color3.fromRGB(255, 255, 255), Title = "สีโครงกระดูก" })
EspLeft:AddToggle("EspTool", { Text = "แสดงอาวุธที่ถือ", Default = false }):AddColorPicker("EspToolColor", { Default = Color3.fromRGB(255, 255, 255), Title = "สีอาวุธ" })

ClientRight:AddToggle("ClientEnabled", { Text = "เปิดปรับภาพฝั่งเครื่องเรา", Default = false }):AddColorPicker("ClientEnabledColor", { Default = Color3.fromRGB(255, 255, 255), Title = "สีภาพ" })
ClientRight:AddToggle("Ambient", { Text = "แสงโดยรวม", Default = false }):AddColorPicker("AmbientColor", { Default = Color3.fromRGB(128, 128, 128), Title = "สีแสงโดยรวม" })
ClientRight:AddToggle("OutdoorAmbient", { Text = "แสงภายนอก", Default = false }):AddColorPicker("OutdoorAmbientColor", { Default = Color3.fromRGB(128, 128, 128), Title = "แสงภายนอก" })
ClientRight:AddToggle("IndoorAmbient", { Text = "แสงภายใน", Default = false }):AddColorPicker("IndoorAmbientColor", { Default = Color3.fromRGB(128, 128, 128), Title = "แสงภายใน" })
ClientRight:AddToggle("FogColor", { Text = "สีหมอก", Default = false }):AddColorPicker("FogColorColor", { Default = Color3.fromRGB(192, 192, 192), Title = "สีหมอก" })
ClientRight:AddSlider("FogStart", { Text = "ระยะเริ่มหมอก", Default = 0, Min = 0, Max = 1000, Rounding = 0 })
ClientRight:AddSlider("FogEnd", { Text = "ระยะสิ้นสุดหมอก", Default = 1000, Min = 0, Max = 10000, Rounding = 0 })
ClientRight:AddToggle("DiffuseColor", { Text = "สีกระจายแสง", Default = false }):AddColorPicker("DiffuseColorColor", { Default = Color3.fromRGB(255, 255, 255), Title = "สีกระจายแสง" })
ClientRight:AddToggle("ColorShiftBottom", { Text = "สีเปลี่ยนด้านล่าง", Default = false }):AddColorPicker("ColorShiftBottomColor", { Default = Color3.fromRGB(0, 0, 0), Title = "สีด้านล่าง" })
ClientRight:AddToggle("ColorShiftTop", { Text = "สีเปลี่ยนด้านบน", Default = false }):AddColorPicker("ColorShiftTopColor", { Default = Color3.fromRGB(0, 0, 0), Title = "สีด้านบน" })
ClientRight:AddToggle("SunColor", { Text = "สีแสงอาทิตย์", Default = false }):AddColorPicker("SunColorColor", { Default = Color3.fromRGB(255, 255, 255), Title = "สีแสงอาทิตย์" })
ClientRight:AddSlider("Contrast", { Text = "ความต่างแสง", Default = 0, Min = -1, Max = 1, Rounding = 2 })
ClientRight:AddSlider("Brightness", { Text = "ความสว่าง", Default = 0, Min = -1, Max = 1, Rounding = 2 })
ClientRight:AddSlider("Opacity", { Text = "ความทึบ", Default = 1, Min = 0, Max = 1, Rounding = 2 })

local EspObjects = {}
local FovCircle = Drawing.new("Circle")
FovCircle.Visible = false
FovCircle.Thickness = 1
FovCircle.Filled = false
FovCircle.NumSides = 64
FovCircle.ZIndex = 10

local FovGlowCircle = Drawing.new("Circle")
FovGlowCircle.Visible = false
FovGlowCircle.Thickness = 3
FovGlowCircle.Filled = false
FovGlowCircle.NumSides = 64
FovGlowCircle.ZIndex = 9

local SilentFovCircle = Drawing.new("Circle")
SilentFovCircle.Visible = false
SilentFovCircle.Thickness = 1
SilentFovCircle.Filled = false
SilentFovCircle.NumSides = 360
SilentFovCircle.ZIndex = 10

local SilentFovGlowCircle = Drawing.new("Circle")
SilentFovGlowCircle.Visible = false
SilentFovGlowCircle.Thickness = 3
SilentFovGlowCircle.Filled = false
SilentFovGlowCircle.NumSides = 64
SilentFovGlowCircle.ZIndex = 9

local RageText = Drawing.new("Text")
RageText.Visible = false
RageText.Size = 16
RageText.Center = true
RageText.Outline = true
RageText.Font = 3
RageText.Color = Color3.fromRGB(0, 255, 128)
RageText.ZIndex = 20

local lastShot = 0
local lastRage = 0
local lastTrigger = 0
local lastKnifeAura = 0
local lastKnifeThrow = 0
local rageState = "idle"
local rageTargetName = ""
local voidSavedCFrame = nil
local voidHadAnchor = false
local origFallenHeight = nil
local IsVoidHolding  
local originalCooldowns = {}
local originalSizes = {}
local pendingHits = {}
local aaAngle = 0
local soundFolder
local oldNamecall
local CachedMousePos = Vector2.new(400, 300)
local AnimatorConnections = {}

local function EnsureSoundFolder()
	if soundFolder and soundFolder.Parent then return soundFolder end
	soundFolder = Instance.new("Folder")
	soundFolder.Name = "NEXPRA_Sounds"
	soundFolder.Parent = SoundService
	return soundFolder
end

local function PlaySound(id, volume)
	local folder = EnsureSoundFolder()
	local s = Instance.new("Sound")
	s.SoundId = id
	s.Volume = volume or 1
	s.PlayOnRemove = false
	s.Parent = folder
	s:Play()
	s.Ended:Connect(function() s:Destroy() end)
	task.delay(5, function() if s and s.Parent then s:Destroy() end end)
end

local function CreateDrawing(class, props)
	local obj = Drawing.new(class)
	for k, v in pairs(props or {}) do obj[k] = v end
	return obj
end

local function RemoveDrawings(player)
	local data = EspObjects[player]
	if not data then return end
	for _, v in pairs(data) do
		if typeof(v) == "table" then
			for _, d in pairs(v) do pcall(function() d:Remove() end) end
		else
			pcall(function() v:Remove() end)
		end
	end
	EspObjects[player] = nil
end

local function GetCharacterParts(character)
	local parts = {}
	for _, child in ipairs(character:GetDescendants()) do
		if child:IsA("BasePart") then table.insert(parts, child) end
	end
	return parts
end

local function GetBoxCorners(character)
	local parts = GetCharacterParts(character)
	if #parts == 0 then return nil end
	local minV = Vector3.new(math.huge, math.huge, math.huge)
	local maxV = Vector3.new(-math.huge, -math.huge, -math.huge)
	for _, part in ipairs(parts) do
		local cf = part.CFrame
		local size = part.Size * 0.5
		local corners = {
			cf * Vector3.new( size.X,  size.Y,  size.Z),
			cf * Vector3.new(-size.X,  size.Y,  size.Z),
			cf * Vector3.new( size.X, -size.Y,  size.Z),
			cf * Vector3.new(-size.X, -size.Y,  size.Z),
			cf * Vector3.new( size.X,  size.Y, -size.Z),
			cf * Vector3.new(-size.X,  size.Y, -size.Z),
			cf * Vector3.new( size.X, -size.Y, -size.Z),
			cf * Vector3.new(-size.X, -size.Y, -size.Z),
		}
		for _, c in ipairs(corners) do
			minV = Vector3.new(math.min(minV.X, c.X), math.min(minV.Y, c.Y), math.min(minV.Z, c.Z))
			maxV = Vector3.new(math.max(maxV.X, c.X), math.max(maxV.Y, c.Y), math.max(maxV.Z, c.Z))
		end
	end
	return minV, maxV
end

local function WorldToScreen(worldPos)
	local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)
	return Vector2.new(screenPos.X, screenPos.Y), onScreen and screenPos.Z > 0, screenPos.Z
end

local function IsTeammate(player)
	if not Toggles.TeamCheck.Value then return false end
	if LocalPlayer.Team and player.Team then
		return LocalPlayer.Team == player.Team
	end
	return false
end

local function IsEspTeammate(player)
	if not Toggles.EspTeamCheck.Value then return false end
	if LocalPlayer.Team and player.Team then
		return LocalPlayer.Team == player.Team
	end
	return false
end

local function EnsureEsp(player)
	if EspObjects[player] then return EspObjects[player] end
	local data = {
		Box = CreateDrawing("Square", {Visible = false, Thickness = 1, Filled = false, ZIndex = 2}),
		BoxFill = CreateDrawing("Square", {Visible = false, Thickness = 1, Filled = true, ZIndex = 1}),
		BoxOutline = CreateDrawing("Square", {Visible = false, Thickness = 3, Filled = false, ZIndex = 1}),
		Name = CreateDrawing("Text", {Visible = false, Size = 14, Center = true, Outline = true, Font = 2, ZIndex = 5}),
		HealthText = CreateDrawing("Text", {Visible = false, Size = 13, Center = false, Outline = true, Font = 2, ZIndex = 5}),
		HealthBarBg = CreateDrawing("Square", {Visible = false, Thickness = 1, Filled = true, ZIndex = 2}),
		HealthBar = CreateDrawing("Square", {Visible = false, Thickness = 1, Filled = true, ZIndex = 3}),
		Distance = CreateDrawing("Text", {Visible = false, Size = 13, Center = true, Outline = true, Font = 2, ZIndex = 5}),
		Tracer = CreateDrawing("Line", {Visible = false, Thickness = 1, ZIndex = 2}),
		Tool = CreateDrawing("Text", {Visible = false, Size = 13, Center = true, Outline = true, Font = 2, ZIndex = 5}),
		Corners = {}, Box3D = {}, Skeleton = {},
	}
	for i = 1, 8 do data.Corners[i] = CreateDrawing("Line", {Visible = false, Thickness = 1, ZIndex = 2}) end
	for i = 1, 12 do data.Box3D[i] = CreateDrawing("Line", {Visible = false, Thickness = 1, ZIndex = 2}) end
	for i = 1, 14 do data.Skeleton[i] = CreateDrawing("Line", {Visible = false, Thickness = 1, ZIndex = 2}) end
	EspObjects[player] = data
	return data
end

local function HideAll(data)
	data.Box.Visible = false
	data.BoxFill.Visible = false
	data.BoxOutline.Visible = false
	data.Name.Visible = false
	data.HealthText.Visible = false
	data.HealthBarBg.Visible = false
	data.HealthBar.Visible = false
	data.Distance.Visible = false
	data.Tracer.Visible = false
	data.Tool.Visible = false
	for i = 1, 8 do data.Corners[i].Visible = false end
	for i = 1, 12 do data.Box3D[i].Visible = false end
	for i = 1, 14 do data.Skeleton[i].Visible = false end
end

local function IsInWorkspace(character)
	return character and character:IsA("Model") and character:IsDescendantOf(workspace)
end

local function IsAlive(player)
	local char = player.Character
	if not IsInWorkspace(char) then return false end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	return hum and root and hum.Health > 0
end

local function GetRayOrigin()
	local char = LocalPlayer.Character
	if not char then return nil end
	local head = char:FindFirstChild("Head")
	if head then return head.Position end
	local root = char:FindFirstChild("HumanoidRootPart")
	if root then return root.Position + Vector3.new(0, 1.5, 0) end
	return nil
end

local function GetHitPart(character, partName)
	return character:FindFirstChild(partName) or character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
end

local function HasLineOfSight(fromPos, toPart)
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {LocalPlayer.Character}
	params.FilterType = Enum.RaycastFilterType.Exclude
	local dir = (toPart.Position - fromPos)
	local result = workspace:Raycast(fromPos, dir, params)
	if not result then return true end
	local hitModel = result.Instance:FindFirstAncestorOfClass("Model")
	if hitModel and hitModel == toPart.Parent then return true end
	if result.Instance:IsDescendantOf(toPart.Parent) then return true end
	return false
end

local function GetClosestTarget(method, fovEnabled, fovSize, wallCheck)
	local best, bestScore = nil, math.huge
	local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local origin = GetRayOrigin()

	for _, player in ipairs(Players:GetPlayers()) do
		if player == LocalPlayer or not IsAlive(player) then continue end
		if IsTeammate(player) then continue end

		local root = player.Character.HumanoidRootPart
		local head = player.Character:FindFirstChild("Head") or root
		local screenPos, onScreen = WorldToScreen(head.Position)
		if not onScreen then continue end

		if fovEnabled then
			if (screenPos - center).Magnitude > fovSize then continue end
		end

		if wallCheck and origin then
			if not HasLineOfSight(origin, head) then continue end
		end

		local score
		if method == "Closest to Center" then
			score = (screenPos - center).Magnitude
		else
			if not localRoot then continue end
			score = (root.Position - localRoot.Position).Magnitude
		end

		if score < bestScore then
			bestScore = score
			best = player
		end
	end
	return best
end

local function GetPingSeconds()
	local ok, ping = pcall(function()
		return LocalPlayer:GetNetworkPing()
	end)
	if ok and typeof(ping) == "number" and ping == ping and ping > 0 then
		return math.clamp(ping, 0, 0.5)
	end
	local ok2, pingMs = pcall(function()
		return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
	end)
	if ok2 and typeof(pingMs) == "number" and pingMs == pingMs and pingMs > 0 then
		return math.clamp(pingMs / 1000, 0, 0.5)
	end
	return 0.06
end

 
 
local function GetTargetVelocity(character, targetPart)
	local vel = Vector3.zero
	pcall(function()
		local root = character and character:FindFirstChild("HumanoidRootPart")
		local src = root or targetPart
		if not src then return end
		local v = src.AssemblyLinearVelocity
		if typeof(v) ~= "Vector3" or v.Magnitude < 0.5 then
			local v2 = src.Velocity
			if typeof(v2) == "Vector3" and v2.Magnitude >= 0.5 then
				v = v2
			else
				return
			end
		end
		 
		local hum = character and character:FindFirstChildOfClass("Humanoid")
		local grounded = false
		if hum then
			local fm = hum.FloorMaterial
			grounded = fm and fm ~= Enum.Material.Air
		end
		if grounded then
			v = Vector3.new(v.X, 0, v.Z)
		else
			v = Vector3.new(v.X, v.Y * 0.35, v.Z)
		end
		 
		if v.Magnitude < 1 then
			vel = Vector3.zero
		elseif v.Magnitude > 60 then
			vel = v.Unit * 60
		else
			vel = v
		end
	end)
	return vel
end

 
 
 
 
local function ValidateAim(origin, aimPos, character)
	local ok, hitPos = pcall(function()
		local dir = aimPos - origin
		local dist = dir.Magnitude
		if dist < 1 or dist > 2000 then return nil end
		local params = RaycastParams.new()
		params.FilterDescendantsInstances = { LocalPlayer.Character }
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.IgnoreWater = true
		local result = workspace:Raycast(origin, dir, params)
		if not result then return nil end
		local inst = result.Instance
		if not inst then return nil end
		if inst:IsDescendantOf(character) then
			return result.Position
		end
		return nil
	end)
	if ok then
		return hitPos
	end
	return nil
end

local function GetPredictionLead()
	local ok, lead = pcall(function()
		local pred = Toggles.SilentPrediction
		if pred and not pred.Value then
			return 0
		end
		local auto = Toggles.SilentAutoPrediction
		if auto and auto.Value then
			return GetPingSeconds()
		end
		local amt = Options.SilentPredictionAmount and Options.SilentPredictionAmount.Value
		return math.clamp(tonumber(amt) or 0.12, 0, 0.5)
	end)
	if ok and typeof(lead) == "number" then
		return lead
	end
	return 0
end

 
 
 
local function GetSilentAimTarget(mousePos)
	local ok, bestPart, bestPoint, bestPredicted = pcall(function()
		if not Toggles.SilentAimEnabled.Value then return nil end
		local hitChance = tonumber(Options.SilentHitChance.Value) or 100
		if math.random(0, 100) > hitChance then return nil end

		local hitPartName = Options.SilentHitPart.Value
		if typeof(hitPartName) ~= "string" then
			hitPartName = "Head"
		end
		local fov = tonumber(Options.SilentFovSize.Value) or 200
		local useFov = Toggles.SilentFovEnabled.Value
		local closestDistance = useFov and fov or math.huge
		if typeof(mousePos) ~= "Vector2" then return nil end

		local wallCheck = true
		pcall(function()
			if Toggles.SilentWallCheck then
				wallCheck = Toggles.SilentWallCheck.Value
			end
		end)
		local lead = GetPredictionLead()
		local origin
		if wallCheck then
			local s, o = pcall(GetRayOrigin)
			if s then origin = o end
		end

		local part, point, predicted
		for _, player in ipairs(Players:GetPlayers()) do
			if player == LocalPlayer then continue end
			local s, alive = pcall(IsAlive, player)
			if not s or not alive then continue end
			local s2, tm = pcall(IsTeammate, player)
			if s2 and tm then continue end

			local character = player.Character
			if not character then continue end
			local targetPart = character:FindFirstChild(hitPartName)
				or character:FindFirstChild("Head")
				or character:FindFirstChild("HumanoidRootPart")
			if not targetPart then continue end

			 
			if wallCheck and origin then
				local s3, visible = pcall(HasLineOfSight, origin, targetPart)
				if s3 and not visible then continue end
			end

			 
			local aimPos = targetPart.Position
			if lead > 0 then
				local vel = GetTargetVelocity(character, targetPart)
				if vel.Magnitude > 0.5 then
					aimPos = aimPos + vel * lead
				end
			end

			local okWs, sp, onScreen = pcall(function()
				return Camera:WorldToViewportPoint(aimPos)
			end)
			if not okWs or not onScreen then continue end

			local screenPoint = Vector2.new(sp.X, sp.Y)
			local dist = (screenPoint - mousePos).Magnitude
			if dist < closestDistance then
				closestDistance = dist
				part = targetPart
				point = screenPoint
				predicted = aimPos
			end
		end
		return part, point, predicted
	end)
	if ok and bestPart then
		return bestPart, bestPoint, bestPredicted
	end
	return nil
end

local function SilentTargetPoint(mousePos)
	local _, point = GetSilentAimTarget(mousePos or CachedMousePos)
	return point
end

local function FireRemote(origin, aimPos, hitInstance, hitPos)
	pcall(function()
		ShootGun:FireServer(origin, aimPos, hitInstance, hitPos)
	end)
end

local function GetCurrentGun()
	local char = LocalPlayer.Character
	if not char then return nil end
	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") then
			if tool:GetAttribute("Cooldown") ~= nil or CollectionService:HasTag(tool, "GunTool") or tool:FindFirstChild("Muzzle", true) then
				return tool
			end
		end
	end
	return nil
end

local function GetCurrentKnife()
	local char = LocalPlayer.Character
	if not char then return nil end
	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") then
			if CollectionService:HasTag(tool, "KnifeTool") or tool:FindFirstChild("RightHandle") or tool.Name:lower():find("knife") then
				return tool
			end
		end
	end
	return nil
end

local function GetAnyGun()
	local char = LocalPlayer.Character
	local backpack = LocalPlayer:FindFirstChild("Backpack")
	for _, container in ipairs({char, backpack}) do
		if not container then continue end
		for _, tool in ipairs(container:GetChildren()) do
			if tool:IsA("Tool") then
				if tool:GetAttribute("Cooldown") ~= nil or CollectionService:HasTag(tool, "GunTool") or tool:FindFirstChild("Muzzle", true) then
					return tool
				end
			end
		end
	end
	return nil
end

local function GetAnyKnife()
	local char = LocalPlayer.Character
	local backpack = LocalPlayer:FindFirstChild("Backpack")
	for _, container in ipairs({char, backpack}) do
		if not container then continue end
		for _, tool in ipairs(container:GetChildren()) do
			if tool:IsA("Tool") then
				if CollectionService:HasTag(tool, "KnifeTool") or tool:FindFirstChild("RightHandle") or tool.Name:lower():find("knife") then
					return tool
				end
			end
		end
	end
	return nil
end

local function EnsureGunEquipped()
	local gun = GetCurrentGun()
	if gun then return gun end
	if not (Toggles.AutoEquipGun.Value or Toggles.ForceGunEnabled.Value) then return nil end
	local any = GetAnyGun()
	if any and any.Parent == LocalPlayer.Backpack then
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then pcall(function() hum:EquipTool(any) end) end
		return GetCurrentGun()
	end
	return nil
end

local function EnsureKnifeEquipped()
	local knife = GetCurrentKnife()
	if knife then return knife end
	if not Toggles.AutoEquipKnife.Value then return nil end
	local any = GetAnyKnife()
	if any and any.Parent == LocalPlayer.Backpack then
		local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then pcall(function() hum:EquipTool(any) end) end
		return GetCurrentKnife()
	end
	return nil
end

local function GetEffectiveCooldown(gun)
	if Toggles.NoGunCooldown.Value then return 0 end
	if Toggles.UseCustomCooldown.Value then return Options.CustomCooldown.Value end
	return gun:GetAttribute("Cooldown") or 0.05
end

local function ApplyGunMods()
	local gun = GetCurrentGun() or GetAnyGun()
	if not gun then return end
	if Toggles.NoGunCooldown.Value then
		if originalCooldowns[gun] == nil then originalCooldowns[gun] = gun:GetAttribute("Cooldown") end
		gun:SetAttribute("Cooldown", 0)
	elseif Toggles.UseCustomCooldown.Value then
		if originalCooldowns[gun] == nil then originalCooldowns[gun] = gun:GetAttribute("Cooldown") end
		gun:SetAttribute("Cooldown", Options.CustomCooldown.Value)
	elseif originalCooldowns[gun] ~= nil then
		gun:SetAttribute("Cooldown", originalCooldowns[gun])
		originalCooldowns[gun] = nil
	end
	if Toggles.ForceGunEnabled.Value then pcall(function() gun.Enabled = true end) end
	EnsureGunEquipped()
end

local function RegisterPendingHit(player, hitPartName)
	pendingHits[player] = {
		part = hitPartName,
		time = tick(),
		health = player.Character and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health or 0,
	}
end

local function ProcessHitConfirmations()
	for player, data in pairs(pendingHits) do
		if tick() - data.time > 1.5 then
			pendingHits[player] = nil
			continue
		end
		if not player.Parent then
			if Toggles.KillSoundsEnabled.Value then
				local id = soundsassets[Options.KillSoundType.Value]
				if id then PlaySound(id, Options.KillSoundVolume.Value) end
			end
			if Toggles.RagebotNotify.Value and Toggles.RagebotEnabled.Value then
				Library:Notify({ Title = "ยิงอัตโนมัติ", Description = 'ยิงโดน "' .. (player.DisplayName or "?") .. '" บริเวณ "' .. data.part .. '" (กำจัดแล้ว)', Time = 3 })
			end
			pendingHits[player] = nil
			continue
		end
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum and hum.Health < data.health then
			if Toggles.HitSoundsEnabled.Value then
				local id = soundsassets[Options.HitSoundType.Value]
				if id then PlaySound(id, Options.HitSoundVolume.Value) end
			end
			if hum.Health <= 0 and Toggles.KillSoundsEnabled.Value then
				local id = soundsassets[Options.KillSoundType.Value]
				if id then PlaySound(id, Options.KillSoundVolume.Value) end
			end
			if Toggles.RagebotNotify.Value and Toggles.RagebotEnabled.Value then
				Library:Notify({ Title = "ยิงอัตโนมัติ", Description = 'ยิงโดน "' .. player.DisplayName .. '" บริเวณ "' .. data.part .. '"', Time = 3 })
			end
			pendingHits[player] = nil
		end
	end
end

if not oldNamecall then
	local _unpack = table.unpack or unpack
	oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
		local method = getnamecallmethod()
		local args = { ... }

		 
		local okCaller, isExecutor = pcall(checkcaller)
		if okCaller and isExecutor then
			return oldNamecall(self, ...)
		end

		 
		 
		if self == ShootGun and (method == "FireServer" or method == "fireServer") then
			local ok, newArgs = pcall(function()
				if not Toggles.SilentAimEnabled.Value then return nil end
				local targetPart, _, predicted = GetSilentAimTarget(CachedMousePos)
				if not targetPart then return nil end
				 
				local origin = args[1]
				if typeof(origin) ~= "Vector3" then return nil end
				local character = targetPart.Parent
				 
				 
				if predicted then
					local surface = ValidateAim(origin, predicted, character)
					if surface then
						return { origin, surface, targetPart, surface }
					end
					 
				end
				 
				local current = targetPart.Position
				local surfaceNow = ValidateAim(origin, current, character)
				if surfaceNow then
					return { origin, surfaceNow, targetPart, surfaceNow }
				end
				 
				 
				return nil
			end)
			if ok and newArgs then
				return oldNamecall(self, _unpack(newArgs))
			end
			return oldNamecall(self, ...)
		end

		 
		if self == UserInputService and method == "GetMouseLocation" then
			local ok, realMouse = pcall(oldNamecall, self, ...)
			if not ok then
				return oldNamecall(self, ...)
			end
			local ok2, point = pcall(SilentTargetPoint, realMouse)
			if ok2 and point then
				return point
			end
			return realMouse
		end

		return oldNamecall(self, ...)
	end))
end

local function restoreHiddenHead(char)
	for part, data in pairs(hmndbreaker.HeadHidden) do
		if part and part.Parent then
			part.Transparency = data.Transparency
			part.CanCollide = data.CanCollide
			if data.Size then part.Size = data.Size end
			if data.CFrame then part.CFrame = data.CFrame end
		end
	end
	hmndbreaker.HeadHidden = {}
end

local function hideCharacterHead(char)
	if not char then return end
	local head = char:FindFirstChild("Head")
	if head and not hmndbreaker.HeadHidden[head] then
		hmndbreaker.HeadHidden[head] = {
			Transparency = head.Transparency,
			CanCollide = head.CanCollide,
			Size = head.Size,
			CFrame = head.CFrame,
		}
		head.Transparency = 1
		head.CanCollide = false
		head.Size = Vector3.new(0.05, 0.05, 0.05)
	end
	for _, inst in ipairs(char:GetChildren()) do
		if inst:IsA("Accessory") then
			local handle = inst:FindFirstChild("Handle")
			if handle and not hmndbreaker.HeadHidden[handle] then
				hmndbreaker.HeadHidden[handle] = {
					Transparency = handle.Transparency,
					CanCollide = handle.CanCollide,
					Size = handle.Size,
					CFrame = handle.CFrame,
				}
				handle.Transparency = 1
				handle.CanCollide = false
				handle.Size = Vector3.new(0.05, 0.05, 0.05)
			end
		end
	end
end

local function ClearAnimations(char)
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local animator = hum:FindFirstChildOfClass("Animator")
	if not animator then return end
	for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
		pcall(function()
			track:Stop(0)
			track:Destroy()
		end)
	end
	local animate = char:FindFirstChild("Animate")
	if animate then
		pcall(function() animate.Disabled = true end)
	end
end

local function HookAnimator(char)
	for _, c in ipairs(AnimatorConnections) do
		pcall(function() c:Disconnect() end)
	end
	AnimatorConnections = {}
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
	if not hum then return end
	local animator = hum:FindFirstChildOfClass("Animator") or hum:WaitForChild("Animator", 5)
	if not animator then return end
	ClearAnimations(char)
	table.insert(AnimatorConnections, animator.AnimationPlayed:Connect(function(track)
		if Toggles.AntiAimEnabled.Value then
			pcall(function()
				track:Stop(0)
				track:Destroy()
			end)
		end
	end))
	local animate = char:FindFirstChild("Animate")
	if animate then
		pcall(function() animate.Disabled = true end)
	end
end

local function RestoreAnimations(char)
	if not char then return end
	local animate = char:FindFirstChild("Animate")
	if animate then
		pcall(function() animate.Disabled = false end)
	end
	for _, c in ipairs(AnimatorConnections) do
		pcall(function() c:Disconnect() end)
	end
	AnimatorConnections = {}
end

local function StopBreaker()
	hmndbreaker.Active = false
	if hmndbreaker.Heartbeat then
		hmndbreaker.Heartbeat:Disconnect()
		hmndbreaker.Heartbeat = nil
	end
	if hmndbreaker.AnimConnection then
		hmndbreaker.AnimConnection:Disconnect()
		hmndbreaker.AnimConnection = nil
	end
	if hmndbreaker.Track then
		pcall(function() hmndbreaker.Track:Stop() end)
		hmndbreaker.Track = nil
	end
	local char = LocalPlayer.Character
	if char then restoreHiddenHead(char) end
end

local function StartBreaker()
	if hmndbreaker.Active then return end
	local char = LocalPlayer.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not hum or not root then return end

	hmndbreaker.Active = true
	hmndbreaker.SpinSpeed = Options.BreakerSpinSpeed.Value
	hmndbreaker.BounceIntensity = Options.BreakerBounce.Value
	hmndbreaker.Mode = Options.BreakerMode.Value
	hmndbreaker.BouncePhase = 0
	hmndbreaker.SolarAngle = 0

	if Toggles.BreakerHideHead.Value then
		hideCharacterHead(char)
	end

	pcall(function()
		local anim = Instance.new("Animation")
		anim.AnimationId = hmndbreaker.EmoteId
		hmndbreaker.Track = hum:LoadAnimation(anim)
		hmndbreaker.Track:Play()
		hmndbreaker.Track:AdjustSpeed(0)
	end)

	hmndbreaker.Heartbeat = RunService.Heartbeat:Connect(function(dt)
		if not hmndbreaker.Active or not Toggles.AntiAimEnabled.Value or Options.AntiAimMode.Value ~= "Breaker" then
			StopBreaker()
			return
		end
		char = LocalPlayer.Character
		if not char then StopBreaker() return end
		root = char:FindFirstChild("HumanoidRootPart")
		hum = char:FindFirstChildOfClass("Humanoid")
		if not root or not hum or hum.Health <= 0 then StopBreaker() return end

		 
		if IsVoidHolding() then return end

		hmndbreaker.SpinSpeed = Options.BreakerSpinSpeed.Value
		hmndbreaker.BounceIntensity = Options.BreakerBounce.Value
		hmndbreaker.Mode = Options.BreakerMode.Value

		if Toggles.BreakerHideHead.Value then
			hideCharacterHead(char)
		end

		local pos = root.Position
		local yaw = tick() * hmndbreaker.SpinSpeed

		if hmndbreaker.Mode == "solar" then
			hmndbreaker.SolarAngle = hmndbreaker.SolarAngle + dt * hmndbreaker.SpinSpeed
			local ox = math.cos(math.rad(hmndbreaker.SolarAngle)) * hmndbreaker.SolarRadius * 0.05
			local oz = math.sin(math.rad(hmndbreaker.SolarAngle)) * hmndbreaker.SolarRadius * 0.05
			pos = pos + Vector3.new(ox, 0, oz)
		else
			hmndbreaker.BouncePhase = hmndbreaker.BouncePhase + dt * 10
			local bounce = math.sin(hmndbreaker.BouncePhase) * hmndbreaker.BounceIntensity * 0.05
			pos = pos + Vector3.new(0, bounce, 0)
		end

		pcall(function()
			root.CFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(yaw % 360), 0)
			root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z)
		end)
	end)
end

IsVoidHolding = function()
	local ok, holding = pcall(function()
		return Toggles.RagebotEnabled.Value and Toggles.RagebotVoid.Value
	end)
	return ok and holding
end

local function UpdateRageVoid()
	if not IsVoidHolding() then
		 
		if voidSavedCFrame then
			local char = LocalPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root then
				pcall(function()
					root.Anchored = voidHadAnchor or false
					root.CFrame = voidSavedCFrame
					root.AssemblyLinearVelocity = Vector3.zero
					root.AssemblyAngularVelocity = Vector3.zero
				end)
			end
			voidSavedCFrame = nil
		end
		if origFallenHeight ~= nil then
			pcall(function()
				workspace.FallenPartsDestroyHeight = origFallenHeight
			end)
			origFallenHeight = nil
		end
		return
	end

	local char = LocalPlayer.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not root or not hum or hum.Health <= 0 then return end

	if not voidSavedCFrame then
		voidSavedCFrame = root.CFrame
		voidHadAnchor = root.Anchored
		pcall(function()
			if origFallenHeight == nil then
				origFallenHeight = workspace.FallenPartsDestroyHeight
			end
			workspace.FallenPartsDestroyHeight = -200000
		end)
	end

	local voidY = -100000
	pcall(function()
		if Options.RagebotVoidY then
			voidY = math.clamp(tonumber(Options.RagebotVoidY.Value) or -100000, -100000, -200)
		end
	end)

	 
	pcall(function()
		root.Anchored = true
		root.CanCollide = false
		root.CFrame = CFrame.new(voidSavedCFrame.X, voidY, voidSavedCFrame.Z)
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
	end)
end

local function DoRagebot()
	if not Toggles.RagebotEnabled.Value then
		rageState = "idle"
		rageTargetName = ""
		return
	end

	local delay = Options.RagebotDelay.Value
	if tick() - lastRage < delay then
		if rageState == "attacking" then rageState = "cooldown" end
		return
	end

	local gun = EnsureGunEquipped()
	if not gun then
		rageState = "no gun"
		rageTargetName = ""
		return
	end

	if Toggles.ForceGunEnabled.Value then
		pcall(function() gun.Enabled = true end)
	end

	local cooldown = GetEffectiveCooldown(gun)
	if tick() - lastShot < cooldown then
		rageState = "cooldown"
		return
	end

	local target = GetClosestTarget(Options.RagebotTargetMethod.Value, false, 0, false)
	if not target or not IsInWorkspace(target.Character) then
		rageState = "scanning"
		rageTargetName = ""
		return
	end

	 
	 
	local origin
	if IsVoidHolding() and voidSavedCFrame then
		origin = voidSavedCFrame.Position + Vector3.new(0, 1.5, 0)
	else
		origin = GetRayOrigin()
	end
	if not origin then
		rageState = "no origin"
		return
	end

	local hitPart = GetHitPart(target.Character, Options.RagebotHitPart.Value)
	if not hitPart then
		rageState = "no hitpart"
		return
	end

	local hitPos = hitPart.Position
	lastRage = tick()
	lastShot = tick()
	rageState = "attacking"
	rageTargetName = target.DisplayName

	FireRemote(origin, hitPos, hitPart, hitPos)
	RegisterPendingHit(target, hitPart.Name)
end

local function UpdateRageVisualizer()
	if not Toggles.RagebotVisualizer.Value or not Toggles.RagebotEnabled.Value then
		RageText.Visible = false
		return
	end
	local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 + 40)
	RageText.Visible = true
	RageText.Position = center
	RageText.Font = 3
	RageText.Size = 16
	RageText.Center = true
	RageText.Outline = true
	local voidTag = IsVoidHolding() and " + void" or ""
	if rageState == "attacking" then
		RageText.Text = "กำลังโจมตี -> " .. rageTargetName .. voidTag
		RageText.Color = Color3.fromRGB(255, 60, 60)
	elseif rageState == "cooldown" then
		RageText.Text = "กำลังรอคูลดาวน์" .. voidTag
		RageText.Color = Color3.fromRGB(255, 180, 40)
	elseif rageState == "scanning" then
		RageText.Text = "กำลังค้นหาเป้าหมาย" .. voidTag
		RageText.Color = Color3.fromRGB(80, 200, 255)
	elseif rageState == "no gun" then
		RageText.Text = "ไม่พบปืน" .. voidTag
		RageText.Color = Color3.fromRGB(160, 160, 160)
	else
		RageText.Text = "พร้อมใช้งาน" .. voidTag
		RageText.Color = Color3.fromRGB(0, 255, 128)
	end
end

local function DoKnifeAura()
	if not Toggles.KnifeKillAura.Value then return end
	if tick() - lastKnifeAura < Options.KnifeAuraDelay.Value then return end
	if not StabRemote then return end
	local knife = EnsureKnifeEquipped()
	if not knife then return end
	local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not localRoot then return end
	local range = Options.KnifeAuraRange.Value
	for _, player in ipairs(Players:GetPlayers()) do
		if player == LocalPlayer or not IsAlive(player) or IsTeammate(player) then continue end
		local root = player.Character.HumanoidRootPart
		local head = player.Character:FindFirstChild("Head") or root
		if (root.Position - localRoot.Position).Magnitude <= range then
			lastKnifeAura = tick()
			pcall(function() StabRemote:FireServer(head) end)
			RegisterPendingHit(player, head.Name)
			break
		end
	end
end

local function DoKnifeThrow()
	if not Toggles.KnifeAutoThrow.Value then return end
	if tick() - lastKnifeThrow < Options.KnifeThrowDelay.Value then return end
	if not ThrowStart or not ThrowHit then return end
	local knife = EnsureKnifeEquipped()
	if not knife then return end
	local origin = GetRayOrigin()
	if not origin then return end
	local target = GetClosestTarget("Distance", false, 0, false)
	if not target then return end
	local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not localRoot then return end
	local hitPart = target.Character:FindFirstChild("Head") or target.Character.HumanoidRootPart
	local dist = (hitPart.Position - localRoot.Position).Magnitude
	if dist > Options.KnifeThrowRange.Value then return end
	local direction = (hitPart.Position - origin).Unit
	lastKnifeThrow = tick()
	pcall(function()
		ThrowStart:FireServer(origin, direction)
		if Toggles.KnifeSilentThrow.Value then
			ThrowHit:FireServer(hitPart, hitPart.Position)
		end
	end)
	RegisterPendingHit(target, hitPart.Name)
end

local function DoTriggerbot()
	if not Toggles.TriggerbotEnabled.Value then return end
	local delay = Options.TriggerbotDelay.Value
	if tick() - lastTrigger < delay then return end
	local gun = EnsureGunEquipped()
	if not gun then return end
	local cooldown = GetEffectiveCooldown(gun)
	if tick() - lastShot < cooldown then return end
	local method = Options.TriggerbotMethod.Value
	local target = nil
	local origin = GetRayOrigin()
	if not origin then return end

	local function resolveFromRay(unitRay)
		local params = RaycastParams.new()
		params.FilterDescendantsInstances = {LocalPlayer.Character}
		params.FilterType = Enum.RaycastFilterType.Exclude
		local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 2000, params)
		if not result or not result.Instance then return nil end
		local model = result.Instance:FindFirstAncestorOfClass("Model")
		if not model or not model:IsDescendantOf(workspace) then return nil end
		local plr = Players:GetPlayerFromCharacter(model)
		if plr and plr ~= LocalPlayer and IsAlive(plr) and not IsTeammate(plr) then
			if Toggles.TriggerbotWallCheck.Value then
				local head = model:FindFirstChild("Head") or model:FindFirstChild("HumanoidRootPart")
				if head and not HasLineOfSight(origin, head) then return nil end
			end
			return plr
		end
		return nil
	end

	if method == "Mouse" then
		local mouseLoc = UserInputService:GetMouseLocation()
		target = resolveFromRay(Camera:ViewportPointToRay(mouseLoc.X, mouseLoc.Y))
	else
		local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
		target = resolveFromRay(Camera:ViewportPointToRay(center.X, center.Y))
	end

	if target then
		local hitPart = GetHitPart(target.Character, Options.TriggerbotHitPart.Value)
		if not hitPart then return end
		if Toggles.TriggerbotWallCheck.Value and not HasLineOfSight(origin, hitPart) then return end
		lastTrigger = tick()
		lastShot = tick()
		FireRemote(origin, hitPart.Position, hitPart, hitPart.Position)
		RegisterPendingHit(target, hitPart.Name)
	end
end

local function UpdateAimbot()
	if not Toggles.AimbotEnabled.Value then return end
	if not Options.AimbotKeybind:GetState() then return end
	local target = GetClosestTarget(Options.TargetMethod.Value, Toggles.FovEnabled.Value, Options.FovSize.Value, false)
	if not target then return end
	local head = target.Character:FindFirstChild("Head") or target.Character.HumanoidRootPart
	local aimPos = head.Position
	local method = Options.AimbotMethod.Value
	local smooth = math.max(Options.AimbotSmoothing.Value, 1)
	if method == "Camera" then
		local current = Camera.CFrame
		Camera.CFrame = current:Lerp(CFrame.lookAt(current.Position, aimPos), 1 / smooth)
	else
		local screenPos = Camera:WorldToViewportPoint(aimPos)
		local mousePos = UserInputService:GetMouseLocation()
		local delta = Vector2.new(screenPos.X - mousePos.X, screenPos.Y - mousePos.Y) / smooth
		pcall(function() mousemoverel(delta.X, delta.Y) end)
	end
end

local function UpdateFov()
	local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	local mousePos = UserInputService:GetMouseLocation()
	pcall(function()
		if typeof(mousePos) == "Vector2" then
			CachedMousePos = mousePos
		end
	end)

	if Toggles.FovDraw.Value and Toggles.FovEnabled.Value then
		FovCircle.Visible = true
		FovCircle.Position = center
		FovCircle.Radius = Options.FovSize.Value
		FovCircle.Color = Options.FovColor.Value
		if Toggles.FovGlow.Value then
			FovGlowCircle.Visible = true
			FovGlowCircle.Position = center
			FovGlowCircle.Radius = Options.FovSize.Value
			FovGlowCircle.Color = Options.FovGlowColor.Value
			FovGlowCircle.Transparency = 0.5
		else
			FovGlowCircle.Visible = false
		end
	else
		FovCircle.Visible = false
		FovGlowCircle.Visible = false
	end

	if Toggles.SilentFovDraw.Value and Toggles.SilentAimEnabled.Value then
		SilentFovCircle.Visible = true
		SilentFovCircle.Position = mousePos
		SilentFovCircle.Radius = Options.SilentFovSize.Value
		SilentFovCircle.Color = Options.SilentFovColor.Value
		if Toggles.SilentFovGlow.Value then
			SilentFovGlowCircle.Visible = true
			SilentFovGlowCircle.Position = mousePos
			SilentFovGlowCircle.Radius = Options.SilentFovSize.Value
			SilentFovGlowCircle.Color = Options.SilentFovGlowColor.Value
			SilentFovGlowCircle.Transparency = 0.5
		else
			SilentFovGlowCircle.Visible = false
		end
	else
		SilentFovCircle.Visible = false
		SilentFovGlowCircle.Visible = false
	end
end

local function UpdateHitboxExpander()
	local size = Options.HitboxSize.Value
	for _, player in ipairs(Players:GetPlayers()) do
		if player == LocalPlayer then continue end
		if IsTeammate(player) then continue end
		local char = player.Character
		if not IsInWorkspace(char) then continue end
		for _, part in ipairs(char:GetChildren()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				if Toggles.HitboxExpander.Value then
					if not originalSizes[part] then originalSizes[part] = part.Size end
					part.Size = Vector3.new(size, size, size)
					part.Transparency = math.max(part.Transparency, 0.5)
					part.CanCollide = false
				elseif originalSizes[part] then
					part.Size = originalSizes[part]
					originalSizes[part] = nil
				end
			end
		end
	end
end

local function UpdateAntiAim()
	if not Toggles.AntiAimEnabled.Value then
		if hmndbreaker.Active then StopBreaker() end
		local char = LocalPlayer.Character
		if char then RestoreAnimations(char) end
		return
	end

	local char = LocalPlayer.Character
	if char then
		ClearAnimations(char)
	end

	local mode = Options.AntiAimMode.Value
	if mode == "Breaker" then
		if not hmndbreaker.Active then StartBreaker() end
		return
	else
		if hmndbreaker.Active then StopBreaker() end
	end

	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not root or not hum then return end

	local speed = Options.AntiAimSpeed.Value
	local yawAmt = Options.AntiAimYawAmount.Value

	if mode == "Spin" then
		aaAngle = (aaAngle + speed) % 360
	elseif mode == "Jitter" then
		aaAngle = (aaAngle + (math.random() > 0.5 and speed or -speed)) % 360
	elseif mode == "Invert" then
		aaAngle = yawAmt
	elseif mode == "Random" then
		aaAngle = math.random(0, 360)
	end

	if Toggles.AntiAimYaw.Value then
		local pos = root.Position
		pcall(function()
			root.CFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(aaAngle), 0)
		end)
	end
end

local function OverrideGameSounds()
	if not Toggles.OverrideGameHitSound.Value then return end
	for _, s in ipairs(workspace:GetDescendants()) do
		if s:IsA("Sound") and (s.Name:lower():find("hit") or s.Name:lower():find("damage") or s.Name:lower():find("hurt")) then
			s.Volume = 0
		end
	end
end

local function UpdateEsp()
	if not Toggles.EspEnabled.Value then
		for _, data in pairs(EspObjects) do HideAll(data) end
		return
	end
	local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local limit = Options.EspLimit.Value

	for _, player in ipairs(Players:GetPlayers()) do
		if player == LocalPlayer then continue end
		if IsEspTeammate(player) then
			if EspObjects[player] then HideAll(EspObjects[player]) end
			continue
		end
		local character = player.Character
		if not IsInWorkspace(character) then
			if EspObjects[player] then HideAll(EspObjects[player]) end
			continue
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local root = character:FindFirstChild("HumanoidRootPart")
		local head = character:FindFirstChild("Head")
		if not (humanoid and root and humanoid.Health > 0) then
			if EspObjects[player] then HideAll(EspObjects[player]) end
			continue
		end
		if localRoot and (root.Position - localRoot.Position).Magnitude > limit then
			if EspObjects[player] then HideAll(EspObjects[player]) end
			continue
		end

		local data = EnsureEsp(player)
		local rootScreen, rootOnScreen = WorldToScreen(root.Position)
		local headScreen, headOnScreen = head and WorldToScreen(head.Position + Vector3.new(0, 0.5, 0)) or Vector2.zero, false
		if not rootOnScreen then HideAll(data) continue end

		local minV, maxV = GetBoxCorners(character)
		if not minV then HideAll(data) continue end

		local positions = {}
		for _, part in ipairs(GetCharacterParts(character)) do
			local sp, on = WorldToScreen(part.Position)
			if on then table.insert(positions, sp) end
		end
		if #positions < 2 then HideAll(data) continue end

		local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
		for _, p in ipairs(positions) do
			minX = math.min(minX, p.X) minY = math.min(minY, p.Y)
			maxX = math.max(maxX, p.X) maxY = math.max(maxY, p.Y)
		end
		local boxPos = Vector2.new(minX, minY)
		local boxSize = Vector2.new(math.max(maxX - minX, 6), math.max(maxY - minY, 6))
		local boxColor = Options.EspBoxColor.Value
		local boxType = Options.BoxType.Value

		if Toggles.EspBox.Value then
			if boxType == "2D" then
				data.Box.Visible = true
				data.Box.Position = boxPos
				data.Box.Size = boxSize
				data.Box.Color = boxColor
				data.BoxOutline.Visible = Toggles.BoxGlow.Value
				if Toggles.BoxGlow.Value then
					data.BoxOutline.Position = boxPos
					data.BoxOutline.Size = boxSize
					data.BoxOutline.Color = Options.BoxGlowColor.Value
				end
				data.BoxFill.Visible = Toggles.BoxFilled.Value
				if Toggles.BoxFilled.Value then
					data.BoxFill.Position = boxPos
					data.BoxFill.Size = boxSize
					data.BoxFill.Color = Options.BoxFilledColor.Value
					data.BoxFill.Transparency = 0.55
				end
				for i = 1, 8 do data.Corners[i].Visible = false end
				for i = 1, 12 do data.Box3D[i].Visible = false end
			elseif boxType == "Corner" then
				data.Box.Visible = false
				data.BoxFill.Visible = false
				data.BoxOutline.Visible = false
				for i = 1, 12 do data.Box3D[i].Visible = false end
				local len = math.clamp(math.min(boxSize.X, boxSize.Y) * 0.25, 5, 18)
				local corners = {
					{boxPos, boxPos + Vector2.new(len, 0)}, {boxPos, boxPos + Vector2.new(0, len)},
					{boxPos + Vector2.new(boxSize.X, 0), boxPos + Vector2.new(boxSize.X - len, 0)},
					{boxPos + Vector2.new(boxSize.X, 0), boxPos + Vector2.new(boxSize.X, len)},
					{boxPos + Vector2.new(0, boxSize.Y), boxPos + Vector2.new(len, boxSize.Y)},
					{boxPos + Vector2.new(0, boxSize.Y), boxPos + Vector2.new(0, boxSize.Y - len)},
					{boxPos + boxSize, boxPos + boxSize - Vector2.new(len, 0)},
					{boxPos + boxSize, boxPos + boxSize - Vector2.new(0, len)},
				}
				for i, c in ipairs(corners) do
					data.Corners[i].Visible = true
					data.Corners[i].From = c[1]
					data.Corners[i].To = c[2]
					data.Corners[i].Color = boxColor
				end
			elseif boxType == "3D" then
				data.Box.Visible = false
				data.BoxFill.Visible = false
				data.BoxOutline.Visible = false
				for i = 1, 8 do data.Corners[i].Visible = false end
				local c3d = {
					Vector3.new(minV.X, minV.Y, minV.Z), Vector3.new(maxV.X, minV.Y, minV.Z),
					Vector3.new(maxV.X, minV.Y, maxV.Z), Vector3.new(minV.X, minV.Y, maxV.Z),
					Vector3.new(minV.X, maxV.Y, minV.Z), Vector3.new(maxV.X, maxV.Y, minV.Z),
					Vector3.new(maxV.X, maxV.Y, maxV.Z), Vector3.new(minV.X, maxV.Y, maxV.Z),
				}
				local screenC = {}
				for i, c in ipairs(c3d) do
					local sp, on = WorldToScreen(c)
					screenC[i] = {sp, on}
				end
				local edges = {{1,2},{2,3},{3,4},{4,1},{5,6},{6,7},{7,8},{8,5},{1,5},{2,6},{3,7},{4,8}}
				for i, e in ipairs(edges) do
					local a, b = screenC[e[1]], screenC[e[2]]
					if a[2] and b[2] then
						data.Box3D[i].Visible = true
						data.Box3D[i].From = a[1]
						data.Box3D[i].To = b[1]
						data.Box3D[i].Color = boxColor
					else
						data.Box3D[i].Visible = false
					end
				end
			end
		else
			data.Box.Visible = false
			data.BoxFill.Visible = false
			data.BoxOutline.Visible = false
			for i = 1, 8 do data.Corners[i].Visible = false end
			for i = 1, 12 do data.Box3D[i].Visible = false end
		end

		if Toggles.EspName.Value then
			data.Name.Visible = true
			data.Name.Text = player.DisplayName
			data.Name.Position = headOnScreen and Vector2.new(headScreen.X, headScreen.Y - 18) or Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y - 16)
			data.Name.Color = Options.EspNameColor.Value
		else
			data.Name.Visible = false
		end

		if Toggles.EspHealth.Value then
			local hp, maxHp = humanoid.Health, humanoid.MaxHealth
			local pct = math.clamp(hp / maxHp, 0, 1)
			local hpColor = Options.EspHealthColor.Value
			if Options.HealthType.Value == "Text" then
				data.HealthText.Visible = true
				data.HealthText.Text = math.floor(hp) .. "/" .. math.floor(maxHp)
				data.HealthText.Position = Vector2.new(boxPos.X + boxSize.X + 5, boxPos.Y)
				data.HealthText.Color = hpColor
				data.HealthBarBg.Visible = false
				data.HealthBar.Visible = false
			else
				data.HealthText.Visible = false
				data.HealthBarBg.Visible = true
				data.HealthBarBg.Position = Vector2.new(boxPos.X - 6, boxPos.Y)
				data.HealthBarBg.Size = Vector2.new(3, boxSize.Y)
				data.HealthBarBg.Color = Color3.fromRGB(20, 20, 20)
				data.HealthBar.Visible = true
				data.HealthBar.Position = Vector2.new(boxPos.X - 6, boxPos.Y + boxSize.Y * (1 - pct))
				data.HealthBar.Size = Vector2.new(3, boxSize.Y * pct)
				data.HealthBar.Color = hpColor
			end
		else
			data.HealthText.Visible = false
			data.HealthBarBg.Visible = false
			data.HealthBar.Visible = false
		end

		if Toggles.EspDistance.Value and localRoot then
			data.Distance.Visible = true
			data.Distance.Text = math.floor((root.Position - localRoot.Position).Magnitude) .. "m"
			data.Distance.Position = Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y + boxSize.Y + 3)
			data.Distance.Color = Options.EspDistanceColor.Value
		else
			data.Distance.Visible = false
		end

		if Toggles.EspTracer.Value then
			data.Tracer.Visible = true
			data.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
			data.Tracer.To = rootScreen
			data.Tracer.Color = Options.EspTracerColor.Value
		else
			data.Tracer.Visible = false
		end

		if Toggles.EspTool.Value then
			local tool = character:FindFirstChildOfClass("Tool")
			if tool then
				data.Tool.Visible = true
				data.Tool.Text = tool.Name
				data.Tool.Position = Vector2.new(boxPos.X + boxSize.X / 2, boxPos.Y + boxSize.Y + 17)
				data.Tool.Color = Options.EspToolColor.Value
			else
				data.Tool.Visible = false
			end
		else
			data.Tool.Visible = false
		end

		if Toggles.EspSkeleton.Value then
			local joints = {
				{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
				{"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
				{"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
				{"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
				{"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
			}
			local skColor = Options.EspSkeletonColor.Value
			for i, pair in ipairs(joints) do
				local a, b = character:FindFirstChild(pair[1]), character:FindFirstChild(pair[2])
				if a and b then
					local pa, oa = WorldToScreen(a.Position)
					local pb, ob = WorldToScreen(b.Position)
					if oa and ob then
						data.Skeleton[i].Visible = true
						data.Skeleton[i].From = pa
						data.Skeleton[i].To = pb
						data.Skeleton[i].Color = skColor
					else
						data.Skeleton[i].Visible = false
					end
				else
					data.Skeleton[i].Visible = false
				end
			end
		else
			for i = 1, 14 do data.Skeleton[i].Visible = false end
		end
	end
end

local function UpdateClient()
	if not Toggles.ClientEnabled.Value then return end
	if Toggles.Ambient.Value then Lighting.Ambient = Options.AmbientColor.Value end
	if Toggles.OutdoorAmbient.Value then Lighting.OutdoorAmbient = Options.OutdoorAmbientColor.Value end
	if Toggles.IndoorAmbient.Value then pcall(function() Lighting.IndoorAmbient = Options.IndoorAmbientColor.Value end) end
	if Toggles.FogColor.Value then Lighting.FogColor = Options.FogColorColor.Value end
	Lighting.FogStart = Options.FogStart.Value
	Lighting.FogEnd = Options.FogEnd.Value
	if Toggles.ColorShiftBottom.Value then Lighting.ColorShift_Bottom = Options.ColorShiftBottomColor.Value end
	if Toggles.ColorShiftTop.Value then Lighting.ColorShift_Top = Options.ColorShiftTopColor.Value end
	if Toggles.DiffuseColor.Value then pcall(function() Lighting.ColorShift_Bottom = Options.DiffuseColorColor.Value end) end
	local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
	if not cc then
		cc = Instance.new("ColorCorrectionEffect")
		cc.Parent = Lighting
	end
	cc.Contrast = Options.Contrast.Value
	cc.Brightness = Options.Brightness.Value
	local op = Options.Opacity.Value
	cc.TintColor = Color3.new(op, op, op)
end

RunService.RenderStepped:Connect(function()
	UpdateEsp()
	UpdateClient()
	UpdateFov()
	UpdateAimbot()
	DoRagebot()
	DoTriggerbot()
	DoKnifeAura()
	DoKnifeThrow()
	UpdateRageVisualizer()
	ApplyGunMods()
	UpdateHitboxExpander()
	UpdateAntiAim()
	UpdateRageVoid()
	ProcessHitConfirmations()
	OverrideGameSounds()
end)

Players.PlayerRemoving:Connect(function(player)
	RemoveDrawings(player)
	pendingHits[player] = nil
end)

local function OnCharacter(char)
	task.wait(0.3)
	if Toggles.AntiAimEnabled.Value then
		HookAnimator(char)
		if Options.AntiAimMode.Value == "Breaker" then
			StopBreaker()
			task.wait(0.2)
			StartBreaker()
		end
	else
		RestoreAnimations(char)
	end
end

if LocalPlayer.Character then
	task.spawn(OnCharacter, LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(OnCharacter)

Toggles.AntiAimEnabled:OnChanged(function()
	local char = LocalPlayer.Character
	if Toggles.AntiAimEnabled.Value then
		if char then HookAnimator(char) end
	else
		if char then RestoreAnimations(char) end
		if hmndbreaker.Active then StopBreaker() end
	end
end)

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("NEXPRA")
 
 
pcall(function()
	local q = ThemeManager.BuiltInThemes and ThemeManager.BuiltInThemes["Quartz"]
	if q then
		ThemeManager:SetDefaultTheme(q[2] or q)
	end
end)
ThemeManager:ApplyToTab(Tabs["UI Settings"])
 
pcall(function()
	ThemeManager:ApplyTheme("Quartz")
end)
pcall(function()
	local opt = Library.Options and Library.Options.ThemeManager_ThemeList
	if opt then
		opt:SetValue("Quartz")
	end
end)

SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
SaveManager:SetFolder("NEXPRA/MVSD")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()