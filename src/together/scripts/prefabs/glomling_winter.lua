-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("DYNAMIC_ANIM", "anim/dynamic/glomling_winter.zip"),
}

return CreatePrefabSkin("glomling_winter",
{
	base_prefab = "critter_glomling",
	type = "item",
	assets = assets,
	build_name = "glomling_winter",
	rarity = "Elegant",
	init_fn = function(inst) pet_init_fn(inst, "glomling_winter", "glomling_build" ) end,
})
