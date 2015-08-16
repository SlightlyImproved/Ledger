-- Ledger 0.1.0 Fri Aug 16 15:47:21 BRT 2015
-- more on https://github.com/haggen/Ledger

-- Credits to `votan` http://www.esoui.com/forums/member.php?u=13996
local function GetTimeZone()
  local localTimeShift = GetSecondsSinceMidnight() - (GetTimeStamp() % 86400)
  if localTimeShift < -43200 then localTimeShift = localTimeShift + 86400 end
  return localTimeShift
end

local function FormatDate(timestamp, language)
  local formattedDate = GetDateStringFromTimestamp(timestamp)

  if language == "en" then
    return formattedDate
  else
    return string.gsub(formattedDate, "^(%d+)/(%d+)", "%2/%1")
  end
end

local function FormatClock(timestamp, language)
  if language == "en" then
    return ZO_FormatTime(timestamp, TIME_FORMAT_STYLE_CLOCK_TIME, TIME_FORMAT_PRECISION_TWELVE_HOUR)
  else
    return ZO_FormatTime(timestamp, TIME_FORMAT_STYLE_CLOCK_TIME, TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR)
  end
end

-- Find the index of give value in a table
function table.indexOf(t, value)
  for i, value in ipairs(t) do
    if t[i] == value then return i end
  end

  return -1
end

-- Import previous cache format data
function ImportOldSheet(newSheet)
  local oldCache = ZO_SavedVars:New("LedgerCache", 1, nil, {})
  local oldSheet = oldCache.sheet

  if oldSheet ~= nil and oldSheet.imported == nil then
    for i = 1, #oldSheet do
      local t = {}

      t.timestamp = oldSheet[i].timestamp
      t.character = GetUnitName("player")
      t.reason = oldSheet[i].reason
      t.balance = oldSheet[i].amount
      t.variation = t.balance - oldSheet[i].previousAmount

      table.insert(newSheet, t)
    end

    oldSheet.imported = GetTimeStamp()
  end
end

--
--
--

local Ledger = ZO_SortFilterList:Subclass()

-- Shared configuration for XML
LEDGER_MINIMUM_WIDTH  = 720
LEDGER_MINIMUM_HEIGHT = 300
LEDGER_ROW_HEIGHT = 28

-- Default settings
local SETTINGS = {
  w = LEDGER_MINIMUM_WIDTH,
  h = LEDGER_MINIMUM_HEIGHT,
  x = (GuiRoot:GetWidth() - LEDGER_MINIMUM_WIDTH) / 2,
  y = (GuiRoot:GetHeight() - LEDGER_MINIMUM_HEIGHT) / 2,
  hidden = false,
  language = GetCVar("Language.2")
}

-- Cache format version
local CACHE_VERSION = 2

-- Default cache table
local CACHE = {
  settings    = SETTINGS,
  spreadsheet = {},
  characters  = {},
}

-- List row height

function Ledger:New(control)
  local this = ZO_SortFilterList.New(self, control)

  this.sortableKeys = {
    timestamp = { isNumeric = true },
    character = { tiebreaker = "timestamp", caseInsensitive = true },
    reason    = { tiebreaker = "timestamp", caseInsensitive = true },
    variation = { tiebreaker = "timestamp", isNumeric = true },
    balance   = { tiebreaker = "timestamp", isNumeric = true },
  }

  this:SetAlternateRowBackgrounds(true)
  ZO_ScrollList_AddDataType(this.list, 1, "LedgerRow", LEDGER_ROW_HEIGHT, function(...) this:SetupRow(...) end)

  local handler = function(e, name) if "Ledger" == name then this:Loaded() end end
  this.control:RegisterForEvent(EVENT_ADD_ON_LOADED, handler)

  SLASH_COMMANDS["/ledger"] = function() this:Toggle() end

  return this
end

function Ledger:Loaded()
  local cache = ZO_SavedVars:NewAccountWide("LedgerCache", CACHE_VERSION, nil, CACHE)
  self.settings = cache.settings
  self.spreadsheet = cache.spreadsheet

  local character = GetUnitName("player")
  if table.indexOf(cache.characters, character) < 0 then
    table.insert(cache.characters, character)
  end

  ImportOldSheet(self.spreadsheet)

  self:Restore()
  self:Refresh()

  self.control:UnregisterForEvent(EVENT_ADD_ON_LOADED)
  self.control:RegisterForEvent(EVENT_MONEY_UPDATE, function(...) self:Update(...) end)

  self.sortHeaderGroup:SelectHeaderByKey("timestamp", false, false)
end

function Ledger:Update(e, balance, previously, reason)
  local entry = {}

  entry.timestamp = GetTimeStamp()
  entry.character = GetUnitName("player")
  entry.reason = reason
  entry.variation = balance - previously
  entry.balance = balance

  table.insert(self.spreadsheet, entry)

  self:Refresh()
end

function Ledger:Refresh()
  if not self.control:IsHidden() then
    ZO_ScrollList_SetHeight(self.list, self.list:GetHeight())
    self:RefreshData()
  end
end

function Ledger:BuildMasterList()
  self.masterList = {}

  for i = 1, #self.spreadsheet do
    local t = ZO_ShallowTableCopy(self.spreadsheet[i], {})
    t.timestamp = t.timestamp + GetTimeZone()
    t.reason = GetString("SI_LEDGER_REASON", t.reason)
    table.insert(self.masterList, t)
  end
end

function Ledger:FilterScrollList()
  local scrollData = ZO_ScrollList_GetDataList(self.list)
  ZO_ClearNumericallyIndexedTable(scrollData)

  for i = 1, #self.masterList do
    table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, self.masterList[i]))
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
  return ZO_ColorDef:New(0.9, 0.9, 0.9, 1)
end

function Ledger:SetupRow(control, data)
  ZO_SortFilterList.SetupRow(self, control, data)

  local formattedDate = FormatDate(data.timestamp, self.settings.language)
  local formattedTime = FormatClock(data.timestamp, self.settings.language)

  local hue = (data.variation > 0) and ZO_ColorDef:New(0.15, 0.85, .35, 1) or ZO_ColorDef:New(0.85, 0.15, 0.35, 1)

  GetControl(control, "Timestamp"):SetText(formattedDate .. " " .. formattedTime)
  GetControl(control, "Character"):SetText(data.character)
  GetControl(control, "Reason"):SetText(data.reason)
  GetControl(control, "Balance"):SetText(ZO_CurrencyControl_FormatCurrency(data.balance))

  GetControl(control, "Variation"):SetText(ZO_CurrencyControl_FormatCurrency(data.variation))
  GetControl(control, "Variation"):SetColor(hue:UnpackRGBA())
end

function Ledger:Toggle()
  self.control:ToggleHidden()
  self.settings.hidden = self.control:IsHidden()
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
