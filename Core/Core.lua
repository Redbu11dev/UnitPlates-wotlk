local addon = LibStub("AceAddon-3.0"):NewAddon("UnitPlates", "AceEvent-3.0", "AceTimer-3.0")
addon.version = GetAddOnMetadata("UnitPlates", "Version")
addon.website = GetAddOnMetadata("UnitPlates", "X-Website")
_G.UnitPlates = addon

local kui = LibStub("Kui-1.0")
local LSM = LibStub("LibSharedMedia-3.0")

_G.SLASH_UNITPLATES1 = "/unitplates"
_G.SLASH_UNITPLATES2 = "/up"

function SlashCmdList.UNITPLATES()
	print("UnitPlates config is not available yet")
	unitPlatesOptionsFrame:Show()
end



UnitPlatesScanTool = CreateFrame( "GameTooltip", "ScanTooltip", nil, "GameTooltipTemplate" )
UnitPlatesScanTool:SetOwner( WorldFrame, "ANCHOR_NONE" )
UnitPlatesScanTextLine2 = _G["ScanTooltipTextLeft2"] -- This is the line with <[Player]'s Pet>

local group_update
local GROUP_UPDATE_INTERVAL = 1
local group_update_elapsed

addon.font = ""
addon.uiscale = nil

addon.frameList = {}
addon.numFrames = 0

-- sizes of frame elements
-- some populated by UpdateSizesTable & ScaleFontSizes
-- addon.sizes = {
	-- frame = {
		-- bgOffset = 8 -- inset of the frame glow
	-- },
	-- tex = {
		-- targetGlowH = 7,
		-- targetArrow = 33
	-- },
	-- font = {}
-- }

-- -- as these are scaled with the user option we need to store the default
-- addon.defaultFontSizes = {
	-- large = 12,
	-- spellname = 11,
	-- name = 11,
	-- level = 11,
	-- health = 11,
	-- small = 9
-- }

-- add latin-only fonts to LSM
-- LSM:Register(LSM.MediaType.FONT, "Yanone Kaffesatz Bold", kui.m.f.yanone)
-- LSM:Register(LSM.MediaType.FONT, "FrancoisOne", kui.m.f.francois)
local DEFAULT_FONT = "FrancoisOne"

-- add my status bar textures too..
-- LSM:Register(LSM.MediaType.STATUSBAR, "Kui status bar", kui.m.t.bar)
-- LSM:Register(LSM.MediaType.STATUSBAR, "Kui shaded bar", kui.m.t.oldbar)
local DEFAULT_BAR = "Kui status bar"

-- local locale = GetLocale()
-- local latin = (locale ~= "zhCN" and locale ~= "zhTW" and locale ~= "koKR" and locale ~= "ruRU")

spellSchoolColors = {
	[1] = {a = 1.00, r = 1.00, g = 1.00, b = 0.00}, -- Physical
	[2] = {a = 1.00, r = 1.00, g = 0.90, b = 0.50}, -- Holy
	[4] = {a = 1.00, r = 1.00, g = 0.50, b = 0.00}, -- Fire
	[8] = {a = 1.00, r = 0.30, g = 1.00, b = 0.30}, -- Nature
	[16] = {a = 1.00, r = 0.50, g = 1.00, b = 1.00}, -- Frost
	[20] = {a = 1.00, r = 0.50, g = 1.00, b = 1.00}, -- Frostfire
	[32] = {a = 1.00, r = 0.50, g = 0.50, b = 1.00}, -- Shadow
	[64] = {a = 1.00, r = 1.00, g = 0.50, b = 1.00} -- Arcane
}

---------------------------

