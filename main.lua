
-- Tải thư viện UI (Kavo Library)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Yomo-blue-archive/Blux-archive/refs/heads/main/main.lua"))()
local Window = Library.CreateLib("Ys9282 Hub", "DarkScene")

-- Tạo một Tab tên là "Main"
local Tab = Window:NewTab("Tính năng")
local Section = Tab:NewSection("Chỉnh thông số nhân vật")

-- Tạo thanh trượt (Slider) để chỉnh tốc độ
Section:NewSlider("Tốc độ chạy", "Kéo để chỉnh tốc độ của bạn", 500, 16, function(s) -- 500 là tối đa, 16 là mặc định
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

-- Tạo thanh trượt (Slider) để chỉnh độ nhảy
Section:NewSlider("Độ nhảy cao", "Kéo để nhảy cao hơn", 500, 50, function(s)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
end)

-- Tạo nút bấm để Reset về mặc định
Section:NewButton("Reset thông số", "Đưa tốc độ và nhảy về bình thường", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
end)
