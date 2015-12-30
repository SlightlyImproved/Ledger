-- Ledger 1.4.2 (Dec 30 2015)
-- Licensed under CC BY-NC-SA 4.0
-- More at https://github.com/haggen/Ledger

local currencyChangeReasons =
{
  [CURRENCY_CHANGE_REASON_ABILITY_UPGRADE_PURCHASE] = "Fertigkeit erlernt",
  [CURRENCY_CHANGE_REASON_ACHIEVEMENT]              = "Errungenschaft",
  [CURRENCY_CHANGE_REASON_ACTION]                   = "Unbekannt (ACTION)",
  [CURRENCY_CHANGE_REASON_BAGSPACE]                 = "Inventarerweiterung",
  [CURRENCY_CHANGE_REASON_BANKSPACE]                = "Bankerweiterung",
  [CURRENCY_CHANGE_REASON_BANK_DEPOSIT]             = "Bankeinzahlung",
  [CURRENCY_CHANGE_REASON_BANK_WITHDRAWAL]          = "Bankabhebung",
  [CURRENCY_CHANGE_REASON_BATTLEGROUND]             = "Unbekannt (BATTLEGROUND)",
  [CURRENCY_CHANGE_REASON_BOUNTY_CONFISCATED]       = "Kopfgeld eingezogen",
  [CURRENCY_CHANGE_REASON_BOUNTY_PAID_FENCE]        = "Kopfgeld gezahlt (Hehler)",
  [CURRENCY_CHANGE_REASON_BOUNTY_PAID_GUARD]        = "Kopfgeld gezahlt (Wache)",
  [CURRENCY_CHANGE_REASON_BUYBACK]                  = "Rückkauf",
  [CURRENCY_CHANGE_REASON_CASH_ON_DELIVERY]         = "Bargeld durch Lieferung",
  [CURRENCY_CHANGE_REASON_COMMAND]                  = "Unbekannt (COMMAND)",
  [CURRENCY_CHANGE_REASON_CONSUME_FOOD_DRINK]       = "Unbekannt (CONSUME_FOOD_DRINK)",
  [CURRENCY_CHANGE_REASON_CONSUME_POTION]           = "Unbekannt (CONSUME_POTION)",
  [CURRENCY_CHANGE_REASON_CONVERSATION]             = "Unbekannt (CONVERSATION)",
  [CURRENCY_CHANGE_REASON_CRAFT]                    = "Handwerk",
  [CURRENCY_CHANGE_REASON_DECONSTRUCT]              = "Zerlegen",
  [CURRENCY_CHANGE_REASON_EDIT_GUILD_HERALDRY]      = "Unbekannt (EDIT_GUILD_HERALDRY)",
  [CURRENCY_CHANGE_REASON_FEED_MOUNT]               = "Pferd (Erhöhung der Tragkraft)",
  [CURRENCY_CHANGE_REASON_GUILD_BANK_DEPOSIT]       = "Bankeinzahlung (Gilde)",
  [CURRENCY_CHANGE_REASON_GUILD_BANK_WITHDRAWAL]    = "Bank entnahme (Gilde)",
  [CURRENCY_CHANGE_REASON_GUILD_FORWARD_CAMP]       = "Unbekannt (GUILD_FORWARD_CAMP)",
  [CURRENCY_CHANGE_REASON_GUILD_STANDARD]           = "Unbekannt (GUILD_STANDARD)",
  [CURRENCY_CHANGE_REASON_GUILD_TABARD]             = "Wappenrock",
  [CURRENCY_CHANGE_REASON_HARVEST_REAGENT]          = "Unbekannt (HARVEST_REAGENT)",
  [CURRENCY_CHANGE_REASON_HOOKPOINT_STORE]          = "Unbekannt (HOOKPOINT_STORE)",
  [CURRENCY_CHANGE_REASON_JUMP_FAILURE_REFUND]      = "Unbekannt (JUMP_FAILURE_REFUND)",
  [CURRENCY_CHANGE_REASON_KEEP_REPAIR]              = "Bergfriedreperatur",
  [CURRENCY_CHANGE_REASON_KEEP_REWARD]              = "Bergfriedbelohnung",
  [CURRENCY_CHANGE_REASON_KEEP_UPGRADE]             = "Bergfriederweiterung",
  [CURRENCY_CHANGE_REASON_KILL]                     = "Unbekannt (KILL)",
  [CURRENCY_CHANGE_REASON_LOOT]                     = "Loot",
  [CURRENCY_CHANGE_REASON_LOOT_STOLEN]              = "Gestohlen",
  [CURRENCY_CHANGE_REASON_MAIL]                     = "Nachricht",
  [CURRENCY_CHANGE_REASON_MEDAL]                    = "Unbekannt (MEDAL)",
  [CURRENCY_CHANGE_REASON_PICKPOCKET]               = "Taschendiebstahl",
  [CURRENCY_CHANGE_REASON_PLAYER_INIT]              = "Unbekannt (PLAYER_INIT)",
  [CURRENCY_CHANGE_REASON_PVP_RESURRECT]            = "Unbekannt (PVP_RESURRECT)",
  [CURRENCY_CHANGE_REASON_QUESTREWARD]              = "Questbelohnung",
  [CURRENCY_CHANGE_REASON_RECIPE]                   = "Unbekannt (RECIPE)",
  [CURRENCY_CHANGE_REASON_REFORGE]                  = "Unbekannt (REFORGE)",
  [CURRENCY_CHANGE_REASON_RESEARCH_TRAIT]           = "Unbekannt (RESEARCH_TRAIT)",
  [CURRENCY_CHANGE_REASON_RESPEC_CHAMPION]          = "Championzurücksetzung",
  [CURRENCY_CHANGE_REASON_RESPEC_MORPHS]            = "Morphzurücksetzung",
  [CURRENCY_CHANGE_REASON_RESPEC_SKILLS]            = "Fertigkeitszurücksetzung",
  [CURRENCY_CHANGE_REASON_REWARD]                   = "Unbekannt (REWARD)",
  [CURRENCY_CHANGE_REASON_SELL_STOLEN]              = "Hehler",
  [CURRENCY_CHANGE_REASON_SOULWEARY]                = "Unbekannt (SOULWEARY)",
  [CURRENCY_CHANGE_REASON_SOUL_HEAL]                = "Unbekannt (SOUL_HEAL)",
  [CURRENCY_CHANGE_REASON_STABLESPACE]              = "Unbekannt (STABLESPACE)",
  [CURRENCY_CHANGE_REASON_STUCK]                    = "Unbekannt (STUCK)",
  [CURRENCY_CHANGE_REASON_TRADE]                    = "Handel",
  [CURRENCY_CHANGE_REASON_TRADINGHOUSE_LISTING]     = "Unbekannt (TRADINGHOUSE_LISTING)",
  [CURRENCY_CHANGE_REASON_TRADINGHOUSE_PURCHASE]    = "Gildenladenkauf",
  [CURRENCY_CHANGE_REASON_TRADINGHOUSE_REFUND]      = "Gildenladenverkauf",
  [CURRENCY_CHANGE_REASON_TRAIT_REVEAL]             = "Unbekannt (TRAIT_REVEAL)",
  [CURRENCY_CHANGE_REASON_TRAVEL_GRAVEYARD]         = "Wegschrein",
  [CURRENCY_CHANGE_REASON_VENDOR]                   = "Verkäufer",
  [CURRENCY_CHANGE_REASON_VENDOR_LAUNDER]           = "Geldwäsche",
  [CURRENCY_CHANGE_REASON_VENDOR_REPAIR]            = "Reperaturen",
}

