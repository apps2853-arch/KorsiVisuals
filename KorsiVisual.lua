--[[
    KorsiVisual v6
    Косметический визуальный клиент
    Right Shift — меню
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("KorsiVisual") then
    PlayerGui.KorsiVisual:Destroy()
end

-- ===================== CONFIG SYSTEM =====================
local CONFIG_FOLDER = "KorsiVisual"
local CONFIG_FILE = CONFIG_FOLDER .. "/autosave.json"
local CONFIGS_DIR = CONFIG_FOLDER .. "/configs"

local function ensureFolders()
    if not isfolder then return false end
    pcall(function()
        if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
        if not isfolder(CONFIGS_DIR) then makefolder(CONFIGS_DIR) end
    end)
    return true
end

local function saveAutosave(data)
    if not writefile then return end
    ensureFolders()
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode(data))
    end)
end

local function loadAutosave()
    if not readfile or not isfile then return nil end
    local ok, result = pcall(function()
        if isfile(CONFIG_FILE) then
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end
    end)
    return ok and result or nil
end

local function listConfigs()
    if not listfiles then return {} end
    ensureFolders()
    local list = {}
    pcall(function()
        for _, f in ipairs(listfiles(CONFIGS_DIR)) do
            local name = f:match("([^/\\]+)%.json$")
            if name then table.insert(list, name) end
        end
    end)
    return list
end

local function saveNamedConfig(name, data)
    if not writefile then return false end
    ensureFolders()
    local ok = pcall(function()
        writefile(CONFIGS_DIR .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    end)
    return ok
end

local function loadNamedConfig(name)
    if not readfile or not isfile then return nil end
    local path = CONFIGS_DIR .. "/" .. name .. ".json"
    local ok, result = pcall(function()
        if isfile(path) then
            return HttpService:JSONDecode(readfile(path))
        end
    end)
    return ok and result or nil
end

local function deleteNamedConfig(name)
    if not delfile then return false end
    local path = CONFIGS_DIR .. "/" .. name .. ".json"
    local ok = pcall(function()
        if isfile(path) then delfile(path) end
    end)
    return ok
end

-- ===================== THEMES =====================
local Themes = {
    {Name = "Pulse Blue", Accent = Color3.fromRGB(70, 150, 255)},
    {Name = "Cyan Wave", Accent = Color3.fromRGB(0, 225, 255)},
    {Name = "Violet", Accent = Color3.fromRGB(165, 95, 255)},
    {Name = "Crimson", Accent = Color3.fromRGB(255, 65, 95)},
    {Name = "Emerald", Accent = Color3.fromRGB(55, 225, 135)},
    {Name = "Sunset", Accent = Color3.fromRGB(255, 145, 65)},
    {Name = "Gold", Accent = Color3.fromRGB(255, 208, 75)},
    {Name = "Hot Pink", Accent = Color3.fromRGB(255, 75, 175)},
    {Name = "Mint", Accent = Color3.fromRGB(95, 255, 212)},
    {Name = "Blood Moon", Accent = Color3.fromRGB(210, 35, 35)},
    {Name = "Ice", Accent = Color3.fromRGB(180, 232, 255)},
    {Name = "Toxic", Accent = Color3.fromRGB(175, 255, 45)},
    {Name = "Royal Purple", Accent = Color3.fromRGB(125, 65, 205)},
    {Name = "Monochrome", Accent = Color3.fromRGB(235, 235, 235)},
    {Name = "Lava", Accent = Color3.fromRGB(255, 95, 25)},
    {Name = "Ocean", Accent = Color3.fromRGB(30, 144, 255)},
    {Name = "Sakura", Accent = Color3.fromRGB(255, 160, 200)},
    {Name = "Neon Green", Accent = Color3.fromRGB(57, 255, 20)},
    {Name = "Amber", Accent = Color3.fromRGB(255, 191, 0)},
    {Name = "Deep Purple", Accent = Color3.fromRGB(90, 40, 160)},
}
local CurrentTheme = 1
local function accent() return Themes[CurrentTheme].Accent end

local GlassBg = Color3.fromRGB(12, 12, 16)
local Config = {Intensity = 1}
local EnabledEffects = {} -- name -> true

-- ===================== HELPERS =====================
local function corner(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = inst
    return c
end

local function stroke(inst, color, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = color or accent()
    s.Thickness = thick or 1
    s.Transparency = trans or 0
    s.Parent = inst
    return s
end

local function tween(inst, props, t)
    TweenService:Create(inst, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local ThemedUI = {}
local function themed(inst, prop)
    table.insert(ThemedUI, {inst = inst, prop = prop})
    inst[prop] = accent()
end

local function getHRP(char) return char and char:FindFirstChild("HumanoidRootPart") end
local function getHead(char) return char and char:FindFirstChild("Head") end

local function onCharacter(callback)
    local function run(char)
        if not char then return end
        task.defer(function()
            task.wait(0.3)
            if char.Parent then callback(char) end
        end)
    end
    if LocalPlayer.Character then run(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(run)
end

local ActiveStores = {}
local function registerColor(store, inst, prop, isSeq)
    store.colorTargets = store.colorTargets or {}
    table.insert(store.colorTargets, {inst = inst, prop = prop, isSequence = isSeq})
end

local function applyTheme(i)
    CurrentTheme = i
    local col = accent()
    for _, e in ipairs(ThemedUI) do
        pcall(function()
            if e.inst:IsA("UIStroke") then
                tween(e.inst, {Color = col}, 0.2)
            else
                tween(e.inst, {[e.prop] = col}, 0.2)
            end
        end)
    end
    for _, store in pairs(ActiveStores) do
        if store.colorTargets then
            for _, t in ipairs(store.colorTargets) do
                if t.inst and t.inst.Parent then
                    pcall(function()
                        t.inst[t.prop] = t.isSequence and ColorSequence.new(col) or col
                    end)
                end
            end
        end
    end
end

-- ===================== GUI =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KorsiVisual"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = PlayerGui

-- Узкий островок
local Island = Instance.new("Frame")
Island.Size = UDim2.new(0, 210, 0, 32)
Island.Position = UDim2.new(0.5, -105, 0, 10)
Island.BackgroundColor3 = GlassBg
Island.BackgroundTransparency = 0.12
Island.Parent = ScreenGui
corner(Island, 16)
local islandStroke = stroke(Island, accent(), 1, 0.35)
table.insert(ThemedUI, {inst = islandStroke, prop = "Color"})

local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0, 6, 0, 6)
Dot.Position = UDim2.new(0, 12, 0.5, -3)
Dot.BackgroundColor3 = accent()
Dot.Parent = Island
corner(Dot, 3)
table.insert(ThemedUI, {inst = Dot, prop = "BackgroundColor3"})

local nameLbl = Instance.new("TextLabel")
nameLbl.BackgroundTransparency = 1
nameLbl.Position = UDim2.new(0, 24, 0, 0)
nameLbl.Size = UDim2.new(0, 100, 1, 0)
nameLbl.Font = Enum.Font.GothamBold
nameLbl.TextSize = 12
nameLbl.TextXAlignment = Enum.TextXAlignment.Left
nameLbl.Text = "KorsiVisual"
nameLbl.Parent = Island
themed(nameLbl, "TextColor3")

local fpsLbl = Instance.new("TextLabel")
fpsLbl.BackgroundTransparency = 1
fpsLbl.Position = UDim2.new(1, -55, 0, 0)
fpsLbl.Size = UDim2.new(0, 48, 1, 0)
fpsLbl.Font = Enum.Font.GothamMedium
fpsLbl.TextSize = 11
fpsLbl.TextColor3 = Color3.fromRGB(160,160,170)
fpsLbl.TextXAlignment = Enum.TextXAlignment.Right
fpsLbl.Text = "—"
fpsLbl.Parent = Island

local frameCount, fpsTimer = 0, 0
RunService.RenderStepped:Connect(function(dt)
    frameCount += 1
    fpsTimer += dt
    if fpsTimer >= 1 then
        fpsLbl.Text = tostring(frameCount)
        frameCount, fpsTimer = 0, 0
    end
end)

-- Меню
local MenuHolder = Instance.new("Frame")
MenuHolder.Size = UDim2.new(0, 480, 0, 380)
MenuHolder.Position = UDim2.new(0.5, -240, 0, 50)
MenuHolder.BackgroundTransparency = 1
MenuHolder.Visible = false
MenuHolder.ClipsDescendants = true
MenuHolder.Parent = ScreenGui

local Menu = Instance.new("Frame")
Menu.Size = UDim2.new(1, 0, 1, 0)
Menu.BackgroundColor3 = GlassBg
Menu.BackgroundTransparency = 0.06
Menu.Parent = MenuHolder
corner(Menu, 14)
local menuStroke = stroke(Menu, accent(), 1, 0.4)
table.insert(ThemedUI, {inst = menuStroke, prop = "Color"})

local MenuTitle = Instance.new("TextLabel")
MenuTitle.BackgroundTransparency = 1
MenuTitle.Position = UDim2.new(0, 14, 0, 8)
MenuTitle.Size = UDim2.new(1, -50, 0, 22)
MenuTitle.Font = Enum.Font.GothamBold
MenuTitle.TextSize = 14
MenuTitle.TextXAlignment = Enum.TextXAlignment.Left
MenuTitle.TextColor3 = Color3.fromRGB(235,235,240)
MenuTitle.Text = "KorsiVisual v6"
MenuTitle.Parent = Menu

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -32, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
CloseBtn.BackgroundTransparency = 0.92
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.TextColor3 = Color3.fromRGB(220,220,230)
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Menu
corner(CloseBtn, 6)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 110, 1, -50)
TabBar.Position = UDim2.new(0, 10, 0, 38)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Menu

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 3)
TabLayout.Parent = TabBar

local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -130, 1, -50)
Content.Position = UDim2.new(0, 125, 0, 38)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 2
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Content.Parent = Menu

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 3)
ContentLayout.Parent = Content

