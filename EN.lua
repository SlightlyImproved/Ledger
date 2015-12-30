-- Ledger 1.4.2 (Dec 30 2015)
-- Licensed under CC BY-NC-SA 4.0
-- More at https://github.com/haggen/Ledger

local currencyChangeReasons =
{
  [CURRENCY_CHANGE_REASON_ABILITY_UPGRADE_PURCHASE] = "Ability upgrade",
  [CURRENCY_CHANGE_REASON_ACHIEVEMENT]              = "Achievement",
  [CURRENCY_CHANGE_REASON_ACTION]                   = "Unknown (ACTION)",
  [CURRENCY_CHANGE_REASON_BAGSPACE]                 = "Bag upgrade",
  [CURRENCY_CHANGE_REASON_BANKSPACE]                = "Bank upgrade",
  [CURRENCY_CHANGE_REASON_BANK_DEPOSIT]             = "Bank deposit",
  [CURRENCY_CHANGE_REASON_BANK_WITHDRAWAL]          = "Bank withdrawal",
  [CURRENCY_CHANGE_REASON_BATTLEGROUND]             = "Unknown (BATTLEGROUND)",
  [CURRENCY_CHANGE_REASON_BOUNTY_CONFISCATED]       = "Bounty confiscated",
  [CURRENCY_CHANGE_REASON_BOUNTY_PAID_FENCE]        = "Bounty paid to fence",
  [CURRENCY_CHANGE_REASON_BOUNTY_PAID_GUARD]        = "Bounty paid to guard",
  [CURRENCY_CHANGE_REASON_BUYBACK]                  = "Buyback",
  [CURRENCY_CHANGE_REASON_CASH_ON_DELIVERY]         = "Cash on delivery",
  [CURRENCY_CHANGE_REASON_COMMAND]                  = "Unknown (COMMAND)",
  [CURRENCY_CHANGE_REASON_CONSUME_FOOD_DRINK]       = "Unknown (CONSUME_FOOD_DRINK)",
  [CURRENCY_CHANGE_REASON_CONSUME_POTION]           = "Unknown (CONSUME_POTION)",
  [CURRENCY_CHANGE_REASON_CONVERSATION]             = "Unknown (CONVERSATION)",
  [CURRENCY_CHANGE_REASON_CRAFT]                    = "Crafting",
  [CURRENCY_CHANGE_REASON_DECONSTRUCT]              = "Deconstruction",
  [CURRENCY_CHANGE_REASON_EDIT_GUILD_HERALDRY]      = "Unknown (EDIT_GUILD_HERALDRY)",
  [CURRENCY_CHANGE_REASON_FEED_MOUNT]               = "Horse carry capacity upgrade",
  [CURRENCY_CHANGE_REASON_GUILD_BANK_DEPOSIT]       = "Guild bank deposit",
  [CURRENCY_CHANGE_REASON_GUILD_BANK_WITHDRAWAL]    = "Guild bank withdrawal",
  [CURRENCY_CHANGE_REASON_GUILD_FORWARD_CAMP]       = "Unknown (GUILD_FORWARD_CAMP)",
  [CURRENCY_CHANGE_REASON_GUILD_STANDARD]           = "Unknown (GUILD_STANDARD)",
  [CURRENCY_CHANGE_REASON_GUILD_TABARD]             = "Guild tabard",
  [CURRENCY_CHANGE_REASON_HARVEST_REAGENT]          = "Unknown (HARVEST_REAGENT)",
  [CURRENCY_CHANGE_REASON_HOOKPOINT_STORE]          = "Unknown (HOOKPOINT_STORE)",
  [CURRENCY_CHANGE_REASON_JUMP_FAILURE_REFUND]      = "Unknown (JUMP_FAILURE_REFUND)",
  [CURRENCY_CHANGE_REASON_KEEP_REPAIR]              = "Keep repair",
  [CURRENCY_CHANGE_REASON_KEEP_REWARD]              = "Keep reward",
  [CURRENCY_CHANGE_REASON_KEEP_UPGRADE]             = "Keep upgrade",
  [CURRENCY_CHANGE_REASON_KILL]                     = "Unknown (KILL)",
  [CURRENCY_CHANGE_REASON_LOOT]                     = "Loot",
  [CURRENCY_CHANGE_REASON_LOOT_STOLEN]              = "Theft",
  [CURRENCY_CHANGE_REASON_MAIL]                     = "Mail attachment",
  [CURRENCY_CHANGE_REASON_MEDAL]                    = "Unknown (MEDAL)",
  [CURRENCY_CHANGE_REASON_PICKPOCKET]               = "Theft (pickpocketing)",
  [CURRENCY_CHANGE_REASON_PLAYER_INIT]              = "Unknown (PLAYER_INIT)",
  [CURRENCY_CHANGE_REASON_PVP_RESURRECT]            = "Unknown (PVP_RESURRECT)",
  [CURRENCY_CHANGE_REASON_QUESTREWARD]              = "Quest reward",
  [CURRENCY_CHANGE_REASON_RECIPE]                   = "Unknown (RECIPE)",
  [CURRENCY_CHANGE_REASON_REFORGE]                  = "Unknown (REFORGE)",
  [CURRENCY_CHANGE_REASON_RESEARCH_TRAIT]           = "Unknown (RESEARCH_TRAIT)",
  [CURRENCY_CHANGE_REASON_RESPEC_CHAMPION]          = "Respec champion",
  [CURRENCY_CHANGE_REASON_RESPEC_MORPHS]            = "Respec morphs",
  [CURRENCY_CHANGE_REASON_RESPEC_SKILLS]            = "Respec skills",
  [CURRENCY_CHANGE_REASON_REWARD]                   = "Unknown (REWARD)",
  [CURRENCY_CHANGE_REASON_SELL_STOLEN]              = "Fence",
  [CURRENCY_CHANGE_REASON_SOULWEARY]                = "Unknown (SOULWEARY)",
  [CURRENCY_CHANGE_REASON_SOUL_HEAL]                = "Unknown (SOUL_HEAL)",
  [CURRENCY_CHANGE_REASON_STABLESPACE]              = "Unknown (STABLESPACE)",
  [CURRENCY_CHANGE_REASON_STUCK]                    = "Unknown (STUCK)",
  [CURRENCY_CHANGE_REASON_TRADE]                    = "Trade",
  [CURRENCY_CHANGE_REASON_TRADINGHOUSE_LISTING]     = "Unknown (TRADINGHOUSE_LISTING)",
  [CURRENCY_CHANGE_REASON_TRADINGHOUSE_PURCHASE]    = "Guild store purchase",
  [CURRENCY_CHANGE_REASON_TRADINGHOUSE_REFUND]      = "Guild store refund",
  [CURRENCY_CHANGE_REASON_TRAIT_REVEAL]             = "Unknown (TRAIT_REVEAL)",
  [CURRENCY_CHANGE_REASON_TRAVEL_GRAVEYARD]         = "Wayshrine",
  [CURRENCY_CHANGE_REASON_VENDOR]                   = "Vendor",
  [CURRENCY_CHANGE_REASON_VENDOR_LAUNDER]           = "Laundering",
  [CURRENCY_CHANGE_REASON_VENDOR_REPAIR]            = "Repairs"
}

