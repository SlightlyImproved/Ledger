-- Ledger 1.5.0 (May 1 2016)
-- Licensed under CC BY-NC-SA 4.0
-- More at https://github.com/haggen/Ledger

local currencyChangeReasons =
{
    [CURRENCY_CHANGE_REASON_ABILITY_UPGRADE_PURCHASE] = "Unknown (ABILITY_UPGRADE_PURCHASE)",
    [CURRENCY_CHANGE_REASON_ACHIEVEMENT]              = "Unknown (ACHIEVEMENT)",
    [CURRENCY_CHANGE_REASON_ACTION]                   = "Unknown (ACTION)",
    [CURRENCY_CHANGE_REASON_BAGSPACE]                 = "Bag upgrade",
    [CURRENCY_CHANGE_REASON_BANKSPACE]                = "Bank upgrade",
    [CURRENCY_CHANGE_REASON_BANK_DEPOSIT]             = "Deposit",
    [CURRENCY_CHANGE_REASON_BANK_FEE]                 = "Unknown (BANK_FEE)",
    [CURRENCY_CHANGE_REASON_BANK_WITHDRAWAL]          = "Withdrawal",
    [CURRENCY_CHANGE_REASON_BATTLEGROUND]             = "Unknown (BATTLEGROUND)",
    [CURRENCY_CHANGE_REASON_BOUNTY_CONFISCATED]       = "Bounty",
    [CURRENCY_CHANGE_REASON_BOUNTY_PAID_FENCE]        = "Bounty",
    [CURRENCY_CHANGE_REASON_BOUNTY_PAID_GUARD]        = "Bounty",
    [CURRENCY_CHANGE_REASON_BUYBACK]                  = "Buyback",
    [CURRENCY_CHANGE_REASON_CASH_ON_DELIVERY]         = "Cash on delivery",
    [CURRENCY_CHANGE_REASON_COMMAND]                  = "Unknown (COMMAND)",
    [CURRENCY_CHANGE_REASON_CONSUME_FOOD_DRINK]       = "Unknown (CONSUME_FOOD_DRINK)",
    [CURRENCY_CHANGE_REASON_CONSUME_POTION]           = "Unknown (CONSUME_POTION)",
    [CURRENCY_CHANGE_REASON_CONVERSATION]             = "Dialogue option",
    [CURRENCY_CHANGE_REASON_CRAFT]                    = "Unknown (CRAFT)",
    [CURRENCY_CHANGE_REASON_DEATH]                    = "Unknown (DEATH)",
    [CURRENCY_CHANGE_REASON_DECONSTRUCT]              = "Unknown (DECONSTRUCT)",
    [CURRENCY_CHANGE_REASON_EDIT_GUILD_HERALDRY]      = "Guild heraldry edit",
    [CURRENCY_CHANGE_REASON_FEED_MOUNT]               = "Mount upgrade",
    [CURRENCY_CHANGE_REASON_GUILD_BANK_DEPOSIT]       = "Guild deposit",
    [CURRENCY_CHANGE_REASON_GUILD_BANK_WITHDRAWAL]    = "Guild withdrawal",
    [CURRENCY_CHANGE_REASON_GUILD_FORWARD_CAMP]       = "Unknown (GUILD_FORWARD_CAMP)",
    [CURRENCY_CHANGE_REASON_GUILD_STANDARD]           = "Unknown (GUILD_STANDARD)",
    [CURRENCY_CHANGE_REASON_GUILD_TABARD]             = "Unknown (GUILD_TABARD)",
    [CURRENCY_CHANGE_REASON_HARVEST_REAGENT]          = "Unknown (HARVEST_REAGENT)",
    [CURRENCY_CHANGE_REASON_HOOKPOINT_STORE]          = "Unknown (HOOKPOINT_STORE)",
    [CURRENCY_CHANGE_REASON_JUMP_FAILURE_REFUND]      = "Unknown (JUMP_FAILURE_REFUND)",
    [CURRENCY_CHANGE_REASON_KEEP_REPAIR]              = "Unknown (KEEP_REPAIR)",
    [CURRENCY_CHANGE_REASON_KEEP_REWARD]              = "Unknown (KEEP_REWARD)",
    [CURRENCY_CHANGE_REASON_KEEP_UPGRADE]             = "Unknown (KEEP_UPGRADE)",
    [CURRENCY_CHANGE_REASON_KILL]                     = "Unknown (KILL)",
    [CURRENCY_CHANGE_REASON_LOOT]                     = "Loot",
    [CURRENCY_CHANGE_REASON_LOOT_STOLEN]              = "Theft",
    [CURRENCY_CHANGE_REASON_MAIL]                     = "Mail attachment",
    [CURRENCY_CHANGE_REASON_MEDAL]                    = "Unknown (MEDAL)",
    [CURRENCY_CHANGE_REASON_PICKPOCKET]               = "Pickpocketing",
    [CURRENCY_CHANGE_REASON_PLAYER_INIT]              = "Unknown (PLAYER_INIT)",
    [CURRENCY_CHANGE_REASON_PVP_KILL_TRANSFER]        = "Unknown (PVP_KILL_TRANSFER)",
    [CURRENCY_CHANGE_REASON_PVP_RESURRECT]            = "Unknown (PVP_RESURRECT)",
    [CURRENCY_CHANGE_REASON_QUESTREWARD]              = "Quest reward",
    [CURRENCY_CHANGE_REASON_RECIPE]                   = "Unknown (RECIPE)",
    [CURRENCY_CHANGE_REASON_REFORGE]                  = "Unknown (REFORGE)",
    [CURRENCY_CHANGE_REASON_RESEARCH_TRAIT]           = "Unknown (RESEARCH_TRAIT)",
    [CURRENCY_CHANGE_REASON_RESPEC_ATTRIBUTES]        = "Attribute respec",
    [CURRENCY_CHANGE_REASON_RESPEC_CHAMPION]          = "Champion points respec",
    [CURRENCY_CHANGE_REASON_RESPEC_MORPHS]            = "Morph respec",
    [CURRENCY_CHANGE_REASON_RESPEC_SKILLS]            = "Skill respec",
    [CURRENCY_CHANGE_REASON_REWARD]                   = "Unknown (REWARD)",
    [CURRENCY_CHANGE_REASON_SELL_STOLEN]              = "Fence",
    [CURRENCY_CHANGE_REASON_SOULWEARY]                = "Unknown (SOULWEARY)",
    [CURRENCY_CHANGE_REASON_SOUL_HEAL]                = "Unknown (SOUL_HEAL)",
    [CURRENCY_CHANGE_REASON_STABLESPACE]              = "Unknown (STABLESPACE)",
    [CURRENCY_CHANGE_REASON_STUCK]                    = "Stuck",
    [CURRENCY_CHANGE_REASON_TRADE]                    = "Trade",
    [CURRENCY_CHANGE_REASON_TRADINGHOUSE_LISTING]     = "Guild store listing",
    [CURRENCY_CHANGE_REASON_TRADINGHOUSE_PURCHASE]    = "Guild store purchase",
    [CURRENCY_CHANGE_REASON_TRADINGHOUSE_REFUND]      = "Guild store refund",
    [CURRENCY_CHANGE_REASON_TRAIT_REVEAL]             = "Unknown (TRAIT_REVEAL)",
    [CURRENCY_CHANGE_REASON_TRAVEL_GRAVEYARD]         = "Wayshrine",
    [CURRENCY_CHANGE_REASON_VENDOR]                   = "Vendor",
    [CURRENCY_CHANGE_REASON_VENDOR_LAUNDER]           = "Laundering",
    [CURRENCY_CHANGE_REASON_VENDOR_REPAIR]            = "Equipment repairs",
}

