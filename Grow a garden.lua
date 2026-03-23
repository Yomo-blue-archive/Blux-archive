local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Grow a Garden | Ys9282 VIP 100+",
   LoadingTitle = "Đang nạp chế độ gom hàng...",
   LoadingSubtitle = "Nhặt đủ 100 món mới đi bán",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Cày Cuốc", 4483362458)

_G.AutoFarm = false
_G.NhaCuaToi = nil
_G.Counter = 0 -- Biến đếm số lượng trái đã nhặt

local player = game.Players.LocalPlayer
local sellPos = CFrame.new(36.589134216308594, 2.999999761581421, 0.4267922341823578)

local function startGomHang()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    
    -- Khóa vị trí vườn nhà
    _G.NhaCuaToi = root.CFrame
    _G.Counter = 0 -- Reset bộ đếm khi bắt đầu
    Rayfield:Notify({Title = "Hệ thống Sẵn Sàng!", Content = "Sẽ đi bán sau mỗi 100 món nhặt được.", Duration = 4})

    while _G.AutoFarm do
        local currentRoot = player.Character:WaitForChild("HumanoidRootPart")

        -- 1. LUÔN VỀ VƯỜN ĐỂ QUÉT HÀNG
        currentRoot.CFrame = _G.NhaCuaToi
        task.wait(0.5)

        -- 2. VÒNG LẶP THU HOẠCH
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and (obj.ObjectText == "Collect" or obj.ActionText == "Collect") then
                local targetPos = obj.Parent.Position
                if (currentRoot.Position - targetPos).Magnitude < 55 then 
                    -- Bay tới nhặt
                    currentRoot.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
                    task.wait(0.1)
                    fireproximityprompt(obj)
                    
                    -- TĂNG BỘ ĐẾM
                    _G.Counter = _G.Counter + 1
                    task.wait(0.1)
                end
            end
            if not _G.AutoFarm then break end
        end

        -- 3. KIỂM TRA ĐIỀU KIỆN BÁN (TRÊN 100 MÓN)
        if _G.Counter >= 100 then
            Rayfield:Notify({Title = "ĐÃ ĐỦ 100 MÓN!", Content = "Đang bay đi bán hàng...", Duration = 2})
            
            -- Bay đi bán
            currentRoot.CFrame = sellPos
            task.wait(0.8)
            game:GetService("ReplicatedStorage").GameEvents.Sell_Inventory:FireServer()
            task.wait(0.5)
            
            -- Bán xong thì Reset bộ đếm về 0 và về nhà
            _G.Counter = 0
            currentRoot.CFrame = _G.NhaCuaToi
            task.wait(0.5)
        end

        task.wait(1.5) -- Nghỉ 1.5s để đợi cây lớn tiếp
    end
end

MainTab:CreateToggle({
   Name = "Bật Auto Farm (Gom 100 món mới bán)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then 
          task.spawn(startGomHang) 
      end
   end,
})

-- ANTI-AFK (Giữ kết nối trên Samsung A22)
local VirtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

