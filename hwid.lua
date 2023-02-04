if (_G.MLOADED) then
    return
end


if (Drawing == nil) then
warn('Unfortunately, your executor is missing the Drawing library and is not supported by FDP Client.')
warn('Consider upgrading to an exploit like Fluxus or KRNL')
return
end
-- { Make FDP folder } --
if (not isfile('FDP')) then
makefolder('FDP')
end
if (not isfile("FDP/assets")) then
    makefolder("FDP/assets")
end
if (not isfile("FDP/configs")) then
    makefolder("FDP/configs")
end
if (not isfile("FDP/scripts")) then
    makefolder("FDP/scripts")
end
-- { Version } --
local FDPVER = (shared.FDPVersion)
local IndentLevel1 = 8
local IndentLevel2 = 14
local IndentLevel3 = 22
local RightIndent = 14
-- { Wait for load } --
if not game:IsLoaded() then game.Loaded:Wait() end
-- { Microops } --
-- Services
local servContext = game:GetService('ContextActionService')
local servGui = game:GetService('GuiService')
local servHttp = game:GetService('HttpService')
local servNetwork = game:GetService('NetworkClient')
local servPlayers = game:GetService('Players')
local servRun = game:GetService('RunService')
local servTeleport = game:GetService('TeleportService')
local servTween = game:GetService('TweenService')
local servInput = game:GetService('UserInputService')
local servVim = game:GetService('VirtualInputManager')
-- Colors
local colRgb,colHsv,colNew = Color3.fromRGB, Color3.fromHSV, Color3.new
-- UDim2
local dimOffset, dimScale, dimNew = UDim2.fromOffset, UDim2.fromScale, UDim2.new
-- Instances
local instNew = Instance.new
local drawNew = Drawing.new
-- Vectors
local vec3, vec2 = Vector3.new, Vector2.new
-- CFrames
local cfrNew = CFrame.new
-- Task
local wait, delay, spawn = task.wait, task.delay, task.spawn
-- Math
local mathRand = math.random
local mathFloor = math.floor
local mathClamp = math.clamp
-- Table
local tabInsert,tabRemove,tabClear,tabFind = table.insert, table.remove, table.clear, table.find
-- Os
local date = os.date
local tick = tick
-- Other stuff
local workspace = workspace
local ipairs = ipairs
local game = game
local isrbxactive = isrbxactive
if (isrbxactive == nil) then
local active = true
servInput.WindowFocused:Connect(function() 
    active = true 
end)
servInput.WindowFocusReleased:Connect(function() 
    active = false
end)
getgenv().isrbxactive = function() 
    return active
end
isrbxactive = isrbxactive
end
-- { Load in some shit } --
local function DecodeThemeJson(json) 
-- Strip away comments
json = json:gsub('//[^\n]+','')
-- Convert JSON to lua
local stuff = servHttp:JSONDecode(json)
-- Get the theme data
local theme = stuff['theme']
-- Set up locals
local RLTHEME
local RLTHEMEFONT
do
    RLTHEME = {}
    RLTHEMEFONT = theme['Font']
    
    -- Make a switch statement
    local switch = {}
    switch['Generic_Outline']       = 'go' -- Thank god im switching away from indices
    switch['Generic_Shadow']        = 'gs'
    switch['Generic_Window']        = 'gw'
    switch['Generic_Enabled']       = 'ge'
    switch['Background_Menu']       = 'bm'
    switch['Background_Module']     = 'bo'
    switch['Background_Setting']    = 'bs'
    switch['Background_Dropdown']   = 'bd'
    switch['Hovering_Menu']         = 'hm'
    switch['Hovering_Module']       = 'ho'
    switch['Hovering_Setting']      = 'hs'
    switch['Hovering_Dropdown']     = 'hd'
    switch['Slider_Foreground']     = 'sf'
    switch['Slider_Background']     = 'sb'
    switch['Text_Main']             = 'tm'
    switch['Text_Outline']          = 'to'
    
    -- Go through all theme data and do stuff
    for Index, ThemeSetting in pairs(theme) do
        -- If this setting isnt a table (like the font) then continue
        if (type(ThemeSetting) ~= 'table') then continue end            
        -- If this setting doesn't have a valid id then continue
        if (not switch[Index]) then continue end
        -- Get theme options
        local Color1 = ThemeSetting['Color']
        local Color2 = ThemeSetting['Color2']
        local IsGradient = ThemeSetting['Gradient']
        local Transpar = ThemeSetting['Transparency']
        
        -- Add to RLTHEME
        local _ = {
            colRgb(Color1[1],Color1[2],Color1[3]);
            Transpar;
            IsGradient;
            Color2 and colRgb(Color2[1],Color2[2],Color2[3]);
            
            
        }
        RLTHEME[switch[Index]] = _
    end
end
-- Return
return RLTHEME, RLTHEMEFONT
end
if (isfile('FDP/theme.jsonc')) then
_G.RLLOADERROR = 0
local ThemeData, Font
pcall(function()
    local FileData = readfile('FDP/theme.jsonc')
    ThemeData, Font = DecodeThemeJson(FileData)
end)
if (ThemeData and Font) then
    _G.RLTHEMEDATA = ThemeData
    _G.RLTHEMEFONT = Font
else
    _G.RLLOADERROR = 2 -- Couldn't load theme properly (JSON decoder failed)
end
end
-- ! WARNING ! --
-- SHITTY THEME CODE BELOW
-- SKIP DOWN LIKE 2000 LINES TO GET TO THE GOOD STUFF
-- { Theme } --
local RLTHEMEDATA, RLTHEMEFONT do 
RLTHEMEFONT = _G.RLTHEMEFONT or 'SourceSans'
if (RLTHEMEFONT:match('https://')) then
    -- syn v3 forwards compatibility
    -- doubt this works but maybe it does
    
    local req = nil or
        (type(syn) == 'table' and syn.request) or 
        (type(http) == 'table' and http.request) or 
        (type(fluxus) == 'table' and fluxus.request) or
        http_request or request
    
    if (req) then
        local _ = req{
            Method = 'GET',
            Url = RLTHEMEFONT
        }
        if (_.Success) then
            writefile('rl-temp.ttf', _.Body)
            local works = pcall(function()
                RLTHEMEFONT = (getsynasset or getcustomasset or fakeasset or getfakeasset)('temp.ttf')
            end)
            if (not works) then
                RLTHEMEFONT = 'SourceSans'  
            end
            delfile('rl-temp.ttf')
        end
    else
        RLTHEMEFONT = 'SourceSans' 
    end
end
RLTHEMEDATA = _G.RLTHEMEDATA or {} do
    RLTHEMEDATA['go'] = RLTHEMEDATA['go'] or {}
    RLTHEMEDATA['gs'] = RLTHEMEDATA['gs'] or {}
    RLTHEMEDATA['gw'] = RLTHEMEDATA['gw'] or {}
    RLTHEMEDATA['ge'] = RLTHEMEDATA['ge'] or {}
    RLTHEMEDATA['bm'] = RLTHEMEDATA['bm'] or {}
    RLTHEMEDATA['bo'] = RLTHEMEDATA['bo'] or {}
    RLTHEMEDATA['bs'] = RLTHEMEDATA['bs'] or {}
    RLTHEMEDATA['bd'] = RLTHEMEDATA['bd'] or {}
    RLTHEMEDATA['hm'] = RLTHEMEDATA['hm'] or {}
    RLTHEMEDATA['ho'] = RLTHEMEDATA['ho'] or {}
    RLTHEMEDATA['hs'] = RLTHEMEDATA['hs'] or {}
    RLTHEMEDATA['hd'] = RLTHEMEDATA['hd'] or {}
    RLTHEMEDATA['sf'] = RLTHEMEDATA['sf'] or {}
    RLTHEMEDATA['sb'] = RLTHEMEDATA['sb'] or {}
    RLTHEMEDATA['tm'] = RLTHEMEDATA['tm'] or {}
    RLTHEMEDATA['to'] = RLTHEMEDATA['to'] or {}
end
-- so many fucking tables my god
do 
    -- generic
    RLTHEMEDATA['go'][1]   = RLTHEMEDATA['go'][1]  or colRgb(075, 075, 080); -- outline color
    RLTHEMEDATA['gs'][1]   = RLTHEMEDATA['gs'][1]  or colRgb(005, 005, 010); -- shadow
    RLTHEMEDATA['gw'][1]   = RLTHEMEDATA['gw'][1]  or colRgb(023, 022, 027); -- window background
    RLTHEMEDATA['ge'][1]   = RLTHEMEDATA['ge'][1]  or colRgb(225, 035, 061); -- enabled
    -- backgrounds
    RLTHEMEDATA['bm'][1]   = RLTHEMEDATA['bm'][1]  or colRgb(035, 035, 040); -- header background
    RLTHEMEDATA['bo'][1]   = RLTHEMEDATA['bo'][1]  or colRgb(030, 030, 035); -- object background
    RLTHEMEDATA['bs'][1]   = RLTHEMEDATA['bs'][1]  or colRgb(025, 025, 030); -- setting background
    RLTHEMEDATA['bd'][1]   = RLTHEMEDATA['bd'][1]  or colRgb(020, 020, 025); -- dropdown background
    -- backgrounds selected
    RLTHEMEDATA['hm'][1]   = RLTHEMEDATA['hm'][1]  or colRgb(038, 038, 043); -- header hovering
    RLTHEMEDATA['ho'][1]   = RLTHEMEDATA['ho'][1] or colRgb(033, 033, 038); -- object hovering
    RLTHEMEDATA['hs'][1]   = RLTHEMEDATA['hs'][1] or colRgb(028, 028, 033); -- setting hovering
    RLTHEMEDATA['hd'][1]   = RLTHEMEDATA['hd'][1] or colRgb(023, 023, 028); -- dropdown hovering
    -- slider 
    RLTHEMEDATA['sf'][1]   = RLTHEMEDATA['sf'][1] or colRgb(225, 075, 080); -- slider foreground
    RLTHEMEDATA['sb'][1]   = RLTHEMEDATA['sb'][1] or colRgb(033, 033, 038); -- slider background
    -- text   
    RLTHEMEDATA['tm'][1]   = RLTHEMEDATA['tm'][1] or colRgb(255, 255, 255); -- main text
    RLTHEMEDATA['to'][1]   = RLTHEMEDATA['to'][1] or colRgb(020, 020, 025); -- outline
end
do 
    RLTHEMEDATA['go'][2]   = RLTHEMEDATA['go'][2]  or 0;
    RLTHEMEDATA['gs'][2]   = RLTHEMEDATA['gs'][2]  or 0;
    RLTHEMEDATA['gw'][2]   = RLTHEMEDATA['gw'][2]  or 0.2;
    RLTHEMEDATA['ge'][2]   = RLTHEMEDATA['ge'][2]  or 0.7;
    RLTHEMEDATA['bm'][2]   = RLTHEMEDATA['bm'][2]  or 0;
    RLTHEMEDATA['bo'][2]   = RLTHEMEDATA['bo'][2]  or 0;
    RLTHEMEDATA['bs'][2]   = RLTHEMEDATA['bs'][2]  or 0;
    RLTHEMEDATA['bd'][2]   = RLTHEMEDATA['bd'][2]  or 0;
    RLTHEMEDATA['hm'][2]   = RLTHEMEDATA['hm'][2]  or 0;
    RLTHEMEDATA['ho'][2]   = RLTHEMEDATA['ho'][2]  or 0;
    RLTHEMEDATA['hs'][2]   = RLTHEMEDATA['hs'][2]  or 0;
    RLTHEMEDATA['hd'][2]   = RLTHEMEDATA['hd'][2]  or 0;
    RLTHEMEDATA['sf'][2]   = RLTHEMEDATA['sf'][2]  or 0;
    RLTHEMEDATA['sb'][2]   = RLTHEMEDATA['sb'][2]  or 0;
    RLTHEMEDATA['tm'][2]   = RLTHEMEDATA['tm'][2]  or 0;
    RLTHEMEDATA['to'][2]   = RLTHEMEDATA['to'][2]  or 0;
end
do 
    RLTHEMEDATA['go'][3]  = RLTHEMEDATA['go'][3] or false;
end
end
-- { UI functions / variables } --
local gradient,twn,ctwn,getnext,stroke,round,uierror
do
do
    local g1
    if (RLTHEMEDATA['go'][3]) then 
        g1 = ColorSequence.new{
            ColorSequenceKeypoint.new(0, RLTHEMEDATA['go'][1]);
            ColorSequenceKeypoint.new(1, RLTHEMEDATA['go'][4]);
        }
    end
    gradient = function(parent)
        local _ = instNew('UIGradient')
        _.Rotation = 45
        --_.Transparency = parent.Transparency
        _.Color = g1
        _.Parent = parent
    
        return _
    end
end
stroke = function(parent,mode, trans) 
    local _ = instNew('UIStroke')
    _.ApplyStrokeMode = mode or 'Contextual'
    _.Thickness = 1
    
    _.Transparency = trans or RLTHEMEDATA['go'][2]
    
    if (RLTHEMEDATA['go'][3]) then
        gradient(_) 
        _.Color = colNew(1,1,1)
    else
        _.Color = RLTHEMEDATA['go'][1]
    end
    
    _.Parent = parent
    return _
end
local info1, info2 = TweenInfo.new(0.1,10,1), TweenInfo.new(0.3,10,1)
function twn(twn_target, twn_settings, twn_long) 
    local tween = servTween:Create(
        twn_target,
        twn_long and info2 or info1,
        twn_settings
    )
    tween:Play()
    return tween
end
function ctwn(twn_target, twn_settings, twn_dur, twn_style, twn_dir) 
    local tween = servTween:Create(
        twn_target,
        TweenInfo.new(twn_dur,twn_style or 10,twn_dir or 1),
        twn_settings
    )
    tween:Play()
    return tween
end
function getnext() 
    local a = ''
    for i = 1, 5 do a = a .. utf8.char(mathRand(50,2000)) end 
    return a 
end
function round(num, place) 
    return mathFloor(((num+(place*.5)) / place)) * place
end
function uierror(func, prop, type) 
    error(('%s failed; %s is not of type %s'):format(func,prop,type), 3)
end
end
local W_WindowOpen = false or false
local RGBCOLOR
-- { UI } --
local ui = {} do 
local ui_Hotkeys = {}
local ui_Connections = {}
local ui_Menus = {}
local ui_Widgets = {}
local ui_Modules = {}
local Configs = {}
local rgbinsts = {}
ui["RGBColor"] = rgbinsts
local monitor_resolution = servGui:GetScreenResolution()
local monitor_inset = servGui:GetGuiInset()
local SaveDataFileName = "FDP/Configs/" .. (shared.CustomSave or game.PlaceId) .. ".txt"
local servHttp = game:GetService("HttpService")
function saveSettings()
    local json;
    if (writefile) then
        json = servHttp:JSONEncode(Configs);
        writefile(SaveDataFileName, json);
    else
        game.Players.LocalPlayer:Kick("Get krnl or synapse x")
    end
end
function loadSettings()
    if (readfile and isfile and isfile(SaveDataFileName)) then
        Configs = servHttp:JSONDecode(readfile(SaveDataFileName));
    end
