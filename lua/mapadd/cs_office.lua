local	TEAMALYX = 1
local	CITIZENNUM = 4
local	COMBINENUM = 16
local	SQUADS = 8
local	HOSTAGES = 3

local	CITIZENSPAWNPOINT = "info_player_counterterrorist"
local	COMBINESPAWNPOINT = "info_player_terrorist"
local	HOSTAGESPAWNPOINT = "info_target"

local HOSTAGEPOSITIONS = {
	Vector(1955.426392,-281.327850,-159.968750),
	Vector(2296.259033,-28.475822,-159.968750),
	Vector(1979.598511,-10.876556,-159.968750)
}

--local	COMBINESPAWNPOINT = "info_player_counterterrorist"
--local	CITIZENSPAWNPOINT = "info_player_terrorist"

local	END_FLG = false

function Init()


end

function EscortHostage()

	HL2.SetEntityRelationshipName2("csquad*", "hostage", DISPOSITION.D_HT, 1)
	HL2.SetEntityRelationshipName2("hostage", "csquad*", DISPOSITION.D_FR, 1)

--	*****	spawn combine

	cnt = COMBINENUM
	ent = HL2.FindEntityByClass(nil, CITIZENSPAWNPOINT)
	local sn = 1
	local sncnt = 1
	local sqn = cnt / SQUADS 
	while ent ~= nil do
		
		local ang = HL2.GetEntityAbsAngles(ent)
		local org = HL2.GetEntityAbsOrigin(ent)
		
		local squadname = "csquad" .. sn
		SpawnCombine(org, ang, squadname)
		sncnt = sncnt + 1
		if sncnt > sqn then 
			sncnt = 1
			sn = sn + 1
		end
		
		ent = HL2.FindEntityByClass(ent, CITIZENSPAWNPOINT)

		cnt = cnt - 1
		if cnt == 0 then break end
		
	end



end

function SpawnHostage(org, ang)

	local cit = HL2.CreateEntity("npc_citizen", org, ang)
	if( cit ~= nil ) then
		HL2.KeyValue(cit, "targetname", "hostage")
		HL2.KeyValue(cit, "runspeedmod", 1.2)
		HL2.SpawnEntity(cit)

		local it = HL2.CreateEntity("instant_trig", org, ang)
		if( it ~= nil ) then
			HL2.KeyValue(it, "label", "takeshostage")
			HL2.KeyValue(it, "radius", 200)
			HL2.KeyValue(it, "group", 1)
			HL2.KeyValue(it, "removegroup", 1)
			HL2.SpawnEntity(it)
		end
		
	end

end 

function SpawnHostages()

	local cnt = HOSTAGES
	--local ent = HL2.FindEntityByClass(nil, HOSTAGESPAWNPOINT)
	--while ent ~= nil do
		
		--local ang = HL2.GetEntityAbsAngles(ent)
		--local org = HL2.GetEntityAbsOrigin(ent)

		--print("spawnhostages calling spawnhostage")
	
	for _,org in pairs(HOSTAGEPOSITIONS) do
		
		SpawnHostage(org, VECTORZERO )
		
		ent = HL2.FindEntityByClass(ent, HOSTAGESPAWNPOINT)

		cnt = cnt - 1
		if cnt == 0 then break end

	end

end

