local FarmTab = Window:CreateTab("Cày Cuốc", 4483362458)

FarmTab:CreateSection("⚡ CHẾ ĐỘ CÀY SIÊU TỐC")

FarmTab:CreateToggle({
   Name = "Auto Farm (Fast) - Lượm & Bán",
   CurrentValue = false,
   Callback = function(v) 
      _G.AutoFarmFast = v 
      task.spawn(function()
          while _G.AutoFarmFast do
              -- Logic farm của V15 (Quét liên tục tại chỗ)
              for _, obj in pairs(game.Workspace:GetDescendants()) do
                  if not _G.AutoFarmFast then break end
                  if obj:IsA("ProximityPrompt") and obj.ActionText == "Collect" then
                      fireproximityprompt(obj)
                  end
              end
              task.wait(0.5)
          end
      end)
   end,
})

FarmTab:CreateSection("🚀 CHẾ ĐỘ DỊCH CHUYỂN")

FarmTab:CreateToggle({
   Name = "Auto Farm (Teleport) - Bán 15s/lần",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoFarmTP = Value
      task.spawn(function()
          local sellPos = CFrame.new(36.588191986083984, 2.999999761581421, 0.426768958568573)
          while _G.AutoFarmTP do
              task.wait(15)
              if _G.AutoFarmTP then
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
   end,
})
