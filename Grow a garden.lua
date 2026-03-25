local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Grow a Garden |V18.4",
   LoadingTitle = "by Coconut(Blue Archive)",
   ConfigurationSaving = { Enabled = false }
})

-- ==========================================
-- BIẾN TOÀN CỤC & REMOTES
-- ==========================================
_G.AutoFarm = false
_G.GardenAnchorCFrame = nil 
_G.GardenRadius = 120       
_G.AutoFeed = false
_G.AutoBuySeed = false
_G.AutoBuyGear = false
_G.AutoBuyEgg = false
_G.ESPEnabled = false
_G.ESPCache = {}
_G.PetLookupTable = {}
_G.SelectedPets = {}
_G.SelectedSeeds = {}
_G.SelectedGears = {}
_G.SelectedEggs = {}
_G.SelectedTreat = "Medium Treat"

local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameEvents = ReplicatedStorage:WaitForChild("GameEvents")

local petRemote = GameEvents:FindFirstChild("ActivePetService")
local seedRemote = GameEvents:FindFirstChild("BuySeedStock")
local gearRemote = GameEvents:FindFirstChild("BuyGearStock")
local eggRemote = GameEvents:FindFirstChild("BuyEgg") or GameEvents:FindFirstChild("OpenEgg")
local sellRemote = GameEvents:FindFirstChild("Sell_Inventory")
local SELL_POSITION = CFrame.new(36.588, 3, 0.426)

-- ==========================================
-- TAB 1: THÚ CƯNG & TRỨNG
-- ==========================================
local PetTab = Window:CreateTab("Thú Cưng & Trứng", 4483362458)

PetTab:CreateSection("🥚 AUTO BUY EGG")
PetTab:CreateDropdown({
   Name = "Chọn loại Trứng:",
   Options = {"Basic Egg", "Rare Egg", "Epic Egg", "Legendary Egg", "Mythical Egg", "Transcendent Egg"},
   MultipleOptions = true,
   Callback = function(Options) _G.SelectedEggs = Options end,
})

PetTab:CreateToggle({
   Name = "Bật Auto Buy Eggs",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoBuyEgg = Value
      task.spawn(function()
          while _G.AutoBuyEgg do
              for _, egg in pairs(_G.SelectedEggs) do
                  if eggRemote then pcall(function() eggRemote:FireServer(egg) end) end
              end
              task.wait(2.5)
          end
      end)
   end,
})

PetTab:CreateSection("🐾 AUTO FEED PET")
PetTab:CreateDropdown({
   Name = "Chọn loại thức ăn:",
   Options = {"Medium Treat", "Large Treat", "Levelup Lollipop"},
   CurrentOption = "Medium Treat",
   Callback = function(Option) _G.SelectedTreat = Option end,
})

local PetDropdown = PetTab:CreateDropdown({
   Name = "Chọn Pet muốn cho ăn:",
   Options = {"Quét Pet trước"},
   MultipleOptions = true,
   Callback = function(Options) _G.SelectedPets = Options end,
})

PetTab:CreateButton({
   Name = "🔍 QUÉT PET TRONG VƯỜN",
   Callback = function()
       local list = {}
       _G.PetLookupTable = {}
       for _, v in pairs(_G.ESPCache) do if v then v:Destroy() end end
       _G.ESPCache = {}
       for _, obj in pairs(game.Workspace:GetDescendants()) do
           if obj:IsA("Model") and string.match(obj.Name, "%w%w%w%w%w%w%w%w%-") then
               local fullID = obj.Name 
               local species = obj:GetAttribute("Species") or "Pet"
               local displayName = species .. " [#" .. string.sub(fullID, -5) .. "]"
               _G.PetLookupTable[displayName] = fullID
               table.insert(list, displayName)
               
               local bbg = Instance.new("BillboardGui", obj)
               bbg.Adornee = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
               bbg.Size = UDim2.new(0,100,0,40)
               bbg.AlwaysOnTop = true
               bbg.Enabled = _G.ESPEnabled
               local txt = Instance.new("TextLabel", bbg)
               txt.Size = UDim2.new(1,0,1,0)
               txt.BackgroundTransparency = 1
               txt.TextColor3 = Color3.fromRGB(255, 255, 0)
               txt.Text = "🐾 ID: " .. string.sub(fullID, -5)
               table.insert(_G.ESPCache, bbg)
           end
       end
       PetDropdown:Refresh(list)
   end,
})

PetTab:CreateToggle({
   Name = "Bật Auto Feed",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFeed = Value
      task.spawn(function()
          while _G.AutoFeed do
              for _, pName in pairs(_G.SelectedPets) do
                  local id = _G.PetLookupTable[pName]
                  if id then pcall(function() petRemote:FireServer("Feed", id, _G.SelectedTreat) end) end
              end
              task.wait(1.5)
          end
      end)
   end,
})

