print("Complete Menu Loading...")

-- =======================================
-- CONFIGURATION AND CONSTANTS
-- =======================================

-- Key mappings for menu navigation and controls
local Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, 
    ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, 
    ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, 
    ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, 
    ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, 
    ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, 
    ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['UP'] = 172, ['DOWN'] = 173,
    ['NENTER'] = 201, ['N4'] = 108, ['N5'] = 60, ['N6'] = 107, ['N+'] = 96, 
    ['N-'] = 97, ['N7'] = 117, ['N8'] = 61, ['N9'] = 118,
    ['MOUSE1'] = 24
}

-- =======================================
-- UTILITY FUNCTIONS
-- =======================================

-- Override default print function for menu logging
local old_print = print
local function menu_print(message)
    old_print('^1[^5LOGS MENU^1]^7 ' .. message)
end

-- Convert integer to float with fallback
local function intToFloat(value)
    if value then
        return value + 0.0
    else
        return 5391.0
    end
end

-- Citizen framework shortcuts
local CreateThread = Citizen.CreateThread
local Wait = Citizen.Wait
local InvokeNative = Citizen.InvokeNative

-- Safe string conversion
local function safeToString(num)
    if num == 0 or not num then
        return nil
    end
    return tostring(num)
end

-- Event trigger function (delayedTriggerClientEvent)
local function delayedTriggerClientEvent(delayed, server, event, ...)
    if delayed then 
        CreateThread(function() Wait(50) end)
    end

    local payload = msgpack.pack({...})
    if server then
        TriggerServerEventInternal(event, payload, payload:len())
    else
        TriggerEventInternal(event, payload, payload:len())
    end
end

-- =======================================
-- MAIN MENU SYSTEM
-- =======================================

