-- Ledger 1.4.0 (Dec 20 2015)
-- Licensed under CC BY-NC-SA 4.0
-- More at https://github.com/haggen/Ledger

LEDGER = "Ledger"

--
--
--
--

local function Ledger_FormatCurrencyVariation(value)
    local incomeColor = ZO_ColorDef:New("11EE99")
    local expenseColor = ZO_ColorDef:New("EE2222")

    local formattedValue = ZO_CurrencyControl_FormatCurrency(zo_abs(value))

    if value >= 0 then
        return incomeColor:Colorize("+"..formattedValue)
    else
        return expenseColor:Colorize("-"..formattedValue)
    end
end

local function Ledger_SetupComboBox(self, name)
    local comboBox = ZO_ComboBox_ObjectFromContainer(GetControl(self.control, name))
    comboBox:SetSortsItems(false)
    return comboBox
end

--
--
--

local Ledger = ZO_SortFilterList:Subclass()

function Ledger:New(...)
    return ZO_SortFilterList.New(self, ...)
end

function Ledger:Initialize(control, sv)
    ZO_SortFilterList.Initialize(self, control)

    ZO_ScrollList_AddDataType(self.list, 1, "LedgerRow", 32, function(...) self:SetupRow(...) end)

    self:SetAlternateRowBackgrounds(true)
    self:SetEmptyText(GetString(SI_LEDGER_EMPTY))

    Fix_ZO_SortHeaderGroup_OnHeaderClicked(self.sortHeaderGroup)
    self.sortHeaderGroup:SelectHeaderByKey("timestamp")

    self.sv = sv

    self.control:SetHandler("OnMoveStop", function()
        self.sv.offsetX = self.control:GetLeft()
        self.sv.offsetY = self.control:GetTop()
    end)

    self.control:SetHandler("OnResizeStop", function()
        self.sv.x = self.control:GetWidth()
        self.sv.y = self.control:GetHeight()
        self:RefreshScrollListHeight()
    end)

    if not (self.sv.offsetX == 0 and self.sv.offsetY == 0) then
        self.control:ClearAnchors()
        self.control:SetAnchor(TOPLEFT, nil, TOPLEFT, self.sv.offsetX, self.sv.offsetY)
    end
    self.control:SetDimensions(self.sv.x, self.sv.y)

    self.sceneFragment = ZO_HUDFadeSceneFragment:New(self.control)
    HUD_SCENE:AddFragment(self.sceneFragment)
    HUD_UI_SCENE:AddFragment(self.sceneFragment)
    self.sceneFragment:SetHiddenForReason("hidden", self.sv.isHidden)

    local function OnFragmentStateChange()
        self.sv.isHidden = self.sceneFragment:IsHidden()
        self:Refresh()
    end
    self.sceneFragment:RegisterCallback("StateChange", OnFragmentStateChange)

    local currentCharacter = GetUnitName("player")

    if not table.indexOf(self.sv.charactersList, currentCharacter) then
        table.insert(self.sv.charactersList, currentCharacter)
    end

    self.closeButton = GetControl(self.control, "CloseButton")
    self.closeButton:SetHandler("OnClicked", function()
        self:Toggle()
    end)

    self.summaryLabel = GetControl(self.control, "Summary")

    self:SetupPeriodComboBox()
    self:SetupCharacterComboBox()

    self.mergeCheckBox = GetControl(self.control, "OptionsMergeCheckBox")
    ZO_CheckButton_SetLabelText(self.mergeCheckBox, GetString(SI_LEDGER_MERGE_LABEL))
    ZO_CheckButton_SetCheckState(self.mergeCheckBox, self.sv.options.shouldMerge)
    ZO_CheckButton_SetToggleFunction(self.mergeCheckBox, function(control, state)
        self.sv.options.shouldMerge = state
        self:Refresh()
    end)

    local function OnPlayerCombatState(event, inCombat)
        self.sceneFragment:SetHiddenForReason("combat", inCombat)
    end
    self.control:RegisterForEvent(EVENT_PLAYER_COMBAT_STATE, OnPlayerCombatState)

    local function OnMoneyUpdate(event, newBalance, previousBalance, reason)
        local entry =
        {
            timestamp = GetTimeStamp(),
            character = GetUnitName("player"),
            reason = reason,
            variation = newBalance - previousBalance,
            balance = newBalance,
        }

        table.insert(self.sv.masterList, entry)

        self:Refresh()
    end
    self.control:RegisterForEvent(EVENT_MONEY_UPDATE, OnMoneyUpdate)

    SLASH_COMMANDS["/ledger"] = function()
        self:Toggle()
    end

    self:Refresh()
