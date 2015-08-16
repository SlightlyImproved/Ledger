
-- Ledger 0.0.1 Fri Aug 14 17:33:21 BRT 2015
-- more on https://github.com/haggen/Ledger
local Ledger = ZO_SortFilterList:Subclass()

-- Default window settings
local DEFAULT_SETTINGS = {
  w = 520, h = 300, x = 0, y = 0, hidden = false
}

-- Cache format version
local CACHE_VERSION = 2

-- Default cache table
local CACHE_DEFAULTS = {
  settings = DEFAULT_SETTINGS,
  spreadsheet = {},
  characters = {},
}

-- List configuration
local DEFAULT_SORT_KEY = "timestamp"
local DEFAULT_SORT_ORDER = ZO_SORT_ORDER_DOWN
local ROW_HEIGHT = 28
local LEDGER_DATA = 1

-- Sortable keys
local SORT_KEYS = {
  timestamp = { isNumeric = true },
  character = { tiebreaker = "timestamp", caseInsensitive = true },
  reason    = { tiebreaker = "timestamp", caseInsensitive = true },
  variation = { tiebreaker = "timestamp", isNumeric = true },
  balance   = { tiebreaker = "timestamp", isNumeric = true },
}

-- Credits to `votan` http://www.esoui.com/forums/member.php?u=13996
function GetTimeZone()
  local localTimeShift = GetSecondsSinceMidnight() - (GetTimeStamp() % 86400)
  if localTimeShift < -43200 then localTimeShift = localTimeShift + 86400 end
  return localTimeShift
end

function FixCacheVersion1To2(cache2)
  local cache1 = ZO_SavedVars:New("LedgerCache", 1, nil, {})
  if not cache1["sheet"] then return end

  for i = 1, #cache1.sheet do
    local t = cache1.sheet[i]
    local n = {}

    n.variation = t.amount - t.previousAmount
    n.balance = t.amount
    n.reason = t.reason
    n.timestamp = t.timestamp
    n.character = GetUnitName("player")

    table.insert(cache2.spreadsheet, n)
  end

  ZO_ShallowTableCopy(cache1.ui, cache2.settings)
end

function Ledger:New(control)
  local this = ZO_SortFilterList.New(self, control)

  this:SetAlternateRowBackgrounds(true)
  ZO_ScrollList_AddDataType(this.list, LEDGER_DATA, "LedgerRow", ROW_HEIGHT, function(...) this:SetupRow(...) end)

  local function OnAddOnLoaded(e, name)
    if name ~= "Ledger" then
      this.cache = ZO_SavedVars:NewAccountWide("LedgerCache", CACHE_VERSION, nil, CACHE_DEFAULTS)

      FixCacheVersion1To2(this.cache)

      this.settings = this.cache.settings
      this.spreadsheet = this.cache.spreadsheet
      this.isDirty = true

      this:Restore()
      this:Refresh()
    end
  end

  local function OnMoneyUpdate(e, balance, previously, reason)
    local entry = {}

    entry.timestamp = GetTimeStamp()
    entry.character = GetUnitName("player")
    entry.reason = reason
    entry.variation = balance - previously
    entry.balance = balance

    table.insert(this.spreadsheet, entry)
    this.isDirty = true
  end

  this.control:RegisterForEvent(EVENT_ADD_ON_LOADED, OnAddOnLoaded)
  this.control:RegisterForEvent(EVENT_MONEY_UPDATE, OnMoneyUpdate)

  return this
end

function Ledger:Refresh()
  if self.isDirty then
    self:RefreshData()
  end
end

function Ledger:BuildMasterList()
  self.isDirty = false
  self.masterList = {}

  for i = 1, self.spreadsheet do
    local t = ZO_ShallowTableCopy(self.spreadsheet[i], {})
    t.reason = GetString("SI_LEDGER_REASON", t.reason)
    table.insert(self.masterList, t)
  end
end

function Ledger:FilterScrollList()
  local scrollData = ZO_ScrollList_GetDataList(self.list)
  ZO_ClearNumericallyIndexedTable(scrollData)

  for i = 1, #self.masterList do
    table.insert(scrollData, ZO_ScrollList_CreateDataEntry(LEDGER_DATA, self.masterList[i]))
  end
end

function Ledger:SortScrollList()
  local scrollData = ZO_ScrollList_GetDataList(self.list)
  table.sort(scrollData, function(...) self:CompareRows(...) end)
end

function Ledger:SetupRow(control, data)
  ZO_SortFilterList.SetupRow(self, control, data)

  -- TODO: format 24h and adjust to timezone
  local timestamp = GetDateStringFromTimestamp(data.timestamp) .. " " .. FormatTimeSeconds(data.timestamp, TIME_FORMAT_STYLE_CLOCK_TIME)
  local hue = data.variation > 0 and { 0.15, 0.85, .35, 1 } or { 0.85, 0.15, 0.35, 1 }

  GetControl(control, "Timestamp"):SetText(timestamp)
  GetControl(control, "Character"):SetText(data.character)
  GetControl(control, "Reason"):SetText(data.reason)
  GetControl(control, "Balance"):SetText(ZO_CurrencyControl_FormatCurrency(data.balance))

  GetControl(control, "Variation"):SetText(ZO_CurrencyControl_FormatCurrency(data.variation))
  GetControl(control, "Variation"):SetColor(unpack(hue))
end

function Ledger:CompareRows(a, b)
  return ZO_TableOrderingFunction(a.data, b.data, self.currentSortKey or DEFAULT_SORT_KEY, SORT_KEYS, self.currentSortOrder or DEFAULT_SORT_ORDER)
end

function Ledger:ChangeSheet(name)
  self.cache.lastSheet = name
  self.currentSheet = name
  self.isDirty = true
end

function Ledger:Toggle()
  self.control:ToggleHidden()
end

function Ledger:Restore()
  self.control:ClearAnchors()
  self.control:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, self.settings.x, self.settings.y)
  self.control:SetDimensions(self.settings.w, self.settings.h)
  self.control:SetHidden(self.settings.hidden)
end

function Ledger:Save()
  self.settings.x = self.control:GetLeft()
  self.settings.y = self.control:GetTop()
  self.settings.w = self.control:GetWidth()
  self.settings.h = self.control:GetHeight()
  self.settings.hidden = self.control:IsHidden()
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

function Ledger_OnMoveStop()
  LEDGER:Save()
end

function Ledger_OnResizeStop()
  LEDGER:Save()
  LEDGER:Refresh()
end
