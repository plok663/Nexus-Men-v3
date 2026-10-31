
--==================================================
-- NEXUS PANEL v3.0 | DARK EDITION
-- All-in-One Roblox Studio Developer Menu
--==================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local ON = {}
local Connections = {}
local Highlights = {}
local FlySpeed = 55
local RainbowHue = 0
local SkyfallBusy = false

local GUI = Instance.new("ScreenGui")
GUI.Name = "NexusPanel"
GUI.ResetOnSpawn = false
GUI.Parent = PlayerGui

local function getCharacter()
    return Player.Character
end

local function getHumanoid()
    local c = getCharacter()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getRoot()
    local c = getCharacter()
    return c and c:FindFirstChild("HumanoidRootPart")
end

--==================================================
-- MAIN WINDOW
--==================================================

local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(620,440)
Main.Position = UDim2.new(.5,-310,.5,-220)
Main.BackgroundColor3 = Color3.fromRGB(15,15,20)
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = GUI

Instance.new("UICorner",Main).CornerRadius =
    UDim.new(0,12)

local Border = Instance.new("UIStroke")
Border.Color = Color3.fromRGB(65,65,85)
Border.Parent = Main

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1,0,0,55)
Header.BackgroundColor3 = Color3.fromRGB(24,24,31)
Header.Text = "  NEXUS PANEL  |  v3.0"
Header.TextColor3 = Color3.new(1,1,1)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 18
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Parent = Main

local Close = Instance.new("TextButton")
Close.Size = UDim2.fromOffset(38,35)
Close.Position = UDim2.new(1,-45,0,10)
Close.BackgroundColor3 = Color3.fromRGB(100,40,45)
Close.Text = "X"
Close.TextColor3 = Color3.new(1,1,1)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 16
Close.Parent = Header

Instance.new("UICorner",Close).CornerRadius =
    UDim.new(0,7)

local Sidebar = Instance.new("Frame")
Sidebar.Position = UDim2.fromOffset(0,55)
Sidebar.Size = UDim2.fromOffset(155,385)
Sidebar.BackgroundColor3 = Color3.fromRGB(19,19,25)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local Content = Instance.new("ScrollingFrame")
Content.Position = UDim2.fromOffset(170,70)
Content.Size = UDim2.new(1,-185,1,-85)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 3
Content.CanvasSize = UDim2.new(0,0,0,600)
Content.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.Parent = Content

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Content.CanvasSize = UDim2.new(
        0,0,0,Layout.AbsoluteContentSize.Y+15
    )
end)

--==================================================
-- FLOATING OPEN BUTTON
--==================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Size = UDim2.fromOffset(115,43)
OpenButton.Position = UDim2.new(0,20,.5,-22)
OpenButton.BackgroundColor3 = Color3.fromRGB(25,25,35)
OpenButton.Text = "NEXUS  ☰"
OpenButton.TextColor3 = Color3.new(1,1,1)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 14
OpenButton.Parent = GUI

Instance.new("UICorner",OpenButton).CornerRadius =
    UDim.new(0,9)

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Color3.fromRGB(90,105,155)
OpenStroke.Parent = OpenButton

local function setMenu(state)
    Main.Visible = state
end

Close.MouseButton1Click:Connect(function()
    setMenu(false)
end)

OpenButton.MouseButton1Click:Connect(function()
    setMenu(not Main.Visible)
end)

UIS.InputBegan:Connect(function(input,processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.RightShift then
        setMenu(not Main.Visible)
    end
end)

--==================================================
-- DRAG WINDOW
--==================================================

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType ==
        Enum.UserInputType.MouseMovement then

        local delta = input.Position-dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset+delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset+delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

--==================================================
-- UI HELPERS
--==================================================

local function clearContent()
    for _,v in ipairs(Content:GetChildren()) do
        if v:IsA("GuiObject") and v ~= Layout then
            v:Destroy()
        end
    end
end

local function addLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-8,0,34)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = Content
end

