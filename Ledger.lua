-- Ledger 1.5.0 (May 1 2016)
-- Licensed under CC BY-NC-SA 4.0
-- More at https://github.com/haggen/Ledger

LEDGER = "Ledger"

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

LEDGER_ROW_HEIGHT = 28

function Ledger:New(...)
    return ZO_SortFilterList.New(self, ...)
end

function Ledger:Initialize(control, savedVars)
    ZO_SortFilterList.Initialize(self, control)

    ZO_ScrollList_AddDataType(self.list, 1, "LedgerRow", LEDGER_ROW_HEIGHT, function(...) self:SetupRow(...) end)
    ZO_ScrollList_EnableHighlight(self.list, "ZO_ThinListHighlight")

    self:SetAlternateRowBackgrounds(true)
    self:SetEmptyText(GetString(SI_LEDGER_EMPTY))

    Fix_ZO_SortHeaderGroup_OnHeaderClicked(self.sortHeaderGroup)
    self.sortHeaderGroup:SelectHeaderByKey("timestamp")

    self.savedVars = savedVars

    self.control:SetHandler("OnMoveStop", function()
        self.savedVars.offsetX = self.control:GetLeft()
        self.savedVars.offsetY = self.control:GetTop()
    end)

    self.control:SetHandler("OnResizeStop", function()
        self.savedVars.x = self.control:GetWidth()
        self.savedVars.y = self.control:GetHeight()
        self:RefreshScrollListHeight()
    end)

    if not (self.savedVars.offsetX == 0 and self.savedVars.offsetY == 0) then
        self.control:ClearAnchors()
        self.control:SetAnchor(TOPLEFT, nil, TOPLEFT, self.savedVars.offsetX, self.savedVars.offsetY)
    end
    self.control:SetDimensions(self.savedVars.x, self.savedVars.y)

    self.sceneFragment = ZO_HUDFadeSceneFragment:New(self.control)
    HUD_SCENE:AddFragment(self.sceneFragment)
    HUD_UI_SCENE:AddFragment(self.sceneFragment)
    self.sceneFragment:SetHiddenForReason("hidden", self.savedVars.isHidden)

    local function OnFragmentStateChange()
        self.savedVars.isHidden = self.sceneFragment:IsHidden()
        self:Refresh()
    end
    self.sceneFragment:RegisterCallback("StateChange", OnFragmentStateChange)

    local characterName = GetUnitName("player")

    if not table.indexOf(self.savedVars.charactersList, characterName) then
        table.insert(self.savedVars.charactersList, characterName)
    end

    -- self.closeButton = GetControl(self.control, "CloseButton")
    -- self.closeButton:SetHandler("OnClicked", function()
    --     self:Toggle()
    -- end)

    self.summaryLabel = GetControl(self.control, "Summary")

    self:SetupPeriodComboBox()
    self:SetupCharacterComboBox()

    self.mergeCheckBox = GetControl(self.control, "OptionsMergeCheckBox")
    ZO_CheckButton_SetLabelText(self.mergeCheckBox, GetString(SI_LEDGER_MERGE_LABEL))
    ZO_CheckButton_SetCheckState(self.mergeCheckBox, self.savedVars.options.shouldMerge)
    ZO_CheckButton_SetToggleFunction(self.mergeCheckBox, function(control, state)
        self.savedVars.options.shouldMerge = state
        self:Refresh()
    end)

    local function OnPlayerCombatState(event, inCombat)
        self.sceneFragment:SetHiddenForReason("combat", inCombat)
    end
    self.control:RegisterForEvent(EVENT_PLAYER_COMBAT_STATE, OnPlayerCombatState)

    local function OnMoneyUpdate(event, newBalance, previousBalance, reason)
        local record =
        {
            timestamp = GetTimeStamp(),
            character = GetUnitName("player"),
            reason = reason,
            variation = newBalance - previousBalance,
            balance = newBalance,
        }

        table.insert(self.savedVars.masterList, record)

        self:Refresh()
    end
    self.control:RegisterForEvent(EVENT_MONEY_UPDATE, OnMoneyUpdate)

    local function OnBankedMoneyUpdate(event, newBalance, previousBalance)
        local entry =
        {
            timestamp = GetTimeStamp(),
            character = "bank",
            variation = newBalance - previousBalance,
            balance = newBalance,
        }

        if newBalance > previousBalance then
            entry.reason = CURRENCY_CHANGE_REASON_BANK_DEPOSIT
        else
            entry.reason = CURRENCY_CHANGE_REASON_BANK_WITHDRAWAL
        end

        table.insert(self.savedVars.masterList, entry)

        self:Refresh()
    end
    self.control:RegisterForEvent(EVENT_BANKED_MONEY_UPDATE , OnBankedMoneyUpdate)

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
        [1] =
        {
            label = GetString(SI_LEDGER_PERIOD_1_HOUR),
            value = 3600,
        },
        [2] =
        {
            label = GetString(SI_LEDGER_PERIOD_1_DAY),
            value = 3600 * 24,
        },
        [3] =
        {
            label = GetString(SI_LEDGER_PERIOD_1_WEEK),
            value = 3600 * 24 * 7,
        },
        [4] =
        {
            label = GetString(SI_LEDGER_PERIOD_1_MONTH),
            value = 3600 * 24 * 30,
        },
    }

    for i = 1, #options do
        local item = self.periodComboBox:CreateItemEntry(options[i].label, function()
            self.savedVars.options.selectedPeriod = options[i].value
            self:Refresh()
        end)

        self.periodComboBox:AddItem(item)

        if self.savedVars.options.selectedPeriod == options[i].value then
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
        },
        [2] =
        {
            label = GetString(SI_LEDGER_BANK_CHARACTER),
            value = "bank",
        }
    }

    for i = 1, #self.savedVars.charactersList do
        local option =
        {
            label = self.savedVars.charactersList[i],
            value = self.savedVars.charactersList[i],
        }

        table.insert(options, option)
    end

    for i = 1, #options do
        local item = self.characterComboBox:CreateItemEntry(options[i].label, function()
            self.savedVars.options.selectedCharacter = options[i].value
            self:Refresh()
        end)

        self.characterComboBox:AddItem(item)

        if self.savedVars.options.selectedCharacter == options[i].value then
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

    local isBankSelected = (self.savedVars.options.selectedCharacter == "bank")

    if #scrollData > 0 then
        local variationByPeriod = 0
        local variationsByReason = {}

        for i = 1, #scrollData do
            local data = scrollData[i].data

            local isBankDeposit = (data.reason == CURRENCY_CHANGE_REASON_BANK_DEPOSIT)
            local isBankWithdrawal = (data.reason == CURRENCY_CHANGE_REASON_BANK_WITHDRAWAL)

            local isActuallyIncomeOrExpense = not (isBankDeposit or isBankWithdrawal)
            if isBankSelected then
                isActuallyIncomeOrExpense = true
            end

            if isActuallyIncomeOrExpense then
                variationByPeriod = variationByPeriod + data.variation
            end

            if variationsByReason[data.reason] then
                variationsByReason[data.reason] = variationsByReason[data.reason] + data.variation
            else
                variationsByReason[data.reason] = data.variation
            end
        end

        variationsByReason[CURRENCY_CHANGE_REASON_BANK_DEPOSIT] = nil
        variationsByReason[CURRENCY_CHANGE_REASON_BANK_WITHDRAWAL] = nil

        local largestExpenseVariation = 0
        local largestExpenseReason
        local largestProfitVariation = 0
        local largestProfitReason

        for reason, variation in pairs(variationsByReason) do
            if variation > largestProfitVariation then
                largestProfitVariation = variation
                largestProfitReason = reason
            end

            if variation < largestExpenseVariation then
                largestExpenseVariation = variation
                largestExpenseReason = reason
            end
        end

        local t =
        {
            Ledger_FormatCurrencyVariation(variationByPeriod),
            ZO_DEFAULT_ENABLED_COLOR:Colorize(self.periodComboBox:GetSelectedItem()),
        }

        local summary1 = zo_strformat(GetString("SI_LEDGER_SUMMARY", 1), unpack(t))
        local summary2 = ""

        if largestExpenseReason and largestProfitReason then
            t =
            {
                ZO_DEFAULT_ENABLED_COLOR:Colorize(GetString("SI_LEDGER_REASON", largestProfitReason)),
                Ledger_FormatCurrencyVariation(largestProfitVariation),
                ZO_DEFAULT_ENABLED_COLOR:Colorize(GetString("SI_LEDGER_REASON", largestExpenseReason)),
                Ledger_FormatCurrencyVariation(largestExpenseVariation),
            }

            summary2 = zo_strformat(GetString("SI_LEDGER_SUMMARY", 2), unpack(t))
        elseif largestExpenseReason then
            t =
            {
                ZO_DEFAULT_ENABLED_COLOR:Colorize(GetString("SI_LEDGER_REASON", largestExpenseReason)),
                Ledger_FormatCurrencyVariation(largestExpenseVariation),
            }

            summary2 = zo_strformat(GetString(SI_LEDGER_SUMMARY2_EXPENSE), unpack(t))
        elseif largestProfitReason then
            t =
            {
                ZO_DEFAULT_ENABLED_COLOR:Colorize(GetString("SI_LEDGER_REASON", largestProfitReason)),
                Ledger_FormatCurrencyVariation(largestProfitVariation),
            }

            summary2 = zo_strformat(GetString(SI_LEDGER_SUMMARY2_PROFIT), unpack(t))
        end

        self.summaryLabel:SetText(zo_strjoin(" ", summary1, summary2))
    else
        self.summaryLabel:SetText(GetString(SI_LEDGER_SUMMARY_EMPTY))
    end
