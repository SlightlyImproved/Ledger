
Ledger           = {}
Ledger.name      = "Ledger"
Ledger.version   = 1 -- Bump only when `cache` is changed

Ledger.cache        = {}
Ledger.cache.sheet  = {}
Ledger.cache.x      = 0
Ledger.cache.y      = 0
Ledger.cache.w      = 520
Ledger.cache.h      = 300
Ledger.cache.hidden = false

--
--
--

local function Loaded(e, name)
  if Ledger.name == name then
    Ledger:Initialize()
  end
end

local function MoneyUpdated(e, amount, previousAmount, reason)
  if Ledger.initialized then
    Ledger:Update(amount, previousAmount, reason)
  end
end

EVENT_MANAGER:RegisterForEvent(Ledger.name, EVENT_ADD_ON_LOADED, Loaded)
EVENT_MANAGER:RegisterForEvent(Ledger.name, EVENT_MONEY_UPDATE, MoneyUpdated)

SLASH_COMMANDS["/ledger"] = function(options)
  Ledger:ToggleUI()
end

--
--
--

function Ledger:Initialize()
  self.cache = ZO_SavedVars:New("LedgerCache", self.version, nil, self.cache)

  self:RestoreUI()

  self.initialized = true
end

function Ledger:SetupList()
  self.list = LedgerList:New(LedgerUI)
end

function Ledger:ToggleUI()
  LedgerUI:SetHidden(not self.cache.hidden)
  Ledger:SaveUI()
end

function Ledger:RestoreUI()
  LedgerUI:ClearAnchors()
  LedgerUI:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, self.cache.x, self.cache.y)
  LedgerUI:SetDimensions(self.cache.w, self.cache.h)
  LedgerUI:SetHidden(self.cache.hidden)
end

function Ledger:SaveUI()
  self.cache.x = LedgerUI:GetLeft()
  self.cache.y = LedgerUI:GetTop()
  self.cache.w = LedgerUI:GetWidth()
  self.cache.h = LedgerUI:GetHeight()
  self.cache.hidden = LedgerUI:IsHidden()
end

function Ledger:Update(amount, previousAmount, reason)
  local data = {}

  data.timestamp = GetTimeStamp()
  data.previousAmount = previousAmount
  data.amount = amount
  data.reason = reason

  table.insert(self.cache.sheet, data)

  self.list:RefreshData()
end

function Ledger:Reset()
  for i,_ in ipairs(self.cache.sheet) do self.cache.sheet[i] = nil end
end

--
--
--

LedgerList = ZO_SortFilterList:Subclass()

LedgerList.SORTINGS = {
  timestamp = { numeric = true },
  reason = { numeric = true, tiebreaker = "timestamp" },
  amount = { numeric = true, tiebreaker = "timestamp" },
  variation = { numeric = true },
}

function LedgerList:New(control, addon)
  local manager = ZO_SortFilterList.New(self, control)

  manager:SetAlternateRowBackgrounds(true)

  manager.sort = function(a, b) return manager:CompareRows(a, b) end

  ZO_ScrollList_AddDataType(manager.list, 1, "LedgerUIRow", 28, function(...) manager:SetupRow(...) end)
  ZO_ScrollList_SetTypeSelectable(manager.list, 1, false)
  ZO_ScrollList_EnableHighlight(manager.list, "ZO_ThinListHighlight")
  ZO_ScrollList_EnableSelection(manager.list, "ZO_ThinListHighlight", function(...) manager:OnSelectionChanged(...) end)
  ZO_ScrollList_SetDeselectOnReselect(manager.list, false)
  ZO_ScrollList_SetAutoSelect(manager.list, true)

  return manager
end

function LedgerList:BuildMasterList()
  self.masterList = ZO_DeepTableCopy(Ledger.cache.sheet, {})

  for i = 1, #self.masterList do
    local t = self.masterList[i]
    t.variation = t.amount - t.previousAmount
    t.reason = Ledger.STRINGS[t.reason] or t.reason
  end
end

function LedgerList:FilterScrollList()
  local scrollData = ZO_ScrollList_GetDataList(self.list)
  ZO_ClearNumericallyIndexedTable(scrollData)

  for i = 1, #self.masterList do
    table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, self.masterList[i]))
  end
end

function LedgerList:OnSelectionChanged(previouslySelected, selected, reselectingDuringRebuild)
  ZO_SortFilterList.OnSelectionChanged(self, previouslySelected, selected)
end

function LedgerList:SortScrollList()
  local scrollData = ZO_ScrollList_GetDataList(self.list)
  table.sort(scrollData, self.sort)
end

function LedgerList:SetupRow(control, data)
  ZO_SortFilterList.SetupRow(self, control, data)

  local timestamp = GetDateStringFromTimestamp(data.timestamp) .. " " .. FormatTimeSeconds(data.timestamp, TIME_FORMAT_STYLE_CLOCK_TIME)

  local hue = data.variation > 0 and { 0.15, 0.85, .25, 1 } or { 0.85, 0.15, 0.25, 1 }

  GetControl(control, "Timestamp"):SetText(timestamp)
  GetControl(control, "Reason"):SetText(data.reason)
  GetControl(control, "Amount"):SetText(ZO_CurrencyControl_FormatCurrency(data.amount))

  GetControl(control, "Variation"):SetText(ZO_CurrencyControl_FormatCurrency(data.variation))
  GetControl(control, "Variation"):SetColor(unpack(hue))
end

function LedgerList:CompareRows(a, b)
  return ZO_TableOrderingFunction(a.data, b.data, self.currentSortKey, LedgerList.SORTINGS, self.currentSortOrder)
end
