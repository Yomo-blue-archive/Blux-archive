-- Khai báo biến tốc độ (Bạn có thể thay đổi số 100 thành số khác)
local speedValue = 100

-- Thông báo cho người dùng biết script đã chạy
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Ys9282 Speed Hack",
    Text = "Tốc độ hiện tại: " .. speedValue,
    Duration = 5
})

-- Vòng lặp để giữ tốc độ luôn ổn định (tránh bị game reset)
while true do
    -- Kiểm tra nếu nhân vật tồn tại
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        -- Chỉnh tốc độ chạy
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
    end
    task.wait(1) -- Đợi 1 giây rồi lặp lại
end