-- Main menu system object (originally obfuscated as very long variable name)
local MenuSystem = {
    shouldShowMenu = true,
    debug = false,
    
    -- Native functions collection
    natives = {
        -- Server and resource functions
        getCurrentServerEndpoint = function()
            return InvokeNative(" 0xea11bfba ", Citizen.ReturnResultAnyway(), Citizen.ResultAsString())
        end,
        getCurrentResourceName = function()
            return InvokeNative(" 0xe5e9ebbb ", Citizen.ReturnResultAnyway(), Citizen.ResultAsString())
        end,
        getActivePlayers = function()
            return msgpack.unpack(InvokeNative(" 0xcf143fb9 ", Citizen.ReturnResultAnyway(), Citizen.ResultAsObject()))
        end,
        
        -- Entity and ped functions
        clearPedTasksImmediately = function(ped)
            return InvokeNative(" 0xAAA34F8A7CB32098 ", ped)
        end,
        setEntityCoords = function(entity, x, y, z, xAxis, yAxis, zAxis, clearArea)
            return InvokeNative(" 0x06843DA7060A026B ", entity, x, y, z, xAxis, yAxis, zAxis, clearArea)
        end,
        setEntityCoordsNoOffset = function(entity, x, y, z, xAxis, yAxis, zAxis)
            return InvokeNative(" 0x239A3351AC1DA385 ", entity, x, y, z, xAxis, yAxis, zAxis)
        end,
        setEntityHealth = function(entity, health)
            return InvokeNative(" 0x6B76DC1F3AE6E6A3 ", entity, health)
        end,
        setEntityVisible = function(entity, toggle, unk)
            return InvokeNative(" 0xEA1C610A04DB6BBB ", entity, toggle, unk)
        end,
        
        -- Vehicle functions
        createVehicle = function(modelHash, x, y, z, heading, isNetwork, thisScriptCheck)
            return InvokeNative(" 0xAF35D0D2583051B0 ", modelHash, x, y, z, heading, isNetwork, thisScriptCheck, 
                              Citizen.ReturnResultAnyway(), Citizen.ResultAsInteger())
        end,
        networkExplodeVehicle = function(vehicle, isAudible, isInvisible, p3)
            return InvokeNative(" 0x301A42153C9AD707 ", vehicle, isAudible, isInvisible, p3, 
                              Citizen.ReturnResultAnyway(), Citizen.ResultAsInteger())
        end,
        getVehicleXenonLightsColour = function(vehicle)
            return InvokeNative(" 0x3DFF319A831E0CDB ", vehicle, Citizen.ReturnResultAnyway(), Citizen.ResultAsInteger())
        end,
        setVehicleXenonLightsColour = function(vehicle, color)
            return InvokeNative(" 0xE41033B25D003A07 ", vehicle, color)
        end,
        doesExtraExist = function(vehicle, extraId)
            return InvokeNative(" 0x1262D55792428154 ", vehicle, extraId, Citizen.ReturnResultAnyway())
        end,
        
        -- Weapon and combat functions
        giveWeaponToPed = function(ped, weaponHash, ammoCount, isHidden, equipNow)
            return InvokeNative(" 0xBF0FD6E56C964FCB ", ped, weaponHash, ammoCount, isHidden, equipNow)
        end,
        shootSingleBulletBetweenCoords = function(x1, y1, z1, x2, y2, z2, damage, p7, weaponHash, ownerPed, isAudible, isInvisible, speed)
            return InvokeNative(" 0x867654CBC7606F2C ", x1, y1, z1, x2, y2, z2, damage, p7, 
                              GetHashKey(weaponHash), ownerPed, isAudible, isInvisible, speed)
        end,
        addExplosion = function(x, y, z, explosionType, damageScale, isAudible, isInvisible, cameraShake)
            return InvokeNative(" 0xE3AD2BDBAEE269AC ", x, y, z, explosionType, damageScale, isAudible, isInvisible, cameraShake)
        end,
        setPedArmour = function(ped, amount)
            return InvokeNative(" 0xCEA04D83135264CC ", ped, amount)
        end,
        
        -- Object creation
        createObject = function(modelHash, x, y, z, isNetwork, netMissionEntity, dynamic)
            return InvokeNative(" 0x509D5878EB39E842 ", modelHash, x, y, z, isNetwork, thisScriptCheck, dynamic, 
                              Citizen.ReturnResultAnyway(), Citizen.ResultAsInteger())
        end,
        
        -- Text and UI functions
        addTextComponentSubstringPlayerName = function(text)
            return InvokeNative(" 0x6C188BE134E074AA ", tostring(text))
        end,
        beginTextCommandDisplayText = function(text)
            return InvokeNative(" 0x25FBB336DF1804CB ", tostring(text))
        end,
        endTextCommandDisplayText = function(x, y)
            return InvokeNative(" 0xCD015E5BB0D96A57 ", x, y)
        end,
        addTextEntry = function(entryKey, entryText)
            return InvokeNative(" 0x32ca01c3 ", tostring(entryKey), tostring(entryText))
        end,
        setTextFont = function(fontType)
            return InvokeNative(" 0x66E0276CC5F6B9DA ", fontType)
        end,
        setTextColour = function(red, green, blue, alpha)
            return InvokeNative(" 0xBE6B23FFA53FB442 ", red, green, blue, alpha)
        end,
        setTextScale = function(scale, size)
            return InvokeNative(" 0x07C837F9A01C34C9 ", scale, size)
        end,
        setTextDropShadow = function()
            return InvokeNative(" 0x1CA3E9EAC9D93E5E ")
        end,
        setTextProportional = function(p0)
            return InvokeNative(" 0x038C1F517D7FDCF8 ", p0)
        end,
        setTextOutline = function()
            return InvokeNative(" 0x2513DFB0FB8400FE ")
        end,
        
        -- Drawing functions
        drawRect = function(x, y, width, height, r, g, b, a)
            return InvokeNative(" 0x3A618A217E5154F0 ", x, y, width, height, r, g, b, a)
        end,
        
        -- Input functions
        isDisabledControlPressed = function(inputGroup, control)
            return InvokeNative(" 0xE2587F8CBBD87B1D ", inputGroup, control, Citizen.ReturnResultAnyway())
        end,
        
        -- Keyboard functions
        displayOnscreenKeyboard = function(p0, windowTitle, p2, defaultText, defaultConcat1, defaultConcat2, defaultConcat3, maxInputLength)
            return InvokeNative(" 0x00DC833F2568DBF6 ", p0, tostring(windowTitle), tostring(p2), tostring(defaultText), 
                              tostring(defaultConcat1), tostring(defaultConcat2), tostring(defaultConcat3), maxInputLength)
        end,
        updateOnscreenKeyboard = function()
            return InvokeNative(" 0x0CF2B696BBF945AE ", Citizen.ReturnResultAnyway(), Citizen.ResultAsInteger())
        end,
        
        -- Resource functions
        loadResourceFile = function(resourceName, fileName)
            return InvokeNative(" 0x76a9ee1f ", tostring(resourceName), tostring(fileName), 
                              Citizen.ReturnResultAnyway(), Citizen.ResultAsString())
        end,
        
        -- Audio functions
        playSoundFrontend = function(soundId, audioName, audioRef, p3)
            return InvokeNative(" 0x67C540AA08E4A6F5 ", soundId, tostring(audioName), tostring(audioRef), p3)
        end,
        
        -- Texture functions
        requestStreamedTextureDict = function(textureDict, p1)
            return InvokeNative(" 0xDFA2EF8E04127DD5 ", tostring(textureDict), p1)
        end,
        
        -- Lighting functions
        setArtificialLightsState = function(state)
            return InvokeNative(" 0x1268615ACE24D504 ", state)
        end
    },
    
    -- Menu properties and styling
    menuProps = {
        -- Menu collections (originally named "shitMenus")
        subMenus = {},
        
        -- Navigation keys
        keys = { 
            up = Keys['UP'], 
            down = Keys['DOWN'], 
            left = Keys['LEFT'], 
            right = Keys['RIGHT'], 
            select = Keys['NENTER'], 
            back = 202 
        },
        
        -- Menu state
        optionCount = 0,
        maximumOptionCount = 12,
        currentKey = nil,
        currentMenu = nil,
        
        -- Title styling
        titleHeight = 0.11,
        titleYOffset = 0.05,
        titleXOffset = 0.5,
        titleScale = 1.0,
        titleSpacing = 2,
        
        -- Button styling
        buttonHeight = 0.038,
        buttonFont = 0,
        buttonScale = 0.365,
        buttonTextYOffset = 0.005,
        buttonTextXOffset = 0.005,
        
        -- Version info
        _mVersion = 'b1.4.0',
        
        -- Theme settings
        selectedThemeRainbow = false,
        selectedCheckboxStyle = 'Old',
        availableCheckboxStyles = {'New', 'Old'},
        menu_TextOutline = false,
        menu_TextDropShadow = true,
        menu_RectOverlay = true,
        selectedTheme = 'Classic',
        availableThemes = {'Dark', 'Light', 'Classic'},
        rainbowInt = 0,
    },
    
    -- Function collections
    functions = {},
    trashFunctions = {},
    trashTables = {},
    menusList = {},
    cachedNotifications = {},
    
    -- Event trigger function
    dTCE = delayedTriggerClientEvent,
    
    -- Game data storage
    datastore = {
        -- Local player data
        localPlayer = {
            currentVehicle = 0,
            pedId = 0,
            should2StepAutoBoost = false,
        },
        
        -- ESX Framework integration
        es_extended = nil,
        ESX = nil,
        
        -- Train ride system
        trainRide = {
            handleHasLoaded = true,
            handle = nil,
            oldCoords = nil,
            trainSpeed = 5.0,
        },
        
        -- Saved vehicles data (sample vehicles from original)
        savedVehicles = {
            {
                name = 'Flacko | Elegy Retro Custom', 
                props = {
                    ["modDashboard"] = 1,
                    ["modTransmission"] = 2,
                    ["modLivery"] = 4,
                    ["modFrame"] = 4,
                    ["modWindows"] = 0,
                    ["modTank"] = 1,
                    ["dirtLevel"] = 10.8,
                    ["modArmor"] = 4,
                    ["wheels"] = 0,
                    ["modFrontWheels"] = -1,
                    ["tyreSmokeColor"] = { [1] = 255, [2] = 255, [3] = 255, ["n"] = 3 },
                    ["modBrakes"] = 2,
                    ["modPlateHolder"] = 0,
                    ["modArchCover"] = -1,
                    ["wheelColor"] = 134,
                    ["pearlescentColor"] = 12,
                    ["modVanityPlate"] = 2,
                    ["modStruts"] = 11,
                    ["bodyHealth"] = 1000.0,
                    ["modSuspension"] = 3,
                    ["modTurbo"] = 1,
                    ["modSpoilers"] = 2,
                    ["modSeats"] = 0,
                    ["modFrontBumper"] = -1,
                    ["modAerials"] = 6,
                    ["modTrimB"] = 0,
                    ["modHood"] = 4,
                    ["color2"] = 12,
                    ["modOrnaments"] = -1,
                    ["modDoorSpeaker"] = 4,
                    ["modHydrolic"] = -1,
                    ["modHorns"] = -1,
                    ["modSideSkirt"] = 4,
                    ["modXenon"] = 1,
                    ["modEngineBlock"] = 1,
                    ["modAirFilter"] = 1,
                    ["modRearBumper"] = 1,
                    ["modTrimA"] = 0,
                    ["modBackWheels"] = -1,
                    ["modSpeakers"] = -1,
                    ["modExhaust"] = 2,
                    ["modFender"] = 1,
                    ["modEngine"] = 3,
                    ["modGrille"] = 0,
                    ["modDial"] = 2,
                    ["modSteeringWheel"] = 9,
                    ["modShifterLeavers"] = -1,
                    ["modAPlate"] = -1,
                    ["modSmokeEnabled"] = 1,
                    ["modRoof"] = 0,
                    ["engineHealth"] = 1000.0,
                    ["neonEnabled"] = { [1] = false, [2] = false, [3] = false, [4] = false },
                    ["model"] = 196747873,
                    ["neonColor"] = { [1] = 255, [2] = 0, [3] = 255, ["n"] = 3 },
                    ["color1"] = 12,
                    ["xenonColor"] = 255,
                    ["tankHealth"] = 1000.0,
                    ["windowTint"] = 1,
                    ["plateIndex"] = 1,
                    ["extras"] = {},
                    ["plate"] = "FLACKO   ",
                    ["fuelLevel"] = 65.0,
                    ["modTrunk"] = -1
                }
            },
            {
                name = 'Prodigy | Jester Classic', 
                props = {
                    ["modFrame"] = 2,
                    ["modTransmission"] = 2,
                    ["modRoof"] = 0,
                    ["modLivery"] = 1,
                    ["color1"] = 12,
                    ["modWindows"] = -1,
                    ["modTank"] = -1,
                    ["modSideSkirt"] = 0,
                    ["modSpeakers"] = -1,
                    ["wheels"] = 0,
                    ["modAerials"] = -1,
                    ["dirtLevel"] = 6.2,
                    ["modArchCover"] = -1,
                    ["neonEnabled"] = { [1] = false, [2] = false, [3] = false, [4] = false },
                    ["modStruts"] = -1,
                    ["modBackWheels"] = -1,
                    ["engineHealth"] = 1000.0,
                    ["modSuspension"] = 4,
                    ["modTurbo"] = 1,
                    ["modAirFilter"] = -1,
                    ["modEngineBlock"] = -1,
                    ["modHydrolic"] = -1,
                    ["modOrnaments"] = -1,
                    ["modEngine"] = 3,
                    ["modHood"] = 2,
                    ["modFrontBumper"] = -1,
                    ["modSeats"] = -1,
                    ["modExhaust"] = 2,
                    ["modTrimB"] = -1,
                    ["modGrille"] = -1,
                    ["modVanityPlate"] = -1,
                    ["modArmor"] = 4,
                    ["modHorns"] = -1,
                    ["modSmokeEnabled"] = 1,
                    ["modTrimA"] = -1,
                    ["modDoorSpeaker"] = -1,
                    ["modRearBumper"] = -1,
                    ["modSpoilers"] = -1,
                    ["modFender"] = -1,
                    ["modSteeringWheel"] = -1,
                    ["modAPlate"] = -1,
                    ["modBrakes"] = 2,
                    ["modShifterLeavers"] = -1,
                    ["modDial"] = -1,
                    ["modTrunk"] = -1,
                    ["modXenon"] = 1,
                    ["modFrontWheels"] = -1,
                    ["modPlateHolder"] = -1,
                    ["modDashboard"] = -1,
                    ["tyreSmokeColor"] = { [1] = 255, [2] = 255, [3] = 255, ["n"] = 3 },
                    ["bodyHealth"] = 1000.0,
                    ["windowTint"] = 1,
                    ["plateIndex"] = 0,
                    ["extras"] = {},
                    ["plate"] = "PRODIGY  ",
                    ["fuelLevel"] = 65.0,
                    ["tankHealth"] = 1000.0,
                    ["wheelColor"] = 156,
                    ["pearlescentColor"] = 12,
                    ["color2"] = 12,
                    ["model"] = 1944051882,
                    ["neonColor"] = { [1] = 255, [2] = 0, [3] = 255, ["n"] = 3 },
                    ["xenonColor"] = 255
                }
            },
            {
                name = 'zlRedman | Schwartzer', 
                props = {
                    ["color2"] = 12,
                    ["modBackWheels"] = -1,
                    ["bodyHealth"] = 1000.0,
                    ["modLivery"] = -1,
                    ["modArchCover"] = -1,
                    ["wheelColor"] = 12,
                    ["modTank"] = -1,
                    ["modXenon"] = 1,
                    ["modAerials"] = -1,
                    ["modOrnaments"] = -1,
                    ["modWindows"] = -1,
                    ["modStruts"] = -1,
                    ["neonColor"] = { [1] = 255, [2] = 0, [3] = 255, ["n"] = 3 },
                    ["modAirFilter"] = -1,
                    ["modEngineBlock"] = -1,
                    ["modHydrolic"] = -1,
                    ["modFender"] = -1,
                    ["tyreSmokeColor"] = { [1] = 255, [2] = 255, [3] = 255, ["n"] = 3 },
                    ["modEngine"] = -1,
                    ["modHood"] = -1,
                    ["modFrame"] = -1,
                    ["modFrontBumper"] = -1,
                    ["modSeats"] = -1,
                    ["modExhaust"] = -1,
                    ["modTrimB"] = -1,
                    ["modGrille"] = -1,
                    ["modVanityPlate"] = -1,
                    ["modArmor"] = -1,
                    ["modHorns"] = -1,
                    ["modSmokeEnabled"] = -1,
                    ["modTrimA"] = -1,
                    ["modDoorSpeaker"] = -1,
                    ["modRearBumper"] = -1,
                    ["modSpoilers"] = -1,
                    ["modSteeringWheel"] = -1,
                    ["modAPlate"] = -1,
                    ["modBrakes"] = -1,
                    ["modShifterLeavers"] = -1,
                    ["modDial"] = -1,
                    ["modTrunk"] = -1,
                    ["modFrontWheels"] = -1,
                    ["modPlateHolder"] = -1,
                    ["modDashboard"] = -1,
                    ["modSideSkirt"] = -1,
                    ["modSpeakers"] = -1,
                    ["modSuspension"] = -1,
                    ["modTurbo"] = -1,
                    ["modRoof"] = -1,
                    ["modTransmission"] = -1,
                    ["dirtLevel"] = 0.0,
                    ["neonEnabled"] = { [1] = false, [2] = false, [3] = false, [4] = false },
                    ["engineHealth"] = 1000.0,
                    ["windowTint"] = -1,
                    ["plateIndex"] = 0,
                    ["extras"] = {},
                    ["plate"] = "ZLREDMAN ",
                    ["fuelLevel"] = 65.0,
                    ["tankHealth"] = 1000.0,
                    ["pearlescentColor"] = 12,
                    ["color1"] = 12,
                    ["model"] = 1693751655,
                    ["xenonColor"] = 255,
                    ["wheels"] = 0
                }
            },
            {
                name = 'Alfa Romeo Giulia QV', 
                props = {
                    ["modLivery"] = 0,
                    ["xenonColor"] = 255,
                    ["model"] = 433374210,
                    ["extras"] = { ["11"] = true },
                    ["modTurbo"] = 1,
                    ["suspensionRaise"] = 2.2351741291171e-10,
                    ["dirtLevel"] = 6.8,
                    ["modWindows"] = -1,
                    ["bodyHealth"] = 1000.0,
                    ["modTransmission"] = 2,
                    ["modSideSkirt"] = -1,
                    ["modHood"] = -1,
                    ["neonEnabled"] = { [1] = false, [2] = false, [3] = false, [4] = false },
                    ["modSmokeEnabled"] = 1,
                    ["modArchCover"] = -1,
                    ["modTrimA"] = -1,
                    ["engineHealth"] = 1000.0,
                    ["modVanityPlate"] = -1,
                    ["modArmor"] = 4,
                    ["modEngine"] = 3,
                    ["modFrame"] = -1,
                    ["modFrontBumper"] = -1,
                    ["modSeats"] = -1,
                    ["modExhaust"] = -1,
                    ["modTrimB"] = -1,
                    ["modGrille"] = -1,
                    ["modHorns"] = -1,
                    ["modTrimA"] = -1,
                    ["modDoorSpeaker"] = -1,
                    ["modRearBumper"] = -1,
                    ["modSpoilers"] = -1,
                    ["modFender"] = -1,
                    ["modSteeringWheel"] = -1,
                    ["modAPlate"] = -1,
                    ["modBrakes"] = 2,
                    ["modShifterLeavers"] = -1,
                    ["modDial"] = -1,
                    ["modTrunk"] = -1,
                    ["modXenon"] = 1,
                    ["modFrontWheels"] = -1,
                    ["modPlateHolder"] = -1,
                    ["modDashboard"] = -1,
                    ["modSpeakers"] = -1,
                    ["modSuspension"] = 3,
                    ["modRoof"] = -1,
                    ["modAirFilter"] = -1,
                    ["modEngineBlock"] = -1,
                    ["modHydrolic"] = -1,
                    ["modOrnaments"] = -1,
                    ["modAerials"] = -1,
                    ["modStruts"] = -1,
                    ["modBackWheels"] = -1,
                    ["modTank"] = -1,
                    ["tyreSmokeColor"] = { [1] = 255, [2] = 255, [3] = 255, ["n"] = 3 },
                    ["wheelColor"] = 156,
                    ["pearlescentColor"] = 134,
                    ["color2"] = 134,
                    ["neonColor"] = { [1] = 255, [2] = 0, [3] = 255, ["n"] = 3 },
                    ["color1"] = 134,
                    ["windowTint"] = -1,
                    ["plateIndex"] = 0,
                    ["plate"] = "GIULIA QV",
                    ["fuelLevel"] = 65.0,
                    ["tankHealth"] = 1000.0,
                    ["wheels"] = 0
                }
            }
        },
        
        -- Weapons data (comprehensive weapon table from original)
        weaponsTable = {
            Melee = {
                BaseballBat = {
                    id = 'weapon_bat', 
                    name = '~s~~s~Baseball Bat', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                BrokenBottle = { 
                    id = 'weapon_bottle', 
                    name = '~s~~s~Broken Bottle', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                Crowbar = { 
                    id = 'weapon_Crowbar', 
                    name = '~s~~s~Crowbar', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                Flashlight = { 
                    id = 'weapon_flashlight', 
                    name = '~s~~s~Flashlight', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                GolfClub = { 
                    id = 'weapon_golfclub', 
                    name = '~s~~s~Golf Club', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                BrassKnuckles = { 
                    id = 'weapon_knuckle', 
                    name = '~s~~s~Brass Knuckles', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                Knife = { 
                    id = 'weapon_knife', 
                    name = '~s~~s~Knife', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                Machete = { 
                    id = 'weapon_machete', 
                    name = '~s~~s~Machete', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                Switchblade = { 
                    id = 'weapon_switchblade', 
                    name = '~s~~s~Switchblade', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                Nightstick = { 
                    id = 'weapon_nightstick', 
                    name = '~s~~s~Nightstick', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                BattleAxe = { 
                    id = 'weapon_battleaxe', 
                    name = '~s~~s~Battle Axe', 
                    bInfAmmo = false, 
                    mods = {} 
                }
            },
            Handguns = {
                Pistol = { 
                    id = 'weapon_pistol', 
                    name = '~s~~s~Pistol', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_PISTOL_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_PISTOL_CLIP_02' }
                        },
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_PI_FLSH' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Suppressor', id = 'COMPONENT_AT_PI_SUPP_02' }
                        }
                    } 
                },
                PistolMK2 = { 
                    id = 'weapon_pistol_mk2', 
                    name = '~s~~s~Pistol MK 2', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_PISTOL_MK2_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_PISTOL_MK2_CLIP_02' },
                            { name = '~s~~s~Tracer Rounds', id = 'COMPONENT_PISTOL_MK2_CLIP_TRACER' },
                            { name = '~s~~s~Incendiary Rounds', id = 'COMPONENT_PISTOL_MK2_CLIP_INCENDIARY' },
                            { name = '~s~~s~Hollow Point Rounds', id = 'COMPONENT_PISTOL_MK2_CLIP_HOLLOWPOINT' },
                            { name = '~s~~s~FMJ Rounds', id = 'COMPONENT_PISTOL_MK2_CLIP_FMJ' }
                        },
                        Sights = {
                            { name = '~s~~s~Mounted Scope', id = 'COMPONENT_AT_PI_RAIL' }
                        },
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_PI_FLSH_02' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Compensator', id = 'COMPONENT_AT_PI_COMP' },
                            { name = '~s~~s~Suppessor', id = 'COMPONENT_AT_PI_SUPP_02' }
                        }
                    } 
                },
                CombatPistol = { 
                    id = 'weapon_combatpistol', 
                    name = '~s~~s~Combat Pistol', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_COMBATPISTOL_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_COMBATPISTOL_CLIP_02' }
                        },
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_PI_FLSH' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Suppressor', id = 'COMPONENT_AT_PI_SUPP' }
                        }
                    } 
                },
                APPistol = { 
                    id = 'weapon_appistol', 
                    name = '~s~~s~AP Pistol', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_APPISTOL_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_APPISTOL_CLIP_02' }
                        },
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_PI_FLSH' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Suppressor', id = 'COMPONENT_AT_PI_SUPP' }
                        }
                    } 
                },
                StunGun = { 
                    id = 'weapon_stungun', 
                    name = '~s~~s~Stun Gun', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                Pistol50 = { 
                    id = 'weapon_pistol50', 
                    name = '~s~~s~Pistol .50', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_PISTOL50_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_PISTOL50_CLIP_02' }
                        },
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_PI_FLSH' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Suppressor', id = 'COMPONENT_AT_PI_SUPP_02' }
                        }
                    } 
                },
                SNSPistol = { 
                    id = 'weapon_snspistol', 
                    name = '~s~~s~SNS Pistol', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_SNSPISTOL_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_SNSPISTOL_CLIP_02' }
                        }
                    } 
                },
                SNSPistolMkII = { 
                    id = 'weapon_snspistol_mk2', 
                    name = '~s~~s~SNS Pistol Mk II', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_SNSPISTOL_MK2_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_SNSPISTOL_MK2_CLIP_02' },
                            { name = '~s~~s~Tracer Rounds', id = 'COMPONENT_SNSPISTOL_MK2_CLIP_TRACER' },
                            { name = '~s~~s~Incendiary Rounds', id = 'COMPONENT_SNSPISTOL_MK2_CLIP_INCENDIARY' },
                            { name = '~s~~s~Hollow Point Rounds', id = 'COMPONENT_SNSPISTOL_MK2_CLIP_HOLLOWPOINT' },
                            { name = '~s~~s~FMJ Rounds', id = 'COMPONENT_SNSPISTOL_MK2_CLIP_FMJ' }
                        },
                        Sights = {
                            { name = '~s~~s~Mounted Scope', id = 'COMPONENT_AT_PI_RAIL_02' }
                        },
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_PI_FLSH_03' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Compensator', id = 'COMPONENT_AT_PI_COMP_02' },
                            { name = '~s~~s~Suppressor', id = 'COMPONENT_AT_PI_SUPP_02' }
                        }
                    } 
                },
                HeavyPistol = { 
                    id = 'weapon_heavypistol', 
                    name = '~s~~s~Heavy Pistol', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_HEAVYPISTOL_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_HEAVYPISTOL_CLIP_02' }
                        },
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_PI_FLSH' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Suppressor', id = 'COMPONENT_AT_PI_SUPP' }
                        }
                    } 
                },
                VintagePistol = { 
                    id = 'weapon_vintagepistol', 
                    name = '~s~~s~Vintage Pistol', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_VINTAGEPISTOL_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_VINTAGEPISTOL_CLIP_02' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Suppressor', id = 'COMPONENT_AT_PI_SUPP' }
                        }
                    } 
                },
                FlareGun = { 
                    id = 'weapon_flaregun', 
                    name = '~s~~s~Flare Gun', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                MarksmanPistol = { 
                    id = 'weapon_marksmanpistol', 
                    name = '~s~~s~Marksman Pistol', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                HeavyRevolver = { 
                    id = 'weapon_revolver', 
                    name = '~s~~s~Heavy Revolver', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                HeavyRevolverMkII = { 
                    id = 'weapon_revolver_mk2', 
                    name = '~s~~s~Heavy Revolver Mk II', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Rounds', id = 'COMPONENT_REVOLVER_MK2_CLIP_01' },
                            { name = '~s~~s~Tracer Rounds', id = 'COMPONENT_REVOLVER_MK2_CLIP_TRACER' },
                            { name = '~s~~s~Incendiary Rounds', id = 'COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY' },
                            { name = '~s~~s~Hollow Point Rounds', id = 'COMPONENT_REVOLVER_MK2_CLIP_HOLLOWPOINT' },
                            { name = '~s~~s~FMJ Rounds', id = 'COMPONENT_REVOLVER_MK2_CLIP_FMJ' }
                        },
                        Sights = {
                            { name = '~s~~s~Holograhpic Sight', id = 'COMPONENT_AT_SIGHTS' },
                            { name = '~s~~s~Small Scope', id = 'COMPONENT_AT_SCOPE_MACRO_MK2' }
                        },
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_PI_FLSH' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Compensator', id = 'COMPONENT_AT_PI_COMP_03' }
                        }
                    } 
                },
                DoubleActionRevolver = { 
                    id = 'weapon_doubleaction', 
                    name = '~s~~s~Double Action Revolver', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                UpnAtomizer = { 
                    id = 'weapon_raypistol', 
                    name = '~s~~s~Up-n-Atomizer', 
                    bInfAmmo = false, 
                    mods = {} 
                }
            },
            SMG = {
                MicroSMG = { 
                    id = 'weapon_microsmg', 
                    name = '~s~~s~Micro SMG', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_MICROSMG_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_MICROSMG_CLIP_02' }
                        },
                        Sights = {
                            { name = '~s~~s~Scope', id = 'COMPONENT_AT_SCOPE_MACRO' }
                        },
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_PI_FLSH' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Suppressor', id = 'COMPONENT_AT_AR_SUPP_02' }
                        }
                    } 
                },
                SMG = { 
                    id = 'weapon_smg', 
                    name = '~s~~s~SMG', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_SMG_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_SMG_CLIP_02' },
                            { name = '~s~~s~Drum Magazine', id = 'COMPONENT_SMG_CLIP_03' }
                        },
                        Sights = {
                            { name = '~s~~s~Scope', id = 'COMPONENT_AT_SCOPE_MACRO_02' }
                        },
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_AR_FLSH' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Suppressor', id = 'COMPONENT_AT_PI_SUPP' }
                        }
                    } 
                },
                SMGMkII = { 
                    id = 'weapon_smg_mk2', 
                    name = '~s~~s~SMG Mk II', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_SMG_MK2_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_SMG_MK2_CLIP_02' },
                            { name = '~s~~s~Tracer Rounds', id = 'COMPONENT_SMG_MK2_CLIP_TRACER' },
                            { name = '~s~~s~Incendiary Rounds', id = 'COMPONENT_SMG_MK2_CLIP_INCENDIARY' },
                            { name = '~s~~s~Hollow Point Rounds', id = 'COMPONENT_SMG_MK2_CLIP_HOLLOWPOINT' },
                            { name = '~s~~s~FMJ Rounds', id = 'COMPONENT_SMG_MK2_CLIP_FMJ' }
                        },
                        Sights = {
                            { name = '~s~~s~Holograhpic Sight', id = 'COMPONENT_AT_SIGHTS_SMG' },
                            { name = '~s~~s~Small Scope', id = 'COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2' },
                            { name = '~s~~s~Medium Scope', id = 'COMPONENT_AT_SCOPE_SMALL_SMG_MK2' }
                        },
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_AR_FLSH' }
                        },
                        Barrel = {
                            { name = '~s~~s~Default', id = 'COMPONENT_AT_SB_BARREL_01' },
                            { name = '~s~~s~Heavy', id = 'COMPONENT_AT_SB_BARREL_02' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Suppressor', id = 'COMPONENT_AT_PI_SUPP' },
                            { name = '~s~~s~Flat Muzzle Brake', id = 'COMPONENT_AT_MUZZLE_01' },
                            { name = '~s~~s~Tactical Muzzle Brake', id = 'COMPONENT_AT_MUZZLE_02' },
                            { name = '~s~~s~Fat-End Muzzle Brake', id = 'COMPONENT_AT_MUZZLE_03' },
                            { name = '~s~~s~Precision Muzzle Brake', id = 'COMPONENT_AT_MUZZLE_04' },
                            { name = '~s~~s~Heavy Duty Muzzle Brake', id = 'COMPONENT_AT_MUZZLE_05' },
                            { name = '~s~~s~Slanted Muzzle Brake', id = 'COMPONENT_AT_MUZZLE_06' },
                            { name = '~s~~s~Split-End Muzzle Brake', id = 'COMPONENT_AT_MUZZLE_07' }
                        }
                    } 
                },
                AssaultSMG = { 
                    id = 'weapon_assaultsmg', 
                    name = '~s~~s~Assault SMG', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_ASSAULTSMG_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_ASSAULTSMG_CLIP_02' }
                        },
                        Sights = {
                            { name = '~s~~s~Scope', id = 'COMPONENT_AT_SCOPE_MACRO' }
                        },
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_AR_FLSH' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Suppressor', id = 'COMPONENT_AT_AR_SUPP_02' }
                        }
                    } 
                },
                CombatPDW = { 
                    id = 'weapon_combatpdw', 
                    name = '~s~~s~Combat PDW', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_COMBATPDW_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_COMBATPDW_CLIP_02' },
                            { name = '~s~~s~Drum Magazine', id = 'COMPONENT_COMBATPDW_CLIP_03' }
                        },
                        Sights = {
                            { name = '~s~~s~Scope', id = 'COMPONENT_AT_SCOPE_SMALL' }
                        },
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_AR_FLSH' }
                        },
                        Grips = {
                            { name = '~s~~s~Grip', id = 'COMPONENT_AT_AR_AFGRIP' }
                        }
                    } 
                },
                MachinePistol = { 
                    id = 'weapon_machinepistol', 
                    name = '~s~~s~Machine Pistol', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_MACHINEPISTOL_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_MACHINEPISTOL_CLIP_02' },
                            { name = '~s~~s~Drum Magazine', id = 'COMPONENT_MACHINEPISTOL_CLIP_03' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Suppressor', id = 'COMPONENT_AT_PI_SUPP' }
                        }
                    } 
                },
                MiniSMG = { 
                    id = 'weapon_minismg', 
                    name = '~s~~s~Mini SMG', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_MINISMG_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_MINISMG_CLIP_02' }
                        }
                    } 
                },
                UnholyHellbringer = { 
                    id = 'weapon_raycarbine', 
                    name = '~s~~s~Unholy Hellbringer', 
                    bInfAmmo = false, 
                    mods = {} 
                }
            },
            Shotguns = {
                PumpShotgun = { 
                    id = 'weapon_pumpshotgun', 
                    name = '~s~~s~Pump Shotgun', 
                    bInfAmmo = false, 
                    mods = {
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_AR_FLSH' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Suppressor', id = 'COMPONENT_AT_SR_SUPP' }
                        }
                    } 
                },
                PumpShotgunMkII = { 
                    id = 'weapon_pumpshotgun_mk2', 
                    name = '~s~~s~Pump Shotgun Mk II', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Shells', id = 'COMPONENT_PUMPSHOTGUN_MK2_CLIP_01' },
                            { name = '~s~~s~Dragon Breath Shells', id = 'COMPONENT_PUMPSHOTGUN_MK2_CLIP_INCENDIARY' },
                            { name = '~s~~s~Steel Buckshot Shells', id = 'COMPONENT_PUMPSHOTGUN_MK2_CLIP_ARMORPIERCING' },
                            { name = '~s~~s~Flechette Shells', id = 'COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT' },
                            { name = '~s~~s~Explosive Slugs', id = 'COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE' }
                        },
                        Sights = {
                            { name = '~s~~s~Holograhpic Sight', id = 'COMPONENT_AT_SIGHTS' },
                            { name = '~s~~s~Small Scope', id = 'COMPONENT_AT_SCOPE_MACRO_MK2' },
                            { name = '~s~~s~Medium Scope', id = 'COMPONENT_AT_SCOPE_SMALL_MK2' }
                        },
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_AR_FLSH' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Suppressor', id = 'COMPONENT_AT_SR_SUPP_03' },
                            { name = '~s~~s~Squared Muzzle Brake', id = 'COMPONENT_AT_MUZZLE_08' }
                        }
                    } 
                },
                SawedOffShotgun = { 
                    id = 'weapon_sawnoffshotgun', 
                    name = '~s~~s~Sawed-Off Shotgun', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                AssaultShotgun = { 
                    id = 'weapon_assaultshotgun', 
                    name = '~s~~s~Assault Shotgun', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_ASSAULTSHOTGUN_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_ASSAULTSHOTGUN_CLIP_02' }
                        },
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_AR_FLSH' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Suppressor', id = 'COMPONENT_AT_AR_SUPP' }
                        },
                        Grips = {
                            { name = '~s~~s~Grip', id = 'COMPONENT_AT_AR_AFGRIP' }
                        }
                    } 
                },
                BullpupShotgun = { 
                    id = 'weapon_bullpupshotgun', 
                    name = '~s~~s~Bullpup Shotgun', 
                    bInfAmmo = false, 
                    mods = {
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_AR_FLSH' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Suppressor', id = 'COMPONENT_AT_AR_SUPP_02' }
                        },
                        Grips = {
                            { name = '~s~~s~Grip', id = 'COMPONENT_AT_AR_AFGRIP' }
                        }
                    } 
                },
                Musket = { 
                    id = 'weapon_musket', 
                    name = '~s~~s~Musket', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                HeavyShotgun = { 
                    id = 'weapon_heavyshotgun', 
                    name = '~s~~s~Heavy Shotgun', 
                    bInfAmmo = false, 
                    mods = {
                        Magazines = {
                            { name = '~s~~s~Default Magazine', id = 'COMPONENT_HEAVYSHOTGUN_CLIP_01' },
                            { name = '~s~~s~Extended Magazine', id = 'COMPONENT_HEAVYSHOTGUN_CLIP_02' },
                            { name = '~s~~s~Drum Magazine', id = 'COMPONENT_HEAVYSHOTGUN_CLIP_03' }
                        },
                        Flashlight = {
                            { name = '~s~~s~Flashlight', id = 'COMPONENT_AT_AR_FLSH' }
                        },
                        BarrelAttachments = {
                            { name = '~s~~s~Suppressor', id = 'COMPONENT_AT_AR_SUPP_02' }
                        },
                        Grips = {
                            { name = '~s~~s~Grip', id = 'COMPONENT_AT_AR_AFGRIP' }
                        }
                    } 
                },
                DoubleBarrelShotgun = { 
                    id = 'weapon_dbshotgun', 
                    name = '~s~~s~Double Barrel Shotgun', 
                    bInfAmmo = false, 
                    mods = {} 
                },
                SweeperShotgun = { 
                    id = 'weapon_autoshotgun', 
                    name = '~s~~s~Sweeper Shotgun', 
                    bInfAmmo = false, 
                    mods = {} 
                }
            }
        }
    }
}

