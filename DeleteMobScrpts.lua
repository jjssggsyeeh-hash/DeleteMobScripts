--================================================================================
-- CONFIGURAÇÕES E LOADER
--================================================================================

local fileName = "DeleteMobScrpts.lua"
local url = "https://raw.githubusercontent.com/jjssggsyeeh-hash/DeleteMobScripts/f74aab4c587f84c413aa4e1af3f8f5fcf680c857/DeleteMobScrpts.lua"

if isfile and isfile(fileName) then
    print("DeleteMob: Rodando script salvo localmente!")
    -- Não vamos executar aqui, apenas carregar se necessário. O resto do script é o próprio código.
else
    print("DeleteMob: Baixando script do GitHub e salvando localmente...")
    pcall(function()
        local scriptContent = game:HttpGet(url)
        writefile(fileName, scriptContent)
    end)
end

-- Tabela de configurações central
local DeleteMob = {
    Aimbot = {
        Enabled = false,
        TeamCheck = false,
        WallCheck = false,
        ShowFov = false,
        Fov = 350,
        Smoothing = 0,
        AimPart = "Head",
        Thickness = 1,
        FovFillColor = Color3.fromRGB(100,0,100),
        FovColor = Color3.fromRGB(100,0,100),
        FovFillTransparency = 1,
        FovTransparency = 0,
        IsAimKeyDown = false
    },
    ESP = {
        Box = {
            Enabled = false,
            Name = false,
            Distance = false,
            Health = false,
            TeamCheck = false,
            HealthType = "Bar", -- Opções: "Bar", "Text", "Both"
            BoxColor = Color3.fromRGB(75,0,10)
        },
        Outlines = {
            Enabled = false,
            TeamCheck = false,
            FillColor = Color3.fromRGB(100, 0, 100),
            FillTransparency = 0,
            OutlineColor = Color3.fromRGB(255,255,255),
            OutlineTransparency = 0
        },
        Tracers = {
            Enabled = false,
            TeamCheck = false,
            TeamColor = false,
            Color = Color3.fromRGB(75,0,10)
        }
    }
}


--================================================================================
-- SERVIÇOS E VARIÁVEIS GLOBAIS
--================================================================================

local PLAYER = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CurrentCam = game:GetService("Workspace").CurrentCamera

--================================================================================
-- CRIAÇÃO DA INTERFACE GRÁFICA (GUI) - [!] TUDO FOI UNIFICADO AQUI
--================================================================================

-- 1. ScreenGui Principal
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "CheatEngineDeleteMob"
mainGui.Parent = PLAYER:WaitForChild("PlayerGui")
mainGui.Enabled = true
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mainGui.ResetOnSpawn = false

-- 2. Janela Principal (Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "DeleteMobF"
mainFrame.Parent = mainGui
mainFrame.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
mainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -175) -- Centralizado
mainFrame.Size = UDim2.new(0, 600, 0, 350)
mainFrame.ZIndex = 10
mainFrame.Draggable = true
mainFrame.Active = true
mainFrame.Visible = true -- A visibilidade agora é controlada por mainGui.Enabled

-- 3. Título e Cabeçalho
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Parent = mainFrame
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0.05, 0, 0.03, 0)
titleLabel.Size = UDim2.new(0, 300, 0, 40)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "DeleteMob | Cheat Engine"
titleLabel.TextColor3 = Color3.fromRGB(17, 223, 255)
titleLabel.TextSize = 22
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local discordLink = Instance.new("TextLabel")
discordLink.Name = "DiscordLink"
discordLink.Parent = mainFrame
discordLink.BackgroundTransparency = 1
discordLink.Position = UDim2.new(1, -210, 0.03, 0)
discordLink.Size = UDim2.new(0, 200, 0, 25)
discordLink.Font = Enum.Font.Roboto
discordLink.Text = "discord.gg/FsApQ7YNTq"
discordLink.TextColor3 = Color3.fromRGB(255, 255, 255)
discordLink.TextSize = 14
discordLink.TextXAlignment = Enum.TextXAlignment.Right

local lineSeparator = Instance.new("Frame")
lineSeparator.Name = "Line"
lineSeparator.Parent = mainFrame
lineSeparator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
lineSeparator.Position = UDim2.new(0, 0, 0.15, 0)
lineSeparator.Size = UDim2.new(1, 0, 0, 2)

-- 4. Botão de Abrir/Fechar
local openCloseButtonFrame = Instance.new("Frame")
openCloseButtonFrame.Name = "OpenCloseFrame"
openCloseButtonFrame.Parent = mainGui
openCloseButtonFrame.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
openCloseButtonFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
openCloseButtonFrame.Position = UDim2.new(0.5, -75, 0.05, 0)
openCloseButtonFrame.Size = UDim2.new(0, 150, 0, 40)
openCloseButtonFrame.ZIndex = 12
openCloseButtonFrame.Draggable = true
openCloseButtonFrame.Active = true

