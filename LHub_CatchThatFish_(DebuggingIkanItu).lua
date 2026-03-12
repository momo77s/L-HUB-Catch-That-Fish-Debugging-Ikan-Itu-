local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local rs = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

-- ================= CLEANUP & INIT =================
local uiParent = (gethui and gethui()) or CoreGui:FindFirstChild("RobloxGui") or Players.LocalPlayer:WaitForChild("PlayerGui")
if uiParent:FindFirstChild("LHubCatchAFish") then uiParent.LHubCatchAFish:Destroy() end

local LHub = Instance.new("ScreenGui", uiParent)
LHub.Name = "LHubCatchAFish"
LHub.ResetOnSpawn = false

-- Variabel Global
getgenv().SpoofActive = false
getgenv().TimerEnd = 0
local currentFish = "Blood Ramadhan"
local currentRarity = "Secret"
local currentWeight = 791.0

-- DATA IKAN SECRET
local secretFishes = {
    "Abyss Fang", "Amber", "Azragon Tide", "Barakiel Fin", "Batu Bintang", "Batu Bulat",
    "Batu Segiempat", "Batu Segipanjang", "Batu Segitiga", "Blight Puff", "Blood Ramadhan",
    "Cindera Fish", "Ciyup Carber", "Cype Darcopink", "Cype Darcoyellow", "Dolphin Wheal",
    "Dolphin Wiliw", "Doplin Blue", "Doplin Pink", "Draco", "Hammer Shark", "Hiu Moster",
    "Hiu Valentine Pink", "Hiu Valentine Reds", "Jellyfish core", "Joar Cusyu", "Kaos Kaki Putra",
    "King Megalodon", "King Monster", "Kraken Moster", "Kuzjuy Shark", "Leviathan Core", "Lopa",
    "Megalodon Core", "Moster Kelelawar", "NabilaNaga", "Nagasa Putra", "Nur Delmare", "Paus Corda",
    "PutraNaga", "Sempak Putra", "Suytu Care", "Voyage", "Whale Shark", "While BloodShack"
}

-- ================= FUNGSI BUKU SUCI (SPOOF) =================
local FishingConfig = require(rs:WaitForChild("FishingSystem"):WaitForChild("FishingConfig"))
local oldRoll = FishingConfig.RollFish
local oldWeight = FishingConfig.GenerateFishWeight
local oldCanCatch = FishingConfig.CanCatchRarity
local oldGetRod = FishingConfig.GetRodConfig

FishingConfig.RollFish = function(...)
    if getgenv().SpoofActive then
        return {["name"] = currentFish, ["rarity"] = currentRarity, ["minKg"] = currentWeight, ["maxKg"] = currentWeight, ["probability"] = 0}
    end
    return oldRoll(...)
end
FishingConfig.GenerateFishWeight = function(...)
    if getgenv().SpoofActive then return currentWeight end
    return oldWeight(...)
end
FishingConfig.GetRodConfig = function(rodName)
    local config = oldGetRod(rodName)
    if getgenv().SpoofActive then
        local fake = {}
        for k,v in pairs(config) do fake[k] = v end
        fake.maxRarity = "Limited"
        fake.maxWeight = 10000
        return fake
    end
    return config
end
FishingConfig.CanCatchRarity = function(...)
    if getgenv().SpoofActive then return true end
    return oldCanCatch(...)
end

-- ================= UI DESIGN =================
local MainFrame = Instance.new("Frame", LHub)
MainFrame.Size = UDim2.new(0, 520, 0, 320)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = false 
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 170, 255)

-- Topbar
local Topbar = Instance.new("Frame", MainFrame)
Topbar.Size = UDim2.new(1, 0, 0, 35)
Topbar.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
Instance.new("UICorner", Topbar).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Topbar)
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "L Hub | Catch A Fish (Debugging Ikan Itu)"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local MinBtn = Instance.new("TextButton", Topbar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -65, 0, 2)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BackgroundTransparency = 1

local CloseBtn = Instance.new("TextButton", Topbar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 2)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BackgroundTransparency = 1

-- Sidebar
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0, 5)
Instance.new("UIPadding", Sidebar).PaddingTop = UDim.new(0, 10)

