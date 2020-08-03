
function Init()

	local ent = HL2.FindEntityByName(nil, "antlion_tutorial_antlion")
	
	while ( ent ~= nil ) do
		HL2.KeyValue(ent, "max_health", 1000);
		ent = HL2.FindEntityByName(ent, "antlion_tutorial_antlion")
	end

	local datestr = HL2.GetDateMD()
	print(" now date > ", datestr)

	if( datestr == "0726" ) then
		HanabiTaikai()
	end 


end

function HanabiTaikai()

--	HANABI TAIKAI
	print(" hanabi taikai ")

	local ent = HL2.FindEntityByClass(nil, "worldspawn")
	if ( ent ~= nil ) then
		HL2.KeyValue(ent, "skyname", "sky_day03_06");
	end

	local ent = HL2.FindEntityByClass(nil, "env_fog_controller")
	if ( ent ~= nil ) then
		HL2.KeyValue(ent, "fogcolor", "218 169 103");
		HL2.KeyValue(ent, "fogcolor2", "218 169 103");
		HL2.KeyValue(ent, "farz", "15000");
		HL2.KeyValue(ent, "fogend", "8000");
	end

	local ent = HL2.FindEntityByClass(nil, "sky_camera")
	if ( ent ~= nil ) then
		HL2.KeyValue(ent, "fogcolor", "218 169 103");
		HL2.KeyValue(ent, "fogcolor2", "218 169 103");
	end

	HL2.CallMapaddLabel("hanabitaikai")


end

function FireHanabi(time)

	local x, y;
	x = HL2.RandomInt(8502, 10127)
	y = HL2.RandomInt(-8241, -6782)

	local pos = HL2.Vector(x, y, 290)

	local ent = HL2.CreateEntity("ef_fireworksstarter", pos, VECTORZERO)
	if ( ent ~= nil ) then
		HL2.SetEntityAbsOrigin(ent, pos)
		HL2.KeyValue(ent, "delaytime", time)
		HL2.SpawnEntity(ent)
	end

end


function Hanabi1()

	local i
	local time = 0
	for i=1, 5 do
	
		FireHanabi(time)
		time = time + 8
	end

end

function Hanabi2()

	local i
	local time = 0
	for i=1, 4 do
	
		FireHanabi(time)
		FireHanabi(time+0.5)
		time = time +  10
	end

end

function Hanabi3()

	local i
	local time = 0
	for i=0, 10 do
	
		FireHanabi(time)
		time = time + 3
	end

end

function Hanabi4()

	local i
	local time = 0
	for i=0, 3 do
	
		FireHanabi(time)
		time = time + 3
	end

	for i=0, 3 do
	
		FireHanabi(time)
		time = time + 1.5
	end

	for i=0, 3 do
	
		FireHanabi(time)
		time = time + 2
	end

	for i=0, 10 do
	
		FireHanabi(time)
		time = time + .5
	end

end


function Hanabi5()

	local i
	local time = 0
	for i=0, 10 do
	
		FireHanabi(time)
		time = time + 1
	end

	for i=0, 10 do
	
		FireHanabi(time)
		time = time + 0.2
	end

	time = time + 5
	for i=1, 40 do
	
		FireHanabi(time)
		time = time + 0.2
	end

end


function cheer()
	
	local rt
	rt = HL2.RandomInt(0,5)
	if( rt == 0 ) then
		local ent = HL2.CreateEntity("instant_trig", VECTORZERO, VECTORZERO)
		if ( ent ~= nil ) then
			HL2.KeyValue(ent, "timer", 30)
			HL2.KeyValue(ent, "label", "cheer1")
			HL2.SpawnEntity(ent)
		end
	elseif( rt == 1 )then
		local ent = HL2.CreateEntity("instant_trig", VECTORZERO, VECTORZERO)
		if ( ent ~= nil ) then
			HL2.KeyValue(ent, "timer", 30)
			HL2.KeyValue(ent, "label", "cheer2")
			HL2.SpawnEntity(ent)
		end
	elseif( rt == 2 )then
		local ent = HL2.CreateEntity("instant_trig", VECTORZERO, VECTORZERO)
		if ( ent ~= nil ) then
			HL2.KeyValue(ent, "timer", 30)
			HL2.KeyValue(ent, "label", "cheer3")
			HL2.SpawnEntity(ent)
		end
	elseif( rt == 3 )then
		local ent = HL2.CreateEntity("instant_trig", VECTORZERO, VECTORZERO)
		if ( ent ~= nil ) then
			HL2.KeyValue(ent, "timer", 30)
			HL2.KeyValue(ent, "label", "alyxtalk")
			HL2.SpawnEntity(ent)
		end
	elseif( rt == 4 )then
		local ent = HL2.CreateEntity("instant_trig", VECTORZERO, VECTORZERO)
		if ( ent ~= nil ) then
			HL2.KeyValue(ent, "timer", 30)
			HL2.KeyValue(ent, "label", "elitalk")
			HL2.SpawnEntity(ent)
		end
	elseif( rt == 5 )then
		local ent = HL2.CreateEntity("instant_trig", VECTORZERO, VECTORZERO)
		if ( ent ~= nil ) then
			HL2.KeyValue(ent, "timer", 31)
			HL2.KeyValue(ent, "label", "kletalk")
			HL2.SpawnEntity(ent)
		end
		local ent = HL2.CreateEntity("instant_trig", VECTORZERO, VECTORZERO)
		if ( ent ~= nil ) then
			HL2.KeyValue(ent, "timer", 29)
			HL2.KeyValue(ent, "label", "cheer3")
			HL2.SpawnEntity(ent)
		end
	end

end


	local type = 0

function HanabiKaisi()

	print("start type ",type)

	if( type == 0 )then
		Hanabi1()
	elseif( type == 1 )then
		Hanabi2()
	elseif( type == 2 )then
		Hanabi3()
		cheer()
	elseif( type == 3 )then
		Hanabi4()
		cheer()
	elseif( type == 4 )then
		Hanabi5()
		cheer()
		type = -1
	end
	
	type = type + 1
	
	local ent = HL2.CreateEntity("instant_trig", VECTORZERO, VECTORZERO)
	if ( ent ~= nil ) then
		HL2.KeyValue(ent, "timer", 50)
		HL2.KeyValue(ent, "label", "Hanabitugi")
		HL2.SpawnEntity(ent)
	end

end
