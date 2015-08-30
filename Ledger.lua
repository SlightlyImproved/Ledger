-- Ledger 0.2.0 Sun Aug 30 02:11:24 BRT 2015
-- more on https://github.com/haggen/Ledger

local SETTINGS = {
  w = 720,
  h = 340,
  x = (GuiRoot:GetWidth() - 720) / 2,
  y = (GuiRoot:GetHeight() - 340) / 2,
  hidden = false,
  language = GetCVar("Language.2"),
}

local CACHE = {
  version     = 2,
  settings    = SETTINGS,
  records     = {},
  filters     = {},
  characters  = {},
}

local SORTABLE_KEYS = {
  timestamp = { isNumeric = true },
  character = { tiebreaker = "timestamp", caseInsensitive = true },
  reason    = { tiebreaker = "timestamp", caseInsensitive = true },
  variation = { tiebreaker = "timestamp", isNumeric = true },
  balance   = { tiebreaker = "timestamp", isNumeric = true },
}

local function CreateStrings(language)
  if langauge == "de" then
    Ledger_CreateGermanStrings()
  else
    Ledger_CreateEnglishStrings()
  end
end

CreateStrings(CACHE.langauge)

--
--
--

local Ledger = ZO_SortFilterList:Subclass()

function Ledger:New(control)
  local this = ZO_SortFilterList.New(self, control)

  ZO_ScrollList_AddDataType(this.list, 1, "LedgerRow", LedgerRow:GetHeight(), function(...) this:SetupRow(...) end)
  ZO_ScrollList_EnableHighlight(this.list, "ZO_ThinListHighlight")

  this:SetAlternateRowBackgrounds(true)
  this:SetEmptyText(GetString(SI_LEDGER_EMPTY_TEXT))

  local setup = function(e, name) this:Setup(name) end
  this.control:RegisterForEvent(EVENT_ADD_ON_LOADED, setup)

  return this
end

function Ledger:Setup(name)
  if name ~= "Ledger" then return end

  self.cache = ZO_SavedVars:NewAccountWide("LedgerCache", CACHE.version, nil, CACHE)

  -- Remove when it's safe to assume that everybody upgraded.
  if self.cache.spreadsheet ~= nil then
    self.cache.records = self.cache.spreadsheet
    self.cache.spreadsheet = nil
  end

  local name = GetUnitName("player")
  local fn = function(_, v) return v == name end
  if Breton_Find(self.cache.characters, fn) == false then
    table.insert(self.cache.characters, name)
  end

  self.sortHeaderGroup:SelectHeaderByKey("timestamp", ZO_SortHeaderGroup.SUPPRESS_CALLBACKS)

  self.control:RegisterForEvent(EVENT_MONEY_UPDATE, function(...) self:Update(...) end)
  self.control:UnregisterForEvent(EVENT_ADD_ON_LOADED)

  SLASH_COMMANDS["/ledger"] = function() this:Toggle() end

  self:Restore()
end

function Ledger:Update(e, balance, previously, reason)
  local entry = {}

  entry.timestamp = GetTimeStamp()
  entry.character = GetUnitName("player")
  entry.reason = reason
  entry.variation = balance - previously
  entry.balance = balance

  table.insert(self.records, entry)

  self:Refresh()
end

function Ledger:Refresh()
  if not self.control:IsHidden() then
    self:RefreshData()
  end
end

function Ledger:BuildMasterList()
  self.masterList = {}

  for i = 1, #self.records do
    local t = ZO_ShallowTableCopy(self.records[i], {})
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

  local formattedDateTime = L10n_GetLocalizedDateTime(data.timestamp, self.cache.settings.language)
  local hue = (data.variation > 0) and ZO_ColorDef:New(0.15, 0.85, .35, 1) or ZO_ColorDef:New(0.85, 0.15, 0.35, 1)

  GetControl(control, "Timestamp"):SetText(formattedDateTime)
  GetControl(control, "Character"):SetText(data.character)
  GetControl(control, "Reason"):SetText(GetString("SI_LEDGER_REASON", t.reason))
  GetControl(control, "Balance"):SetText(ZO_CurrencyControl_FormatCurrency(data.balance))
  GetControl(control, "Variation"):SetText(ZO_CurrencyControl_FormatCurrency(data.variation))
  GetControl(control, "Variation"):SetColor(hue:UnpackRGBA())
end

function Ledger:Toggle()
  self.control:ToggleHidden()
  self.settings.hidden = self.control:IsHidden()
end

function Ledger:Restore()
  CreateStrings(self.cache.language)

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

  ZO_ScrollList_SetHeight(self.list, self.list:GetHeight())
  ZO_ScrollList_Commit(self.list)
end
