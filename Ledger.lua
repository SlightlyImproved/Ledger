-- Ledger 1.0.1 Thu Sep 03 20:20:52 BRT 2015
-- More on https://github.com/haggen/Ledger

function table.find(t, fn)
  for k, v in pairs(t) do
    if fn(k, v) then return k, v end
  end
end

function table.filter(t, fn)
  local ft = {}

  for k, v in pairs(t) do
    local m, x = fn(k, v, ft)

    if m then table.insert(ft, v) end
    if x then break end
  end

  return ft
end

function table.map(t, fn)
  local mt = {}

  for k, v in pairs(t) do
    mt[k] = fn(k, v, mt)
  end

  return mt
end

function table.group(t, fn)
  local gt = {}

  for k, v in pairs(t) do
    local gk = fn(k, v, gt)

    if gt[gk] then
      table.insert(gt[gk], v)
    else
      gt[gk] = {v}
    end
  end

  return gt
end

function table.reduce(t, n, fn)
  for k, v in pairs(t) do
    n = fn(k, v, n, t)
  end

  return n
end

--
--
--

local Ledger = ZO_SortFilterList:Subclass()

--
--
--

LEDGER_WIDTH      = 800
LEDGER_HEIGHT     = 320
LEDGER_ROW_HEIGHT = 32

local settings = {
  w        = LEDGER_WIDTH,
  h        = LEDGER_HEIGHT,
  x        = (GuiRoot:GetWidth() - LEDGER_WIDTH) / 2,
  y        = (GuiRoot:GetHeight() - LEDGER_HEIGHT) / 2,
  hidden   = false,
  language = GetCVar("Language.2"),
}

Ledger.defaultCache = {
  version    = 2,
  settings   = settings,
  filters    = {},
  characters = {},
  data       = {},
}

Ledger.sortableKeys = {
  timestamp = { isNumeric = true },
  character = { tiebreaker = "timestamp", caseInsensitive = true },
  reason    = { tiebreaker = "timestamp", caseInsensitive = true },
  variation = { tiebreaker = "timestamp", isNumeric = true },
  balance   = { tiebreaker = "timestamp", isNumeric = true },
}

Ledger.filterOptions = {
  timeFrame = {
    [1] = 3600 * 24,
    [2] = 3600 * 24 * 7,
    [3] = 3600 * 24 * 30,
  },
  character = {
    [1] = false
  },
}

--
--
--

function Ledger:New(control)
  local this = ZO_SortFilterList.New(self, control)

  ZO_ScrollList_AddDataType(this.list, 1, "LedgerRow", LEDGER_ROW_HEIGHT, function(...) this:SetupRow(...) end)
  ZO_ScrollList_EnableHighlight(this.list, "ZO_ThinListHighlight")

  this:SetAlternateRowBackgrounds(true)
  this:SetEmptyText(GetString(SI_LEDGER_EMPTY))

  this.timeFrameComboBox = ZO_ComboBox_ObjectFromContainer(GetControl(control, "FiltersTimeFrame"))
  this.timeFrameComboBox:SetSortsItems(false)
  this.timeFrameComboBox:SetFont("LedgerRowFont")
  this.timeFrameComboBox:SetSpacing(2)

  this.characterComboBox = ZO_ComboBox_ObjectFromContainer(GetControl(control, "FiltersCharacter"))
  this.characterComboBox:SetSortsItems(false)
  this.characterComboBox:SetFont("LedgerRowFont")
  this.characterComboBox:SetSpacing(2)

  local setup = function(e, name) this:Loaded(name) end
  control:RegisterForEvent(EVENT_ADD_ON_LOADED, setup)

  return this
end

