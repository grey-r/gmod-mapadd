--lua_run dumpTable(util.KeyValuesToTable( fixKeyValues(file.Read( "data/mapadd/d1_trainstation_01.txt", "GAME" )) ))

MapAdd = {}
MapAdd.tbl = {} --loaded from keyvalues

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
    ["default"] = function( k, v ) print("Failed to use entity " .. k) end
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

    if t.OnHitTrigger then
    end

    if t.labels then
        for k,v in pairs(t.labels) do
            for _,inner in pairs(MapAdd.tbl) do
                if inner.Key == "entities:" .. v then
                    MapAdd.Entities( inner.Value )
                end
            end
        end
    end
end

function MapAdd.Initialize()
    local t = MapAdd.tbl--[1].Value --root
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
    local mapName = game.GetMap()
    local mapAddPath = "data/mapadd/" .. mapName .. ".txt"
    if (file.Exists(mapAddPath,"GAME")) then
        local mapAdd = file.Read( mapAddPath, "GAME" )
        local fixedKeyValues = fixKeyValues(mapAdd)
        MapAdd.tbl = util.KeyValuesToTablePreserveOrder( fixedKeyValues, true, true )
        MapAdd.Initialize()
    end
end

hook.add("Initialize","MapAdd",function()
    MapAdd.Load()
end)

hook.add("PostCleanupMap","MapAdd",function()
    MapAdd.Load()
end)

hook.Add("Tick","MapAdd",function()
    MapAdd.ProcessTriggers()
end)

MapAdd.Load()