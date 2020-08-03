
function Init()

	local ent = HL2.FindEntityByName(nil, "npc_combine_croom2_1_weapon")
	if ( ent ~= nul ) then
		HL2.KeyValue(ent, "targetname", "wep1")
	end

	local ent = HL2.FindEntityByName(nil, "npc_combine_croom2_2_weapon")
	if ( ent ~= nul ) then
		HL2.KeyValue(ent, "targetname", "wep2")
	end
	
	local ent = HL2.FindEntityByClass(nil, "worldspawn")
	if ( ent ~= nil ) then
		HL2.KeyValue(ent, "skyname", "sky_day03_06");
	end

end


