
function Init()

	local ent = HL2.FindEntityByClass(nil, "worldspawn")
	if ( ent ~= nil ) then
		HL2.KeyValue(ent, "skyname", "sky_day03_06");
	end


end


