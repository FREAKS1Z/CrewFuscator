--[[

it's simple library but i can make it better soon :)

example

local CoreGui = game:GetService("StarterGui")

CoreGui:SetCore("SendNotification", {
    Title = "Script Made By",
    Text = "Shizoscript & ClickManteam",
    Icon = "rbxassetid://14307252060",
    Duration = 2,
})

local GUILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/FREAKS1Z/CrewFuscator/refs/heads/main/Back-ups-lib-shizo/Dedskie.lua"))()

local win = GUILib:CreateWindow({
    title = "My Script",
    credits = "Made by Me" -- you can use this will be on bottom of the gui
})

win:AddLabel({
    text = "Welcome to my script!"
})

win:AddButton({
    text = "Click Me",
    callback = function()
        print("Button was clicked!")
    end
})

win:AddToggle({
    text = "ESP",
    default = false,
    callback = function(state)
        if state then
            print("ESP is now ON")
        else
            print("ESP is now OFF")
        end
    end
})

win:AddToggle({
    text = "Speed Boost",
    default = true,
    callback = function(state)
        local plr = game.Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            if state then
                plr.Character.Humanoid.WalkSpeed = 50
            else
                plr.Character.Humanoid.WalkSpeed = 16
            end
        end
    end
})

win:AddButton({
    text = "Destroy GUI",
    callback = function()
        win.gui:Destroy()
    end
})




-- ]]

local GUILib = {}
local TweenService = game:GetService("TweenService")

