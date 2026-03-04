-- プレイヤーとサービスの取得
local player = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- 変数の初期化
local flying = false
local speed = 50
local bodyGyro = nil
local bodyVelocity = nil

-- 飛行トグル関数
local function toggleFly()
    flying = not flying
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    if flying then
        -- 飛行開始
        humanoid.PlatformStand = true
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.P = 10000
        bodyGyro.Parent = rootPart
        
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
    else
        -- 飛行終了
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
        humanoid.PlatformStand = false
    end
end

-- 移動処理
rs.Heartbeat:Connect(function()
    if not flying then return end
    
    local character = player.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart or not bodyGyro or not bodyVelocity then return end
    
    -- カメラの方向を向く
    bodyGyro.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + camera.CFrame.LookVector)
    
    -- 移動方向の計算
    local moveDirection = Vector3.new()
    
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
    
    -- 速度を適用
    if moveDirection.Magnitude > 0 then
        bodyVelocity.Velocity = moveDirection.Unit * speed
    else
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end)

-- キー入力処理
uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Fキーで飛行ON/OFF
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
    
    -- 飛行中のみ速度変更可能
    if flying then
        if input.KeyCode == Enum.KeyCode.Up then
            speed = math.min(speed + 10, 200)
            print("飛行速度: " .. speed)
        elseif input.KeyCode == Enum.KeyCode.Down then
            speed = math.max(speed - 10, 10)
            print("飛行速度: " .. speed)
        end
    end
end)

-- キャラクター再出現時の処理
player.CharacterAdded:Connect(function()
    if flying then
        flying = false
        if bodyGyro then bodyGyro:Destroy() end
        if bodyVelocity then bodyVelocity:Destroy() end
    end
end)

print("飛行スクリプト読み込み完了！ FキーでON/OFF")
