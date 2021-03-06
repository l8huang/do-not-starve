-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("ANIM", "anim/ghost_wolfgang_build.zip"),
	Asset("ANIM", "anim/wolfgang_mighty.zip"),
	Asset("ANIM", "anim/wolfgang.zip"),
	Asset("ANIM", "anim/wolfgang_skinny.zip"),
}

return CreatePrefabSkin("wolfgang_none",
{
	base_prefab = "wolfgang",
	type = "base",
	assets = assets,
	build_name = "wolfgang",
	rarity = "Common",
	skins = { ghost_skin = "ghost_wolfgang_build", mighty_skin = "wolfgang_mighty", normal_skin = "wolfgang", wimpy_skin = "wolfgang_skinny", },
	torso_tuck_builds = { "wolfgang", "wolfgang_skinny", "wolfgang_mighty", },
})
