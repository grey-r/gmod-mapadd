
function Init()

	local ent = HL2.FindEntityByClass(nil, "worldspawn")
	if ( ent ~= nil ) then
		HL2.KeyValue(ent, "skyname", "sky_day01_06");
	end

	local ent = HL2.FindEntityByClass(nil, "env_fog_controller")
	if ( ent ~= nil ) then
		HL2.KeyValue(ent, "fogcolor", "137 128 115");
		HL2.KeyValue(ent, "fogcolor2", "137 128 115");
		print("1111")
	end

	local ent = HL2.FindEntityByClass(nil, "sky_camera")
	if ( ent ~= nil ) then
		HL2.KeyValue(ent, "fogcolor", "137 128 115");
		HL2.KeyValue(ent, "fogcolor2", "137 128 115");
		print("12111")
	end

end


