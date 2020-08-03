local	TEAMALYX = 1
local	CITIZENNUM = 6
local	COMBINENUM = 10
local	SQUADS = 16
local	GAMEEND = false
local   ENEMYCOUNT = 0
local	SPAWNLIMIT = 20
local   KILLCOUNT = 0
local   NPCNAMES = {
					"npc_headcrab", "npc_antlion",
					"npc_combine_ace", "npc_zombie",
					"npc_houndeye", "npc_zombie2"
					}
					
local	CITIZENSPAWNPOINT = "info_player_allies"
local	COMBINESPAWNPOINT = "info_player_axis"


local	END_FLG = false


function SpawnGordon(org, ang)

	local plr = HL2.GetPlayer()
	if plr ~= nil then
		HL2.SetEntityAbsOrigin(plr, org)
		HL2.SetEntityAbsAngles(plr, ang)
		local item = HL2.CreateEntity("item_suit", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("weapon_ar2", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("item_ammo_ar2", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("item_ammo_ar2", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("weapon_frag", org, ang)
		HL2.SpawnEntity(item)
		item = HL2.CreateEntity("weapon_frag", org, ang)
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
			"weapon_grease",
			"weapon_kar98",
			"weapon_ak47"
		}

function GetWeaponName()

	local rt = HL2.RandomInt(1, 4)
	
	return wep_name[rt]

end

--these are the combine weapons. Some are repeated to make them slightly more likely to occur. Sniper rifles should be uncommon in comparison to more traditional weapons.
local wep_name1 = {	"weapon_oicw",
			"weapon_mp5",  
			"weapon_ar2",
			"weapon_smg1",
			"weapon_shotgun"
		}

function GetWeaponName1()

	local rt = HL2.RandomInt(1, 5)
	
	return wep_name1[rt]

end

local npc_name = {	"npc_combine_s",
			"npc_combine_e",
			"npc_metropolice"
		}

function GetNPCName()

	local rt = HL2.RandomInt(1, 3)
	
	return npc_name[rt]

end

function InstantSpawnEntity(class, pos)

	local ent = HL2.CreateEntity(class, pos, VECTORZERO)
	if ent ~= nil then
		HL2.SpawnEntity(ent)
	end

	return ent

end

function IncreaseMoney(amount)
	local money = HL2.GetMoney()
	money = money + amount
	HL2.SetMoney(money)
end


function PlayerRandomSpawn()

	local pos = GetRandomNodePosition()
	if pos ~= nil then
	    local   plr = HL2.GetPlayer()
	    if plr ~= nil then
			HL2.SetAbsOrigin(plr, pos)
			InstantSpawnEntity("item_suit", pos)
			InstantSpawnEntity("weapon_crowbar", pos)
	    end
	end

end

function GetRandomNodePosition()

	local nodes = HL2.GetNodeCounts()
	local retorg = nil

   	if nodes >= 1 then
		local node  = HL2.GetNodeData(HL2.RandomInt(0,nodes-1))
		if node ~= nil then
			retorg = HL2.Vector(node.x, node.y + 16, node.z)
		end
	end

	return retorg

end


function SpawnEnemy()

	local pos = GetRandomNodePosition()
	local ent = nil

	if pos ~= nil then

	    local npcname = NPCNAMES[HL2.RandomInt(1, table.getn(NPCNAMES))]

	    print("Spawn -> " .. npcname)

	    local ang = HL2.Vector(0, HL2.RandomInt(0, 359), 0)

		ent = HL2.CreateEntity(npcname, pos, ang)
		if ent ~= nil then

			local pent = HL2.GetPlayer()
			local visinfo = HL2.CheckVisible(pent, ent)
			if visinfo.IsVisible ~= 1 then

			    if npcname == "npc_headcrab" then
					HL2.KeyValue(ent, "startburrowed", 1)
				end

			    if npcname == "npc_combine_ace" then
	    	HL2.KeyValue(ent, "additionalequipment", GetWeaponName1())
        HL2.KeyValue(ent, "NumGrenades", HL2.RandomInt(2,2))		
				end				

				HL2.KeyValue(ent, "spawnflags", 1024 )
				HL2.KeyValue(ent, "targetname", "enemy")		
				HL2.KeyValue(ent, "squadname", HL2.RandomInt(1, 5))
				HL2.KeyValue(ent, "runspeedmod", HL2.RandomFloat(1.0, 2.0))

	    		HL2.SpawnEntity(ent)
	    		ENEMYCOUNT = ENEMYCOUNT + 1
			else
			    HL2.RemoveEntity(ent)
			end
		end

	end

	return ent

end

function StatusTimer()

	if GAMEEND == true then
		return 0
	end

	HL2.ShowInfoMessage(0, 2, ENEMYCOUNT .. " ENEMIES.")
	return 2
	
end


function SpawnTimer()

	if GAMEEND == true then
		return 0
	end

	if ENEMYCOUNT < SPAWNLIMIT then
		SpawnEnemy()
	end

	return 5

end

function Killed(info)

	local entinfo = HL2.GetEntInfo(info.KilledEnt)

    print("damagetype : " .. info.DamageType)

	if entinfo.Name == "enemy" then
		ENEMYCOUNT = ENEMYCOUNT - 1
		KILLCOUNT = KILLCOUNT + 1
		end	
		if entinfo.Name == "combines" then
		ENEMYCOUNT = ENEMYCOUNT - 1
		KILLCOUNT = KILLCOUNT + 1		
--		if info.DamageType == 128 then
			--  with crowbar
--			IncreaseMoney(3)
--		else
--			IncreaseMoney(1)
--		end
	end

	if info.IsPlayer == 1 then
	    GameOver()
	end

end

function SpawnCitizen(org, ang)

	
	local cit = HL2.CreateEntity("npc_citizen", org, ang)
	if( cit ~= nil ) then
		local rt = HL2.RandomInt(1,wep_name.getn)
		local sf = 1024 + 8192
		if HL2.RandomInt(0,5) == 1 then
			sf = sf + 131072
		end
--		if HL2.RandomInt(0,5) == 1 then
			sf = sf + 65536 + 1048576
--		end
		HL2.KeyValue(cit, "additionalequipment", GetWeaponName())
		HL2.KeyValue(cit, "squadname", "citizen")
		HL2.KeyValue(cit, "spawnflags", sf)
		HL2.KeyValue(cit, "targetname", "citizen")
		HL2.KeyValue(cit, "citizentype", 3)
		HL2.KeyValue(cit, "runspeedmod", HL2.RandomFloat(0.8, 1.2))
		HL2.SpawnEntity(cit)
	end
 
end

function SpawnCombine(org, ang, sqn)

	local npcname = GetNPCName()
	local cb = HL2.CreateEntity(npcname, org, ang)
	if( cb ~= nil ) then
		local rt = HL2.RandomInt(1,SQUADS)
		local sf = 1024 + 8192
		if npcname == "npc_combine_s" then
			if HL2.RandomInt(0,1) == 0 then
				HL2.KeyValue(cb, "model", "models/combine_soldier_prisonguard.mdl")
			end
		end
	
		if HL2.RandomInt(0,6) == 1 then
			sf = sf + 256
		end
		
		HL2.KeyValue(cb, "runspeedmod", HL2.RandomFloat(0.8, 1.2))
		HL2.KeyValue(cb, "spawnflags", sf)	
		HL2.KeyValue(cb, "additionalequipment", GetWeaponName1())
		HL2.KeyValue(cb, "NumGrenades", HL2.RandomInt(2,2))
		HL2.KeyValue(cb, "squadname", "combines" .. rt)
		HL2.KeyValue(cb, "targetname", sqn)
		HL2.SpawnEntity(cb)
	  ENEMYCOUNT = ENEMYCOUNT + 1		
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

	return found
end

function CheckCitizen()

	local found = 0

	local ent = HL2.FindEntityByName(nil, "citizen")
	while ent ~= nil do
		found = found + 1
		ent = HL2.FindEntityByName(ent, "citizen")
	end

	return found
end



function MoveTo(squad)

	local nodes = HL2.GetNodeCounts()
	local node = HL2.GetNodeData(HL2.RandomInt(0,nodes-1))
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

--	CheckEnemy()

	local sq

	for sq = 1, SQUADS, 1 do
	
		MoveTo("csquad" .. sq)
	
	end

	local it = HL2.CreateEntity("instant_trig", VECTORZERO, VECTORZERO)
	if( it ~= nil ) then
		HL2.KeyValue(it, "label", "cmovestop")	
		HL2.KeyValue(it, "timer", HL2.RandomInt(20,30))
		HL2.SpawnEntity(it)
	end

	if TEAMALYX == 1 then
		MoveTo("teamalyx")
		HL2.EntFire("followalyx", nil, "StartSchedule", 0, -1)
	end
	
end

function RespawnCitizen()

	local maxs = HL2.Vector(1, 1, 1)
	local mins = HL2.Vector(-1, -1, -1)


	local cnt = CITIZENNUM - CheckCitizen()

	print("respawn citizen ", cnt)

	if cnt > 0 then
		ent = HL2.FindEntityByClass(nil, CITIZENSPAWNPOINT)
		while ent ~= nil do
	
			local ang = HL2.GetEntityAbsAngles(ent)
			local org = HL2.GetEntityAbsOrigin(ent)
	
			local chkorg = org
			chkorg.z = chkorg.z + 10
	
			local check = HL2.CheckRoom(chkorg, mins, maxs)
			
			if check == 0 then
				SpawnCitizen(org, ang)
				cnt = cnt - 1
				if cnt == 0 then break end
			else
				print("no room")
			end
			
			ent = HL2.FindEntityByClass(ent, CITIZENSPAWNPOINT)
	
		end
	end 

end


function SpawnCombines()

	local maxs = HL2.Vector(1, 1, 1)
	local mins = HL2.Vector(-1, -1, -1)


	local cnt = COMBINENUM - CheckEnemy()

	print("respawn combine ", cnt)

	if cnt > 0 then
		ent = HL2.FindEntityByClass(nil, COMBINESPAWNPOINT)
		while ent ~= nil do
	
			local ang = HL2.GetEntityAbsAngles(ent)
			local org = HL2.GetEntityAbsOrigin(ent)
	
			local chkorg = org
			chkorg.z = chkorg.z + 10
	
			local check = HL2.CheckRoom(chkorg, mins, maxs)
			
			if check == 0 then
				local squadname = "csquad" .. HL2.RandomInt(1, SQUADS)
				SpawnCombine(org, ang, squadname)
				cnt = cnt - 1
				if cnt == 0 then break end
			else
				print("no room")
			end
			
			ent = HL2.FindEntityByClass(ent, COMBINESPAWNPOINT)
	
		end
	end 

end

function RoundInit()

 	HL2.CreateTimer("SpawnTimer", 3)
 	HL2.CreateTimer("StatusTimer", 2)
	HL2.HookKilledEvent("Killed")

	local i;

	for i=1, 10, 1 do
		SpawnEnemy()
	end	
	
--	****	spawn citizen

	local cnt = CITIZENNUM
	local firstspawn = 1

	local ent = HL2.FindEntityByClass(nil, CITIZENSPAWNPOINT)
	if ent ~= nil then
		
		local ang = HL2.GetEntityAbsAngles(ent)
		local org = HL2.GetEntityAbsOrigin(ent)

		SpawnGordon(org, ang)
	end
	
--	spawn citizen

	RespawnCitizen()

--	*****	spawn team alyx
	
	if TEAMALYX == 1 then
		SpawnTeamAlyx(ent)
	end
	

--	*****	spawn combine

	SpawnCombines()
	
end


function RemoveEnemiesWeapon()

	local sq

	for sq = 1, SQUADS, 1 do
	
		local name = "csquad" .. sq
		
		HL2.EntFire(name, nil, "ignite", 0, 0)
		
	end
	
	HL2.EntFire("ssquad", nil, "ignite", 0, 0)
	
end

function GameOver()

	HL2.HookKilledEvent()
	GAMEEND = true
	HL2.CallMapaddLabel("GameOver")
	HL2.ShowInfoMessage(1, 15, " " .. KILLCOUNT .. " ENEMIES KILLED ")

end
