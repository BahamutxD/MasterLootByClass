local MLC = CreateFrame("Frame")
local RaidDropDown = CreateFrame('Frame', 'RaidDropDown', UIParent, 'UIDropDownMenuTemplate')

MLC:RegisterEvent("ADDON_LOADED")
MLC:RegisterEvent("OPEN_MASTER_LOOT_LIST")
MLC:RegisterEvent("UPDATE_MASTER_LOOT_LIST")
MLC:RegisterEvent("RAID_ROSTER_UPDATE")
MLC:RegisterEvent("LOOT_SLOT_CLEARED")

MLC.raid = {
  ['warrior'] = {},
  ['paladin'] = {},
  ['druid'] = {},
  ['warlock'] = {},
  ['mage'] = {},
  ['priest'] = {},
  ['rogue'] = {},
  ['shaman'] = {},
  ['hunter'] = {},
}

MLC.classColors = {
  ["warrior"] = { r = 0.78, g = 0.61, b = 0.43, c = "|cffc79c6e" },
  ["mage"] = { r = 0.41, g = 0.8, b = 0.94, c = "|cff69ccf0" },
  ["rogue"] = { r = 1, g = 0.96, b = 0.41, c = "|cfffff569" },
  ["druid"] = { r = 1, g = 0.49, b = 0.04, c = "|cffff7d0a" },
  ["hunter"] = { r = 0.67, g = 0.83, b = 0.45, c = "|cffabd473" },
  ["shaman"] = { r = 0.14, g = 0.35, b = 1.0, c = "|cff0070de" },
  ["priest"] = { r = 1, g = 1, b = 1, c = "|cffffffff" },
  ["warlock"] = { r = 0.58, g = 0.51, b = 0.79, c = "|cff9482c9" },
  ["paladin"] = { r = 0.96, g = 0.55, b = 0.73, c = "|cfff58cba" },
}

function MLC.fillRaidData()
  MLC.raid = {
      ['warrior'] = {},
      ['paladin'] = {},
      ['druid'] = {},
      ['warlock'] = {},
      ['mage'] = {},
      ['priest'] = {},
      ['rogue'] = {},
      ['shaman'] = {},
      ['hunter'] = {},
  }
  if UnitInRaid("player") then
    for i = 0, GetNumRaidMembers() do
      if GetRaidRosterInfo(i) then
          local name, _, _, _, _, _, z = GetRaidRosterInfo(i);
          local _, unitClass = UnitClass('raid' .. i)
          unitClass = string.lower(unitClass)
          table.insert(MLC.raid[unitClass], name)
      end
    end
  end
end

local function GetMLID(name)
  if GetNumRaidMembers() > 0 then
    for i = 1, 40 do
      if GetMasterLootCandidate(i) == name then
        return i
      end
    end
  end
    return nil
end

local function GiveToRandom()
	local max = GetNumRaidMembers()
	local name, id
  local item = LootFrame.selectedSlot
  local link = GetLootSlotLink(item)
	while not name do
		id = math.random(1, max)
		name = GetMasterLootCandidate(id)
	end
  if IsRaidLeader() or IsRaidOfficer() then
    SendChatMessage("Random Rolling".." "..link, "RAID_WARNING")
  end
  GiveMasterLoot(item, id);
end

local function GiveLoot(name)
  local item = LootFrame.selectedSlot
  local id = GetMLID(name)
  GiveMasterLoot(item, id);
end

local function GiveToSelf()
  local item = LootFrame.selectedSlot
  for id = 1, GetNumRaidMembers() do
    if (GetMasterLootCandidate(id) == UnitName("player")) then
      GiveMasterLoot(item, id);
    end
   end
end

local function IsMasterLootOn()
  local method = GetLootMethod()
  if method == 'master' then
    return true
  end
  return false
end