end
-- connections
ui_Connections['i'] = servInput.InputBegan:Connect(function(io, gpe) 
    if (gpe == false and io.UserInputType.Value == 8) then
        local kcv = io.KeyCode.Value
        for i = 1, #ui_Hotkeys do 
            local hk = ui_Hotkeys[i]
            if (hk[1] == kcv) then
                hk[2]()
            end
        end
    end
end)
do
    local rgbtime = 0
    
    ui_Connections['r'] = servRun.RenderStepped:Connect(function(dt) 
        if (not isrbxactive()) then return end
        
        rgbtime = (rgbtime > 1 and 0 or rgbtime)+(dt*0.1)
        RGBCOLOR = colHsv(rgbtime,0.8,1)
        for i = 1, #rgbinsts do 
            local v = rgbinsts[i]
            v[1][v[2]] = RGBCOLOR
        end
    end)
end
-- Gui creation
local w_Screen
 local w_TooltipHeader
  local w_Tooltip
local w_Backframe
 local w_CreditFrame
 local w_FriendsFrame
 local w_ModFrame
  local w_Help
  local w_Modal
 local w_ProfileFrame
 local w_SettingsFrame
local w_ModList
 local w_ModListLayout
 local w_ModListTitle
 local w_ModListVer
local w_MouseCursor
local ModlistPadding = {
    dimOffset(-100, 0).X;
    dimOffset(8, 0).X;
    Enum.TextXAlignment.Left;
    'PaddingLeft';
} 
do 
    w_Screen = instNew('ScreenGui')
    w_Screen.IgnoreGuiInset = true
    w_Screen.ZIndexBehavior = Enum.ZIndexBehavior.Global
    w_Screen.Name = getnext()
    pcall(function() 
        syn.protect_gui(w_Screen)
    end)
    w_Screen.DisplayOrder = 939393
    w_Screen.Parent = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or game.CoreGui
    ui["MainGui"] = w_Screen

    w_Backframe = instNew('Frame')
    w_Backframe.BackgroundColor3 = RLTHEMEDATA['gw'][1]
    w_Backframe.BackgroundTransparency = RLTHEMEDATA['gw'][2]
    w_Backframe.BorderSizePixel = 0
    w_Backframe.ClipsDescendants = true
    w_Backframe.Position = dimNew(0, 0, 0, 0)
    w_Backframe.Size = dimScale(1,1)
    w_Backframe.Visible = false
    w_Backframe.Parent = w_Screen
    
    w_ModFrame = instNew('Frame')
    w_ModFrame.BackgroundTransparency = 1
    w_ModFrame.BorderSizePixel = 0
    w_ModFrame.ClipsDescendants = false
    w_ModFrame.Size = dimScale(1,1)
    w_ModFrame.Visible = true
    w_ModFrame.Parent = w_Backframe
    
    w_FriendsFrame = instNew('Frame')
    w_FriendsFrame.BackgroundTransparency = 1
    w_FriendsFrame.BorderSizePixel = 0
    w_FriendsFrame.ClipsDescendants = false
    w_FriendsFrame.Size = dimScale(1,1)
    w_FriendsFrame.Visible = false
    w_FriendsFrame.Parent = w_Backframe
    
    w_ProfileFrame = instNew('Frame')
    w_ProfileFrame.BackgroundTransparency = 1
    w_ProfileFrame.BorderSizePixel = 0
    w_ProfileFrame.ClipsDescendants = false
    w_ProfileFrame.Size = dimScale(1,1)
    w_ProfileFrame.Visible = false
    w_ProfileFrame.Parent = w_Backframe
    
    w_SettingsFrame = instNew('Frame')
    w_SettingsFrame.BackgroundTransparency = 1
    w_SettingsFrame.BorderSizePixel = 0
    w_SettingsFrame.ClipsDescendants = false
    w_SettingsFrame.Size = dimScale(1,1)
    w_SettingsFrame.Visible = false
    w_SettingsFrame.Parent = w_Backframe
    
    w_CreditFrame = instNew('Frame')
    w_CreditFrame.BackgroundTransparency = 1
    w_CreditFrame.BorderSizePixel = 0
    w_CreditFrame.ClipsDescendants = false
    w_CreditFrame.Size = dimScale(1,1)
    w_CreditFrame.Visible = false
    w_CreditFrame.Parent = w_Backframe
    
    do 
        
    end
    
    w_Modal = instNew('TextButton')
    w_Modal.Active = false
    w_Modal.BackgroundTransparency = 1
    w_Modal.Modal = true
    w_Modal.Size = dimOffset(1,1)
    w_Modal.Text = ''
    w_Modal.Parent = w_ModFrame
    
    w_Help = instNew('TextLabel')
    w_Help.AnchorPoint = vec2(1,1)
    w_Help.BackgroundTransparency = 1
    w_Help.Font = RLTHEMEFONT
    w_Help.Position = dimScale(1,1)
    w_Help.RichText = true
    w_Help.Size = dimOffset(300,300)
    w_Help.Text = ''
    w_Help.TextColor3 = RLTHEMEDATA['tm'][1]
    w_Help.TextSize = 20
    w_Help.TextStrokeColor3 = RLTHEMEDATA['to'][1]
    w_Help.TextStrokeTransparency = 0
    w_Help.TextXAlignment = 'Left'
    w_Help.TextYAlignment = 'Top'
    w_Help.Visible = false
    w_Help.ZIndex = 1
    w_Help.Parent = w_ModFrame
    
    w_ModList = instNew('Frame')
    w_ModList.AnchorPoint = vec2(0, 1)
    w_ModList.BackgroundColor3 = RLTHEMEDATA['gw'][1]
    w_ModList.BackgroundTransparency = 1
    w_ModList.BorderColor3 = RLTHEMEDATA['gs'][1]
    w_ModList.BorderMode = 'Inset'
    w_ModList.BorderSizePixel = 1
    w_ModList.Position = dimScale(0,1)
    w_ModList.Size = dimNew(0,200,0.3,0)
    w_ModList.Visible = false
    w_ModList.Parent = w_Screen
    
    w_ModListLayout = instNew('UIListLayout')
    w_ModListLayout.FillDirection = 'Vertical'
    w_ModListLayout.HorizontalAlignment = 'Left'
    w_ModListLayout.VerticalAlignment = 'Bottom'
    w_ModListLayout.Parent = w_ModList
    
    w_ModListTitle = instNew('TextLabel')
    w_ModListTitle.BackgroundTransparency = 1
    w_ModListTitle.Font = RLTHEMEFONT
    w_ModListTitle.LayoutOrder = 939
    w_ModListTitle.Size = dimNew(1, 0, 0, 30)
    w_ModListTitle.TextColor3 = RLTHEMEDATA['tm'][1]
    w_ModListTitle.TextSize = 24
    w_ModListTitle.Text = " ".."FDP ".. FDPVER .. " "
    w_ModListTitle.TextStrokeColor3 = RLTHEMEDATA['to'][1]
    w_ModListTitle.TextStrokeTransparency = RLTHEMEDATA['to'][2]
    w_ModListTitle.TextTransparency = RLTHEMEDATA['tm'][1]
    w_ModListTitle.TextXAlignment = 'Left'
    w_ModListTitle.ZIndex = 5
    w_ModListTitle.Parent = w_ModList
    
    w_TooltipHeader = instNew('TextLabel')
    w_TooltipHeader.BackgroundColor3 = RLTHEMEDATA['bm'][1]
    w_TooltipHeader.BackgroundTransparency = RLTHEMEDATA['bm'][2]
    w_TooltipHeader.BorderSizePixel = 0
    w_TooltipHeader.Font = RLTHEMEFONT
    w_TooltipHeader.RichText = true
    w_TooltipHeader.Size = dimOffset(175,20)
    w_TooltipHeader.Text = 'Hi'
    w_TooltipHeader.TextColor3 = RLTHEMEDATA['tm'][1]
    w_TooltipHeader.TextSize = 19
    w_TooltipHeader.TextStrokeColor3 = RLTHEMEDATA['to'][1]
    w_TooltipHeader.TextStrokeTransparency = 0
    w_TooltipHeader.TextXAlignment = 'Center'
    w_TooltipHeader.Visible = false 
    w_TooltipHeader.ZIndex = 1500
    w_TooltipHeader.Parent = w_Screen
    
    stroke(w_TooltipHeader, 'Border')
    
    w_Tooltip = instNew('TextLabel')
    w_Tooltip.BackgroundColor3 = RLTHEMEDATA['gw'][1]
    w_Tooltip.BackgroundTransparency = RLTHEMEDATA['gw'][2]
    w_Tooltip.BorderSizePixel = 0
    w_Tooltip.Font = RLTHEMEFONT
    w_Tooltip.Position = dimOffset(0, 21)
    w_Tooltip.RichText = true
    w_Tooltip.Size = dimOffset(175,25)
    w_Tooltip.Text = ''
    w_Tooltip.TextColor3 = RLTHEMEDATA['tm'][1]
    w_Tooltip.TextSize = 17
    w_Tooltip.TextStrokeColor3 = RLTHEMEDATA['to'][1]
    w_Tooltip.TextStrokeTransparency = 0
    w_Tooltip.TextWrapped = true
    w_Tooltip.TextXAlignment = 'Left'
    w_Tooltip.TextYAlignment = 'Top'
    w_Tooltip.Visible = true 
    w_Tooltip.ZIndex = 1500
    w_Tooltip.Parent = w_TooltipHeader
    
    stroke(w_Tooltip, 'Border')
    
    local __ = instNew('UIPadding')
    __.PaddingLeft = dimOffset(5, 0).X
    --__.PaddingTop = dimOffset(0, 5).Y
    __.Parent = w_Tooltip
    
    w_Tooltip:GetPropertyChangedSignal('Text'):Connect(function() 
        w_Tooltip.Size = dimOffset(175,25)
        local n = dimOffset(0,5)
        for i = 1, 25 do 
            w_Tooltip.Size += n
            if (w_Tooltip.TextFits) then break end
        end
        w_Tooltip.Size += n
    end)
    
    w_MouseCursor = instNew('ImageLabel')
    w_MouseCursor.BackgroundTransparency = 1
    w_MouseCursor.Image = 'rbxassetid://8845749987'
    w_MouseCursor.ImageColor3 = RLTHEMEDATA['ge'][1]
    w_MouseCursor.ImageTransparency = 1
    w_MouseCursor.Position = dimOffset(150, 150)
    w_MouseCursor.Size = dimOffset(24, 24)
    w_MouseCursor.Visible = true
    w_MouseCursor.ZIndex = 1500
    w_MouseCursor.Parent = w_Screen
end
function ui:manageml(x1,x2,align,paddir) 
    ModlistPadding[1] = x1 and dimOffset(x1, 0).X or ModlistPadding[1]
    ModlistPadding[2] = x2 and dimOffset(x2, 0).X or ModlistPadding[2]
    ModlistPadding[4] = paddir or ModlistPadding[4]
    
    if (align and align ~= ModlistPadding[3]) then
        -- :troll
        local c = w_ModList:GetChildren()
        local _ = ModlistPadding[2]
        local __ = ModlistPadding[4]
        local ___ = __ == 'PaddingLeft' and 'PaddingRight' or __
        local ____ = dimOffset(0,0).X
        for i = 1, #c do
            local v = c[i]
            if (v.ClassName == 'TextLabel' and v ~= w_ModListTitle) then
                v.TextXAlignment = align
                local p = v.P
                p[__] = _
                p[___] = ____
            end
        end
        w_ModListTitle.TextXAlignment = align
        ModlistPadding[3] = align
    end
    
    
    return {
        w_ModList;
        w_ModListLayout;
        w_ModListTitle;
    }
end
ui_Connections['t'] = servRun.RenderStepped:Connect(function() 
    local pos = servInput:GetMouseLocation()
    local x,y = pos.X, pos.Y
    w_TooltipHeader.Position = dimOffset(x+15, y+15)
    w_MouseCursor.Position = dimOffset(x-4, y)
end)
local ModListEnable,ModListDisable,ModListInit,ModListModify do 
    local mods_instance = {}
    
    ModListEnable = function(name) 
        local b = mods_instance[name]
        
        b.TextXAlignment = ModlistPadding[3]
        b.Parent = w_ModList
        twn(b.P, {[ModlistPadding[4]] = ModlistPadding[2]},true)
        twn(b, {Size = dimNew(1, 0, 0, 24), TextTransparency = 0, TextStrokeTransparency = 0},true)
    end
    
    ModListDisable = function(name)
        local b = mods_instance[name]
        
        twn(b.P, {[ModlistPadding[4]] = ModlistPadding[1]},true)
        twn(b, {Size = dimNew(0, 0, 0, 0), TextTransparency = 1, TextStrokeTransparency = 1},true)
    end
    
    ModListModify = function(name, new) 
        mods_instance[name].Text = new
    end
    
    ModListInit = function(name) 
        local _ = instNew('TextLabel')
        _.Size = dimNew(0, 0, 0, 0)
        _.BackgroundTransparency = 1
        _.Font = RLTHEMEFONT
        _.TextXAlignment = ModlistPadding[3]
        _.TextColor3 = RLTHEMEDATA['tm'][1]
        _.TextSize = 22
        _.Text = name
        --_.Name = name
        _.RichText = true
        _.TextTransparency = 1
        _.TextStrokeTransparency = 1
        _.TextStrokeColor3 = RLTHEMEDATA['to'][1]
        _.ZIndex = 5
        
        mods_instance[name] = _

        for i,v in pairs(mods_instance) do
            print(v)
        end
        
        tabInsert(rgbinsts, {_,'TextColor3'})
        
        
        local __ = instNew('UIPadding')
        __.Name = 'P'
        __[ModlistPadding[4]] = ModlistPadding[1]
        __.Parent = _
    end
