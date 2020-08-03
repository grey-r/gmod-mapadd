
function AtamaniBousi(name)

	local ent = HL2.FindEntityByName(nil, name)
	if ( ent ~= nil ) then
		local bousi = HL2.CreateEntity("prop_dynamic", VECTORZERO, VECTORZERO)
		if( bousi ~= nil ) then
			HL2.SetEntityOwner(ent, bousi)
			HL2.SetEntityParent(ent, bousi, "eyes")
			HL2.KeyValue(bousi, "model", "models/misc/xmas/bousi.mdl")
			HL2.KeyValue(bousi, "solid", 6)
			HL2.SetEntityLocalOrigin(bousi, (HL2.Vector(-4, -.2, 1.5)))
			HL2.SetEntityLocalAngles(bousi, (HL2.Vector(0, 90, -30)))
			HL2.SpawnEntity(bousi)
		end
	end

end

function OninoMen(name)

	local ent = HL2.FindEntityByName(nil, name)
	
	while ( ent ~= nil ) do
		local onimen = HL2.CreateEntity("prop_dynamic", VECTORZERO, VECTORZERO)
		if( onimen ~= nil ) then
			local skin = HL2.RandomInt(0,1)
			HL2.SetEntityOwner(ent, onimen)
			HL2.SetEntityParent(ent, onimen, "eyes")
			HL2.KeyValue(onimen, "model", "models/misc/setubun/onimen.mdl")
			HL2.KeyValue(onimen, "solid", 6)
			HL2.KeyValue(onimen, "skin", skin)
			HL2.SetEntityLocalOrigin(onimen, (HL2.Vector(4, 0, 0)))
			HL2.SetEntityLocalAngles(onimen, VECTORZERO)
			HL2.SpawnEntity(onimen)
		end
		ent = HL2.FindEntityByName(ent, name)
	end

end


--	Merry Christmas
function Xmas()

	print("Merry Christmas\n")

	AtamaniBousi("Kleiner")
	AtamaniBousi("Eli")
	AtamaniBousi("gman")

	HL2.CallMapaddLabel("xmasset")

end 

--	Happy New Year
function NewYear()

	print("Happy New Year\n")

	HL2.CallMapaddLabel("newyearset")
	
	
	--	setkakejiku
	local vec = HL2.Vector(-6728, -1555, 40)
	local ang = HL2.Vector(0, 90, 0)
	local kakejiku = HL2.CreateEntity("prop_dynamic", vec, ang)
	if( kakejiku ~= nil ) then
		local skin = HL2.RandomInt(0,4)
		HL2.KeyValue(kakejiku, "model", "models/misc/newyear/kakejiku.mdl")
		HL2.KeyValue(kakejiku, "skin", skin)
		HL2.SpawnEntity(kakejiku)
	end

end 

--	Setubun
function Setubun()

	print("Mamemaki\n")

	HL2.CallMapaddLabel("setubun")

	OninoMen("Kleiner")
	OninoMen("gman")


end

function Init()

--	Events
	local datestr = HL2.GetDateMD()
	print(" now date > ", datestr)
	
	if( datestr == "1225" ) then
		Xmas()
	end 

	if( datestr >= "0101" and datestr <= "0103" ) then
		NewYear()
	end 

	if( datestr >= "0102" and datestr <= "0103" ) then
		HL2.CallMapaddLabel("osetimoiikedo")
	end
	
	if( datestr == "0203" ) then
		Setubun()
	end
	
	if( datestr >= "0701" and datestr <= "0831" ) then
		HL2.CallMapaddLabel("natu")
	end 

end