for i, value in pairs(currencyChangeReasons) do
  ZO_CreateStringId("SI_LEDGER_REASON" .. i, value)
end

ZO_CreateStringId("SI_BINDING_NAME_LEDGER_TOGGLE"   , "Hauptbuch öffnen/schließen")
ZO_CreateStringId("SI_LEDGER_TITLE"                 , "Hauptbuch")
ZO_CreateStringId("SI_LEDGER_EMPTY"                 , "Wenn du Gold bekommst oder ausgibt wird es hier aufgezeichnet.")
ZO_CreateStringId("SI_LEDGER_HEADER_TIMESTAMP"      , "Zeitpunkt")
ZO_CreateStringId("SI_LEDGER_HEADER_CHARACTER"      , "Charakter")
ZO_CreateStringId("SI_LEDGER_HEADER_REASON"         , "Grund")
ZO_CreateStringId("SI_LEDGER_HEADER_VARIATION"      , "Veränderung")
ZO_CreateStringId("SI_LEDGER_HEADER_BALANCE"        , "Kontostand")
ZO_CreateStringId("SI_LEDGER_PERIOD_1_HOUR"         , "1 Stunde")
ZO_CreateStringId("SI_LEDGER_PERIOD_1_DAY"          , "1 Tag")
ZO_CreateStringId("SI_LEDGER_PERIOD_1_WEEK"         , "1 Woche")
ZO_CreateStringId("SI_LEDGER_PERIOD_1_MONTH"        , "1 Monat")
ZO_CreateStringId("SI_LEDGER_ALL_CHARACTERS"        , "Alle Charaktere")
ZO_CreateStringId("SI_LEDGER_MERGE_LABEL"           , "Ähnliche zusammenführen")
ZO_CreateStringId("SI_LEDGER_SUMMARY"               , "Kontostand änderte sich um <<1>> in |cC4C19B<<z:2>>|r. Größte Ausgabe war |cC4C19B<<3>>|r (<<4>>) und größte Einnahme |cC4C19B<<5>>|r (<<6>>).")
ZO_CreateStringId("SI_LEDGER_SUMMARY_EMPTY"         , "")
