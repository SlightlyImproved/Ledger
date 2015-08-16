
local REASONS = {
  [CURRENCY_CHANGE_REASON_ABILITY_UPGRADE_PURCHASE] = "Ability upgrade",
  [CURRENCY_CHANGE_REASON_ACHIEVEMENT]              = "Achievement",
  [CURRENCY_CHANGE_REASON_ACTION]                   = nil,
  [CURRENCY_CHANGE_REASON_BAGSPACE]                 = "Bag upgrade",
  [CURRENCY_CHANGE_REASON_BANKSPACE]                = "Bank upgrade",
  [CURRENCY_CHANGE_REASON_BANK_DEPOSIT]             = "Bank deposit",
  [CURRENCY_CHANGE_REASON_BANK_WITHDRAWAL]          = "Bank withdrawal",
  [CURRENCY_CHANGE_REASON_BATTLEGROUND]             = nil,
  [CURRENCY_CHANGE_REASON_BOUNTY_CONFISCATED]       = "Bounty confiscated",
  [CURRENCY_CHANGE_REASON_BOUNTY_PAID_FENCE]        = "Bounty paid (fence)",
  [CURRENCY_CHANGE_REASON_BOUNTY_PAID_GUARD]        = "Bounty paid (guard)",
  [CURRENCY_CHANGE_REASON_BUYBACK]                  = "Buyback",
  [CURRENCY_CHANGE_REASON_CASH_ON_DELIVERY]         = "Cash on delivery",
  [CURRENCY_CHANGE_REASON_COMMAND]                  = nil,
  [CURRENCY_CHANGE_REASON_CONSUME_FOOD_DRINK]       = nil,
  [CURRENCY_CHANGE_REASON_CONSUME_POTION]           = nil,
  [CURRENCY_CHANGE_REASON_CONVERSATION]             = nil,
  [CURRENCY_CHANGE_REASON_CRAFT]                    = "Crafting",
  [CURRENCY_CHANGE_REASON_DECONSTRUCT]              = "Deconstruction",
  [CURRENCY_CHANGE_REASON_EDIT_GUILD_HERALDRY]      = nil,
  [CURRENCY_CHANGE_REASON_FEED_MOUNT]               = nil,
  [CURRENCY_CHANGE_REASON_GUILD_BANK_DEPOSIT]       = "Bank deposit (guild)",
  [CURRENCY_CHANGE_REASON_GUILD_BANK_WITHDRAWAL]    = "Bank withdrawal (guild)",
  [CURRENCY_CHANGE_REASON_GUILD_FORWARD_CAMP]       = nil,
  [CURRENCY_CHANGE_REASON_GUILD_STANDARD]           = nil,
  [CURRENCY_CHANGE_REASON_GUILD_TABARD]             = "Guild tabard",
  [CURRENCY_CHANGE_REASON_HARVEST_REAGENT]          = nil,
  [CURRENCY_CHANGE_REASON_HOOKPOINT_STORE]          = nil,
  [CURRENCY_CHANGE_REASON_JUMP_FAILURE_REFUND]      = nil,
  [CURRENCY_CHANGE_REASON_KEEP_REPAIR]              = "Keep repair",
  [CURRENCY_CHANGE_REASON_KEEP_REWARD]              = "Keep reward",
  [CURRENCY_CHANGE_REASON_KEEP_UPGRADE]             = "Keep upgrade",
  [CURRENCY_CHANGE_REASON_KILL]                     = nil,
  [CURRENCY_CHANGE_REASON_LOOT]                     = "Loot",
  [CURRENCY_CHANGE_REASON_LOOT_STOLEN]              = "Theft",
  [CURRENCY_CHANGE_REASON_MAIL]                     = "Mail attachment",
  [CURRENCY_CHANGE_REASON_MEDAL]                    = nil,
  [CURRENCY_CHANGE_REASON_PICKPOCKET]               = "Mugging",
  [CURRENCY_CHANGE_REASON_PLAYER_INIT]              = nil,
  [CURRENCY_CHANGE_REASON_PVP_RESURRECT]            = nil,
  [CURRENCY_CHANGE_REASON_QUESTREWARD]              = "Quest reward",
  [CURRENCY_CHANGE_REASON_RECIPE]                   = nil,
  [CURRENCY_CHANGE_REASON_REFORGE]                  = nil,
  [CURRENCY_CHANGE_REASON_RESEARCH_TRAIT]           = nil,
  [CURRENCY_CHANGE_REASON_RESPEC_CHAMPION]          = "Respec champion",
  [CURRENCY_CHANGE_REASON_RESPEC_MORPHS]            = "Respec morphs",
  [CURRENCY_CHANGE_REASON_RESPEC_SKILLS]            = "Respec skills",
  [CURRENCY_CHANGE_REASON_REWARD]                   = nil,
  [CURRENCY_CHANGE_REASON_SELL_STOLEN]              = "Fence",
  [CURRENCY_CHANGE_REASON_SOULWEARY]                = nil,
  [CURRENCY_CHANGE_REASON_SOUL_HEAL]                = nil,
  [CURRENCY_CHANGE_REASON_STABLESPACE]              = "Stable",
  [CURRENCY_CHANGE_REASON_STUCK]                    = nil,
  [CURRENCY_CHANGE_REASON_TRADE]                    = "Trade",
  [CURRENCY_CHANGE_REASON_TRADINGHOUSE_LISTING]     = nil,
  [CURRENCY_CHANGE_REASON_TRADINGHOUSE_PURCHASE]    = "Guild store purchase",
  [CURRENCY_CHANGE_REASON_TRADINGHOUSE_REFUND]      = "Guild store refund",
  [CURRENCY_CHANGE_REASON_TRAIT_REVEAL]             = nil,
  [CURRENCY_CHANGE_REASON_TRAVEL_GRAVEYARD]         = nil,
  [CURRENCY_CHANGE_REASON_VENDOR]                   = "Vendor",
  [CURRENCY_CHANGE_REASON_VENDOR_LAUNDER]           = "Laundering",
  [CURRENCY_CHANGE_REASON_VENDOR_REPAIR]            = "Repairs"
}

for n, value in pairs(REASONS) do
  ZO_CreateStringId("SI_LEDGER_REASON" .. n, value)
end

ZO_CreateStringId("SI_LEDGER_HEADER_TIMESTAMP" , "Timestamp")
ZO_CreateStringId("SI_LEDGER_HEADER_CHARACTER" , "Character")
ZO_CreateStringId("SI_LEDGER_HEADER_REASON"    , "Reason")
ZO_CreateStringId("SI_LEDGER_HEADER_VARIATION" , "Variation")
ZO_CreateStringId("SI_LEDGER_HEADER_BALANCE"   , "Balance")
ZO_CreateStringId("SI_LEDGER_TITLE"            , "Ledger")
