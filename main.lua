local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Rocket",
    LoadingTitle = "Ai hỏi?",
    LoadingSubtitle = "by Coconut (Blue Archive)",
})

local Tab = Window:CreateTab("Tự động", 4483362458)
local AfkTab = Window:CreateTab("AFK & Tiện ích", 4483362458)

local _G = {
    AutoFuel = false,
    AutoRocketClick = false,
    AutoRocketLaunch = false,
    AutoTap = false,
    AutoEquipAll = false,
    AutoUpgrade = false,
    JumpAFK = false,
    DetectedID = nil
}

-- BỘ DÒ ID
local function StartHooking()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "FireServer" and (args[1] and type(args[1]) == "number") then
            _G.DetectedID = args[1]
        end
        return oldNamecall(self, ...)
    end)
end
task.spawn(StartHooking)

-- ================= TAB TỰ ĐỘNG (FIXED STOP) =================
Tab:CreateSection("Hoạt động")

Tab:CreateToggle({
    Name = "Auto Rocket (Phóng & Kết thúc)",
    CurrentValue = false,
    Flag = "RocketLaunchToggle", 
    Callback = function(Value)
        _G.AutoRocketLaunch = Value
        if Value then
            task.spawn(function()
                local RE = game:GetService("ReplicatedStorage"):WaitForChild("Vrtx"):WaitForChild("Events"):WaitForChild("RE")
                while _G.AutoRocketLaunch do
                    if not _G.AutoRocketLaunch then break end -- KIỂM TRA ĐỂ DỪNG
                    if _G.DetectedID then
                        RE.launchButtonClick:FireServer(_G.DetectedID)
                        RE.rocketFinished:FireServer()
                    end
                    task.wait(1.2)
                end
            end)
        end
    end,
})

Tab:CreateToggle({
    Name = "Auto Rocket Click",
    CurrentValue = false,
    Flag = "RocketClickToggle", 
    Callback = function(Value)
        _G.AutoRocketClick = Value
        if Value then
            task.spawn(function()
                local RE = game:GetService("ReplicatedStorage"):WaitForChild("Vrtx"):WaitForChild("Events"):WaitForChild("RE")
                while _G.AutoRocketClick do
                    if not _G.AutoRocketClick then break end -- KIỂM TRA ĐỂ DỪNG
                    if _G.DetectedID then RE.rocketClick:FireServer(_G.DetectedID) end
                    task.wait(0.1) 
                end
            end)
        end
    end,
})

Tab:CreateToggle({
    Name = "Auto Tap",
    CurrentValue = false,
    Flag = "TapToggle", 
    Callback = function(Value)
        _G.AutoTap = Value
        if Value then
            task.spawn(function()
                local RE = game:GetService("ReplicatedStorage"):WaitForChild("Vrtx"):WaitForChild("Events"):WaitForChild("RE")
                while _G.AutoTap do
                    if not _G.AutoTap then break end -- KIỂM TRA ĐỂ DỪNG
                    if _G.DetectedID then RE.tapButtonClick:FireServer(_G.DetectedID) end
                    task.wait(0.1) 
                end
            end)
        end
    end,
})

Tab:CreateSection("Nâng cấp & Nhiên liệu")

Tab:CreateToggle({
    Name = "Auto Collect ALL Fuel",
    CurrentValue = false,
    Flag = "FuelAllInOne", 
    Callback = function(Value)
        _G.AutoFuel = Value
        if Value then
            task.spawn(function()
                local RE = game:GetService("ReplicatedStorage"):WaitForChild("Vrtx"):WaitForChild("Events"):WaitForChild("RE"):WaitForChild("collectFuel")
                local fuelTypes = {"oilPumps", "oilDrill", "acidPump", "fuelTank"}
                while _G.AutoFuel do
                    if not _G.AutoFuel then break end -- KIỂM TRA ĐỂ DỪNG
                    if _G.DetectedID then
                        RE:FireServer(_G.DetectedID, "tapFuel")
                        for _, fType in pairs(fuelTypes) do
                            for i = 1, 10 do
                                if not _G.AutoFuel then break end
                                RE:FireServer(_G.DetectedID, fType .. i)
                                task.wait(0.05)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end,
})

Tab:CreateToggle({
    Name = "Auto Upgrade (Nâng cấp)",
    CurrentValue = false,
    Flag = "FullUpgradeToggle", 
    Callback = function(Value)
        _G.AutoUpgrade = Value
        if Value then
            task.spawn(function()
                local RE = game:GetService("ReplicatedStorage"):WaitForChild("Vrtx"):WaitForChild("Events"):WaitForChild("RE")
                local machineTypes = {"oilPumps", "oilDrill", "acidPump", "fuelTank", "tap"}
                while _G.AutoUpgrade do
                    if not _G.AutoUpgrade then break end -- KIỂM TRA ĐỂ DỪNG
                    if _G.DetectedID then
                        for _, mType in pairs(machineTypes) do
                            for i = 1, 10 do
                                if not _G.AutoUpgrade then break end
                                RE.upgrade:FireServer(mType, i)
                                task.wait(0.05)
                                RE.levelUp:FireServer(mType, i)
                                task.wait(0.05)
                            end
                        end
                    end
                    task.wait(3)
                end
            end)
        end
    end,
})

-- ================= TAB AFK (FIXED JUMP STOP) =================
AfkTab:CreateSection("Chế độ treo máy (AFK)")

AfkTab:CreateToggle({
    Name = "Chế độ treo máy (Nhảy liên tục)",
    CurrentValue = false,
    Flag = "JumpAFK_Toggle",
    Callback = function(Value)
        _G.JumpAFK = Value
        if Value then
            task.spawn(function()
                while _G.JumpAFK do
                    if not _G.JumpAFK then break end -- LỆNH ÉP DỪNG NHẢY
                    local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
                    task.wait(2)
                end
            end)
        end
    end,
})

