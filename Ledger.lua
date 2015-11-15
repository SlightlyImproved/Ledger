-- Ledger 1.2.0 Nov 14 2015 21:38:14 GMT
-- More on https://github.com/haggen/Ledger

local Ledger = ZO_SortFilterList:Subclass()

--
--
--

LEDGER_WINDOW_WIDTH = 800
LEDGER_WINDOW_HEIGHT = 460
LEDGER_ROW_HEIGHT = 32
LEDGER_ROW_DATA = 1

local DEFAULT_CACHE = {
  version = 2,
  width = LEDGER_WINDOW_WIDTH,
  height = LEDGER_WINDOW_HEIGHT,
  offsetX = (GuiRoot:GetWidth() - LEDGER_WINDOW_WIDTH) / 2,
  offsetY = (GuiRoot:GetHeight() - LEDGER_WINDOW_HEIGHT) / 2,
  isHidden = false,
  language = GetCVar("Language.2"),
  filters = {
    timeFrame = 1,
    character = 1,
  },
  characters = {},
  data = {},
}

local SORT_KEYS = {
  timestamp = {
    isNumeric = true
  },
  character = {
    caseInsensitive = true,
    tiebreaker = "timestamp",
  },
  reason = {
    caseInsensitive = true,
    tiebreaker = "timestamp",
  },
  variation = {
    isNumeric = true,
    tiebreaker = "timestamp",
  },
  balance = {
    isNumeric = true,
    tiebreaker = "timestamp",
  },
}

local TIME_FRAME_FILTER_OPTIONS = {
  [1] = {
    label = GetString(SI_LEDGER_TIME_FRAME_1_DAY),
    value = 3600 * 24 * 1
  },
  [2] = {
    label = GetString(SI_LEDGER_TIME_FRAME_1_WEEK),
    value = 3600 * 24 * 7
  },
  [3] = {
    label = GetString(SI_LEDGER_TIME_FRAME_1_MONTH),
    value = 3600 * 24 * 30
  },
}

local CHARACTER_FILTER_OPTIONS = {
  [1] = {
    label = GetString(SI_LEDGER_ALL_CHARACTERS),
    value = false
  }
}

--
--
--

function Ledger:New(control)
  local manager = ZO_SortFilterList.New(self, control)

  ZO_ScrollList_AddDataType(manager.list, LEDGER_ROW_DATA, "LedgerRow", LEDGER_ROW_HEIGHT, function(...) manager:SetupRow(...) end)

  manager:SetAlternateRowBackgrounds(true)

  manager.sortHeaderGroup:SelectHeaderByKey("timestamp")
  manager.sortHeaderGroup:SelectHeaderByKey("timestamp")

  manager.timeFrameComboBox = manager:SetupComboBox("FiltersTimeFrame")
  manager.characterComboBox = manager:SetupComboBox("FiltersCharacter")

  LEDGER_FRAGMENT = ZO_HUDFadeSceneFragment:New(control, DEFAULT_HUD_DURATION, 50)

  HUD_SCENE:AddFragment(LEDGER_FRAGMENT)
  HUD_UI_SCENE:AddFragment(LEDGER_FRAGMENT)

  SLASH_COMMANDS["/ledger"] = function() manager:Toggle() end

  local function OnAddOnLoaded(e, name)
    if name ~= "Ledger" then return end

    LEDGER_CACHE = ZO_SavedVars:NewAccountWide("LedgerCache", DEFAULT_CACHE.version, nil, DEFAULT_CACHE)

    LEDGER_FRAGMENT:SetHiddenForReason("isHidden", LEDGER_CACHE.isHidden)

    if LEDGER_CACHE.isHidden then
      LEDGER_FRAGMENT:Hide()
    else
    end

    if #LEDGER_CACHE.data == 0 then
      manager:SetEmptyText(GetString(SI_LEDGER_EMPTY_DATA))
    else
      manager:SetEmptyText(GetString(SI_LEDGER_EMPTY_FILTER))
    end

    if LEDGER_CACHE.settings ~= nil then
      LEDGER_CACHE.settings = nil
      LEDGER_CACHE.width = DEFAULT_CACHE.width
      LEDGER_CACHE.height = DEFAULT_CACHE.height
      LEDGER_CACHE.offsetX = DEFAULT_CACHE.offsetX
      LEDGER_CACHE.offsetY = DEFAULT_CACHE.offsetY
      LEDGER_CACHE.isHidden = DEFAULT_CACHE.isHidden
    end

    manager:RegisterCharacter(GetUnitName("player"))
    manager:UpdateFilterOptions()

    manager:Restore()
    manager:Refresh()

    control:RegisterForEvent(EVENT_MONEY_UPDATE, function(...) manager:OnMoneyUpdate(...) end)
    control:RegisterForEvent(EVENT_PLAYER_COMBAT_STATE, function(e, inCombat) if inCombat then manager:Hide() end end)
    control:UnregisterForEvent(EVENT_ADD_ON_LOADED)
  end

  control:RegisterForEvent(EVENT_ADD_ON_LOADED, OnAddOnLoaded)

  return manager
end

function Ledger:SetupComboBox(name)
  local comboBox = ZO_ComboBox_ObjectFromContainer(GetControl(self.control, name))
  comboBox:SetSortsItems(false)
  comboBox:SetFont("LedgerRowFont")
  comboBox:SetSpacing(2)
  return comboBox
end

function Ledger:RegisterCharacter(name)
  for i = 1, #LEDGER_CACHE.characters do
    if LEDGER_CACHE.characters[i] == name then
      name = nil
    end
  end

  if name then table.insert(LEDGER_CACHE.characters, name) end
end

