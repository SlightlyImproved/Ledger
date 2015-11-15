local REASONS = {
  [CURRENCY_CHANGE_REASON_ABILITY_UPGRADE_PURCHASE] = "Ability upgrade",
  [CURRENCY_CHANGE_REASON_ACHIEVEMENT]              = "Achievement",
  [CURRENCY_CHANGE_REASON_ACTION]                   = "CURRENCY_CHANGE_REASON_ACTION",
  [CURRENCY_CHANGE_REASON_BAGSPACE]                 = "Bag upgrade",
  [CURRENCY_CHANGE_REASON_BANKSPACE]                = "Bank upgrade",
  [CURRENCY_CHANGE_REASON_BANK_DEPOSIT]             = "Bank deposit",
  [CURRENCY_CHANGE_REASON_BANK_WITHDRAWAL]          = "Bank withdrawal",
  [CURRENCY_CHANGE_REASON_BATTLEGROUND]             = "CURRENCY_CHANGE_REASON_BATTLEGROUND",
  [CURRENCY_CHANGE_REASON_BOUNTY_CONFISCATED]       = "Bounty confiscated",
  [CURRENCY_CHANGE_REASON_BOUNTY_PAID_FENCE]        = "Bounty paid (fence)",
  [CURRENCY_CHANGE_REASON_BOUNTY_PAID_GUARD]        = "Bounty paid (guard)",
  [CURRENCY_CHANGE_REASON_BUYBACK]                  = "Buyback",
  [CURRENCY_CHANGE_REASON_CASH_ON_DELIVERY]         = "Cash on delivery",
  [CURRENCY_CHANGE_REASON_COMMAND]                  = "CURRENCY_CHANGE_REASON_COMMAND",
  [CURRENCY_CHANGE_REASON_CONSUME_FOOD_DRINK]       = "CURRENCY_CHANGE_REASON_CONSUME_FOOD_DRINK",
  [CURRENCY_CHANGE_REASON_CONSUME_POTION]           = "CURRENCY_CHANGE_REASON_CONSUME_POTION",
  [CURRENCY_CHANGE_REASON_CONVERSATION]             = "CURRENCY_CHANGE_REASON_CONVERSATION",
  [CURRENCY_CHANGE_REASON_CRAFT]                    = "Crafting",
  [CURRENCY_CHANGE_REASON_DECONSTRUCT]              = "Deconstruction",
  [CURRENCY_CHANGE_REASON_EDIT_GUILD_HERALDRY]      = "CURRENCY_CHANGE_REASON_EDIT_GUILD_HERALDRY",
  [CURRENCY_CHANGE_REASON_FEED_MOUNT]               = "Horse upgrade (carry capacity)",
  [CURRENCY_CHANGE_REASON_GUILD_BANK_DEPOSIT]       = "Bank deposit (guild)",
  [CURRENCY_CHANGE_REASON_GUILD_BANK_WITHDRAWAL]    = "Bank withdrawal (guild)",
  [CURRENCY_CHANGE_REASON_GUILD_FORWARD_CAMP]       = "CURRENCY_CHANGE_REASON_GUILD_FORWARD_CAMP",
  [CURRENCY_CHANGE_REASON_GUILD_STANDARD]           = "CURRENCY_CHANGE_REASON_GUILD_STANDARD",
  [CURRENCY_CHANGE_REASON_GUILD_TABARD]             = "Guild tabard",
  [CURRENCY_CHANGE_REASON_HARVEST_REAGENT]          = "CURRENCY_CHANGE_REASON_HARVEST_REAGENT",
  [CURRENCY_CHANGE_REASON_HOOKPOINT_STORE]          = "CURRENCY_CHANGE_REASON_HOOKPOINT_STORE",
  [CURRENCY_CHANGE_REASON_JUMP_FAILURE_REFUND]      = "CURRENCY_CHANGE_REASON_JUMP_FAILURE_REFUND",
  [CURRENCY_CHANGE_REASON_KEEP_REPAIR]              = "Keep repair",
  [CURRENCY_CHANGE_REASON_KEEP_REWARD]              = "Keep reward",
  [CURRENCY_CHANGE_REASON_KEEP_UPGRADE]             = "Keep upgrade",
  [CURRENCY_CHANGE_REASON_KILL]                     = "CURRENCY_CHANGE_REASON_KILL",
  [CURRENCY_CHANGE_REASON_LOOT]                     = "Loot",
  [CURRENCY_CHANGE_REASON_LOOT_STOLEN]              = "Theft",
  [CURRENCY_CHANGE_REASON_MAIL]                     = "Mail attachment",
  [CURRENCY_CHANGE_REASON_MEDAL]                    = "CURRENCY_CHANGE_REASON_MEDAL",
  [CURRENCY_CHANGE_REASON_PICKPOCKET]               = "Theft (pickpocketing)",
  [CURRENCY_CHANGE_REASON_PLAYER_INIT]              = "CURRENCY_CHANGE_REASON_PLAYER_INIT",
  [CURRENCY_CHANGE_REASON_PVP_RESURRECT]            = "CURRENCY_CHANGE_REASON_PVP_RESURRECT",
  [CURRENCY_CHANGE_REASON_QUESTREWARD]              = "Quest reward",
  [CURRENCY_CHANGE_REASON_RECIPE]                   = "CURRENCY_CHANGE_REASON_RECIPE",
  [CURRENCY_CHANGE_REASON_REFORGE]                  = "CURRENCY_CHANGE_REASON_REFORGE",
  [CURRENCY_CHANGE_REASON_RESEARCH_TRAIT]           = "CURRENCY_CHANGE_REASON_RESEARCH_TRAIT",
  [CURRENCY_CHANGE_REASON_RESPEC_CHAMPION]          = "Respec champion",
  [CURRENCY_CHANGE_REASON_RESPEC_MORPHS]            = "Respec morphs",
  [CURRENCY_CHANGE_REASON_RESPEC_SKILLS]            = "Respec skills",
  [CURRENCY_CHANGE_REASON_REWARD]                   = "CURRENCY_CHANGE_REASON_REWARD",
  [CURRENCY_CHANGE_REASON_SELL_STOLEN]              = "Fence",
  [CURRENCY_CHANGE_REASON_SOULWEARY]                = "CURRENCY_CHANGE_REASON_SOULWEARY",
  [CURRENCY_CHANGE_REASON_SOUL_HEAL]                = "CURRENCY_CHANGE_REASON_SOUL_HEAL",
  [CURRENCY_CHANGE_REASON_STABLESPACE]              = "CURRENCY_CHANGE_REASON_STABLESPACE",
  [CURRENCY_CHANGE_REASON_STUCK]                    = "CURRENCY_CHANGE_REASON_STUCK",
  [CURRENCY_CHANGE_REASON_TRADE]                    = "Trade",
  [CURRENCY_CHANGE_REASON_TRADINGHOUSE_LISTING]     = "CURRENCY_CHANGE_REASON_TRADINGHOUSE_LISTING",
  [CURRENCY_CHANGE_REASON_TRADINGHOUSE_PURCHASE]    = "Guild store purchase",
  [CURRENCY_CHANGE_REASON_TRADINGHOUSE_REFUND]      = "Guild store refund",
  [CURRENCY_CHANGE_REASON_TRAIT_REVEAL]             = "CURRENCY_CHANGE_REASON_TRAIT_REVEAL",
  [CURRENCY_CHANGE_REASON_TRAVEL_GRAVEYARD]         = "Wayshrine",
  [CURRENCY_CHANGE_REASON_VENDOR]                   = "Vendor",
  [CURRENCY_CHANGE_REASON_VENDOR_LAUNDER]           = "Laundering",
  [CURRENCY_CHANGE_REASON_VENDOR_REPAIR]            = "Repairs"
}

