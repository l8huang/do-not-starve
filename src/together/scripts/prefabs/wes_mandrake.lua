-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("ANIM", "anim/ghost_wes_build.zip"),
	Asset("DYNAMIC_ANIM", "anim/dynamic/wes_mandrake.zip"),
}

return CreatePrefabSkin("wes_mandrake",
{
	base_prefab = "wes",
	type = "base",
	assets = assets,
	build_name = "wes_mandrake",
	rarity = "Event",
	skins = { ghost_skin = "ghost_wes_build", normal_skin = "wes_mandrake", },
	torso_tuck_builds = { "wes_mandrake", },
	has_alternate_for_body = { "wes_mandrake", },
	has_alternate_for_skirt = { "wes_mandrake", },
})
