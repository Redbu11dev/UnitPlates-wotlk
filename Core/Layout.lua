-- local fiz = CreateFrame("Frame")
-- fiz:RegisterEvent("UNIT_SPELLCAST_SENT")
-- fiz:RegisterEvent("UNIT_SPELLCAST_STOP")
-- fiz:RegisterEvent("UNIT_SPELLCAST_FAILED")
-- fiz:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")

-- fiz:SetScript("OnEvent", function(self, event, unit)
    -- if unit ~= "player" then return end

    -- if event == "UNIT_SPELLCAST_SENT" then
        -- -- This doesn't mute the whole game, but it suppresses the 
        -- -- "Interface" sounds where fizzles often live.
        -- SetCVar("Sound_EnableSFX", "0") 
    -- elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" then
        -- -- Delay the unmute slightly so the "thud" finishes playing in silence
        -- C_Timer.After(0.1, function() 
            -- SetCVar("Sound_EnableSFX", "1")
            -- UIErrorsFrame:Clear()
        -- end)
    -- end
-- end)

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

local function IsTotemPlate(name)
	for totem, icon in pairs(totemIcons) do
		if string.find(name, totem) then return icon end
	end
end

---------------------------CONSTANTS

--SIZES
--make all sizes relative to nameplateHealthBarHeight
local nameplateHealthBarHeight = 14

local minimalOnePixel = nameplateHealthBarHeight / 16

local nameplateHealthBarWidth = nameplateHealthBarHeight * 7.1875
local nameplateWidthGrayLevel = nameplateHealthBarHeight * 4.6875
local nameplatePowerBarHeight = nameplateHealthBarHeight / 2

local nameFontSize = nameplateHealthBarHeight * 0.6875
local healthPercentageFontSize = nameplateHealthBarHeight * 0.625
local healthBigFontSize = nameplateHealthBarHeight * 0.625
--local healthSmallFontSize = nameplateHealthBarHeight * 0.5
local powerFontSize = nameplateHealthBarHeight * 0.5
local levelFontSize = nameplateHealthBarHeight * 0.625
local castWarningNameFontSize = nameplateHealthBarHeight * 0.6875
local castWarningDurationFontSize = nameplateHealthBarHeight * 0.5

local nameplateArrowSize = nameplateHealthBarHeight * 1.875
local nameplateRarityH = nameplateHealthBarHeight * 2.75
local nameplateRarityW = nameplateHealthBarHeight * 2.625

local combatIconSize = nameplateHealthBarHeight * 1.4

local nameplateTypeIconSize = nameplateHealthBarHeight
local nameplateClassIconSize = nameplateHealthBarHeight * 1.25

local raidIconSize = nameplateHealthBarHeight * 3.125

local threatFrameSize = nameplateHealthBarHeight
local threatFontSize = nameplateHealthBarHeight * 0.5

local maxDebuffs = 15
local maxDebuffsInRow = 5
local maxDebuffsInRowGrayLevel = 3
local debuffIconOffset = 0.1 * minimalOnePixel
local debuffIconSize = (nameplateHealthBarWidth / maxDebuffsInRow) - debuffIconOffset
local debuffIconSizeGrayLevel = (nameplateWidthGrayLevel / maxDebuffsInRowGrayLevel) - debuffIconOffset

local castBarSizes = {
	cbheight = nameplateHealthBarHeight * 0.3125,
	shield = nameplateHealthBarHeight,
	icon = nameplateHealthBarHeight
 }

local combopointsSizes = {
	combopoints = nameplateHealthBarHeight * 0.5625,
	spacing = minimalOnePixel
}

local totemIconSize = nameplateHealthBarHeight * 2.5

--OFFSETS
local nameplateRarityXOffset = nameplateRarityW * 0.619

--COLORS
local glowColor = {.3, 0.7, 1, 1}
local hatedColor = {.7, 0.2, 0.1}
local neutralColor = {1, 0.8, 0}
local friendlyColor = {.2, 0.6, 0.1}
local tappedColor = {0.2352941176470588, 0.2274509803921569, 0.2352941176470588}
local playerColor = {.2, 0.5, 0.9}

local castBarColor = {.43, 0.47, 0.55, 1}
local castBarShieldColor = {.8, 0.1, 0.1, 1}

local combopointsColors = {
	full = {1, 0.224, 0.027}
}

local powerBarColors = {
	mana = {0, 0, 0.9, 0.99999779462814},
	energy = {1, 1, 0, 0.99999779462814},
	rage = {1, 0, 0, 0.99999779462814},
	rageDim = {0.5, 0, 0, 0.99999779462814}
}

local chatTextColors = {
    ["CHAT_MSG_SAY"] = {1.0, 1.0, 1.0, 0.99}, -- White
    ["CHAT_MSG_PARTY"] = {0.67, 0.67, 1.0, 0.99}, -- Light Blue
    ["CHAT_MSG_YELL"] = {1.0, 0.25, 0.25, 0.99}, -- Bright Red
    ["CHAT_MSG_MONSTER_SAY"] = {1.0, 1.0, 0.6, 0.99}, -- Pale Yellow
    ["CHAT_MSG_MONSTER_YELL"] = {1.0, 0.48, 0.0, 0.99}, -- Orange-Gold (Distinct from Say)
}

---------------------------CONSTANTS END