-- Content Area
local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Size = UDim2.new(1, -140, 1, -35)
ContentArea.Position = UDim2.new(0, 140, 0, 35)
ContentArea.BackgroundTransparency = 1

local TabInfo = Instance.new("Frame", ContentArea)
TabInfo.Size = UDim2.new(1, 0, 1, 0)
TabInfo.BackgroundTransparency = 1
TabInfo.Visible = true

local TabSpoof = Instance.new("Frame", ContentArea)
TabSpoof.Size = UDim2.new(1, 0, 1, 0)
TabSpoof.BackgroundTransparency = 1
TabSpoof.Visible = false

local tabs = {["Information"] = TabInfo, ["Spoof Fish"] = TabSpoof}
local navBtns = {}

-- FUNGSI NAVIGASI + INDIKATOR GARIS BIRU
local function switchTab(tabName)
    for name, frame in pairs(tabs) do frame.Visible = (name == tabName) end
    for name, data in pairs(navBtns) do
        if name == tabName then
            data.btn.BackgroundColor3 = Color3.fromRGB(0, 130, 220)
            data.btn.TextColor3 = Color3.new(1,1,1)
            data.indicator.Visible = true
        else
            data.btn.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
            data.btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            data.indicator.Visible = false
        end
    end
end

for _, name in ipairs({"Information", "Spoof Fish"}) do
    local btnContainer = Instance.new("Frame", Sidebar)
    btnContainer.Size = UDim2.new(1, -10, 0, 35)
    btnContainer.Position = UDim2.new(0, 5, 0, 0)
    btnContainer.BackgroundTransparency = 1
    
    local btn = Instance.new("TextButton", btnContainer)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Text = "  " .. name
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local indicator = Instance.new("Frame", btnContainer)
    indicator.Size = UDim2.new(0, 4, 1, 0)
    indicator.Position = UDim2.new(1, -4, 0, 0)
    indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    indicator.BorderSizePixel = 0
    indicator.Visible = false
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 4)
    
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
    navBtns[name] = {btn = btn, indicator = indicator}
end
switchTab("Information")

-- ================= TAB 1: INFORMATION =================
local InfoPad = Instance.new("UIPadding", TabInfo)
InfoPad.PaddingTop = UDim.new(0, 20) InfoPad.PaddingLeft = UDim.new(0, 20)

local InfoTitle = Instance.new("TextLabel", TabInfo)
InfoTitle.Size = UDim2.new(1, -20, 0, 30)
InfoTitle.Text = "✨ FITUR L HUB:"
InfoTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
InfoTitle.Font = Enum.Font.GothamBold
InfoTitle.TextSize = 16
InfoTitle.TextXAlignment = Enum.TextXAlignment.Left
InfoTitle.BackgroundTransparency = 1

local InfoList = Instance.new("TextLabel", TabInfo)
InfoList.Size = UDim2.new(1, -20, 0, 60)
InfoList.Position = UDim2.new(0, 0, 0, 40)
InfoList.Text = "✔️ Spoof Fish\n✔️ Rejoin"
InfoList.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoList.Font = Enum.Font.Gotham
InfoList.TextSize = 14
InfoList.TextXAlignment = Enum.TextXAlignment.Left
InfoList.TextYAlignment = Enum.TextYAlignment.Top
InfoList.BackgroundTransparency = 1

local CreditText = Instance.new("TextLabel", TabInfo)
CreditText.Size = UDim2.new(1, -20, 0, 50)
CreditText.Position = UDim2.new(0, 0, 0, 110)
CreditText.Text = "👤 Dibuat oleh: L & Gemini AI\n🎵 TikTok: @hahihe4"
CreditText.TextColor3 = Color3.fromRGB(150, 200, 255)
CreditText.Font = Enum.Font.GothamBold
CreditText.TextSize = 14
CreditText.TextXAlignment = Enum.TextXAlignment.Left
CreditText.TextYAlignment = Enum.TextYAlignment.Top
CreditText.BackgroundTransparency = 1

