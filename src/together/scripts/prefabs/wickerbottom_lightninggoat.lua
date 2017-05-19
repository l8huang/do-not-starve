-- AUTOGENERATED CODE BY export_accountitems.lua

local assets =
{
	Asset("ANIM", "anim/ghost_wickerbottom_build.zip"),
	Asset("DYNAMIC_ANIM", "anim/dynamic/wickerbottom_lightninggoat.zip"),
}

return CreatePrefabSkin("wickerbottom_lightninggoat",
{
	base_prefab = "wickerbottom",
	type = "base",
	assets = assets,
	build_name = "wickerbottom_lightninggoat",
	rarity = "Event",
	skins = { ghost_skin = "ghost_wickerbottom_build", normal_skin = "wickerbottom_lightninggoat", },
	torso_tuck_builds = { "wickerbottom_lightninggoat", },
	has_alternate_for_body = { "wickerbottom_lightninggoat", },
	has_alternate_for_skirt = { "wickerbottom_lightninggoat", },
})