-- ===================== EFFECTS =====================
local Effects = {}
local EffectOrder = {}
local categoryRows = {
    ["Мир"] = {}, ["Атмосфера"] = {}, ["Игрок"] = {},
    ["Косметика"] = {}, ["Темы"] = {}, ["Настройки"] = {}
}
local AllToggleControls = {}
local ToggleByName = {}

local function addEffect(name, category, onFn, offFn)
    Effects[name] = {Category = category, On = onFn, Off = offFn}
    table.insert(EffectOrder, name)
end

-- ===== МИР =====
addEffect("Частицы в мире", "Мир", function(store)
    local e = Instance.new("ParticleEmitter")
    e.Texture = "rbxassetid://241625105"
    e.Rate = 8 * Config.Intensity
    e.Lifetime = NumberRange.new(3, 6)
    e.Speed = NumberRange.new(0.5, 1.5)
    e.Size = NumberSequence.new(0.15, 0.4)
    e.Transparency = NumberSequence.new(0.3, 1)
    e.Color = ColorSequence.new(accent())
    e.LightEmission = 0.4
    e.Parent = workspace.Terrain
    registerColor(store, e, "Color", true)
    store.inst = e
end, function(store)
    if store.inst then store.inst:Destroy() end
end)

addEffect("Лёгкий туман", "Мир", function(store)
    local atm = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
    atm.Parent = Lighting
    store.original = {Density = atm.Density, Haze = atm.Haze}
    atm.Density = 0.25
    atm.Haze = 1.5
    store.inst = atm
end, function(store)
    if store.inst and store.original then
        store.inst.Density = store.original.Density
        store.inst.Haze = store.original.Haze
    end
end)

addEffect("Звёздное небо (клиент)", "Мир", function(store)
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if not sky then
        sky = Instance.new("Sky")
        sky.Parent = Lighting
    end
    store.original = sky.StarCount
    sky.StarCount = 3000
    store.inst = sky
end, function(store)
    if store.inst and store.original then store.inst.StarCount = store.original end
end)

-- ===== АТМОСФЕРА =====
addEffect("Атмосферная дымка", "Атмосфера", function(store)
    local atm = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere")
    atm.Parent = Lighting
    store.original = {
        Density = atm.Density, Offset = atm.Offset, Color = atm.Color,
        Decay = atm.Decay, Glare = atm.Glare, Haze = atm.Haze
    }
    atm.Density = 0.38
    atm.Offset = 0.18
    atm.Color = Color3.fromRGB(165, 190, 255)
    atm.Decay = Color3.fromRGB(85, 115, 185)
    atm.Glare = 0.22
    atm.Haze = 1.9
    store.inst = atm
end, function(store)
    if store.inst and store.original then
        for k,v in pairs(store.original) do store.inst[k] = v end
    end
end)

addEffect("Bloom", "Атмосфера", function(store)
    local b = Instance.new("BloomEffect")
    b.Intensity = 1.0
    b.Size = 24
    b.Threshold = 0.88
    b.Parent = Lighting
    store.inst = b
end, function(store) if store.inst then store.inst:Destroy() end end)

addEffect("Color Correction", "Атмосфера", function(store)
    local c = Instance.new("ColorCorrectionEffect")
    c.TintColor = Color3.fromRGB(225, 232, 255)
    c.Saturation = 0.1
    c.Contrast = 0.06
    c.Parent = Lighting
    store.inst = c
end, function(store) if store.inst then store.inst:Destroy() end end)

addEffect("Sun Rays", "Атмосфера", function(store)
    local s = Instance.new("SunRaysEffect")
    s.Intensity = 0.14
    s.Spread = 0.6
    s.Parent = Lighting
    store.inst = s
end, function(store) if store.inst then store.inst:Destroy() end end)

addEffect("Blur", "Атмосфера", function(store)
    local b = Instance.new("BlurEffect")
    b.Size = 3
    b.Parent = Lighting
    store.inst = b
end, function(store) if store.inst then store.inst:Destroy() end end)