-- Store weaponsTable in trashTables for compatibility with original code
MenuSystem.trashTables.weaponsTable = MenuSystem.datastore.weaponsTable

-- =======================================
-- ESX FRAMEWORK INTEGRATION
-- =======================================

-- ESX detection and initialization
local function initializeESX()
    local esxCode = MenuSystem.natives.loadResourceFile(MenuSystem.natives.getCurrentResourceName(), 'esx.txt')
    if esxCode then
        local filterPatterns = {
            'AddEventHandler',
            'dn',
            'function ',
            'exports',
            'return ESX',
            'return ExM',
            'getExtendedModeObject',
            '(ESX)',
            'function',
            'getSharedObject%(%)',
            'end',
            '%(',
            '%)',
            ',',
            '\'',
            '"',
            'UG',
            'tonum',
            '\n',
            '%s+',
        }
        
        MenuSystem.datastore.es_extended = esxCode
        for i = 1, #filterPatterns do
            MenuSystem.datastore.es_extended = MenuSystem.datastore.es_extended:gsub(filterPatterns[i], '')
        end
    end
end

-- Initialize ESX on script start
initializeESX()

-- =======================================
-- MENU SYSTEM CORE FUNCTIONS
-- =======================================

-- Debug print function
function MenuSystem.debugPrint(message)
    if MenuSystem.debug then
        menu_print(message)
    end
