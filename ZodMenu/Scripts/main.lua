print("[ZodMenu] Loaded. Includes InfiBrush, IronGut, SpawnerMod, CarSpawner and TheFlash.")


-- InfiBrush Functionality (F8)
RegisterKeyBind(Key.F8, function()
    print("[InfiBrush] F8 pressed — scanning for RustBrush_C, PaintBomb_C and PolishBrush_C...")

    local targetClasses = { "RustBrush_C", "PolishBrush_C", "PaintBomb_C" }
    local propsToTry = { "Quantity", "Uses", "Count", "Charges", "Durability" }

    for _, className in ipairs(targetClasses) do
        local items = FindAllOf(className)

        for _, item in ipairs(items) do
            local modified = false
            for _, prop in ipairs(propsToTry) do
                local ok, value = pcall(function() return item[prop] end)
                if ok and value ~= nil then
                    local setOk = pcall(function()
                        item[prop] = 999999
                    end)
                    if setOk then
                        print("[InfiBrush] Set", prop, "Successful For:", item:GetFullName())
                        modified = true
                        break
                    end
                end
            end
            if not modified then
                print("[InfiBrush] No valid field found for:", item:GetFullName())
            end
        end
    end

    return false
end)


-- IronGut Functionality (F9)
local noNeeds = false
RegisterKeyBind(Key.F9, function()
    local stats = FindFirstOf("BP_PlayerStats_C")
    if not stats then
        print("[IronGut] ERROR: BP_PlayerStats_C not found.")
        return false
    end

    noNeeds = not noNeeds
    if stats.SetNoHunger then stats:SetNoHunger(noNeeds) end
    if stats.SetNoThirst then stats:SetNoThirst(noNeeds) end

    print(string.format("[IronGutToggle] %s hunger & thirst.", noNeeds and "DISABLED" or "RESTORED"))
    return false
end)


-- SpawnerMod Functionality (DEL and END)
local UEHelpers = require("UEHelpers")

RegisterKeyBind(Key.DEL, function()
    print("[SpawnerMod] Toggle requested.")
    local pc = UEHelpers:GetPlayerController()
    if not pc then print("No PlayerController found.") return end

    local widgetClass = StaticFindObject("/Game/UI/ItemSpawnerMenu/ItemSpawnerMenu.ItemSpawnerMenu_C")
    if not widgetClass then print("ItemSpawnerMenu_C not found.") return end

    local world = pc:GetWorld()
    if not world then print("No valid world context.") return end

    local spawnerWidget = StaticConstructObject(widgetClass, world)
    if not spawnerWidget then print("Failed to create widget instance.") return end

    if spawnerWidget.Construct then spawnerWidget:Construct() end
    spawnerWidget:SetVisibility(0)
    spawnerWidget:AddToViewport(0)
    pc.bShowMouseCursor = true
    print("[SpawnerMod] Spawner menu opened with cursor enabled.")
end)

RegisterKeyBind(Key.END, function()
    print("[SpawnerMod] Attempting viewport refresh hack.")
    local pc = UEHelpers:GetPlayerController()
    if not pc then print("No PlayerController found for refresh.") return end

    local dummyWidgetClass = StaticFindObject("/Game/UI/ItemSpawnerMenu/ItemSpawnerMenu.ItemSpawnerMenu_C")
    if not dummyWidgetClass then print("Dummy widget class not found.") return end

    local world = pc:GetWorld()
    if not world then print("No valid world context for refresh.") return end

    local dummyWidget = StaticConstructObject(dummyWidgetClass, world)
    if not dummyWidget then print("Failed to create dummy widget.") return end

    if dummyWidget.Construct then dummyWidget:Construct() end
    dummyWidget:SetVisibility(1)
    dummyWidget:AddToViewport(0)
    dummyWidget:RemoveFromParent()
    pc.bShowMouseCursor = false
    print("[SpawnerMod] Viewport refresh completed, mouse cursor hidden.")


    local viewportClient = FindObject("GameViewportClient", "GameEngine.GameViewport")
    if viewportClient == nil then
        print("[SpawnerMod] GameViewportClient not found.")
        return
    end

  
    local isValid, fullName = pcall(function() return viewportClient:GetFullName() end)
    if not isValid or fullName == nil then
        print("[SpawnerMod] GameViewportClient is invalid (nullptr or dead). Skipping widget cleanup.")
        return
    end

    print("[SpawnerMod] Valid GameViewportClient: " .. fullName)

    if viewportClient.RemoveAllViewportWidgets then
        local success, result = pcall(function()
            return viewportClient:RemoveAllViewportWidgets()
        end)

        if success then
            print("[SpawnerMod] Cleared all viewport widgets successfully.")
        else
            print("[SpawnerMod] Failed to clear widgets: method execution failed.")
        end
    else
        print("[SpawnerMod] RemoveAllViewportWidgets method not available.")
    end
end)


