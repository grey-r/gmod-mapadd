--lua_run dumpTable(util.KeyValuesToTable( fixKeyValues(file.Read( "data/mapadd/d1_trainstation_01.txt", "GAME" )) ))

MapAdd = MapAdd or {}
MapAdd.Table = {} --loaded from keyvalues
MapAdd.Nodes = {} --populated from navmesh on map load
MapAdd.Env = {
    ["HL2"] = {
        ["EntFire"] = function (targetname, activator, input, parameter, delay )
            timer.Simple(delay, function()
                local es = ents.FindByName(targetname)
                for _,v in pairs(es) do
                    vInput( input, activator, activator, parameter )
                end
            end)
        end,
        ["HookKilledEvent"] = function( f_name )
            hook.add("PostEntityTakeDamage","MapAddKilledHook",function( ent, dmg, took)
                --[[
                > Info.IsPlayer - Boolean; if this entity is the player, return 1. Otherwise, return 0.
                > Info.IsNPC - Boolean; if the entity's an NPC, return 1. Otherwise, return 0.
                > Info.Relation - String; the entity's relation string.
                > Info.DamageType - Integer; the damage flag of the killer's attack (e.g. CLUB, ENERGYBEAM). See trigger_hurt's "damagetype" keyvalue for a listing.
                > Info.Damage - Integer; the amount of damage the fatal attack inflicted.
                > Info.AmmoType - String; the ammotype used to kill the victim. See weapon_custom Bullet section.
                > Info.Attacker - String; the targetname of the victim's killer.
                > Info.KilledEnt - pEnt; The entity itself. Use HL2.GetEntInfo with this if you need more information like the victim's classname.
                ]]--
                if ( ent.Alive and not ent:Alive() ) or (ent.Health and ent:Health()<0) then
                    local info = {}
                    info.IsPlayer = ent:IsPlayer()
                    info.IsNPC = ent:IsNPC()
                    info.Relation = ent:GetRelationship(dmg:GetAttacker())
                    info.DamageType = dmg:GetDamageType()
                    info.Damage = dmg:GetDamage()
                    info.AmmoType = dmg:GetAmmoType()
                    info.Attacker = dmg:GetAttacker()
                    info.KilledEnt = ent
                    RunString(f_name .. "(" .. info .. ")")
                end
            end)
        end,
        ["CreateTimer"] = function(f_name, int, parameters ) --todo: add vararg for parameters?
            timer.Simple(int, function()
                RunString(f_name .. "(" .. (parameters or "") .. ")")
            end)
        end,
        ["GetDateMD"] = function()
            return os.date("%m%d")
        end,
        ["CurrentMapName"] = function()
            return game.GetMap()
        end,
        ["ChangeLevel"] = function(mapn)
            RunConsoleCommand( "changelevel", mapn )
        end,
        ["CallMapaddLabel"] = function(lbl)
            for _,inner in pairs(MapAdd.Table) do
                if inner.Key == "entities:" .. lbl then
                    MapAdd.Entities( inner.Value )
                end
            end
        end,
        ["GetMoney"] = function()
            return MapAdd.Money or 0
        end,
        ["SetMoney"] = function(v)
            MapAdd.Money = v
        end,
        ["GetPlayer"] = function( pn )
            if CLIENT then
                return LocalPlayer()
            else
                return Entity(1)
            end
        end,
        ["ShowHUDMessage"] = function(msg)
            PrintMessage(HUD_PRINTCENTER,msg)   
        end,
        ["ShowInfoMessage"] = function(msg)
            PrintMessage(HUD_PRINTTALK,msg)   
        end,
        ["TimeStr"] = function(seconds)
            return math.floor(seconds/60) .. ":" .. tostring(seconds%60)
        end,
        ["GetEntInfo"] = function(e)
            local info = {}
            info.Health = e:Health()
            info.Classname = e:GetClass()
            info.ModelName = e:GetModel()
            info.IsAlive = (e.Alive and e:Alive()) or (e.Health and e:Health() > 0)
            info.IsNpc = e:IsNPC()
            info.IsPlayer = e:IsPlayer()
            info.Owner = e:GetOwner()
            info.Name = e:GetName()
        end,
        ["GetAbsOrigin"] = function(e) return e:GetPos() end,
        ["GetAbsAngles"] = function(e) return e:GetAngles() end,
        ["GetAbsVelocity"] = function(e) return e:GetVelocity() end,
        ["SetAbsOrigin"] = function(e,v) e:SetPos(v) end,
        ["SetAbsAngles"] = function(e,v) e:SetAngles(Angle(v.x,v.y,v.z)) end,
        ["SetAbsVelocity"] = function(e,v) e:SetVelocity(v) end,
        ["EyePosition"] = function(e) return e:EyePos() end,
        ["EyeAngles"] = function(e) return Vector( e:EyeAngles().p, e:EyeAngles().y, e:EyeAngles().r) end,
        ["KeyValue"] = function(e,k,v) e:SetKeyValue(k,v) end,
        ["SetEntityParent"] = function(e,par,at) e:SetParent(par,at) end,
        ["SetEntityOwner"] = function(e,own) e:SetOwner(own) end,
        ["SetEntityMoveType"] = function(e,mt)
            local MOVETYPES = {
                ["none"] = MOVETYPE_NONE,
                ["isometric"] = MOVETYPE_ISOMETRIC,
                ["walk"] = MOVETYPE_WALK,
                ["ground"] = MOVETYPE_WALK,
                ["step"] = MOVETYPE_STEP,
                ["fly"] = MOVETYPE_FLY,
                ["flygravity"] = MOVETYPE_FLYGRAVITY,
                ["physics"] = MOVETYPE_VPHYSICS,
                ["vphysics"] = MOVETYPE_VPHYSICS,
                ["push"] = MOVETYPE_PUSH,
                ["noclip"] = MOVETYPE_NOCLIP,
                ["ladder"] = MOVETYPE_LADDER,
                ["observer"] = MOVETYPE_OBSERVER,
                ["custom"] = MOVETYPE_CUSTOM
            }
            e:SetMoveType(MOVETYPES[mt] or MOVETYPES["ground"])
        end,
        ["SetEntityRelationship"] = function(a,b,disposition,priority)
            local aList, bList

            if IsEntity( a ) then
                aList = { [1]=a }
            elseif isstring(a) then
                aList = {}
                table.Merge(aList, ents.FindByClass(a))
                table.Merge(aList, ents.FindByName(a))
            else
                aList = {}
            end

            if IsEntity( b ) then
                bList = { [1]=b }
            elseif isstring(a) then
                bList = {}
                table.Merge(bList, ents.FindByClass(b))
                table.Merge(bList, ents.FindByName(b))
            else
                bList = {}
            end

            for _,v in pairs(aList) do
                for _,b in pairs(bList) do
                    v:AddEntityRelationship( b, disposition, priority )
                end
            end
        end,
        ["SetEntityPhysVelocity"] = function(ent,v)
            local phys = ent:GetPhysicsObject()
            if IsValid(phys) then
                phys:SetVelocity(v)
            end
        end,
        ["SetEntityPhysVelocity"] = function(ent,v)
            local phys = ent:GetPhysicsObject()
            if IsValid(phys) then
                phys:SetVelocity(v)
            end
        end,
        ["SetEntityPhysFreeze"] = function(ent) --unknown how second param works
            local phys = ent:GetPhysicsObject()
            if IsValid(phys) then
                phys:EnableMotion(false)
            end
        end,
        ["SetModel"] = function(ent,model)
            ent:SetModel(model)
        end,
        ["CreateEntity"] = function(classname, origin, angle )
            local e = ents.Create(classname)
            if e:IsValid() then
                e:SetPos(origin)
                e:SetAngles( Angle(angle.x,angle.y,angle.z))
            end
        end,
        ["SpawnEntity"] = function(ent)
            if IsValid(ent) then ent:Spawn() end
        end,
        ["FindEntityByName"] = function(ent,targetname)
            local entsTbl = ents.FindByName(targetname)
            local canReturn = false
            if ent==nil then
                canReturn = true
            end
            for _,v in pairs(entsTbl) do
                if canReturn then
                    return v
                elseif v == ent then
                    canReturn = true
                end
            end
        end,
        ["FindEntityByClassname"] = function(ent,classname)
            local entsTbl = ents.FindByClass(classname)
            local canReturn = false
            if ent==nil then
                canReturn = true
            end
            for _,v in pairs(entsTbl) do
                if canReturn then
                    return v
                elseif v == ent then
                    canReturn = true
                end
            end
        end,
        ["RemoveEntity"] = function(ent)
            SafeRemoveEntity(ent)
        end,
        ["Vector"] = function(x,y,z) return Vector(x,y,z) end,
        ["VectorString"] = function(v) return tostring(v) end,
        ["DotProduct"] = function(a,b) return a:Dot(b) end,
        ["VectorLength"] = function(a,b) return a:Distance(b) end,
        ["VectorNormalize"] = function(v) return a:GetNormalized() end,
        ["AngleVectors"] = function(a) return a:Forward() end,
        ["VectorAngles"] = function(v) return a:Angle() end,
        ["CheckRoom"] = function( origin, mins, maxs )
            local td = {}
            td.start = origin
            td.endpos = origin
            td.mins = mins
            td.maxs = maxs
            local tr = util.TraceHull(td)
            return tr.Hit
        end,
        ["CheckVisible"] = function(a,b)
            local p1 = a.EyePos and a:EyePos() or a:GetPos()
            local p2 = b.EyePos and b:EyePos() or b:GetPos()
            local td = {}
            td.start = p1
            td.endpos = p2
            td.filter = {p1,p2}
            local tr = util.TraceLine(tr)
            local ret = {
                ["IsVisible"] = not tr.Hit,
                ["Length"] = tr.HitPos:Distance(p1),
                ["AngleYaw"] = td.Normal:Angle().y,
                ["AnglePitch"] = td.Normal:Angle().p
            }
        end,
        ["RandomSeed"] = function(n) math.randomseed(n) end,
        ["RandomInt"] = function(a,b) return math.random(a,b) end,
        ["RandomFloat"] = function(a,b) return math.Rand(a,b) end,
        ["PlaySoundPos"] = function(s,pos,...) EmitSound( s, pos, ...) end,
        ["PlaySoundEntity"] = function(s,ent,...) 
            if IsValid(ent) then
                EmitSound( s, ent:GetPos(), ent, ...)
            end
        end,
        ["GetNodeCounts"] = function() return #MapAdd.Nodes end,
        ["GetNodeData"] = function(id) 
            local n = MapAdd.Nodes[id]
            if not n then
                return
            end
            local node = {}
            node.x = n.x
            node.y = n.y
            node.z = n.z
            node.yaw = math.Rand(-180,180) --idk
            node.type = 2 --ground
        end,
        ["SaveString"] = function(s,v)
            MapAdd.Strings = MapAdd.Strings or {}
            MapAdd.Strings[s] = v
        end,
        ["LoadString"] = function(s,v)
            MapAdd.Strings = MapAdd.Strings or {}
            return MapAdd.Strings[s]
        end,
        ["StoreWorkVar"] = function(s,v)
            MapAdd.WorkVars = MapAdd.WorkVars or {}
            MapAdd.WorkVars[s] = v
        end,
        ["GetWorkVar"] = function(s,v)
            MapAdd.WorkVars = MapAdd.WorkVars or {}
            return MapAdd.WorkVars[s]
        end
    }
}
setmetatable(MapAdd.Env, {__index = _G})

