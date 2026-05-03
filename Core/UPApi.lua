local totemIcons = {
  ["Disease Cleansing Totem"] = "spell_nature_diseasecleansingtotem",
  ["Earth Elemental Totem"] = "spell_nature_earthelemental_totem",
  ["Earthbind Totem"] = "spell_nature_strengthofearthtotem02",
  ["Fire Elemental Totem"] = "spell_fire_elemental_totem",
  ["Fire Nova Totem"] = "spell_fire_sealoffire",
  ["Fire Resistance Totem"] = "spell_fireresistancetotem_01",
  ["Flametongue Totem"] = "spell_nature_guardianward",
  ["Frost Resistance Totem"] = "spell_frostresistancetotem_01",
  ["Grace of Air Totem"] = "spell_nature_invisibilitytotem",
  ["Grounding Totem"] = "spell_nature_groundingtotem",
  ["Healing Stream Totem"] = "Inv_spear_04",
  ["Magma Totem"] = "spell_fire_selfdestruct",
  ["Mana Spring Totem"] = "spell_nature_manaregentotem",
  ["Mana Tide Totem"] = "spell_frost_summonwaterelemental",
  ["Nature Resistance Totem"] = "spell_nature_natureresistancetotem",
  ["Poison Cleansing Totem"] = "spell_nature_poisoncleansingtotem",
  ["Searing Totem"] = "spell_fire_searingtotem",
  ["Sentry Totem"] = "spell_nature_removecurse",
  ["Stoneclaw Totem"] = "spell_nature_stoneclawtotem",
  ["Stoneskin Totem"] = "spell_nature_stoneskintotem",
  ["Strength of Earth Totem"] = "spell_nature_earthbindtotem",
  ["Totem of Wrath"] = "spell_fire_totemofwrath",
  ["Tremor Totem"] = "spell_nature_tremortotem",
  ["Windfury Totem"] = "spell_nature_windfury",
  ["Windwall Totem"] = "spell_nature_earthbind",
  ["Wrath of Air Totem"] = "spell_nature_slowingtotem"
}

function UpApiIsTotemPlate(name)
	for totem, icon in pairs(totemIcons) do
		if string.find(name, totem) then return icon end
	end
end

function UpApiGetUnitAuras(unitId, getBuffs, onlyMineBuffs, getDebuffs, onlyMineDebuffs, ignoredBuffNames, ignoredDebuffNames)	
	local maxBuffs = 40
	local unitBuffs = {}
	local unitDebuffs = {}
	
	if not unitId or not UnitExists(unitId) then
		return nil
	end
	
	--actual buffs
	if getBuffs then
		for i = 1, maxBuffs do
			--3.3.5 structure
			local name, rank, texture, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff(unitId, i)
			
			-- In WoW, the loop continues until it hits a nil name (end of debuffs)
			if not name then break end
			
			local nameIsIgnored = false
			for _, ignoredBuffName in ipairs(ignoredBuffNames) do
				if (string.upper(name) == string.upper(ignoredBuffName)) then
					nameIsIgnored = true
					break
				end
			end
			
			-- Store as a sub-table for easy access later
			if (onlyMineBuffs and (unitCaster ~= "player")) or nameIsIgnored then
				--do not insert
			else
				table.insert(unitBuffs, {
					spellId = spellId,
					name = name,
					texture = texture,
					count = count,
					debuffType = debuffType,
					duration = duration,
					expirationTime = expirationTime,
					isDebuff = false
				})
			end
		end
		
			-- --debug
	-- for i = 1, 40 do
		-- local keys = {}
		-- for name in pairs(totemIcons) do
			-- table.insert(keys, name)
		-- end
		-- local randomKey = keys[math.random(#keys)]
		-- local randomValue = totemIcons[randomKey]
	
		-- local min = 0.1
		-- local max = 40
		-- local randomNum = min + math.random() * (max - min)
		-- local testDur = randomNum--i+2
		-- table.insert(unitBuffs, {
			-- spellId = i,
			-- name = "test"..i,
			-- texture = "Interface\\Icons\\" .. randomValue,
			-- count = i,
			-- debuffType = nil,
			-- duration = testDur,
			-- expirationTime = GetTime() + testDur,
			-- isDebuff = false
		-- })
	-- end
	end
	
	--actual debuffs
	if getDebuffs then
		for i = 1, maxBuffs do
			--3.3.5 structure
			local name, rank, texture, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitDebuff(unitId, i)
			
			-- In WoW, the loop continues until it hits a nil name (end of debuffs)
			if not name then break end
			
			local nameIsIgnored = false
			for _, ignoredDebuffName in ipairs(ignoredDebuffNames) do
				if (string.upper(name) == string.upper(ignoredDebuffName)) then
					nameIsIgnored = true
					break
				end
			end
			
			-- Store as a sub-table for easy access later
			if (onlyMineDebuffs and (unitCaster ~= "player")) or nameIsIgnored then
				--do not insert
			else
				table.insert(unitDebuffs, {
					spellId = spellId,
					name = name,
					texture = texture,
					count = count,
					debuffType = debuffType,
					duration = duration,
					expirationTime = expirationTime,
					isDebuff = true
				})
			end
		end
		
			-- --debug
	-- for i = 1, 40 do
		-- local keys = {}
		-- for name in pairs(totemIcons) do
			-- table.insert(keys, name)
		-- end
		-- local randomKey = keys[math.random(#keys)]
		-- local randomValue = totemIcons[randomKey]
	
		-- local min = 0.1
		-- local max = 40
		-- local randomNum = min + math.random() * (max - min)
		-- local testDur = randomNum--i+2
		-- local randomBool = (math.random(0, 1) == 1)
		-- table.insert(unitDebuffs, {
			-- spellId = i,
			-- name = "test"..i,
			-- texture = "Interface\\Icons\\" .. randomValue,
			-- count = i,
			-- debuffType = nil,
			-- duration = testDur,
			-- expirationTime = GetTime() + testDur,
			-- isDebuff = true
		-- })
	-- end
	end
	
	--sort by expirationTime DESC
	table.sort(unitBuffs, function(a, b)
		-- local shortTime = 5
		
		-- -- Check if 'a' is a "short" buff
		-- local aIsShort = (a.duration > 0 and a.duration <= shortTime)
		-- -- Check if 'b' is a "short" buff
		-- local bIsShort = (b.duration > 0 and b.duration <= shortTime)

		-- if aIsShort ~= bIsShort then
			-- -- If one is short and the other isn't, the non-short one comes first
			-- return bIsShort
		-- end
		
		-- if aIsShort and bIsShort then
			-- return a.expirationTime < b.expirationTime
		-- end

		-- Optional: Sub-sort by expirationTime so the soonest to expire is at the front
		-- of their respective groups (Long-duration vs Short-duration)
		return a.expirationTime > b.expirationTime
	end)
	
	--sort by expirationTime DESC
	table.sort(unitDebuffs, function(a, b)
		return a.expirationTime > b.expirationTime
	end)
	
	local allAuras = {}
	
	-- Copy Buffs
	for _, data in ipairs(unitBuffs) do
		table.insert(allAuras, data)
	end
	
	-- Copy Debuffs
	for _, data in ipairs(unitDebuffs) do
		table.insert(allAuras, data)
	end
	
	return allAuras
end