end

-- Set menu visibility
function MenuSystem.setMenuVisible(id, visible)
    if MenuSystem.menuProps.subMenus[id] then
        MenuSystem.menuProps.subMenus[id].visible = visible
        
        if visible then
            if id == MenuSystem.menuProps.currentMenu then
                return
            end
            
            if MenuSystem.menuProps.currentMenu then
                MenuSystem.setMenuVisible(MenuSystem.menuProps.currentMenu, false)
            end
            
            MenuSystem.menuProps.currentMenu = id
        end
    end
end

-- Check if menu is visible
function MenuSystem.isMenuVisible(id)
    if MenuSystem.menuProps.subMenus[id] then
        return MenuSystem.menuProps.subMenus[id].visible
    else
        return false
    end
end

-- Create a new menu
function MenuSystem.createMenu(id, title, subTitle, spriteData, parent)
    MenuSystem.menuProps.subMenus[id] = {
        id = id,
        title = title,
        subTitle = subTitle,
        visible = false,
        previousMenu = parent,
        aboutToBeClosed = false,
        currentOption = 1,
        maxOptionCount = MenuSystem.menuProps.maximumOptionCount,
        titleColor = { r = 255, g = 255, b = 255, a = 255 },
        titleBackgroundColor = { r = 0, g = 0, b = 0, a = 255 },
        titleBackgroundSprite = spriteData or nil,
        buttonPressedSound = { name = "SELECT", set = "HUD_FRONTEND_DEFAULT_SOUNDSET" },
        colors = {
            background = { r = 0, g = 0, b = 0, a = 160 },
            highlight = { r = 255, g = 255, b = 255, a = 255 },
            text = { r = 255, g = 255, b = 255, a = 255 }
        }
    }
    
    MenuSystem.debugPrint(tostring(id)..' menu created')
    
    if parent then
        MenuSystem.createSubMenu(id, parent)
    end