local function addToggle(name,callback)
    local state = false

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1,-8,0,42)
    button.BackgroundColor3 = Color3.fromRGB(31,31,40)
    button.Text = name.."    [OFF]"
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = Content

    Instance.new("UICorner",button).CornerRadius =
        UDim.new(0,7)

    button.MouseButton1Click:Connect(function()
        state = not state
        ON[name] = state

        button.Text = name..
            (state and "    [ON]" or "    [OFF]")

        button.BackgroundColor3 = state
            and Color3.fromRGB(55,75,115)
            or Color3.fromRGB(31,31,40)

        if callback then
            local ok,err = pcall(callback,state)
            if not ok then warn("Nexus:",err) end
        end
    end)
end

local function addButton(name,callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1,-8,0,42)
    button.BackgroundColor3 = Color3.fromRGB(65,45,90)
    button.Text = name
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Parent = Content

    Instance.new("UICorner",button).CornerRadius =
        UDim.new(0,7)

    button.MouseButton1Click:Connect(callback)
end

--==================================================
-- SKYFALL
--==================================================

local function skyfall()
    if SkyfallBusy then return end

    local r = getRoot()
    local h = getHumanoid()

    if not r or not h then return end

    SkyfallBusy = true

    r.AssemblyLinearVelocity = Vector3.zero
    r.CFrame = r.CFrame + Vector3.new(0,150,0)

    task.wait(.3)

    if r.Parent then
        r.AssemblyLinearVelocity = Vector3.new(0,-30,0)
    end

    task.delay(4,function()
        SkyfallBusy = false
    end)
end

--==================================================
-- FLY
--==================================================

local function fly(state)
    if Connections.Fly then
        Connections.Fly:Disconnect()
        Connections.Fly = nil
    end

    local r = getRoot()
    local h = getHumanoid()

    if not r or not h then return end

    if state then
        local velocity = Instance.new("BodyVelocity")
        velocity.MaxForce = Vector3.new(1e6,1e6,1e6)
        velocity.Parent = r

        local gyro = Instance.new("BodyGyro")
        gyro.MaxTorque = Vector3.new(1e6,1e6,1e6)
        gyro.Parent = r

        h.PlatformStand = true

        Connections.Fly = RunService.RenderStepped:Connect(function()
            if not velocity.Parent then return end

            local cf = Camera.CFrame
            local direction = Vector3.zero

            if UIS:IsKeyDown(Enum.KeyCode.W) then
                direction += cf.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                direction -= cf.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                direction -= cf.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                direction += cf.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                direction += Vector3.yAxis
            end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                direction -= Vector3.yAxis
            end

            velocity.Velocity = direction.Magnitude > 0
                and direction.Unit*FlySpeed or Vector3.zero

            gyro.CFrame = cf
        end)

        Connections.FlyObjects = {velocity,gyro}
    else
        if Connections.FlyObjects then
            for _,obj in ipairs(Connections.FlyObjects) do
                obj:Destroy()
            end
            Connections.FlyObjects = nil
        end

        h.PlatformStand = false
    end
end

--==================================================
-- PLAYER HIGHLIGHTS
--==================================================

local function updateHighlights(state)
    for p,h in pairs(Highlights) do
        h:Destroy()
        Highlights[p] = nil
    end

    if not state then return end

    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= Player and p.Character then
            local h = Instance.new("Highlight")
            h.Adornee = p.Character
            h.FillColor = Color3.fromRGB(70,110,255)
            h.OutlineColor = Color3.new(1,1,1)
            h.Parent = GUI
            Highlights[p] = h
        end
    end
end

--==================================================
-- NAME TAGS / DISTANCE
--==================================================

local function updateTags(state)
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= Player then
            if p.Character then
                local old = p.Character:FindFirstChild("NexusTag")
                if old then old:Destroy() end
            end
        end
    end

    if not state then return end

    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= Player then
            local c = p.Character
            local head = c and c:FindFirstChild("Head")

            if head then
                local tag = Instance.new("BillboardGui")
                tag.Name = "NexusTag"
                tag.Adornee = head
                tag.Size = UDim2.fromOffset(190,35)
                tag.StudsOffset = Vector3.new(0,2,0)
                tag.AlwaysOnTop = true
                tag.Parent = c

                local txt = Instance.new("TextLabel")
                txt.Size = UDim2.fromScale(1,1)
                txt.BackgroundTransparency = 1
                txt.TextColor3 = Color3.new(1,1,1)
                txt.TextStrokeTransparency = 0
                txt.Font = Enum.Font.GothamBold
                txt.TextSize = 13
                txt.Parent = tag

                Connections["Tag"..p.UserId] =
                    RunService.RenderStepped:Connect(function()
                        local myRoot = getRoot()
                        local targetRoot = p.Character and
                            p.Character:FindFirstChild("HumanoidRootPart")

                        if myRoot and targetRoot and tag.Parent then
                            local distance =
                                (myRoot.Position-targetRoot.Position).Magnitude

                            txt.Text = p.DisplayName..
                                " | "..math.floor(distance).." studs"
                        end
                    end)
            end
        end
    end