for n, value in pairs(REASONS) do
  ZO_CreateStringId("SI_LEDGER_REASON" .. n, value)
end

ZO_CreateStringId("SI_BINDING_NAME_LEDGER_TOGGLE"   , "Open/close Ledger")

ZO_CreateStringId("SI_LEDGER_TITLE"                 , "Ledger")
ZO_CreateStringId("SI_LEDGER_EMPTY_DATA"            , "Welcome! Go get or spend some Gold and see your transactions appearing here.")
ZO_CreateStringId("SI_LEDGER_EMPTY_FILTER"          , "This filter has returned nothing.")
ZO_CreateStringId("SI_LEDGER_HEADER_TIMESTAMP"      , "Timestamp")
ZO_CreateStringId("SI_LEDGER_HEADER_CHARACTER"      , "Character")
ZO_CreateStringId("SI_LEDGER_HEADER_REASON"         , "Reason")
ZO_CreateStringId("SI_LEDGER_HEADER_VARIATION"      , "Variation")
ZO_CreateStringId("SI_LEDGER_HEADER_BALANCE"        , "Balance")
ZO_CreateStringId("SI_LEDGER_TIME_FRAME_1_DAY"      , "Last 1 day")
ZO_CreateStringId("SI_LEDGER_TIME_FRAME_1_WEEK"     , "Last 1 week")
ZO_CreateStringId("SI_LEDGER_TIME_FRAME_1_MONTH"    , "Last 1 month")
ZO_CreateStringId("SI_LEDGER_ALL_CHARACTERS"        , "All characters")