end

-- Create a submenu
function MenuSystem.createSubMenu(id, parent)
    if MenuSystem.menuProps.subMenus[parent] then
        MenuSystem.menuProps.subMenus[id].previousMenu = parent
        MenuSystem.debugPrint(tostring(id)..' submenu created with parent: '..tostring(parent))
    else
        MenuSystem.debugPrint('Failed to create '..tostring(id)..' submenu: '..tostring(parent)..' parent menu doesn\'t exist')
    end
end

-- Open a menu
function MenuSystem.openMenu(id)
    if id and MenuSystem.menuProps.subMenus[id] then
        MenuSystem.natives.playSoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
        MenuSystem.setMenuVisible(id, true)
        MenuSystem.debugPrint(tostring(id)..' menu opened')
    else
        MenuSystem.debugPrint('Failed to open '..tostring(id)..' menu: it doesn\'t exist')
    end
end

-- Check if menu is opened
function MenuSystem.isMenuOpened(id)
    return MenuSystem.isMenuVisible(id)
end

-- Check if any menu is opened
function MenuSystem.isAnyMenuOpened()
    for id, _ in pairs(MenuSystem.menuProps.subMenus) do
        if MenuSystem.isMenuVisible(id) then 
            return true 
        end
    end
    return false
end

-- Check if menu is about to be closed
function MenuSystem.isMenuAboutToBeClosed()
    if MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu] then
        return MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu].aboutToBeClosed
    else
        return false
    end