function Ledger:UpdateFilterOptions()
  for i = 1, #LEDGER_CACHE.characters do
    table.insert(CHARACTER_FILTER_OPTIONS, {
      label = LEDGER_CACHE.characters[i],
      value = LEDGER_CACHE.characters[i],
    })
  end

  for index, option in ipairs(TIME_FRAME_FILTER_OPTIONS) do
    d(index, option)
    local callback = function() self:UpdateFilter("timeFrame", index) end
    self.timeFrameComboBox:AddItem(self.timeFrameComboBox:CreateItemEntry(option.label, callback))
  end

  self.timeFrameComboBox:SelectItemByIndex(LEDGER_CACHE.filters.timeFrame or 1)

  for index, option in ipairs(CHARACTER_FILTER_OPTIONS) do
    local callback = function() self:UpdateFilter("character", index) end
    self.characterComboBox:AddItem(self.characterComboBox:CreateItemEntry(option.label, callback))
  end

  self.characterComboBox:SelectItemByIndex(LEDGER_CACHE.filters.character or 1)
end

function Ledger:OnMoneyUpdate(e, balance, previously, reason)
  local entry = {}

  entry.timestamp = GetTimeStamp()
  entry.character = GetUnitName("player")
  entry.reason = reason
  entry.variation = balance - previously
  entry.balance = balance

  table.insert(LEDGER_CACHE.data, entry)

  self:Refresh()
end

function Ledger:Refresh()
  if not LEDGER_CACHE.isHidden then
    self:RefreshData()
  end
end

function Ledger:UpdateFilter(filter, index)
  LEDGER_CACHE.filters[filter] = index
  self:Refresh()
end

function Ledger:BuildMasterList()
  self.masterList = {}

  for i = 1, #LEDGER_CACHE.data do
    local t = ZO_ShallowTableCopy(LEDGER_CACHE.data[i], {})
    t.reason = GetString("SI_LEDGER_REASON", t.reason)
    table.insert(self.masterList, t)
  end
end

function Ledger:FilterScrollList()
  local scrollData = ZO_ScrollList_GetDataList(self.list)
  ZO_ClearNumericallyIndexedTable(scrollData)

  local timeFrame = GetTimeStamp() - TIME_FRAME_FILTER_OPTIONS[LEDGER_CACHE.filters.timeFrame].value
  local character = CHARACTER_FILTER_OPTIONS[LEDGER_CACHE.filters.character].value

  for i = 1, #self.masterList do
    local entry = self.masterList[i]
    local match = true

    match = match and (character == false or character == entry.character)
    match = match and entry.timestamp >= timeFrame

    if match then
      table.insert(scrollData, ZO_ScrollList_CreateDataEntry(LEDGER_ROW_DATA, entry))
    end
  end
end

function Ledger:SortScrollList()
  local scrollData = ZO_ScrollList_GetDataList(self.list)
  table.sort(scrollData, function(a, b) return self:CompareRows(a, b) end)
end

function Ledger:CompareRows(a, b)
  return ZO_TableOrderingFunction(a.data, b.data, self.currentSortKey, SORT_KEYS, self.currentSortOrder)
end

function Ledger:GetRowColors(data, mouseIsOver, control)
  return ZO_ColorDef:New(1, 1, 1, 1)
end

function Ledger:SetupRow(control, data)
  ZO_SortFilterList.SetupRow(self, control, data)

  local formattedDateTime = L10n_GetLocalizedDateTime(data.timestamp, LEDGER_CACHE.language)
  local sign, hue = ""

  if data.variation >= 0 then
    sign, hue = "+", ZO_ColorDef:New(0.25, 0.95, 0.85, 1)
  else
    hue = ZO_ColorDef:New(0.95, 0.25, 0.35, 1)
  end

  GetControl(control, "Timestamp"):SetText(formattedDateTime)
  GetControl(control, "Character"):SetText(data.character)
  GetControl(control, "Reason"):SetText(data.reason)
  GetControl(control, "Variation"):SetText(sign .. ZO_CurrencyControl_FormatCurrency(data.variation))
  GetControl(control, "Variation"):SetColor(hue:UnpackRGBA())
  GetControl(control, "Balance"):SetText(ZO_CurrencyControl_FormatCurrency(data.balance))
end

function Ledger:Toggle()
  if LEDGER_CACHE.isHidden then
    self:Show()
  else
    self:Hide()
  end
end

function Ledger:Show()
  LEDGER_CACHE.isHidden = false
  LEDGER_FRAGMENT:SetHiddenForReason("isHidden", false)

  if not IsGameCameraUIModeActive() then
    SetGameCameraUIMode(true)
  end
end

function Ledger:Hide()
  LEDGER_CACHE.isHidden = true
  LEDGER_FRAGMENT:SetHiddenForReason("isHidden", true)
end

function Ledger:Restore()
  self.control:ClearAnchors()
  self.control:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LEDGER_CACHE.offsetX, LEDGER_CACHE.offsetY)
  self.control:SetDimensions(LEDGER_CACHE.width, LEDGER_CACHE.height)
end

function Ledger:Save()
  LEDGER_CACHE.offsetX = self.control:GetLeft()
  LEDGER_CACHE.offsetY = self.control:GetTop()
  LEDGER_CACHE.width = self.control:GetWidth()
  LEDGER_CACHE.height = self.control:GetHeight()
end

--
--
--

function Ledger_OnInitialized(control)
  LEDGER = Ledger:New(control)
end

function LedgerClose_OnMouseUp(control)
  LEDGER:Toggle()
end

function Ledger_OnShow()
  LEDGER:Refresh()
end

function Ledger_OnMoveStop()
  LEDGER:Save()
end

function Ledger_OnResizeStop()
  LEDGER:Save()
  LEDGER:Refresh()
end
