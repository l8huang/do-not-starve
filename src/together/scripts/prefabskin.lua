require("class")
require("prefabs")

local BACKPACK_DECAY_TIME = 3 * TUNING.TOTAL_DAY_TIME -- will decay after this amount of time on the ground

--tuck_torso = "full" - torso goes behind pelvis slot
--tuck_torso = "none" - torso goes above the skirt
--tuck_torso = "skirt" - torso goes betwen the skirt and pelvis (the default)
BASE_TORSO_TUCK = {}

BASE_ALTERNATE_FOR_BODY = {}
BASE_ALTERNATE_FOR_SKIRT = {}

HAS_LEG_BOOT = {}
BASE_LEGS_SIZE = {}
BASE_FEET_SIZE = {}

SKIN_FX_PREFAB = {}

--------------------------------------------------------------------------
--[[ Backpack skin functions ]]
--------------------------------------------------------------------------
local function backpack_pickedup(inst)
    if inst.decay_task ~= nil then
        inst.decay_task:Cancel()
        inst.decay_task = nil
    end
end 

local function backpack_decay_fn(inst, backpack_dropped)
    inst.decay_task = nil
    if not inst.decayed then
        inst.AnimState:SetSkin("swap_backpack_mushy", "swap_backpack")
        inst.skin_build_name = "swap_backpack_mushy"
        inst.override_skinname = "backpack_mushy"
        inst.components.inventoryitem:ChangeImageName("backpack_mushy")
        inst.decayed = true
        inst:RemoveEventCallback("ondropped", backpack_dropped)
        inst:RemoveEventCallback("onputininventory", backpack_pickedup)
    end
end

local function backpack_dropped(inst)
    if not inst.decayed then
        if inst.decay_task ~= nil then
            inst.decay_task:Cancel()
        end
        inst.decay_task = inst:DoTaskInTime(BACKPACK_DECAY_TIME, backpack_decay_fn, backpack_dropped)
    end
end

local function backpack_decay_long_update(inst, dt)
    if inst.decay_task ~= nil then
        local time_remaining = GetTaskRemaining(inst.decay_task)
        inst.decay_task:Cancel()
        if time_remaining > dt then
            inst.decay_task = inst:DoTaskInTime(time_remaining - dt, backpack_decay_fn, backpack_dropped)
        else
            backpack_decay_fn(inst, backpack_dropped)
        end
    end
end

local function backpack_skin_save_fn(inst, data)
    if inst.decayed then
        data.decayed = true
    elseif inst.decay_task ~= nil then
        data.remaining_decay_time = math.floor(GetTaskRemaining(inst.decay_task))
    end
end

local function backpack_skin_load_fn(inst, data)
    if data.decayed then
        if inst.decay_task ~= nil then
            inst.decay_task:Cancel()
        end
        backpack_decay_fn(inst, backpack_dropped)
    elseif data.remaining_decay_time ~= nil and not (inst.decayed or inst.components.inventoryitem:IsHeld()) then
        if inst.decay_task ~= nil then
            inst.decay_task:Cancel()
        end
        inst.decay_task = inst:DoTaskInTime(math.max(0, data.remaining_decay_time), backpack_decay_fn, backpack_dropped)
    end
end

function backpack_init_fn(inst, build_name)
    if not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, "swap_backpack")
    inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())

    --Now add decay logic
    inst:ListenForEvent("ondropped", backpack_dropped)
    inst:ListenForEvent("onputininventory", backpack_pickedup)
    backpack_dropped(inst)

    inst.OnSave = backpack_skin_save_fn
    inst.OnLoad = backpack_skin_load_fn
    inst.OnLongUpdate = backpack_decay_long_update
end

--------------------------------------------------------------------------
--[[ Torch skin functions ]]
--------------------------------------------------------------------------
function torch_init_fn(inst, build_name)
    if not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, "swap_torch")
    inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
end

--------------------------------------------------------------------------
--[[ Spear skin functions ]]
--------------------------------------------------------------------------
function spear_init_fn(inst, build_name)
    if not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, "swap_spear")
    inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
end

--------------------------------------------------------------------------
--[[ Hat skin functions ]]
--------------------------------------------------------------------------
function hat_init_fn(inst, build_name)
    if not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, "swap_hat")
    inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
end

tophat_init_fn = hat_init_fn
flowerhat_init_fn = hat_init_fn
strawhat_init_fn = hat_init_fn
winterhat_init_fn = hat_init_fn
catcoonhat_init_fn = hat_init_fn
rainhat_init_fn = hat_init_fn
minerhat_init_fn = hat_init_fn

--------------------------------------------------------------------------
--[[ Bedroll skin functions ]]
--------------------------------------------------------------------------
function bedroll_furry_init_fn(inst, build_name)
    if not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, "swap_bedroll_straw")
    inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
