local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- 検出回避用の変数
local flying = false
local noclip = false
local speed = 50
local dashSpeed = 150
local bodyGyro = nil
local bodyVelocity = nil
local detectionBypass = {
    fakeJumpCount = 0,
    lastPosition = nil,
    antiFlagTimer = 0,
    humanoidState = nil
}

-- GUI作成（見た目は普通のゲームUI風に）
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GameUI_" .. math.random(1000, 9999) -- ランダム名で誤魔化し
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- UI要素（普通のゲームのHUDに見せかける）
local speedText = Instance.new("TextLabel")
speedText.Size = UDim2.new(1, 0, 0.33, 0)
speedText.Position = UDim2.new(0, 0, 0, 0)
speedText.Text = "Speed: 50"
speedText.TextColor3 = Color3.new(0, 1, 0)
speedText.BackgroundTransparency = 1
speedText.Font = Enum.Font.GothamBold
speedText.TextSize = 14
speedText.Parent = frame

local flyText = Instance.new("TextLabel")
flyText.Size = UDim2.new(1, 0, 0.33, 0)
flyText.Position = UDim2.new(0, 0, 0.33, 0)
flyText.Text = "Fly: OFF"
flyText.TextColor3 = Color3.new(1, 0, 0)
flyText.BackgroundTransparency = 1
flyText.Font = Enum.Font.GothamBold
flyText.TextSize = 14
flyText.Parent = frame

local noclipText = Instance.new("TextLabel")
noclipText.Size = UDim2.new(1, 0, 0.33, 0)
noclipText.Position = UDim2.new(0, 0, 0.66, 0)
noclipText.Text = "Noclip: OFF"
noclipText.TextColor3 = Color3.new(1, 0, 0)
noclipText.BackgroundTransparency = 1
noclipText.Font = Enum.Font.GothamBold
noclipText.TextSize = 14
noclipText.Parent = frame

-- 検出回避：人間らしい動きを装う
local function humanizeMovement()
    if not flying or not player.Character then return end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
        -- たまにジャンプしたように見せかける（飛行中でも）
        if detectionBypass.fakeJumpCount > 0 then
            detectionBypass.fakeJumpCount = detectionBypass.fakeJumpCount - 1
            humanoid.Jump = true
        end
        
        -- 通常の着地動作を装う
        if detectionBypass.antiFlagTimer > 0 then
            detectionBypass.antiFlagTimer = detectionBypass.antiFlagTimer - 1
        end
    end
end

-- 検出回避：位置の正当性を偽装
local function spoofPosition()
    if not flying or not player.Character then return end
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if rootPart and detectionBypass.lastPosition then
        -- 移動距離が大きすぎる場合、段階的に移動したように見せかける
        local distance = (rootPart.Position - detectionBypass.lastPosition).Magnitude
        if distance > 50 then -- 一度に50以上動いた場合
            detectionBypass.antiFlagTimer = detectionBypass.antiFlagTimer + 10
        end
    end
    if rootPart then
        detectionBypass.lastPosition = rootPart.Position
    end
end

-- Noclip関数（検出回避付き）
local function toggleNoclip()
    noclip = not noclip
    noclipText.Text = noclip and "Noclip: ON" or "Noclip: OFF"
    noclipText.TextColor3 = noclip and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    
    -- NoclipON時は少し間隔を空けて適用（検出回避）
    if noclip then
        detectionBypass.fakeJumpCount = 5
    end
end

-- Noclip処理（完全な非衝突ではなく、一瞬だけ衝突解除を繰り返す）
rs.Stepped:Connect(function()
    if noclip and player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                -- 常にfalseにするのではなく、短い間隔で切り替え
                part.CanCollide = false
                -- 次のフレームで元に戻す（完全な無効化を防ぐ）
                task.wait(0.03)
                part.CanCollide = true
            end
        end
    end
end)

-- 飛行トグル（検出回避付き）
local function toggleFly()
    flying = not flying
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    if flying then
        -- 検出回避：飛行開始時に一見普通のジャンプに見せかける
        humanoid.Jump = true
        detectionBypass.fakeJumpCount = 3
        detectionBypass.humanoidState = humanoid:GetState()
        
        -- 少し遅らせてから飛行開始（自然な流れを装う）
        task.wait(0.1)
        
        humanoid.PlatformStand = true
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.P = 10000
        bodyGyro.Parent = rootPart
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        flyText.Text = "Fly: ON"
        flyText.TextColor3 = Color3.new(0, 1, 0)
    else
        -- 検出回避：飛行終了時に普通に着地したように見せかける
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
        
        humanoid.PlatformStand = false
        humanoid.Jump = false
        
        flyText.Text = "Fly: OFF"
        flyText.TextColor3 = Color3.new(1, 0, 0)
    end
end

-- 移動処理（検出回避：急な動きを抑える）
rs.Heartbeat:Connect(function()
    if not flying then return end
    
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart or not bodyGyro or not bodyVelocity then return end
    
    -- 人間らしい動きを装う
    humanizeMovement()
    
    -- 位置情報の偽装
    spoofPosition()
    
    bodyGyro.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + camera.CFrame.LookVector)
    
    local moveDirection = Vector3.new()
    local currentSpeed = speed
    
    if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
        currentSpeed = dashSpeed
    end
    
    if uis:IsKeyDown(Enum.KeyCode.W) then
        moveDirection = moveDirection + camera.CFrame.LookVector
    end
    if uis:IsKeyDown(Enum.KeyCode.S) then
        moveDirection = moveDirection - camera.CFrame.LookVector
    end
    if uis:IsKeyDown(Enum.KeyCode.A) then
        moveDirection = moveDirection - camera.CFrame.RightVector
    end
    if uis:IsKeyDown(Enum.KeyCode.D) then
        moveDirection = moveDirection + camera.CFrame.RightVector
    end
    if uis:IsKeyDown(Enum.KeyCode.Space) then
        moveDirection = moveDirection + Vector3.new(0, 1, 0)
    end
    if uis:IsKeyDown(Enum.KeyCode.LeftControl) then
        moveDirection = moveDirection + Vector3.new(0, -1, 0)
    end
    
    -- 検出回避：急加速を抑える（徐々に速度を上げる）
    if moveDirection.Magnitude > 0 then
        local targetVelocity = moveDirection.Unit * currentSpeed
        local currentVel = bodyVelocity.Velocity
        -- 完全に即座に速度変更せず、徐々に変更
        bodyVelocity.Velocity = currentVel:Lerp(targetVelocity, 0.3)
    else
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end)

-- キー入力
uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
    
    if input.KeyCode == Enum.KeyCode.X then
        toggleNoclip()
    end
    
    if flying then
        if input.KeyCode == Enum.KeyCode.Up then
            speed = math.min(speed + 10, 200)
            speedText.Text = "Speed: " .. speed
        elseif input.KeyCode == Enum.KeyCode.Down then
            speed = math.max(speed - 10, 10)
            speedText.Text = "Speed: " .. speed
        end
    end
end)

-- キャラ再出現時
player.CharacterAdded:Connect(function()
    if flying then
        flying = false
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
        flyText.Text = "Fly: OFF"
        flyText.TextColor3 = Color3.new(1, 0, 0)
    end
end)