------------------------------------------ GUID/name storage functions --
do
	local knownGUIDs = {} -- GUIDs that we can relate to names (i.e. players)
	local knownIndex = {}

	-- loaded = visible frames that currently possess this key
	local loadedGUIDs, loadedNames = {}, {}

	function addon:StoreNameWithGUID(name, guid)
		-- used to provide aggressive name -> guid matching
		-- should only be used for players
		if not name or not guid then
			return
		end
		if knownGUIDs[name] then
			return
		end
		knownGUIDs[name] = guid
		tinsert(knownIndex, name)

		-- purging index > 100 names
		if #knownIndex > 100 then
			knownGUIDs[tremove(knownIndex, 1)] = nil
		end
	end

	function addon:GetGUID(f)
		-- give this frame a guid if we think we already know it
		if f.player and knownGUIDs[f.name.text] then
			f.guid = knownGUIDs[f.name.text]
			loadedGUIDs[f.guid] = f

			addon:SendMessage("UnitPlates_GUIDAssumed", f)
		end
	end
	function addon:StoreGUID(f, unit, guid)
		if not unit then
			return
		end
		if not guid then
			guid = UnitGUID(unit)
			if not guid then
				return
			end
		end

		if f.guid and loadedGUIDs[f.guid] then
			if f.guid ~= guid then
				-- the currently stored guid is incorrect
				loadedGUIDs[f.guid] = nil
			else
				return
			end
		end

		f.guid = guid
		loadedGUIDs[guid] = f

		if UnitIsPlayer(unit) then
			-- we can probably assume this unit has a unique name
			-- nevertheless, overwrite this each time. just in case.
			self:StoreNameWithGUID(f.name.text, guid)
		elseif loadedNames[f.name.text] == f then
			-- force the registered f for this name to change
			loadedNames[f.name.text] = nil
		end

		--print('got GUID for: '..f.name.text.. '; '..f.guid)
		addon:SendMessage("UnitPlates_GUIDStored", f, unit)
	end
	
	function addon:StoreGUIDNoUnit(f, guid)
		if f.guid and loadedGUIDs[f.guid] then
			if f.guid ~= guid then
				-- the currently stored guid is incorrect
				loadedGUIDs[f.guid] = nil
			else
				return
			end
		end

		f.guid = guid
		loadedGUIDs[guid] = f

		self:StoreNameWithGUID(f.name.text, guid)
	end
	
	-- function GetUnitIDFromGUID(guid)
		-- -- 1. Check the obvious ones first (fastest)
		-- if UnitGUID("target") == guid then return "target" end
		-- if UnitGUID("mouseover") == guid then return "mouseover" end
		-- if UnitGUID("focus") == guid then return "focus" end

		-- -- 2. Check group members' targets
		-- -- This is how you find the GUID for mobs you aren't touching
		-- local groupType = IsInRaid() and "raid" or "party"
		-- local groupSize = GetNumGroupMembers()

		-- for i = 1, groupSize do
			-- local unit = groupType .. i .. "target"
			-- if UnitGUID(unit) == guid then
				-- return unit
			-- end
		-- end

		-- return nil
	-- end
	
	-- function GetUnitIDFromGUID(guid)
		-- if not guid then return nil end

		-- -- 1. Primary Units (Fastest)
		-- if UnitGUID("target") == guid then return "target" end
		-- if UnitGUID("mouseover") == guid then return "mouseover" end
		-- if UnitGUID("focus") == guid then return "focus" end
		-- if UnitGUID("pettarget") == guid then return "pettarget" end

		-- -- 2. Group Targets
		-- if GetNumGroupMembers() > 0 then
			-- local groupType = IsInRaid() and "raid" or "party"
			
			-- for i = 1, GetNumGroupMembers() do
				-- local unit = groupType .. i .. "target"
				-- if UnitGUID(unit) == guid then
					-- return unit
				-- end
				
				-- -- Also check group members' pets' targets
				-- local petUnit = groupType .. "pet" .. i .. "target"
				-- if UnitGUID(petUnit) == guid then
					-- return petUnit
				-- end
			-- end
		-- end

		-- -- 3. Arena / Boss Units (Specific encounters)
		-- -- Checking arena targets (1-5)
		-- for i = 1, 5 do
			-- local arenaUnit = "arena" .. i .. "target"
			-- if UnitGUID(arenaUnit) == guid then
				-- return arenaUnit
			-- end
		-- end

		-- -- Checking boss units (1-4)
		-- for i = 1, 4 do
			-- local bossUnit = "boss" .. i .. "target"
			-- if UnitGUID(bossUnit) == guid then
				-- return bossUnit
			-- end
		-- end

		-- return nil
	-- end
	
	function GetUnitIDFromName(name)
		if not name then return nil end

		-- 1. Primary Units (Fastest/Most likely)
		if UnitName("target") == name then return "target" end
		if UnitName("mouseover") == name then return "mouseover" end
		if UnitName("focus") == name then return "focus" end
		if UnitName("player") == name then return "player" end
		if UnitName("pet") == name then return "pet" end
		if UnitName("vehicle") == name then return "vehicle" end
		if UnitName("npc") == name then return "npc" end

		-- 2. Target Chains (Immediate)
		if UnitName("targettarget") == name then return "targettarget" end
		if UnitName("focustarget") == name then return "focustarget" end
		if UnitName("pettarget") == name then return "pettarget" end

		-- 3. Boss and Arena Units
		for i = 1, 4 do
			local unit = "boss" .. i
			if UnitName(unit) == name then return unit end
			if UnitName(unit .. "target") == name then return unit .. "target" end
		end

		for i = 1, 5 do
			local arenaUnit = "arena" .. i
			local arenaPet = "arenapet" .. i
			if UnitName(arenaUnit) == name then return arenaUnit end
			if UnitName(arenaUnit .. "target") == name then return arenaUnit .. "target" end
			if UnitName(arenaPet) == name then return arenaPet end
			if UnitName(arenaPet .. "target") == name then return arenaPet .. "target" end
		end

		-- 4. Group Members (Raid or Party)
		if GetNumPartyMembers() > 0 then
			for i = 1, 4 do
				local unit = "party" .. i
				local pet = "partypet" .. i
				if UnitName(unit) == name then return unit end
				if UnitName(unit .. "target") == name then return unit .. "target" end
				if UnitName(pet) == name then return pet end
				if UnitName(pet .. "target") == name then return pet .. "target" end
			end
			
			for i = 1, 40 do
				local unit = "raid" .. i
				local pet = "raidpet" .. i
				if UnitName(unit) == name then return unit end
				if UnitName(unit .. "target") == name then return unit .. "target" end
				if UnitName(pet) == name then return pet end
				if UnitName(pet .. "target") == name then return pet .. "target" end
			end
		end
		-- if IsInRaid() then
			-- for i = 1, 40 do
				-- local unit = "raid" .. i
				-- local pet = "raidpet" .. i
				-- if UnitName(unit) == name then return unit end
				-- if UnitName(unit .. "target") == name then return unit .. "target" end
				-- if UnitName(pet) == name then return pet end
				-- if UnitName(pet .. "target") == name then return pet .. "target" end
			-- end
		-- else
			-- for i = 1, 4 do
				-- local unit = "party" .. i
				-- local pet = "partypet" .. i
				-- if UnitName(unit) == name then return unit end
				-- if UnitName(unit .. "target") == name then return unit .. "target" end
				-- if UnitName(pet) == name then return pet end
				-- if UnitName(pet .. "target") == name then return pet .. "target" end
			-- end
		-- end

		return nil
	end
	
	
	
	-------------------
	
	function GetUnitIDFromGUID(guid)
		if not guid then return nil end

		-- 1. Primary Units (Fastest/Most likely)
		if UnitGUID("target") == guid then return "target" end
		if UnitGUID("mouseover") == guid then return "mouseover" end
		if UnitGUID("focus") == guid then return "focus" end
		if UnitGUID("player") == guid then return "player" end
		if UnitGUID("pet") == guid then return "pet" end
		if UnitGUID("vehicle") == guid then return "vehicle" end
		if UnitGUID("npc") == guid then return "npc" end

		-- 2. Target Chains (Immediate)
		if UnitGUID("targettarget") == guid then return "targettarget" end
		if UnitGUID("focustarget") == guid then return "focustarget" end
		if UnitGUID("pettarget") == guid then return "pettarget" end

		-- 3. Boss and Arena Units
		for i = 1, 4 do
			local unit = "boss" .. i
			if UnitGUID(unit) == guid then return unit end
			if UnitGUID(unit .. "target") == guid then return unit .. "target" end
		end

		for i = 1, 5 do
			local arenaUnit = "arena" .. i
			local arenaPet = "arenapet" .. i
			if UnitGUID(arenaUnit) == guid then return arenaUnit end
			if UnitGUID(arenaUnit .. "target") == guid then return arenaUnit .. "target" end
			if UnitGUID(arenaPet) == guid then return arenaPet end
			if UnitGUID(arenaPet .. "target") == guid then return arenaPet .. "target" end
		end

		-- 4. Group Members (Raid or Party)
		if GetNumPartyMembers() > 0 then
			for i = 1, 4 do
				local unit = "party" .. i
				local pet = "partypet" .. i
				if UnitGUID(unit) == guid then return unit end
				if UnitGUID(unit .. "target") == guid then return unit .. "target" end
				if UnitGUID(pet) == guid then return pet end
				if UnitGUID(pet .. "target") == guid then return pet .. "target" end
			end
			
			for i = 1, 40 do
				local unit = "raid" .. i
				local pet = "raidpet" .. i
				if UnitGUID(unit) == guid then return unit end
				if UnitGUID(unit .. "target") == guid then return unit .. "target" end
				if UnitGUID(pet) == guid then return pet end
				if UnitGUID(pet .. "target") == guid then return pet .. "target" end
			end
		end
		
		
		-- if IsInRaid() then
			-- for i = 1, 40 do
				-- local unit = "raid" .. i
				-- local pet = "raidpet" .. i
				-- if UnitGUID(unit) == guid then return unit end
				-- if UnitGUID(unit .. "target") == guid then return unit .. "target" end
				-- if UnitGUID(pet) == guid then return pet end
				-- if UnitGUID(pet .. "target") == guid then return pet .. "target" end
			-- end
		-- else
			-- for i = 1, 4 do
				-- local unit = "party" .. i
				-- local pet = "partypet" .. i
				-- if UnitGUID(unit) == guid then return unit end
				-- if UnitGUID(unit .. "target") == guid then return unit .. "target" end
				-- if UnitGUID(pet) == guid then return pet end
				-- if UnitGUID(pet .. "target") == guid then return pet .. "target" end
			-- end
		-- end

		return nil
	end
	
	function getClassPos(class)
		if(class=="WARRIOR") then return 0,    0.25,    0,	0.25;	end
		if(class=="MAGE")    then return 0.25, 0.5,     0,	0.25;	end
		if(class=="ROGUE")   then return 0.5,  0.75,    0,	0.25;	end
		if(class=="DRUID")   then return 0.75, 1,       0,	0.25;	end
		if(class=="HUNTER")  then return 0,    0.25,    0.25,	0.5;	end
		if(class=="SHAMAN")  then return 0.25, 0.5,     0.25,	0.5;	end
		if(class=="PRIEST")  then return 0.5,  0.75,    0.25,	0.5;	end
		if(class=="WARLOCK") then return 0.75, 1,       0.25,	0.5;	end
		if(class=="PALADIN") then return 0,    0.25,    0.5,	0.75;	end
		return 0.25, 0.5, 0.5, 0.75	-- Returns empty next one, so blank
	end
	
	function KKAbbreviate(number)
		local sign = number < 0 and -1 or 1
		number = math.abs(number)

		if number > 1000000 then
			return KKround(number/1000000*sign,2) .. "m"
		elseif number > 1000 then
			return KKround(number/1000*sign,2) .. "k"
		end
		
		return number
	end
	
	function KKround(input, places)
		if not places then places = 0 end
		
		if type(input) == "number" and type(places) == "number" then
			local pow = 1
			for i = 1, places do pow = pow * 10 end
			return floor(input * pow + 0.5) / pow
		end
	end
	
	-- function GetClassFromNameColor(f)
		-- -- Ensure it's a player first (usually blue name color by default if not class colored)
		-- -- But if 'Class Colors on Nameplates' is enabled in interface options:
		-- local r, g, b = f.oldName:GetTextColor()
		
		-- -- Round the values to handle precision issues
		-- r, g, b = floor(r * 100 + .5) / 100, floor(g * 100 + .5) / 100, floor(b * 100 + .5) / 100

		-- for class, color in pairs(RAID_CLASS_COLORS) do
			-- if r == floor(color.r * 100 + .5) / 100 and
			   -- g == floor(color.g * 100 + .5) / 100 and
			   -- b == floor(color.b * 100 + .5) / 100 then
				-- return class
			-- end
		-- end
		-- return nil
	-- end
	
	
	
	function addon:StoreName(f)
		if not f.name.text or f.guid then
			return
		end
		if not loadedNames[f.name.text] then
			loadedNames[f.name.text] = f
		end
	end
	function addon:FrameHasName(f)
		return loadedNames[f.name.text] == f
	end
	function addon:FrameHasGUID(f)
		return loadedGUIDs[f.guid] == f
	end
	function addon:ClearName(f)
		if self:FrameHasName(f) then
			loadedNames[f.name.text] = nil
		end
	end
	function addon:ClearGUID(f)
		if self:FrameHasGUID(f) then
			loadedGUIDs[f.guid] = nil
		end
		f.guid = nil
	end
	function addon:GetNameplate(guid, name)
		--print("called addon:GetNameplate with: "..tostring(guid).." / "..tostring(name))
		local gf, nf = loadedGUIDs[guid], loadedNames[name]

		if gf then
			return gf
		elseif nf then
			return nf
		else
			return nil
		end
	end

	-- return the given unit's nameplate
	function addon:GetUnitPlate(unit)
		return self:GetNameplate(UnitGUID(unit), GetUnitName(unit))
	end

	-- store an assumed unique name with its guid before it becomes visible
	local function StoreUnit(unit)
		if not unit then
			return
		end

		local guid = UnitGUID(unit)
		if not guid then
			return
		end
		
		local isPlayer = UnitIsPlayer(unit)
		local name = UnitName(unit)
		
		--cache in NPC info
		local creatureType = UnitCreatureType(unit)
		if creatureType then
			StoreCacheNPCCreatureType(name, creatureType)
		end
		
		UnitPlatesScanTool:ClearLines()
		UnitPlatesScanTool:SetUnit(unit)
		local scanTextLine2Text = UnitPlatesScanTextLine2:GetText()
		if scanTextLine2Text and not string.find(scanTextLine2Text, "Level") then
			local guild = scanTextLine2Text
			--cache in guild
			if isPlayer then
				StoreCachePlayerGuild(name, guild)
			else
				StoreCacheNPCGuild(name, guild)
			end
		end
		--
		
		if not isPlayer then
			return
		end		
		
		if loadedGUIDs[guid] then
			return
		end

		local name = GetUnitName(unit)
		if not name or knownGUIDs[name] then
			return
		end
		addon:StoreNameWithGUID(name, guid)

		-- also send GUIDStored if the frame currently exists
		local f = addon:GetNameplate(guid, name)
		if f then
			addon:StoreGUID(f, unit, guid)
		else
			-- equivalent to GUIDStored, but with no currently-visible frame
			addon:SendMessage("UnitPlates_UnitStored", unit, name, guid)
		end
	end

	function addon:UPDATE_MOUSEOVER_UNIT(event)
		StoreUnit("mouseover")
		if UnitExists("mouseovertarget") then
			StoreUnit("mouseovertarget")
		end
	end
	function addon:PLAYER_TARGET_CHANGED(event)
		StoreUnit("target")
		if UnitExists("targettarget") then
			StoreUnit("targettarget")
		end
	end
	function addon:PLAYER_FOCUS_CHANGED(event)
		StoreUnit("focus")
		if UnitExists("focustarget") then
			StoreUnit("focustarget")
		end
	end

	local function GetGroupTypeAndCount()
		local t, stop, start = "raid", GetNumRaidMembers(), 1
		if stop == 0 then
			t, stop, start = "party", GetNumPartyMembers(), 0
		end
		if stop == 0 then
			t = nil
		end
		return t, stop, start
	end

	function addon:GroupUpdate()
		group_update = nil

		local t, stop, start = GetGroupTypeAndCount()
		if not t then
			return
		end

		for i = start, stop do
			StoreUnit(t .. i)
		end
	end
