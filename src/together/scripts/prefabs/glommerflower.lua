local assets =
{
    Asset("ANIM", "anim/glommer_flower.zip"),
    Asset("INV_IMAGE", "glommerflower_dead"),
}

local prefabs =
{
    "glommer",
}

local function OnLoseChild(inst, child)
    if not inst:HasTag("glommerflower") then
        return
    end

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst:AddTag("show_spoilage")
    inst.components.inventoryitem:ChangeImageName("glommerflower_dead")
    inst.AnimState:PlayAnimation("idle_dead")
    inst:RemoveTag("glommerflower")

    --V2C: I think this is trying to refresh the inventory tile
    --     because show_spoilage doesn't refresh automatically.
    --     Plz document hacks like this in the future -_ -""
    if inst.components.inventoryitem:IsHeld() then
        local owner = inst.components.inventoryitem.owner
        inst.components.inventoryitem:RemoveFromOwner(true)
        if owner.components.container ~= nil then
            owner.components.container:GiveItem(inst)
        elseif owner.components.inventory ~= nil then
            owner.components.inventory:GiveItem(inst)
        end
    end

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_LARGE_FUEL
    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
end

local function getstatus(inst)
    return not inst:HasTag("glommerflower") and "DEAD" or nil
end

local function OnPreLoad(inst, data)
    if data ~= nil and data.deadchild then
        OnLoseChild(inst)
    end
end

local function OnSave(inst, data)
    data.deadchild = not inst:HasTag("glommerflower") or nil
end

local function OnInit(inst)
    if inst:HasTag("glommerflower") then
        --Rebind Glommer
        local glommer = TheSim:FindFirstEntityWithTag("glommer")
        if glommer ~= nil and
            glommer.components.health ~= nil and
            not glommer.components.health:IsDead() and
            glommer.components.follower.leader ~= inst then
            glommer.components.follower:SetLeader(inst)
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("glommer_flower")
    inst.AnimState:SetBuild("glommer_flower")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("glommerflower")
    inst:AddTag("nonpotatable")
    inst:AddTag("irreplaceable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("leader")
    inst.components.leader.onremovefollower = OnLoseChild
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("glommerflower")

    MakeHauntableLaunch(inst)

    inst.OnPreLoad = OnPreLoad
    inst.OnSave = OnSave

    inst:DoTaskInTime(0, OnInit)

    return inst
end

return Prefab("glommerflower", fn, assets, prefabs)
