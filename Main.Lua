--
-- Emden Roblox Cheat for Matcha made By 6Syrox6
-- 

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer

_G.ESPWanted = true
_G.ESPCops = true

_G.ColorCop = Color3.new(0,0,1.228)
_G.ColorWanted = Color3.new(1,0,0)

local circles = {}

UI.AddTab("EMDEN", function(tab)
        local sec = tab:Section("Settings", "Left")

        sec:Toggle("copesp", "Cop ESP", true, function(state)  
                _G.ESPCops = state         
        end)
        sec:ColorPicker("copcolor", 0,0,1,1, function(color)
                _G.ColorCop = color
        end)


        sec:Toggle("wantedesp", "Wanted ESP", true, function(state)
                _G.ESPWanted = state
        end)

        sec:ColorPicker("Wantedcolor", 1,0,0,1, function(color)
                _G.ColorWanted = color
        end)
end)

local function isWanted(player)
        local wantedlevel = player:GetAttribute("IsWanted")
        if wantedlevel == true then
        return true
    end
    return false
end

local function isCop(player)
        local job = player:GetAttribute("Job")
        if job == 1 or job == 8 then
        return true
    end
    return false
end

local function getHeadPos(player)
    local char = player.Character
    if not char then return nil end
    local head = char:FindFirstChild("Head")
    if not head then return nil end
    return head.Position + Vector3.new(0, -5, 0)
end

local function getDist(a, b)
    local dx = a.X - b.X
    local dy = a.Y - b.Y
    local dz = a.Z - b.Z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

spawn(function()
    while true do
        task.wait(1 / 30)
        local camera = Workspace.CurrentCamera
        if not camera then continue end

        -- Step 1: remove every circle from last frame
        for player, c in pairs(circles) do
            c:Remove()
            circles[player] = nil
        end

        -- Step 2: draw fresh circles
        for _, player in ipairs(Players:GetPlayers()) do
            if player == localPlayer then continue end
            
            local wanted = isWanted(player)
            local cop = isCop(player)

            local showPlayer = false    

            if wanted and _G.ESPWanted then
                showPlayer = true
            elseif cop and _G.ESPCops then    
                showPlayer = true
            end

            if not showPlayer then continue end
            --if not wanted and not cop then continue end

            local worldPos = getHeadPos(player)
            if not worldPos then continue end

            local screenPos, onScreen
            if type(WorldToScreen) == "function" then
                screenPos, onScreen = WorldToScreen(worldPos)
            else
                local vec, on = camera:WorldToViewportPoint(worldPos)
                screenPos = Vector2.new(vec.X, vec.Y)
                onScreen = on
            end
            
            if not onScreen then continue end

            local dist = getDist(worldPos, camera.Position)
            local radius = math.clamp(400 / dist, 3, 7)

            local c = Drawing.new("Circle")
            
            if wanted then
                c.Color = _G.ColorWanted
            else
                c.Color = _G.ColorCop
            end
            
            c.Filled = true
            c.Radius = radius
            c.NumSides = 32
            c.Thickness = 1
            c.Transparency = 1
            c.Position = screenPos
            c.Visible = true
            c.ZIndex = 5

            circles[player] = c
        end
    end
end)

if type(notify) == "function" then
    notify("Emden Cheat V1.1", "Running", 3)
end