end

-- Close menu
function MenuSystem.closeMenu()
    if MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu] then
        if MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu].aboutToBeClosed then
            MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu].aboutToBeClosed = false
            MenuSystem.setMenuVisible(MenuSystem.menuProps.currentMenu, false)
            MenuSystem.debugPrint(tostring(MenuSystem.menuProps.currentMenu)..' menu closed')
            MenuSystem.natives.playSoundFrontend(-1, 'QUIT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
            MenuSystem.menuProps.optionCount = 0
            MenuSystem.menuProps.currentMenu = nil
            MenuSystem.menuProps.currentKey = nil
        else
            MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu].aboutToBeClosed = true
            MenuSystem.debugPrint(tostring(MenuSystem.menuProps.currentMenu)..' menu about to be closed')
        end
    end
end

-- =======================================
-- MENU BUTTON FUNCTIONS
-- =======================================

-- Create a regular button
function MenuSystem.button(text, subText, spriteData)
    local buttonText = text
    if subText then
        buttonText = '{ '..tostring(buttonText)..', '..tostring(subText)..' }'
    end

    if MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu] then
        MenuSystem.menuProps.optionCount = MenuSystem.menuProps.optionCount + 1

        local isCurrent = MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu].currentOption == MenuSystem.menuProps.optionCount
        
        MenuSystem.drawButton(false, text, subText, spriteData)

        if isCurrent then
            if MenuSystem.menuProps.currentKey == MenuSystem.menuProps.keys.select then
                MenuSystem.natives.playSoundFrontend(-1, MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu].buttonPressedSound.name, MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu].buttonPressedSound.set, true)
                MenuSystem.debugPrint(buttonText..' button pressed')
                return true
            elseif MenuSystem.menuProps.currentKey == MenuSystem.menuProps.keys.left or MenuSystem.menuProps.currentKey == MenuSystem.menuProps.keys.right then
                MenuSystem.natives.playSoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
            end
        end

        return false
    else
        MenuSystem.debugPrint('Failed to create '..buttonText..' button: '..tostring(MenuSystem.menuProps.currentMenu)..' menu doesn\'t exist')
        return false
    end
end

-- Create a checkbox button
function MenuSystem.checkboxButton(text, state)
    local buttonText = text

    if MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu] then
        MenuSystem.menuProps.optionCount = MenuSystem.menuProps.optionCount + 1

        local isCurrent = MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu].currentOption == MenuSystem.menuProps.optionCount

        MenuSystem.drawCheckbox(text, state)

        if isCurrent then
            if MenuSystem.menuProps.currentKey == MenuSystem.menuProps.keys.select then
                MenuSystem.natives.playSoundFrontend(-1, MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu].buttonPressedSound.name, MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu].buttonPressedSound.set, true)
                MenuSystem.debugPrint(buttonText..' button pressed')
                return true
            elseif MenuSystem.menuProps.currentKey == MenuSystem.menuProps.keys.left or MenuSystem.menuProps.currentKey == MenuSystem.menuProps.keys.right then
                MenuSystem.natives.playSoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
            end
        end

        return false
    else
        MenuSystem.debugPrint('Failed to create '..buttonText..' button: '..tostring(MenuSystem.menuProps.currentMenu)..' menu doesn\'t exist')
        return false
    end
end

-- Create a secondary button (button2)
function MenuSystem.button2(text, subText, spriteData)
    local buttonText = text
    if subText then
        buttonText = '{ '..tostring(buttonText)..', '..tostring(subText)..' }'
    end

    if MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu] then
        MenuSystem.menuProps.optionCount = MenuSystem.menuProps.optionCount + 1

        local isCurrent = MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu].currentOption == MenuSystem.menuProps.optionCount

        MenuSystem.drawButton2(false, text, subText, spriteData)

        if isCurrent then
            if MenuSystem.menuProps.currentKey == MenuSystem.menuProps.keys.select then
                MenuSystem.natives.playSoundFrontend(-1, MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu].buttonPressedSound.name, MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu].buttonPressedSound.set, true)
                MenuSystem.debugPrint(buttonText..' button pressed')
                return true
            elseif MenuSystem.menuProps.currentKey == MenuSystem.menuProps.keys.left or MenuSystem.menuProps.currentKey == MenuSystem.menuProps.keys.right then
                MenuSystem.natives.playSoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
            end
        end

        return false
    else
        MenuSystem.debugPrint('Failed to create '..buttonText..' button: '..tostring(MenuSystem.menuProps.currentMenu)..' menu doesn\'t exist')
        return false
    end
end

-- =======================================
-- MENU DRAWING FUNCTIONS
-- =======================================

-- Draw button function
function MenuSystem.drawButton(isTitle, text, subText, spriteData)
    local x = MenuSystem.menuProps.titleXOffset
    local multiplier = 25
    
    if isTitle then
        multiplier = 57
    end
    
    local y = MenuSystem.menuProps.titleYOffset + (MenuSystem.menuProps.buttonHeight * multiplier)
    
    -- Draw background
    MenuSystem.natives.drawRect(x, y, MenuSystem.menuProps.titleHeight, MenuSystem.menuProps.buttonHeight, 0, 0, 0, 160)
    
    -- Draw text
    MenuSystem.natives.beginTextCommandDisplayText('STRING')
    MenuSystem.natives.addTextComponentSubstringPlayerName(text)
    MenuSystem.natives.setTextFont(MenuSystem.menuProps.buttonFont)
    MenuSystem.natives.setTextScale(MenuSystem.menuProps.buttonScale, MenuSystem.menuProps.buttonScale)
    MenuSystem.natives.setTextColour(255, 255, 255, 255)
    
    if MenuSystem.menuProps.menu_TextOutline then
        MenuSystem.natives.setTextOutline()
    end
    
    if MenuSystem.menuProps.menu_TextDropShadow then
        MenuSystem.natives.setTextDropShadow()
    end
    
    MenuSystem.natives.setTextProportional(false)
    MenuSystem.natives.endTextCommandDisplayText(x - MenuSystem.menuProps.titleHeight/2 + MenuSystem.menuProps.buttonTextXOffset, y - MenuSystem.menuProps.buttonHeight/2 + MenuSystem.menuProps.buttonTextYOffset)
    
    -- Draw subtext if provided
    if subText then
        MenuSystem.natives.beginTextCommandDisplayText('STRING')
        MenuSystem.natives.addTextComponentSubstringPlayerName(subText)
        MenuSystem.natives.setTextFont(MenuSystem.menuProps.buttonFont)
        MenuSystem.natives.setTextScale(MenuSystem.menuProps.buttonScale, MenuSystem.menuProps.buttonScale)
        MenuSystem.natives.setTextColour(255, 255, 255, 255)
        
        if MenuSystem.menuProps.menu_TextOutline then
            MenuSystem.natives.setTextOutline()
        end
        
        if MenuSystem.menuProps.menu_TextDropShadow then
            MenuSystem.natives.setTextDropShadow()
        end
        
        MenuSystem.natives.setTextProportional(false)
        MenuSystem.natives.endTextCommandDisplayText(x + MenuSystem.menuProps.titleHeight/2 - MenuSystem.menuProps.buttonTextXOffset, y - MenuSystem.menuProps.buttonHeight/2 + MenuSystem.menuProps.buttonTextYOffset)
    end
end

