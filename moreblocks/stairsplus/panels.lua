-- Load translation library if intllib is installed

local S
if (minetest.get_modpath("intllib")) then
	dofile(minetest.get_modpath("intllib").."/intllib.lua")
	S = intllib.Getter(minetest.get_current_modname())
	else
	S = function ( s ) return s end
end

-- Node will be called <modname>panel_<subname>

function register_panel(modname, subname, recipeitem, groups, images, description, drop, light)
minetest.register_node(":" .. modname .. ":panel_" .. subname .. "_bottom", {
	description = S("%s Panel"):format(S(description)),
	drawtype = "nodebox",
	tiles = images,
	light_source = light,
	drop = modname .. ":panel_" .. drop .. "_bottom",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = groups,
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0, 0.5, 0, 0.5},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0, 0.5, 0, 0.5},
	},
	sounds = default.node_sound_stone_defaults(),
	on_place = function(itemstack, placer, pointed_thing)
	if pointed_thing.type ~= "node" then
		return itemstack
	end
	
	local p0 = pointed_thing.under
	local p1 = pointed_thing.above
	if p0.y-1 == p1.y then
		local fakestack = ItemStack(modname .. ":panel_" .. subname.. "_top")
		local ret = minetest.item_place(fakestack, placer, pointed_thing)
		if ret:is_empty() then
			itemstack:take_item()
			return itemstack
		end
	end
	
	-- Otherwise place regularly
	return minetest.item_place(itemstack, placer, pointed_thing)
	end,
})

minetest.register_node(":"..modname .. ":panel_" .. subname .. "_top", {
	description = S("%s Panel"):format(S(description)),
	drawtype = "nodebox",
	tiles = images,
	light_source = light,
	drop = modname .. ":panel_" .. drop .. "_bottom",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = groups,
	node_box = {
		type = "fixed",
		fixed = {-0.5, 0, 0, 0.5, 0.5, 0.5},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, 0, 0, 0.5, 0.5, 0.5},
	},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node(":"..modname .. ":panel_" .. subname .. "_vertical", {
	description = S("%s Panel"):format(S(description)),
	drawtype = "nodebox",
	tiles = images,
	light_source = light,
	drop = modname .. ":panel_" .. drop .. "_bottom",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = groups,
	node_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0, 0, 0.5, 0.5},
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, 0, 0, 0.5, 0.5},
	},
	sounds = default.node_sound_stone_defaults(),
})

-- Recipes to cycle between panel types

minetest.register_craft({
	output = modname .. ":panel_" .. subname .. "_top",
	recipe = {
		{modname .. ":panel_" .. subname .. "_bottom"},
	},
})

minetest.register_craft({
	output = modname .. ":panel_" .. subname .. "_vertical",
	recipe = {
		{modname .. ":panel_" .. subname .. "_top"},
	},
})

minetest.register_craft({
	output = modname .. ":panel_" .. subname .. "_bottom",
	recipe = {
		{modname .. ":panel_" .. subname .. "_vertical"},
	},
})
end
