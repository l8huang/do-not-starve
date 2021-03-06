-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("DYNAMIC_ANIM", "anim/dynamic/torch_spooky.zip"),
}

return CreatePrefabSkin("torch_spooky",
{
	base_prefab = "torch",
	type = "item",
	assets = assets,
	build_name = "torch_spooky",
	rarity = "Elegant",
	prefabs = { "torchfire_spooky", },
	init_fn = function(inst) torch_init_fn(inst, "torch_spooky") end,
	fx_prefab = { "torchfire_spooky", },
})