-- TheFlash Speed Boost (F1)
local function ApplyForwardVelocity(speed)
    local pc = FindFirstOf("PlayerController")
    if not pc then print("[TheFlash] No PlayerController found.") return end
    local pawn = pc.Pawn
    if not pawn then print("[TheFlash] No Pawn found.") return end
    local movementComponent = pawn.CharacterMovement or pawn.MovementComponent
    if not movementComponent then print("[TheFlash] No MovementComponent found.") return end
    local forwardVector = pawn:GetActorForwardVector()
    if not forwardVector then print("[TheFlash] No forward vector found.") return end

    local newVelocity = {
        X = forwardVector.X * speed,
        Y = forwardVector.Y * speed,
        Z = forwardVector.Z * speed
    }

    local ok = pcall(function()
        movementComponent.Velocity = newVelocity
    end)

    if ok then
        print(string.format("[TheFlash] Applied velocity: X=%.2f Y=%.2f Z=%.2f", newVelocity.X, newVelocity.Y, newVelocity.Z))
    end
end

RegisterKeyBind(112, function()
    ApplyForwardVelocity(7500.0)
    return false
end)

--Car Spawner
print("CarSpawner Loaded.")
print("Press NUMPAD SUBTRACT (-) to cycle cars, NUMPAD ADD (+) to spawn the selected car.")

-- Current car names. (Fucking remove "Pontiac" before they DMCA -_-)
local carIndex = 1
local carNames = {
    "Lada",
    "Musgoat",
    "Poyopa",
    "Trailer",
    "Caddie",
    "TriClops",
    "Pontiac",
    "IFA",
    "C18",
    "UAZ",
    "GTR",
    "Golf"
}

-- How to cycle in this fucked up cooked env? Index? Index.....
local function CycleCar()
    carIndex = carIndex + 1
    if carIndex > #carNames then
        carIndex = 1
    end
    print("Selected car: " .. carNames[carIndex])
end

-- Safely spawn the bitch
local function SpawnSelectedCar()
    local Rust = false
    local Polish = false
    local Metallic = false
    local Color = {A=1,R=1,G=1,B=1}
    local PlayerControllerClass = FindFirstOf("BP_DebugMenuComponent_C")
    if PlayerControllerClass then
        ExecuteInGameThread(function()
            PlayerControllerClass:SpawnCar(carIndex,Rust,Polish,Metallic,Color)
        end)
    end
end

-- CarSpawner Keys
RegisterKeyBind(Key.SUBTRACT, function()
    CycleCar()
end)

RegisterKeyBind(Key.ADD, function()
    SpawnSelectedCar()
end)

-- Show the default/initial car selected
print("Initial car selected: " .. carNames[carIndex])


print("[ZodMenu] Ready. F8=InfiBrush+Paint, F9=IronGut, DEL=SpawnerMod, Numpad Subtract/Add=CarSelector/Spawner END=SpawnerCloseFix, F1=TheFlash.")