end

function Ledger:BuildMasterList()
    self.masterList = {}

    local t = {}
    local threshold = GetTimeStamp() - self.savedVars.options.selectedPeriod

    for i = #self.savedVars.masterList, 1, -1 do
        local entry = self.savedVars.masterList[i]

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

        local matchSelectedCharacter = (currentEntry.character == self.savedVars.options.selectedCharacter)

        if (not self.savedVars.options.selectedCharacter or matchSelectedCharacter) then
            if (not self.savedVars.options.shouldMerge) or (self.savedVars.options.shouldMerge and not previousEntry) then
                table.insert(scrollData, ZO_ScrollList_CreateDataEntry(1, currentEntry))
                previousEntry = currentEntry
            else
                local isSameCharacter = currentEntry.character == previousEntry.character
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
    character =
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

    local characterName = data.character
    if characterName == "bank" then
        characterName = GetString(SI_LEDGER_BANK_CHARACTER)
    end

    GetControl(control, "Timestamp"):SetText(formattedDateTime)
    GetControl(control, "Character"):SetText(characterName)
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
        self.sceneFragment:SetHiddenForReason("hidden", false)
        self.control:BringWindowToTop()
        SCENE_MANAGER:SetInUIMode(true)
    else
        self.sceneFragment:SetHiddenForReason("hidden", true)
        SCENE_MANAGER:SetInUIMode(false)
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
    ["x"] = 980,
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
            local savedVars = ZO_SavedVars:NewAccountWide("LedgerSavedVars", 1, nil, defaultSavedVars)
            LEDGER = Ledger:New(control, savedVars)
        end
    end)
end