end
-- Base class for stuff
local base_class = {} do 
    local s1,s2 = dimNew(1,0,1,0), dimNew(0,0,1,0)
    
    
    
    -- objtype_action_actiontype
    
    -- Menu funcs
    do
        base_class.menu_toggle = function(self) 
            local t = not self.MToggled
            if (t) then
                Configs[self.Name]["MenuToggled"] = true
                saveSettings()
            else
                Configs[self.Name]["MenuToggled"] = false
                saveSettings()
            end
            
            self.MToggled = t
            self.Menu.Visible = t
            twn(self.Icon, {Rotation = t and 0 or 180}, true)
        end
        base_class.menu_enable = function(self) 
            self.MToggled = true
            self.Menu.Visible = true
            twn(self.Icon, {Rotation = 0}, true)
        end
        base_class.menu_disable = function(self) 
            self.MToggled = false
            self.Menu.Visible = false
            twn(self.Icon, {Rotation = 180}, true)
        end
        base_class.menu_getstate = function(self) 
            return self.MToggled
        end
    end

    -- Notificatino
    do
    local notifs = {}
    local notifsounds = {
        high = 'rbxassetid://9009664674',
        low = 'rbxassetid://9009665420',
        none = '',
        warn = 'rbxassetid://9009666085'
    }

    local m_Notif
    local m_Description
    local m_Header
    local m_Icon
    local m_Text

    local m_Sound
    do 

        m_Notif = instNew('Frame')
        m_Notif.AnchorPoint = vec2(1,1)
        m_Notif.BackgroundColor3 = RLTHEMEDATA['bo'][1]
        m_Notif.BackgroundTransparency = RLTHEMEDATA['bo'][2]
        m_Notif.BorderSizePixel = 0
        m_Notif.Position = dimNew(1, 300, 1, -((#notifs*80)+((#notifs+1)*25)))
        m_Notif.Size = dimOffset(180, 90)
        m_Notif.ZIndex = 162
        --m_Notif.Parent = w_Screen

        stroke(m_Notif)

        m_Sound = instNew('Sound')
        --m_Sound.Playing = true
        --m_Sound.SoundId =notifsounds[tone or 3]
        m_Sound.Volume = 1
        m_Sound.TimePosition = 0.1
        --m_Sound.Parent = m_Notif 

        m_Progress = instNew('Frame')
        m_Progress.BackgroundColor3 = RLTHEMEDATA['ge'][1]
        m_Progress.BorderSizePixel = 0
        m_Progress.Position = dimOffset(0, 30)
        m_Progress.Size = dimNew(1,0,0,1)
        m_Progress.ZIndex = 163
        --m_Progress.Parent = m_Notif

        m_Header = instNew('Frame')
        m_Header.BackgroundColor3 = RLTHEMEDATA['bm'][1]
        m_Header.BackgroundTransparency = RLTHEMEDATA['bm'][2]
        m_Header.BorderSizePixel = 0
        m_Header.Size = dimNew(1,0,0,30)
        m_Header.ZIndex = 162
        --m_Header.Parent = m_Notif

        stroke(m_Header)

        m_Text = instNew('TextLabel')
        m_Text.BackgroundTransparency = 1
        m_Text.Font = RLTHEMEFONT
        m_Text.Position = dimOffset(24, 0)
        m_Text.RichText = true
        m_Text.Size = dimNew(1, -32, 1, 0)
        m_Text.Text = ''
        m_Text.TextColor3 = RLTHEMEDATA['tm'][1]
        m_Text.TextSize = 22
        m_Text.TextStrokeColor3 = RLTHEMEDATA['to'][1]
        m_Text.TextStrokeTransparency = 0
        m_Text.TextXAlignment = 'Left'
        m_Text.ZIndex = 162
        --m_Text.Parent = m_Header

        m_Description = instNew('TextLabel')
        m_Description.BackgroundTransparency = 1
        m_Description.Font = RLTHEMEFONT
        m_Description.Position = dimOffset(4, 32)
        m_Description.RichText = true
        m_Description.Size = dimNew(1, -4, 1, -32)
        m_Description.Text = tostring(text)
        m_Description.TextColor3 = RLTHEMEDATA['tm'][1]
        m_Description.TextSize = 20
        m_Description.TextStrokeColor3 = RLTHEMEDATA['to'][1]
        m_Description.TextStrokeTransparency = 0
        m_Description.TextWrapped = true
        m_Description.TextXAlignment = 'Left'
        m_Description.TextYAlignment = 'Top'
        m_Description.ZIndex = 162
        --m_Description.Parent = m_Notif

    end




    function ui:Notify(title, text, duration, tone, warning) 
        duration = mathClamp(duration or 2, 0.1, 30)

        local m_Notif = m_Notif:Clone()
        local m_Description = m_Description:Clone()
        local m_Header = m_Header:Clone()
        local m_Progress = m_Progress:Clone()
        local m_Text = m_Text:Clone()
        local m_Sound = m_Sound:Clone()

        do
            m_Description.Parent = m_Notif
            m_Sound.Parent = m_Notif
            m_Progress.Parent = m_Notif
            m_Header.Parent = m_Notif

            m_Text.Parent = m_Header
        end do
            m_Text.Text = title
            m_Description.Text = text
        end

        m_Sound.SoundId = notifsounds[tone or 'none']
        m_Sound.Playing = true

    

        m_Notif.Position = dimNew(1, 300, 1, -((#notifs*80)+((#notifs+1)*25)))
        m_Notif.Parent = w_Screen

        for i = 1, 25 do
            if (m_Text.TextFits) then break end
            m_Notif.Size += dimOffset(25, 0)
        end


        tabInsert(notifs, m_Notif)
        twn(m_Notif, {Position = m_Notif.Position - dimOffset(325,0)}, true)
        local j = ctwn(m_Progress, {Size = dimOffset(0, 1)}, duration)
        j.Completed:Connect(function()
            do
                for i = 1, #notifs do 
                    if (notifs[i] == m_Notif) then 
                        tabRemove(notifs, i) 
                    end 
                end
                for i = 1, #notifs do 
                    twn(notifs[i], {Position = dimNew(1, -25, 1, -(((i-1)*80)+(i*25)))}, true)
                end
                twn(m_Notif, {Position = dimNew(1, -25, 1, 310)}, true).Completed:Wait()
                m_Notif:Destroy()
            end
        end)
    end
end

    function createnotification(title, text, duration)
        FDPNotifications(title, text, duration, "info") 
    end
    function moduleenabled(title, text, duration)
        FDPNotifications(title, text, duration, "toggled") 
    end
    function moduledisabled(title, text, duration)
        FDPNotifications(title, text, duration, "disabled") 
    end

    -- Module funcs
    do
        base_class.module_toggle_menu = function(self) 
            local t = not self.MToggled
            
            self.MToggled = t
            self.Menu.Visible = t
            
            twn(self.Icon, {Rotation = t and 360 or 0}, true)
            
            self.Icon.Text = t and '-' or '+'
            if (t) then
                Configs[self.Name]["MenuToggled"] = true
                saveSettings()
            else
                Configs[self.Name]["MenuToggled"] = false
                saveSettings()
            end
        end
        base_class.module_toggle_self = function(self, nonoti, save) 
            local save = save or true

            if not save then
                local t = not self.OToggled
                self.OToggled = t

                pcall(self.Flags.Toggled, t)
                pcall(self.Flags[t and 'Enabled' or 'Disabled'])
            
                twn(self.Effect, {Size = t and s1 or s2}, true)
            
                if not Configs[self.Name] then
                    Configs[self.Name] = {["Keybind"] = "", ["IsToggled"] = "", ["MenuToggled"] = "", ["Extras"] = {}}
                end
                if (t) then
                    ModListEnable(self.Name)
                    Configs[self.Name]["IsToggled"] = true
                    saveSettings()
                else
                    ModListDisable(self.Name)
                    Configs[self.Name]["IsToggled"] = false
                    saveSettings()
                end
            else

                local t = not self.OToggled
                self.OToggled = t

                pcall(self.Flags.Toggled, t)
                pcall(self.Flags[t and 'Enabled' or 'Disabled'])
            
                twn(self.Effect, {Size = t and s1 or s2}, true)
            
                if not Configs[self.Name] then
                    Configs[self.Name] = {["Keybind"] = "", ["IsToggled"] = "", ["MenuToggled"] = "", ["Extras"] = {}}
                end
                if (t) then
                    ModListEnable(self.Name)
                    Configs[self.Name]["IsToggled"] = true
                    saveSettings()
                else
                    ModListDisable(self.Name)
                    Configs[self.Name]["IsToggled"] = false
                    saveSettings()
                end
            end
            return self 
        end
        base_class.module_toggle_enable = function(self) 
            self.OToggled = true
            
            pcall(self.Flags.Toggled, true)
            pcall(self.Flags.Enabled)
            
            twn(self.Effect, {Size = s1}, true)
            
            ModListEnable(self.Name)
            return self 
        end
        base_class.module_toggle_disable = function(self) 
            self.OToggled = false
            
            pcall(self.Flags.Toggled, false)
            pcall(self.Flags.Disabled)
            
            twn(self.Effect, {Size = s2}, true)
            
            ModListDisable(self.Name)
            return self
        end
        base_class.module_toggle_reset = function(self)
            if (self.OToggled) then
                local f = self.Flags
                pcall(f.Toggled, false)
                pcall(f.Disabled)
                
                pcall(f.Toggled, true)
                pcall(f.Enabled)
            end
        end
        base_class.module_getstate_self = function(self) return self.OToggled end
        base_class.module_getstate_menu = function(self) return self.MToggled end
        
        base_class.module_setvis = function(self, t, t2) 
            self.Root.Visible = t 
            self.Highlight.Visible = t2
        end 
        
        base_class.module_click_self = function(self) 
            pcall(self.Flags.Clicked)
            
            self.Effect.BackgroundTransparency = 0.8
            twn(self.Effect, {BackgroundTransparency = 1}, true)
        end
        base_class.module_gettext = function(self) 
            return self.Text
        end
        
    end
    -- Setting funcs
    do
        base_class.s_toggle_self = function(self) 
            local t = not self.Toggled
            if (t) then
                Configs[self.PName]["Extras"][self.Name] = true
                saveSettings()
            else
                Configs[self.PName]["Extras"][self.Name] = false
                saveSettings()
            end
            pcall(self.Flags.Toggled, t)
            pcall(self.Flags.Enabled)
            pcall(self.Flags.Disabled)
            
            self.Toggled = t
            twn(self.Icon, {BackgroundTransparency = t and 0 or 1})
            return self
        end 
        base_class.s_toggle_enable = function(self) 
            self.Toggled = true
            
            pcall(self.Flags.Toggled, true)
            pcall(self.Flags.Enabled)
            
            twn(self.Icon, {BackgroundTransparency = 0})
            return self
        end 
        base_class.s_toggle_disable = function(self) 
            self.Toggled = false
            
            pcall(self.Flags.Toggled, false)
            pcall(self.Flags.Disabled)
            
            twn(self.Icon, {BackgroundTransparency = 1})
            return self
        end 
        base_class.s_toggle_reset = function(self) 
            if (self.Toggled) then
                local f = self.Flags
                pcall(f.Toggled, false)
                pcall(f.Disabled)
                
                pcall(f.Toggled, true)
                pcall(f.Enabled)
            end
        end
        base_class.s_toggle_getstate = function(self) 
            return self.Toggled
        end
        base_class.s_modhoykey_setnewhotkey = function(self, hotkey)
            local label = self.Label
            label.Text = 'Settings new key...'
            wait(0.01);
            local kcv = Enum.KeyCode[hotkey].Value
            self.Hotkey = kcv
            label.Text = 'Hotkey: ' .. Enum.KeyCode[hotkey].Name
            
            
            Configs[self.Parent.Name]["Keybind"] = Enum.KeyCode[hotkey].Name
            saveSettings()
            delay(0.01, function()
                local n = self.Parent.Name
                for i = 1, #ui_Hotkeys do 
                    if ui_Hotkeys[i][3] == n then
                        tabRemove(ui_Hotkeys, i)
                        break
                    end
                end
                tabInsert(ui_Hotkeys, {kcv, function() 
                    self.Parent:Toggle()
                end, n})
            end)
        end
        base_class.s_modhotkey_sethotkey = function(self) 
            local label = self.Label
            label.Text = 'Press any key...'
            print(self.Parent.Name)
            wait(0.01);
            local c;
            c = servInput.InputBegan:Connect(function(io,gpe)
                
                Configs[self.Parent.Name]["Keybind"] = io.KeyCode.Name
                saveSettings()
                
                local kcv = io.KeyCode.Value
                if (kcv ~= 0) then
                    
                    self.Hotkey = kcv
                    label.Text = 'Hotkey: '..io.KeyCode.Name
                    
                    -- As scuffed as this is, it works
                    -- To prevent the module being bound from immediately toggling, a short delay is made
                    delay(0.01, function()
                        local n = self.Parent.Name
                        for i = 1, #ui_Hotkeys do 
                            if ui_Hotkeys[i][3] == n then
                                tabRemove(ui_Hotkeys, i)
                                break
                            end
                        end
                        tabInsert(ui_Hotkeys, {kcv, function() 
                            self.Parent:Toggle()
                        end, n})
                    end)
                else
                    self.Hotkey = nil    
                    label.Text = 'Hotkey: N/A'
                    
                    local n = self.Parent.Name
                    for i = 1, #ui_Hotkeys do 
                        if ui_Hotkeys[i][3] == n then
                            tabRemove(ui_Hotkeys, i)
                            break
                        end
                    end
                end
                c:Disconnect()
            end)
            
        end
    
        base_class.s_modhotkey_gethotkey = function(self) 
            return self.Hotkey
        end
        
        base_class.s_hotkey_sethotkey = function(self) 
            local label = self.Label
            label.Text = 'Press any key...'
            
            wait(0.01);
            local c;
            c = servInput.InputBegan:Connect(function(io,gpe)
                local kc = io.KeyCode
                local kcv = kc.Value
                if (kcv ~= 0) then
                    
                    self.Hotkey = kc
                    label.Text = self.Name..': '..kc.Name
                    
                    pcall(self.Flags.HotkeySet, kc, kcv)
                else
                    self.Hotkey = nil    
                    label.Text = self.Name..': N/A'
                    
                    pcall(self.Flags.HotkeySet, nil, 0)
                end
                c:Disconnect()
            end)
        end
        
        base_class.s_hotkey_sethotkeyexplicit = function(self, kc) 
            self.Hotkey = kc
            self.Label.Text = self.Name..': '..kc.Name
            
            pcall(self.Flags.HotkeySet, kc, kc.Value)
            
            return self
        end
        
        base_class.s_hotkey_gethotkey = function(self)
            return self.Hotkey
        end
        
        
        base_class.s_dropdown_getselection = function(self) 
            return self.Selection
        end
        base_class.s_dropdown_toggle = function(self) 
            local t = not self.MToggled
            
            self.MToggled = t
            self.Menu.Visible = t
            
            pcall(self.Flags[ t and 'Opened' or 'Closed'])
            
            twn(self.Icon, {Rotation = t and 0 or 180}, true)
        end
        
        base_class.s_ddoption_select_self = function(self) 
            local parent = self.Parent
            
            local objs = parent.Objects
            for i = 1, #objs do objs[i]:Deselect() end
            
            self.Selected = true
            parent.Selection = self.Name
            pcall(parent.Flags['Changed'], self.Name, self)
            
            if (parent.Primary) then
                local n = parent.Parent.Name 
                ModListModify(n, n .. ' <font color="#DFDFDF">['..self.Name..']</font>')
            end
            
            twn(self.Effect, {Size = s1}, true)
            
            return self
        end
        base_class.s_ddoption_deselect_self = function(self) 
            if (self.Selected) then 
                self.Selected = false
                twn(self.Effect, {Size = s2}, true)
            end
            
            return self
        end
        base_class.s_ddoption_selected_getstate = function(self) 
            return self.Selected
        end
        
        base_class.s_slider_getval = function(self) return self.CurrentVal end
        base_class.s_slider_setvalnum = function(self, nval) 
            local min = self.Min
            local cval = self.CurrentVal
            local pval = self.PreviousVal
            
            cval = round(mathClamp(nval, min, self.Max), self.Step)
            Configs[self.PName]["Extras"][self.Name] = cval
            saveSettings()
            
            if (pval ~= cval) then
                pval = cval
                local form = self.StepFormat
                
                self.SliderFill.Position = dimOffset(mathFloor((cval - min) * self.Ratio), 0)
                self.SliderAmnt.Text = form:format(cval)
                
                if (self.Primary) then
                    local n = self.Parent.Name 
                    ModListModify(n, n .. (' <font color="#DFDFDF">('..form..')</font>'):format(cval))
                end
                
                pcall(self.Flags.Changed, cval)
            end
            
            self.CurrentVal = cval
        end
        base_class.s_slider_setvalpos = function(self, xval) 
            local min = self.Min
            local cval = self.CurrentVal
            local pval = self.PreviousVal
            
            local pos_normalized = mathClamp(xval - self.SliderBg.AbsolutePosition.X, 0, self.SliderSize)
            
            cval = round((pos_normalized * self.RatioInverse)+min, self.Step)
            Configs[self.PName]["Extras"][self.Name] = cval
            saveSettings()
            
            if (pval ~= cval) then
                pval = cval
                local form = self.StepFormat
                
                self.SliderFill.Position = dimOffset(mathFloor((cval - min)*self.Ratio), 0)
                self.SliderAmnt.Text = form:format(cval)
                
                self.CurrentVal = cval
                
                if (self.Primary) then
                    local n = self.Parent.Name 
                    ModListModify(n, n .. (' <font color="#DFDFDF">('..form..')</font>'):format(cval))
                end
                
                pcall(self.Flags.Changed, cval)
            end
        end
    end
    -- Button funcs
    base_class.button_click = function(self) 
        pcall(self.Flags['Clicked'])
    end
    -- Slider funcs
    base_class.slider_setval = function(self, value) 
        value = tonumber(value)
        if not value then uierror('slider_setval','value','number') end
        
        local m1,m2,m3 = self.min, self.max, self.step
        value = mathClamp(round(value, m3),m1,m2)
        
        self.setval_internal(value)
    end
    base_class.slider_getval = function(self) 
        return self.value1
    end
    -- Input funcs
    base_class.input_gettxt = function(self) 
        return self.Text
    end
    
    -- Generic funcs
    base_class.generic_tooltip = function(self, tooltip) 
        if (tooltip) then
            self.Tooltip = tostring(tooltip)    
        else
            self.Tooltip = nil
        end
        return self 
    end
    base_class.generic_connect = function(self, flagname, func) 
        if (type(func) ~= 'function' and type(func) ~= 'nil') then
            uierror('generic_connect','func','function or type nil')
        end
        if (type(flagname) ~= 'string') then
            uierror('generic_connect','flagname','string')
        end
        
        self.Flags[flagname] = func
        return self 
    end
      -- Creation functions
    base_class.menu_create_module = function(self, text, Type, nohotkey) 
        Type = Type or 'Toggle'
        local M_IndexOffset = self.ZIndex+1
        
        if (Type == 'Toggle') then 
            ModListInit(text)
            
            
            
            
            local m_ModuleRoot
             local m_ModuleBackground
              local m_ModuleEnableEffect
               local m_ModuleEnableEffect2
              local m_Highlight
              local m_ModuleText
               local m_TextPadding
              local m_ModuleIcon
             local m_Menu
              local m_MenuListLayout
            
            do
                m_ModuleRoot = instNew('ImageButton')
                m_ModuleRoot.Size = dimNew(1, 0, 0, 25)
                m_ModuleRoot.AutomaticSize = 'Y'
                m_ModuleRoot.ClipsDescendants = false
                m_ModuleRoot.BackgroundTransparency = 1
                m_ModuleRoot.BorderSizePixel = 0
                m_ModuleRoot.ZIndex = M_IndexOffset-1
                m_ModuleRoot.Parent = self.Menu
                
                 m_ModuleBackground = instNew('Frame')
                 m_ModuleBackground.BackgroundColor3 = RLTHEMEDATA['bo'][1]
                 m_ModuleBackground.BackgroundTransparency = RLTHEMEDATA['bo'][2]
                 m_ModuleBackground.BorderSizePixel = 0
                 m_ModuleBackground.Size = dimNew(1,0,0,25)
                 m_ModuleBackground.ZIndex = M_IndexOffset
                 m_ModuleBackground.Parent = m_ModuleRoot
                 
                  m_Highlight = instNew('Frame')
                  m_Highlight.Active = false
                  m_Highlight.BackgroundColor3 = RLTHEMEDATA['ge'][1]
                  m_Highlight.BackgroundTransparency = 0.9
                  m_Highlight.BorderSizePixel = 0
                  m_Highlight.Size = dimScale(1,1)
                  m_Highlight.Visible = false
                  m_Highlight.ZIndex = M_IndexOffset
                  m_Highlight.Parent = m_ModuleBackground
                  
                  m_ModuleEnableEffect = instNew('Frame')
                  m_ModuleEnableEffect.BackgroundColor3 = RLTHEMEDATA['tm'][1]
                  m_ModuleEnableEffect.BackgroundTransparency = 0.92
                  m_ModuleEnableEffect.BorderSizePixel = 0
                  m_ModuleEnableEffect.ClipsDescendants = true
                  m_ModuleEnableEffect.Size = dimNew(0,0,1,0)
                  m_ModuleEnableEffect.ZIndex = M_IndexOffset
                  m_ModuleEnableEffect.Parent = m_ModuleBackground
                  
                   m_ModuleEnableEffect2 = instNew('Frame')
                   m_ModuleEnableEffect2.BackgroundColor3 = RLTHEMEDATA['ge'][1]
                   m_ModuleEnableEffect2.BorderSizePixel = 0
                   m_ModuleEnableEffect2.Size = dimNew(0,2,1,0)
                   m_ModuleEnableEffect2.ZIndex = M_IndexOffset
                   m_ModuleEnableEffect2.Parent = m_ModuleEnableEffect
                  
                  m_ModuleText = instNew('TextLabel')
                  m_ModuleText.BackgroundTransparency = 1
                  m_ModuleText.Font = RLTHEMEFONT
                  m_ModuleText.Position = dimOffset(0, 0)
                  m_ModuleText.RichText = true
                  m_ModuleText.Size = dimScale(1, 1)
                  m_ModuleText.Text = text
                  m_ModuleText.TextColor3 = RLTHEMEDATA['tm'][1]
                  m_ModuleText.TextSize = 20
                  m_ModuleText.TextStrokeColor3 = RLTHEMEDATA['to'][1]
                  m_ModuleText.TextStrokeTransparency = 0
                  m_ModuleText.TextXAlignment = 'Left'
                  m_ModuleText.ZIndex = M_IndexOffset
                  m_ModuleText.Parent = m_ModuleBackground
                  
                   m_TextPadding = instNew('UIPadding')
                   m_TextPadding.PaddingLeft = dimOffset(IndentLevel1, 0).X -- LEFT PADDING 1
                   m_TextPadding.Parent = m_ModuleText
                  
                  m_ModuleIcon = instNew('TextLabel')
                  m_ModuleIcon.AnchorPoint = vec2(1,0)
                  m_ModuleIcon.BackgroundTransparency = 1
                  m_ModuleIcon.Font = RLTHEMEFONT
                  m_ModuleIcon.Position = dimScale(1,0)
                  m_ModuleIcon.Rotation = 0
                  m_ModuleIcon.Size = dimOffset(25, 25)
                  m_ModuleIcon.Text = '+'
                  m_ModuleIcon.TextColor3 = RLTHEMEDATA['tm'][1]
                  m_ModuleIcon.TextSize = 18
                  m_ModuleIcon.TextStrokeColor3 = RLTHEMEDATA['to'][1]
                  m_ModuleIcon.TextStrokeTransparency = 0
                  m_ModuleIcon.TextXAlignment = 'Center'
                  m_ModuleIcon.ZIndex = M_IndexOffset
                  m_ModuleIcon.Parent = m_ModuleBackground
                
                m_Menu = instNew('Frame')
                m_Menu.BackgroundColor3 = RLTHEMEDATA['bs'][1]
                m_Menu.BackgroundTransparency = 1
                m_Menu.BorderSizePixel = 0
                m_Menu.Position = dimOffset(0,25)
                m_Menu.Size = dimNew(1,0,0,0)
                m_Menu.Visible = false
                m_Menu.ZIndex = M_IndexOffset-1
                m_Menu.Parent = m_ModuleRoot
                
                 m_MenuListLayout = instNew('UIListLayout')
                 m_MenuListLayout.FillDirection = 'Vertical'
                 m_MenuListLayout.SortOrder = 2
                 m_MenuListLayout.HorizontalAlignment = 'Left'
                 m_MenuListLayout.VerticalAlignment = 'Top'
                 m_MenuListLayout.Parent = m_Menu
                 
            end
                
            local M_Object = {} do 
                loadSettings()
                M_Object.Tooltip = nil
                
                M_Object.MToggled = false
                M_Object.OToggled = false
                
                M_Object.Flags = {} do 
                    M_Object.Flags['Enabled'] = true
                    M_Object.Flags['Disabled'] = true
                    M_Object.Flags['Toggled'] = true
                end
                
                M_Object.Name = text
                M_Object.Menu = m_Menu
                M_Object.Icon = m_ModuleIcon
                M_Object.Effect = m_ModuleEnableEffect
                M_Object.ZIndex = M_IndexOffset
                
                M_Object.Highlight = m_Highlight
                
                M_Object.Parent = self
                M_Object.Root = m_ModuleRoot
                
                M_Object.addToggle = base_class.module_create_toggle
                M_Object.AddLabel = base_class.module_create_label
                M_Object.addDropdown = base_class.module_create_dropdown
                M_Object.addModHotkey = base_class.module_create_modhotkey
                M_Object.AddHotkey = base_class.module_create_hotkey
                M_Object.addSlider = base_class.module_create_slider
                M_Object.AddInput = base_class.module_create_input
                M_Object.AddButton = base_class.module_create_button
                
                M_Object.setvis = base_class.module_setvis
                
                M_Object.Toggle = base_class.module_toggle_self
                M_Object.Disable = base_class.module_toggle_disable
                M_Object.Enable = base_class.module_toggle_enable
                M_Object.Reset = base_class.module_toggle_reset
                
                M_Object.ToggleMenu = base_class.module_toggle_menu
                M_Object.getState = base_class.module_getstate_self
                M_Object.isEnabled = base_class.module_getstate_self
                M_Object.GetMenuState = base_class.module_getstate_menu
                
                M_Object.Connect = base_class.generic_connect
                M_Object.setTooltip = base_class.generic_tooltip
            end
            
            do
                if not Configs[text] then
                    Configs[text] = {["Keybind"] = "", ["IsToggled"] = "", ["MenuToggled"] = "", ["Extras"] = {}}
                end
                if Configs[text] then
                    if Configs[text]["IsToggled"] == true then
                        M_Object:Toggle(true)
                    end
                    if Configs[text]["MenuToggled"] == true then
                        M_Object:ToggleMenu()
                    end
                end
                m_ModuleBackground.InputBegan:Connect(function(io) 
                    local uitv = io.UserInputType.Value
                    if (uitv == 0) then
                        M_Object:Toggle()
                        return
                    end
                    
                    if (uitv == 1) then
                        M_Object:ToggleMenu()
                        return
                    end
                end)
                
                m_ModuleBackground.MouseEnter:Connect(function() 
                    m_ModuleBackground.BackgroundColor3 = RLTHEMEDATA['ho'][1]
                    
                    
                    local tt = M_Object.Tooltip
                    if (tt) then
                        w_Tooltip.Text = tt
                        w_TooltipHeader.Text = M_Object.Name
                        w_TooltipHeader.Visible = true
                    end
                end)
                
                m_ModuleBackground.MouseLeave:Connect(function() 
                    m_ModuleBackground.BackgroundColor3 = RLTHEMEDATA['bo'][1]
                    
                    if (w_Tooltip.Text == M_Object.Tooltip) then
                        w_TooltipHeader.Visible = false
                    end
                end)
            end
            
            if (not nohotkey) then
                M_Object:addModHotkey() 
            end
            
            tabInsert(ui_Modules, M_Object)
            return M_Object
        elseif (Type == 'Textbox') then
            local m_ModuleRoot
             local m_ModuleBackground
             local m_ModuleEnableEffect
              local m_ModuleText
               local m_ModulePadding
              local m_ModuleIcon
            do
                m_ModuleRoot = instNew('Frame')
                m_ModuleRoot.AutomaticSize = 'Y'
                m_ModuleRoot.BackgroundTransparency = 1
                m_ModuleRoot.BorderSizePixel = 0
                m_ModuleRoot.Size = dimNew(1, 0, 0, 25)
                m_ModuleRoot.ZIndex = M_IndexOffset-1
                m_ModuleRoot.Parent = self.Menu
                
                 m_ModuleBackground = instNew('Frame')
                 m_ModuleBackground.BackgroundColor3 = RLTHEMEDATA['bo'][1]
                 m_ModuleBackground.BackgroundTransparency = RLTHEMEDATA['bo'][2]
                 m_ModuleBackground.BorderSizePixel = 0
                 m_ModuleBackground.Size = dimNew(1,0,0,25)
                 m_ModuleBackground.ZIndex = M_IndexOffset
                 m_ModuleBackground.Parent = m_ModuleRoot
                 
                  m_ModuleEnableEffect = instNew('Frame')
                  m_ModuleEnableEffect.BackgroundColor3 = RLTHEMEDATA['tm'][1]
                  m_ModuleEnableEffect.BackgroundTransparency = 1
                  m_ModuleEnableEffect.BorderSizePixel = 0
                  m_ModuleEnableEffect.ClipsDescendants = true
                  m_ModuleEnableEffect.Size = dimNew(1,0,1,0)
                  m_ModuleEnableEffect.ZIndex = M_IndexOffset
                  m_ModuleEnableEffect.Parent = m_ModuleBackground
                 
                 m_ModuleText = instNew('TextBox')
                 m_ModuleText.BackgroundTransparency = 1
                 m_ModuleText.ClearTextOnFocus = not nohotkey
                 m_ModuleText.Font = RLTHEMEFONT
                 m_ModuleText.Size = dimScale(1, 1)
                 m_ModuleText.Text = text
                 m_ModuleText.TextColor3 = RLTHEMEDATA['tm'][1]
                 m_ModuleText.TextSize = 20
                 m_ModuleText.TextStrokeColor3 = RLTHEMEDATA['to'][1]
                 m_ModuleText.TextStrokeTransparency = 0
                 m_ModuleText.TextWrapped = true
                 m_ModuleText.TextXAlignment = 'Left'
                 m_ModuleText.ZIndex = M_IndexOffset
                 m_ModuleText.Parent = m_ModuleBackground
                  
                  m_ModulePadding = instNew('UIPadding')
                  m_ModulePadding.PaddingLeft = dimOffset(IndentLevel1, 0).X
                  m_ModulePadding.Parent = m_ModuleText
                 
                 m_ModuleIcon = instNew('TextLabel')
                 m_ModuleIcon.Size = dimOffset(25, 25)
                 m_ModuleIcon.Position = dimScale(1,0)
                 m_ModuleIcon.AnchorPoint = vec2(1,0)
                 m_ModuleIcon.BackgroundTransparency = 1
                 m_ModuleIcon.Font = RLTHEMEFONT
                 m_ModuleIcon.TextXAlignment = 'Center'
                 m_ModuleIcon.TextColor3 = RLTHEMEDATA['tm'][1]
                 m_ModuleIcon.TextSize = 18
                 m_ModuleIcon.Text = '🅃'
                 m_ModuleIcon.TextStrokeTransparency = 0
                 m_ModuleIcon.TextStrokeColor3 = RLTHEMEDATA['to'][1]
                 m_ModuleIcon.Rotation = 0
                 m_ModuleIcon.ZIndex = M_IndexOffset
                 m_ModuleIcon.Parent = m_ModuleBackground
            end
                
            local M_Object = {} do 
                M_Object.Tooltip = nil
                
                
                M_Object.Flags = {} do 
                    M_Object.Flags['Focused'] = true
                    M_Object.Flags['Unfocused'] = true
                    M_Object.Flags['TextChanged'] = true
                end
                
                M_Object.Effect = m_ModuleEnableEffect
                
                M_Object.Name = text
                M_Object.ZIndex = M_IndexOffset
                                    
                M_Object.Connect = base_class.generic_connect
                M_Object.setTooltip = base_class.generic_tooltip
            end
            
            do
                m_ModuleBackground.MouseEnter:Connect(function() 
                    m_ModuleBackground.BackgroundColor3 = RLTHEMEDATA['ho'][1]
                    
                    
                    local tt = M_Object.Tooltip
                    if (tt) then
                        w_Tooltip.Text = tt
                        w_TooltipHeader.Text = M_Object.Name
                        w_TooltipHeader.Visible = true
                    end
                end)
                
                m_ModuleBackground.MouseLeave:Connect(function() 
                    m_ModuleBackground.BackgroundColor3 = RLTHEMEDATA['bo'][1]
                    
                    if (w_Tooltip.Text == M_Object.Tooltip) then
                        w_TooltipHeader.Visible = false
                    end
                end)
                
                m_ModuleText.FocusLost:Connect(function(enter) 
                    pcall(M_Object.Flags.Unfocused, m_ModuleText.Text, enter)
                    if (not nohotkey) then 
                        m_ModuleText.Text = M_Object.Name
                    end
                end)
                m_ModuleText.Focused:Connect(function() 
                    pcall(M_Object.Flags.Focused)
                end)
                m_ModuleText:GetPropertyChangedSignal('Text'):Connect(function() 
                    pcall(M_Object.Flags.TextChanged, m_ModuleText.Text)
                end)
            end
            
            tabInsert(ui_Modules, M_Object)
            return M_Object
        elseif (Type == 'Button') then
            local m_ModuleRoot
             local m_ModuleBackground
              local m_Highlight
              local m_ModuleEnableEffect
              local m_ModuleText
               local m_ModulePadding
              local m_ModuleIcon
            do
                m_ModuleRoot = instNew('Frame')
                m_ModuleRoot.Size = dimNew(1, 0, 0, 25)
                m_ModuleRoot.AutomaticSize = 'Y'
                m_ModuleRoot.BackgroundTransparency = 1
                m_ModuleRoot.BorderSizePixel = 0
                m_ModuleRoot.ZIndex = M_IndexOffset-1
                m_ModuleRoot.Parent = self.Menu
                
                 m_ModuleBackground = instNew('Frame')
                 m_ModuleBackground.BackgroundColor3 = RLTHEMEDATA['bo'][1]
                 m_ModuleBackground.BackgroundTransparency = RLTHEMEDATA['bo'][2]
                 m_ModuleBackground.BorderSizePixel = 0
                 m_ModuleBackground.Size = dimNew(1,0,0,25)
                 m_ModuleBackground.ZIndex = M_IndexOffset
                 m_ModuleBackground.Parent = m_ModuleRoot
                 
                 
                  m_ModuleEnableEffect = instNew('Frame')
                  m_ModuleEnableEffect.BackgroundColor3 = RLTHEMEDATA['tm'][1]
                  m_ModuleEnableEffect.BackgroundTransparency = 1
                  m_ModuleEnableEffect.ClipsDescendants = true
                  m_ModuleEnableEffect.Size = dimNew(1,0,1,0)
                  m_ModuleEnableEffect.BorderSizePixel = 0
                  m_ModuleEnableEffect.ZIndex = M_IndexOffset
                  m_ModuleEnableEffect.Parent = m_ModuleBackground
                  
                  m_Highlight = instNew('Frame')
                  m_Highlight.Size = dimScale(1,1)
                  m_Highlight.BackgroundColor3 = RLTHEMEDATA['ge'][1]
                  m_Highlight.BackgroundTransparency = 0.9
                  m_Highlight.Visible = false
                  m_Highlight.ZIndex = M_IndexOffset
                  m_Highlight.BorderSizePixel = 0
                  m_Highlight.Parent = m_ModuleBackground
                 
                 m_ModuleText = instNew('TextLabel')
                 m_ModuleText.BackgroundTransparency = 1
                 m_ModuleText.Font = RLTHEMEFONT
                 m_ModuleText.Position = dimOffset(0, 0)
                 m_ModuleText.RichText = true
                 m_ModuleText.Size = dimNew(1, 0, 1, 0)
                 m_ModuleText.Text = text
                 m_ModuleText.TextColor3 = RLTHEMEDATA['tm'][1]
                 m_ModuleText.TextSize = 20
                 m_ModuleText.TextStrokeColor3 = RLTHEMEDATA['to'][1]
                 m_ModuleText.TextStrokeTransparency = 0
                 m_ModuleText.TextXAlignment = 'Left'
                 m_ModuleText.ZIndex = M_IndexOffset
                 m_ModuleText.Parent = m_ModuleBackground
                 
                 m_ModulePadding = instNew('UIPadding')
                 m_ModulePadding.PaddingLeft = dimOffset(IndentLevel1, 0).X
                 m_ModulePadding.Parent = m_ModuleText
                 
                 m_ModuleIcon = instNew('ImageLabel')
                 m_ModuleIcon.AnchorPoint = vec2(1,0.5)
                 m_ModuleIcon.BackgroundTransparency = 1
                 m_ModuleIcon.Position = dimNew(1,-6, 0.5, 0)
                 m_ModuleIcon.Rotation = 0
                 m_ModuleIcon.Size = dimOffset(12, 12)
                 m_ModuleIcon.Image = 'rbxassetid://8997446977'
                 m_ModuleIcon.ImageColor3 = RLTHEMEDATA['tm'][1]
                 m_ModuleIcon.ZIndex = M_IndexOffset
                 m_ModuleIcon.Parent = m_ModuleBackground
            end
                
            local M_Object = {} do 
                M_Object.Tooltip = nil
                
                
                M_Object.Flags = {} do 
                    M_Object.Flags['Clicked'] = true
                end
                
                M_Object.setvis = base_class.module_setvis
                M_Object.Root = m_ModuleRoot
                
                M_Object.Highlight = m_Highlight
                
                
                M_Object.Effect = m_ModuleEnableEffect
                
                M_Object.Name = text
                M_Object.ZIndex = M_IndexOffset
                
                M_Object.Click = base_class.module_click_self
                
                M_Object.Connect = base_class.generic_connect
                M_Object.setTooltip = base_class.generic_tooltip
            end
            
            do
                m_ModuleBackground.InputBegan:Connect(function(io) 
                    local uitv = io.UserInputType.Value
                    if (uitv == 0) then
                        M_Object:Click()
                        return
                    end
                end)
                
                m_ModuleBackground.MouseEnter:Connect(function() 
                    m_ModuleBackground.BackgroundColor3 = RLTHEMEDATA['ho'][1]
                    
                    
                    local tt = M_Object.Tooltip
                    if (tt) then
                        w_Tooltip.Text = tt
                        w_TooltipHeader.Text = M_Object.Name
                        w_TooltipHeader.Visible = true
                    end
                end)
                
                m_ModuleBackground.MouseLeave:Connect(function() 
                    m_ModuleBackground.BackgroundColor3 = RLTHEMEDATA['bo'][1]
                    
                    if (w_Tooltip.Text == M_Object.Tooltip) then
                        w_TooltipHeader.Visible = false
                    end
                end)
            end
            
            tabInsert(ui_Modules, M_Object)
            return M_Object
        end
    end
    base_class.module_create_label = function(self, text) 
        text = tostring(text)
                    
        local T_IndexOffset = self.ZIndex+1
        local t_Text
         local t_Padding
        do
            t_Text = instNew('TextLabel')
            t_Text.BackgroundColor3 = RLTHEMEDATA['bs'][1]
            t_Text.BackgroundTransparency = RLTHEMEDATA['bs'][2]
            t_Text.BorderSizePixel = 0
            t_Text.Font = RLTHEMEFONT
            t_Text.Parent = self.Menu
            t_Text.RichText = true
            t_Text.Size = dimNew(1, 0, 0, 25)
            t_Text.Text = text
            t_Text.TextColor3 = RLTHEMEDATA['tm'][1]
            t_Text.TextSize = 18
            t_Text.TextStrokeColor3 = RLTHEMEDATA['to'][1]
            t_Text.TextStrokeTransparency = 0
            t_Text.TextWrapped = true
            t_Text.TextXAlignment = 'Left'
            t_Text.TextYAlignment = 'Center'
            t_Text.ZIndex = T_IndexOffset
            
            t_Padding = instNew('UIPadding')
            t_Padding.PaddingLeft = dimOffset(IndentLevel2, 0).X -- LEFT PADDING 2
            t_Padding.Parent = t_Text
        end
        
        for i = 1, 25 do 
            if (t_Text.TextFits) then
                break
            end
            t_Text.Size += dimOffset(0,25)
        end
            
        local T_Object = {} do 
            T_Object.Tooltip = nil
            T_Object.Toggled = false
            
            T_Object.Name = text
            T_Object.setTooltip = base_class.generic_tooltip
        end
        
        do
            t_Text.MouseEnter:Connect(function()                     
                local tt = T_Object.Tooltip
                if (tt) then
                    w_Tooltip.Text = tt
                    w_TooltipHeader.Text = T_Object.Name
                    w_TooltipHeader.Visible = true
                end
            end)
            
            t_Text.MouseLeave:Connect(function() 
                
                if (w_Tooltip.Text == T_Object.Tooltip) then
                    w_TooltipHeader.Visible = false
                end
            end)
        end
        
        return T_Object            
    end
    base_class.module_create_toggle = function(self, text) 
        text = tostring(text)
        
        local T_IndexOffset = self.ZIndex+1
        
        
        local t_Toggle
         local t_Box1
          local t_Box2
         local t_Text
          local t_TextPadding
        
        do
            t_Toggle = instNew('Frame')
            t_Toggle.BackgroundColor3 = RLTHEMEDATA['bs'][1]
            t_Toggle.BackgroundTransparency = RLTHEMEDATA['bs'][2]
            t_Toggle.BorderSizePixel = 0
            t_Toggle.Size = dimNew(1, 0, 0, 25)
            t_Toggle.ZIndex = T_IndexOffset
            t_Toggle.Parent = self.Menu
             
             t_Text = instNew('TextLabel')
             t_Text.Size = dimScale(1, 1)
             t_Text.BackgroundTransparency = 1
             t_Text.Font = RLTHEMEFONT
             t_Text.TextXAlignment = 'Left'
             t_Text.TextColor3 = RLTHEMEDATA['tm'][1]
             t_Text.TextSize = 18
             t_Text.Text = text
             t_Text.TextStrokeTransparency = 0
             t_Text.TextStrokeColor3 = RLTHEMEDATA['to'][1]
             t_Text.ZIndex = T_IndexOffset
             t_Text.Parent = t_Toggle
             
              t_TextPadding = instNew('UIPadding')
              t_TextPadding.PaddingLeft = dimOffset(IndentLevel2, 0).X -- LEFT PADDING 2
              t_TextPadding.Parent = t_Text
             
             t_Box1 = instNew('Frame')
             t_Box1.AnchorPoint = vec2(1,0)
             t_Box1.BackgroundColor3 = RLTHEMEDATA['sf'][1]
             t_Box1.BackgroundTransparency = 1
             t_Box1.BorderSizePixel = 0
             t_Box1.Position = dimNew(1,-RightIndent,0.5,-5) -- RIGHT PADDING
             t_Box1.Size = dimOffset(10, 10)
             t_Box1.ZIndex = T_IndexOffset
             t_Box1.Parent = t_Toggle
             
             stroke(t_Box1)
             
             t_Box2 = instNew('Frame')
             t_Box2.Size = dimOffset(8, 8)
             t_Box2.Position = dimOffset(1,1)
             t_Box2.BackgroundTransparency = 1
             t_Box2.BackgroundColor3 = RLTHEMEDATA['ge'][1]
             t_Box2.BorderSizePixel = 0
             t_Box2.Visible = true
             t_Box2.ZIndex = T_IndexOffset
             t_Box2.Parent = t_Box1
        end
            
        local T_Object = {} do 
            T_Object.Tooltip = nil
            T_Object.Toggled = false
            
            T_Object.Flags = {}
            T_Object.Flags['Enabled'] = true
            T_Object.Flags['Disabled'] = true
            T_Object.Flags['Toggled'] = true
            
            T_Object.Icon = t_Box2
            T_Object.Name = text
            T_Object.PName = self.Name
            
            T_Object.Toggle = base_class.s_toggle_self
            T_Object.Disable = base_class.s_toggle_disable
            T_Object.Enable = base_class.s_toggle_enable
            T_Object.Reset = base_class.s_toggle_reset
            T_Object.getState = base_class.s_toggle_getstate
            T_Object.getValue = base_class.s_toggle_getstate
            T_Object.isEnabled = base_class.s_toggle_getstate
            
            T_Object.Connect = base_class.generic_connect
            T_Object.setTooltip = base_class.generic_tooltip
        end
        
        do
            if Configs[self.Name] then
                if Configs[self.Name]["Extras"][text] == true then
                    T_Object:Toggle()
                end
            end
            t_Toggle.InputBegan:Connect(function(io) 
                local uitv = io.UserInputType.Value
                if (uitv == 0) then
                    T_Object:Toggle()
                    return
                end
            end)
            
            t_Toggle.MouseEnter:Connect(function() 
                t_Toggle.BackgroundColor3 = RLTHEMEDATA['hs'][1]
                
                local tt = T_Object.Tooltip
                if (tt) then
                    w_Tooltip.Text = tt
                    w_TooltipHeader.Text = T_Object.Name
                    w_TooltipHeader.Visible = true
                end
            end)
            
            t_Toggle.MouseLeave:Connect(function() 
                t_Toggle.BackgroundColor3 = RLTHEMEDATA['bs'][1]
                
                if (w_Tooltip.Text == T_Object.Tooltip) then
                    w_TooltipHeader.Visible = false
                end
            end)
        end
        
        return T_Object            
    end
    base_class.module_create_dropdown = function(self, text, primary) 
        text = tostring(text)
        primary = primary or false
        
        local D_IndexOffset = self.ZIndex+1
        
        local d_Root
         local d_Header
          local d_HeaderText
           local d_TextPadding
          local d_HeaderIcon
          
          
          local d_Menu
           local d_MenuListLayout
        
        do
            d_Root = instNew('Frame')
            d_Root.Size = dimNew(1, 0, 0, 25)
            d_Root.AutomaticSize = 'Y'
            d_Root.BackgroundTransparency = 1
            d_Root.BorderSizePixel = 0
            d_Root.ZIndex = D_IndexOffset-1
            d_Root.Parent = self.Menu
        
             d_Header = instNew('Frame')
             d_Header.Active = true
             d_Header.BackgroundColor3 = RLTHEMEDATA['bs'][1]
             d_Header.BackgroundTransparency = RLTHEMEDATA['bs'][2]
             d_Header.BorderSizePixel = 0
             d_Header.Size = dimNew(1, 0, 0, 25)
             d_Header.ZIndex = D_IndexOffset+1
             d_Header.Parent = d_Root
             
              d_HeaderText = instNew('TextLabel')
              d_HeaderText.Size = dimScale(1, 1)
              d_HeaderText.BackgroundTransparency = 1
              d_HeaderText.Font = RLTHEMEFONT
              d_HeaderText.TextXAlignment = 'Left'
              d_HeaderText.TextColor3 = RLTHEMEDATA['tm'][1]
              d_HeaderText.TextSize = 18
              d_HeaderText.Text = text
              d_HeaderText.TextStrokeTransparency = 0
              d_HeaderText.TextStrokeColor3 = RLTHEMEDATA['to'][1]
              d_HeaderText.ZIndex = D_IndexOffset+1
              d_HeaderText.Parent = d_Header
              
               d_TextPadding = instNew('UIPadding')
               d_TextPadding.PaddingLeft = dimOffset(IndentLevel2, 0).X -- LEFT PADDING 2
               d_TextPadding.Parent = d_HeaderText
              
              d_HeaderIcon = instNew('ImageLabel')
              d_HeaderIcon.Size = dimOffset(25, 25)
              d_HeaderIcon.Position = dimNew(1,-RightIndent +10, 0, 0) -- RIGHT PADDING
              d_HeaderIcon.AnchorPoint = vec2(1,0)
              d_HeaderIcon.BackgroundTransparency = 1
              d_HeaderIcon.ImageColor3 = RLTHEMEDATA['tm'][1]
              d_HeaderIcon.Image = 'rbxassetid://7184113125'
              d_HeaderIcon.Rotation = 180
              d_HeaderIcon.ZIndex = D_IndexOffset+1
              d_HeaderIcon.Parent = d_Header
             
             d_Menu = instNew('Frame')
             d_Menu.Size = dimNew(1,0,0,0)
             d_Menu.AutomaticSize = 'Y'
             d_Menu.Position = dimOffset(0, 25)
             d_Menu.BackgroundColor3 = RLTHEMEDATA['bd'][1]
             d_Menu.BackgroundTransparency = 1
             d_Menu.BorderSizePixel = 0
             d_Menu.ZIndex = D_IndexOffset
             d_Menu.Visible = false
             d_Menu.Parent = d_Header
             
              d_MenuListLayout = instNew('UIListLayout')
              d_MenuListLayout.FillDirection = 'Vertical'
              d_MenuListLayout.HorizontalAlignment = 'Left'
              d_MenuListLayout.VerticalAlignment = 'Top'
              d_MenuListLayout.Parent = d_Menu
        end
        
        local D_Object = {} do 
            D_Object.Tooltip = nil
            D_Object.MToggled = false
            
            D_Object.Primary = primary
            
            D_Object.Menu = d_Menu
            D_Object.Name = text
            D_Object.Parent = self
            D_Object.Icon = d_HeaderIcon
            D_Object.ZIndex = D_IndexOffset
            
            D_Object.Selection = nil
            
            D_Object.Objects = {}
            
            
            D_Object.Flags = {}
            D_Object.Flags['Changed'] = true
            D_Object.Flags['Opened'] = true
            D_Object.Flags['Closed'] = true
            
            D_Object.Toggle = base_class.s_dropdown_toggle
            D_Object.GetSelection = base_class.s_dropdown_getselection
            D_Object.getValue = base_class.s_dropdown_getselection
            
            D_Object.Connect = base_class.generic_connect
            D_Object.setTooltip = base_class.generic_tooltip
            D_Object.addOption = base_class.dropdown_create_option
        end
        
        do
            d_Header.InputBegan:Connect(function(io) 
                local uitv = io.UserInputType.Value
                if (uitv == 0 or uitv == 1) then
                    D_Object:Toggle()
                    return
                end
            end)
            
            d_Header.MouseEnter:Connect(function() 
                d_Header.BackgroundColor3 = RLTHEMEDATA['hs'][1]
                
                local tt = D_Object.Tooltip
                if (tt) then
                    w_Tooltip.Text = tt
                    w_TooltipHeader.Text = D_Object.Name
                    w_TooltipHeader.Visible = true
                end
            end)
            
            d_Header.MouseLeave:Connect(function() 
                d_Header.BackgroundColor3 = RLTHEMEDATA['bs'][1]
                
                if (w_Tooltip.Text == D_Object.Tooltip) then
                    w_TooltipHeader.Visible = false
                end
            end)
        end
        
        return D_Object
    end
    base_class.module_create_modhotkey = function(self, hotkey) 
        local H_IndexOffset = self.ZIndex+1
        
        local h_Hotkey
         local h_Text
          local h_TextPadding
        
        do
            h_Hotkey = instNew('Frame')
            h_Hotkey.BackgroundColor3 = RLTHEMEDATA['bs'][1]
            h_Hotkey.BackgroundTransparency = RLTHEMEDATA['bs'][2]
            h_Hotkey.BorderSizePixel = 0
            h_Hotkey.Size = dimNew(1, 0, 0, 25)
            h_Hotkey.ZIndex = H_IndexOffset
            h_Hotkey.Parent = self.Menu
             
             h_Text = instNew('TextLabel')
             h_Text.Size = dimScale(1, 1)
             h_Text.BackgroundTransparency = 1
             h_Text.Font = RLTHEMEFONT
             h_Text.TextXAlignment = 'Left'
             h_Text.TextColor3 = RLTHEMEDATA['tm'][1]
             h_Text.TextSize = 18
             h_Text.Text = 'Hotkey: N/A'
             h_Text.TextStrokeTransparency = 0
             h_Text.TextStrokeColor3 = RLTHEMEDATA['to'][1]
             h_Text.ZIndex = H_IndexOffset
             h_Text.Parent = h_Hotkey
             
              h_TextPadding = instNew('UIPadding')
              h_TextPadding.PaddingLeft = dimOffset(IndentLevel2, 0).X -- LEFT PADDING 2
              h_TextPadding.Parent = h_Text
                
        end
            
        local H_Object = {} do 
            H_Object.Label = h_Text
            H_Object.Hotkey = nil
            
            H_Object.Parent = self
            H_Object.Tooltip = nil
            
            H_Object.Flags = {}
            H_Object.Flags['HotkeySet'] = true
            
            H_Object.setHotkey = base_class.s_modhotkey_sethotkey
            H_Object.setNewHotKey = base_class.s_modhoykey_setnewhotkey
            H_Object.GetHotkey = base_class.s_modhotkey_gethotkey
            H_Object.getValue = base_class.s_modhotkey_gethotkey
            
            H_Object.Connect = base_class.generic_connect
            H_Object.setTooltip = base_class.generic_tooltip
        end
        
        do
            if Configs[self.Name] then
                if Configs[self.Name]["Keybind"] ~= "" then
                    H_Object:setNewHotKey(Configs[self.Name]["Keybind"])
                end
            end
            -- H_Object:setNewHotKey(Enum.KeyCode.R)
            h_Hotkey.InputBegan:Connect(function(io) 
                local uitv = io.UserInputType.Value
                if (uitv == 0) then
                    H_Object:setHotkey()
                    return
                end
            end)
            
            h_Hotkey.MouseEnter:Connect(function() 
                h_Hotkey.BackgroundColor3 = RLTHEMEDATA['hs'][1]
            end)
            
            h_Hotkey.MouseLeave:Connect(function() 
                h_Hotkey.BackgroundColor3 = RLTHEMEDATA['bs'][1]
            end)
        end
        
        return H_Object   
    end
    base_class.module_create_hotkey = function(self, text) 
        local H_IndexOffset = self.ZIndex+1
        
        local h_Hotkey
         local h_Text
          local h_TextPadding
        
        do
            h_Hotkey = instNew('Frame')
            h_Hotkey.BackgroundColor3 = RLTHEMEDATA['bs'][1]
            h_Hotkey.BackgroundTransparency = RLTHEMEDATA['bs'][2]
            h_Hotkey.BorderSizePixel = 0
            h_Hotkey.Size = dimNew(1, 0, 0, 25)
            h_Hotkey.ZIndex = H_IndexOffset
            h_Hotkey.Parent = self.Menu
             
             h_Text = instNew('TextLabel')
             h_Text.Size = dimScale(1, 1)
             h_Text.BackgroundTransparency = 1
             h_Text.Font = RLTHEMEFONT
             h_Text.TextXAlignment = 'Left'
             h_Text.TextColor3 = RLTHEMEDATA['tm'][1]
             h_Text.TextSize = 18
             h_Text.Text = tostring(text)..': N/A'
             h_Text.TextStrokeTransparency = 0
             h_Text.TextStrokeColor3 = RLTHEMEDATA['to'][1]
             h_Text.ZIndex = H_IndexOffset
             h_Text.Parent = h_Hotkey
             
             h_TextPadding = instNew('UIPadding')
             h_TextPadding.PaddingLeft = dimOffset(IndentLevel2, 0).X -- LEFT PADDING 2
             h_TextPadding.Parent = h_Text
        end
            
        local H_Object = {} do 
            H_Object.Label = h_Text
            H_Object.Hotkey = nil
            
            H_Object.Parent = self
            H_Object.Tooltip = nil
            
            H_Object.Name = tostring(text)
            H_Object.Flags = {}
            H_Object.Flags['HotkeySet'] = true
            
            H_Object.bind = base_class.s_hotkey_sethotkey
            H_Object.setHotkey = base_class.s_hotkey_sethotkeyexplicit
            H_Object.GetHotkey = base_class.s_hotkey_gethotkey
            H_Object.getValue = base_class.s_hotkey_gethotkey
            
            H_Object.Connect = base_class.generic_connect
            H_Object.setTooltip = base_class.generic_tooltip
        end
        
        do
            h_Hotkey.InputBegan:Connect(function(io) 
                local uitv = io.UserInputType.Value
                if (uitv == 0) then
                    H_Object:bind()
                    return
                end
            end)
            
            h_Hotkey.MouseEnter:Connect(function() 
                h_Hotkey.BackgroundColor3 = RLTHEMEDATA['hs'][1]
                
                local tt = H_Object.Tooltip
                if (tt) then
                    w_Tooltip.Text = tt
                    w_TooltipHeader.Text = H_Object.Name
                    w_TooltipHeader.Visible = true
                end
            end)
            
            h_Hotkey.MouseLeave:Connect(function() 
                h_Hotkey.BackgroundColor3 = RLTHEMEDATA['bs'][1]
                
                if (w_Tooltip.Text == H_Object.Tooltip) then
                    w_TooltipHeader.Visible = false
                end
            end)
        end
        
        return H_Object   
    end
    base_class.module_create_slider = function(self, text, args, primary) 
        text = tostring(text)
        local newval = nil
        if Configs[self.Name] then
            if typeof(Configs[self.Name]["Extras"][text]) == "number" then
                NewValue = Configs[self.Name]["Extras"][text]
            end
        end
        
        args['min'] = args['min'] or 0
        args['max'] = args['max'] or 100
        args['cur'] = NewValue or args['cur'] or args['min']
        args['step'] = args['step'] or 1
        
        
        local S_IndexOffset = self.ZIndex+1
        
        local s_Slider
         local s_InputBox
         local s_Text
          local s_TextPad
         local s_Amount
         local s_SliderBarBg
          local s_SliderBar
          
        do
            s_Slider = instNew('Frame')
            s_Slider.BackgroundColor3 = RLTHEMEDATA['bs'][1]
            s_Slider.BackgroundTransparency = RLTHEMEDATA['bs'][2]
            s_Slider.BorderSizePixel = 0
            s_Slider.Size = dimNew(1, 0, 0, 25)
            s_Slider.ZIndex = S_IndexOffset
            s_Slider.Parent = self.Menu
             
             s_InputBox = instNew('TextBox')
             s_InputBox.BackgroundColor3 = RLTHEMEDATA['bs'][1]
             s_InputBox.BackgroundTransparency = 0.1--RLTHEMEDATA['bs'][2]
             s_InputBox.BorderSizePixel = 0
             s_InputBox.Font = RLTHEMEFONT
             s_InputBox.Size = dimNew(1, 0, 1, 0)
             s_InputBox.PlaceholderText = 'Enter new value'
             s_InputBox.TextColor3 = RLTHEMEDATA['tm'][1]
             s_InputBox.TextSize = 18
             s_InputBox.TextStrokeColor3 = RLTHEMEDATA['to'][1]
             s_InputBox.TextStrokeTransparency = 0
             s_InputBox.TextXAlignment = 'Center'
             s_InputBox.Visible = false
             s_InputBox.ZIndex = S_IndexOffset + 3
             s_InputBox.Parent = s_Slider
             
             s_Text = instNew('TextLabel')
             s_Text.BackgroundColor3 = RLTHEMEDATA['bs'][1]
             s_Text.BackgroundTransparency = 0.2
             s_Text.BorderSizePixel = 0
             s_Text.Font = RLTHEMEFONT
             s_Text.Size = dimScale(1, 1)
             s_Text.Text = text
             s_Text.TextColor3 = RLTHEMEDATA['tm'][1]
             s_Text.TextSize = 18
             s_Text.TextStrokeColor3 = RLTHEMEDATA['to'][1]
             s_Text.TextStrokeTransparency = 0
             s_Text.TextXAlignment = 'Left'
             s_Text.Visible = true
             s_Text.ZIndex = S_IndexOffset + 1
             s_Text.Parent = s_Slider
              
              s_TextPad = instNew('UIPadding')
              s_TextPad.PaddingLeft = dimOffset(IndentLevel2, 0).X -- LEFT PADDING 2
              s_TextPad.Parent = s_Text 
             
             s_Amount = instNew('TextLabel')
             s_Amount.Size = dimNew(0, 30, 1, 0)
             s_Amount.Position = dimNew(1,-RightIndent, 0, 0) -- RIGHT PADDING
             s_Amount.AnchorPoint = vec2(1,0)
             s_Amount.BackgroundTransparency = 1
             s_Amount.BorderSizePixel = 0
             s_Amount.Font = RLTHEMEFONT
             s_Amount.TextXAlignment = 'Right'
             s_Amount.TextColor3 = RLTHEMEDATA['tm'][1]
             s_Amount.TextSize = 18
             s_Amount.Visible = true
             s_Amount.TextStrokeTransparency = 0
             s_Amount.TextStrokeColor3 = RLTHEMEDATA['to'][1]
             s_Amount.ZIndex = S_IndexOffset + 1 
             s_Amount.Parent = s_Slider
             
             s_SliderBarBg = instNew('Frame')
             s_SliderBarBg.BackgroundColor3 = RLTHEMEDATA['sb'][1]
             s_SliderBarBg.BackgroundTransparency = RLTHEMEDATA['sb'][2]
             s_SliderBarBg.BorderSizePixel = 0
             s_SliderBarBg.ClipsDescendants = true
             s_SliderBarBg.Position = dimNew(0, 8, 0.5, -3)
             s_SliderBarBg.Size = dimNew(1, -16, 0, 6)
             s_SliderBarBg.ZIndex = S_IndexOffset
             s_SliderBarBg.Parent = s_Slider
             
              s_SliderBar = instNew('Frame')
              s_SliderBar.Size = dimScale(1, 1)
              s_SliderBar.Position = dimNew(0,0)
              s_SliderBar.AnchorPoint = vec2(1, 0)
              s_SliderBar.BackgroundColor3 = RLTHEMEDATA['sf'][1]
              s_SliderBar.BackgroundTransparency = RLTHEMEDATA['sf'][2]
              s_SliderBar.BorderSizePixel = 0
              s_SliderBar.ZIndex = S_IndexOffset
              s_SliderBar.Parent = s_SliderBarBg
              
            stroke(s_SliderBarBg, nil, 0.7)
             
        end
        
        local StepFormat
        
        if (args['step'] < 1) then
            StepFormat = (
                '%.'..
                (
                    (('%.0e'):format(args['step'])):match('e%-0(%d)')
                )..
                'f'
            )
            
            if (StepFormat == '%.f') then
                error('FATAL ERROR WHEN MAKING SLIDER\nCOULDN\'T MAKE STEPFORMAT PROPERLY\nTELL ME IF YOU SEE THIS')
                return
            end
        else
            StepFormat = '%d'
        end
        
        s_Amount.Text = StepFormat:format(args['cur'])
        
        
        local DragConn
            
        local S_Object = {} do 
            S_Object.Tooltip = nil
            S_Object.Name = text
            S_Object.PName = self.Name
            
            S_Object.SliderFill = s_SliderBar
            S_Object.SliderBg = s_SliderBarBg
            S_Object.SliderAmnt = s_Amount
            
            
            S_Object.SliderSize = s_SliderBarBg.AbsoluteSize.X
            
            S_Object.CurrentVal = args['cur']
            S_Object.PreviousVal = nil
            S_Object.Min = args['min']
            S_Object.Max = args['max']
            S_Object.Step = args['step']
            S_Object.Ratio = S_Object.SliderSize / (S_Object.Max - S_Object.Min)
            S_Object.RatioInverse = 1 / S_Object.Ratio
            S_Object.StepFormat = StepFormat
            
            
            S_Object.Parent = self
            S_Object.Primary = primary or false
            
            
            
            S_Object.Flags = {}
            S_Object.Flags['Changed'] = true
            
            S_Object.getValue = base_class.s_slider_getval
            S_Object.SetValue = base_class.s_slider_setvalnum
            S_Object.SetValuePos = base_class.s_slider_setvalpos
            
            S_Object.Connect = base_class.generic_connect
            S_Object.setTooltip = base_class.generic_tooltip
        end
        
        S_Object:SetValue(args['cur'])
        
        do
            s_Slider.MouseEnter:Connect(function() 
                s_Slider.BackgroundColor3 = RLTHEMEDATA['hs'][1]
                
                s_Amount.TextXAlignment = 'Center'
                twn(s_Text, {BackgroundTransparency = 1, TextTransparency = 1, TextStrokeTransparency = 1},true)
                twn(s_Amount, {Position = dimNew(0.5,IndentLevel2,0,0)}, true) -- LEFT PADDING 2
                
                local tt = S_Object.Tooltip
                if (tt) then
                    w_Tooltip.Text = tt
                    w_TooltipHeader.Text = S_Object.Name
                    w_TooltipHeader.Visible = true
                end
            end)
            
            s_Slider.MouseLeave:Connect(function() 
                s_Slider.BackgroundColor3 = RLTHEMEDATA['bs'][1]
                -- deez nuts
                s_Amount.TextXAlignment = 'Right'
                twn(s_Text, {BackgroundTransparency = 0.2, TextTransparency = 0, TextStrokeTransparency = 0},true)
                twn(s_Amount, {Position = dimNew(1,-RightIndent,0,0)}, true) -- RIGHT PADDING
                
                if (w_Tooltip.Text == S_Object.Tooltip) then
                    w_TooltipHeader.Visible = false
                end
            end)
            
            s_Slider.InputBegan:Connect(function(io) 
                local v = io.UserInputType.Value
                if (v == 0) then
                    S_Object:SetValuePos(io.Position.X)
                    
                    DragConn = servInput.InputChanged:Connect(function(io) 
                        if (io.UserInputType.Value == 4) then
                            S_Object:SetValuePos(io.Position.X)
                        end
                    end)
                elseif (v == 1) then
                    s_InputBox.Visible = true
                    s_InputBox:CaptureFocus()
                    s_InputBox.Text = ''
                end
            end)
            
            s_Slider.InputEnded:Connect(function(io) 
                if (io.UserInputType.Value == 0) then
                    DragConn:Disconnect()
                end
            end)
            
            s_InputBox.FocusLost:Connect(function(enter) 
                if not enter then return end
                
                local t = s_InputBox.Text
                local a = tonumber(t)
                if (a == nil) then
                    if (t == '') then
                        s_InputBox.Visible = false
                    else
                        s_InputBox.Text = 'Not a number'
                    end
                else
                    S_Object:SetValue(a)
                    s_InputBox.Visible = false
                end
            end)
        end
        return S_Object            
    end
    base_class.module_create_input = function(self, text) 
        text = tostring(text)
        local I_IndexOffset = self.ZIndex + 1 
        
        local i_Input
         local i_TextPad
         local i_Icon
        do
            
            i_Input = instNew('TextBox')
            i_Input.BackgroundColor3 = RLTHEMEDATA['bs'][1]
            i_Input.BackgroundTransparency = RLTHEMEDATA['bs'][2]
            i_Input.BorderSizePixel = 0 
            i_Input.ClearTextOnFocus = true
            i_Input.Font = RLTHEMEFONT
            i_Input.Size = dimNew(1, 0, 0, 25)
            i_Input.Text = text
            i_Input.TextColor3 = RLTHEMEDATA['tm'][1]
            i_Input.TextSize = 18
            i_Input.TextStrokeColor3 = RLTHEMEDATA['to'][1]
            i_Input.TextStrokeTransparency = 0
            i_Input.TextWrapped = true
            i_Input.TextXAlignment = 'Left'
            i_Input.ZIndex = I_IndexOffset
            i_Input.Parent = self.Menu
             
             i_TextPad = instNew('UIPadding')
             i_TextPad.PaddingLeft = dimOffset(IndentLevel2, 0).X -- LEFT PADDING 2
             i_TextPad.Parent = i_Input
            
            i_Icon = instNew('ImageLabel')
            i_Icon.AnchorPoint = vec2(1,0.5)
            i_Icon.Position = dimNew(1,-4, 0.5, 0)                
            i_Icon.BackgroundTransparency = 1
            i_Icon.Image = 'rbxassetid://8997447289'
            i_Icon.Rotation = 0
            i_Icon.Size = dimOffset(12, 12)
            i_Icon.ZIndex = I_IndexOffset
            i_Icon.Parent = i_Input
        end
            
        local I_Object = {} do 
            I_Object.Tooltip = nil
            
            
            I_Object.Flags = {} do 
                I_Object.Flags['Focused'] = true
                I_Object.Flags['Unfocused'] = true
                I_Object.Flags['TextChanged'] = true
            end
            
            I_Object.Name = text
            I_Object.ZIndex = I_IndexOffset
            
            I_Object.Connect = base_class.generic_connect
            I_Object.setTooltip = base_class.generic_tooltip
        end
        
        do
            i_Input.MouseEnter:Connect(function() 
                i_Input.BackgroundColor3 = RLTHEMEDATA['hs'][1]
                
                
                local tt = I_Object.Tooltip
                if (tt) then
                    w_Tooltip.Text = tt
                    w_TooltipHeader.Text = I_Object.Name
                    w_TooltipHeader.Visible = true
                end
            end)
            
            i_Input.MouseLeave:Connect(function() 
                i_Input.BackgroundColor3 = RLTHEMEDATA['bs'][1]
                
                if (w_Tooltip.Text == I_Object.Tooltip) then
                    w_TooltipHeader.Visible = false
                end
            end)
            
            i_Input.FocusLost:Connect(function(enter) 
                pcall(I_Object.Flags.Unfocused, i_Input.Text, enter)
                i_Input.Text = I_Object.Name
            end)
            i_Input.Focused:Connect(function() 
                pcall(I_Object.Flags.Focused)
            end)
            i_Input:GetPropertyChangedSignal('Text'):Connect(function() 
                pcall(I_Object.Flags.TextChanged, i_Input.Text)
            end)
        end
        
        return I_Object
    end
    base_class.module_create_button = function(self, text) 
        text = tostring(text)
        
        local B_IndexOffset = self.ZIndex + 1
        
        local b_Background
         local b_EnableEffect
         local b_Text
          local b_TextPadding
         local b_Icon
        
        do
            b_Background = instNew('Frame')
            b_Background.BackgroundColor3 = RLTHEMEDATA['bs'][1] 
            b_Background.BackgroundTransparency = RLTHEMEDATA['bs'][2]
            b_Background.BorderSizePixel = 0
            b_Background.Size = dimNew(1,0,0,25)
            b_Background.ZIndex = B_IndexOffset
            b_Background.Parent = self.Menu
            
             b_EnableEffect = instNew('Frame')
             b_EnableEffect.BackgroundColor3 = RLTHEMEDATA['tm'][1]
             b_EnableEffect.BackgroundTransparency = 1
             b_EnableEffect.BorderSizePixel = 0
             b_EnableEffect.ClipsDescendants = true
             b_EnableEffect.Size = dimNew(1,0,1,0)
             b_EnableEffect.ZIndex = B_IndexOffset
             b_EnableEffect.Parent = b_Background
            
             b_Text = instNew('TextLabel')
             b_Text.BackgroundTransparency = 1
             b_Text.Font = RLTHEMEFONT
             b_Text.Position = dimOffset(10, 0)
             b_Text.Size = dimNew(1, -10, 1, 0)
             b_Text.Text = text
             b_Text.TextColor3 = RLTHEMEDATA['tm'][1]
             b_Text.TextSize = 18
             b_Text.TextStrokeColor3 = RLTHEMEDATA['to'][1]
             b_Text.TextStrokeTransparency = 0
             b_Text.TextXAlignment = 'Left'
             b_Text.ZIndex = B_IndexOffset
             b_Text.Parent = b_Background
             
              b_TextPadding = instNew('UIPadding')
              b_TextPadding.PaddingLeft = dimOffset(IndentLevel2, 0).X -- LEFT PADDING 2
              b_TextPadding.Parent = b_Text
                
             
             b_Icon = instNew('ImageLabel')
             b_Icon.AnchorPoint = vec2(1,0.5)
             b_Icon.BackgroundTransparency = 1
             b_Icon.Position = dimNew(1,-4, 0.5, 0)
             b_Icon.Rotation = 0
             b_Icon.Size = dimOffset(12, 12)
             b_Icon.Image = 'rbxassetid://8997446977'
             b_Icon.ImageColor3 = RLTHEMEDATA['tm'][1]
             b_Icon.ZIndex = B_IndexOffset
             b_Icon.Parent = b_Background
        end
            
        local B_Object = {} do 
            B_Object.Tooltip = nil
            
            
            B_Object.Flags = {} do 
                B_Object.Flags['Clicked'] = true
            end
            
            B_Object.Effect = b_EnableEffect
            
            B_Object.Name = text
            B_Object.ZIndex = B_IndexOffset
            
            B_Object.Click = base_class.module_click_self
            
            B_Object.Connect = base_class.generic_connect
            B_Object.setTooltip = base_class.generic_tooltip
        end
        
        do
            b_Background.InputBegan:Connect(function(io) 
                local uitv = io.UserInputType.Value
                if (uitv == 0) then
                    B_Object:Click()
                    return
                end
            end)
            
            b_Background.MouseEnter:Connect(function() 
                b_Background.BackgroundColor3 = RLTHEMEDATA['hs'][1]
                
                
                local tt = B_Object.Tooltip
                if (tt) then
                    w_Tooltip.Text = tt
                    w_TooltipHeader.Text = B_Object.Name
                    w_TooltipHeader.Visible = true
                end
            end)
            
            b_Background.MouseLeave:Connect(function() 
                b_Background.BackgroundColor3 = RLTHEMEDATA['bs'][1] 
                
                if (w_Tooltip.Text == B_Object.Tooltip) then
                    w_TooltipHeader.Visible = false
                end
            end)
        end
        
        return B_Object
    end
    base_class.dropdown_create_option = function(self, text) 
        text = tostring(text)
        local O_IndexOffset = self.ZIndex + 1
        
        local o_Option
         local o_Text
          local o_TextPadding
         local o_EnableEffect
         local o_EnableEffect2
        
        do
            o_Option = instNew('Frame')
            o_Option.BackgroundColor3 = RLTHEMEDATA['bd'][1]
            o_Option.BackgroundTransparency = RLTHEMEDATA['bd'][2]
            o_Option.BorderSizePixel = 0
            o_Option.Size = dimNew(1, 0, 0, 25)
            o_Option.ZIndex = O_IndexOffset
            o_Option.Parent = self.Menu
             
             o_Text = instNew('TextLabel')
             o_Text.BackgroundTransparency = 1
             o_Text.Font = RLTHEMEFONT
             o_Text.Size = dimScale(1,1)
             o_Text.Text = text
             o_Text.TextColor3 = RLTHEMEDATA['tm'][1]
             o_Text.TextSize = 18
             o_Text.TextStrokeColor3 = RLTHEMEDATA['to'][1]
             o_Text.TextStrokeTransparency = 0
             o_Text.TextXAlignment = 'Left'
             o_Text.ZIndex = O_IndexOffset
             o_Text.Parent = o_Option
             
             o_TextPadding = instNew('UIPadding')
             o_TextPadding.PaddingLeft = dimOffset(IndentLevel3, 0).X -- LEFT PADDING 3
             o_TextPadding.Parent = o_Text
             
             o_EnableEffect = instNew('Frame')
             o_EnableEffect.BackgroundColor3 = RLTHEMEDATA['tm'][1]
             o_EnableEffect.BackgroundTransparency = 0.96
             o_EnableEffect.BorderSizePixel = 0
             o_EnableEffect.ClipsDescendants = true
             o_EnableEffect.Size = dimNew(0,0,1,0)
             o_EnableEffect.ZIndex = O_IndexOffset
             o_EnableEffect.Parent = o_Option
             
              o_EnableEffect2 = instNew('Frame')
              o_EnableEffect2.BackgroundColor3 = RLTHEMEDATA['ge'][1]
              o_EnableEffect2.Size = dimNew(0,2,1,0)
              o_EnableEffect2.BorderSizePixel = 0
              o_EnableEffect2.ZIndex = O_IndexOffset
              o_EnableEffect2.Parent = o_EnableEffect
        end
            
        local O_Object = {} do 
            O_Object.Tooltip = nil
            O_Object.Selected = false
            
            O_Object.Name = text
            O_Object.Parent = self
            
            O_Object.Effect = o_EnableEffect
            
            O_Object.Select = base_class.s_ddoption_select_self
            O_Object.Deselect = base_class.s_ddoption_deselect_self
            
            O_Object.getState = base_class.s_ddoption_selected_getstate
            O_Object.IsSelected = base_class.s_ddoption_selected_getstate
            
            O_Object.setTooltip = base_class.generic_tooltip
        end
        
        do
            o_Option.InputBegan:Connect(function(io) 
                local uitv = io.UserInputType.Value
                if (uitv == 0 or uitv == 1) then
                    O_Object:Select()
                    return
                end
            end)
            
            o_Option.MouseEnter:Connect(function() 
                o_Option.BackgroundColor3 = RLTHEMEDATA['hd'][1]
                
                local tt = O_Object.Tooltip
                if (tt) then
                    w_Tooltip.Text = tt
                    w_TooltipHeader.Text = O_Object.Name
                    w_TooltipHeader.Visible = true
                end
            end)
            
            o_Option.MouseLeave:Connect(function() 
                o_Option.BackgroundColor3 = RLTHEMEDATA['bd'][1]
                
                if (w_Tooltip.Text == O_Object.Tooltip) then
                    w_TooltipHeader.Visible = false
                end
            end)
        end
        
        tabInsert(self.Objects, O_Object)
        return O_Object
    end
    
    base_class.widget_create_label = function(self, text) 
        local WidgetLabel = instNew('TextLabel')
        WidgetLabel.BackgroundTransparency = 1
        WidgetLabel.Font = RLTHEMEFONT
        WidgetLabel.RichText = true
        WidgetLabel.TextColor3 = RLTHEMEDATA['tm'][1]
        WidgetLabel.TextSize = 20
        WidgetLabel.TextStrokeColor3 = RLTHEMEDATA['to'][1]
        WidgetLabel.TextStrokeTransparency = 0
        WidgetLabel.ZIndex = self.Index
        WidgetLabel.Parent = self.Frame
        
        local bl = {}
        bl['BackgroundTransparency'] = true
        bl['Font'] = true
        bl['TextColor3'] = true
        bl['TextStrokeColor3'] = true
        bl['TextStrokeTransparency'] = true
        bl['ZIndex'] = true
        bl['Parent'] = true
        
        
        local mt = setmetatable({}, {
            __index = function(a,b) 
                return WidgetLabel[b] 
            end;
            
            __newindex = function(part, prop, val) 
                if (bl[prop] == nil) then
                    WidgetLabel[prop] = val
                elseif (prop == 'SELF') then
                    return WidgetLabel
                end
            end;
            
            __metatable = 'the j :skull:'
        })
        
        return mt
    end
    
    
end
-- UI functions
function ui:newMenu(text) 
    loadSettings()
    local M_Id = #ui_Menus+1
    local M_IndexOffset = 50+(M_Id * 15)
    
    local m_Header
     local m_HeaderEnableEffect
     local m_HeaderText
     local m_HeaderIcon
     
     local m_Menu
      local m_MenuListLayout
    
    m_Header = instNew('ImageButton')
    m_Header.Active = true
    m_Header.AutoButtonColor = false
    m_Header.BackgroundColor3 = RLTHEMEDATA['bm'][1]
    m_Header.BackgroundTransparency = RLTHEMEDATA['bm'][2]
    m_Header.BorderSizePixel = 0
    m_Header.ClipsDescendants = false
    m_Header.Size = dimOffset(1366 < 1500 and 170 or 300, 30)
    local FinalPosition do 
    local MenusPerRow = mathFloor(((monitor_resolution.X-100) / 200))
    FinalPosition = dimOffset(60+(((M_Id-1)%MenusPerRow)*(200)), 80+150*(mathFloor((M_Id-1)/MenusPerRow)))
    end
    
    
    m_Header.Position = FinalPosition
        
    
    
    --dimOffset((0.1*((M_Id-1)%6) * monitor_resolution.X)+(100*((M_Id-1)%6)+100), 0)
    m_Header.ZIndex = M_IndexOffset+2
    m_Header.Parent = w_ModFrame
    
    
    
     m_HeaderEnableEffect = instNew('Frame')
     m_HeaderEnableEffect.BackgroundColor3 = RLTHEMEDATA['ge'][1]
     m_HeaderEnableEffect.Size = dimNew(0,0,1,0)
     m_HeaderEnableEffect.BorderSizePixel = 0
     m_HeaderEnableEffect.ZIndex = M_IndexOffset+2
     m_HeaderEnableEffect.Parent = m_Header
    
     m_HeaderText = instNew('TextLabel')
     m_HeaderText.Size = dimNew(1, 0, 1, 0)
     m_HeaderText.Position = dimOffset(0, 0)
     m_HeaderText.BackgroundTransparency = 1
     m_HeaderText.Font = RLTHEMEFONT
     m_HeaderText.TextXAlignment = 'Center'
     m_HeaderText.TextColor3 = RLTHEMEDATA['tm'][1]
     m_HeaderText.TextSize = 22
     m_HeaderText.Text = text
     m_HeaderText.TextStrokeTransparency = 0
     m_HeaderText.TextStrokeColor3 = RLTHEMEDATA['to'][1]
     m_HeaderText.ZIndex = M_IndexOffset+2
     m_HeaderText.Parent = m_Header
     
     m_HeaderIcon = instNew('ImageLabel')
     m_HeaderIcon.Size = dimOffset(30, 30)
     m_HeaderIcon.Position = dimScale(1,0)
     m_HeaderIcon.AnchorPoint = vec2(1,0)
     m_HeaderIcon.BackgroundTransparency = 1
     m_HeaderIcon.ImageColor3 = RLTHEMEDATA['tm'][1]
     m_HeaderIcon.Image = 'rbxassetid://7184113125'
     m_HeaderIcon.Rotation = 180
     m_HeaderIcon.ZIndex = M_IndexOffset+2
     m_HeaderIcon.Parent = m_Header
    m_Menu = instNew('Frame')
    m_Menu.AutomaticSize = 'Y'
    m_Menu.BackgroundColor3 = RLTHEMEDATA['bo'][1]
    m_Menu.BackgroundTransparency = 1--RLTHEMEDATA['bo'][2]
    m_Menu.BorderSizePixel = 0
    m_Menu.Position = dimOffset(0, 30)
    m_Menu.Size = dimNew(1,0,0,0)
    m_Menu.Visible = false
    m_Menu.ZIndex = M_IndexOffset
    m_Menu.Parent = m_Header
    
     m_MenuListLayout = instNew('UIListLayout')
     m_MenuListLayout.FillDirection = 'Vertical'
     m_MenuListLayout.HorizontalAlignment = 'Left'
     m_MenuListLayout.VerticalAlignment = 'Top'
     m_MenuListLayout.Parent = m_Menu
    
     
    stroke(m_Header)
    stroke(m_Menu)
    
    
    
    
    local M_Object = {} do 
        M_Object.MToggled = false
        M_Object.Menu = m_Menu
        M_Object.Icon = m_HeaderIcon
        M_Object.ZIndex = M_IndexOffset
        M_Object.Enabled = m_HeaderEnableEffect
        M_Object.Name = text
        
        M_Object.addMod = base_class.menu_create_module
        
        
        M_Object.Enable = base_class.menu_enable
        M_Object.Disable = base_class.menu_disable
        M_Object.Toggle = base_class.menu_toggle
        M_Object.getState = base_class.menu_getstate
    end
    
    
    do
        if not Configs[text] then
            Configs[text] = {["MenuToggled"] = ""}
        end
        if Configs[text] then
            if Configs[text]["MenuToggled"] == true then
                M_Object:Toggle()
            end
        end
        
        
        local prevclicktime = 0
        local id = 'menu-'..M_Id
        
        
        
        m_Header.InputBegan:Connect(function(io) 
            -- Header got input; check type
            local uitv = io.UserInputType.Value
            
            -- If left clicking then do stuff
            if (uitv == 0) then
                -- Check double click debounce
                local currclicktime = tick()
                if (currclicktime - prevclicktime < 0.2) then
                    M_Object:Toggle()
                end
                prevclicktime = currclicktime
                
                -- Start dragging logic
                
                local root_pos = m_Header.AbsolutePosition -- Get the original header position
                local start_pos = io.Position -- Get start input position; this will be used for a "delta" position
                start_pos = vec2(start_pos.X, start_pos.Y) -- Convert it to a vec2 so it can be used easier
                
                local destination = vec2(root_pos.X, root_pos.Y) + monitor_inset -- Get the wanted destination; this will be used for custom tweening
                -- (normal roblox tweening works fine, but i believe custom is more performant)
                servRun:BindToRenderStep(M_Id, 2000, function(dt) -- "Tween" code
                    m_Header.Position = m_Header.Position:lerp(dimOffset(destination.X, destination.Y), 1 - 1e-9^(dt)) -- Lerp the position
                    
                    -- value = lerp(target, value, exp2(-rate*deltaTime))
                end)
                -- Connect to mouse movement
                ui_Connections[id] = servInput.InputChanged:Connect(function(io) 
                    -- Check if the input is a mouse movement
                    if (io.UserInputType.Value == 4) then
                        -- If so then get the mouse position
                        local curr_pos = io.Position
                        -- Convert it to a vec2
                        curr_pos = vec2(curr_pos.X, curr_pos.Y)
                        -- Get the new destination (original position + input delta + inset)
                        destination = root_pos + (curr_pos - start_pos) + monitor_inset
                        
                        --twn(m_Header, {Position = dimOffset(destination.X, destination.Y)})
                    end
                end)
                
            -- If its not mouse1, check if its a right click
            elseif (uitv == 1) then
                -- Toggle if it is
                M_Object:Toggle()
            end
        end)
        m_Header.InputEnded:Connect(function(io) 
            if (io.UserInputType.Value == 0) then
                local a = ui_Connections[id]
                if (a) then a:Disconnect() end
                servRun:UnbindFromRenderStep(M_Id)
            end
        end)
        
        m_Header.MouseEnter:Connect(function() 
            m_Header.BackgroundColor3 = RLTHEMEDATA['hm'][1]
        end)
        
        m_Header.MouseLeave:Connect(function() 
            m_Header.BackgroundColor3 = RLTHEMEDATA['bm'][1]
        end)
    end
    
    
    
    tabInsert(ui_Menus, M_Object)
    return M_Object
end
function ui:CreateWidget(Name, Position, Size, InFDPWindow) 
    local W_Id = #ui_Widgets+1
    local W_IndexOffset = 25+(W_Id * 15)
    
    
    local w_Header
    local w_Main
    
    w_Header = instNew('TextLabel')
    w_Header.BackgroundColor3 = RLTHEMEDATA['bm'][1]
    w_Header.BackgroundTransparency = RLTHEMEDATA['bm'][2]
    w_Header.BorderSizePixel = 0
    w_Header.Font = RLTHEMEFONT
    w_Header.Position = Position
    w_Header.RichText = true
    w_Header.Size = dimOffset(Size.X, 21)
    w_Header.Text = Name
    w_Header.TextColor3 = RLTHEMEDATA['tm'][1]
    w_Header.TextSize = 19
    w_Header.TextStrokeColor3 = RLTHEMEDATA['to'][1]
    w_Header.TextStrokeTransparency = 0
    w_Header.TextXAlignment = 'Center'
    w_Header.Visible = true 
    w_Header.ZIndex = W_IndexOffset
    w_Header.Parent = InFDPWindow and w_ModFrame or w_Main
    
    stroke(w_Header, 'Border')
    
    w_Main = instNew('Frame')
    w_Main.BackgroundColor3 = RLTHEMEDATA['gw'][1]
    w_Main.BackgroundTransparency = RLTHEMEDATA['gw'][2]
    w_Main.BorderSizePixel = 0
    w_Main.Position = dimOffset(0, 21)
    w_Main.Size = dimNew(1, 0, 1, Size.Y-21)
    w_Main.Visible = true 
    w_Main.ZIndex = W_IndexOffset
    w_Main.Parent = w_Header
    
    stroke(w_Main, 'Border')
    
    local WidgetObject = {} do 
        WidgetObject.Frame = w_Main
        WidgetObject.Name = Name
        WidgetObject.Index = W_IndexOffset
        WidgetObject.Header = w_Header
        
        WidgetObject.CreateLabel = widget_create_label
        WidgetObject.Colors = {}
        WidgetObject.Colors.Text = RLTHEMEDATA['tm'][1]
        WidgetObject.Colors.TextStroke = RLTHEMEDATA['to'][1]
    end
    do 
        local id = 'wid-'..W_Id
        
        w_Header.InputBegan:Connect(function(io) 
            -- Header got input; check type
            local uitv = io.UserInputType.Value
            
            -- If left clicking then do stuff
            if (uitv == 0) then
                -- Start dragging logic
                
                local root_pos = w_Header.AbsolutePosition -- Get the original header position
                local start_pos = io.Position -- Get start input position; this will be used for a "delta" position
                start_pos = vec2(start_pos.X, start_pos.Y) -- Convert it to a vec2 so it can be used easier
                
                local destination = vec2(root_pos.X, root_pos.Y) + monitor_inset -- Get the wanted destination; this will be used for custom tweening
                -- (normal roblox tweening works fine, but i believe custom is more performant)
                servRun:BindToRenderStep(W_Id, 2000, function() -- "Tween" code
                    w_Header.Position = w_Header.Position:lerp(dimOffset(destination.X, destination.Y), 0.3) -- Lerp the position
                end)
                -- Connect to mouse movement
                ui_Connections[id] = servInput.InputChanged:Connect(function(io) 
                    -- Check if the input is a mouse movement
                    if (io.UserInputType.Value == 4) then
                        -- If so then get the mouse position
                        local curr_pos = io.Position
                        -- Convert it to a vec2
                        curr_pos = vec2(curr_pos.X, curr_pos.Y)
                        -- Get the new destination (original position + input delta + inset)
                        destination = root_pos + (curr_pos - start_pos) + monitor_inset
                    end
                end)
            end
        end)
        w_Header.InputEnded:Connect(function(io) 
            if (io.UserInputType.Value == 0) then
                local a = ui_Connections[id]
                if (a) then a:Disconnect() end
                servRun:UnbindFromRenderStep(W_Id)
            end
        end)
    
    end
    return WidgetObject
end
function ui:Destroy() 
    pcall(ui.Flags.Destroying)
    
    
    -- Destroy
    local _ = w_Screen.Parent
    w_Screen:Destroy()
    
    -- Unbinds
    servContext:UnbindAction('RL-ToggleMenu')
    servContext:UnbindAction('RL-Destroy')
    
    -- Disconnections
    
    for i,v in pairs(ui_Connections) do 
        v:Disconnect() 
    end
    
    -- Variable clearing
    gradient,getnext,stroke,round,uierror = nil,nil,nil,nil,nil
    ui_Menus = nil
    
    _G.RLLOADED = false
    _G.RLTHEME = nil
    _G.RLTHEMEDATA = nil
    _G.RLTHEMEFONT = nil
    _G.RLLOADERROR = nil
    
    writefile('FDP/Queued.txt','')
    
    local sound = instNew('Sound')
    sound.SoundId = 'rbxassetid://9009668475'
    sound.Volume = 1
    sound.TimePosition = 0.02
    sound.Parent = _
    sound:Play()
    sound.Ended:Connect(function() 
        sound:Destroy()
    end)
    
end
function ui:GetModules() 
    return ui_Modules
end
function ui:GetScreen() 
    return w_Screen 
end
function ui:GetModframe() 
    return w_ModFrame
end
    
ui.Flags = {}
ui.Flags.Destroying = true
ui.Connect = base_class.generic_connect
-- Gui binds
local OldIconEnabled = servInput.MouseIconEnabled
servContext:BindActionAtPriority('RL-ToggleMenu',function(_,uis) 
    
    if (uis.Value == 0) then
        W_WindowOpen = not W_WindowOpen
        
        if (W_WindowOpen) then
            servInput.MouseIconEnabled = false
            w_MouseCursor.ImageTransparency = 0
            
            w_Backframe.Visible = true
            twn(w_Backframe, {Size = dimScale(1, 1)}, true)
        else
            servInput.MouseIconEnabled = OldIconEnabled
            w_MouseCursor.ImageTransparency = 1
            
            
            local j = twn(w_Backframe, {Size = dimScale(1, 0)}, true)
            j.Completed:Wait()
            if j.PlaybackState == 4 then
                w_Backframe.Visible = false
            end 
        end
    end
end,false,999999,Enum.KeyCode.RightShift)
servContext:BindActionAtPriority('RL-Destroy',function(_,uis) 
    if (uis.Value == 0) then
        for i,v in pairs(ui_Modules) do
            if v:getState() == true then
                v:Toggle(false, false)
            end
        end
        ui:Destroy()
        _G.MLOADED = false
        for i,v in pairs(ui_Connections) do 
                v:Disconnect() 
            end
        end
end,false,999999,Enum.KeyCode.RightControl)
-- Auto collection
delay(5, function() 
    if (ui_Menus ~= nil and #ui_Menus == 0) then
        for i,v in pairs(ui_Modules) do
            if v:getState() == true then
                v:Toggle(false, false)
            end
        end
        ui:Destroy()
        _G.MLOADED = false
        warn'[FDP] Failure to clean library resources!\nAutomatically cleared for you; make sure to\ncall ui:Destroy() when finished'
    end
end)
end

_G.MLOADED = true
return ui