end

--==================================================
-- RAINBOW AVATAR
--==================================================

local function rainbow(state)
    if Connections.Rainbow then
        Connections.Rainbow:Disconnect()
        Connections.Rainbow = nil
    end

    if state then
        Connections.Rainbow = RunService.RenderStepped:Connect(function(dt)
            RainbowHue = (RainbowHue+dt*.3)%1

            local c = getCharacter()
            if c then
                for _,part in ipairs(c:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Color = Color3.fromHSV(RainbowHue,1,1)
                    end
                end
            end
        end)
    end
end

--==================================================
-- POTATO GRAPHICS
--==================================================

local originalShadows = Lighting.GlobalShadows

local function potato(state)
    Lighting.GlobalShadows = not state and originalShadows or false

    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj.Enabled = not state
        end
    end
end

--==================================================
-- GHOST (LOCAL VISUAL TRANSPARENCY)
--==================================================

local GhostDescendantConnection
local GhostOriginalTransparency = setmetatable({}, {__mode = "k"})

local function setGhostObject(obj, state)
    if obj:IsA("BasePart") then
        if state then
            obj.LocalTransparencyModifier = 1
        else
            obj.LocalTransparencyModifier = 0
        end
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        if state then
            if GhostOriginalTransparency[obj] == nil then
                GhostOriginalTransparency[obj] = obj.Transparency
            end
            obj.Transparency = 1
        else
            local original = GhostOriginalTransparency[obj]
            if original ~= nil then
                obj.Transparency = original
                GhostOriginalTransparency[obj] = nil
            end
        end
    end
end

local function ghost(state)
    if GhostDescendantConnection then
        GhostDescendantConnection:Disconnect()
        GhostDescendantConnection = nil
    end

    local character = getCharacter()
    if not character then return end

    for _,obj in ipairs(character:GetDescendants()) do
        setGhostObject(obj, state)
    end

    if state then
        GhostDescendantConnection = character.DescendantAdded:Connect(function(obj)
            setGhostObject(obj, true)
        end)
    end
end

--==================================================
-- GOD MODE (LOCAL TEST)
--==================================================

local GodModeConnection
local GodModeHumanoid
local GodModeOriginalMaxHealth

local function godMode(state)
    if GodModeConnection then
        GodModeConnection:Disconnect()
        GodModeConnection = nil
    end

    local character = getCharacter()
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if state then
        GodModeHumanoid = humanoid
        GodModeOriginalMaxHealth = humanoid.MaxHealth

        -- Local test protection only. The server remains authoritative.
        humanoid.MaxHealth = 1000000
        humanoid.Health = humanoid.MaxHealth

        local forceField = character:FindFirstChild("NexusGodModeForceField")
        if not forceField then
            forceField = Instance.new("ForceField")
            forceField.Name = "NexusGodModeForceField"
            forceField.Visible = true
            forceField.Parent = character
        end

        GodModeConnection = humanoid.HealthChanged:Connect(function(health)
            if ON["God Mode"] and humanoid.Parent and health > 0
                and health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    else
        local forceField = character:FindFirstChild("NexusGodModeForceField")
        if forceField then forceField:Destroy() end

        if GodModeHumanoid == humanoid and humanoid.Parent then
            humanoid.MaxHealth = GodModeOriginalMaxHealth or 100
            humanoid.Health = math.min(humanoid.Health, humanoid.MaxHealth)
        end

        GodModeHumanoid = nil
        GodModeOriginalMaxHealth = nil
    end
end

--==================================================
-- FPS
--==================================================

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.fromOffset(130,30)
fpsLabel.Position = UDim2.new(1,-140,0,10)
fpsLabel.BackgroundColor3 = Color3.fromRGB(20,20,27)
fpsLabel.TextColor3 = Color3.new(1,1,1)
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 13
fpsLabel.Visible = false
fpsLabel.Parent = GUI

local frames = 0
local last = os.clock()

RunService.RenderStepped:Connect(function()
    frames += 1

    if os.clock()-last >= 1 then
        fpsLabel.Text = "FPS: "..frames
        frames = 0
        last = os.clock()
    end
end)

--==================================================
-- SPECTATOR
--==================================================

local SpectateIndex = 1

local function getSpectateTargets()
    local targets = {}

    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= Player then
            local character = p.Character
            local humanoid = character and
                character:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health > 0 then
                table.insert(targets,p)
            end
        end
    end

    table.sort(targets,function(a,b)
        return a.Name:lower() < b.Name:lower()
    end)

    return targets
end

local function updateSpectator()
    local targets = getSpectateTargets()

    if #targets == 0 then
        local h = getHumanoid()
        if h then Camera.CameraSubject = h end
        return
    end

    SpectateIndex = ((SpectateIndex - 1) % #targets) + 1

    local target = targets[SpectateIndex]
    local humanoid = target.Character and
        target.Character:FindFirstChildOfClass("Humanoid")

    if humanoid and humanoid.Health > 0 then
        Camera.CameraSubject = humanoid
    end
end

local function spectator(state)
    if state then
        SpectateIndex = 1
        updateSpectator()
    else
        local h = getHumanoid()
        if h then Camera.CameraSubject = h end
    end
end

local function nextSpectator()
    if not ON["Spectator Camera"] then return end
    SpectateIndex += 1
    updateSpectator()
end

local function previousSpectator()
    if not ON["Spectator Camera"] then return end
    SpectateIndex -= 1
    updateSpectator()
end

--==================================================
-- TELEPORT BEHIND PLAYER
--==================================================

local function teleportBehindPlayer(target)
    if not target or target == Player or target.Parent ~= Players then
        warn("Nexus: Please select a valid player")
        return
    end

    local myRoot = getRoot()
    local targetCharacter = target.Character
    local targetRoot = targetCharacter and
        targetCharacter:FindFirstChild("HumanoidRootPart")
    local targetHumanoid = targetCharacter and
        targetCharacter:FindFirstChildOfClass("Humanoid")

    if not myRoot or not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then
        warn("Nexus: Selected player has no active character")
        return
    end

    -- Positive local Z places the character behind the target's facing direction.
    myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
end

local function movement()
    addLabel("MOVEMENT")
    addToggle("Fly",fly)
    addToggle("Player Highlights",updateHighlights)
    addToggle("Name Tags / Distance",updateTags)
    addButton("SKYFALL  ↓",skyfall)

    addLabel("TELEPORT BEHIND PLAYER")
    addLabel("Select a player below, then press the button:")

    local selectedPlayer = nil
    local currentPlayers = Players:GetPlayers()
    table.sort(currentPlayers,function(a,b)
        return a.Name:lower() < b.Name:lower()
    end)

    local teleportButton = Instance.new("TextButton")
    teleportButton.Size = UDim2.new(1,-8,0,38)
    teleportButton.BackgroundColor3 = Color3.fromRGB(65,45,90)
    teleportButton.Text = "TELEPORT BEHIND SELECTED PLAYER"
    teleportButton.TextColor3 = Color3.new(1,1,1)
    teleportButton.Font = Enum.Font.GothamBold
    teleportButton.TextSize = 13
    teleportButton.Parent = Content
    Instance.new("UICorner",teleportButton).CornerRadius = UDim.new(0,7)

    local selectedLabel = Instance.new("TextLabel")
    selectedLabel.Size = UDim2.new(1,-8,0,25)
    selectedLabel.BackgroundTransparency = 1
    selectedLabel.Text = "Selected: None"
    selectedLabel.TextColor3 = Color3.fromRGB(190,190,200)
    selectedLabel.Font = Enum.Font.Gotham
    selectedLabel.TextSize = 12
    selectedLabel.Parent = Content

    teleportButton.MouseButton1Click:Connect(function()
        if not selectedPlayer then
            selectedLabel.Text = "Selected: Choose a player first"
            return
        end
        teleportBehindPlayer(selectedPlayer)
    end)

    local otherPlayerCount = 0
    for _,targetPlayer in ipairs(currentPlayers) do
        if targetPlayer ~= Player then
            otherPlayerCount += 1

            local playerButton = Instance.new("TextButton")
            playerButton.Size = UDim2.new(1,-8,0,36)
            playerButton.BackgroundColor3 = Color3.fromRGB(25,25,33)
            playerButton.Text = targetPlayer.DisplayName.."  (@"..targetPlayer.Name..")"
            playerButton.TextColor3 = Color3.new(1,1,1)
            playerButton.Font = Enum.Font.Gotham
            playerButton.TextSize = 13
            playerButton.TextTruncate = Enum.TextTruncate.AtEnd
            playerButton.Parent = Content
            Instance.new("UICorner",playerButton).CornerRadius = UDim.new(0,7)

            playerButton.MouseButton1Click:Connect(function()
                selectedPlayer = targetPlayer
                selectedLabel.Text = "Selected: "..targetPlayer.DisplayName
                for _,child in ipairs(Content:GetChildren()) do
                    if child:IsA("TextButton") and child ~= teleportButton then
                        child.BackgroundColor3 = Color3.fromRGB(25,25,33)
                    end
                end
                playerButton.BackgroundColor3 = Color3.fromRGB(65,45,90)
            end)
        end
    end

    if otherPlayerCount == 0 then
        selectedLabel.Text = "No other players are currently in this server."
    end

    addLabel("FLY CONTROLS")
    addLabel("W A S D = Move | Space = Up")
    addLabel("Left Ctrl = Down")
end

local function visuals()
    addLabel("VISUALS")
    addToggle("Rainbow Avatar",rainbow)
    addToggle("Ghost",ghost)
    addToggle("God Mode",godMode)
    addLabel("Note: LocalScript protection only; the game server can still apply damage.")
    addToggle("Potato Graphics",potato)
end

local function createHammerTool()
    local backpack = Player:FindFirstChildOfClass("Backpack") or Player:WaitForChild("Backpack")
    local character = Player.Character

    if backpack:FindFirstChild("Nexus Hammer") or (character and character:FindFirstChild("Nexus Hammer")) then
        return
    end

    local tool = Instance.new("Tool")
    tool.Name = "Nexus Hammer"
    tool.RequiresHandle = true
    tool.CanBeDropped = true
    tool.ToolTip = "A large decorative hammer"
    tool.Grip = CFrame.new(0, -0.7, 0)

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.35, 3.8, 0.35)
    handle.Color = Color3.fromRGB(115, 75, 40)
    handle.Material = Enum.Material.Wood
    handle.CanCollide = false
    handle.Massless = true
    handle.Anchored = false
    handle.Parent = tool

    local head = Instance.new("Part")
    head.Name = "HammerHead"
    head.Size = Vector3.new(2.6, 1.15, 1.15)
    head.Color = Color3.fromRGB(105, 110, 120)
    head.Material = Enum.Material.Metal
    head.CanCollide = false
    head.Massless = true
    head.Anchored = false
    head.CFrame = handle.CFrame * CFrame.new(0, 1.75, 0)
    head.Parent = tool

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = handle
    weld.Part1 = head
    weld.Parent = handle

    -- Cartoon-style visual swing when the equipped hammer is clicked.
    -- This is a cosmetic animation only; it does not damage or knock back players.
    local TweenService = game:GetService("TweenService")
    local normalGrip = tool.Grip
    local swinging = false

    tool.Activated:Connect(function()
        if swinging or tool.Parent ~= Player.Character then
            return
        end

        swinging = true
        local swingGrip = normalGrip
            * CFrame.Angles(math.rad(-65), 0, math.rad(55))

        local swingIn = TweenService:Create(
            tool,
            TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Grip = swingGrip}
        )
        local swingOut = TweenService:Create(
            tool,
            TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Grip = normalGrip}
        )

        swingIn:Play()
        swingIn.Completed:Wait()
        swingOut:Play()
        swingOut.Completed:Wait()
        swinging = false
    end)

    tool.Parent = backpack