end
function addon:QueueGroupUpdate()
	group_update = true
	group_update_elapsed = 0
end

------------------------------------------------------------ main update loop --
do
	local WorldFrame, tinsert, select = WorldFrame, tinsert, select
	function addon:OnUpdate()
		-- find new nameplates
		local frames = select("#", WorldFrame:GetChildren())
		if frames ~= self.numFrames then
			local f
			for i = 1, frames do
				f = select(i, WorldFrame:GetChildren())
				if self:IsNameplate(f) and not f.kui then
					self:InitFrame(f)
					tinsert(self.frameList, f)
				end
			end
			self.numFrames = frames
		end
		-- process group update queue
		if group_update then
			group_update_elapsed = group_update_elapsed + .1
			if group_update_elapsed > GROUP_UPDATE_INTERVAL then
				self:GroupUpdate()
			end
		end
	end
end
------------------------------------------------------------------------ init --
function addon:OnInitialize()
	-- self.db = LibStub("AceDB-3.0"):New("UnitPlatesGDB", defaults)
	-- self:FinalizeOptions()

	-- self.db.RegisterCallback(self, "OnProfileChanged", "ProfileChanged")
	-- LSM.RegisterCallback(self, "LibSharedMedia_Registered", "LSMMediaRegistered")

	-- we treat these like built in elements rather than having them rely
	-- on messages
	-- addon.Castbar = addon:GetModule("Castbar")
	--addon.TankModule = addon:GetModule("TankMode")
