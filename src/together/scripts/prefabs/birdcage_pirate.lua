-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("DYNAMIC_ANIM", "anim/dynamic/birdcage_pirate.zip"),
}

return CreatePrefabSkin("birdcage_pirate",
{
	base_prefab = "birdcage",
	type = "item",
	assets = assets,
	build_name = "birdcage_pirate",
	rarity = "Loyal",
	init_fn = function(inst) birdcage_init_fn(inst, "birdcage_pirate") end,
})