end

function Ledger:SetupPeriodComboBox()
    self.periodComboBox = Ledger_SetupComboBox(self, "OptionsPeriodComboBox")

    local selectedIndex = 1

    local options =
    {
        [1] = {
            label = GetString(SI_LEDGER_PERIOD_1_HOUR),
            value = 3600,
        },
        [2] = {
            label = GetString(SI_LEDGER_PERIOD_1_DAY),
            value = 3600 * 24,
        },
        [3] = {
            label = GetString(SI_LEDGER_PERIOD_1_WEEK),
            value = 3600 * 24 * 7,
        },
        [4] = {
            label = GetString(SI_LEDGER_PERIOD_1_MONTH),
            value = 3600 * 24 * 30,
        },
    }

    for i = 1, #options do
        local item = self.periodComboBox:CreateItemEntry(options[i].label, function()
            self.sv.options.selectedPeriod = options[i].value
            self:Refresh()
        end)

        self.periodComboBox:AddItem(item)

        if self.sv.options.selectedPeriod == options[i].value then
            selectedIndex = i
        end
    end

    self.periodComboBox:SelectItemByIndex(selectedIndex)
end

function Ledger:SetupCharacterComboBox()
    self.characterComboBox = Ledger_SetupComboBox(self, "OptionsCharacterComboBox")

    local selectedIndex = 1

    local options =
    {
        [1] =
        {
            label = GetString(SI_LEDGER_ALL_CHARACTERS),
            value = nil,
        }
    }

    for i = 1, #self.sv.charactersList do
        local option =
        {
            label = self.sv.charactersList[i],
            value = self.sv.charactersList[i],
        }

        table.insert(options, option)
    end

    for i = 1, #options do
        local item = self.characterComboBox:CreateItemEntry(options[i].label, function()
            self.sv.options.selectedCharacter = options[i].value
            self:Refresh()
        end)

        self.characterComboBox:AddItem(item)

        if self.sv.options.selectedCharacter == options[i].value then
            selectedIndex = i
        end
    end

    self.characterComboBox:SelectItemByIndex(selectedIndex)
end

function Ledger:Refresh()
    if not self.sceneFragment:IsHidden() then
        self:RefreshData()
        self:RefreshSummary()
    end
end

function Ledger:RefreshSummary()
    local scrollData = ZO_ScrollList_GetDataList(self.list)

    if #scrollData > 0 then
        local variationByPeriod = 0
        local variationsByReason = {}

        for i = 1, #scrollData do
            local data = scrollData[i].data

            variationByPeriod = variationByPeriod + data.variation

            if variationsByReason[data.reason] then
                variationsByReason[data.reason] = variationsByReason[data.reason] + data.variation
            else
                variationsByReason[data.reason] = data.variation
            end
        end

        local mostExpensive = {variation = 0}
        local mostProfitable = {variation = 0}

        for reason, variation in pairs(variationsByReason) do
            if variation >= mostProfitable.variation then
                mostProfitable.variation = variation
                mostProfitable.reason = reason
            end

            if variation <= mostExpensive.variation then
                mostExpensive.variation = variation
                mostExpensive.reason = reason
            end
        end

        local t =
        {
            Ledger_FormatCurrencyVariation(variationByPeriod),
            self.periodComboBox:GetSelectedItem(),
            GetString("SI_LEDGER_REASON", mostExpensive.reason),
            Ledger_FormatCurrencyVariation(mostExpensive.variation),
            GetString("SI_LEDGER_REASON", mostProfitable.reason),
            Ledger_FormatCurrencyVariation(mostProfitable.variation),
        }

        self.summaryLabel:SetText(zo_strformat(GetString(SI_LEDGER_SUMMARY), unpack(t)))
    else
        self.summaryLabel:SetText(GetString(SI_LEDGER_SUMMARY_EMPTY))
    end
end

function Ledger:BuildMasterList()
    self.masterList = {}

    local t = {}
    local threshold = GetTimeStamp() - self.sv.options.selectedPeriod

    for i = #self.sv.masterList, 1, -1 do
        local entry = self.sv.masterList[i]

        if entry.timestamp >= threshold then
            table.insert(t, ZO_ShallowTableCopy(entry))
        else
            break
        end
    end

    for i = #t, 1, -1 do
        table.insert(self.masterList, t[i])
    end
end