end

--==================================================
-- AUTO CLICKER (equipped Roblox Tool)
--==================================================

local AutoClickerEnabled = false
local AutoClickerKey = Enum.KeyCode.F6
local WaitingForAutoClickerKey = false
local AutoClickerButton
local AutoClickerKeyButton

local function updateAutoClickerButton()
    if AutoClickerButton then
        AutoClickerButton.Text = "Auto Clicker    ["..(AutoClickerEnabled and "ON" or "OFF").."]"
        AutoClickerButton.BackgroundColor3 = AutoClickerEnabled
            and Color3.fromRGB(55,75,115)
            or Color3.fromRGB(31,31,40)
    end
    ON["Auto Clicker"] = AutoClickerEnabled
end

local function setAutoClicker(state)
    AutoClickerEnabled = state
    updateAutoClickerButton()

    if state then
        task.spawn(function()
            while AutoClickerEnabled do
                local character = getCharacter()
                local equippedTool = nil
                if character then
                    for _,obj in ipairs(character:GetChildren()) do
                        if obj:IsA("Tool") then
                            equippedTool = obj
                            break
                        end
                    end
                end
                if equippedTool then
                    pcall(function() equippedTool:Activate() end)
                end
                task.wait(0.12)
            end
        end)
    end
end

UIS.InputBegan:Connect(function(input, processed)
    if WaitingForAutoClickerKey then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            AutoClickerKey = input.KeyCode
            WaitingForAutoClickerKey = false
            if AutoClickerKeyButton then
                AutoClickerKeyButton.Text = "Toggle key: "..AutoClickerKey.Name
            end
        end
        return
    end

    if processed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard
        and input.KeyCode == AutoClickerKey then
        setAutoClicker(not AutoClickerEnabled)
    end
end)

