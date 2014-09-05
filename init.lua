local time_load_start = os.clock()

local language = minetest.setting_get("language")

if io.open(minetest.get_modpath("word_translation").."/".. language ..".lua") then
	dofile(minetest.get_modpath("word_translation").."/".. language ..".lua")
	local words = tmp
	tmp = nil
	minetest.after(1, function()
		local t1 = os.clock()
		for item,def in pairs(minetest.registered_items) do
			local old_desc = def.description
			if old_desc
			and old_desc ~= "" then
				local new_desc = words[old_desc] or ""
				if new_desc == "" then
					local current_words = string.split(old_desc, " ")
					local count = #current_words
					for n,word in ipairs(current_words) do
						local new_word = words[word] or word
						new_desc = new_desc..new_word
						if n ~= count then
							new_desc = new_desc.." "
						end
					end
				end
				if new_desc ~= ""
				and new_desc ~= old_desc then
					minetest.override_item(item, {description = new_desc})
				end
			end
		end
		words = nil
		print(string.format("[word_translation] items overridden after ca. %.2fs", os.clock() - t1))
	end)
end

print(string.format("[word_translation] loaded after ca. %.2fs", os.clock() - time_load_start))