function SpawnGordon(org, ang)

	local plr = HL2.GetPlayer()
	if plr ~= nil then
		HL2.SetEntityAbsOrigin(plr, org)
		HL2.SetEntityAbsAngles(plr, ang)
		local item = HL2.CreateEntity("item_suit", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("weapon_pistol", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("item_ammo_pistol", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("weapon_smg1", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("item_ammo_smg1", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("item_ammo_smg1", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("weapon_frag", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("weapon_frag", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("weapon_crowbar", org, ang)
		HL2.SpawnEntity(item)
	end

--	local i
--	for i = 1, 10, 1 do
--		local wep = HL2.CreateEntity(GetWeaponName(), HL2.Vector(133, -1340, 399 - sq * 30), VECTORZERO)
--		if wep ~= nil then
--			HL2.SpawnEntity(wep)
--		end
--	end
	
end


local wep_name = {	"weapon_smg1", 
			"weapon_ak47",
			"weapon_ar2",
			"weapon_mp5",
			"weapon_kar98",
			"weapon_shotgun",
			"weapon_ak47"
		}

function GetWeaponName()

	local rt = HL2.RandomInt(1, 7)
	
	return wep_name[rt]

end


local npc_name = {	"npc_combine_s",
			"npc_combine_s", --once was combine_e in smod
			"npc_metropolice"
		}

function GetNPCName()

	local rt = HL2.RandomInt(1, 3)
	
	return npc_name[rt]

end

function SpawnCitizen(org, ang)

	
	local cit = HL2.CreateEntity("npc_citizen", org, ang)
	if( cit ~= nil ) then
		print("cit spawned")
		local rt = HL2.RandomInt(1,#wep_name)
		local sf = 1024 + 8192
		if HL2.RandomInt(0,5) == 1 then
			sf = sf + 131072
		end
		if HL2.RandomInt(0,5) == 1 then
			sf = sf + 65536 + 1048576
		end
		HL2.KeyValue(cit, "additionalequipment", GetWeaponName())
		HL2.KeyValue(cit, "squadname", "citizen")
		HL2.KeyValue(cit, "spawnflags", sf)
--		HL2.KeyValue(cit, "citizentype", HL2.RandomInt(0,3))
		HL2.KeyValue(cit, "citizentype", 3)
		HL2.KeyValue(cit, "runspeedmod", HL2.RandomFloat(0.6, 1.2))
		HL2.SpawnEntity(cit)
	end
 
end

function SpawnCombine(org, ang, sqn)

	local npcname = GetNPCName()
	local cb = HL2.CreateEntity(npcname, org, ang)
	if( cb ~= nil ) then
		print("combine made")
		local rt = HL2.RandomInt(1,SQUADS)
		local sf = 1024
		if npcname == "npc_combine_s" then
			if HL2.RandomInt(0,1) == 0 then
				HL2.KeyValue(cb, "model", "models/combine_soldier_prisonguard.mdl")
			end
		end
	
		if HL2.RandomInt(0,3) >= 1 then
			sf = sf + 8192
		end
		if HL2.RandomInt(0,6) == 1 then
			sf = sf + 256
		end
		
		--	speed hacker
		if HL2.RandomInt(0,20) == 1 then
			HL2.KeyValue(cb, "runspeedmod", "3")
		else
			HL2.KeyValue(cb, "runspeedmod", HL2.RandomFloat(1.0,1.4))
		end
		
		HL2.KeyValue(cb, "spawnflags", sf)	
		HL2.KeyValue(cb, "additionalequipment", GetWeaponName())
		HL2.KeyValue(cb, "NumGrenades", HL2.RandomInt(0,3))
		HL2.KeyValue(cb, "squadname", "combines" .. rt)
		HL2.KeyValue(cb, "targetname", sqn)
		HL2.SpawnEntity(cb)
		
	end

end


function CheckEnemy()

	local found = 0
	local sq

	for sq = 1, SQUADS, 1 do
	
		local ent = HL2.FindEntityByName(nil, "csquad" .. sq)
		while ent ~= nil do
			found = found + 1
			ent = HL2.FindEntityByName(ent, "csquad" .. sq)
		end
	end
	
--	if found == 0 and END_FLG == false then
--		HL2.CallMapaddLabel("clear")
--		END_FLG = true
--	elseif END_FLG == false then
--		HL2.ShowHUDMessage("\n\n\n\n\n\nRemaining " .. found .. " Combines")
--	end 

end

function MoveTo(squad)

	local nodes = HL2.GetNodeCounts()
	local node = HL2.GetNodeData(HL2.RandomInt(0,nodes-1))
	print("FOUND NODE")
	print(node)
	if node ~= nil then
		local org = HL2.Vector(node.x, node.y, node.z)
		local targ = HL2.CreateEntity("info_target", org, VECTORZERO)
		if targ ~= nil then
			--print(squad , "move to ", HL2.VectorString(org))
			HL2.KeyValue(targ, "targetname", "mvtg" .. squad)
			HL2.SpawnEntity(targ)
		end 
		local gf = HL2.CreateEntity("ai_goal_follow", org, VECTORZERO)
		if( gf ~= nil ) then
			HL2.KeyValue(gf, "startactive", "1")
			HL2.KeyValue(gf, "actor", squad)
			HL2.KeyValue(gf, "formation", "1")
			HL2.KeyValue(gf, "searchtype", "0")
			HL2.KeyValue(gf, "goal", "mvtg" .. squad)
			HL2.KeyValue(gf, "MaximumState", "2")
			HL2.KeyValue(gf, "targetname", "mvgf" .. squad)
			HL2.SpawnEntity(gf)
		end
		local it = HL2.CreateEntity("instant_trig", org, VECTORZERO)
		if( it ~= nil ) then
			HL2.KeyValue(it, "radius", "300")
			HL2.KeyValue(it, "targetname", "mvit" .. squad)
			HL2.KeyValue(it, "touchname", squadname)
			HL2.KeyValue(it, "OnHitTrigger", "mvgf" .. squad .. ",kill,,0,-1")
			HL2.SpawnEntity(it)
		end
	end 

end

function SpawnTeamAlyx(ent)


--	alyx
	ent = HL2.FindEntityByClass(ent, CITIZENSPAWNPOINT)
	if ent ~= nil then
		local ang = HL2.GetEntityAbsAngles(ent)
		local org = HL2.GetEntityAbsOrigin(ent)
		local npc = HL2.CreateEntity("npc_alyx", org, ang)
		if npc ~= nil then
			HL2.KeyValue(npc, "additionalequipment", "weapon_alyxgun")
			HL2.KeyValue(npc, "squadname", "teamalyx")
			HL2.KeyValue(npc, "targetname", "teamalyx")
			HL2.KeyValue(npc, "spawnflags", "1024")
			HL2.SpawnEntity(npc)
		end
	end

--	barney
	ent = HL2.FindEntityByClass(ent, CITIZENSPAWNPOINT)
	if ent ~= nil then
		local ang = HL2.GetEntityAbsAngles(ent)
		local org = HL2.GetEntityAbsOrigin(ent)
		local npc = HL2.CreateEntity("npc_barney", org, ang)
		if npc ~= nil then
			HL2.KeyValue(npc, "additionalequipment", "weapon_ar2")
			HL2.KeyValue(npc, "squadname", "teamalyx")
			HL2.KeyValue(npc, "targetname", "teamalyx")
			HL2.KeyValue(npc, "spawnflags", "1024")
			HL2.SpawnEntity(npc)
		end
	end

--	?
	ent = HL2.FindEntityByClass(ent, CITIZENSPAWNPOINT)
	if ent ~= nil then
		local ang = HL2.GetEntityAbsAngles(ent)
		local org = HL2.GetEntityAbsOrigin(ent)
		local npc = HL2.CreateEntity("npc_um_citizen", org, ang)
		if npc ~= nil then
			HL2.KeyValue(npc, "additionalequipment", "weapon_shotgun")
			HL2.KeyValue(npc, "targetname", "teamalyx")
			HL2.KeyValue(npc, "squadname", "teamalyx")
			HL2.KeyValue(npc, "spawnflags", 1024 + 1048576)
			HL2.SpawnEntity(npc)
		end
	end

end


function MoveCombine()

	CheckEnemy()

	local sq

	for sq = 1, SQUADS, 1 do
	
		MoveTo("csquad" .. sq)
	
	end

	local it = HL2.CreateEntity("instant_trig", VECTORZERO, VECTORZERO)
	if( it ~= nil ) then
		HL2.KeyValue(it, "label", "cmovestop")	
		HL2.KeyValue(it, "timer", HL2.RandomInt(30,40))
		HL2.SpawnEntity(it)
	end

	if TEAMALYX == 1 then
		MoveTo("teamalyx")
		HL2.EntFire("followalyx", nil, "StartSchedule", 0, -1)
	end
	
end



function RoundInit()

	
--	*****	spawn hostages
	SpawnHostages()

	
--	****	spawn citizen

	local cnt = CITIZENNUM
	local firstspawn = 1

	local ent = HL2.FindEntityByClass(nil, CITIZENSPAWNPOINT)
	while ent ~= nil do
		
		local ang = HL2.GetEntityAbsAngles(ent)
		local org = HL2.GetEntityAbsOrigin(ent)


		if firstspawn == 1 then
			SpawnGordon(org, ang)
		else
			SpawnCitizen(org, ang)
		end
		
		ent = HL2.FindEntityByClass(ent, CITIZENSPAWNPOINT)
		
		firstspawn = 0

		cnt = cnt - 1
		if cnt == 0 then break end
		
	end


--	*****	spawn team alyx
	
	if TEAMALYX == 1 then
		SpawnTeamAlyx(ent)
	end
	

--	*****	spawn combine

	cnt = COMBINENUM
	ent = HL2.FindEntityByClass(nil, COMBINESPAWNPOINT)
	local sn = 1
	local sncnt = 1
	local sqn = COMBINENUM / SQUADS
	while ent ~= nil do
		
		local ang = HL2.GetEntityAbsAngles(ent)
		local org = HL2.GetEntityAbsOrigin(ent)
		
		local squadname = "csquad" .. sn
		SpawnCombine(org, ang, squadname)
		sncnt = sncnt + 1
		if sncnt > sqn then 
			sncnt = 1
			sn = sn + 1
		end
		
		ent = HL2.FindEntityByClass(ent, COMBINESPAWNPOINT)

		cnt = cnt - 1
		if cnt == 0 then break end
		
	end

	HL2.SetEntityRelationshipName2("csquad*", "hostage", DISPOSITION.D_NU, 1)
	HL2.SetEntityRelationshipName2("hostage", "csquad*", DISPOSITION.D_NU, 1)

	
end


function StopEnemies()

	local ent = HL2.FindEntityByName(nil, "csquad*")
	while ent ~= nil do
		
		local org = HL2.Vector(2121, 1310, -237)
		HL2.SetEntityAbsOrigin(ent, org)
		ent = HL2.FindEntityByName(ent, "csquad*")
	end
	

end