for i, value in pairs(currencyChangeReasons) do
  ZO_CreateStringId("SI_LEDGER_REASON" .. i, value)
end

ZO_CreateStringId("SI_BINDING_NAME_LEDGER_TOGGLE"   , "Open/close Ledger")
ZO_CreateStringId("SI_LEDGER_TITLE"                 , "Ledger")
ZO_CreateStringId("SI_LEDGER_EMPTY"                 , "Whenever you get or spend gold Ledger keeps a record.")
ZO_CreateStringId("SI_LEDGER_HEADER_TIMESTAMP"      , "Time")
ZO_CreateStringId("SI_LEDGER_HEADER_CHARACTER"      , "Character")
ZO_CreateStringId("SI_LEDGER_HEADER_REASON"         , "Reason")
ZO_CreateStringId("SI_LEDGER_HEADER_VARIATION"      , "Variation")
ZO_CreateStringId("SI_LEDGER_HEADER_BALANCE"        , "Balance")
ZO_CreateStringId("SI_LEDGER_PERIOD_1_HOUR"         , "Last 1 hour")
ZO_CreateStringId("SI_LEDGER_PERIOD_1_DAY"          , "Last 1 day")
ZO_CreateStringId("SI_LEDGER_PERIOD_1_WEEK"         , "Last 1 week")
ZO_CreateStringId("SI_LEDGER_PERIOD_1_MONTH"        , "Last 1 month")
ZO_CreateStringId("SI_LEDGER_ALL_CHARACTERS"        , "All characters")
ZO_CreateStringId("SI_LEDGER_MERGE_LABEL"           , "Merge similar")
ZO_CreateStringId("SI_LEDGER_SUMMARY1"              , "Balance changed by <<1>> in the |cC4C19B<<z:2>>|r.")
ZO_CreateStringId("SI_LEDGER_SUMMARY2"              , "You spent most on |cC4C19B<<1>>|r (<<2>>) and profited most from |cC4C19B<<3>>|r (<<4>>).")
ZO_CreateStringId("SI_LEDGER_SUMMARY_EMPTY"         , "")