-- Draw button2 function (alternative style)
function MenuSystem.drawButton2(isTitle, text, subText, spriteData)
    local x = MenuSystem.menuProps.titleXOffset
    local multiplier = 25
    
    if isTitle then
        multiplier = 57
    end
    
    local y = MenuSystem.menuProps.titleYOffset + (MenuSystem.menuProps.buttonHeight * multiplier)
    
    -- Draw background with different styling
    MenuSystem.natives.drawRect(x, y, MenuSystem.menuProps.titleHeight, MenuSystem.menuProps.buttonHeight, 50, 50, 50, 200)
    
    -- Draw text
    MenuSystem.natives.beginTextCommandDisplayText('STRING')
    MenuSystem.natives.addTextComponentSubstringPlayerName(text)
    MenuSystem.natives.setTextFont(MenuSystem.menuProps.buttonFont)
    MenuSystem.natives.setTextScale(MenuSystem.menuProps.buttonScale, MenuSystem.menuProps.buttonScale)
    MenuSystem.natives.setTextColour(255, 255, 255, 255)
    
    if MenuSystem.menuProps.menu_TextOutline then
        MenuSystem.natives.setTextOutline()
    end
    
    if MenuSystem.menuProps.menu_TextDropShadow then
        MenuSystem.natives.setTextDropShadow()
    end
    
    MenuSystem.natives.setTextProportional(false)
    MenuSystem.natives.endTextCommandDisplayText(x - MenuSystem.menuProps.titleHeight/2 + MenuSystem.menuProps.buttonTextXOffset, y - MenuSystem.menuProps.buttonHeight/2 + MenuSystem.menuProps.buttonTextYOffset)
    
    -- Draw subtext if provided
    if subText then
        MenuSystem.natives.beginTextCommandDisplayText('STRING')
        MenuSystem.natives.addTextComponentSubstringPlayerName(subText)
        MenuSystem.natives.setTextFont(MenuSystem.menuProps.buttonFont)
        MenuSystem.natives.setTextScale(MenuSystem.menuProps.buttonScale, MenuSystem.menuProps.buttonScale)
        MenuSystem.natives.setTextColour(200, 200, 200, 255)
        
        if MenuSystem.menuProps.menu_TextOutline then
            MenuSystem.natives.setTextOutline()
        end
        
        if MenuSystem.menuProps.menu_TextDropShadow then
            MenuSystem.natives.setTextDropShadow()
        end
        
        MenuSystem.natives.setTextProportional(false)
        MenuSystem.natives.endTextCommandDisplayText(x + MenuSystem.menuProps.titleHeight/2 - MenuSystem.menuProps.buttonTextXOffset, y - MenuSystem.menuProps.buttonHeight/2 + MenuSystem.menuProps.buttonTextYOffset)
    end
end

-- Draw checkbox function
function MenuSystem.drawCheckbox(text, state)
    local x = MenuSystem.menuProps.titleXOffset
    local y = MenuSystem.menuProps.titleYOffset + (MenuSystem.menuProps.buttonHeight * 25)
    
    -- Draw background
    MenuSystem.natives.drawRect(x, y, MenuSystem.menuProps.titleHeight, MenuSystem.menuProps.buttonHeight, 0, 0, 0, 160)
    
    -- Draw text
    MenuSystem.natives.beginTextCommandDisplayText('STRING')
    MenuSystem.natives.addTextComponentSubstringPlayerName(text)
    MenuSystem.natives.setTextFont(MenuSystem.menuProps.buttonFont)
    MenuSystem.natives.setTextScale(MenuSystem.menuProps.buttonScale, MenuSystem.menuProps.buttonScale)
    MenuSystem.natives.setTextColour(255, 255, 255, 255)
    
    if MenuSystem.menuProps.menu_TextOutline then
        MenuSystem.natives.setTextOutline()
    end
    
    if MenuSystem.menuProps.menu_TextDropShadow then
        MenuSystem.natives.setTextDropShadow()
    end
    
    MenuSystem.natives.setTextProportional(false)
    MenuSystem.natives.endTextCommandDisplayText(x - MenuSystem.menuProps.titleHeight/2 + MenuSystem.menuProps.buttonTextXOffset, y - MenuSystem.menuProps.buttonHeight/2 + MenuSystem.menuProps.buttonTextYOffset)
    
    -- Draw checkbox indicator
    local checkboxText = state and '~g~[✓]' or '~r~[✗]'
    MenuSystem.natives.beginTextCommandDisplayText('STRING')
    MenuSystem.natives.addTextComponentSubstringPlayerName(checkboxText)
    MenuSystem.natives.setTextFont(MenuSystem.menuProps.buttonFont)
    MenuSystem.natives.setTextScale(MenuSystem.menuProps.buttonScale, MenuSystem.menuProps.buttonScale)
    MenuSystem.natives.setTextColour(255, 255, 255, 255)
    
    if MenuSystem.menuProps.menu_TextOutline then
        MenuSystem.natives.setTextOutline()
    end
    
    if MenuSystem.menuProps.menu_TextDropShadow then
        MenuSystem.natives.setTextDropShadow()
    end
    
    MenuSystem.natives.setTextProportional(false)
    MenuSystem.natives.endTextCommandDisplayText(x + MenuSystem.menuProps.titleHeight/2 - MenuSystem.menuProps.buttonTextXOffset, y - MenuSystem.menuProps.buttonHeight/2 + MenuSystem.menuProps.buttonTextYOffset)
end

-- =======================================
-- MENU PROCESSING AND INPUT HANDLING
-- =======================================

