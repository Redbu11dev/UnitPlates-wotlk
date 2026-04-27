UnitPlatesPlayersCache = UnitPlatesPlayersCache or {}
UnitPlatesNPCCache = UnitPlatesNPCCache or {}


-----------CACHE

function InitPlayersCacheEntry(keyName)
	if (not UnitPlatesPlayersCache[keyName]) then
        UnitPlatesPlayersCache[keyName] = {
            engClass = nil,
            engRace = nil,
            gender = nil,
			guild = nil,
            lastSeen = nil -- Useful if you want to clear old data later
        }
    end
end
function InitNPCCacheEntry(keyName)
	if (not UnitPlatesNPCCache[keyName]) then
        UnitPlatesNPCCache[keyName] = {
			creatureType = nil,
			guild = nil,
			lastSeen = nil -- Useful if you want to clear old data later
		}
    end
end










function StoreCachePlayerInfo(keyName, engClass, engRace, gender)
    if keyName then
		if not UnitPlatesPlayersCache[keyName] then 
			InitPlayersCacheEntry(keyName)
		end
		UnitPlatesPlayersCache[keyName].engClass = engClass
		UnitPlatesPlayersCache[keyName].engRace = engRace
		UnitPlatesPlayersCache[keyName].gender = gender
		UnitPlatesPlayersCache[keyName].lastSeen = time() -- Useful if you want to clear old data later
        -- UnitPlatesPlayersCache[keyName] = {
            -- engClass = engClass,
            -- engRace = engRace,
            -- gender = gender,
            -- lastSeen = time()
        -- }
    end
end

function RetrieveCachePlayerInfo(keyName) --engClass, engRace, gender
    if UnitPlatesPlayersCache and UnitPlatesPlayersCache[keyName] then
        return UnitPlatesPlayersCache[keyName].engClass, UnitPlatesPlayersCache[keyName].engRace, UnitPlatesPlayersCache[keyName].gender
    end
	return nil, nil, nil
end

function StoreCachePlayerGuild(keyName, guild)
    if keyName then
		if not UnitPlatesPlayersCache[keyName] then 
			InitPlayersCacheEntry(keyName)
		end
		UnitPlatesPlayersCache[keyName].guild = guild
		UnitPlatesPlayersCache[keyName].lastSeen = time() -- Useful if you want to clear old data later
    end
end

function RetrieveCachePlayerGuild(keyName) --guild
    if UnitPlatesPlayersCache and UnitPlatesPlayersCache[keyName] then
        return UnitPlatesPlayersCache[keyName].guild
    end
	return nil
end







function StoreCacheNPCCreatureType(keyName, creatureType)
    if keyName then
		if not UnitPlatesNPCCache[keyName] then 
			InitNPCCacheEntry(keyName)
		end
		UnitPlatesNPCCache[keyName].creatureType = creatureType
		UnitPlatesNPCCache[keyName].lastSeen = time() -- Useful if you want to clear old data later
    end
end

function RetrieveCacheNPCCreatureType(keyName) --creatureType
    if UnitPlatesNPCCache and UnitPlatesNPCCache[keyName] then
        return UnitPlatesNPCCache[keyName].creatureType
    end
	return nil
end


function StoreCacheNPCGuild(keyName, guild)
    if keyName then
		if not UnitPlatesNPCCache[keyName] then 
			InitNPCCacheEntry(keyName)
		end
		UnitPlatesNPCCache[keyName].guild = guild
		UnitPlatesNPCCache[keyName].lastSeen = time() -- Useful if you want to clear old data later
    end
end

function RetrieveCacheNPCGuild(keyName) --guild
    if UnitPlatesNPCCache and UnitPlatesNPCCache[keyName] then
        return UnitPlatesNPCCache[keyName].guild
    end
	return nil
end





--------PLAYER


function RepPlayerGetEnClass(name, unitId, guid)
	local isInParty = false
	if UnitIsPlayer(name) then
		isInParty = true
	end
	
	local locClass, engClass, locRace, engRace, gender, name, server
	if not isInParty then
		locClass, engClass, locRace, engRace, gender, name, server = GetPlayerInfoByGUID(guid)
	else
		locClass, engClass, locRace, engRace, gender, name, server = GetPlayerInfoByGUID(UnitGUID(name))
		--if in party, then we can also pull mana/energy etc
	end
	
	return string.upper(engClass)
end

function RepPlayerGetGender(name, unitId, guid)
	local isInParty = false
	if UnitIsPlayer(name) then
		isInParty = true
	end
	
	local locClass, engClass, locRace, engRace, gender, name, server
	if not isInParty then
		locClass, engClass, locRace, engRace, gender, name, server = GetPlayerInfoByGUID(guid)
	else
		locClass, engClass, locRace, engRace, gender, name, server = GetPlayerInfoByGUID(UnitGUID(name))
		--if in party, then we can also pull mana/energy etc
	end
	
	return gender
end

--------NPC