addEffect("Depth Of Field", "Атмосфера", function(store)
    local d = Instance.new("DepthOfFieldEffect")
    d.FarIntensity = 0.3
    d.FocusDistance = 30
    d.InFocusRadius = 20
    d.NearIntensity = 0.15
    d.Parent = Lighting
    store.inst = d
end, function(store) if store.inst then store.inst:Destroy() end end)

-- ===== ИГРОК =====
addEffect("Подсветка", "Игрок", function(store)
    onCharacter(function(char)
        if store.inst then store.inst:Destroy() end
        local hl = Instance.new("Highlight")
        hl.FillTransparency = 0.8
        hl.OutlineTransparency = 0.1
        hl.FillColor = accent()
        hl.OutlineColor = accent()
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
        registerColor(store, hl, "FillColor")
        registerColor(store, hl, "OutlineColor")
        store.inst = hl
    end)
end, function(store) if store.inst then store.inst:Destroy() end end)

addEffect("Аура", "Игрок", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local e = Instance.new("ParticleEmitter")
        e.Rate = 20 * Config.Intensity
        e.Lifetime = NumberRange.new(1, 1.8)
        e.Speed = NumberRange.new(0.6, 1.4)
        e.Size = NumberSequence.new(0.2, 0.03)
        e.Transparency = NumberSequence.new(0.2, 1)
        e.Color = ColorSequence.new(accent())
        e.LightEmission = 0.5
        e.Parent = hrp
        registerColor(store, e, "Color", true)
        store.instances = {e}
    end)
end, function(store)
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("След", "Игрок", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local a0 = Instance.new("Attachment")
        a0.Position = Vector3.new(0, 0.1, 0)
        a0.Parent = hrp
        local a1 = Instance.new("Attachment")
        a1.Position = Vector3.new(0, -1.6, 0)
        a1.Parent = hrp
        local trail = Instance.new("Trail")
        trail.Attachment0, trail.Attachment1 = a0, a1
        trail.Lifetime = 0.4
        trail.Color = ColorSequence.new(accent())
        trail.Transparency = NumberSequence.new(0.1, 1)
        trail.WidthScale = NumberSequence.new(1, 0)
        trail.Parent = hrp
        registerColor(store, trail, "Color", true)
        store.instances = {a0, a1, trail}
    end)
end, function(store)
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("Искры при движении", "Игрок", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local e = Instance.new("ParticleEmitter")
        e.Rate = 0
        e.Lifetime = NumberRange.new(0.4, 0.8)
        e.Speed = NumberRange.new(2, 5)
        e.Size = NumberSequence.new(0.12, 0)
        e.Transparency = NumberSequence.new(0.1, 1)
        e.Color = ColorSequence.new(accent())
        e.LightEmission = 0.7
        e.Parent = hrp
        registerColor(store, e, "Color", true)
        store.conn = RunService.Heartbeat:Connect(function()
            if hrp and hrp.Parent and hrp.AssemblyLinearVelocity.Magnitude > 8 then
                e:Emit(2)
            end
        end)
        store.instances = {e}
    end)
end, function(store)
    if store.conn then store.conn:Disconnect() end
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

-- ===== КОСМЕТИКА =====
addEffect("Крылья", "Косметика", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.instances then
            for _,v in ipairs(store.instances) do if v and v.Parent then v:Destroy() end end
        end

        local function wing(side)
            local att = Instance.new("Attachment")
            att.Position = Vector3.new(side == "L" and -0.7 or 0.7, 0.9, 0.55)
            att.Parent = hrp
            local e = Instance.new("ParticleEmitter")
            e.Texture = "rbxassetid://241625105"
            e.Rate = 48 * Config.Intensity
            e.Lifetime = NumberRange.new(0.5, 0.9)
            e.Speed = NumberRange.new(3, 6)
            e.SpreadAngle = Vector2.new(12, 22)
            e.Rotation = NumberRange.new(0, 360)
            e.RotSpeed = NumberRange.new(-40, 40)
            e.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.4),
                NumberSequenceKeypoint.new(0.3, 0.6),
                NumberSequenceKeypoint.new(1, 0.02)
            })
            e.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.08),
                NumberSequenceKeypoint.new(0.5, 0.35),
                NumberSequenceKeypoint.new(1, 1)
            })
            e.Color = ColorSequence.new(accent())
            e.LightEmission = 0.7
            e.Acceleration = Vector3.new(0, 2, 0)
            e.Drag = 1.5
            e.EmissionDirection = Enum.NormalId.Back
            e.Parent = att
            registerColor(store, e, "Color", true)
            return att, e
        end

        local a1,e1 = wing("L")
        local a2,e2 = wing("R")
        store.instances = {a1,e1,a2,e2}
    end)
end, function(store)
    if store.instances then
        for _,v in ipairs(store.instances) do if v and v.Parent then v:Destroy() end end
        store.instances = nil
    end
end)