local function toolsTab()
    addLabel("TOOLS")
    addLabel("EQUIPPABLE ITEMS")
    addButton("GET HAMMER", createHammerTool)
    addLabel("The hammer will appear in your hotbar.")
end

local function autoClickerTab()
    addLabel("AUTO CLICKER")
    addLabel("Activates the Tool currently equipped in your hotbar.")

    AutoClickerButton = Instance.new("TextButton")
    AutoClickerButton.Size = UDim2.new(1,-8,0,42)
    AutoClickerButton.BackgroundColor3 = Color3.fromRGB(31,31,40)
    AutoClickerButton.TextColor3 = Color3.new(1,1,1)
    AutoClickerButton.Font = Enum.Font.Gotham
    AutoClickerButton.TextSize = 14
    AutoClickerButton.Parent = Content
    Instance.new("UICorner",AutoClickerButton).CornerRadius = UDim.new(0,7)
    updateAutoClickerButton()
    AutoClickerButton.MouseButton1Click:Connect(function()
        setAutoClicker(not AutoClickerEnabled)
    end)

    AutoClickerKeyButton = Instance.new("TextButton")
    AutoClickerKeyButton.Size = UDim2.new(1,-8,0,38)
    AutoClickerKeyButton.BackgroundColor3 = Color3.fromRGB(65,45,90)
    AutoClickerKeyButton.Text = "Toggle key: "..AutoClickerKey.Name
    AutoClickerKeyButton.TextColor3 = Color3.new(1,1,1)
    AutoClickerKeyButton.Font = Enum.Font.Gotham
    AutoClickerKeyButton.TextSize = 13
    AutoClickerKeyButton.Parent = Content
    Instance.new("UICorner",AutoClickerKeyButton).CornerRadius = UDim.new(0,7)
    AutoClickerKeyButton.MouseButton1Click:Connect(function()
        WaitingForAutoClickerKey = true
        AutoClickerKeyButton.Text = "Press a key..."
    end)