end






function loadUnitPlatesDefaultSettings()
	UnitPlatesSettings = {
		minimapIconPos = 0,
		showBuffs=true,
		onlyYourBuffs=false,
		ignoredBuffNames = "name1,name2",
		showDebuffs=true,
		onlyYourDebuffs=false,
		ignoredDebuffNames = "name1,name2",
	}
end

function loadUnitPlatesSettings() 
	if UnitPlatesSettings == nil then
		loadUnitPlatesDefaultSettings()
		print("unable to load UnitPlates saved data, backing up to defaults")
	else
		if UnitPlatesSettings.minimapIconPos == nil then
			UnitPlatesSettings.minimapIconPos=0
		end
		if UnitPlatesSettings.showBuffs == nil then
			UnitPlatesSettings.showBuffs=true
		end
		if UnitPlatesSettings.onlyYourBuffs == nil then
			UnitPlatesSettings.onlyYourBuffs=true
		end
		if UnitPlatesSettings.ignoredBuffNames == nil then
			UnitPlatesSettings.ignoredBuffNames="name1,name2"
		end
		if UnitPlatesSettings.showDebuffs == nil then
			UnitPlatesSettings.showDebuffs=true
		end
		if UnitPlatesSettings.onlyYourDebuffs == nil then
			UnitPlatesSettings.onlyYourDebuffs=true
		end
		if UnitPlatesSettings.ignoredDebuffNames == nil then
			UnitPlatesSettings.ignoredDebuffNames="name1,name2"
		end
		print("UnitPlates saved data loaded")
	end