local function dumpTable( t, indent, done )

	done = done or {}
	indent = indent or 0
	local keys = table.GetKeys( t )

	table.sort( keys, function( a, b )
		if ( isnumber( a ) && isnumber( b ) ) then return a < b end
		return tostring( a ) < tostring( b )
	end )

	done[ t ] = true

	for i = 1, #keys do
		local key = keys[ i ]
		local value = t[ key ]
		Msg( string.rep( "\t", indent ) )

		if  ( istable( value ) && !done[ value ] ) then

			done[ value ] = true
            Msg( "[")
            if isstring( key ) then
                Msg("\"")
            end
            Msg( tostring( key ) )
            if isstring( key ) then
                Msg("\"")
            end
            Msg( "] = {\n" )
			dumpTable ( value, indent + 2, done )
            Msg( string.rep( "\t", indent ) )
			Msg( "}" )
			done[ value ] = nil

		else
            Msg( "[")
            if isstring( key ) then
                Msg("\"")
            end
            Msg( tostring( key ) )
            if isstring( key ) then
                Msg("\"")
            end
            Msg( "] = " )
            if isstring( value ) then
                Msg("\"")
            end
			Msg( tostring( value ) )
            if isstring( value ) then
                Msg("\"")
            end
        end
        if (i~=#keys) then
            Msg(",")
        end
        Msg("\n")

	end

end

local function fixKeyValues(testStr)
    testExp = [[^([%s]+)(%b"")([%s]*)$]]
    testRep = [[%1%2 "true"%3]]
    testResult = "root {"
    testTbl = string.Explode("\n",testStr)
    for i,s in ipairs(testTbl) do
        appendStr = string.gsub(s, testExp, testRep)
        if string.len(string.trim(appendStr)) > 0 then
            testResult = testResult .. appendStr
            if i~=#testTbl then
                testResult = testResult .. "\n"
            end
        end
    end
    testResult = testResult .. "}"
    return testResult
end

MapAdd.Triggers = {}

MapAdd.PrecacheFunctions = {
    ["sound"] = util.PrecacheSound,
    ["model"] = util.PrecacheModel,
    ["default"] = function( v ) print("Failed to precache " .. v) end
}

function MapAdd.Precache(t)
    for _, pair in pairs(t) do
        local f = MapAdd.PrecacheFunctions[pair["Key"]]
        if not f then
            f =  MapAdd.PrecacheFunctions["default"]
        end
        f(pair.Value)
    end
end

MapAdd.EntityFunctions = {
    ["instant_trig"] = function(_,t)
        local result = {}
        for _, pair in pairs(t) do
            if pair["Key"] == "origin" then
                result.origin = Vector()
                local exp = string.Explode(" ",pair.Value)
                result.origin.x = exp[1]
                result.origin.y = exp[2]
                result.origin.z = exp[3]
            end
            if pair["Key"] == "keyvalues" then
                for _, innerpair in pairs(pair.Value) do
                    if innerpair["Key"] == "label" then
                        result.labels = string.Explode(":",innerpair["Value"])
                    elseif innerpair["Key"] == "timer" then 
                        result.expireTime = CurTime() + innerpair["Value"]
                    else
                        result[innerpair["Key"]] = innerpair.Value
                    end
                end
            end
        end
        if result.radius and not result.touchname then
            result.touchname = "player"
        end
        table.insert(MapAdd.Triggers,result)
    end,
    ["default"] = function( class, tb ) 
        local ent = ents.create(class)

        if not ent:IsValid() then
            print("Attempted to make invalid entity " .. class)
            return
        end

        local spawnflags = 0
        local keyvalues = {}
        local inputs = {}
        local relation = ""
        local stabilize = 10 --TODO
        for _,pair in pairs(tb) do
            if pair.Key == "alwaysthink" then
                spawnflags = bit.bor(spawnflags,1024)
            end
            if pair.Key == "freeze" then
                spawnflags = bit.bor(spawnflags,8)
            end
            if pair.Key == "longrange" then
                spawnflags = bit.bor(spawnflags,256)
            end
            if pair.Key == "patrol" then
                inputs[#inputs+1] = "StartPatrolling"
            end
            if pair.Key == "relation" then
                relation = pair.Value
            end
            if pair.Key == "stabilize" then
                relation = pair.Value
            end
            if pair.Key == "origin" then
                local pos = Vector()
                local t = string.Explode(" ",pair.Value)
                if #t>=3 then
                    ang.x = t[1]
                    ang.y = t[2]
                    ang.z = t[3]
                end
                ent:SetPos(pos)
            end
            if pair.Key == "angle" then
                local ang = Angle()
                local t = string.Explode(" ",pair.Value)
                if #t>=3 then
                    ang.p = t[1]
                    ang.y = t[2]
                    ang.r = t[3]
                end
                ent:SetAngles(ang)
            end
            if pair["Key"] == "keyvalues" then
                for _, innerpair in pairs(pair.Value) do
                    if innerpair.Key == "spawnflags" then
                        spawnflags = bit.bor(spawnflags,innerpair.Value)
                    else
                        result[innerpair["Key"]] = innerpair.Value
                    end
                end
            end
        end

        ent:AddRelationship(relation)
        for _, input in pairs(inputs) do
            ent:Fire(input)
        end
        for key, value in pairs(keyvalues) do
            ent:SetKeyValue(key,value)
        end
        ent:SetKeyValue("spawnflags",spawnflags)

        ent:Spawn()
    end
}

function MapAdd.Entities(t)
    for _, pair in pairs(t) do
        local f = MapAdd.EntityFunctions[pair["Key"]]
        if not f then
            f =  MapAdd.EntityFunctions["default"]
        end
        f(pair.Key, pair.Value)
    end
end

function MapAdd.ProcessTriggers()
    for k,t in pairs(MapAdd.Triggers) do
        if t.touchname and t.origin and t.radius then
            local checkEnts

            local firstChar = string.sub(t.touchname,1,1)
            if firstChar=="^" then
                local otherChars = string.sub(t.touchname,2)
                for l,b in pairs(ents.GetAll()) do
                    if b:GetClass()~=otherChars then
                        table.insert(checkEnts,b)
                    end
                end
            else
                checkEnts = ents.FindByClass(t.touchname)
                table.Merge(checkEnts,ents.FindByName(t.touchname))
            end

            for l,b in pairs(checkEnts) do
                if b:GetPos():Distance(t.origin)<t.radius then
                    MapAdd.ActivateTrigger( t )
                end
            end
        end
        if t.expireTime and CurTime() > t.expireTime then
            MapAdd.ActivateTrigger( t )
        end
    end
end

function MapAdd.ActivateTrigger( t )
    if not t.noclear then
        table.RemoveByValue(MapAdd.Triggers,t)
    end

    if t.removegroup then
        for k,v in pairs(MapAdd.Triggers) do
            if v.group and v.group==t.removegroup then
                table.RemoveByValue(MapAdd.Triggers,v)
            end
        end
    end

    if t.OnHitTrigger then --TODO
    end

    if t.labels then
        for k,v in pairs(t.labels) do
            for _,inner in pairs(MapAdd.Table) do
                if inner.Key == "entities:" .. v then
                    MapAdd.Entities( inner.Value )
                end
            end
        end
    end
end

function MapAdd.Initialize()
    local t = MapAdd.Table--[1].Value --root
    for _, inner in pairs(t) do
        if inner.Key == "precache" then
            MapAdd.Precache(inner.Value)
        end
        if inner.Key == "entities" then
            MapAdd.Entities(inner.Value)
        end
    end
end

function MapAdd.Load() 
    if CLIENT then
        return
    end

    local areas = navmesh.GetAllNavAreas()
    local nodes = {}
    local nodecache = {}
    for _, v in pairs(areas) do
        for i=0,3 do
            local corner = v:GetCorner(i)
            local cornerID = tostring(corner)
            if not nodecache[corner] then
                nodes[#nodes+1] = corner
            end
        end
        nodes[#nodes+1] = v:GetCenter()
    end
    MapAdd.Nodes = nodes

    local mapName = game.GetMap()
    local mapAddPath = "data/mapadd/" .. mapName .. ".txt"
    if (file.Exists(mapAddPath,"GAME")) then
        local mapAdd = file.Read( mapAddPath, "GAME" )
        local fixedKeyValues = fixKeyValues(mapAdd)
        MapAdd.Table = util.KeyValuesToTablePreserveOrder( fixedKeyValues, true, true )
        MapAdd.Initialize()
    end

    local luaMapAddPath = "lua/mapadd/" .. mapName .. ".lua"
    if (file.Exists(luaMapAddPath,"GAME")) then
        local fileCompiled = CompileFile(string.sub(luaMapAddPath,4))
        setfenv(fileCompiled,MapAdd.Env)
        fileCompiled()
    end
end

hook.add("InitPostEntity","MapAdd",function()
    MapAdd.Load()
end)

hook.add("PostCleanupMap","MapAdd",function()
    MapAdd.Load()
end)

hook.Add("Tick","MapAdd",function()
    MapAdd.ProcessTriggers()
end)

if MapAdd.Hotload then
    MapAdd.Load()
end
MapAdd.Hotload = true