local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local KeyWindow = Rayfield:CreateWindow({
   Name = "BQL COCONUT | Key System",
   LoadingTitle = "Checking License...",
   ConfigurationSaving = { Enabled = false }
})

local KeyTab = KeyWindow:CreateTab("Verification", 4483362458)

local CorrectKey = "" 
local KeyURL = "" 
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

           loadstring(game:HttpGet("https://raw.githubusercontent.com/Yomo-blue-archive/Blux-archive/refs/heads/main/Grow%20a%20garden%20security"))()
       else
           Rayfield:Notify({Title = "Failed Key!", Content = "Vui lòng kiểm tra lại hoặc lấy key mới.", Duration = 5})
       end
   end,
})