function Ledger:FilterScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    ZO_ClearNumericallyIndexedTable(scrollData)

    local previousEntry

    for i = 1, #self.masterList do
        currentEntry = self.masterList[i]

        local matchSelectedCharacter = (currentEntry.character == self.sv.options.selectedCharacter)

        if (not self.sv.options.selectedCharacter or matchSelectedCharacter) then
            if (not self.sv.options.shouldMerge) or (self.sv.options.shouldMerge and not previousEntry) then
                table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, currentEntry))
                previousEntry = currentEntry
            else
                local isSameCharacter = currentEntry.characterName == previousEntry.characterName
                local isSameReason = currentEntry.reason == previousEntry.reason

                if (isSameReason and isSameCharacter) then
                    previousEntry.mergeCount = (previousEntry.mergeCount or 1) + 1
                    previousEntry.variation = previousEntry.variation + currentEntry.variation
                    previousEntry.balance = currentEntry.balance
                else
                    table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, currentEntry))
                    previousEntry = currentEntry
                end
            end
        end
    end
end

function Ledger:SortScrollList()
    local scrollData = ZO_ScrollList_GetDataList(self.list)
    table.sort(scrollData, function(...) return self:CompareRows(...) end)
end

local sortKeys =
{
    timestamp =
    {
        isNumeric = true
    },
    name =
    {
        caseInsensitive = true,
        tiebreaker = "timestamp"
    },
    reason =
    {
        caseInsensitive = true,
        tiebreaker = "timestamp"
    },
    variation =
    {
        isNumeric = true,
        tiebreaker = "timestamp"
    },
    balance =
    {
        isNumeric = true,
        tiebreaker = "timestamp"
    },
}

function Ledger:CompareRows(row1, row2)
    return ZO_TableOrderingFunction(row1.data, row2.data, self.currentSortKey, sortKeys, self.currentSortOrder)
end

function Ledger:GetRowColors()
end

function Ledger:SetupRow(control, data)
    ZO_SortFilterList.SetupRow(self, control, data)

    local formattedDateTime = L10n_GetLocalizedDateTime(data.timestamp)

    local reasonDescription = GetString("SI_LEDGER_REASON", data.reason)
    if data.mergeCount and (data.mergeCount > 0) then
        reasonDescription = reasonDescription..string.format(" (%d)", data.mergeCount)
    end

    GetControl(control, "Timestamp"):SetText(formattedDateTime)
    GetControl(control, "Character"):SetText(data.character)
    GetControl(control, "Reason"):SetText(reasonDescription)
    GetControl(control, "Variation"):SetText(Ledger_FormatCurrencyVariation(data.variation))
    GetControl(control, "Balance"):SetText(ZO_CurrencyControl_FormatCurrency(data.balance))
end

function Ledger:RefreshScrollListHeight()
    ZO_ScrollList_SetHeight(self.list, self.list:GetHeight())
    ZO_ScrollList_Commit(self.list)
end

function Ledger:Toggle()
    if self.sceneFragment:IsHidden() then
        SCENE_MANAGER:SetInUIMode(true)
        self.sceneFragment:SetHiddenForReason("hidden", false)
        self.control:BringWindowToTop()
    else
        self.sceneFragment:SetHiddenForReason("hidden", true)
    end
end

--
--
--

local defaultSavedVars =
{
    ["masterList"] = {},
    ["charactersList"] = {},
    ["isHidden"] = false,
    ["x"] = 840,
    ["y"] = 320,
    ["offsetX"] = 0,
    ["offsetY"] = 0,
    ["options"] =
    {
        ["shouldMerge"] = true,
        ["selectedPeriod"] = 3600,
        ["selectedCharacter"] = nil
    }
}

function Ledger_OnInitialized(control)
    EVENT_MANAGER:RegisterForEvent(LEDGER, EVENT_ADD_ON_LOADED, function(event, addonName)
        if (addonName == LEDGER) then
            EVENT_MANAGER:UnregisterForEvent(LEDGER, EVENT_ADD_ON_LOADED)

            local sv = ZO_SavedVars:NewAccountWide("LedgerSavedVars", 1, nil, defaultSavedVars)

            if LedgerCache then
                local oldSavedVars = LedgerCache["Default"][GetUnitDisplayName("player")]

                if oldSavedVars then
                    sv.masterList = oldSavedVars["$AccountWide"].data
                    sv.charactersList = oldSavedVars["$AccountWide"].characters
                    LedgerCache["Default"][GetUnitDisplayName("player")] = nil
                end
            end

            LEDGER = Ledger:New(control, sv)
        end
    end)
end