end

--------------------------------------------------------------------------
--[[ Crockpot skin functions ]]
--------------------------------------------------------------------------
function cookpot_init_fn(inst, build_name)
    if inst.components.placer == nil and not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, "cook_pot")
end

--------------------------------------------------------------------------
--[[ Chest skin functions ]]
--------------------------------------------------------------------------
function treasurechest_init_fn(inst, build_name)
    if inst.components.placer == nil and not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, "treasure_chest")
end

--------------------------------------------------------------------------
--[[ Endtable skin functions ]]
--------------------------------------------------------------------------
function endtable_init_fn(inst, build_name)
    if inst.components.placer == nil and not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, "stagehand")
end

--------------------------------------------------------------------------
--[[ Firepit skin functions ]]
--------------------------------------------------------------------------
function firepit_init_fn(inst, build_name, fxoffset)
    if inst.components.placer ~= nil then
        --Placers can run this on clients as well as servers
        inst.AnimState:SetSkin(build_name, "firepit")
        return
    elseif not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, "firepit")
    inst.components.burnable:SetFXOffset(fxoffset)
end

--------------------------------------------------------------------------
--[[ Pet skin functions ]]
--------------------------------------------------------------------------
function critter_builder_init_fn(inst, skin_name)
    inst.skin_name = skin_name
end

function pet_init_fn(inst, build_name, default_build)
    if not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, default_build)
end

function perdling_init_fn(inst, build_name, default_build, hungry_sound)
    if not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, default_build)
    inst.skin_hungry_sound = hungry_sound
end

--------------------------------------------------------------------------
--[[ Birdcage skin functions ]]
--------------------------------------------------------------------------
function birdcage_init_fn(inst, build_name)
    if inst.components.placer == nil and not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, "bird_cage")
end

--------------------------------------------------------------------------
--[[ Mushroomlight skin functions ]]
--------------------------------------------------------------------------
function mushroom_light_init_fn(inst, build_name)
    if inst.components.placer == nil and not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, "mushroom_light")
end

function mushroom_light2_init_fn(inst, build_name)
    if inst.components.placer == nil and not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, "mushroom_light2")
end

--------------------------------------------------------------------------
--[[ Lantern skin functions ]]
--------------------------------------------------------------------------
function lantern_init_fn(inst, build_name)
    if inst.components.placer == nil and not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, "lantern")
end

--------------------------------------------------------------------------
--[[ Reviver skin functions ]]
--------------------------------------------------------------------------
local function reviver_playbeatanimation(inst)
    inst.AnimState:PlayAnimation("idle")
    inst.highlightchildren[1].AnimState:PlayAnimation("idle")
end

function reviver_init_fn(inst, build_name)
    if not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, "bloodpump")
    inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())

    local skin_fx = SKIN_FX_PREFAB[build_name]
    if skin_fx ~= nil then
        inst.reviver_beat_fx = skin_fx[1]

        if skin_fx[2] ~= nil then
            local fx = SpawnPrefab(skin_fx[2])
            fx.entity:SetParent(inst.entity)
            fx.AnimState:OverrideItemSkinSymbol("bloodpump01", build_name, "bloodpumpglow", inst.GUID, "bloodpump")
            inst.highlightchildren = { fx }
            inst.PlayBeatAnimation = reviver_playbeatanimation
        end
    end
end

--------------------------------------------------------------------------
--[[ Cane skin functions ]]
--------------------------------------------------------------------------
local function cane_do_trail(inst)
    local owner = inst.components.inventoryitem:GetGrandOwner() or inst
    if not owner.entity:IsVisible() then
        return
    end

    local x, y, z = owner.Transform:GetWorldPosition()
    if owner.sg ~= nil and owner.sg:HasStateTag("moving") then
        local theta = -owner.Transform:GetRotation() * DEGREES
        local speed = owner.components.locomotor:GetRunSpeed() * .1
        x = x + speed * math.cos(theta)
        z = z + speed * math.sin(theta)
    end
    local mounted = owner.components.rider ~= nil and owner.components.rider:IsRiding()
    local map = TheWorld.Map
    local offset = FindValidPositionByFan(
        math.random() * 2 * PI,
        (mounted and 1 or .5) + math.random() * .5,
        4,
        function(offset)
            local pt = Vector3(x + offset.x, 0, z + offset.z)
            return map:IsPassableAtPoint(pt:Get())
                and not map:IsPointNearHole(pt)
                and #TheSim:FindEntities(pt.x, 0, pt.z, .7, { "shadowtrail" }) <= 0
        end
    )

    if offset ~= nil then
        SpawnPrefab(inst.trail_fx).Transform:SetPosition(x + offset.x, 0, z + offset.z)
    end
end