end


--==================================================
-- AVATAR (lokale kosmetische Vorschau)
--==================================================

local AvatarOriginalTransparency = {}
local AvatarKorbloxPreviewEnabled = false

local function rememberTransparency(obj)
    if obj and obj:IsA("BasePart") and AvatarOriginalTransparency[obj] == nil then
        AvatarOriginalTransparency[obj] = obj.LocalTransparencyModifier
    end
end

local function restoreAvatarPreview()
    for obj, value in pairs(AvatarOriginalTransparency) do
        if obj and obj.Parent then
            obj.LocalTransparencyModifier = value
        end
    end
    table.clear(AvatarOriginalTransparency)
    AvatarKorbloxPreviewEnabled = false
end

local function setKorbloxPreview()
    local character = getCharacter()
    if not character then return end

    AvatarKorbloxPreviewEnabled = not AvatarKorbloxPreviewEnabled
    -- Hides the right leg locally as a simple Korblox-style preview.
    -- This does not grant or equip the official Korblox avatar item.
    local rightLegNames = {"RightUpperLeg", "RightLowerLeg", "RightFoot", "Right Leg"}
    for _, name in ipairs(rightLegNames) do
        local part = character:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            rememberTransparency(part)
            part.LocalTransparencyModifier = AvatarKorbloxPreviewEnabled and 1 or (AvatarOriginalTransparency[part] or 0)
        end
    end