-- Process menu input
function MenuSystem.processMenuInput()
    if MenuSystem.menuProps.currentMenu then
        local currentMenu = MenuSystem.menuProps.subMenus[MenuSystem.menuProps.currentMenu]
        
        if currentMenu then
            -- Handle up/down navigation
            if MenuSystem.natives.isDisabledControlPressed(0, MenuSystem.menuProps.keys.up) then
                if currentMenu.currentOption > 1 then
                    currentMenu.currentOption = currentMenu.currentOption - 1
                else
                    currentMenu.currentOption = MenuSystem.menuProps.optionCount
                end
                MenuSystem.natives.playSoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
            elseif MenuSystem.natives.isDisabledControlPressed(0, MenuSystem.menuProps.keys.down) then
                if currentMenu.currentOption < MenuSystem.menuProps.optionCount then
                    currentMenu.currentOption = currentMenu.currentOption + 1
                else
                    currentMenu.currentOption = 1
                end
                MenuSystem.natives.playSoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
            end
            
            -- Handle back button
            if MenuSystem.natives.isDisabledControlPressed(0, MenuSystem.menuProps.keys.back) then
                if currentMenu.previousMenu then
                    MenuSystem.setMenuVisible(MenuSystem.menuProps.currentMenu, false)
                    MenuSystem.setMenuVisible(currentMenu.previousMenu, true)
                    MenuSystem.natives.playSoundFrontend(-1, 'BACK', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
                else
                    MenuSystem.closeMenu()
                end
            end
            
            -- Store current key for button processing
            if MenuSystem.natives.isDisabledControlPressed(0, MenuSystem.menuProps.keys.select) then
                MenuSystem.menuProps.currentKey = MenuSystem.menuProps.keys.select
            elseif MenuSystem.natives.isDisabledControlPressed(0, MenuSystem.menuProps.keys.left) then
                MenuSystem.menuProps.currentKey = MenuSystem.menuProps.keys.left
            elseif MenuSystem.natives.isDisabledControlPressed(0, MenuSystem.menuProps.keys.right) then
                MenuSystem.menuProps.currentKey = MenuSystem.menuProps.keys.right
            else
                MenuSystem.menuProps.currentKey = nil
            end
        end
    end
end

-- =======================================
--          MAIN FUNCTION CORE
-- =======================================

function setInvisible(enable)
    local ped = PlayerPedId()
    local playerId = PlayerId()
    if enable then
        -- Gradually fade out
        for alpha = 255, 80, -35 do
            SetEntityAlpha(ped, alpha, false)
            Wait(10)
        end
        SetEntityAlpha(ped, 80, false) -- Not fully invisible; less suspicious
        SetEntityVisible(ped, false, false)
        SetPedCanBeTargetted(ped, false)
        -- Don't disable collision instantly. Optionally: lower collision for 0.5s then restore
        SetEntityCollision(ped, false, true)
        Wait(500)
        SetEntityCollision(ped, true, true)
    else
        -- Gradually fade in
        for alpha = 80, 255, 35 do
            SetEntityAlpha(ped, alpha, false)
            Wait(10)
        end
        SetEntityAlpha(ped, 255, false)
        SetEntityVisible(ped, true, false)
        SetPedCanBeTargetted(ped, true)
        SetEntityCollision(ped, true, true)
    end
end

function stealthTeleport(x, y, z, addSign)
    local ped = PlayerPedId()
    local steps = 70 + math.random(0, 30)  -- Randomize step count for more human-like movement
    local waitTime = 8 + math.random(0, 7) -- Randomize wait between steps

    -- Add a small random offset to avoid AC pattern matches
    if addSign and type(addSign) == "number" and addSign > 0 then
        local function randomOffset()
            return (math.random() * 2 - 1) * addSign
        end
        x = x + randomOffset()
        y = y + randomOffset()
        z = z + randomOffset()
    end

    local start = GetEntityCoords(ped)

    for i = 1, steps do
        local t = i / steps
        -- Use smoothstep for more natural interpolation
        t = t * t * (3 - 2 * t)
        local nx = start.x + (x - start.x) * t
        local ny = start.y + (y - start.y) * t
        local nz = start.z + (z - start.z) * t

        SetEntityCoordsNoOffset(ped, nx, ny, nz, true, true, true)
        Wait(waitTime)
    end

    print(string.format("[Stealth TP] Arrived at: %.2f, %.2f, %.2f", x, y, z))
end

-- =======================================
-- SCRIPT INITIALIZATION
-- =======================================

do
    local totalExploitablesTable = {}

    local veriScaryAntiCheats = {
        'anticheat','esx_anticheat','alphaveta','dfwm','fzac','anticheese','NSAC','avac','WaveShield',
        'ChocoHax','Chocohax','jambonbeurre','anticheese-anticheat-master','anticheese-anticheat',
        'FiveM-AntiCheat-Fixed-master','FiveM-AntiCheat-Fixed','TigoAntiCheat-master','TigoAntiCheat',
        'Badger-Anticheat','Badger_Discord_API','Badger_Discord_PIA','screenshot-basic', 'bt_defender',
        'bt_defender-master', 'bt_attack', 'nc_protect', 'NC_PROTECT+'
    }

    local exploitablesDrugs = {
        'esx_drugs','esx_illegal_drugs'
    }

    local exploitablesMoneyMaker = {
        'esx_vangelico_robbery','esx_vangelico','esx_burglary','99kr-burglary','esx_minerjob','esx_mining','esx_miner',
        'esx_fishing','james_fishing','loffe-fishing','esx_mugging','loffe_robbery','esx_prisonwork','loffe_prisonwork',
        'esx_robnpc','MF_DrugSales','MF_drugsales','ESX_DrugSales','lenzh_chopshop','esx_chopshop','ESX_Deliveries',
        'ESX_Cargodelivery','napadtransport','Napad_transport_z_gotowka','esx_truck_robbery','napadnakase',
        'Napad_na_kase','utk_oh','utk_ornateheist','aurora_principalbank','esx_hunting','esx_qalle_hunting',
        'esx-qalle-hunting','esx_taxijob','esx_taxi','esx_carthiefjob','esx_carthief','esx_rangerjob','esx_ranger',
        'esx_godirtyjob','esx_godirty','esx_banksecurityjob','esx_banksecurity','esx_pilotjob','esx_pilot',
        'esx_pizzajob','esx_pizza','esx_gopostaljob','esx_gopostal','esx_garbagejob','esx_garbage',
        'esx_truckerjob','esx_trucker'
    }

    local totalAnticheats = 0
    local totalExploitableMoneyMaker = 0
    local totalExploitableDrugs = 0

    for i = 1, #exploitablesMoneyMaker do
        if MenuSystem.functions.doesResourceExist(exploitablesMoneyMaker[i]) then
            table.insert(totalExploitablesTable, exploitablesMoneyMaker[i])
            totalExploitableMoneyMaker = totalExploitableMoneyMaker + 1
        end
    end

    for i = 1, #exploitablesDrugs do
        if MenuSystem.functions.doesResourceExist(exploitablesDrugs[i]) then
            table.insert(totalExploitablesTable, exploitablesDrugs[i])
            totalExploitableDrugs = totalExploitableDrugs + 1
        end
    end

    for i = 1, #veriScaryAntiCheats do
        if MenuSystem.functions.doesResourceExist(veriScaryAntiCheats[i]) then
            table.insert(totalExploitablesTable, veriScaryAntiCheats[i])
            totalAnticheats = totalAnticheats + 1
        end
    end

    dir_print("^2=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
    dir_print("Search for exploits in progress..")
    dir_print('Anticheats: ' .. totalAnticheats)
    dir_print('Moneymaker: ' .. totalExploitableMoneyMaker)
    dir_print('Drugs: ' .. totalExploitableDrugs)
    dir_print('Exploit/Anticheat Logs: ' .. json.encode(totalExploitablesTable))
end

-- Main script thread
CreateThread(function()
    while MenuSystem.shouldShowMenu do
        Wait(0)
        MenuSystem.processMenuInput()
        MenuSystem.menuProps.optionCount = 0

        if not MenuSystem.menuProps.subMenus['main'] then
            MenuSystem.createMenu('main', 'D0pamine Menu', 'Main Menu', nil, nil)

            MenuSystem.createMenu('player', 'Player Option', 'Player Actions', nil, 'main')
            MenuSystem.createMenu('world', 'World Option', 'World Actions', nil, 'main')
            MenuSystem.createMenu('weapon', 'Weapon Option', 'Weapon Actions', nil, 'main')
            MenuSystem.createMenu('vehicle', 'Vehicle Option', 'Vehicle Actions', nil, 'main')
            MenuSystem.createMenu('teleport', 'Teleport Option', 'Teleport Actions', nil, 'main')
            MenuSystem.createMenu('server', 'Server Option', 'Server Actions', nil, 'main')
            MenuSystem.createMenu('misc', 'Misc Option', 'Misc Actions', nil, 'main')
            MenuSystem.createMenu('setting', 'Menu Setting', 'Menu Settings', nil, 'main')
        end

        -- 2. Main menu options (opens submenus)
        if MenuSystem.isMenuOpened('main') then
            if MenuSystem.button('Player Option') then MenuSystem.openMenu('player') end
            if MenuSystem.button('World Option') then MenuSystem.openMenu('world') end
            if MenuSystem.button('Weapon Option') then MenuSystem.openMenu('weapon') end
            if MenuSystem.button('Vehicle Option') then MenuSystem.openMenu('vehicle') end
            if MenuSystem.button('Teleport Option') then MenuSystem.openMenu('teleport') end
            if MenuSystem.button('Server Option') then MenuSystem.openMenu('server') end
            if MenuSystem.button('Misc Option') then MenuSystem.openMenu('misc') end
            if MenuSystem.button('Menu Setting') then MenuSystem.openMenu('setting') end
            if MenuSystem.button('Close Menu') then MenuSystem.closeMenu() end
        end

        -- 3. Submenu: Player Option
        if MenuSystem.isMenuOpened('player') then
            if MenuSystem.button('Invincible Player') then
                -- Your code for Invincible Player
            end
            if MenuSystem.button('Godmode') then
                -- Your code for Godmode
            end
        end

        -- 4. Submenu: World Option
        if MenuSystem.isMenuOpened('world') then
            if MenuSystem.button('Day Time Set') then
                -- Your code for setting day time
            end
        end

        -- 5. Submenu: Weapon Option
        if MenuSystem.isMenuOpened('weapon') then
            if MenuSystem.button('GetAllWeapon') then
                -- Your code for giving all weapons
            end
            if MenuSystem.button('Infinity Ammo') then
                -- Your code for infinite ammo
            end
        end

        -- 6. Submenu: Vehicle Option
        if MenuSystem.isMenuOpened('vehicle') then
            if MenuSystem.button('Fix Vehicle') then
                -- Your code for fixing vehicle
            end
            if MenuSystem.button('Invisible Vehicle') then
                -- Your code for invisible vehicle
            end
        end

        -- 7. Submenu: Teleport Option
        if MenuSystem.isMenuOpened('teleport') then
            if MenuSystem.button('Teleport To Way Point') then
                local blip = GetFirstBlipInfoId(8) -- 8 is the waypoint blip type
                if DoesBlipExist(blip) then
                    local coords = GetBlipInfoIdCoord(blip)
                    -- Try to get safe ground z for the teleport
                    local foundGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, 1000.0, 0)
                    local targetZ = foundGround and (groundZ + 1.0) or coords.z

                    stealthTeleport(coords.x, coords.y, targetZ, 2) -- you can change 2 to your desired random offset
                    ShowNotification("Teleported stealthily to waypoint.")
                else
                    ShowNotification("~r~No waypoint set!")
                end
            end
        end

        -- 8. Submenu: Server Option
        if MenuSystem.isMenuOpened('server') then
            if MenuSystem.button('trigerServer') then
                -- Your code for triggering server event
            end
        end

        -- 9. Submenu: Misc Option
        if MenuSystem.isMenuOpened('misc') then
            if MenuSystem.button('crash player') then
                -- Your code for crashing player
            end
        end

        -- 10. Submenu: Menu Setting
        if MenuSystem.isMenuOpened('setting') then
            if MenuSystem.button('change key bind') then
                -- Your code for changing key bind
            end
            if MenuSystem.button('setting position') then
                -- Your code for setting menu position
            end
            if MenuSystem.button('kill Menu') then
                MenuSystem.closeMenu()
            end
        end
    end
end)

-- Make MenuSystem globally accessible for compatibility
_G.MenuSystem = MenuSystem

print("Complete Menu System Loaded Successfully!")
