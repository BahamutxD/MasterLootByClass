local MLC = CreateFrame("Frame")
local RaidDropDown = CreateFrame('Frame', 'RaidDropDown', UIParent, 'UIDropDownMenuTemplate')

MLC:RegisterEvent("ADDON_LOADED")
MLC:RegisterEvent("OPEN_MASTER_LOOT_LIST")
MLC:RegisterEvent("UPDATE_MASTER_LOOT_LIST")
MLC:RegisterEvent("RAID_ROSTER_UPDATE")
MLC:RegisterEvent("LOOT_SLOT_CLEARED")
MLC:RegisterEvent("LOOT_BIND_CONFIRM")

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

MLC.classes = {
  ['Warriors'] = 'warrior',
  ['Paladins'] = 'paladin',
  ['Druids'] = 'druid',
  ['Warlocks'] = 'warlock',
  ['Mages'] = 'mage',
  ['Priests'] = 'priest',
  ['Rogues'] = 'rogue',
  ['Shamans'] = 'shaman',
  ['Hunters'] = 'hunter',
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

local function GiveLoot(name)
  local li = LootFrame.selectedSlot
  local ci = GetMLID(name)
  GiveMasterLoot(li, ci);
end

local function CloseMenu()
  if getglobal('RaidDropDown'):IsVisible() then
    ToggleDropDownMenu(1, nil, getglobal('RaidDropDown'), "cursor", 0, 0)
  end
end

function BuildRaidMenu()

  if UIDROPDOWNMENU_MENU_LEVEL == 1 then
      local Warriors = {}
      Warriors.text = MLC.classColors['warrior'].c .. 'Warriors'
      Warriors.notCheckable = true
      Warriors.hasArrow = true
      Warriors.value = {
          ['key'] = 'warrior'
      }
      UIDropDownMenu_AddButton(Warriors, UIDROPDOWNMENU_MENU_LEVEL);

      local Druids = {}
      Druids.text = MLC.classColors['druid'].c .. 'Druids'
      Druids.notCheckable = true
      Druids.hasArrow = true
      Druids.value = {
          ['key'] = 'druid'
      }
      UIDropDownMenu_AddButton(Druids, UIDROPDOWNMENU_MENU_LEVEL);

      local Paladins = {}
      Paladins.text = MLC.classColors['paladin'].c .. 'Paladins'
      Paladins.notCheckable = true
      Paladins.hasArrow = true
      Paladins.value = {
          ['key'] = 'paladin'
      }
      UIDropDownMenu_AddButton(Paladins, UIDROPDOWNMENU_MENU_LEVEL);

      local Warlocks = {}
      Warlocks.text = MLC.classColors['warlock'].c .. 'Warlocks'
      Warlocks.notCheckable = true
      Warlocks.hasArrow = true
      Warlocks.value = {
          ['key'] = 'warlock'
      }
      UIDropDownMenu_AddButton(Warlocks, UIDROPDOWNMENU_MENU_LEVEL);

      local Mages = {}
      Mages.text = MLC.classColors['mage'].c .. 'Mages'
      Mages.notCheckable = true
      Mages.hasArrow = true
      Mages.value = {
          ['key'] = 'mage'
      }
      UIDropDownMenu_AddButton(Mages, UIDROPDOWNMENU_MENU_LEVEL);

      local Priests = {}
      Priests.text = MLC.classColors['priest'].c .. 'Priests'
      Priests.notCheckable = true
      Priests.hasArrow = true
      Priests.value = {
          ['key'] = 'priest'
      }
      UIDropDownMenu_AddButton(Priests, UIDROPDOWNMENU_MENU_LEVEL);

      local Rogues = {}
      Rogues.text = MLC.classColors['rogue'].c .. 'Rogues'
      Rogues.notCheckable = true
      Rogues.hasArrow = true
      Rogues.value = {
          ['key'] = 'rogue'
      }
      UIDropDownMenu_AddButton(Rogues, UIDROPDOWNMENU_MENU_LEVEL);

      local Hunters = {}
      Hunters.text = MLC.classColors['hunter'].c .. 'Hunters'
      Hunters.notCheckable = true
      Hunters.hasArrow = true
      Hunters.value = {
          ['key'] = 'hunter'
      }
      UIDropDownMenu_AddButton(Hunters, UIDROPDOWNMENU_MENU_LEVEL);

      local Shamans = {}
      Shamans.text = MLC.classColors['shaman'].c .. 'Shamans'
      Shamans.notCheckable = true
      Shamans.hasArrow = true
      Shamans.value = {
          ['key'] = 'shaman'
      }
      UIDropDownMenu_AddButton(Shamans, UIDROPDOWNMENU_MENU_LEVEL);

  end
  if UIDROPDOWNMENU_MENU_LEVEL == 2 then

      for i, player in next, MLC.raid[UIDROPDOWNMENU_MENU_VALUE['key']] do
          local Players = {}
          local color = MLC.classColors[UIDROPDOWNMENU_MENU_VALUE['key']].c
          Players.text = color .. player
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
      if event == "RAID_ROSTER_UPDATE" then
          MLC.fillRaidData()
      end
      if event == "OPEN_MASTER_LOOT_LIST" and UnitInRaid("player") then
        UIDropDownMenu_Initialize(RaidDropDown, BuildRaidMenu, "MENU");
        ToggleDropDownMenu(1, nil, RaidDropDown, "cursor", 0, 0)
        if event == "LOOT_BIND_CONFIRM" then
          StaticPopup1Button1:Click()
        end
        if event == "LOOT_SLOT_CLEARED" then
          CloseMenu()
        end
      end
  end
end)