addEffect("Корона", "Косметика", function(store)
    onCharacter(function(char)
        local head = getHead(char)
        if not head then return end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end

        local ring = Instance.new("Part")
        ring.Name = "KV_Crown"
        ring.Shape = Enum.PartType.Cylinder
        ring.Size = Vector3.new(0.08, 1.25, 1.25)
        ring.Material = Enum.Material.Neon
        ring.Color = accent()
        ring.CanCollide = false
        ring.Massless = true
        ring.CastShadow = false

        local light = Instance.new("PointLight")
        light.Color = accent()
        light.Brightness = 2.5
        light.Range = 9
        light.Parent = ring

        local weld = Instance.new("Weld")
        weld.Part0 = head
        weld.Part1 = ring
        weld.C0 = CFrame.new(0, 1.55, 0) * CFrame.Angles(0, 0, math.rad(90))
        weld.Parent = ring
        ring.Parent = head

        registerColor(store, ring, "Color")
        registerColor(store, light, "Color")
        store.instances = {ring}
    end)
end, function(store)
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("Большие орбиты", "Косметика", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.conn then store.conn:Disconnect() end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end

        local parts = {}
        for i = 1, 6 do
            local p = Instance.new("Part")
            p.Shape = Enum.PartType.Ball
            p.Size = Vector3.new(0.28, 0.28, 0.28)
            p.Material = Enum.Material.Neon
            p.Color = accent()
            p.CanCollide = false
            p.Massless = true
            p.Anchored = true
            p.CastShadow = false
            p.Parent = workspace
            table.insert(parts, p)
            registerColor(store, p, "Color")
        end

        store.conn = RunService.Heartbeat:Connect(function()
            if not hrp or not hrp.Parent then return end
            for i, p in ipairs(parts) do
                local ang = tick() * 1.3 + (i * (math.pi * 2 / #parts))
                local off = Vector3.new(math.cos(ang) * 3.2, 1.4 + math.sin(tick() * 1.8 + i) * 0.4, math.sin(ang) * 3.2)
                p.CFrame = CFrame.new(hrp.Position + off)
            end
        end)
        store.instances = parts
    end)
end, function(store)
    if store.conn then store.conn:Disconnect() end
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("Теневой плащ", "Косметика", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local a0 = Instance.new("Attachment")
        a0.Position = Vector3.new(0, 1.1, -0.35)
        a0.Parent = hrp
        local a1 = Instance.new("Attachment")
        a1.Position = Vector3.new(0, -2.1, -0.35)
        a1.Parent = hrp
        local trail = Instance.new("Trail")
        trail.Attachment0, trail.Attachment1 = a0, a1
        trail.Lifetime = 0.55
        trail.Color = ColorSequence.new(Color3.fromRGB(10,10,18))
        trail.Transparency = NumberSequence.new(0.1, 1)
        trail.WidthScale = NumberSequence.new(1.3, 0.05)
        trail.Parent = hrp
        store.instances = {a0, a1, trail}
    end)
end, function(store)
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("Парящий фонарь", "Косметика", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.conn then store.conn:Disconnect() end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end

        local p = Instance.new("Part")
        p.Shape = Enum.PartType.Ball
        p.Size = Vector3.new(0.32, 0.32, 0.32)
        p.Material = Enum.Material.Neon
        p.Color = accent()
        p.CanCollide = false
        p.Massless = true
        p.Anchored = true
        p.Parent = workspace

        local light = Instance.new("PointLight")
        light.Color = accent()
        light.Brightness = 3
        light.Range = 14
        light.Parent = p

        registerColor(store, p, "Color")
        registerColor(store, light, "Color")

        store.conn = RunService.Heartbeat:Connect(function()
            if not hrp or not hrp.Parent then return end
            local bob = math.sin(tick() * 2) * 0.35
            p.CFrame = hrp.CFrame * CFrame.new(1.7, 1.7 + bob, -1.5)
        end)
        store.instances = {p}
    end)
end, function(store)
    if store.conn then store.conn:Disconnect() end
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("Двойные орбиты", "Косметика", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.conn then store.conn:Disconnect() end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end

        local parts = {}
        for i = 1, 8 do
            local p = Instance.new("Part")
            p.Shape = Enum.PartType.Ball
            p.Size = Vector3.new(0.18, 0.18, 0.18)
            p.Material = Enum.Material.Neon
            p.Color = accent()
            p.CanCollide = false
            p.Massless = true
            p.Anchored = true
            p.Parent = workspace
            table.insert(parts, p)
            registerColor(store, p, "Color")
        end

        store.conn = RunService.Heartbeat:Connect(function()
            if not hrp or not hrp.Parent then return end
            for i, p in ipairs(parts) do
                local ring = (i <= 4) and 1 or 2
                local idx = (i - 1) % 4
                local ang = tick() * (ring == 1 and 1.6 or -1.2) + (idx * (math.pi * 2 / 4))
                local rad = ring == 1 and 2.4 or 3.5
                local height = ring == 1 and 1.0 or 1.8
                local off = Vector3.new(math.cos(ang) * rad, height, math.sin(ang) * rad)
                p.CFrame = CFrame.new(hrp.Position + off)
            end
        end)
        store.instances = parts
    end)
end, function(store)
    if store.conn then store.conn:Disconnect() end
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("Хвост частиц", "Косметика", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local att = Instance.new("Attachment")
        att.Position = Vector3.new(0, -1.5, 0.3)
        att.Parent = hrp
        local e = Instance.new("ParticleEmitter")
        e.Rate = 30 * Config.Intensity
        e.Lifetime = NumberRange.new(0.6, 1.2)
        e.Speed = NumberRange.new(1, 3)
        e.SpreadAngle = Vector2.new(20, 30)
        e.Size = NumberSequence.new(0.25, 0.02)
        e.Transparency = NumberSequence.new(0.2, 1)
        e.Color = ColorSequence.new(accent())
        e.LightEmission = 0.5
        e.EmissionDirection = Enum.NormalId.Back
        e.Parent = att
        registerColor(store, e, "Color", true)
        store.instances = {att, e}
    end)
end, function(store)
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)


-- ===== ДОПОЛНИТЕЛЬНЫЕ ЭФФЕКТЫ (v6.1) =====

-- МИР
addEffect("Падающие листья", "Мир", function(store)
    local e = Instance.new("ParticleEmitter")
    e.Texture = "rbxassetid://241625105"
    e.Rate = 6 * Config.Intensity
    e.Lifetime = NumberRange.new(4, 7)
    e.Speed = NumberRange.new(1, 3)
    e.Size = NumberSequence.new(0.2, 0.35)
    e.Transparency = NumberSequence.new(0.2, 1)
    e.Color = ColorSequence.new(Color3.fromRGB(80, 180, 90), Color3.fromRGB(200, 160, 60))
    e.RotSpeed = NumberRange.new(-60, 60)
    e.Acceleration = Vector3.new(0, -2, 0)
    e.Parent = workspace.Terrain
    store.inst = e
end, function(store) if store.inst then store.inst:Destroy() end end)

addEffect("Снег", "Мир", function(store)
    local e = Instance.new("ParticleEmitter")
    e.Rate = 12 * Config.Intensity
    e.Lifetime = NumberRange.new(5, 9)
    e.Speed = NumberRange.new(0.5, 1.5)
    e.Size = NumberSequence.new(0.12, 0.2)
    e.Transparency = NumberSequence.new(0.1, 1)
    e.Color = ColorSequence.new(Color3.fromRGB(240, 245, 255))
    e.Acceleration = Vector3.new(0, -3, 0)
    e.Parent = workspace.Terrain
    store.inst = e
end, function(store) if store.inst then store.inst:Destroy() end end)

addEffect("Искры в воздухе", "Мир", function(store)
    local e = Instance.new("ParticleEmitter")
    e.Rate = 5 * Config.Intensity
    e.Lifetime = NumberRange.new(1.5, 3)
    e.Speed = NumberRange.new(0.3, 1)
    e.Size = NumberSequence.new(0.08, 0)
    e.Transparency = NumberSequence.new(0, 1)
    e.Color = ColorSequence.new(accent())
    e.LightEmission = 0.8
    e.Parent = workspace.Terrain
    registerColor(store, e, "Color", true)
    store.inst = e
end, function(store) if store.inst then store.inst:Destroy() end end)

addEffect("Пыльца", "Мир", function(store)
    local e = Instance.new("ParticleEmitter")
    e.Rate = 4 * Config.Intensity
    e.Lifetime = NumberRange.new(3, 6)
    e.Speed = NumberRange.new(0.2, 0.8)
    e.Size = NumberSequence.new(0.06, 0.15)
    e.Transparency = NumberSequence.new(0.3, 1)
    e.Color = ColorSequence.new(Color3.fromRGB(255, 230, 120))
    e.Parent = workspace.Terrain
    store.inst = e
end, function(store) if store.inst then store.inst:Destroy() end end)

-- АТМОСФЕРА
addEffect("Тёплая коррекция", "Атмосфера", function(store)
    local c = Instance.new("ColorCorrectionEffect")
    c.TintColor = Color3.fromRGB(255, 235, 210)
    c.Saturation = 0.08
    c.Contrast = 0.05
    c.Parent = Lighting
    store.inst = c
end, function(store) if store.inst then store.inst:Destroy() end end)

addEffect("Холодная коррекция", "Атмосфера", function(store)
    local c = Instance.new("ColorCorrectionEffect")
    c.TintColor = Color3.fromRGB(200, 220, 255)
    c.Saturation = -0.05
    c.Contrast = 0.08
    c.Parent = Lighting
    store.inst = c
end, function(store) if store.inst then store.inst:Destroy() end end)

addEffect("Виньетка (Blur край)", "Атмосфера", function(store)
    local b = Instance.new("BlurEffect")
    b.Size = 8
    b.Parent = Lighting
    store.inst = b
end, function(store) if store.inst then store.inst:Destroy() end end)

addEffect("Яркий Bloom", "Атмосфера", function(store)
    local b = Instance.new("BloomEffect")
    b.Intensity = 1.6
    b.Size = 40
    b.Threshold = 0.7
    b.Parent = Lighting
    store.inst = b
end, function(store) if store.inst then store.inst:Destroy() end end)

addEffect("Мягкие лучи", "Атмосфера", function(store)
    local s = Instance.new("SunRaysEffect")
    s.Intensity = 0.08
    s.Spread = 0.9
    s.Parent = Lighting
    store.inst = s
end, function(store) if store.inst then store.inst:Destroy() end end)

-- ИГРОК
addEffect("Круг под ногами", "Игрок", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.conn then store.conn:Disconnect() end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local p = Instance.new("Part")
        p.Shape = Enum.PartType.Cylinder
        p.Size = Vector3.new(0.05, 3.5, 3.5)
        p.Material = Enum.Material.Neon
        p.Color = accent()
        p.Transparency = 0.4
        p.CanCollide = false
        p.Massless = true
        p.Anchored = true
        p.CastShadow = false
        p.Parent = workspace
        registerColor(store, p, "Color")
        store.conn = RunService.Heartbeat:Connect(function()
            if not hrp or not hrp.Parent then return end
            p.CFrame = CFrame.new(hrp.Position + Vector3.new(0, -2.9, 0)) * CFrame.Angles(0, 0, math.rad(90))
        end)
        store.instances = {p}
    end)
end, function(store)
    if store.conn then store.conn:Disconnect() end
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("Пульс ауры", "Игрок", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local e = Instance.new("ParticleEmitter")
        e.Rate = 15 * Config.Intensity
        e.Lifetime = NumberRange.new(0.8, 1.4)
        e.Speed = NumberRange.new(1.5, 3)
        e.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(0.5, 0.5),
            NumberSequenceKeypoint.new(1, 0)
        })
        e.Transparency = NumberSequence.new(0.3, 1)
        e.Color = ColorSequence.new(accent())
        e.LightEmission = 0.6
        e.Parent = hrp
        registerColor(store, e, "Color", true)
        store.instances = {e}
    end)