-- ==========================================
-- TAB 2: CÀY CUỐC
-- ==========================================
local FarmTab = Window:CreateTab("Cày Cuốc", 4483362458)

FarmTab:CreateButton({
   Name = "🎯 BƯỚC 1: LƯU TÂM VƯỜN",
   Callback = function()
       local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
       if root then
           _G.GardenAnchorCFrame = root.CFrame
           Rayfield:Notify({Title = "Ys9282", Content = "Đã lưu Tâm Vườn!", Duration = 3})
       end
   end,
})

FarmTab:CreateToggle({
   Name = "🚀 BƯỚC 2: Bật Auto Farm",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      task.spawn(function()
          while _G.AutoFarm do
              local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
              if root and _G.GardenAnchorCFrame then
                  local validCrops = {}
                  for _, obj in pairs(workspace:GetDescendants()) do
                      if obj:IsA("ProximityPrompt") and (obj.ActionText == "Collect" or obj.ActionText == "Harvest") then
                          if (_G.GardenAnchorCFrame.Position - obj.Parent.Position).Magnitude <= _G.GardenRadius then
                              table.insert(validCrops, obj)
                          end
                      end
                  end

                  if #validCrops > 0 then
                      for _, obj in ipairs(validCrops) do
                          if not _G.AutoFarm then break end
                          root.CFrame = obj.Parent.CFrame * CFrame.new(0, 2, 0)
                          fireproximityprompt(obj)
                          task.wait(0.15) 
                      end
                      task.wait(1)
                      root.CFrame = SELL_POSITION
                      task.wait(0.5)
                      if sellRemote then pcall(function() sellRemote:FireServer() end) end
                      task.wait(0.5)
                      root.CFrame = _G.GardenAnchorCFrame
                  end
              end
              task.wait(3)
          end
      end)
   end,
})

-- ==========================================
-- TAB 3: CỬA HÀNG (FIXED AUTO BUY)
-- ==========================================
local ShopTab = Window:CreateTab("Cửa Hàng", 4483362458)

ShopTab:CreateSection("🛒 AUTO BUY SEEDS (FIXED)")
ShopTab:CreateDropdown({
   Name = "Chọn Hạt Giống:",
   Options = {
       "Carrot [Common]", "Tomato [Common]", "Strawberry [Uncommon]", "Blueberry [Uncommon]", 
       "Corn [Rare]", "Daffodil [Rare]", "Watermelon [Legendary]", "Pumpkin [Legendary]", 
       "Coconut [Mythical]", "Cactus [Mythical]", "Dragon Fruit [Mythical]", "Beanstalk [Mythical]",
       "Alien Apple [Transcendent]", "Zebrazinkle [Transcendent]", "Octobloom [Transcendent]"
   },
   MultipleOptions = true,
   Callback = function(Options) 
       _G.SelectedSeeds = {}
       for _, v in pairs(Options) do
           -- Tách lấy tên chính (ví dụ: "Alien Apple")
           local rawName = string.split(v, " [")[1]
           table.insert(_G.SelectedSeeds, rawName)
       end
   end,
})

ShopTab:CreateToggle({
   Name = "Bật Auto Buy Seeds",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoBuySeed = Value
      task.spawn(function()
          while _G.AutoBuySeed do
              for _, seed in pairs(_G.SelectedSeeds) do 
                  -- Gửi lệnh chuẩn theo format: ("Shop", "Alien Apple Seed")
                  pcall(function() seedRemote:FireServer("Shop", seed .. " Seed") end)
              end
              task.wait(3)
          end
      end)
   end,
})

ShopTab:CreateSection("🛡️ AUTO BUY GEAR (ĐỦ MỤC)")
ShopTab:CreateDropdown({
   Name = "Chọn Trang Bị:",
   Options = {
       "Watering Can", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", 
       "Master Sprinkler", "Grandmaster Sprinkler", "Supreme Sprinkler", 
       "Harvest Tool", "Trowel", "Recall Wrench", "Cleaning Spray", 
       "Pet Lead", "Favorite Tool", "Trading Ticket"
   },
   MultipleOptions = true,
   Callback = function(Options) _G.SelectedGears = Options end,
})

ShopTab:CreateToggle({
   Name = "Bật Auto Buy Gears",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoBuyGear = Value
      task.spawn(function()
          while _G.AutoBuyGear do
              for _, gear in pairs(_G.SelectedGears) do 
                  -- Gear chỉ cần tên vật phẩm
                  pcall(function() gearRemote:FireServer(gear) end) 
              end
              task.wait(4)
          end
      end)
   end,
})

-- ANTI-AFK
local VU = game:GetService("VirtualUser")
player.Idled:Connect(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end)

Rayfield:Notify({Title = "Ys9282 V18.4", Content = "Chúc may mắn lần sau!", Duration = 5})