for i, value in pairs(currencyChangeReasons) do
    ZO_CreateStringId("SI_LEDGER_REASON"..i, value)
end

ZO_CreateStringId("SI_BINDING_NAME_LEDGER_TOGGLE"   , "Open/close Ledger")
ZO_CreateStringId("SI_LEDGER_TITLE"                 , "Ledger")
ZO_CreateStringId("SI_LEDGER_EMPTY"                 , "No record found for the selected period and character.")
ZO_CreateStringId("SI_LEDGER_HEADER_TIMESTAMP"      , "Time")
ZO_CreateStringId("SI_LEDGER_HEADER_CHARACTER"      , "Character")
ZO_CreateStringId("SI_LEDGER_HEADER_REASON"         , "Reason")
ZO_CreateStringId("SI_LEDGER_HEADER_VARIATION"      , "Variation")
ZO_CreateStringId("SI_LEDGER_HEADER_BALANCE"        , "Balance")
ZO_CreateStringId("SI_LEDGER_PERIOD_1_HOUR"         , "Last 1 hour")
ZO_CreateStringId("SI_LEDGER_PERIOD_1_DAY"          , "Last 1 day")
ZO_CreateStringId("SI_LEDGER_PERIOD_1_WEEK"         , "Last 1 week")
ZO_CreateStringId("SI_LEDGER_PERIOD_1_MONTH"        , "Last 1 month")
ZO_CreateStringId("SI_LEDGER_ALL_CHARACTERS"        , "Any character")
ZO_CreateStringId("SI_LEDGER_BANK_CHARACTER"        , "Bank")
ZO_CreateStringId("SI_LEDGER_MERGE_LABEL"           , "Merge similar")
ZO_CreateStringId("SI_LEDGER_SUMMARY1"              , "Balance changed by <<1>> in the <<z:2>>.")
ZO_CreateStringId("SI_LEDGER_SUMMARY2"              , "You profited most from <<1>> (<<2>>) and spent most on <<3>> (<<4>>).")
ZO_CreateStringId("SI_LEDGER_SUMMARY2_EXPENSE"      , "You spent most on <<1>> (<<2>>).")
ZO_CreateStringId("SI_LEDGER_SUMMARY2_PROFIT"       , "You profited most from <<1>> (<<2>>).")
ZO_CreateStringId("SI_LEDGER_SUMMARY_EMPTY"         , "")