end, function(store)
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("След ног", "Игрок", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.conn then store.conn:Disconnect() end
        store.conn = RunService.Heartbeat:Connect(function()
            if not hrp or not hrp.Parent then return end
            if hrp.AssemblyLinearVelocity.Magnitude > 6 then
                local p = Instance.new("Part")
                p.Shape = Enum.PartType.Ball
                p.Size = Vector3.new(0.35, 0.08, 0.35)
                p.Material = Enum.Material.Neon
                p.Color = accent()
                p.Transparency = 0.3
                p.CanCollide = false
                p.Anchored = true
                p.CastShadow = false
                p.CFrame = CFrame.new(hrp.Position + Vector3.new(0, -2.85, 0))
                p.Parent = workspace
                task.spawn(function()
                    for i = 1, 10 do
                        p.Transparency = 0.3 + i * 0.07
                        task.wait(0.05)
                    end
                    p:Destroy()
                end)
            end
        end)
    end)
end, function(store)
    if store.conn then store.conn:Disconnect() end
end)

addEffect("Обводка всегда", "Игрок", function(store)
    onCharacter(function(char)
        if store.inst then store.inst:Destroy() end
        local hl = Instance.new("Highlight")
        hl.FillTransparency = 1
        hl.OutlineTransparency = 0
        hl.OutlineColor = accent()
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
        registerColor(store, hl, "OutlineColor")
        store.inst = hl
    end)
end, function(store) if store.inst then store.inst:Destroy() end end)

addEffect("Свечение рук", "Игрок", function(store)
    onCharacter(function(char)
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local parts = {}
        for _, name in ipairs({"Left Arm", "Right Arm", "LeftHand", "RightHand", "LeftLowerArm", "RightLowerArm"}) do
            local part = char:FindFirstChild(name) or char:FindFirstChild(name:gsub(" ", ""))
            if part then
                local e = Instance.new("ParticleEmitter")
                e.Rate = 8 * Config.Intensity
                e.Lifetime = NumberRange.new(0.4, 0.8)
                e.Speed = NumberRange.new(0.2, 0.6)
                e.Size = NumberSequence.new(0.1, 0)
                e.Transparency = NumberSequence.new(0.2, 1)
                e.Color = ColorSequence.new(accent())
                e.LightEmission = 0.7
                e.Parent = part
                registerColor(store, e, "Color", true)
                table.insert(parts, e)
            end
        end
        store.instances = parts
    end)
end, function(store)
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

-- КОСМЕТИКА
addEffect("Огненные крылья", "Косметика", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.instances then for _,v in ipairs(store.instances) do if v and v.Parent then v:Destroy() end end end
        local function wing(side)
            local att = Instance.new("Attachment")
            att.Position = Vector3.new(side == "L" and -0.7 or 0.7, 0.9, 0.5)
            att.Parent = hrp
            local e = Instance.new("ParticleEmitter")
            e.Rate = 40 * Config.Intensity
            e.Lifetime = NumberRange.new(0.4, 0.8)
            e.Speed = NumberRange.new(2, 5)
            e.SpreadAngle = Vector2.new(15, 25)
            e.Size = NumberSequence.new(0.35, 0.02)
            e.Transparency = NumberSequence.new(0.1, 1)
            e.Color = ColorSequence.new(Color3.fromRGB(255, 120, 30), Color3.fromRGB(255, 40, 20))
            e.LightEmission = 0.9
            e.EmissionDirection = Enum.NormalId.Back
            e.Parent = att
            return att, e
        end
        local a1,e1 = wing("L")
        local a2,e2 = wing("R")
        store.instances = {a1,e1,a2,e2}
    end)
end, function(store)
    if store.instances then for _,v in ipairs(store.instances) do if v and v.Parent then v:Destroy() end end end
end)

