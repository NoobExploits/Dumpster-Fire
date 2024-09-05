local espEnabled = false
local checkingThread = nil

local function toggleESP(enabled)
    local normal = workspace:FindFirstChild("Normal")
    if normal then
        for _, gunDrop in ipairs(normal:GetChildren()) do
            if gunDrop.Name == "GunDrop" then
                local highlight = gunDrop:FindFirstChild("Highlight")
                if enabled and not highlight then
                    local blah = Instance.new("Highlight", gunDrop)
                    blah.FillColor = Color3.fromRGB(7, 0, 255)
                    blah.OutlineTransparency = 0.75
                elseif not enabled and highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end

local function checkForNewGunDrops()
    while espEnabled do
        local normal = workspace:FindFirstChild("Normal")
        if normal then
            for _, gunDrop in ipairs(normal:GetChildren()) do
                if gunDrop.Name == "GunDrop" and not gunDrop:FindFirstChild("Highlight") then
                    local blah = Instance.new("Highlight", gunDrop)
                    blah.FillColor = Color3.fromRGB(7, 0, 255)
                    blah.OutlineTransparency = 0.75
                end
            end
        end
        task.wait(0.5)
    end
end

local Fluent = loadstring(game:HttpGet(
    "https://github.com/mr-suno/Fluent/releases/latest/download/main.lua"
))()

local Window = Fluent:CreateWindow({
    Title = "Impact Hub",
    SubTitle = "youtube.com/@NoobExploits",
    TabWidth = 180,
    Size = UDim2.fromOffset(625, 560 / 2),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Player = Window:AddTab({
        Title = "Player",
        Icon = "user"
    }),
    Info = Window:AddTab({
        Title = "Info",
        Icon = "info"
    })
}

local GunESPTgl = Tabs.Player:AddToggle("23wersdfg", {
    Title = "Gun ESP",
    Description = "Allows you to see the dropped gun through walls.",
    Default = false
})

Tabs.Info:AddParagraph({
    Title   = "Credit to",
    Content = "Noob Exploits (me, programmar)\nSuno (for making starry and sitting in a call with me for 18 hours straight)\nClaude AI (helping me fix a bug 😭)",
 })

 Tabs.Info:AddButton({
    Title = "Discord Server",
    Description = "Copys server invite to your clipboard",
    Callback = function()
        setclipboard("https://discord.gg/S4b4gSMpmS")
        toclipboard("https://discord.gg/S4b4gSMpmS")
    end
})

Tabs.Info:AddButton({
    Title = "Promote Starry",
    Description = "Brag to everyone about your amazing hacks.",
    Callback = function()
        game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("⭐ Starry, the #1 Murder Mystery 2 script providing many features like Kill All, Auto Grab Gun, Coin & EXP farming, Extra Life & more!")
    end
})

GunESPTgl:OnChanged(function(bool)
    espEnabled = bool
    toggleESP(espEnabled)
    if espEnabled then
        if checkingThread then
            task.cancel(checkingThread)
        end
        checkingThread = task.spawn(checkForNewGunDrops)
    else
        if checkingThread then
            task.cancel(checkingThread)
            checkingThread = nil
        end
    end
end)

Window:SelectTab(1)

workspace.ChildAdded:Connect(function(child)
    if child.Name == "Normal" and espEnabled then
        toggleESP(true)
    end
end)