function Ledger:Loaded(name)
  if name ~= "Ledger" then return end

  self.cache = ZO_SavedVars:NewAccountWide("LedgerCache", self.defaultCache.version, nil, self.defaultCache)

  self:PreventRefresh()

  local name = GetUnitName("player")

  if not table.find(self.cache.characters, function(_, n) return n == name end) then
    table.insert(self.cache.characters, name)
  end

  for _, name in ipairs(self.cache.characters) do
    table.insert(self.filterOptions.character, name)
  end

  for i, value in ipairs(self.filterOptions.timeFrame) do
    local name = GetString("SI_LEDGER_TIME_FRAME_OPTION", i)
    local callback = function() self:UpdateFilter("timeFrame", i) end
    self.timeFrameComboBox:AddItem(self.timeFrameComboBox:CreateItemEntry(name, callback))
  end
  self.timeFrameComboBox:SelectItemByIndex(self.cache.filters.timeFrame or 1)

  for i, value in ipairs(self.filterOptions.character) do
    local name = i > 1 and value or GetString("SI_LEDGER_CHARACTER_OPTION", i)
    local callback = function() self:UpdateFilter("character", i) end
    self.characterComboBox:AddItem(self.characterComboBox:CreateItemEntry(name, callback))
  end
  self.characterComboBox:SelectItemByIndex(self.cache.filters.timeFrame or 1)

  self.currentSortOrder = ZO_SORT_ORDER_DOWN
  self.sortHeaderGroup:SelectHeaderByKey("timestamp", ZO_SortHeaderGroup.SUPPRESS_CALLBACKS)

  self.control:RegisterForEvent(EVENT_MONEY_UPDATE, function(...) self:Update(...) end)
  self.control:UnregisterForEvent(EVENT_ADD_ON_LOADED)

  SLASH_COMMANDS["/ledger"] = function() this:Toggle() end

  self:AllowRefresh()
  self:Restore()
  self:Refresh()
end

function Ledger:Update(e, balance, previously, reason)
  local entry = {}

  entry.timestamp = GetTimeStamp()
  entry.character = GetUnitName("player")
  entry.reason = reason
  entry.variation = balance - previously
  entry.balance = balance

  table.insert(self.cache.data, entry)

  self:Refresh()
end

function Ledger:PreventRefresh()
  self.preventRefresh = true
end

function Ledger:AllowRefresh()
  self.preventRefresh = nil
end

function Ledger:Refresh()
  if self.preventRefresh then return end
  if self.control:IsHidden() then return end

  self:RefreshData()
end

function Ledger:UpdateFilter(filter, value)
  self.cache.filters[filter] = value
  self:Refresh()
end

function Ledger:BuildMasterList()
  self.masterList = {}

  for i = 1, #self.cache.data do
    local t = ZO_ShallowTableCopy(self.cache.data[i], {})
    t.reason = GetString("SI_LEDGER_REASON", t.reason)
    table.insert(self.masterList, t)
  end
end

function Ledger:FilterScrollList()
  local scrollData = ZO_ScrollList_GetDataList(self.list)
  ZO_ClearNumericallyIndexedTable(scrollData)

  local timeFrame = GetTimeStamp() - self.filterOptions.timeFrame[self.cache.filters.timeFrame]
  local character = self.filterOptions.character[self.cache.filters.character]

  for i = 1, #self.masterList do
    local entry = self.masterList[i]
    local match = true

    match = match and (character == false or character == entry.character)
    match = match and entry.timestamp >= timeFrame

    if match then
      table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, entry))
    end
  end
end

function Ledger:SortScrollList()
  local scrollData = ZO_ScrollList_GetDataList(self.list)
  table.sort(scrollData, function(a, b) return self:CompareRows(a, b) end)
end

function Ledger:CompareRows(a, b)
  return ZO_TableOrderingFunction(a.data, b.data, self.currentSortKey, self.sortableKeys, self.currentSortOrder)
end

function Ledger:GetRowColors(data, mouseIsOver, control)
  return ZO_ColorDef:New(1, 1, 1, 1)
end

function Ledger:SetupRow(control, data)
  ZO_SortFilterList.SetupRow(self, control, data)

  local formattedDateTime = L10n_GetLocalizedDateTime(data.timestamp, self.cache.settings.language)
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
  self.control:ToggleHidden()
  self.cache.settings.hidden = self.control:IsHidden()
end

function Ledger:Restore()
  self.control:ClearAnchors()
  self.control:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, self.cache.settings.x, self.cache.settings.y)
  self.control:SetDimensions(self.cache.settings.w, self.cache.settings.h)
  self.control:SetHidden(self.cache.settings.hidden)
end

function Ledger:Save()
  self.cache.settings.x = self.control:GetLeft()
  self.cache.settings.y = self.control:GetTop()
  self.cache.settings.w = self.control:GetWidth()
  self.cache.settings.h = self.control:GetHeight()
  self.cache.settings.hidden = self.control:IsHidden()
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

  ZO_ScrollList_SetHeight(LEDGER.list, LEDGER.list:GetHeight())
  ZO_ScrollList_Commit(LEDGER.list)
end