end

local function avatarTab()
    addLabel("AVATAR")
    addLabel("Kosmetische Vorschau – nur lokal auf deinem Bildschirm.")
    addButton("KORBLOX-OPTIK  |  ON / OFF", setKorbloxPreview)
    addButton("AVATAR-VORSCHAU ZURÜCKSETZEN", restoreAvatarPreview)
    addLabel("Hinweis: Diese Buttons schalten keine kostenpflichtigen Roblox-Items frei und ändern nicht dein echtes Avatar-Inventar.")
end

local function cameraTab()
    addLabel("CAMERA")
    addToggle("Spectator Camera",spectator)
    addButton("Spectate: Previous Player",previousSpectator)
    addButton("Spectate: Next Player",nextSpectator)
end

local function performance()
    addLabel("PERFORMANCE")
    addToggle("FPS Counter",function(v)
        fpsLabel.Visible = v
    end)
end

local function debugging()
    addLabel("DEBUGGING")

    local h = getHumanoid()
    local r = getRoot()

    addLabel("Player: "..Player.Name)
    addLabel("Health: "..(h and tostring(math.floor(h.Health)) or "N/A"))
    addLabel("Position: "..(r and tostring(r.Position) or "N/A"))
    addLabel("Players: "..#Players:GetPlayers())
end

local tabs = {
    Movement = movement,
    Visuals = visuals,
    Tools = toolsTab,
    ["Auto Clicker"] = autoClickerTab,
    Avatar = avatarTab,
    Camera = cameraTab,
    Performance = performance,
    Debugging = debugging
}

local function openTab(name)
    for _,obj in ipairs(Content:GetChildren()) do
        if obj:IsA("GuiObject") and obj ~= Layout then
            obj:Destroy()
        end
    end

    tabs[name]()
end

local names = {
    "Movement",
    "Visuals",
    "Tools",
    "Auto Clicker",
    "Avatar",
    "Camera",
    "Performance",
    "Debugging"
}

for i,name in ipairs(names) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1,-14,0,40)
    button.Position = UDim2.fromOffset(7,8+(i-1)*46)
    button.BackgroundColor3 = Color3.fromRGB(31,31,40)
    button.Text = name
    button.TextColor3 = Color3.new(1,1,1)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.Parent = Sidebar

    Instance.new("UICorner",button).CornerRadius =
        UDim.new(0,6)

    button.MouseButton1Click:Connect(function()
        openTab(name)
    end)
end

-- Keep spectator camera on a valid player when the player list changes
Players.PlayerRemoving:Connect(function()
    task.defer(function()
        if ON["Spectator Camera"] then
            updateSpectator()
        end
    end)
end)

Players.PlayerAdded:Connect(function()
    task.defer(function()
        if ON["Spectator Camera"] then
            updateSpectator()
        end
    end)
end)

--==================================================
-- RESPAWN
--==================================================

Player.CharacterAdded:Connect(function()
    restoreAvatarPreview()
    task.wait(1)

    if ON.Fly then fly(true) end
    if ON.Ghost then ghost(true) end
    if ON["God Mode"] then godMode(true) end
end)

--==================================================
-- START
--==================================================

openTab("Movement")
Main.Visible = true

print("NEXUS PANEL v3.0 loaded!")