local openCloseButton = Instance.new("TextButton")
openCloseButton.Parent = openCloseButtonFrame
openCloseButton.BackgroundColor3 = Color3.fromRGB(49, 49, 49)
openCloseButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
openCloseButton.Size = UDim2.new(1, 0, 1, 0)
openCloseButton.Font = Enum.Font.GothamBold
openCloseButton.Text = "Abrir / Fechar"
openCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openCloseButton.TextSize = 18

-- 5. Seção de Aimbot
local aimbotSectionFrame = Instance.new("Frame")
aimbotSectionFrame.Name = "AimBotSection"
aimbotSectionFrame.Parent = mainFrame
aimbotSectionFrame.BackgroundTransparency = 1
aimbotSectionFrame.Position = UDim2.new(0.05, 0, 0.20, 0)
aimbotSectionFrame.Size = UDim2.new(0, 110, 0, 250)

local aimbotListLayout = Instance.new("UIListLayout")
aimbotListLayout.Parent = aimbotSectionFrame
aimbotListLayout.SortOrder = Enum.SortOrder.LayoutOrder
aimbotListLayout.Padding = UDim.new(0, 6)

local function createMenuButton(parent, name, text)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = parent
    button.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
    button.BorderColor3 = Color3.fromRGB(255, 255, 255)
    button.Size = UDim2.new(1, 0, 0, 32)
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 17
    return button
end

local aimbotEnableButton = createMenuButton(aimbotSectionFrame, "AimbotEnable", "Enable")
local aimbotWallCheckButton = createMenuButton(aimbotSectionFrame, "WallCheck", "Wall Check")
local aimbotTeamCheckButton = createMenuButton(aimbotSectionFrame, "TeamCheck", "Team Check")
local aimbotShowFovButton = createMenuButton(aimbotSectionFrame, "ShowFov", "Show Fov")
local aimbotPartButton = createMenuButton(aimbotSectionFrame, "AimPart", "Aim: Head")


-- 6. FOV Circle (para o aimbot)
local fovFrame = Instance.new("Frame")
fovFrame.Name = "FOVFFrame"
fovFrame.Parent = mainGui
fovFrame.BackgroundTransparency = 1
fovFrame.Visible = false
fovFrame.ZIndex = 20
fovFrame.ClipsDescendants = true

local fovCircle = Instance.new("ImageLabel")
fovCircle.Parent = fovFrame
fovCircle.BackgroundTransparency = 1
fovCircle.Image = "rbxassetid://10345293292" -- Círculo
fovCircle.ImageColor3 = DeleteMob.Aimbot.FovColor
fovCircle.ImageTransparency = DeleteMob.Aimbot.FovTransparency
fovCircle.ScaleType = Enum.ScaleType.Fit
fovCircle.Size = UDim2.new(1, 0, 1, 0)


--================================================================================
-- LÓGICA E FUNÇÕES
--================================================================================

-- Função para alternar a cor dos botões (ON/OFF)
local function toggleButtonColor(button, isActive)
    if isActive then
        button.BackgroundColor3 = Color3.fromRGB(2, 54, 8) -- Verde (Ligado)
    else
        button.BackgroundColor3 = Color3.fromRGB(52, 52, 52) -- Cinza (Desligado)
    end
end

-- Funções de Aimbot
function isVisible(targetPart)
    if not DeleteMob.Aimbot.WallCheck then
        return true
    end
    local ray = Ray.new(CurrentCam.CFrame.Position, (targetPart.Position - CurrentCam.CFrame.Position).unit * 1000)
    local hitPart, _ = game.Workspace:FindPartOnRayWithIgnoreList(ray, {PLAYER.Character, targetPart.Parent})
    return not hitPart or not hitPart:IsA("BasePart")
end

function getClosestTarget()
    local maxFov = DeleteMob.Aimbot.Fov
    local currentTarget = nil
    local mousePos = UserInputService:GetMouseLocation()

    for _, otherPlayer in pairs(game:GetService("Players"):GetPlayers()) do
        if otherPlayer ~= PLAYER and otherPlayer.Character and otherPlayer.Character:FindFirstChild("Humanoid") and otherPlayer.Character.Humanoid.Health > 0 then
            local isTeamCheckOk = not DeleteMob.Aimbot.TeamCheck or (otherPlayer.Team ~= PLAYER.Team)
            
            if isTeamCheckOk then
                local targetPart = otherPlayer.Character:FindFirstChild(DeleteMob.Aimbot.AimPart)
                if targetPart then
                    local screenPos, onScreen = CurrentCam:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local magnitude = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if magnitude < maxFov and isVisible(targetPart) then
                            maxFov = magnitude
                            currentTarget = otherPlayer
                        end
                    end
                end
            end
        end
    end
    return currentTarget
