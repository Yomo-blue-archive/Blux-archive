local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local KeyWindow = Rayfield:CreateWindow({
   Name = "BQL COCONUT | Key System",
   LoadingTitle = "Checking License...",
   ConfigurationSaving = { Enabled = false }
})

local KeyTab = KeyWindow:CreateTab("Verification", 4483362458)

-- CẤU HÌNH KEY CỦA BẠN
local CorrectKey = "COCONUT_FREE_2026" -- Bạn có thể đổi key mỗi ngày ở đây
local KeyURL = "" -- Link Discord hoặc nơi lấy key

KeyTab:CreateSection("GET KEY HERE")

KeyTab:CreateButton({
   Name = "COPY LINK GET KEY",
   Callback = function()
       setclipboard(KeyURL)
       Rayfield:Notify({Title = "Success", Content = "", Duration = 5})
   end,
})

KeyTab:CreateSection("ENTER KEY")

KeyTab:CreateInput({
   Name = "Input Key:",
   PlaceholderText = "Paste key here...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
       if Text == CorrectKey then
           Rayfield:Notify({Title = "!", Content = "Load...", Duration = 3})
           task.wait(2)
           KeyWindow:Destroy()
           
           -- CHỈ KHI ĐÚNG KEY MỚI CHẠY MÃ CHÍNH
           loadstring(game:HttpGet("https://raw.githubusercontent.com/Yomo-blue-archive/Blux-archive/refs/heads/main/Grow-a-garden.lua"))()
       else
           Rayfield:Notify({Title = "Failed Key!", Content = "Vui lòng kiểm tra lại hoặc lấy key mới.", Duration = 5})
       end
   end,
})