-- ================= TAB 2: SPOOF FISH =================
local SpoofPad = Instance.new("UIPadding", TabSpoof)
SpoofPad.PaddingTop = UDim.new(0, 15) SpoofPad.PaddingLeft = UDim.new(0, 15) SpoofPad.PaddingRight = UDim.new(0, 15)

-- DROPDOWN BUTTON
local DropdownBtn = Instance.new("TextButton", TabSpoof)
DropdownBtn.Size = UDim2.new(1, 0, 0, 35)
DropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
DropdownBtn.Text = "Pilih Ikan Secret Otomatis ▼"
DropdownBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
DropdownBtn.Font = Enum.Font.GothamBold
DropdownBtn.ZIndex = 2
Instance.new("UICorner", DropdownBtn).CornerRadius = UDim.new(0, 6)

-- MANUAL INPUTS
local InputContainer = Instance.new("Frame", TabSpoof)
InputContainer.Size = UDim2.new(1, 0, 0, 35)
InputContainer.Position = UDim2.new(0, 0, 0, 45)
InputContainer.BackgroundTransparency = 1
local I_Name = Instance.new("TextBox", InputContainer)
I_Name.Size = UDim2.new(0.5, -5, 1, 0)
I_Name.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
I_Name.TextColor3 = Color3.new(1,1,1)
I_Name.Text = "Blood Ramadhan"
I_Name.Font = Enum.Font.Gotham
Instance.new("UICorner", I_Name).CornerRadius = UDim.new(0, 6)
local I_Rarity = Instance.new("TextBox", InputContainer)
I_Rarity.Size = UDim2.new(0.5, -5, 1, 0)
I_Rarity.Position = UDim2.new(0.5, 5, 0, 0)
I_Rarity.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
I_Rarity.TextColor3 = Color3.new(1,1,1)
I_Rarity.Text = "Secret"
I_Rarity.Font = Enum.Font.Gotham
Instance.new("UICorner", I_Rarity).CornerRadius = UDim.new(0, 6)

-- BUTTON START
local SpoofBtn = Instance.new("TextButton", TabSpoof)
SpoofBtn.Size = UDim2.new(1, 0, 0, 40)
SpoofBtn.Position = UDim2.new(0, 0, 0, 90)
SpoofBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
SpoofBtn.Text = "🎣 MULAI SPOOFING"
SpoofBtn.TextColor3 = Color3.new(1,1,1)
SpoofBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", SpoofBtn).CornerRadius = UDim.new(0, 6)

-- TIMER & REJOIN ROW
local BottomRow = Instance.new("Frame", TabSpoof)
BottomRow.Size = UDim2.new(1, 0, 0, 35)
BottomRow.Position = UDim2.new(0, 0, 0, 140)
BottomRow.BackgroundTransparency = 1

local RejoinBtn = Instance.new("TextButton", BottomRow)
RejoinBtn.Size = UDim2.new(0, 110, 1, 0)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
RejoinBtn.Text = "🔄 REJOIN"
RejoinBtn.TextColor3 = Color3.new(1,1,1)
RejoinBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", RejoinBtn).CornerRadius = UDim.new(0, 6)

local TimerDisplay = Instance.new("TextLabel", BottomRow)
TimerDisplay.Size = UDim2.new(1, -120, 1, 0)
TimerDisplay.Position = UDim2.new(0, 120, 0, 0)
TimerDisplay.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TimerDisplay.Text = "⏱️ COOLDOWN: 00:00"
TimerDisplay.TextColor3 = Color3.fromRGB(0, 255, 100)
TimerDisplay.Font = Enum.Font.GothamBold
Instance.new("UICorner", TimerDisplay).CornerRadius = UDim.new(0, 6)

-- DROPDOWN LIST (ZIndex tinggi, Fixed Scroll)
local DropdownList = Instance.new("ScrollingFrame", TabSpoof)
DropdownList.Size = UDim2.new(1, 0, 0, 160)
DropdownList.Position = UDim2.new(0, 0, 0, 40)
DropdownList.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
DropdownList.ScrollBarThickness = 5
DropdownList.Visible = false
DropdownList.ZIndex = 5
-- FIX: Gunakan AutomaticCanvasSize agar tinggi scroll mengikuti jumlah isi
DropdownList.AutomaticCanvasSize = Enum.AutomaticSize.Y 
DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0) 
Instance.new("UICorner", DropdownList).CornerRadius = UDim.new(0, 6)
local DropLayout = Instance.new("UIListLayout", DropdownList)