end

function aimAt(target)
    local targetPart = target.Character and target.Character:FindFirstChild(DeleteMob.Aimbot.AimPart)
    if targetPart then
        -- [!] Lógica de suavização (smoothing) pode ser adicionada aqui
        local newCFrame = CFrame.new(CurrentCam.CFrame.Position, targetPart.Position)
        CurrentCam.CFrame = CurrentCam.CFrame:Lerp(newCFrame, 0.1) -- Exemplo de suavização
    end
end


--================================================================================
-- CONEXÕES DE EVENTOS (BOTÕES E INPUTS)
--================================================================================

-- [!] Lógica do botão de abrir/fechar CORRIGIDA
openCloseButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Botões do Aimbot
aimbotEnableButton.MouseButton1Click:Connect(function()
    DeleteMob.Aimbot.Enabled = not DeleteMob.Aimbot.Enabled
    toggleButtonColor(aimbotEnableButton, DeleteMob.Aimbot.Enabled)
end)

aimbotWallCheckButton.MouseButton1Click:Connect(function()
    DeleteMob.Aimbot.WallCheck = not DeleteMob.Aimbot.WallCheck
    toggleButtonColor(aimbotWallCheckButton, DeleteMob.Aimbot.WallCheck)
end)

aimbotTeamCheckButton.MouseButton1Click:Connect(function()
    DeleteMob.Aimbot.TeamCheck = not DeleteMob.Aimbot.TeamCheck
    toggleButtonColor(aimbotTeamCheckButton, DeleteMob.Aimbot.TeamCheck)
end)

aimbotShowFovButton.MouseButton1Click:Connect(function()
    DeleteMob.Aimbot.ShowFov = not DeleteMob.Aimbot.ShowFov
    toggleButtonColor(aimbotShowFovButton, DeleteMob.Aimbot.ShowFov)
end)

aimbotPartButton.MouseButton1Click:Connect(function()
	if DeleteMob.Aimbot.AimPart == "Head" then
		DeleteMob.Aimbot.AimPart = "HumanoidRootPart"
        aimbotPartButton.Text = "Aim: Torso"
	else
		DeleteMob.Aimbot.AimPart = "Head"
        aimbotPartButton.Text = "Aim: Head"
	end
end)


-- Input de Toque (Mobile)
UserInputService.TouchStarted:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and DeleteMob.Aimbot.Enabled then
        DeleteMob.Aimbot.IsAimKeyDown = true
    end
end)

UserInputService.TouchEnded:Connect(function(input, gameProcessedEvent)
    if DeleteMob.Aimbot.IsAimKeyDown then
        DeleteMob.Aimbot.IsAimKeyDown = false
    end
end)

-- Input de Mouse (para testes no PC)
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.UserInputType == Enum.UserInputType.MouseButton2 then
         if DeleteMob.Aimbot.Enabled then
            DeleteMob.Aimbot.IsAimKeyDown = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
     if input.UserInputType == Enum.UserInputType.MouseButton2 then
        if DeleteMob.Aimbot.IsAimKeyDown then
            DeleteMob.Aimbot.IsAimKeyDown = false
        end
    end
end)


--================================================================================
-- LOOP PRINCIPAL (RenderStepped) - [!] UNIFICADO
--================================================================================

RunService.RenderStepped:Connect(function()
    -- Lógica do Aimbot
    if DeleteMob.Aimbot.IsAimKeyDown and DeleteMob.Aimbot.Enabled then
        local target = getClosestTarget()
        if target then
            aimAt(target)
        end
    end

    -- Lógica de exibição do FOV
    if DeleteMob.Aimbot.ShowFov then
        local mousePos = UserInputService:GetMouseLocation()
        fovFrame.Visible = true
        local fovSize = DeleteMob.Aimbot.Fov * 2
        fovFrame.Position = UDim2.fromOffset(mousePos.X - fovSize/2, mousePos.Y - fovSize/2)
        fovFrame.Size = UDim2.fromOffset(fovSize, fovSize)
    else
        fovFrame.Visible = false
    end

    -- [!] Adicione a lógica de atualização do ESP aqui
    -- Por exemplo, percorrer todos os jogadores e atualizar a posição das caixas do ESP
end)


--================================================================================
-- INICIALIZAÇÃO
--================================================================================
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "DeleteMob Loaded", Text = "Made By Mick Gordon, Refactored by Gemini"})
end)

print("DeleteMob Script Carregado com Sucesso.")