end

unitPlatesOptionsFrame = CreateFrame("Frame", "unitPlatesOptionsFrame", UIParent)

function initUnitPlatesSettings()
	loadUnitPlatesSettings() 

	unitPlatesOptionsFrame:SetMovable(true)
	unitPlatesOptionsFrame:EnableMouse(true)
	
	unitPlatesOptionsFrame:SetScript("OnMouseDown", function()
	  if arg1 == "LeftButton" and not unitPlatesOptionsFrame.isMoving then
	   unitPlatesOptionsFrame:StartMoving()
	   unitPlatesOptionsFrame.isMoving = true
	  end
	end)
	unitPlatesOptionsFrame:SetScript("OnMouseUp", function()
	  if arg1 == "LeftButton" and unitPlatesOptionsFrame.isMoving then
	   unitPlatesOptionsFrame:StopMovingOrSizing()
	   unitPlatesOptionsFrame.isMoving = false
	  end
	end)
	unitPlatesOptionsFrame:SetScript("OnHide", function()
	  if ( unitPlatesOptionsFrame.isMoving ) then
	   unitPlatesOptionsFrame:StopMovingOrSizing()
	   unitPlatesOptionsFrame.isMoving = false
	  end
	end)
	
	unitPlatesOptionsFrame:SetWidth(500)
	unitPlatesOptionsFrame:SetHeight(500)
	unitPlatesOptionsFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	
	unitPlatesOptionsFrame:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
		edgeSize = 12,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	})
	unitPlatesOptionsFrame:SetBackdropColor(0,0,0,.5)
	
	unitPlatesOptionsFrame.title = unitPlatesOptionsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	--nameplate.health.text:SetAllPoints()
	unitPlatesOptionsFrame.title:SetPoint("TOP", unitPlatesOptionsFrame, "TOP", 0, -8)
	unitPlatesOptionsFrame.title:SetTextColor(1,1,1,barAlpha)
	unitPlatesOptionsFrame.title:SetFont("Interface\\AddOns\\UnitPlates\\fonts\\francois.ttf", 12, "OUTLINE")
	unitPlatesOptionsFrame.title:SetJustifyH("LEFT")
	unitPlatesOptionsFrame.title:SetText("UnitPlates options")
	
	local closeButton = CreateFrame("Button", nil, unitPlatesOptionsFrame, "UIPanelButtonTemplate")
	closeButton:SetPoint("TOPRIGHT",0,0)
	closeButton:SetWidth(50)
	closeButton:SetHeight(25)
	closeButton:SetText("Close")
	closeButton:SetScript("OnClick", function()
		unitPlatesOptionsFrame:Hide()
	end)
	
	local setDefaultsButton = CreateFrame("Button", nil, unitPlatesOptionsFrame, "UIPanelButtonTemplate")
	setDefaultsButton:SetPoint("BOTTOM",0,0)
	setDefaultsButton:SetWidth(200)
	setDefaultsButton:SetHeight(40)
	setDefaultsButton:SetText("Set defaults & Reload")
	setDefaultsButton:SetScript("OnClick", function()
		loadUnitPlatesDefaultSettings()
		ReloadUI()
	end)
	
	-- Create the scrolling parent frame and size it to fit inside the texture
	unitPlatesOptionsFrame.scrollFrame = CreateFrame("ScrollFrame", "unitPlatesOptionsFrame_ScrollFrame", unitPlatesOptionsFrame, "UIPanelScrollFrameTemplate")
	unitPlatesOptionsFrame.scrollFrame:SetHeight(unitPlatesOptionsFrame:GetHeight())
	unitPlatesOptionsFrame.scrollBar = _G[unitPlatesOptionsFrame.scrollFrame:GetName() .. "ScrollBar"]
    unitPlatesOptionsFrame.scrollFrame:SetWidth(unitPlatesOptionsFrame:GetWidth())
	unitPlatesOptionsFrame.scrollFrame:SetPoint("TOPLEFT", 10, -30)
	unitPlatesOptionsFrame.scrollFrame:SetPoint("BOTTOMRIGHT", -30, 50)

	-- Create the scrolling child frame, set its width to fit, and give it an arbitrary minimum height (such as 1)
	local scrollChild = CreateFrame("Frame", nil, unitPlatesOptionsFrame.scrollFrame)
	scrollChild:SetWidth(unitPlatesOptionsFrame:GetWidth()-18)
	scrollChild:SetHeight(1) 
	scrollChild:SetAllPoints(unitPlatesOptionsFrame.scrollFrame)
	unitPlatesOptionsFrame.scrollFrame:SetScrollChild(scrollChild)
	
	local showBuffsCheckbox = CreateFrame("CheckButton", "showBuffsCheckbox", scrollChild, "UICheckButtonTemplate")
	showBuffsCheckbox:SetPoint("TOPLEFT",8,-24)
	getglobal(showBuffsCheckbox:GetName() .. 'Text'):SetText("Show buffs")
	showBuffsCheckbox:SetChecked(UnitPlatesSettings.showBuffs)
	showBuffsCheckbox.tooltip = "Show buffs"
	showBuffsCheckbox:SetScript("OnClick", function()
		UnitPlatesSettings.showBuffs=not UnitPlatesSettings.showBuffs
		--applyAllSettings()
	end)
	
	local showOnlyYourBuffsCheckbox = CreateFrame("CheckButton", "showOnlyYourBuffsCheckbox", scrollChild, "UICheckButtonTemplate")
	showOnlyYourBuffsCheckbox:SetPoint("TOP", showBuffsCheckbox, "BOTTOM", 0, -0)
	getglobal(showOnlyYourBuffsCheckbox:GetName() .. 'Text'):SetText("Show only your buffs")
	showOnlyYourBuffsCheckbox:SetChecked(UnitPlatesSettings.onlyYourBuffs)
	showOnlyYourBuffsCheckbox.tooltip = "Show only your buffs"
	showOnlyYourBuffsCheckbox:SetScript("OnClick", function()
		UnitPlatesSettings.onlyYourBuffs=not UnitPlatesSettings.onlyYourBuffs
		--applyAllSettings()
	end)
	
	local ignoredBuffnamesTitle = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	ignoredBuffnamesTitle:SetPoint("TOPLEFT", showOnlyYourBuffsCheckbox, "BOTTOMLEFT", 0, -4)
	ignoredBuffnamesTitle:SetTextColor(0.999,0.819,0,barAlpha)
	ignoredBuffnamesTitle:SetJustifyH("LEFT")
	ignoredBuffnamesTitle:SetText("Ignore buff names: ")
	
	local ignoredBuffnamesInput = CreateFrame("EditBox", nil, scrollChild)
	ignoredBuffnamesInput:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
		edgeSize = 12,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	})
	ignoredBuffnamesInput:SetBackdropColor(0,0,0,.5)
	ignoredBuffnamesInput:SetTextInsets(5, 5, 5, 5)
	ignoredBuffnamesInput:SetTextColor(1,1,1,1)
	ignoredBuffnamesInput:SetJustifyH("LEFT")
	ignoredBuffnamesInput:SetWidth(280)
	ignoredBuffnamesInput:SetHeight(26)
	ignoredBuffnamesInput:SetPoint("LEFT", ignoredBuffnamesTitle, "RIGHT", 0, 0)
	ignoredBuffnamesInput:SetFontObject("GameFontNormal")
	ignoredBuffnamesInput:SetAutoFocus(false)
	ignoredBuffnamesInput:SetText(""..UnitPlatesSettings.ignoredBuffNames)
	ignoredBuffnamesInput:SetScript("OnTextChanged", function(self)
		local inputValue = ignoredBuffnamesInput:GetText()
		if not inputValue then
			ignoredBuffnamesInput:SetText(""..UnitPlatesSettings.ignoredBuffNames)
		else
			UnitPlatesSettings.ignoredBuffNames = inputValue
			ignoredBuffnamesInput:SetText(""..UnitPlatesSettings.ignoredBuffNames)
			--applyAllSettings()
		end
	end)
	
	local showDebuffsCheckbox = CreateFrame("CheckButton", "showDebuffsCheckbox", scrollChild, "UICheckButtonTemplate")
	showDebuffsCheckbox:SetPoint("TOPLEFT", ignoredBuffnamesTitle, "BOTTOMLEFT", 0, -16)
	getglobal(showDebuffsCheckbox:GetName() .. 'Text'):SetText("Show debuffs")
	showDebuffsCheckbox:SetChecked(UnitPlatesSettings.showDebuffs)
	showDebuffsCheckbox.tooltip = "Show debuffs"
	showDebuffsCheckbox:SetScript("OnClick", function()
		UnitPlatesSettings.showDebuffs=not UnitPlatesSettings.showDebuffs
		--applyAllSettings()
	end)
	
	local showOnlyYourDebuffsCheckbox = CreateFrame("CheckButton", "showOnlyYourDebuffsCheckbox", scrollChild, "UICheckButtonTemplate")
	showOnlyYourDebuffsCheckbox:SetPoint("TOP", showDebuffsCheckbox, "BOTTOM", 0, -0)
	getglobal(showOnlyYourDebuffsCheckbox:GetName() .. 'Text'):SetText("Show only your debuffs")
	showOnlyYourDebuffsCheckbox:SetChecked(UnitPlatesSettings.onlyYourDebuffs)
	showOnlyYourDebuffsCheckbox.tooltip = "Show only your debuffs"
	showOnlyYourDebuffsCheckbox:SetScript("OnClick", function()
		UnitPlatesSettings.onlyYourDebuffs=not UnitPlatesSettings.onlyYourDebuffs
		--applyAllSettings()
	end)
	
	local ignoredDebuffnamesTitle = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	ignoredDebuffnamesTitle:SetPoint("TOPLEFT", showOnlyYourDebuffsCheckbox, "BOTTOMLEFT", 0, -4)
	ignoredDebuffnamesTitle:SetTextColor(0.999,0.819,0,barAlpha)
	ignoredDebuffnamesTitle:SetJustifyH("LEFT")
	ignoredDebuffnamesTitle:SetText("Ignore debuff names: ")
	
	local ignoredDebuffnamesInput = CreateFrame("EditBox", nil, scrollChild)
	ignoredDebuffnamesInput:SetBackdrop({
		bgFile = "Interface/Tooltips/UI-Tooltip-Background",
		edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
		edgeSize = 12,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	})
	ignoredDebuffnamesInput:SetBackdropColor(0,0,0,.5)
	ignoredDebuffnamesInput:SetTextInsets(5, 5, 5, 5)
	ignoredDebuffnamesInput:SetTextColor(1,1,1,1)
	ignoredDebuffnamesInput:SetJustifyH("LEFT")
	ignoredDebuffnamesInput:SetWidth(280)
	ignoredDebuffnamesInput:SetHeight(26)
	ignoredDebuffnamesInput:SetPoint("LEFT", ignoredDebuffnamesTitle, "RIGHT", 0, 0)
	ignoredDebuffnamesInput:SetFontObject("GameFontNormal")
	ignoredDebuffnamesInput:SetAutoFocus(false)
	ignoredDebuffnamesInput:SetText(""..UnitPlatesSettings.ignoredDebuffNames)
	ignoredDebuffnamesInput:SetScript("OnTextChanged", function(self)
		local inputValue = ignoredDebuffnamesInput:GetText()
		if not inputValue then
			ignoredDebuffnamesInput:SetText(""..UnitPlatesSettings.ignoredDebuffNames)
		else
			UnitPlatesSettings.ignoredDebuffNames = inputValue
			ignoredDebuffnamesInput:SetText(""..UnitPlatesSettings.ignoredDebuffNames)
			--applyAllSettings()
		end
	end)
	
	
	unitPlatesOptionsFrame:Hide()
