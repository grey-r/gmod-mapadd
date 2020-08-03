
function Init()

	local ent = HL2.FindEntityByName(nil, "turret_1")
	if ( ent ~= nul ) then
		HL2.KeyValue(ent, "bullet_damage", 180)
	end
	local ent = HL2.FindEntityByName(nil, "turret_2")
	if ( ent ~= nul ) then
		HL2.KeyValue(ent, "bullet_damage", 180)
	end
	
	local ent = HL2.FindEntityByClass(nil, "worldspawn")
	if ( ent ~= nil ) then
		HL2.KeyValue(ent, "skyname", "sky_day02_06");
	end

	local ent = HL2.FindEntityByClass(nil, "env_fog_controller")
	if ( ent ~= nil ) then
		HL2.KeyValue(ent, "fogcolor", "146 162 176");
		HL2.KeyValue(ent, "fogcolor2", "146 162 176");
		print("1111")
	end

	local ent = HL2.FindEntityByClass(nil, "sky_camera")
	if ( ent ~= nil ) then
		HL2.KeyValue(ent, "fogcolor", "146 162 176");
		HL2.KeyValue(ent, "fogcolor2", "146 162 176");
		print("12111")
	end


end