for _, fishName in ipairs(secretFishes) do
    local fBtn = Instance.new("TextButton", DropdownList)
    fBtn.Size = UDim2.new(1, 0, 0, 25)
    fBtn.BackgroundTransparency = 1
    fBtn.Text = "  " .. fishName
    fBtn.TextColor3 = Color3.fromRGB(200, 230, 255)
    fBtn.Font = Enum.Font.Gotham
    fBtn.TextXAlignment = Enum.TextXAlignment.Left
    fBtn.ZIndex = 5
    
    fBtn.MouseButton1Click:Connect(function()
        I_Name.Text = fishName
        I_Rarity.Text = "Secret"
        DropdownBtn.Text = fishName .. " ▼"
        DropdownList.Visible = false
    end)
end

DropdownBtn.MouseButton1Click:Connect(function()
    DropdownList.Visible = not DropdownList.Visible
end)

-- ================= LOGIKA BUTTONS =================
SpoofBtn.MouseButton1Click:Connect(function()
    getgenv().SpoofActive = not getgenv().SpoofActive
    if getgenv().SpoofActive then
        currentFish = I_Name.Text
        currentRarity = I_Rarity.Text
        currentWeight = 791.0
        SpoofBtn.Text = "🛑 STOP SPOOFING"
        SpoofBtn.BackgroundColor3 = Color3.fromRGB(230, 60, 60)
    else
        SpoofBtn.Text = "🎣 MULAI SPOOFING"
        SpoofBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    end
end)

RejoinBtn.MouseButton1Click:Connect(function()
    RejoinBtn.Text = "⏳ Tunggu..."
    RejoinBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
end)

-- UI TOGGLES (FITUR BESAR / KECIL)
local isHidden = false
MinBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    Sidebar.Visible = not isHidden
    ContentArea.Visible = not isHidden
    
    if isHidden then
        MainFrame.Size = UDim2.new(0, 200, 0, 35)
        Title.Text = "L Hub | Catch A Fish" 
    else
        MainFrame.Size = UDim2.new(0, 520, 0, 320)
        Title.Text = "L Hub | Catch A Fish (Debugging Ikan Itu)"
    end
    MinBtn.Text = isHidden and "+" or "-"
end)

CloseBtn.MouseButton1Click:Connect(function()
    getgenv().SpoofActive = false
    FishingConfig.RollFish = oldRoll FishingConfig.GenerateFishWeight = oldWeight
    FishingConfig.CanCatchRarity = oldCanCatch FishingConfig.GetRodConfig = oldGetRod
    LHub:Destroy()
end)

-- ================= INTERCEPTOR & LIVE TIMER =================
task.spawn(function()
    while task.wait(1) do
        if LHub.Parent == nil then break end
        local timeLeft = getgenv().TimerEnd - tick()
        if timeLeft > 0 then
            local m = math.floor(timeLeft / 60)
            local s = math.floor(timeLeft % 60)
            TimerDisplay.Text = string.format("⏱️ %02d:%02d (DANGER)", m, s)
            TimerDisplay.TextColor3 = Color3.fromRGB(255, 80, 80)
        else
            TimerDisplay.Text = "⏱️ 00:00 (SAFE)"
            TimerDisplay.TextColor3 = Color3.fromRGB(0, 255, 100)
        end
    end
end)

if hookmetamethod and not getgenv().HookCatchAFish then
    getgenv().HookCatchAFish = true
    local oldNC
    oldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() and method == "FireServer" and tostring(self) == "codedata" then
            local args = {...}
            local payload = args[1]
            
            if payload and type(payload) == "table" and payload.rarity == "Secret" then
                getgenv().TimerEnd = tick() + 250 
            end
            
            return oldNC(self, unpack(args))
        end
        return oldNC(self, ...)
    end)
end

print("👑 L-HUB Catch A Fish (Fixed Scroll) Loaded!")
