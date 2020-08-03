local	GAMEEND = false
local   ENEMYCOUNT = 0
local	SPAWNLIMIT = 15
local   KILLCOUNT = 0
local   NPCNAMES = {
					"npc_metropolice", "npc_metropolice",
					"npc_combine_s", "npc_combine_e",
					"npc_combine_p", "npc_combine_c"
					}

local   ITEMS = {
					"weapon_alyxgun", 2,
					"weapon_goldengun", 1,
					"weapon_a35", 1,
					"weapon_minigun", 1,
					"weapon_svd", 1,
				}


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
			InstantSpawnEntity("weapon_smg1", pos)			
		    end
	end

end

function SpawnItems()

	local i

	for i=1, table.getn(ITEMS), 2 do

	    local itemname = ITEMS[i]
	    local count = ITEMS[i+1]

		local j

		for j=1, count, 1 do
			local pos = GetRandomNodePosition()
			if pos ~= nil then
				InstantSpawnEntity(itemname, pos)
			end
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

local wep_name = {	"weapon_smg1", 
			"weapon_ar2",
			"weapon_shotgun",
			"weapon_shotgun",
			"weapon_oicw",
			"weapon_pulsemg",
			"weapon_smg1",			
			"weapon_ar2"
		}

function GetWeaponName()

	local rt = HL2.RandomInt(1, 8)
	
	return wep_name[rt]

end

local wep_name1 = {	"weapon_pistol",
			"weapon_smg1",  
			"weapon_pistol",
			"weapon_jackhammer",
			"weapon_mp40",
			"weapon_grease"
		}

function GetWeaponName1()

	local rt = HL2.RandomInt(1, 6)
	
	return wep_name1[rt]

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
		  HL2.KeyValue(ent, "additionalequipment", GetWeaponName())
			    if npcname == "npc_headcrab" then
					HL2.KeyValue(ent, "startburrowed", 1)
				end
				
			    if npcname == "npc_metropolice" then
	    	HL2.KeyValue(ent, "additionalequipment", GetWeaponName1())
        HL2.KeyValue(ent, "Manhacks", HL2.RandomInt(0,2))		
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

function Initialize()

 	HL2.CreateTimer("SpawnTimer", 3)
 	HL2.CreateTimer("StatusTimer", 2)
	HL2.HookKilledEvent("Killed")

    SpawnItems()
    PlayerRandomSpawn()

	local i;

	for i=1, 15, 1 do
		SpawnEnemy()
	end

end



function Killed(info)

	local entinfo = HL2.GetEntInfo(info.KilledEnt)

    print("damagetype : " .. info.DamageType)

	if entinfo.Name == "enemy" then
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

function GameOver()

	HL2.HookKilledEvent()
	GAMEEND = true
	HL2.CallMapaddLabel("GameOver")
	HL2.ShowInfoMessage(1, 15, "YOU KILLED " .. KILLCOUNT .. " ENEMIES.")

end