local function cane_equipped(inst)
    if inst._trailtask == nil then
        inst._trailtask = inst:DoPeriodicTask(6 * FRAMES, cane_do_trail, 2 * FRAMES)
    end
end

local function cane_unequipped(inst)
    if inst._trailtask ~= nil then
        inst._trailtask:Cancel()
        inst._trailtask = nil
    end
end

function cane_init_fn(inst, build_name)
    if not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, "cane")
    inst.AnimState:OverrideSymbol("grass", "swap_cane", "grass")
    inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())

    local skin_fx = SKIN_FX_PREFAB[build_name]
    if skin_fx ~= nil then
        inst.trail_fx = skin_fx[1]
        if inst.trail_fx ~= nil then
            inst:ListenForEvent("equipped", cane_equipped)
            inst:ListenForEvent("unequipped", cane_unequipped)
        end
    end
end

--------------------------------------------------------------------------
--[[ Staff skin functions ]]
--------------------------------------------------------------------------
local function staff_init_fn(inst, build_name)
    if not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, "staffs")
    inst.AnimState:OverrideSymbol("grass", "staffs", "grass")
    inst.components.inventoryitem:ChangeImageName(inst:GetSkinName())
end

function orangestaff_init_fn(inst, build_name)
    staff_init_fn(inst, build_name)

    if not TheWorld.ismastersim then
        return
    end

    local skin_fx = SKIN_FX_PREFAB[build_name]
    if skin_fx ~= nil then
        inst.trail_fx = skin_fx[1]
        if inst.trail_fx ~= nil then
            inst:ListenForEvent("equipped", cane_equipped)
            inst:ListenForEvent("unequipped", cane_unequipped)
        end

        if skin_fx[2] ~= nil then
            inst.components.blinkstaff:SetFX(skin_fx[2], skin_fx[3])
        end
    end
end

firestaff_init_fn = staff_init_fn
icestaff_init_fn = staff_init_fn

--------------------------------------------------------------------------
--[[ ResearchLab2 skin functions ]]
--------------------------------------------------------------------------
local function researchlab2_cancelflash(inst)
    for i = 1, #inst.flashtasks do
        table.remove(inst.flashtasks):Cancel()
    end
end

local function researchlab2_applyflash(inst, intensity)
    inst.AnimState:SetLightOverride(intensity * .6)
    inst.highlightchildren[1].AnimState:SetLightOverride(intensity)
end

local function researchlab2_flashupdate(inst, intensity, totalframes)
    inst.flashframe = inst.flashframe + 1
    if inst.flashframe < totalframes then
        local k = inst.flashframe / totalframes
        researchlab2_applyflash(inst, (1 - k * k) * intensity)
    else
        inst.flashfadetask:Cancel()
        inst.flashfadetask = nil
        inst.flashframe = nil
        researchlab2_applyflash(inst, 0)
    end
end

local function researchlab2_flash(inst, intensity, frames)
    if not inst.AnimState:IsCurrentAnimation("proximity_loop") then
        researchlab2_cancelflash(inst)
        return
    end
    if inst.flashfadetask ~= nil then
        inst.flashfadetask:Cancel()
    end
    inst.flashfadetask = inst:DoPeriodicTask(0, researchlab2_flashupdate, nil, intensity, frames)
    inst.flashframe = -1
    researchlab2_applyflash(inst, intensity * .5)
end

local function researchlab2_checkflashing(inst, anim, offset)
    if inst.checkanimtask ~= nil then
        inst.checkanimtask:Cancel()
        inst.checkanimtask = nil
    end
    researchlab2_cancelflash(inst)
    if anim == "proximity_loop" then
        local period = 49 * FRAMES
        table.insert(inst.flashtasks, inst:DoPeriodicTask(period, researchlab2_flash, 18 * FRAMES, .2, 8))
        table.insert(inst.flashtasks, inst:DoPeriodicTask(period, researchlab2_flash, 24 * FRAMES, .2, 10))
    end
end

local function researchlab2_checkanim(inst)
    if inst.AnimState:IsCurrentAnimation("proximity_loop") then
        inst.checkanimtask = nil
        researchlab2_checkflashing(inst, "proximity_loop", inst.AnimState:GetCurrentAnimationTime())
    else
        inst.checkanimtask = inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() - inst.AnimState:GetCurrentAnimationTime() + FRAMES, researchlab2_checkanim)
    end
end

local function researchlab2_playanimation(inst, anim, loop)
    inst.AnimState:PlayAnimation(anim, loop)
    inst.highlightchildren[1].AnimState:PlayAnimation(anim, loop)
    researchlab2_checkflashing(inst, anim, 0)
end