local function BuildRaidMenu()

  if UIDROPDOWNMENU_MENU_LEVEL == 1 then
      local title = {};
      title.isTitle = true
      title.notCheckable = true
      title.text = "Give Loot To"
      UIDropDownMenu_AddButton(title);

      local me = {};
      me.text = "Me"
      me.disabled = false
      me.isTitle = false
      me.notCheckable = true
      me.func = GiveToSelf
      UIDropDownMenu_AddButton(me, UIDROPDOWNMENU_MENU_LEVEL);

      local random = {};
      random.text = "Random"
      random.disabled = false
      random.isTitle = false
      random.notCheckable = true
      random.func = GiveToRandom
      UIDropDownMenu_AddButton(random, UIDROPDOWNMENU_MENU_LEVEL);  

      local separator = {};
      separator.text = ""
      separator.disabled = true
      UIDropDownMenu_AddButton(separator);

      local Warriors = {}
      Warriors.text = MLC.classColors['warrior'].c .. 'Warriors'
      Warriors.notCheckable = true
      Warriors.hasArrow = true
      Warriors.value = {
          ['key'] = 'warrior'
      }
      if next(MLC.raid['warrior']) ~= nil then
        UIDropDownMenu_AddButton(Warriors, UIDROPDOWNMENU_MENU_LEVEL);
      end

      local Druids = {}
      Druids.text = MLC.classColors['druid'].c .. 'Druids'
      Druids.notCheckable = true
      Druids.hasArrow = true
      Druids.value = {
          ['key'] = 'druid'
      }
      if next(MLC.raid['druid']) ~= nil then
        UIDropDownMenu_AddButton(Druids, UIDROPDOWNMENU_MENU_LEVEL);
      end

      local Paladins = {}
      Paladins.text = MLC.classColors['paladin'].c .. 'Paladins'
      Paladins.notCheckable = true
      Paladins.hasArrow = true
      Paladins.value = {
          ['key'] = 'paladin'
      }
      if next(MLC.raid['paladin']) ~= nil then
        UIDropDownMenu_AddButton(Paladins, UIDROPDOWNMENU_MENU_LEVEL);
      end

      local Warlocks = {}
      Warlocks.text = MLC.classColors['warlock'].c .. 'Warlocks'
      Warlocks.notCheckable = true
      Warlocks.hasArrow = true
      Warlocks.value = {
          ['key'] = 'warlock'
      }
      if next(MLC.raid['warlock']) ~= nil then
        UIDropDownMenu_AddButton(Warlocks, UIDROPDOWNMENU_MENU_LEVEL);
      end

      local Mages = {}
      Mages.text = MLC.classColors['mage'].c .. 'Mages'
      Mages.notCheckable = true
      Mages.hasArrow = true
      Mages.value = {
          ['key'] = 'mage'
      }
      if next(MLC.raid['mage']) ~= nil then
        UIDropDownMenu_AddButton(Mages, UIDROPDOWNMENU_MENU_LEVEL);
      end

      local Priests = {}
      Priests.text = MLC.classColors['priest'].c .. 'Priests'
      Priests.notCheckable = true
      Priests.hasArrow = true
      Priests.value = {
          ['key'] = 'priest'
      }
      if next(MLC.raid['priest']) ~= nil then
        UIDropDownMenu_AddButton(Priests, UIDROPDOWNMENU_MENU_LEVEL);
      end

      local Rogues = {}
      Rogues.text = MLC.classColors['rogue'].c .. 'Rogues'
      Rogues.notCheckable = true
      Rogues.hasArrow = true
      Rogues.value = {
          ['key'] = 'rogue'
      }
      if next(MLC.raid['rogue']) ~= nil then
        UIDropDownMenu_AddButton(Rogues, UIDROPDOWNMENU_MENU_LEVEL);
      end

      local Hunters = {}
      Hunters.text = MLC.classColors['hunter'].c .. 'Hunters'
      Hunters.notCheckable = true
      Hunters.hasArrow = true
      Hunters.value = {
          ['key'] = 'hunter'
      }
      if next(MLC.raid['hunter']) ~= nil then
        UIDropDownMenu_AddButton(Hunters, UIDROPDOWNMENU_MENU_LEVEL);
      end

      local Shamans = {}
      Shamans.text = MLC.classColors['shaman'].c .. 'Shamans'
      Shamans.notCheckable = true
      Shamans.hasArrow = true
      Shamans.value = {
          ['key'] = 'shaman'
      }
      if next(MLC.raid['shaman']) ~= nil then
        UIDropDownMenu_AddButton(Shamans, UIDROPDOWNMENU_MENU_LEVEL);
      end
  end
  if UIDROPDOWNMENU_MENU_LEVEL == 2 then

      for i, player in next, MLC.raid[UIDROPDOWNMENU_MENU_VALUE['key']] do
          local Players = {}
          local color = MLC.classColors[UIDROPDOWNMENU_MENU_VALUE['key']].c
          Players.text = color .. player
          Players.notCheckable = false
          Players.hasArrow = false
          Players.func = GiveLoot
          Players.arg1 = player
          UIDropDownMenu_AddButton(Players, UIDROPDOWNMENU_MENU_LEVEL);
      end
  end
end

MLC:SetScript("OnEvent", function()
  if event then
    if event == "ADDON_LOADED" and arg1 == "MLC" then
      DEFAULT_CHAT_FRAME:AddMessage("<MLC> loaded")
      MLC.fillRaidData()
    end
    if IsMasterLootOn() and UnitInRaid("player") then
      if event == "RAID_ROSTER_UPDATE" or event == "UPDATE_MASTER_LOOT_LIST" then
          MLC.fillRaidData()
      end
      if event == "OPEN_MASTER_LOOT_LIST" then
        MLC.fillRaidData();
        UIDropDownMenu_Initialize(RaidDropDown, BuildRaidMenu, "MENU");
        ToggleDropDownMenu(1, nil, RaidDropDown, "cursor", 0, 0)
      end
      if event == "LOOT_SLOT_CLEARED" then
        CloseDropDownMenus()
      end
    end
  end
end)