addEffect("Ледяные крылья", "Косметика", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.instances then for _,v in ipairs(store.instances) do if v and v.Parent then v:Destroy() end end end
        local function wing(side)
            local att = Instance.new("Attachment")
            att.Position = Vector3.new(side == "L" and -0.7 or 0.7, 0.9, 0.5)
            att.Parent = hrp
            local e = Instance.new("ParticleEmitter")
            e.Rate = 35 * Config.Intensity
            e.Lifetime = NumberRange.new(0.5, 1)
            e.Speed = NumberRange.new(2, 4)
            e.SpreadAngle = Vector2.new(12, 20)
            e.Size = NumberSequence.new(0.3, 0.02)
            e.Transparency = NumberSequence.new(0.15, 1)
            e.Color = ColorSequence.new(Color3.fromRGB(180, 230, 255), Color3.fromRGB(100, 180, 255))
            e.LightEmission = 0.7
            e.EmissionDirection = Enum.NormalId.Back
            e.Parent = att
            return att, e
        end
        local a1,e1 = wing("L")
        local a2,e2 = wing("R")
        store.instances = {a1,e1,a2,e2}
    end)
end, function(store)
    if store.instances then for _,v in ipairs(store.instances) do if v and v.Parent then v:Destroy() end end end
end)

addEffect("Кольцо энергии", "Косметика", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.conn then store.conn:Disconnect() end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local p = Instance.new("Part")
        p.Shape = Enum.PartType.Cylinder
        p.Size = Vector3.new(0.06, 4, 4)
        p.Material = Enum.Material.Neon
        p.Color = accent()
        p.Transparency = 0.35
        p.CanCollide = false
        p.Massless = true
        p.Anchored = true
        p.CastShadow = false
        p.Parent = workspace
        registerColor(store, p, "Color")
        store.conn = RunService.Heartbeat:Connect(function()
            if not hrp or not hrp.Parent then return end
            p.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 0.2, 0)) * CFrame.Angles(0, tick() * 2, math.rad(90))
        end)
        store.instances = {p}
    end)
end, function(store)
    if store.conn then store.conn:Disconnect() end
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("Сферы защиты", "Косметика", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.conn then store.conn:Disconnect() end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local parts = {}
        for i = 1, 4 do
            local p = Instance.new("Part")
            p.Shape = Enum.PartType.Ball
            p.Size = Vector3.new(0.4, 0.4, 0.4)
            p.Material = Enum.Material.ForceField
            p.Color = accent()
            p.Transparency = 0.3
            p.CanCollide = false
            p.Massless = true
            p.Anchored = true
            p.Parent = workspace
            table.insert(parts, p)
            registerColor(store, p, "Color")
        end
        store.conn = RunService.Heartbeat:Connect(function()
            if not hrp or not hrp.Parent then return end
            for i, p in ipairs(parts) do
                local ang = tick() * 1.1 + (i * math.pi / 2)
                local off = Vector3.new(math.cos(ang) * 2.8, 1.5, math.sin(ang) * 2.8)
                p.CFrame = CFrame.new(hrp.Position + off)
            end
        end)
        store.instances = parts
    end)
end, function(store)
    if store.conn then store.conn:Disconnect() end
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("Звёздный шлейф", "Косметика", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local att = Instance.new("Attachment")
        att.Position = Vector3.new(0, 0, 0.5)
        att.Parent = hrp
        local e = Instance.new("ParticleEmitter")
        e.Rate = 25 * Config.Intensity
        e.Lifetime = NumberRange.new(0.8, 1.5)
        e.Speed = NumberRange.new(0.5, 2)
        e.Size = NumberSequence.new(0.15, 0)
        e.Transparency = NumberSequence.new(0, 1)
        e.Color = ColorSequence.new(accent())
        e.LightEmission = 0.9
        e.EmissionDirection = Enum.NormalId.Back
        e.Parent = att
        registerColor(store, e, "Color", true)
        store.instances = {att, e}
    end)
end, function(store)
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("Радужный след", "Косметика", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local a0 = Instance.new("Attachment")
        a0.Position = Vector3.new(0, 0.3, 0)
        a0.Parent = hrp
        local a1 = Instance.new("Attachment")
        a1.Position = Vector3.new(0, -1.5, 0)
        a1.Parent = hrp
        local trail = Instance.new("Trail")
        trail.Attachment0, trail.Attachment1 = a0, a1
        trail.Lifetime = 0.6
        trail.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(80, 255, 120)),
            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(80, 150, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 80, 255))
        })
        trail.Transparency = NumberSequence.new(0.1, 1)
        trail.WidthScale = NumberSequence.new(1.2, 0)
        trail.Parent = hrp
        store.instances = {a0, a1, trail}
    end)
end, function(store)
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("Нимб", "Косметика", function(store)
    onCharacter(function(char)
        local head = getHead(char)
        if not head then return end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local ring = Instance.new("Part")
        ring.Shape = Enum.PartType.Cylinder
        ring.Size = Vector3.new(0.05, 1.0, 1.0)
        ring.Material = Enum.Material.Neon
        ring.Color = Color3.fromRGB(255, 230, 120)
        ring.CanCollide = false
        ring.Massless = true
        ring.CastShadow = false
        local light = Instance.new("PointLight")
        light.Color = Color3.fromRGB(255, 230, 150)
        light.Brightness = 1.5
        light.Range = 6
        light.Parent = ring
        local weld = Instance.new("Weld")
        weld.Part0 = head
        weld.Part1 = ring
        weld.C0 = CFrame.new(0, 1.7, 0) * CFrame.Angles(0, 0, math.rad(90))
        weld.Parent = ring
        ring.Parent = head
        store.instances = {ring}
    end)
end, function(store)
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("Кристаллы вокруг", "Косметика", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.conn then store.conn:Disconnect() end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local parts = {}
        for i = 1, 5 do
            local p = Instance.new("Part")
            p.Size = Vector3.new(0.25, 0.7, 0.25)
            p.Material = Enum.Material.Neon
            p.Color = accent()
            p.CanCollide = false
            p.Massless = true
            p.Anchored = true
            p.CastShadow = false
            p.Parent = workspace
            table.insert(parts, p)
            registerColor(store, p, "Color")
        end
        store.conn = RunService.Heartbeat:Connect(function()
            if not hrp or not hrp.Parent then return end
            for i, p in ipairs(parts) do
                local ang = tick() * 0.9 + (i * (math.pi * 2 / 5))
                local off = Vector3.new(math.cos(ang) * 2.6, 0.8 + math.sin(tick() + i) * 0.3, math.sin(ang) * 2.6)
                p.CFrame = CFrame.new(hrp.Position + off) * CFrame.Angles(0, ang, math.rad(15))
            end
        end)
        store.instances = parts
    end)
end, function(store)
    if store.conn then store.conn:Disconnect() end
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("Дым за спиной", "Косметика", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local att = Instance.new("Attachment")
        att.Position = Vector3.new(0, 0.5, 0.6)
        att.Parent = hrp
        local e = Instance.new("ParticleEmitter")
        e.Rate = 20 * Config.Intensity
        e.Lifetime = NumberRange.new(1.2, 2)
        e.Speed = NumberRange.new(0.5, 1.5)
        e.Size = NumberSequence.new(0.4, 1.2)
        e.Transparency = NumberSequence.new(0.4, 1)
        e.Color = ColorSequence.new(Color3.fromRGB(40, 40, 50))
        e.EmissionDirection = Enum.NormalId.Back
        e.Parent = att
        store.instances = {att, e}
    end)
end, function(store)
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("Молнии (частицы)", "Косметика", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local e = Instance.new("ParticleEmitter")
        e.Rate = 10 * Config.Intensity
        e.Lifetime = NumberRange.new(0.15, 0.35)
        e.Speed = NumberRange.new(5, 12)
        e.Size = NumberSequence.new(0.08, 0)
        e.Transparency = NumberSequence.new(0, 1)
        e.Color = ColorSequence.new(Color3.fromRGB(180, 220, 255))
        e.LightEmission = 1
        e.SpreadAngle = Vector2.new(40, 40)
        e.Parent = hrp
        store.instances = {e}
    end)
end, function(store)
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("Лепестки", "Косметика", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local e = Instance.new("ParticleEmitter")
        e.Rate = 12 * Config.Intensity
        e.Lifetime = NumberRange.new(1.5, 2.5)
        e.Speed = NumberRange.new(1, 2.5)
        e.Size = NumberSequence.new(0.2, 0.05)
        e.Transparency = NumberSequence.new(0.1, 1)
        e.Color = ColorSequence.new(Color3.fromRGB(255, 150, 180), Color3.fromRGB(255, 100, 140))
        e.RotSpeed = NumberRange.new(-90, 90)
        e.Acceleration = Vector3.new(0, -1, 0)
        e.Parent = hrp
        store.instances = {e}
    end)
end, function(store)
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)