local function researchlab2_pushanimation(inst, anim, loop)
    local wasplaying = inst.AnimState:IsCurrentAnimation(anim)
    inst.AnimState:PushAnimation(anim, loop)
    inst.highlightchildren[1].AnimState:PushAnimation(anim, loop)
    if not wasplaying and inst.AnimState:IsCurrentAnimation(anim) then
        researchlab2_checkflashing(inst, anim, 0)
    elseif anim == "proximity_loop" and inst.checkanimtask == nil then
        inst.checkanimtask = inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() - inst.AnimState:GetCurrentAnimationTime() + FRAMES, researchlab2_checkanim)
    end
end

function researchlab2_init_fn(inst, build_name)
    if inst.components.placer ~= nil then
        --Placers can run this on clients as well as servers
        inst.AnimState:SetSkin(build_name, "researchlab2")
        return
    elseif not TheWorld.ismastersim then
        return
    end

    inst.AnimState:SetSkin(build_name, "researchlab2")
    inst.AnimState:OverrideSymbol("shadow_plume", "researchlab2", "shadow_plume")
    inst.AnimState:OverrideSymbol("shadow_wisp", "researchlab2", "shadow_wisp")

    local skin_fx = SKIN_FX_PREFAB[build_name]
    if skin_fx ~= nil and skin_fx[1] ~= nil then
        local fx = SpawnPrefab(skin_fx[1])
        fx.entity:SetParent(inst.entity)
        for i = 1, 4 do
            local symbol = "newfx"..tostring(i)
            fx.AnimState:OverrideItemSkinSymbol(symbol, build_name, symbol, inst.GUID, "researchlab2")
        end
        inst.highlightchildren = { fx }
        inst.flashtasks = {}
        inst._PlayAnimation = researchlab2_playanimation
        inst._PushAnimation = researchlab2_pushanimation
    end
end

--------------------------------------------------------------------------
--[[ ResearchLab4 skin functions ]]
--------------------------------------------------------------------------
function researchlab4_init_fn(inst, build_name)
    if inst.components.placer ~= nil then
        --Placers can run this on clients as well as servers
        inst.AnimState:OverrideItemSkinSymbol("machine_hat", build_name, "machine_hat", inst.GUID, "researchlab4")
        return
    elseif not TheWorld.ismastersim then
        return
    end

    inst.AnimState:OverrideItemSkinSymbol("machine_hat", build_name, "machine_hat", inst.GUID, "researchlab4")
end

--------------------------------------------------------------------------

function CreatePrefabSkin(name, info)
    local prefab_skin = Prefab(name, nil, info.assets, info.prefabs)
    prefab_skin.is_skin = true

    prefab_skin.base_prefab         = info.base_prefab
    prefab_skin.type                = info.type
    prefab_skin.init_fn             = info.init_fn
    prefab_skin.build_name          = info.build_name
    prefab_skin.rarity              = info.rarity
    prefab_skin.rarity_modifier     = info.rarity_modifier
    prefab_skin.skins               = info.skins
    prefab_skin.disabled            = info.disabled
    prefab_skin.granted_items       = info.granted_items

    if info.torso_tuck_builds ~= nil then
        for _,base_skin in pairs(info.torso_tuck_builds) do
            BASE_TORSO_TUCK[base_skin] = "full"
        end
    end

    if info.torso_untuck_builds ~= nil then
        for _,base_skin in pairs(info.torso_untuck_builds) do
            BASE_TORSO_TUCK[base_skin] = "untucked"
        end
    end

    if info.torso_untuck_wide_builds ~= nil then
        for _,base_skin in pairs(info.torso_untuck_wide_builds) do
            BASE_TORSO_TUCK[base_skin] = "untucked_wide"
        end
    end

    if info.has_alternate_for_body ~= nil then
        for _,base_skin in pairs(info.has_alternate_for_body) do
            BASE_ALTERNATE_FOR_BODY[base_skin] = true
        end
    end

    if info.has_alternate_for_skirt ~= nil then
        for _,base_skin in pairs(info.has_alternate_for_skirt) do
            BASE_ALTERNATE_FOR_SKIRT[base_skin] = true
        end
    end

    if info.legs_cuff_size ~= nil then
        for base_skin,size in pairs(info.legs_cuff_size) do
            BASE_LEGS_SIZE[base_skin] = size
        end
    end

    if info.feet_cuff_size ~= nil then
        for base_skin,size in pairs(info.feet_cuff_size) do
            BASE_FEET_SIZE[base_skin] = size
        end
    end

	--HAS_LEG_BOOT not yet tested
    if info.has_leg_boot_builds ~= nil then
        for _,base_skin in pairs(info.has_leg_boot_builds) do
            HAS_LEG_BOOT[base_skin] = true
        end
    end

    if info.fx_prefab ~= nil then
        SKIN_FX_PREFAB[name] = info.fx_prefab
    end

    return prefab_skin
end
