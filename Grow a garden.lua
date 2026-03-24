local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Grow a Garden | Ys9282 V16.5 FINAL",
   LoadingTitle = "Đang cấu hình Gear & Transcendent Seeds...",
   ConfigurationSaving = { Enabled = false }
})

-- ==========================================
-- BIẾN TOÀN CỤC
-- ==========================================
_G.AutoFarm = false
_G.AutoFeed = false
_G.AutoBuySeed = false
_G.AutoBuyGear = false
_G.ESPEnabled = false
_G.SelectedPets = {}
_G.SelectedSeeds = {}
_G.SelectedGears = {}
_G.SelectedTreat = "Medium Treat"
_G.PetLookupTable = {}
_G.ESPCache = {}

local player = game.Players.LocalPlayer
local petRemote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("ActivePetService")
local seedRemote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuySeedStock")
local gearRemote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyGearStock")
local sellRemote = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Sell_Inventory")

-- ==========================================
-- TAB 1: THÚ CƯNG
-- ==========================================
local PetTab = Window:CreateTab("Thú Cưng", 4483362458)

PetTab:CreateToggle({
   Name = "Bật/Tắt ESP Pet",
   CurrentValue = false,
   Callback = function(Value)
      _G.ESPEnabled = Value
      for _, bbg in pairs(_G.ESPCache) do if bbg then bbg.Enabled = _G.ESPEnabled end end
   end,
})

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
   Name = "Auto Feed Pet",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFeed = Value
      task.spawn(function()
          while _G.AutoFeed do
              for _, pName in pairs(_G.SelectedPets) do
                  local id = _G.PetLookupTable[pName]
                  if id then pcall(function() petRemote:FireServer("Feed", id, _G.SelectedTreat) end) end
              end
              task.wait(1)
          end
      end)
   end,
})

-- ==========================================
-- TAB 2: CÀY CUỐC (15S BÁN 1 LẦN)
-- ==========================================
local FarmTab = Window:CreateTab("Cày Cuốc", 4483362458)

FarmTab:CreateToggle({
   Name = "Bật Auto Farm & Auto Sell 15s",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      -- Vòng lặp bán hàng (Chính xác 15s/lần)
      task.spawn(function()
          local sellPos = CFrame.new(36.588191986083984, 2.999999761581421, 0.426768958568573)
          while _G.AutoFarm do
              task.wait(15)
              if _G.AutoFarm then
                  local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                  if root then
                      local oldPos = root.CFrame
                      root.CFrame = sellPos
                      task.wait(0.1)
                      pcall(function() sellRemote:FireServer() end)
                      task.wait(0.6)
                      root.CFrame = oldPos
                  end
              end
          end
      end)
      -- Vòng lặp gom cây
      task.spawn(function()
          while _G.AutoFarm do
              local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
              if root then
                  for _, obj in pairs(game.Workspace:GetDescendants()) do
                      if not _G.AutoFarm then break end
                      if obj:IsA("ProximityPrompt") and (obj.ActionText == "Collect" or obj.ActionText == "Harvest") then
                          if (root.Position - obj.Parent.Position).Magnitude < 50 then
                              root.CFrame = obj.Parent.CFrame * CFrame.new(0, 2, 0)
                              fireproximityprompt(obj)
                              task.wait(0.15)
                          end
                      end
                  end
              end
              task.wait(0.3)
          end
      end)
   end,
})

-- ==========================================
-- TAB 3: CỬA HÀNG (ALIEN APPLE ĐÃ SỬA)
-- ==========================================
local ShopTab = Window:CreateTab("Cửa Hàng", 4483362458)

ShopTab:CreateSection("🛒 AUTO BUY HẠT GIỐNG")
ShopTab:CreateDropdown({
   Name = "Chọn Hạt Giống:",
   Options = {
       "Carrot [Common]", "Tomato [Common]", "Strawberry [Uncommon]", "Blueberry [Uncommon]", 
       "Corn [Rare]", "Daffodil [Rare]", "Watermelon [Legendary]", "Pumpkin [Legendary]", 
       "Bamboo [Legendary]", "Coconut [Mythical]", "Cactus [Mythical]", "Dragon Fruit [Mythical]", 
       "Mango [Mythical]", "Grape [Divine]", "Mushroom [Divine]", "Pepper [Divine]", 
       "Cacao [Divine]", "Sunflower [Divine]", "Beanstalk [Prismatic]", "Ember Lily [Prismatic]", 
       "Sugar Apple [Prismatic]", "Burning Bud [Prismatic]", "Giant Pinecone [Prismatic]", 
       "Elder Strawberry [Prismatic]", "Romanesco [Prismatic]", "Crimson Thorn [Transcendent]", 
       "Zebrazinkle [Transcendent]", "Octobloom [Transcendent]", "Alien Apple [Transcendent]"
   },
   MultipleOptions = true,
   Callback = function(Options) 
       _G.SelectedSeeds = {}
       for _, v in pairs(Options) do table.insert(_G.SelectedSeeds, string.split(v, " [")[1]) end
   end,
})

ShopTab:CreateToggle({
   Name = "Auto Buy Seeds",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoBuySeed = Value
      task.spawn(function()
          while _G.AutoBuySeed do
              for _, s in pairs(_G.SelectedSeeds) do pcall(function() seedRemote:FireServer("Shop", s .. " Seed") end) end
              task.wait(2)
          end
      end)
   end,
})

ShopTab:CreateSection("🛡️ AUTO BUY TRANG BỊ")
ShopTab:CreateDropdown({
   Name = "Chọn Gear:",
   Options = {
       "Watering Can", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", 
       "Master Sprinkler", "Grandmaster Sprinkler", "Harvest Tool", "Trowel", 
       "Recall Wrench", "Cleaning Spray", "Pet Lead", "Favorite Tool", 
       "Medium Toy", "Medium Treat", "Levelup Lollipop", "Trading Ticket"
   },
   MultipleOptions = true,
   Callback = function(Options) _G.SelectedGears = Options end,
})

ShopTab:CreateToggle({
   Name = "Auto Buy Gears",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoBuyGear = Value
      task.spawn(function()
          while _G.AutoBuyGear do
              for _, g in pairs(_G.SelectedGears) do pcall(function() gearRemote:FireServer(g) end) end
              task.wait(3.5)
          end
      end)
   end,
})

-- ANTI-AFK
local VU = game:GetService("VirtualUser")
player.Idled:Connect(function() VU:CaptureController() VU:ClickButton2(Vector2.new()) end)

Rayfield:Notify({Title = "Ys9282 V16.5", Content = "Alien Apple [Trans] & Full Gear đã sẵn sàng!", Duration = 5})