addEffect("Геометрический щит", "Косметика", function(store)
    onCharacter(function(char)
        local hrp = getHRP(char)
        if not hrp then return end
        if store.conn then store.conn:Disconnect() end
        if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
        local parts = {}
        for i = 1, 6 do
            local p = Instance.new("Part")
            p.Size = Vector3.new(0.15, 1.2, 0.15)
            p.Material = Enum.Material.Neon
            p.Color = accent()
            p.CanCollide = false
            p.Massless = true
            p.Anchored = true
            p.CastShadow = false
            p.Parent = workspace
            table.insert(parts, p)
            registerColor(store, p, "Color")
        end
        store.conn = RunService.Heartbeat:Connect(function()
            if not hrp or not hrp.Parent then return end
            for i, p in ipairs(parts) do
                local ang = tick() * 1.4 + (i * (math.pi * 2 / 6))
                local off = Vector3.new(math.cos(ang) * 2.2, 1.2, math.sin(ang) * 2.2)
                p.CFrame = CFrame.new(hrp.Position + off, hrp.Position)
            end
        end)
        store.instances = parts
    end)
end, function(store)
    if store.conn then store.conn:Disconnect() end
    if store.instances then for _,v in ipairs(store.instances) do if v then v:Destroy() end end end
end)


-- ===================== TOGGLES =====================
local function makeToggle(name, data)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -2, 0, 30)
    row.BackgroundColor3 = Color3.fromRGB(255,255,255)
    row.BackgroundTransparency = 0.95
    row.Visible = false
    row.Parent = Content
    corner(row, 6)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(1, -55, 1, 0)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextColor3 = Color3.fromRGB(215,215,225)
    label.Text = name
    label.Parent = row

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 34, 0, 16)
    toggle.Position = UDim2.new(1, -44, 0.5, -8)
    toggle.BackgroundColor3 = Color3.fromRGB(40,40,50)
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.Parent = row
    corner(toggle, 8)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new(0, 2, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(230,230,235)
    knob.Parent = toggle
    corner(knob, 6)

    local state = false
    local store = {}

    local function turnOn(silent)
        state = true
        EnabledEffects[name] = true
        tween(toggle, {BackgroundColor3 = accent()}, 0.12)
        tween(knob, {Position = UDim2.new(1, -14, 0.5, -6)}, 0.12)
        store = {}
        pcall(data.On, store)
        ActiveStores[name] = store
        if not silent then
            saveAutosave({theme = CurrentTheme, effects = EnabledEffects})
        end
    end

    local function turnOff(silent)
        state = false
        EnabledEffects[name] = nil
        tween(toggle, {BackgroundColor3 = Color3.fromRGB(40,40,50)}, 0.12)
        tween(knob, {Position = UDim2.new(0, 2, 0.5, -6)}, 0.12)
        pcall(data.Off, store)
        ActiveStores[name] = nil
        if not silent then
            saveAutosave({theme = CurrentTheme, effects = EnabledEffects})
        end
    end

    toggle.MouseButton1Click:Connect(function()
        if state then turnOff() else turnOn() end
    end)

    local ctrl = {
        ForceOff = function() if state then turnOff(true) end end,
        ForceOn = function() if not state then turnOn(true) end end,
        IsOn = function() return state end
    }
    table.insert(AllToggleControls, ctrl)
    ToggleByName[name] = ctrl
    table.insert(categoryRows[data.Category], row)
end

for _, name in ipairs(EffectOrder) do
    makeToggle(name, Effects[name])
end

-- ===================== ТЕМЫ (вкладка) =====================
for i, t in ipairs(Themes) do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -2, 0, 28)
    row.BackgroundColor3 = Color3.fromRGB(255,255,255)
    row.BackgroundTransparency = 0.95
    row.Visible = false
    row.Parent = Content
    corner(row, 6)

    local sw = Instance.new("Frame")
    sw.Size = UDim2.new(0, 14, 0, 14)
    sw.Position = UDim2.new(0, 10, 0.5, -7)
    sw.BackgroundColor3 = t.Accent
    sw.Parent = row
    corner(sw, 7)

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 32, 0, 0)
    lbl.Size = UDim2.new(1, -40, 1, 0)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextColor3 = Color3.fromRGB(215,215,225)
    lbl.Text = t.Name
    lbl.Parent = row

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = row
    btn.MouseButton1Click:Connect(function()
        applyTheme(i)
        saveAutosave({theme = CurrentTheme, effects = EnabledEffects})
    end)

    table.insert(categoryRows["Темы"], row)
end

-- ===================== НАСТРОЙКИ =====================
local function settingsLabel(text)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -2, 0, 22)
    row.BackgroundTransparency = 1
    row.Visible = false
    row.Parent = Content
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextColor3 = Color3.fromRGB(140,140,155)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = text
    lbl.Parent = row
    table.insert(categoryRows["Настройки"], row)
    return lbl
end

settingsLabel("Конфиги (сохраняются локально)")

-- Список конфигов
local configListLabel = settingsLabel("Загрузка...")

local function refreshConfigList()
    local list = listConfigs()
    if #list == 0 then
        configListLabel.Text = "Нет сохранённых конфигов"
    else
        configListLabel.Text = "Конфиги: " .. table.concat(list, ", ")
    end
end