end

---------------------------------------------------------------------- enable --
function addon:OnEnable()
	-- -- force enable threat on nameplates - this is a hidden CVar
	-- SetCVar("threatWarning", 3)

	-- get font and status bar texture from LSM
	-- self.font = LSM:Fetch(LSM.MediaType.FONT, self.db.profile.fonts.options.font)
	-- self.bartexture = LSM:Fetch(LSM.MediaType.STATUSBAR, self.db.profile.general.bartexture)
	self.bartexture = "X-Perl 3"

	self.uiscale = UIParent:GetEffectiveScale()

	self:configChangedListener()

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("PLAYER_FOCUS_CHANGED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("PARTY_MEMBERS_CHANGED", "QueueGroupUpdate")
	self:RegisterEvent("RAID_ROSTER_UPDATE", "QueueGroupUpdate")
	
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
	--MSG EVENTS
	self:RegisterEvent("CHAT_MSG_SAY")
	self:RegisterEvent("CHAT_MSG_YELL")
	self:RegisterEvent("CHAT_MSG_EMOTE")
	self:RegisterEvent("CHAT_MSG_PARTY")
	self:RegisterEvent("CHAT_MSG_MONSTER_SAY")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	-- self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	
	--debuffs
	self:RegisterEvent("UNIT_AURA")

	self:ScheduleRepeatingTimer("OnUpdate", 0.1)
	
	initUnitPlatesSettings()
end