local function UpdateDebuffs(f, unitId)

	if not unitId or not UnitExists(unitId) then 
        HideAllDebuffs(f) -- Clear icons if we can't scan
        return 
    end

	-- for i = 1, 15 do
        -- f.debuffContainer.debuffs[i]:Hide()
    -- end

    local iconIndex = 1
    
    -- 1. Loop through all debuffs on the unit
    for i = 1, 40 do
        local name, _, texture, count, _, duration, expirationTime, unitCaster = UnitDebuff(unitId, i)
		
		---------------------------DEBUG
		
		-- name = "test"
		-- --texture = "Interface\\AddOns\\UnitPlates\\img\\loading.tga"
		-- local keys = {}
		-- for name in pairs(totemIcons) do
			-- table.insert(keys, name)
		-- end

		-- -- 2. Pick a random key from that list
		-- local randomKey = keys[math.random(#keys)]

		-- -- 3. Access the value
		-- local randomValue = totemIcons[randomKey]
		-- texture = "Interface\\Icons\\" .. randomValue
		-- count = i
		-- duration = i+10
		-- expirationTime = GetTime() + duration
		
		---------------------------DEBUG END
		
		
        
        -- Stop if no more debuffs OR if we ran out of our 15 icons
        if not name or iconIndex > maxDebuffs then
			break 
		end

        -- Optional: Filter for only player debuffs
        --if unitCaster == "player" then
            local icon = f.debuffContainer.debuffs[iconIndex]
            
            -- Set Texture
            icon.tex:SetTexture(texture)
            
            -- Set Count
            if count and count > 1 then
                icon.count:SetText(count)
                icon.count:Show()
            else
                icon.count:Hide()
            end
            
            -- Set Cooldown Spiral
            if duration and duration > 0 then
                icon.cd:SetCooldown(expirationTime - duration, duration)
				icon.expiration = expirationTime
				icon.duration = duration
                icon.cd:Show()
            else
				icon.cd:SetCooldown(0, 0)
				icon.expiration = 0
				icon.duration = 0
                icon.cd:Hide()
            end
            
			-- Position the icon dynamically
			local maxInRow = maxDebuffsInRow
			local iconSize = debuffIconSize
			if f.isGrayLevel or f.isPet then
				maxInRow = maxDebuffsInRowGrayLevel
				iconSize = debuffIconSizeGrayLevel
			end
			
			local column = (iconIndex - 1) % maxInRow          -- Results in 0, 1, 2, 3
			local row = math.floor((iconIndex - 1) / maxInRow) -- Results in 0, 1, 2...
			
			local xOffset = column * (iconSize + debuffIconOffset)
			local yOffset = row * (iconSize + debuffIconOffset)
			icon:SetSize(debuffIconSize, debuffIconSize)
			
			icon:ClearAllPoints()
			-- We use BOTTOMLEFT so that as 'row' increases, icons move UP (on top)
			icon:SetPoint("BOTTOMLEFT", f.debuffContainer, "BOTTOMLEFT", xOffset, yOffset)
			
            
            -- local xOffset = (iconIndex - 1) * (debuffIconSize + debuffIconOffset)
			-- local yOffset = 0
            -- icon:ClearAllPoints()
            -- icon:SetPoint("BOTTOMLEFT", f.debuffContainer, "BOTTOMLEFT", xOffset, yOffset)
            
            icon:Show()
            iconIndex = iconIndex + 1
        --end
    end
    
    -- 2. Hide any remaining icons in our pool that aren't being used
    for i = iconIndex, maxDebuffs do
        f.debuffContainer.debuffs[i]:Hide()
    end
end

local function HideAllDebuffs(f)
	for i = 1, maxDebuffs do
        f.debuffContainer.debuffs[i]:Hide()
    end
end




local kui = LibStub("Kui-1.0")
local addon = LibStub("AceAddon-3.0"):GetAddon("UnitPlates")
--local slowUpdateTime, critUpdateTime = 1, 0.1
local slowUpdateTime, critUpdateTime, debuffUnitIdUpdateTime = 0.01, 0.1, 0.1
local _

-- UnitPlatesScanTool = CreateFrame( "GameTooltip", "ScanTooltip", nil, "GameTooltipTemplate" )
-- scanTool:SetOwner( WorldFrame, "ANCHOR_NONE" )
-- UnitPlatesScanTextLine2 = _G["ScanTooltipTextLeft2"] -- This is the line with <[Player]'s Pet>

-- local profile

--------------------------------------------------------------------- globals --
local select, pairs, ipairs, type = select, pairs, ipairs, type
local unpack, floor = unpack, math.floor
local strfind, strsplit, tinsert = strfind, strsplit, tinsert
local UnitExists = UnitExists
-- non-laggy, pixel perfect positioning (Semlar's) #############################
local function SizerOnSizeChanged(self, x, y)
	-- because :Hide bubbles up and triggers the OnHide script of any elements
	-- that might use it, we set MOVING to let them know they should ignore
	-- that invocation
	-- Hiding frames before moving them significantly increases FPS for some
	-- reason, so I thought this was better than nothing
	self.f.MOVING = true
	self.f:Hide()
	self.f:SetPoint("CENTER", WorldFrame, "BOTTOMLEFT", floor(x), floor(y))
	self.f:Show()
	self.f.MOVING = nil
end

------------------------------------------------------------- Frame functions --
local function SetCentreFrame(f)
	-- using CENTER breaks pixel-perfectness with oddly sized frames
	-- .. so we have to align frames manually.
	local w, h = f:GetSize()

	if f.trivial then
		f.x = floor((w / 2) - (nameplateWidthGrayLevel / 2))
		f.y = floor((h / 2) - (nameplateHealthBarHeight / 2))
	else
		f.x = floor((w / 2) - (nameplateHealthBarWidth / 2))
		f.y = floor((h / 2) - (nameplateHealthBarHeight / 2))
	end
end
-- get default health bar colour, parse it into one of our custom colours
-- and the reaction of the unit toward the player
local function SetHealthColor(self, sticky, r, g, b)
	if sticky == false then
		-- unstick and reset
		self.health.reset = true
		self.healthColourPriority = nil
		sticky = nil
	elseif sticky == true then
		-- convert legacy stickiness
		sticky = 1
	end
	-- nil sticky = just update health colour

	if sticky then
		if not self.healthColourPriority or sticky >= self.healthColourPriority then
			self.health:SetStatusBarColor(r, g, b)
			self.healthColourPriority = sticky
		end
		return
	end

	-- update health colour from default (r,g,b arguments are ignored)
	--local origR, origG, origB = self.oldHealth:GetStatusBarColor()
	r, g, b = self.oldHealth:GetStatusBarColor()
	if self.health.reset or r ~= self.health.r or g ~= self.health.g or b ~= self.health.b then
		-- store the default colour
		self.health.r, self.health.g, self.health.b = r, g, b
		self.health.reset, self.player, self.tapped = nil, nil, nil

		if g > 0.9 and r == 0 and b == 0 then
			-- friendly NPC
			self.friend = true
			r, g, b = unpack(friendlyColor)
		elseif b > 0.9 and r == 0 and g == 0 then
			-- friendly player
			self.friend = true
			self.player = true
			r, g, b = unpack(playerColor)
		elseif r > 0.9 and g == 0 and b == 0 then
			-- enemy NPC
			self.friend = nil
			r, g, b = unpack(hatedColor)
		elseif (r + g) > 1.8 and b == 0 then
			-- neutral NPC
			self.friend = nil
			r, g, b = unpack(neutralColor)
		--elseif UnitIsTapped(self.guid) then
		elseif r < 0.6 and (r + g) == (r + b) then
			-- tapped NPC
			-- keep previous self.friend value
			self.tapped = true
			r, g, b = unpack(tappedColor)
		else
			-- enemy player, use default UI colour
			self.friend = nil
			self.player = true
		end

		self.health:SetStatusBarColor(r, g, b)
	end
	
	-------------------------------------------
	-- --NOTE: WORKS INCORRECTLY WHEN YOU HAVE A PET/MINION WHICH ATTACKS FIRST
	-- --additional tapped check hack (inaccurate isTapped check for unscanned nameplate)
	-- local oldNameColorR, oldNameColorG, oldNameColorB, oldNameColorA = self.oldName:GetTextColor()
	-- --print(self.oldName:GetTextColor())
	-- local isAggro = false
	-- if ((oldNameColorR > 0.99) and (oldNameColorG == 0) and (oldNameColorB == 0)) then
		-- isAggro = true
	-- end
	-- if (isAggro and (not self.player) and (not self.friend) and (not UnitAffectingCombat("player")) and (GetNumPartyMembers() < 1)) then
		-- self.tapped = true
		-- r, g, b = unpack(tappedColor)
		-- self.health:SetStatusBarColor(r, g, b)
	-- else
		-- --not tapped
		-- self.tapped = false
		-- --gotta set normal color?
	-- end
	-------------------------------------------
	
	if self.guid then
		local unitId = GetUnitIDFromGUID(self.guid)
		if unitId then
			--if UnitIsTapped(unitId) then
			if UnitIsTapped(unitId) and not (UnitIsTappedByPlayer(unitId) or UnitIsTappedByAllThreatList(unitId)) then
				--print("----------name3: "..unitId)
				-- tapped NPC
				-- keep previous self.friend value
				self.tapped = true
				r, g, b = unpack(tappedColor)
				self.health:SetStatusBarColor(r, g, b)
			else
				--not tapped
				self.tapped = false
				--gotta set normal color?
			end
		end
	end
end

local function GetDesiredAlpha(frame)
	return 1
end
---------------------------------------------------- Update health bar & text --
local OnHealthValueChanged
do
	OnHealthValueChanged = function(frame, curval)
		frame.health.min, frame.health.max = frame.oldHealth:GetMinMaxValues()
		frame.health.curr = curval or frame.oldHealth:GetValue()
		frame.health.percent = 100 * frame.health.curr / frame.health.max

		frame.health:SetMinMaxValues(frame.health.min, frame.health.max)
		frame.health:SetValue(frame.health.curr)

		frame.health.p:SetText(kui.num(frame.health.curr))
	end
end
------------------------------------------------------- Frame script handlers --
local function OnFrameEnter(self)
	addon:StoreGUID(self, "mouseover")
	self.highlighted = true

	-- if self.highlight then
		-- self.highlight:Show()
	-- end
end
local function OnFrameLeave(self)
	self.highlighted = nil

	-- if self.highlight and profile.general and (profile.general.highlight_target and not self.target or not profile.general.highlight_target) then
		-- self.highlight:Hide()
	-- end
end
local function OnFrameShow(self)
	local f = self.kui

	---------------------------------------------- Trivial sizing/positioning --
	-- if addon.uiscale then
		-- -- change our parent frame size if we're using fixaa..
		-- -- (size is changed by SetAllPoints otherwise)
		-- f:SetSize(self:GetWidth() / addon.uiscale, self:GetHeight() / addon.uiscale)
	-- end
	
	f:SetSize(self:GetWidth(), self:GetHeight())

	if not f.doneFirstShow then
		f:SetCentre()
		f.doneFirstShow = true
	end

	-- run updates immediately after the frame is shown
	f.elapsed = 0
	f.critElap = 0
	f.debuffUpdateElapsed = 0

	-- reset glow colour
	-- f:SetGlowColour()

	-- dispatch the PostShow message after the first UpdateFrame
	f.DispatchPostShow = true
	f.DoShow = true
	
	HideAllDebuffs(f)
	f.chatBubble:Hide()
end
local function OnFrameHide(self)
	local f = self.kui
	f:Hide()

	f:SetFrameLevel(0)

	f.glow:Hide() 
	f.glow2:Hide()
	-- if f.targetGlow then
		-- f.targetGlow:Hide()
	-- end

	addon:ClearGUID(f)

	-- remove name from store
	-- if there are name duplicates, this will be recreated in an onupdate
	addon:ClearName(f)

	--f.active = nil
	f.lastAlpha = nil
	f.fadingTo = nil
	f.hasThreat = nil
	f.target = nil
	f.targetDelay = nil
	f.healthColourPriority = nil

	-- force un-highlight
	OnFrameLeave(f)
	-- if f.highlight then
		-- f.highlight:Hide()
	-- end

	-- ResetCastBarFade(f)
	f.castbar_ignore_frame = nil

	-- despite being a default element, this doesn't hide correctly if it was
	-- shown when the frame is hidden
	f.glow:Hide()

	-- unset stored health bar colours
	f.health.r, f.health.g, f.health.b, f.health.reset = nil, nil, nil, nil
	f.friend = nil
	
	HideAllDebuffs(f)
	f.chatBubble:Hide()

	addon:SendMessage("UnitPlates_PostHide", f)
end
-- stuff that needs to be updated every frame
local function OnFrameUpdate(self, e)
	local f = self.kui
	f.elapsed = f.elapsed - e
	f.critElap = f.critElap - e
	f.debuffUpdateElapsed = f.debuffUpdateElapsed - e

	-- Show during first update to prevent flashyness
	-- .DoShow is set OnFrameShow
	if f.DoShow then
		f:Show()
		f.DoShow = nil
	end
	------------------------------------------------------------------- Alpha --
	f.defaultAlpha = self:GetAlpha()
	f.currentAlpha = GetDesiredAlpha(f)
	------------------------------------------------------------------ Fading --
	
	f:SetAlpha(f.currentAlpha)

	-- call delayed updates
	if f.elapsed <= 0 then
		f.elapsed = slowUpdateTime
		f:UpdateFrame()
	end

	if f.critElap <= 0 then
		f.critElap = critUpdateTime
		f:UpdateFrameCritical()
	end
	
	-- if f.highlighted then
		-- if UnitCanAttack("player", "mouseover") then
			-- --print("can attack")
			-- SetCursor("ATTACK_CURSOR")
		-- end
	-- end
	if MouseIsOver(f.health) or MouseIsOver(f.typeIcon) then
		if UnitCanAttack("player", "mouseover") then
			--print("can attack")
			SetCursor("ATTACK_CURSOR")
			--set right click attack action?
		end
		if (UnitGUID("target") == f.guid) and UnitCanAttack("player", "target") then
			--print("can attack")
			SetCursor("ATTACK_CURSOR")
			--set right click attack action?
		end
	end
end

local function UpdatePlate(self)
	--reset values
	--local isPlayer = false
	local isInParty = false
	self.guild:SetText("")
	--
	
	--name
	local name = self.oldName:GetText()
	--
	
	if UnitIsPlayer(self.oldName:GetText()) then
		isInParty = true
	end
	local isPlayer = self.player
	local guid = self.guid
	local unitId = GetUnitIDFromGUID(guid)
	if not unitId then
		--try to see if it is player and has same name in your party or raid
		-- if UnitName("pet") == name then
			-- unitId = "pet"
			-- --also store guid?
			-- guid = UnitGUID(unitId)
		-- end
		
		--hacky unitId check for pets and party members
		local unitIdFromName = GetUnitIDFromName(name)
		if unitIdFromName then
			unitId = unitIdFromName
			guid = UnitGUID(unitId)
		end
		--hacky guid check for pets and party members END
	end
	local levelDifficultyColor = GetQuestDifficultyColor(self.oldLevel:GetText())
	local isGrayLevel = levelDifficultyColor.r == 0.5 and levelDifficultyColor.g == 0.5 and levelDifficultyColor.b == 0.5
	self.isGrayLevel = isGrayLevel
	
	local isInCombat = false
	if unitId then
		if UnitAffectingCombat(unitId) then
			isInCombat = true
		end
	else
		local thrR, thrG, thrB, thrA = self.oldName:GetTextColor()
		if thrR > 0.99 and thrG == 0 and thrB == 0 then
			isInCombat = true
		end
	end
	
	--
	--name debug
	--self.name:SetTextColor(self.oldName:GetTextColor())
	-- if guid then
		-- self.name:SetText(self.oldName:GetText().." / "..guid)
	-- end
	--
	
	--get guild
	local guild = nil
	if unitId then
		UnitPlatesScanTool:ClearLines()
		UnitPlatesScanTool:SetUnit(unitId)
		local scanTextLine2Text = UnitPlatesScanTextLine2:GetText()
		--if not ownerText then return nil end
		--local owner, _ = string.split("'",ownerText)
		
		-- if (unitstr ~= nil) and UnitIsPossessed(unitstr) then
			-- guild = "PET"
		-- end
		
		if scanTextLine2Text and not string.find(scanTextLine2Text, "Level") then
			--local owner, _ = string.split("'",ownerText)
			guild = scanTextLine2Text
			--cache in guild
			if isPlayer then
				StoreCachePlayerGuild(name, guild)
			else
				StoreCacheNPCGuild(name, guild)
			end
		end
	end
	
	if not guild then
		--try to get from cache
		if isPlayer then
			guild = RetrieveCachePlayerGuild(name, guild)
		else
			guild = RetrieveCacheNPCGuild(name, guild)
		end
	end
	
	if guild then
		self.guild:SetText("<"..guild..">")
	else
		--empty
		self.guild:SetText("")
	end
	--get guild end
	
	-----------------------------------
	local isPet = false	
	if guild and (guild:match("'s Pet$") or guild:match("'s Minion$")) then
		isPet = true
	end
	self.isPet = isPet
	-----------------------------------
	
	
	-----COMMON
	--(BOTH PLAYERS AND NPC)
	
	--combat icon
	if isInCombat then
		self.combatIcon:Show()
	else
		self.combatIcon:Hide()
	end
	--
	
	--healthbar with
	if isGrayLevel or isPet then
		self.trivial = true
		if not UnitAffectingCombat("player") then
			--can't call this while in combat
			self.oldFrame:SetSize(nameplateWidthGrayLevel, nameplateHealthBarHeight)
		end
		self:SetCentre()
		self.health:SetSize(nameplateWidthGrayLevel, nameplateHealthBarHeight)
		self.health:SetPoint("BOTTOMLEFT", self.x, self.y)
		self.power:SetWidth(nameplateWidthGrayLevel)
		self.castWarning.bar:SetWidth(nameplateWidthGrayLevel)
		self.debuffContainer:SetWidth(nameplateWidthGrayLevel)
	else
		self.trivial = false
		if not UnitAffectingCombat("player") then
			--can't call this while in combat
			self.oldFrame:SetSize(nameplateHealthBarWidth, nameplateHealthBarHeight)
		end
		self:SetCentre()
		self.health:SetSize(nameplateHealthBarWidth, nameplateHealthBarHeight)
		self.health:SetPoint("BOTTOMLEFT", self.x, self.y)
		self.power:SetWidth(nameplateHealthBarWidth)
		self.castWarning.bar:SetWidth(nameplateHealthBarWidth)
		self.debuffContainer:SetWidth(nameplateHealthBarWidth)
	end
	
	--level and rarity shenanigans
	self.oldLevel:Hide()
	-- addon:UpdateLevel(self, false)
	-- classifications
	self.level:SetText(self.oldLevel:GetText())
	self.level:SetTextColor(self.oldLevel:GetTextColor())
	if self.state:IsVisible() then
		if self.state:GetTexture() == "Interface\\Tooltips\\EliteNameplateIcon" then
			--f.level:SetText(f.level:GetText() .. "+")--elite
			self.rarityIcon:Show()
			self.rarityIconR:Show()
		else
			--f.level:SetText(f.level:GetText() .. "r")--rare
			self.rarityIcon:Show()
			self.rarityIconR:Show()
		end

		-- self.state:Hide()
	else
		self.rarityIcon:Hide()
		self.rarityIconR:Hide()
	end	
	
	if self.boss:IsVisible() then
		self.level:SetText("??")
		self.level:SetTextColor(1, 0.2, 0.2)

		self.rarityIcon:Hide()
		self.rarityIconR:Hide()
	end
	--f.level:SetWidth(0)
	self.level:Show()
	if self.state:IsVisible() then
		-- hide the elite/rare dragon
		-- self.state:Hide()
	end
	
	--update name position
	if (self.guild:GetText() == nil or self.guild:GetText() == '') then
		self.name:SetPoint("BOTTOM", self.health, "TOP", 0, 2 * minimalOnePixel)
	else
		self.name:SetPoint("BOTTOM", self.guild, "TOP", 0, 2 * minimalOnePixel)
	end
	
	--get power
	UpdateUnitPower(self, unitId)
	
	--get health percentage
	local hpPercent = floor(self.health.percent)
	if hpPercent < 100 then
		self.health.percentage:SetText(floor(self.health.percent).."%")
	else
		self.health.percentage:SetText("")
	end
	
	-----COMMON END
	
	if isPlayer then
		self.rarityIcon:Hide()
		self.rarityIconR:Hide()
	
		local locClass, engClass, locRace, engRace, gender, xname, server
		if isInParty then
			locClass, engClass, locRace, engRace, gender, xname, server = GetPlayerInfoByGUID(UnitGUID(name))
			--cache in locClass, engClass, locRace, engRace, gender, name, server
			if engClass then
				StoreCachePlayerInfo(name, engClass, engRace, gender)
			end
			
			--if in party, then we can also pull mana/energy etc
			--get power
			UpdateUnitPower(self, unitId)
		elseif guid then
			locClass, engClass, locRace, engRace, gender, xname, server = GetPlayerInfoByGUID(guid)
			--cache in locClass, engClass, locRace, engRace, gender, name, server
			if engClass then
				StoreCachePlayerInfo(name, engClass, engRace, gender)
			end
		else
			--no guid, try from cache
			engClass, engRace, gender = RetrieveCachePlayerInfo(name)
		end
		
		--set class
		if engClass then
			local classr, classl, classt, classb = getClassPos(string.upper(engClass))
			self.classIcon.icon:SetTexCoord(classr, classl, classt, classb)
			self.classIcon:Show()
		else
			--empty
			self.classIcon:Hide()
		end
		
		--set gender icon
		if gender and engRace then
			if gender == 3 then
				self.typeIcon.icon:SetTexture("Interface\\AddOns\\UnitPlates\\img\\races\\"..string.lower(engRace).."_female.tga")
			else
				self.typeIcon.icon:SetTexture("Interface\\AddOns\\UnitPlates\\img\\races\\"..string.lower(engRace).."_male.tga")
			end
		else
			--empty
			self.typeIcon.icon:SetTexture("Interface\\AddOns\\UnitPlates\\img\\loading.tga")
		end
		
	else
		--is npc
		self.classIcon:Hide()		
		
		--set creature type
		local creatureType = nil
		if unitId then
			creatureType = UnitCreatureType(unitId)
			--most probably just an unknown type
			if (unitId and (not creatureType)) then
				creatureType = "UNKNOWN"
			end
			--cache in creature type
			if creatureType then
				StoreCacheNPCCreatureType(name, creatureType)
			end
		end
		
		if not creatureType then
			--try by name from cache
			creatureType = RetrieveCacheNPCCreatureType(name)
		end
		
		if creatureType then
			--print("creatureType: "..creatureType)
			local success = self.typeIcon.icon:SetTexture("Interface\\AddOns\\UnitPlates\\img\\creaturetypes\\"..string.upper(creatureType)..".tga")
			if not success then
				local success = self.typeIcon.icon:SetTexture("Interface\\AddOns\\UnitPlates\\img\\creaturetypes\\UNKNOWN.tga")
			end
		else
			--empty
			self.typeIcon.icon:SetTexture("Interface\\AddOns\\UnitPlates\\img\\loading.tga")
		end
	end
	
	--combo points update
	if unitId == "target" then
		self.combopoints.points = GetComboPoints("player", unitId)
		if not self.combopoints.points or self.combopoints.points < 1 then
			self.combopoints:Hide()
		else
			self.combopoints.color = combopointsColors.full
			for i = 1, 5 do
				if i <= self.combopoints.points then
					self.combopoints[i]:SetAlpha(1)
				else
					self.combopoints[i]:SetAlpha(.3)
				end
				self.combopoints[i]:SetVertexColor(unpack(self.combopoints.color))
			end
			self.combopoints:Show()
		end
	else
		self.combopoints.points = nil
		self.combopoints:Hide()
	end
	--combo points update end
	
	--cast warning bar simulation
	local currTimeMillis = GetTime()*1000
	if unitId then
		local spellName, spellNameSecondary, spellDisplayName, spellIcon, spellStartTimeMillis, spellEndTimeMillis, spellIsTradeSkill, spellCastID, spellInterrupt = UnitCastingInfo(unitId)
		if (spellName and ((spellEndTimeMillis - currTimeMillis) > 0)) then
			-- print("spellName: "..spellName)
			-- print("spellNameSecondary: "..spellNameSecondary)
			-- print("spellDisplayName: "..spellDisplayName)
			-- print("spellIcon: "..spellIcon)
			-- print("spellStartTimeMillis: "..spellStartTimeMillis)
			-- print("spellEndTimeMillis: "..spellEndTimeMillis)
			-- print("spellIsTradeSkill: ".."boolean")
			-- print("spellCastID: "..spellCastID)
			-- print("spellInterrupt: ".."boolean")
			
			--something is being cast
			self.castWarning.currentValue = spellEndTimeMillis - currTimeMillis
			self.castWarning.startTime = spellStartTimeMillis
			self.castWarning.endTime = spellEndTimeMillis
			self.castWarning.castTime = self.castWarning.endTime-self.castWarning.startTime
			
			-- print("unitId startTime raw: "..spellStartTimeMillis)
			-- print("unitId endTime raw: "..spellEndTimeMillis)
			
			self.castWarning.curr:SetText(string.format("%.1f", self.castWarning.currentValue/1000))
			self.castWarning.bar:SetMinMaxValues(0, self.castWarning.castTime)
			self.castWarning.bar:SetValue(self.castWarning.castTime-self.castWarning.currentValue)
			
			if not spellInterrupt then
				self.castWarning.bar:SetStatusBarColor(unpack(castBarColor))	
				self.castWarning.shield:Hide()
			else
				self.castWarning.bar:SetStatusBarColor(unpack(castBarShieldColor))
				self.castWarning.shield:Show()
			end
			
			self.castWarning:Show()
			-- print("unitID castTime: "..self.castWarning.castTime.." / ".."current: "..self.castWarning.castTime-self.castWarning.currentValue)
		else
			--assume nothing is being cast
			self.castWarning.startTime = 0
			self.castWarning.endTime = 0
			
			if self.castWarning.endTime > currTimeMillis then
				self.castWarning.currentValue = self.castWarning.endTime - currTimeMillis
				
				self.castWarning.curr:SetText(string.format("%.1f", self.castWarning.currentValue/1000))
				self.castWarning.bar:SetMinMaxValues(0, self.castWarning.castTime)
				self.castWarning.bar:SetValue(self.castWarning.castTime-self.castWarning.currentValue)
				
				self.castWarning.bar:SetStatusBarColor(unpack(castBarColor))	
				self.castWarning.shield:Hide()
			end
			if (self.castWarning:IsShown() and (self.castWarning.castTime > 0) and (currTimeMillis > self.castWarning.endTime)) then
				self.castWarning.castTime = 0
				self.castWarning:Hide()
			end
		end
	else
		if self.castWarning.endTime > currTimeMillis then
			self.castWarning.currentValue = self.castWarning.endTime - currTimeMillis
			
			self.castWarning.curr:SetText(string.format("%.1f", self.castWarning.currentValue/1000))
			self.castWarning.bar:SetMinMaxValues(0, self.castWarning.castTime)
			self.castWarning.bar:SetValue(self.castWarning.castTime-self.castWarning.currentValue)
			
			self.castWarning.bar:SetStatusBarColor(unpack(castBarColor))	
			self.castWarning.shield:Hide()
			
			-- print("normal castTime: "..self.castWarning.castTime.." / ".."current: "..self.castWarning.castTime-self.castWarning.currentValue)
		end
		if (self.castWarning:IsShown() and (self.castWarning.castTime > 0) and (currTimeMillis > self.castWarning.endTime)) then
			self.castWarning.castTime = 0
			self.castWarning:Hide()
		end
	end
	
	--TOTEM
	local totemIcon = IsTotemPlate(name)
	if totemIcon then
		self:GetParent().totem.icon:SetTexture("Interface\\Icons\\" .. totemIcon)
		local totemR,totemG,totemB,totemA = self.health:GetStatusBarColor()
		self:GetParent().totem:SetBackdropColor(totemR,totemG,totemB,totemA)
		self:GetParent().totem:SetBackdropBorderColor(totemR,totemG,totemB,totemA)
		self:GetParent().totem:Show()
		self:Hide()
	else
		self:GetParent().totem:Hide()
		self:Show()
	end
	
	--THREAT
	if (unitId and (not self.friend)) then
		local isTanking, status, threatpct, rawthreatpct, threatvalue = UnitDetailedThreatSituation("player", unitId)
		if threatpct then
			local p = threatpct / 100
        
			-- Interpolate: StartValue + (EndValue - StartValue) * Ratio
			local r = 0.2 + (0.7 - 0.2) * p
			local g = 0.6 + (0.2 - 0.6) * p
			local b = 0.1 -- Both start and end at 0.1		
		
			self.threat.text:SetTextColor(r, g, b, 1)
			self.threat.text:SetText(threatpct.."%")
			self.threat.text:Show()
		else
			self.threat.text:Hide()
		end
	else
		self.threat.text:Hide()
	end
	
	--DEBUFFS
	if unitId then
		if self.debuffUpdateElapsed <= 0 then
			self.debuffUpdateElapsed = debuffUnitIdUpdateTime
			UpdateDebuffs(self, unitId)
		end
	end
	
	-- name colors
	self.name:SetTextColor(1,1,1,1)
	self.guild:SetTextColor(1,1,1,1)
	
	local myGuildName, myGuildRankName, myGuildRankIndex = GetGuildInfo("player")
	if (myGuildName and isPlayer and (guild == myGuildName)) then
		self.guild:SetTextColor(0,0.999,0,1)
	end
	
	if self.highlighted then
		self:SetFrameStrata("LOW")
		self.name:SetTextColor(1,1,0,1)
		self.guild:SetTextColor(1,1,0,1)
	else
		self:SetFrameStrata("BACKGROUND")
		-- self.name:SetTextColor(1,1,0,1)
		-- self.guild:SetTextColor(1,1,0,1)
	end
	
	---if everything fails then try from cache
end

function UpdateUnitPower(self, unitId)
	if unitId then
		local unitPowerType = UnitPowerType(unitId)
		local unitMaxPower = UnitPowerMax(unitId, unitPowerType)
		if unitMaxPower > 0 then
			local unitPower = UnitPower(unitId, unitPowerType)
			-- print("----------unitPowerType: "..unitPowerType)
			-- print("----------unitMaxPower: "..unitMaxPower)
			-- print("----------unitPower: "..unitPower)
			self.power.text:SetText(string.format("%s", KKAbbreviate(unitPower)))
		
			if unitPowerType == 0 then
				self.power:SetStatusBarColor(unpack(powerBarColors.mana))
			elseif unitPowerType == 1 then
				self.power:SetStatusBarColor(unpack(powerBarColors.rage))
			elseif unitPowerType == 2 or unitPowerType == 3 then
				self.power:SetStatusBarColor(unpack(powerBarColors.energy))
			else
				self.power:SetStatusBarColor(unpack(powerBarColors.energy))
			end
			
			self.power:SetMinMaxValues(0, unitMaxPower)
			
			if unitPowerType == 1 and unitPower < 1 then
				self.power:SetValue(unitMaxPower)
				self.power:SetStatusBarColor(unpack(powerBarColors.rageDim))
			else
				self.power:SetValue(unitPower)
			end
			self.power:Show()
		else
			self.power:Hide()
		end
	else
		self.power:Hide()
	end
end

-- stuff that can be updated less often
local function UpdateFrame(self)
	-- periodically update the name in order to purge Unknowns due to lag, etc
	self:SetName()

	-- ensure a frame is still stored for this name, as name conflicts cause
	-- it to be erased when another might still exist
	addon:StoreName(self)

	-- reset/update health bar colour
	self:SetHealthColor()

	-- if select(2, self.oldName:GetTextColor()) == 0 then
		-- self.active = true
	-- else
		-- self.active = nil
	-- end

	if self.DispatchPostShow then
		-- force initial health update, which relies on health colour
		self:OnHealthValueChanged()

		addon:SendMessage("UnitPlates_PostShow", self)
		self.DispatchPostShow = nil

		-- return guid to an assumed unique name
		addon:GetGUID(self)
	end
	
	UpdatePlate(self)
	
	-- self:GetParent():SetWidth(1)
	-- self:GetParent():SetHeight(1)
end

-- stuff that needs to be updated often
local function UpdateFrameCritical(self)
	------------------------------------------------------------------ Threat --
	if self.glow:IsVisible() then
		-- check the default glow colour every frame while it is visible
		self.glow.wasVisible = true
		self.glow.r, self.glow.g, self.glow.b = self.glow:GetVertexColor()

		if addon.TankModule then
			-- handoff to tank module
			addon.TankModule:ThreatUpdate(self)
		end
	elseif self.glow.wasVisible then
		self.glow.wasVisible = nil

		-- if not self.targetGlow or not self.target then
			-- -- restore default glow colour
			-- self:SetGlowColour()
		-- end

		if self.hasThreat then
			-- lost threat
			self.hasThreat = nil

			if addon.TankModule then
				addon.TankModule:ThreatClear(self)
			end
		end
	end
	------------------------------------------------------------ Target stuff --
	if UnitExists("target") and self.defaultAlpha == 1 then
		if not self.target then
			if self.guid and self.guid == UnitGUID("target") then
				-- this is definitely the target
				self.targetDelay = 1
			else
				-- this -may- be the target's frame but we need to wait a moment
				-- before we can be sure.
				-- this alpha update delay is a blizzard issue.
				self.targetDelay = (self.targetDelay and self.targetDelay + 1) or 0
			end

			if self.targetDelay >= 1 then
				-- this is almost probably certainly maybe the target
				-- (the delay may not be long enough, but it already feels
				-- laggy so i'd prefer not to make it longer)
				self.target = true
				self.targetDelay = nil
				addon:StoreGUID(self, "target")

				-- move this frame above others
				self:SetFrameLevel(3)

				-- if profile_hp.text.mouseover then
					-- self.health.p:Show()
				-- end
				
				self.glow:Show() 
				self.glow2:Show()

				-- if self.targetGlow then
					-- self.targetGlow:Show()
					-- self:SetGlowColour(unpack(profile.general.targetglowcolour))
				-- end

				-- if self.highlight and profile.general.highlight_target then
					-- self.highlight:Show()
				-- end

				addon:SendMessage("UnitPlates_PostTarget", self, true)
			end
		end
	else
		if self.targetDelay then
			-- it wasn't the target after all. phew.
			self.targetDelay = nil
		end

		if self.target then
			-- or it was, but no longer is.
			self.target = nil

			self:SetFrameLevel(0)

			self.glow:Hide() 
			self.glow2:Hide()
			-- if self.targetGlow then
				-- self.targetGlow:Hide()
				-- self:SetGlowColour()
			-- end

			addon:SendMessage("UnitPlates_PostTarget", self, nil)
		end
	end

	--------------------------------------------------------------- Mouseover --
	if self.oldHighlight:IsShown() then
		if not self.highlighted then
			OnFrameEnter(self)
		end
	elseif self.highlighted then
		OnFrameLeave(self)
	end
end
local function SetName(self)
	-- get name from default frame and update our values
	self.name.text = self.oldName:GetText()
	self.name:SetText(self.name.text)
end
local function IsTrivial(self)
	return false
	-- return self:GetScale() < 1 and not addon.notrivial
end
--------------------------------------------------------------- KNP functions --
function addon:IsNameplate(frame)
	if frame:GetName() then
		return false
	end
	local o = select(2, frame:GetRegions())
	return (o and o:GetObjectType() == "Texture" and o:GetTexture() == [[Interface\Tooltips\Nameplate-Border]])
end

--------------CastWarning
function FadeCastWarningFrame(self, from, to, duration, end_delay, callback)
	kui.frameFadeRemoveFrame(self)

	self:Show()
	self:SetAlpha(from)

	kui.frameFade(self, {
		mode = "OUT",
		startAlpha = from,
		endAlpha = to,
		timeToFade = duration,
		fadeHoldTime = end_delay,
		finishedFunc = function(self)
			if to == 0 then
				self:Hide()
			else
				self:SetAlpha(to)
			end

			if callback then
				callback(self)
			end
		end
	})
end

local castWarningEvents = {
	["SPELL_CAST_START"] = true,
	["SPELL_CAST_SUCCESS"] = true,
	["SPELL_INTERRUPT"] = true,
	["SPELL_HEAL"] = true,
	["SPELL_PERIODIC_HEAL"] = true
}

local function SetCastWarning(self, spellID, spellName, spellSchool, isHeal, amount)
	kui.frameFadeRemoveFrame(self.castWarning)

	if spellName == nil then
		-- hide the warning instantly
		self.castWarning.icon.tex:SetTexture(nil)
		self.castWarning.text:SetText()
		self.castWarning:Hide()
	else
		--local name, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spellID)
		local name, rank, icon, cost, isFunnel, powerType, castTimeMillis = GetSpellInfo(spellID)
		-- print("here")
		-- print(""..GetSpellInfo(spellID))
		if isHeal then
			if amount >= 0 then
				-- healing
				amount = "+" .. amount
				self.castWarning.text:SetTextColor(0, 1, 0)
			else
				-- damage (nyi)
				amount = "-" .. amount
				self.castWarning.text:SetTextColor(1, 0, 0)
			end
			self.castWarning.text:SetText("["..spellName.."]".." "..amount)
			self.castWarning.icon.tex:SetTexture(icon)
		else
			local col = spellSchoolColors[spellSchool] or {r = 1, g = 1, b = 1}
			self.castWarning.text:SetTextColor(col.r, col.g, col.b)
			self.castWarning.text:SetText("["..spellName.."]")
			self.castWarning.icon.tex:SetTexture(icon)
		end
		
		local currTimeMillis = GetTime()*1000
		
		if (castTimeMillis and (castTimeMillis > 0)) then	
			self.castWarning.currentValue = 0
			self.castWarning.startTime = currTimeMillis
			self.castWarning.endTime = currTimeMillis+castTimeMillis
			self.castWarning.castTime = self.castWarning.endTime-self.castWarning.startTime
			
			-- print("--- startTime raw: "..currTime)
			-- print("--- endTime raw: "..currTime + castTime)
			-- print("--- startTime raw: "..currTimeMillis)
			-- print("--- endTime raw: "..currTimeMillis + castTimeMillis)
		
			self.castWarning.curr:SetText(string.format("%.1f", self.castWarning.currentValue/1000))
			self.castWarning.bar:SetMinMaxValues(0, self.castWarning.castTime)
			self.castWarning.bar:SetValue(self.castWarning.castTime-self.castWarning.currentValue)
			
			self.castWarning.bar:SetStatusBarColor(unpack(castBarColor))	
			self.castWarning.shield:Hide()
			
			-- self.castWarning.spark:SetWidth(6)
			-- FadeCastWarningFrame(self.castWarning, 1, 0, 3)
			
			self.castWarning:Show()
		else
			self.castWarning.currentValue = 0
			self.castWarning.startTime = 0
			self.castWarning.endTime = 0
			self.castWarning.castTime = 0
			
			FadeCastWarningFrame(self.castWarning, 1, 0, 3)
		end
	end
end

function addon:COMBAT_LOG_EVENT_UNFILTERED(_, castTime, event, guid, name, _, targetGUID, targetName, _, spellID, spellName, spellSchool, amount)
	if guid and name then
		local namePlateFrame = addon:GetNameplate(nil, name)
		if namePlateFrame and (namePlateFrame.player) then
			--print("storing guid for: "..name)
			--store guid
			addon:StoreGUIDNoUnit(namePlateFrame, guid)
		end
	end


	if not (guid and targetGUID) then
		return
	end

	if castWarningEvents[event] then
		if event == "SPELL_HEAL" or event == "SPELL_PERIODIC_HEAL" then
			-- fetch the spell's target's nameplate
			guid, name = targetGUID, targetName
		end

		-- if self.db.profile.useNames and name then
			-- name = name and name:gsub("%-.+$", "") -- remove realm names
		-- else
			-- name = nil
		-- end
		
		--check if player and use player name later on
		name = nil

		local f = addon:GetNameplate(guid, name)
		if f then
			-- if not f.castWarning or f.trivial then
				-- return
			-- end
			if event == "SPELL_HEAL" or event == "SPELL_PERIODIC_HEAL" then
				-- display heal warning
				SetCastWarning(f, spellID, spellName, spellSchool, true, amount)
			elseif event == "SPELL_INTERRUPT" then
				-- hide the warning
				SetCastWarning(f, nil)
			else
				-- or display it for this spell
				SetCastWarning(f, spellID, spellName, spellSchool, false, 0)
			end
		end
	end
end
--------------CastWarning END

local updateCustomBalloonText = function(f, text, r, g, b, a)
	-- if f.chatBubble.font:GetText() == text then
		-- return nil
	-- end

	f.chatBubble:Show()
	local minHeight = 20

	local minWidth = 50
	local maxWidth = 300
	f.chatBubble.fontMeasure:SetText(text)

	f.chatBubble.font:SetText(text)
	f.chatBubble.font:SetTextColor(r, g, b, a)
	
	local maxOfMin = math.max(minWidth, f.chatBubble.fontMeasure:GetWidth())
	f.chatBubble.font:SetWidth(math.min(maxOfMin, maxWidth))
	
	f.chatBubble:SetWidth(f.chatBubble.font:GetWidth() + 48)
	f.chatBubble:SetHeight(math.max(f.chatBubble.font:GetHeight(), minHeight) + 32)
	
	FadeCastWarningFrame(f.chatBubble, 1, 1, 10)
end

-----------PLATE CREATION
function addon:InitFrame(frame)
	-- container for kui objects!
	-- frame.kui = CreateFrame("Frame", nil, profile.general.compatibility and frame or WorldFrame)
	
	frame.kui = CreateFrame("Frame", nil, frame)
	local f = frame.kui

	f.fontObjects = {}

	-- fetch default ui's objects
	local healthBar, castBar = frame:GetChildren()
	local glowRegion, overlayRegion, castbarOverlay, shieldedRegion, spellIconRegion, highlightRegion, nameTextRegion, levelTextRegion, bossIconRegion, raidIconRegion, stateIconRegion = frame:GetRegions()

	overlayRegion:SetTexture(nil)
	highlightRegion:SetTexture(nil)
	--bossIconRegion:SetTexture(nil)
	shieldedRegion:SetTexture(nil)
	castbarOverlay:SetTexture(nil)
	glowRegion:SetTexture(nil)
	spellIconRegion:SetSize(0.01, 0.01)

	--overlayRegion:Hide()
	castbarOverlay:Hide()

	healthBar:Hide()
	nameTextRegion:Hide()

	-- re-hidden OnFrameShow
	--bossIconRegion:Hide()
	bossIconRegion:SetSize(0.01, 0.01)
	--stateIconRegion:Hide()
	stateIconRegion:SetSize(0.01, 0.01)

	-- make default healthbar & castbar transparent
	castBar:SetStatusBarTexture(kui.m.t.empty)
	healthBar:SetStatusBarTexture(kui.m.t.empty)

	f.glow = glowRegion
	f.boss = bossIconRegion
	f.state = stateIconRegion
	f.oldLevel = levelTextRegion
	f.icon = raidIconRegion
	f.spell = spellIconRegion
	f.shield = shieldedRegion
	f.oldHealth = healthBar
	f.oldCastbar = castBar
	f.oldOverlayRegion = overlayRegion
	f.oldFrame = frame

	f.oldName = nameTextRegion
	f.oldName:Hide()

	f.oldHighlight = highlightRegion
	
	--f.oldCastbar

	--------------------------------------------------------- Frame functions --
	--f.CreateFontString = addon.CreateFontString
	f.UpdateFrame = UpdateFrame
	f.UpdateFrameCritical = UpdateFrameCritical
	f.SetName = SetName
	f.SetHealthColor = SetHealthColor
	-- f.SetGlowColour = SetGlowColour
	f.SetCentre = SetCentreFrame
	f.OnHealthValueChanged = OnHealthValueChanged
	f.IsTrivial = IsTrivial

	------------------------------------------------------------------ Layout --	
	f:SetPoint("CENTER", frame, "CENTER")
	f:SetFrameStrata("BACKGROUND")
	f:SetFrameLevel(0)
	f:SetCentre()
	
	-- self:CreateHealthBar(frame, f)
	f.health = CreateFrame("StatusBar", nil, f)
	f.health:SetFrameLevel(1)
	f.health:SetStatusBarTexture("Interface\\AddOns\\UnitPlates\\img\\statusbar\\XPerl_StatusBar4")
	f.health.percent = 100
	f.health:GetStatusBarTexture():SetDrawLayer("ARTWORK", -8)
	if self.SetValueSmooth then
		f.health.OrigSetValue = f.health.SetValue
		f.health.SetValue = self.SetValueSmooth
	elseif self.CutawayBar then
		self.CutawayBar(f.health)
	end
	f.health:SetBackdrop({
		bgFile = "Interface\\AddOns\\UnitPlates\\img\\WHITE", -- A solid texture
		edgeFile = "Interface\\AddOns\\UnitPlates\\img\\WHITE", 
		edgeSize = 1, 
		insets = { left = -minimalOnePixel, right = -minimalOnePixel, top = -minimalOnePixel, bottom = -minimalOnePixel }
	})
	f.health:SetBackdropColor(0, 0, 0, 1) -- Black Background
	f.health:SetBackdropBorderColor(0, 0, 0, 1) -- Black Border
	f.health:ClearAllPoints()
	f.health:SetSize(nameplateHealthBarWidth, nameplateHealthBarHeight)
	f.health:SetPoint("BOTTOMLEFT", f.x, f.y)
	
	-- self:CreateHealthText(frame, f)
	-- f.health.p = f:CreateFontString(f.overlay, {
		-- font = self.font,
		-- size = "health",
		-- alpha = 1,
		-- outline = "OUTLINE"
	-- })
	-- f.health.p:SetHeight(10)
	-- f.health.p:SetJustifyH("RIGHT")
	-- f.health.p:SetJustifyV("MIDDLE")
	-- f.health.p.osize = "health" -- original font size used to update/restore
	--nameplate.health.text:SetAllPoints()
	f.health.p = f.health:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.health.p:SetFont("Interface\\AddOns\\UnitPlates\\fonts\\francois.ttf", healthBigFontSize, "OUTLINE")
	f.health.p:SetJustifyH("RIGHT")
	f.health.p:SetTextColor(1,1,1,1)
	f.health.p:ClearAllPoints()
	f.health.p:SetPoint("BOTTOMRIGHT", f.health, "BOTTOMRIGHT", -1 * minimalOnePixel, -(healthBigFontSize * 0.4))
	f.health.p:Show()
	
	f.health.percentage = f.health:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.health.percentage:SetFont("Fonts\\FRIZQT__.TTF", healthPercentageFontSize)
	f.health.percentage:SetJustifyH("CENTER")
	f.health.percentage:SetPoint("CENTER", f.health, "CENTER", 0, 0)
	f.health.percentage:SetTextColor(1,1,1,1)
	f.health.percentage:SetText("69%")

	-- overlay - frame level above health bar, used for text -------------------
	f.overlay = CreateFrame("Frame", nil, f)
	f.overlay:SetAllPoints(f.health)
	f.overlay:SetFrameLevel(2)

	-- self:CreateHighlight(frame, f)
	-- f.highlight = f.overlay:CreateTexture(nil, "ARTWORK")
	-- f.highlight:SetTexture(addon.bartexture)
	-- f.highlight:SetAllPoints(f.health)
	-- f.highlight:SetVertexColor(1, 1, 1)
	-- f.highlight:SetBlendMode("ADD")
	-- f.highlight:SetAlpha(.05)
	-- f.highlight:Hide()
	
	f.typeIcon = CreateFrame("Frame", nil, f)
	f.typeIcon:SetFrameLevel(1)
	f.typeIcon:SetPoint("RIGHT", f.health, "LEFT", -1 * minimalOnePixel, 0)
	f.typeIcon:SetHeight(nameplateTypeIconSize)
	f.typeIcon:SetWidth(nameplateTypeIconSize)
	f.typeIcon.icon = f.typeIcon:CreateTexture(nil, "OVERLAY")
	f.typeIcon.icon:SetAllPoints()
	--f.typeIcon.icon:SetTexture("Interface\\AddOns\\UnitPlates\\img\\creaturetypes\\UNKNOWN.tga")
	f.typeIcon.icon:SetTexture("Interface\\AddOns\\UnitPlates\\img\\loading.tga")
	--CreateBackdrop(nameplate.typeIcon, 1)
	f.typeIcon:SetBackdrop({
		bgFile = "Interface\\AddOns\\UnitPlates\\img\\WHITE", -- A solid texture
		edgeFile = "Interface\\AddOns\\UnitPlates\\img\\WHITE", 
		edgeSize = 1, 
		insets = { left = -minimalOnePixel, right = -minimalOnePixel, top = -minimalOnePixel, bottom = -minimalOnePixel }
	})
	f.typeIcon:SetBackdropColor(0, 0, 0, 1) -- Black Background
	f.typeIcon:SetBackdropBorderColor(0, 0, 0, 1) -- Black Border
	f.typeIcon:Show()
	
	
	f.threat = CreateFrame("Frame", nil, f)
	f.threat:SetFrameLevel(1)
	f.threat:SetPoint("TOP", f.typeIcon, "BOTTOM", 0, -1 * minimalOnePixel)
	f.threat:SetHeight(threatFrameSize)
	f.threat:SetWidth(threatFrameSize)
	
	f.threat.text = f.threat:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.threat.text:SetFont("Interface\\AddOns\\UnitPlates\\fonts\\francois.ttf", threatFontSize, "OUTLINE")
	f.threat.text:SetJustifyH("RIGHT")
	f.threat.text:SetTextColor(1,1,1,1)
	f.threat.text:ClearAllPoints()
	f.threat.text:SetPoint("TOPRIGHT", f.threat, "TOPRIGHT", 0, 0)
	f.threat.text:SetText("100%")
	f.threat.text:Hide()

	-- self:CreateLevel(frame, f)
	-- f.level = f:CreateFontString(f.level, {
		-- reset = true,
		-- font = self.font,
		-- size = "level",
		-- alpha = 1,
		-- outline = "OUTLINE"
	-- })
	-- f.level:SetParent(f.overlay)
	-- f.level:SetJustifyH("LEFT")
	-- f.level:SetJustifyV("MIDDLE")
	-- f.level:SetHeight(10)
	-- f.level:ClearAllPoints()
	-- f.level.osize = "level" -- original font size used to update/restore
	
	-- f.level:ClearAllPoints()
	f.level = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.level:SetFont("Interface\\AddOns\\UnitPlates\\fonts\\francois.ttf", levelFontSize, "OUTLINE")
	f.level:SetParent(f.overlay)
	f.level:SetJustifyH("CENTER")
	-- f.level:SetPoint("RIGHT", f.typeIcon, "RIGHT", -2, -4)
	f.level:ClearAllPoints()
	f.level:SetPoint("BOTTOMLEFT", f.health, "BOTTOMLEFT", 2 * minimalOnePixel, -(levelFontSize * 0.4))
	f.oldLevel.enabled = true
	f.oldLevel:Hide()
	
	-- f.guild = f:CreateFontString(f.overlay, {
		-- font = self.font,
		-- size = "name",
		-- outline = "OUTLINE"
	-- })
	-- f.guild.osize = "name" -- original font size used to update/restore
	-- f.guild:SetHeight(10)
	f.guild = f:CreateFontString(nil, "OVERLAY")
	f.guild:SetFont("Interface\\AddOns\\UnitPlates\\fonts\\francois.ttf", nameFontSize, "OUTLINE")
	f.guild:ClearAllPoints()
	f.guild:SetWidth(0)
	f.guild:SetPoint("BOTTOM", f.health, "TOP", 0, 2 * minimalOnePixel)
	
	-- f.name = f:CreateFontString(f.overlay, {
		-- font = self.font,
		-- size = "name",
		-- outline = "OUTLINE"
	-- })
	-- f.name.osize = "name" -- original font size used to update/restore
	
	f.name = f:CreateFontString(nil, "OVERLAY")
	f.name:SetFont("Interface\\AddOns\\UnitPlates\\fonts\\francois.ttf", nameFontSize, "OUTLINE")
	--f.name:SetHeight(10)
	f.name:ClearAllPoints()
	f.name:SetWidth(0)
	if (f.guild:GetText() == nil or f.guild:GetText() == '') then
		f.name:SetPoint("BOTTOM", f.health, "TOP", 0, 2 * minimalOnePixel)
	else
		f.name:SetPoint("BOTTOM", f.guild, "TOP", 0, 2 * minimalOnePixel)
	end
	
	f.combatIcon = CreateFrame("Frame", nil, f)
	f.combatIcon:SetFrameLevel(0)
	f.combatIcon:SetPoint("LEFT", f.name, "RIGHT", -0, -0)
	f.combatIcon:SetHeight(combatIconSize)
	f.combatIcon:SetWidth(combatIconSize)
	f.combatIcon.icon = f.combatIcon:CreateTexture(nil, "OVERLAY")
	f.combatIcon.icon:SetAllPoints()
	f.combatIcon.icon:SetTexture("Interface\\AddOns\\UnitPlates\\img\\combat\\swords_combat_2")
	f.combatIcon:Hide()
	
	------CHAT BUBBLE
	f.chatBubble = CreateFrame("Frame", nil, f)
	f.chatBubble:SetHeight(5)
	f.chatBubble:SetWidth(5)
	f.chatBubble:SetPoint("BOTTOM", f.name, "TOP", 0, 10)
	local insets = 16
	f.chatBubble:SetBackdrop({
		bgFile = "Interface\\Tooltips\\ChatBubble-Background",
		edgeFile = "Interface\\Tooltips\\ChatBubble-Backdrop",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = insets, right = insets, top = insets, bottom = insets }
	})
	f.chatBubble:SetBackdropColor(1,1,1,1)
	f.chatBubble:SetBackdropBorderColor(1,1,1,1)
	f.chatBubble.fontMeasure = f.chatBubble:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.chatBubble.font = f.chatBubble:CreateFontString(nil, "OVERLAY", "GameFontNormal")

	updateCustomBalloonText(f, "Placeholder", f.name:GetTextColor())
	
	f.chatBubble.font:SetPoint("CENTER", f.chatBubble, "CENTER", 0, 0)
	f.chatBubble.font:SetJustifyH("CENTER")
	
	f.chatBubble.tail = f.chatBubble:CreateTexture(nil, "OVERLAY")
	f.chatBubble.tail:SetTexture("Interface/Tooltips/ChatBubble-Tail")
	f.chatBubble.tail:SetWidth(24)
	f.chatBubble.tail:SetHeight(18)
	f.chatBubble.tail:SetPoint("TOP", f.chatBubble, "BOTTOM", -10, 3.5)
	
	f:SetFrameStrata("LOW")
	
	f.chatBubble:Hide()
	
	------CHAT BUBBLE END
	
	
	
	
	f.power = CreateFrame("StatusBar", nil, f)
	f.power:SetFrameLevel(1) -- keep above glow
	f.power:SetOrientation("HORIZONTAL")
	f.power:SetPoint("TOP", f.health, "BOTTOM", 0, 0)
	f.power:SetStatusBarTexture("Interface\\AddOns\\UnitPlates\\img\\statusbar\\XPerl_StatusBar7")
	f.power.hlr, f.power.hlg, f.power.hlb, f.power.hla = glowr, glowg, glowb, 1
	f.power:SetWidth(nameplateHealthBarWidth)
	f.power:SetHeight(nameplatePowerBarHeight)
	f.power:SetBackdrop({
		bgFile = "Interface\\AddOns\\UnitPlates\\img\\WHITE", -- A solid texture
		edgeFile = "Interface\\AddOns\\UnitPlates\\img\\WHITE", 
		edgeSize = 1, 
		insets = { left = -minimalOnePixel, right = -minimalOnePixel, top = -minimalOnePixel, bottom = -minimalOnePixel }
	})
	f.power:SetBackdropColor(0, 0, 0, 1) -- Black Background
	f.power:SetBackdropBorderColor(0, 0, 0, 1) -- Black Border
	f.power:Hide()
	
	f.power.text = f.power:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.power.text:SetFont("Interface\\AddOns\\UnitPlates\\fonts\\francois.ttf", powerFontSize, "OUTLINE")
	f.power.text:SetJustifyH("RIGHT")
	f.power.text:SetPoint("BOTTOMRIGHT", f.power, "BOTTOMRIGHT", -1 * minimalOnePixel, -(powerFontSize * 0.5))
	f.power.text:SetText("69")
	f.power.text:SetTextColor(1,1,1,1)
	
	f.classIcon = CreateFrame("Frame", nil, f)
	f.classIcon:SetPoint("RIGHT", f.name, "LEFT", -2 * minimalOnePixel, 4 * minimalOnePixel)
	f.classIcon:SetHeight(nameplateClassIconSize)
	f.classIcon:SetWidth(nameplateClassIconSize)
	f.classIcon.icon = f.classIcon:CreateTexture(nil, "ARTWORK")
	f.classIcon.icon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
	f.classIcon.icon:SetAllPoints()
	f.classIcon:Hide()
	
	f.rarityIcon = CreateFrame("Frame", nil, f)
	f.rarityIcon:SetFrameLevel(0)
	f.rarityIcon:SetPoint("RIGHT", f.typeIcon, "LEFT", nameplateRarityXOffset, -1 * minimalOnePixel)
	f.rarityIcon:SetHeight(nameplateRarityH)
	f.rarityIcon:SetWidth(nameplateRarityW)
	f.rarityIcon.icon = f.rarityIcon:CreateTexture(nil, "BORDER")
	f.rarityIcon.icon:SetTexCoord(1, 0, 0, 1)
	f.rarityIcon.icon:SetVertexColor(1, 1, 0, 1)
	f.rarityIcon.icon:SetAllPoints()
	f.rarityIcon.icon:SetTexture("Interface\\AddOns\\UnitPlates\\img\\frame_elite")
	f.rarityIcon:Hide()

	f.rarityIconR = CreateFrame("Frame", nil, f)
	f.rarityIconR:SetFrameLevel(0)
	f.rarityIconR:SetPoint("LEFT", f.health, "RIGHT", -nameplateRarityXOffset, -1 * minimalOnePixel)
	f.rarityIconR:SetHeight(nameplateRarityH)
	f.rarityIconR:SetWidth(nameplateRarityW)
	f.rarityIconR.icon = f.rarityIconR:CreateTexture(nil, "BORDER")
	--nameplate.rarityIconR.icon:SetTexCoord(1, 0, 0, 1)
	f.rarityIconR.icon:SetVertexColor(1, 1, 0, 1)
	f.rarityIconR.icon:SetAllPoints()
	f.rarityIconR.icon:SetTexture("Interface\\AddOns\\UnitPlates\\img\\frame_elite")
	f.rarityIconR:Hide()

	-- castbar #################################################################
	-- if self.Castbar then
		-- self.Castbar:CreateCastbar(f)
	-- end
	-- self.Castbar:CreateCastbar(f)

	-- target highlight --------------------------------------------------------
	f.glow = f:CreateTexture(nil, "BACKGROUND")
	f.glow:SetPoint("LEFT", f.typeIcon, "LEFT", -nameplateArrowSize, 0)
	f.glow:SetTexture("Interface\\AddOns\\UnitPlates\\img\\arrow_left")
	--nameplate.glow:SetFrameLevel(1)
	f.glow:SetDrawLayer("BACKGROUND")
	f.glow:SetWidth(nameplateArrowSize)
	f.glow:SetHeight(nameplateArrowSize)
	f.glow:SetVertexColor(unpack(glowColor))
	f.glow:Hide()

	f.glow2 = f:CreateTexture(nil, "BACKGROUND")
	f.glow2:SetPoint("RIGHT", f.health, "RIGHT", nameplateArrowSize, 0)
	f.glow2:SetTexture("Interface\\AddOns\\UnitPlates\\img\\arrow_right")
	--nameplate.glow:SetFrameLevel(1)
	f.glow2:SetDrawLayer("BACKGROUND")
	--nameplate.glow2.texture:SetRotation(2)
	f.glow2:SetWidth(nameplateArrowSize)
	f.glow2:SetHeight(nameplateArrowSize)
	f.glow2:SetVertexColor(unpack(glowColor))
	f.glow2:Hide()
	
	-- f.targetGlow = f.overlay:CreateTexture(nil, "ARTWORK")
	-- f.targetGlow:SetTexture("Interface\\AddOns\\UnitPlates\\Media\\target-glow")
	-- f.targetGlow:SetTexCoord(0, .593, 0, .875)
	-- f.targetGlow:SetPoint("CENTER", f.health, "CENTER", 0, -10)
	-- f.targetGlow:SetVertexColor(unpack(self.db.profile.general.targetglowcolour))
	-- f.targetGlow:Hide()
	-- f.targetGlow:SetSize(nameplateHealthBarWidth, nameplateHealthBarHeight*4)

	-- raid icon ---------------------------------------------------------------
	f.icon:SetParent(f.overlay)
	f.icon:SetSize(raidIconSize, raidIconSize)
	f.icon:ClearAllPoints()
	f.icon:SetPoint("TOP", f.overlay, "BOTTOM", 0, -8 * minimalOnePixel)
	
	----------------------------------------------------------------------------
	
	f.castWarning = CreateFrame("Frame", nil, f)
	f.castWarning:SetFrameLevel(0)
	f.castWarning:SetPoint("TOP", f.power, "BOTTOM", 0, -5 * minimalOnePixel)
	f.castWarning:SetWidth(1)
	f.castWarning:SetHeight(1)
	f.castWarning:Hide()
	
	f.castWarning.bar = CreateFrame("StatusBar", nil, f.castWarning)
	f.castWarning.bar:SetStatusBarTexture("Interface\\AddOns\\UnitPlates\\img\\statusbar\\XPerl_StatusBar7")
	f.castWarning.bar:GetStatusBarTexture():SetDrawLayer("ARTWORK", 2)
	f.castWarning.bar:SetStatusBarColor(unpack(castBarColor))
	f.castWarning.bar:SetHeight(4)
	f.castWarning.bar:SetWidth(nameplateHealthBarWidth)
	f.castWarning.bar:SetPoint("TOP", f.castWarning, "TOP", 0, 0)
	f.castWarning.bar:SetMinMaxValues(0, 1)
	
	f.castWarning.bar:SetBackdrop({
		bgFile = "Interface\\AddOns\\UnitPlates\\img\\WHITE", -- A solid texture
		edgeFile = "Interface\\AddOns\\UnitPlates\\img\\WHITE", 
		edgeSize = 1, 
		insets = { left = -minimalOnePixel, right = -minimalOnePixel, top = -minimalOnePixel, bottom = -minimalOnePixel }
	})
	f.castWarning.bar:SetBackdropColor(0, 0, 0, 1) -- Black Background
	f.castWarning.bar:SetBackdropBorderColor(0, 0, 0, 1) -- Black Border
	
	-- uninterruptible cast shield -----------------------------------------
	f.castWarning.shield = f.castWarning.bar:CreateTexture(nil, "ARTWORK")
	f.castWarning.shield:SetTexture("Interface\\AddOns\\UnitPlates\\Media\\Shield")
	f.castWarning.shield:SetTexCoord(0, 0.84375, 0, 1)
	f.castWarning.shield:SetVertexColor(0.5, 0.5, 0.7)

	f.castWarning.shield:SetSize(castBarSizes.shield * .84375, castBarSizes.shield)
	f.castWarning.shield:SetPoint("LEFT", f.castWarning.bar, -7 * minimalOnePixel, 0)

	f.castWarning.shield:SetBlendMode("BLEND")
	f.castWarning.shield:SetDrawLayer("ARTWORK", 7)
	
	--
	f.castWarning.spark = f.castWarning.bar:CreateTexture(nil, "ARTWORK")
	f.castWarning.spark:SetDrawLayer("ARTWORK", 6)
	f.castWarning.spark:SetVertexColor(1, 1, 0.8)
	f.castWarning.spark:SetTexture("Interface\\AddOns\\UnitPlates\\Media\\t\\spark")
	f.castWarning.spark:SetPoint("TOP", f.castWarning.bar:GetRegions(), "TOPRIGHT", 0, 3 * minimalOnePixel)
	f.castWarning.spark:SetPoint("BOTTOM", f.castWarning.bar:GetRegions(), "BOTTOMRIGHT", 0, -3 * minimalOnePixel)
	f.castWarning.spark:SetWidth(6)
	
	f.castWarning.curr = f.castWarning.bar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.castWarning.curr:SetFont("Interface\\AddOns\\UnitPlates\\fonts\\francois.ttf", castWarningDurationFontSize, "OUTLINE")
	--f.castWarning.curr:SetPoint("LEFT", f.castWarning.bar, "RIGHT", 2, 0)
	f.castWarning.curr:SetPoint("BOTTOMRIGHT", f.castWarning.bar, "BOTTOMRIGHT", -1 * minimalOnePixel, -(castWarningDurationFontSize * 0.65))
	f.castWarning.curr:SetText("0")
	
	f.castWarning.text = f.castWarning:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	f.castWarning.text:SetFont("Interface\\AddOns\\UnitPlates\\fonts\\francois.ttf", castWarningNameFontSize, "OUTLINE")
	f.castWarning.text:SetPoint("TOP", f.castWarning.bar, "BOTTOM", 0, -5)
	-- f.castWarning.text:SetText("69")
	-- f.castWarning.text:SetTextColor(1,1,1,1)
	
	f.castWarning.icon = CreateFrame("Frame", nil, f.castWarning)
	f.castWarning.icon:SetFrameLevel(0)
	f.castWarning.icon:SetPoint("RIGHT", f.castWarning.text, "LEFT", -2 * minimalOnePixel, 0)
	f.castWarning.icon:SetHeight(castBarSizes.icon)
	f.castWarning.icon:SetWidth(castBarSizes.icon)
	f.castWarning.icon.tex = f.castWarning.icon:CreateTexture(nil, "ARTWORK")
	f.castWarning.icon.tex:SetAllPoints()
	-- f.castWarning.icon.tex:SetTexture("Interface\\AddOns\\UnitPlates\\img\\loading.tga")
	
	f.castWarning.currentValue = 0
	f.castWarning.startTime = 0
	f.castWarning.endTime = 0
	f.castWarning.castTime = 0
	
	---------------------------------------------------------------------------------

	-- scripts -------------------------------------------------------------
	-- f.castbar:RegisterEvent("UNIT_SPELLCAST_START")
	-- f.castbar:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
	--cast bar end
	
	-- create combo points
	f.combopoints = CreateFrame("Frame", nil, f.overlay)
	f.combopoints:Hide()

	local pcp
	for i = 0, 4 do
		-- create individual combo point icons
		-- size and position of first icon is set in ScaleComboPoints
		local cp = f.combopoints:CreateTexture(nil, "ARTWORK")
		cp:SetDrawLayer("ARTWORK", 2)
		cp:SetTexture("Interface\\AddOns\\UnitPlates\\Media\\combopoint-round")

		if i > 0 then
			cp:SetPoint("LEFT", pcp, "RIGHT", combopointsSizes.spacing, 0)
		end

		tinsert(f.combopoints, i + 1, cp)
		pcp = cp
	end

	for i, cp in ipairs(f.combopoints) do
		cp:SetSize(combopointsSizes.combopoints, combopointsSizes.combopoints)

		if i == 1 then
			-- place first icon to offset others to center
			cp:SetPoint("BOTTOM", f.health, "BOTTOM", -(combopointsSizes.combopoints + combopointsSizes.spacing) * 2, -(combopointsSizes.combopoints / 2))
		end
	end
	-- create combo points end
	
	--totem
	frame.totem = CreateFrame("Frame", nil, frame)
	frame.totem:SetPoint("TOP", frame, "TOP", 0, 0)
	frame.totem:SetHeight(totemIconSize)
	frame.totem:SetWidth(totemIconSize)
	frame.totem.icon = frame.totem:CreateTexture(nil, "OVERLAY")
	frame.totem.icon:SetTexCoord(.078, .92, .079, .937)
	frame.totem.icon:SetAllPoints()
	frame.totem:SetBackdrop({
		bgFile = "Interface\\AddOns\\UnitPlates\\img\\WHITE", -- A solid texture
		edgeFile = "Interface\\AddOns\\UnitPlates\\img\\WHITE", 
		edgeSize = 1, 
		insets = { left = -(3 * minimalOnePixel), right = -(3 * minimalOnePixel), top = -(3 * minimalOnePixel), bottom = -(3 * minimalOnePixel) }
	})
	frame.totem:SetBackdropColor(0, 0, 0, 1) -- Black Background
	frame.totem:SetBackdropBorderColor(0, 0, 0, 1) -- Black Border
	--frame.totem:SetVertexColor(1, 1, 1, 1)
	frame.totem:Hide()
	--totem END
	
	--debuffs
	f.debuffContainer = CreateFrame("Frame", nil, f)
	f.debuffContainer:SetPoint("BOTTOM", f.name, "TOP", 0, 0)
	f.debuffContainer:SetHeight(nameplateHealthBarHeight)
	f.debuffContainer:SetWidth(nameplateHealthBarWidth)
	f.debuffContainer:SetScript("OnUpdate", function(self, elapsed)
		self.nextUpdate = (self.nextUpdate or 0) - elapsed
		if self.nextUpdate > 0 then return end
		self.nextUpdate = 0.1 
		
		local f = self:GetParent() -- Reference the nameplate
		local currentTime = GetTime()
		local needsShift = false
		
		-- 1. First Pass: Update Timers and Detect Expirations
		for i = 1, maxDebuffs do
			local icon = self.debuffs[i]
			if icon:IsShown() and icon.expiration then
				local timeLeft = icon.expiration - currentTime
				
				if timeLeft <= 0 then
					-- This icon expired!
					icon.expiration = nil
					icon.duration = nil
					
					if f.unitId and UnitExists(f.unitId) then
						-- Scenario A: Valid Unit, just redraw everything and stop
						UpdateDebuffs(f, f.unitId)
						return 
					else
						-- Scenario B: No Unit, mark for manual shift
						icon:Hide()
						needsShift = true
					end
				else
					-- -- Update your custom timer text here
					-- if timeLeft < 5 then
						-- icon.timerText:SetText(string.format("%.1f", timeLeft))
					-- else
						-- icon.timerText:SetText(math.floor(timeLeft))
					-- end
				end
			end
		end
		
		-- 2. Second Pass: Manual Shift (Only if an icon expired in Scenario B)
		if needsShift then
			for i = 1, maxDebuffs - 1 do
				local currentIcon = self.debuffs[i]
				-- If this slot is now empty, try to pull from the next slot
				if not currentIcon:IsShown() then
					local nextIcon = self.debuffs[i+1]
					if nextIcon:IsShown() then
						-- Copy data
						currentIcon.tex:SetTexture(nextIcon.tex:GetTexture())
						currentIcon.expiration = nextIcon.expiration
						currentIcon.duration = nextIcon.duration
						
						local countText = nextIcon.count:GetText()
						currentIcon.count:SetText(countText or "")
						if countText and countText ~= "" then currentIcon.count:Show() else currentIcon.count:Hide() end
						
						-- Restart Spiral
						if currentIcon.expiration and currentIcon.duration then
							currentIcon.cd:SetCooldown(currentIcon.expiration - currentIcon.duration, currentIcon.duration)
							currentIcon.cd:Show()
						end

						currentIcon:Show()
						
						-- Clear the source
						nextIcon.expiration = nil
						nextIcon:Hide()
					end
				end
			end
		end
		
	end)
	
	f.debuffContainer.debuffs = {} -- Table to hold our icon frames
	--f.debuffContainer:SetFrameStrata("TOOLTIP")
	
	for i = 1, maxDebuffs do
		-- f.debuffContainer.icon1 = f.typeIcon:CreateTexture(nil, "OVERLAY")
		-- f.debuffContainer.icon1:SetTexture("Interface\\AddOns\\UnitPlates\\img\\loading.tga")
		-- f.debuffContainer.icon1:SetSize(debuffIconSize, debuffIconSize)
		
		-- f.debuffContainer.icon1:SetPoint("BOTTOMLEFT", f.debuffContainer, "BOTTOMLEFT", 0, 0)
		
		local icon = CreateFrame("Frame", nil, f.debuffContainer)
		icon:SetSize(debuffIconSize, debuffIconSize)
		icon:SetFrameLevel(1)
		
		-- 1. The Actual Texture
		icon.tex = icon:CreateTexture(nil, "BACKGROUND")
		icon.tex:SetTexture("Interface\\AddOns\\UnitPlates\\img\\loading.tga")
		icon.tex:SetAllPoints(icon)
		--icon.tex:SetFrameLevel(0)
		
		-- 2. The Stack Count (e.g., Sunder Armor x5)
		icon.count = icon:CreateFontString(nil, "OVERLAY", "SubSpellFont")
		icon.count:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, 0)
		icon.count:SetFont("Interface\\AddOns\\UnitPlates\\fonts\\francois.ttf", powerFontSize, "OUTLINE")
		icon.count:SetTextColor(1,1,1,1)
		
		-- 3. The Cooldown Spiral (Requires a specific frame type)
		icon.cd = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
		icon.cd:SetAllPoints(icon)
		icon.cd:SetReverse(true)
		icon.cd:SetFrameLevel(10)

		icon:Hide() -- Hide by default
		-- Inside your icon creation loop
		f.debuffContainer.debuffs[i] = icon -- Store in our pool
	end
	--debuffs END

	----------------------------------------------------------------- Scripts --
	frame:HookScript("OnShow", OnFrameShow)
	frame:HookScript("OnHide", OnFrameHide)
	frame:HookScript("OnUpdate", OnFrameUpdate)

	f.oldHealth.kuiParent = frame
	f.oldHealth:HookScript("OnValueChanged", function(self, ...) f:OnHealthValueChanged(...) end)
	------------------------------------------------------------ Finishing up --
	addon:SendMessage("UnitPlates_PostCreate", f)
	
	------------------------------------------------------------

	if frame:IsShown() then
		-- force OnShow
		OnFrameShow(frame)
	else
		f:Hide()
	end
end

---------------------------------------------------------------------- Events --
function addon:PLAYER_ENTERING_WORLD()
	-- Enable overlapping (Disable collision)
	SetCVar("chatBubbles", 1) 
    SetCVar("chatBubblesParty", 1)
    
    -- This specific CVar helps prevent bubbles from flying off-screen 
    -- when nameplates are active
    --SetCVar("bloatTest", 0)	
	
    SetCVar("nameplateAllowOverlap", 1)
	
	SetCVar("ShowClassColorInNameplate", 0)
	
	SetCVar("showVKeyCastbar", 1)
	
	-- force enable threat on nameplates - this is a hidden CVar
	SetCVar("threatWarning", 3)
	
	--UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")[cite: 1]
	
	-- Optional: These are the only other common movement CVars in 3.3.5
    -- They control how far away plates appear
    -- SetCVar("nameplateMaxDistance", 40)

	if InCombatLockdown() then
		self:PLAYER_REGEN_DISABLED()
	else
		self:PLAYER_REGEN_ENABLED()
	end
end
function addon:PLAYER_REGEN_DISABLED()
	-- if profile.general.combataction_hostile > 1 then
		-- SetCVar("nameplateShowEnemies", profile.general.combataction_hostile == 3 and 1 or 0)
	-- end
	-- if profile.general.combataction_friendly > 1 then
		-- SetCVar("nameplateShowFriends", profile.general.combataction_friendly == 3 and 1 or 0)
	-- end
end
function addon:PLAYER_REGEN_ENABLED()
	-- if profile.general.combataction_hostile > 1 then
		-- SetCVar("nameplateShowEnemies", profile.general.combataction_hostile == 2 and 1 or 0)
	-- end
	-- if profile.general.combataction_friendly > 1 then
		-- SetCVar("nameplateShowFriends", profile.general.combataction_friendly == 2 and 1 or 0)
	-- end
end
------------------------------------------------------------- Script handlers --
function addon:configChangedListener()
	-- cache values used often to reduce table lookup
	-- profile = addon.db.profile
	-- profile_hp = profile.hp
	-- profile_fade = profile.fade
	-- profile_fade_rules = profile_fade.rules
	-- profile_lowhealthval = profile.general.lowhealthval
end

----------------------------------
-- local chatEventsCatcherFrame = CreateFrame("Frame", "UnitPlatesChatEventsCatcherFrame", UIParent)
-- chatEventsCatcherFrame:SetFrameStrata("LOW")
-- chatEventsCatcherFrame:SetScript("OnEvent", function(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
	-- --local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12

	-- --guid is arg13
	-- --message is arg2
	-- --name is arg2
	
	-- print("arg1: "..tostring(arg1))
	-- print("arg2: "..tostring(arg2))
	-- print("arg3: "..tostring(arg3))
	-- print("arg4: "..tostring(arg4))
	-- print("arg5: "..tostring(arg5))
	-- print("arg6: "..tostring(arg6))
	-- print("arg7: "..tostring(arg7))
	-- print("arg8: "..tostring(arg8))
	-- print("arg9: "..tostring(arg9))
	-- print("arg10: "..tostring(arg10))
	-- print("arg11: "..tostring(arg11))
	-- print("arg12: "..tostring(arg12))
	-- print("arg13: "..tostring(arg13))
	-- print("arg14: "..tostring(arg14))
	
	-- print("receved chat msg event with: "..tostring(arg13).." / "..tostring(arg3).." / "..tostring(arg2))
	
	-- if arg13 then
		-- local guidPlateFrame = addon:GetNameplate(arg13, nil)
		-- if guidPlateFrame then
			-- print("1found plate for chat evnt : "..tostring(arg13).." / "..tostring(arg3).." / "..tostring(arg2))
			-- updateCustomBalloonText(guidPlateFrame, arg2, guidPlateFrame.name:GetTextColor())
		-- end
	-- else
		-- if arg3 then
			-- --check if name is player, then might as well display
			-- local guidPlateFrame = addon:GetNameplate(arg13, arg3)
			-- if guidPlateFrame then
				-- print("2found plate for chat evnt : "..tostring(arg13).." / "..tostring(arg3).." / "..tostring(arg2))
				-- updateCustomBalloonText(guidPlateFrame, arg2, guidPlateFrame.name:GetTextColor())
			-- end
		-- end
	-- end
-- end)
-- chatEventsCatcherFrame:RegisterEvent("CHAT_MSG_SAY")
-- chatEventsCatcherFrame:RegisterEvent("CHAT_MSG_YELL")
-- chatEventsCatcherFrame:RegisterEvent("CHAT_MSG_PARTY")
-- chatEventsCatcherFrame:RegisterEvent("CHAT_MSG_MONSTER_SAY")
-- chatEventsCatcherFrame:RegisterEvent("CHAT_MSG_MONSTER_YELL")

function addon:OnChatEventInternal(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)

	--guid is arg12
	--message is arg1
	--name is arg2
	
	local pGuid = arg12
	local pName = arg2
	local pText = arg1
	
	-- print("event: "..tostring(event))
	-- print("arg1: "..tostring(arg1))
	-- print("arg2: "..tostring(arg2))
	-- print("arg3: "..tostring(arg3))
	-- print("arg4: "..tostring(arg4))
	-- print("arg5: "..tostring(arg5))
	-- print("arg6: "..tostring(arg6))
	-- print("arg7: "..tostring(arg7))
	-- print("arg8: "..tostring(arg8))
	-- print("arg9: "..tostring(arg9))
	-- print("arg10: "..tostring(arg10))
	-- print("arg11: "..tostring(arg11))
	-- print("arg12: "..tostring(arg12))
	-- print("arg13: "..tostring(arg13))
	-- print("arg14: "..tostring(arg14))
	
	-- print("receved chat msg event with: "..tostring(arg12).." / "..tostring(arg2).." / "..tostring(arg1))
	
	
	if event == "CHAT_MSG_EMOTE" then
		local namePlateFrame = addon:GetNameplate(nil, pName)
		if namePlateFrame and (namePlateFrame.player) then
			--store guid
			addon:StoreGUIDNoUnit(namePlateFrame, pGuid)
		end
		return
	end
	--early return
	
	
	
	local namePrefix = ""
	-- if ((pName ~= nil) and (pName ~= '')) then
		-- namePrefix = pName..": "
	-- end
	
	local textColor = chatTextColors[event] or {1, 1, 1, 0.99}
	
	-- local rr, gg, bb, aa = unpack(textColor)
	-- print("textColor: "..rr)
	-- print("textColor: "..gg)
	-- print("textColor: "..bb)
	-- print("textColor: "..aa)
	
	if ((pGuid ~= nil) and (pGuid ~= '')) then
		local guidPlateFrame = addon:GetNameplate(pGuid, nil)
		if guidPlateFrame then
			-- print("1found plate for chat evnt : "..tostring(pGuid).." / "..tostring(pName).." / "..tostring(pText))
			updateCustomBalloonText(guidPlateFrame, namePrefix..pText, unpack(textColor))
		else
			local namePlateFrame = addon:GetNameplate(nil, pName)
			if namePlateFrame and (namePlateFrame.player) then
				--also store guid?
				addon:StoreGUIDNoUnit(namePlateFrame, pGuid)
				--addon:StoreNameWithGUID(namePlateFrame.oldName:GetText(), pGuid)
				updateCustomBalloonText(namePlateFrame, namePrefix..pText, unpack(textColor))
			end
		end
	else
		if (pName ~= nil) and (pName ~= '') then
			--check if name is player, then might as well display
			local namePlateFrame = addon:GetNameplate(nil, pName)
			if namePlateFrame and (namePlateFrame.player) then
				-- print("2found plate for chat evnt : "..tostring(pGuid).." / "..tostring(pName).." / "..tostring(pText))
				updateCustomBalloonText(namePlateFrame, namePrefix..pText, unpack(textColor))
			end
		end
	end
end


function addon:CHAT_MSG_SAY()
	-- print("event: ")
	-- print("arg1: ")
	-- print("arg2: ")
	-- print("arg3: ")
	-- print("arg4: ")
	-- print("arg5: ")
	-- print("arg6: ")
	-- print("arg7: ")
	-- print("arg8: ")
	-- print("arg9: ")
	-- print("arg10: ")
	-- print("arg11: ")
	-- print("arg12: ")
	-- print("arg13: ")
	-- print("arg14: ")
	addon:OnChatEventInternal(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
function addon:CHAT_MSG_YELL()
	addon:OnChatEventInternal(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
function addon:CHAT_MSG_EMOTE()
	addon:OnChatEventInternal(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
function addon:CHAT_MSG_PARTY()
	addon:OnChatEventInternal(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
function addon:CHAT_MSG_MONSTER_SAY()
	addon:OnChatEventInternal(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
function addon:CHAT_MSG_MONSTER_YELL()
	addon:OnChatEventInternal(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
end
-- function addon:CHAT_MSG_MONSTER_EMOTE()
	-- addon:OnChatEventInternal(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
-- end



function addon:UNIT_AURA(event, arg1, arg2)
	--local event, arg1, arg2
	-- print(""..event)
	-- print(""..arg1)
	-- print(""..tostring(arg2))
	--arg1 is unitId
	if arg1 then
		--update debuffs
		-- print("try get plate")
		local plate = addon:GetUnitPlate(arg1)
		if plate then
		-- print("has plate")
			UpdateDebuffs(plate, arg1)
		end
	end
end