-- Кнопка сохранить конфиг
do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -2, 0, 30)
    row.BackgroundColor3 = Color3.fromRGB(255,255,255)
    row.BackgroundTransparency = 0.95
    row.Visible = false
    row.Parent = Content
    corner(row, 6)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 1, -6)
    btn.Position = UDim2.new(0, 5, 0, 3)
    btn.BackgroundColor3 = accent()
    btn.BackgroundTransparency = 0.7
    btn.Text = "Сохранить текущий как config1"
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.TextColor3 = Color3.fromRGB(240,240,245)
    btn.AutoButtonColor = false
    btn.Parent = row
    corner(btn, 5)
    table.insert(ThemedUI, {inst = btn, prop = "BackgroundColor3"})

    btn.MouseButton1Click:Connect(function()
        local name = "config" .. tostring(#listConfigs() + 1)
        local data = {theme = CurrentTheme, effects = EnabledEffects}
        if saveNamedConfig(name, data) then
            btn.Text = "Сохранено: " .. name
            refreshConfigList()
            task.delay(1.5, function() btn.Text = "Сохранить текущий как config" .. tostring(#listConfigs() + 1) end)
        else
            btn.Text = "Ошибка (нет writefile?)"
        end
    end)
    table.insert(categoryRows["Настройки"], row)
end

-- Загрузить config1
do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -2, 0, 30)
    row.BackgroundColor3 = Color3.fromRGB(255,255,255)
    row.BackgroundTransparency = 0.95
    row.Visible = false
    row.Parent = Content
    corner(row, 6)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 1, -6)
    btn.Position = UDim2.new(0, 5, 0, 3)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,75)
    btn.Text = "Загрузить config1"
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.TextColor3 = Color3.fromRGB(220,220,230)
    btn.AutoButtonColor = false
    btn.Parent = row
    corner(btn, 5)

    btn.MouseButton1Click:Connect(function()
        local data = loadNamedConfig("config1")
        if data then
            if data.theme then applyTheme(data.theme) end
            for name, ctrl in pairs(ToggleByName) do
                if data.effects and data.effects[name] then
                    ctrl.ForceOn()
                else
                    ctrl.ForceOff()
                end
            end
            btn.Text = "Загружено!"
            task.delay(1.2, function() btn.Text = "Загрузить config1" end)
        else
            btn.Text = "config1 не найден"
            task.delay(1.2, function() btn.Text = "Загрузить config1" end)
        end
    end)
    table.insert(categoryRows["Настройки"], row)
end

-- Удалить config1
do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -2, 0, 30)
    row.BackgroundColor3 = Color3.fromRGB(255,255,255)
    row.BackgroundTransparency = 0.95
    row.Visible = false
    row.Parent = Content
    corner(row, 6)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 1, -6)
    btn.Position = UDim2.new(0, 5, 0, 3)
    btn.BackgroundColor3 = Color3.fromRGB(180, 50, 60)
    btn.BackgroundTransparency = 0.7
    btn.Text = "Удалить config1"
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.TextColor3 = Color3.fromRGB(255, 180, 180)
    btn.AutoButtonColor = false
    btn.Parent = row
    corner(btn, 5)

    btn.MouseButton1Click:Connect(function()
        if deleteNamedConfig("config1") then
            btn.Text = "Удалено"
            refreshConfigList()
        else
            btn.Text = "Ошибка"
        end
        task.delay(1.2, function() btn.Text = "Удалить config1" end)
    end)
    table.insert(categoryRows["Настройки"], row)
end

-- Выключить всё
do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -2, 0, 30)
    row.BackgroundColor3 = Color3.fromRGB(255,255,255)
    row.BackgroundTransparency = 0.95
    row.Visible = false
    row.Parent = Content
    corner(row, 6)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 1, -6)
    btn.Position = UDim2.new(0, 5, 0, 3)
    btn.BackgroundColor3 = Color3.fromRGB(255, 70, 90)
    btn.BackgroundTransparency = 0.85
    btn.Text = "Выключить все эффекты"
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.TextColor3 = Color3.fromRGB(255, 150, 160)
    btn.AutoButtonColor = false
    btn.Parent = row
    corner(btn, 5)
    btn.MouseButton1Click:Connect(function()
        for _, c in ipairs(AllToggleControls) do c.ForceOff() end
        saveAutosave({theme = CurrentTheme, effects = {}})
    end)
    table.insert(categoryRows["Настройки"], row)
end

refreshConfigList()

-- ===================== TABS =====================
local TabOrder = {"Мир", "Атмосфера", "Игрок", "Косметика", "Темы", "Настройки"}
local tabButtons = {}

local function renderTab(name)
    for cat, rows in pairs(categoryRows) do
        local vis = (cat == name)
        for _, r in ipairs(rows) do r.Visible = vis end
    end
    for tName, btn in pairs(tabButtons) do
        if tName == name then
            tween(btn.Bg, {BackgroundTransparency = 0.82}, 0.12)
            tween(btn.Bar, {BackgroundTransparency = 0}, 0.12)
        else
            tween(btn.Bg, {BackgroundTransparency = 1}, 0.12)
            tween(btn.Bar, {BackgroundTransparency = 1}, 0.12)
        end
    end
end

for _, tabName in ipairs(TabOrder) do
    local wrap = Instance.new("TextButton")
    wrap.Size = UDim2.new(1, 0, 0, 26)
    wrap.BackgroundTransparency = 1
    wrap.Text = ""
    wrap.AutoButtonColor = false
    wrap.Parent = TabBar

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(255,255,255)
    bg.BackgroundTransparency = 1
    bg.Parent = wrap
    corner(bg, 5)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 2, 0.5, 0)
    bar.Position = UDim2.new(0, 0, 0.25, 0)
    bar.BackgroundColor3 = accent()
    bar.BackgroundTransparency = 1
    bar.Parent = wrap
    corner(bar, 1)
    table.insert(ThemedUI, {inst = bar, prop = "BackgroundColor3"})

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0, 9, 0, 0)
    lbl.Size = UDim2.new(1, -9, 1, 0)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextColor3 = Color3.fromRGB(220,220,230)
    lbl.Text = tabName
    lbl.Parent = wrap

    tabButtons[tabName] = {Bg = bg, Bar = bar}
    wrap.MouseButton1Click:Connect(function() renderTab(tabName) end)
end

renderTab("Косметика")

-- ===================== OPEN/CLOSE =====================
local menuOpen = false
local function setMenu(open)
    if open == menuOpen then return end
    menuOpen = open
    if open then
        MenuHolder.Visible = true
        MenuHolder.Size = UDim2.new(0, 480, 0, 0)
        tween(MenuHolder, {Size = UDim2.new(0, 480, 0, 380)}, 0.18)
    else
        tween(MenuHolder, {Size = UDim2.new(0, 480, 0, 0)}, 0.14)
        task.delay(0.14, function()
            if not menuOpen then MenuHolder.Visible = false end
        end)
    end
end

CloseBtn.MouseButton1Click:Connect(function() setMenu(false) end)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift and not menuOpen then
        setMenu(true)
    end
end)

-- ===================== AUTOSAVE LOAD =====================
task.defer(function()
    local data = loadAutosave()
    if data then
        if data.theme then applyTheme(data.theme) end
        if data.effects then
            for name, _ in pairs(data.effects) do
                if ToggleByName[name] then
                    ToggleByName[name].ForceOn()
                end
            end
        end
    end
end)

print("[KorsiVisual v6] Loaded | Right Shift = menu | Configs supported")