local colors = {
    primary = Color3.fromRGB(40, 80, 150),
    secondary = Color3.fromRGB(20, 40, 80),
    button = Color3.fromRGB(60, 120, 200),
    toggleOff = Color3.fromRGB(200, 50, 50),
    toggleOn = Color3.fromRGB(50, 200, 50),
    text = Color3.fromRGB(255, 255, 255)
}
--[[ Sounds ]]--
local customFont = Font.new("rbxassetid://12187368843") -- Text Custom Front
local buttonIcon = "rbxassetid://14307252060" -- Buttom Icon Click
local buttonClickSound = "rbxassetid://9090993751" -- Button Click Sound
local toggleClickSound = "rbxassetid://9117028601" -- Toggle Click sound 
--[[ end of siund ]]--
function GUILib:CreateWindow(config)
    local Players = game:GetService("Players")
    local plr = Players.LocalPlayer
    local pGui = plr:WaitForChild("PlayerGui")

    config = config or {}
    config.title = config.title or "My GUI"

    local gui = Instance.new("ScreenGui")
    gui.Name = config.title .. "GUI"
    gui.ResetOnSpawn = false
    gui.Parent = pGui

    local box = Instance.new("Frame")
    box.Name = "MainBox"
    box.Size = UDim2.new(0, 160, 0, 140)
    box.Position = UDim2.new(0.5, -80, 0.5, -70)
    box.BackgroundColor3 = colors.primary
    box.BorderSizePixel = 2
    box.BorderColor3 = colors.secondary
    box.Active = true
    box.Draggable = true
    box.Parent = gui

    local hdr = Instance.new("Frame")
    hdr.Size = UDim2.new(1, 0, 0, 25)
    hdr.BackgroundColor3 = colors.secondary
    hdr.BorderSizePixel = 0
    hdr.Parent = box

    local ttl = Instance.new("TextLabel")
    ttl.Size = UDim2.new(0.7, 0, 1, 0)
    ttl.Position = UDim2.new(0, 5, 0, 0)
    ttl.BackgroundTransparency = 1
    ttl.Text = config.title
    ttl.TextColor3 = colors.text
    ttl.TextSize = 12
    ttl.FontFace = customFont
    ttl.TextXAlignment = Enum.TextXAlignment.Left
    ttl.Parent = hdr

    local tglBtn = Instance.new("TextButton")
    tglBtn.Size = UDim2.new(0, 20, 0, 20)
    tglBtn.Position = UDim2.new(1, -23, 0, 2.5)
    tglBtn.BackgroundColor3 = colors.button
    tglBtn.Text = "-"
    tglBtn.TextColor3 = colors.text
    tglBtn.TextSize = 14
    tglBtn.FontFace = customFont
    tglBtn.BorderSizePixel = 0
    tglBtn.Parent = hdr

    local cnt = Instance.new("Frame")
    cnt.Name = "Content"
    cnt.Size = UDim2.new(1, -8, 1, -35)
    cnt.Position = UDim2.new(0, 4, 0, 28)
    cnt.BackgroundTransparency = 1
    cnt.Parent = box

    local creds = Instance.new("TextLabel")
    creds.Size = UDim2.new(1, 0, 0, 16)
    creds.Position = UDim2.new(0, 0, 1, -18)
    creds.BackgroundTransparency = 1
    creds.Text = config.credits or "Made by YourName"
    creds.TextColor3 = Color3.fromRGB(200, 200, 200)
    creds.TextSize = 9
    creds.FontFace = customFont
    creds.Parent = box

    local open = true
    local curH = 140

    tglBtn.MouseButton1Click:Connect(function()
        open = not open
        local curPos = box.Position
        if open then
            box.Size = UDim2.new(0, 160, 0, curH)
            box.Position = curPos
            tglBtn.Text = "-"
            cnt.Visible = true
            creds.Visible = true
        else
            box.Size = UDim2.new(0, 160, 0, 25)
            box.Position = curPos
            tglBtn.Text = "+"
            cnt.Visible = false
            creds.Visible = false
        end
    end)

    local win = {
        gui = gui,
        box = box,
        content = cnt,
        credits = creds,
        _yOffset = 0,
        _minHeight = 140
    }

    function win:_updateSize()
        local cntH = self._yOffset + 35 + 18
        local newH = math.max(self._minHeight, cntH)
        local curPos = self.box.Position
        self.box.Size = UDim2.new(0, 160, 0, newH)
        self.box.Position = curPos
    end

    function win:AddButton(btnCfg)
        btnCfg = btnCfg or {}
        btnCfg.text = btnCfg.text or "Button"
        btnCfg.callback = btnCfg.callback or function() print("Button clicked!") end

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 25)
        btn.Position = UDim2.new(0, 0, 0, self._yOffset)
        btn.BackgroundColor3 = colors.button
        btn.Text = ""
        btn.BorderSizePixel = 0
        btn.Parent = self.content

        local snd = Instance.new("Sound")
        snd.SoundId = buttonClickSound
        snd.Volume = 0.5
        snd.Parent = btn

        local btnTxt = Instance.new("TextLabel")
        btnTxt.Size = UDim2.new(1, -26, 1, 0)
        btnTxt.Position = UDim2.new(0, 4, 0, 0)
        btnTxt.BackgroundTransparency = 1
        btnTxt.Text = btnCfg.text
        btnTxt.TextColor3 = colors.text
        btnTxt.TextSize = 11
        btnTxt.FontFace = customFont
        btnTxt.TextXAlignment = Enum.TextXAlignment.Left
        btnTxt.Parent = btn

        local ico = Instance.new("ImageLabel")
        ico.Size = UDim2.new(0, 18, 0, 18)
        ico.Position = UDim2.new(1, -22, 0.5, -9)
        ico.BackgroundTransparency = 1
        ico.Image = buttonIcon
        ico.ScaleType = Enum.ScaleType.Fit
        ico.Parent = btn

        btn.MouseButton1Click:Connect(function()
            snd:Play()
            btnCfg.callback()
        end)

        self._yOffset = self._yOffset + 30
        self:_updateSize()
        curH = self.box.Size.Y.Offset
        return btn
    end

    function win:AddToggle(tglCfg)
        tglCfg = tglCfg or {}
        tglCfg.text = tglCfg.text or "Toggle"
        tglCfg.default = tglCfg.default or false
        tglCfg.callback = tglCfg.callback or function(state) print("Toggle:", state) end

        local tglBox = Instance.new("Frame")
        tglBox.Size = UDim2.new(1, 0, 0, 25)
        tglBox.Position = UDim2.new(0, 0, 0, self._yOffset)
        tglBox.BackgroundColor3 = Color3.fromRGB(30, 60, 120)
        tglBox.BorderSizePixel = 0
        tglBox.Parent = self.content

        local tglLbl = Instance.new("TextLabel")
        tglLbl.Size = UDim2.new(0.55, 0, 1, 0)
        tglLbl.Position = UDim2.new(0, 4, 0, 0)
        tglLbl.BackgroundTransparency = 1
        tglLbl.Text = tglCfg.text
        tglLbl.TextColor3 = colors.text
        tglLbl.TextSize = 11
        tglLbl.FontFace = customFont
        tglLbl.TextXAlignment = Enum.TextXAlignment.Left
        tglLbl.Parent = tglBox

        local tgl = Instance.new("TextButton")
        tgl.Size = UDim2.new(0, 32, 0, 18)
        tgl.Position = UDim2.new(1, -35, 0.5, -9)
        tgl.BackgroundColor3 = tglCfg.default and colors.toggleOn or colors.toggleOff
        tgl.Text = tglCfg.default and "ON" or "OFF"
        tgl.TextColor3 = colors.text
        tgl.TextSize = 9
        tgl.FontFace = customFont
        tgl.BorderSizePixel = 0
        tgl.Parent = tglBox

        local snd = Instance.new("Sound")
        snd.SoundId = toggleClickSound
        snd.Volume = 0.5
        snd.Parent = tgl

        local toggled = tglCfg.default

        tgl.MouseButton1Click:Connect(function()
            snd:Play()
            toggled = not toggled
            if toggled then
                tgl.BackgroundColor3 = colors.toggleOn
                tgl.Text = "ON"
            else
                tgl.BackgroundColor3 = colors.toggleOff
                tgl.Text = "OFF"
            end
            tglCfg.callback(toggled)
        end)

        self._yOffset = self._yOffset + 30
        self:_updateSize()
        curH = self.box.Size.Y.Offset

        return {
            toggle = tgl,
            setState = function(state)
                toggled = state
                tgl.BackgroundColor3 = state and colors.toggleOn or colors.toggleOff
                tgl.Text = state and "ON" or "OFF"
            end,
            getState = function()
                return toggled
            end
        }
    end

    function win:AddLabel(lblCfg)
        lblCfg = lblCfg or {}
        lblCfg.text = lblCfg.text or "Label"

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 20)
        lbl.Position = UDim2.new(0, 0, 0, self._yOffset)
        lbl.BackgroundTransparency = 1
        lbl.Text = lblCfg.text
        lbl.TextColor3 = colors.text
        lbl.TextSize = 11
        lbl.FontFace = customFont
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = self.content

        self._yOffset = self._yOffset + 25
        self:_updateSize()
        curH = self.box.Size.Y.Offset
        return lbl
    end

    function win:AddCredits(credCfg)
        credCfg = credCfg or {}
        credCfg.text = credCfg.text or "Made by YourName"

local credLbl = Instance.new("TextLabel")
credLbl.Size = UDim2.new(1, 0, 0, 20)
credLbl.Position = UDim2.new(0, 0, 0, self._yOffset)
credLbl.BackgroundTransparency = 1
credLbl.Text = credCfg.text
credLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
credLbl.TextSize = 9
credLbl.FontFace = customFont
credLbl.TextXAlignment = Enum.TextXAlignment.Center
credLbl.Parent = self.content

self._yOffset = self._yOffset + 25
self:_updateSize()
curH = self.box.Size.Y.Offset
return credLbl
end

return win
end

return GUILib
