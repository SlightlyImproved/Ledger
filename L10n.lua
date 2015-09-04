-- L10n 1.0 Fri Aug 28 20:30:10 BRT 2015
--
-- About:
-- ...
--
-- The most simple use would be calling the function `L10n_GetLocalizedDateTime()`.
--
-- Say you're running this in New York, which is UTC-9
-- you would get something like this: "8/28/2015 7:07 P.M.".
--
-- Now if someone did the same in Berlin, using a German
-- game client, it would be this: "29/8/2015 1:07".
--
-- The string is localized to the player's timezone,
-- and is using the proper format for the game client.
--
-- You can also provide both a custom `timestamp` and `language`,
-- but note that the `timestamp` MUST be in UTC/GMT time.
--
-- The currently acceptable languages are "en", "de" and "fr".
--
-- See more examples:
--
-- L10n_GetLocalizedDateTime(1440804257, "en") --> "8/28/2015 8:24 P.M." (in UTC-3)
-- L10n_GetLocalizedDateTime(1440804257, "de") --> "28/8/2015 20:24" (in UTC-3)
--

-- Return the difference of your timezone in seconds.
-- Credits to `votan` http://www.esoui.com/forums/member.php?u=13996
function L10n_GetTimeZone()
  local localTimeShift = GetSecondsSinceMidnight() - (GetTimeStamp() % 86400)
  if localTimeShift < -43200 then localTimeShift = localTimeShift + 86400 end
  return localTimeShift
end

-- Accepts:
-- a) a timestamp and a language, e.g. 1234567, "en"; or
-- b) a language, e.g. "en", and the timestamp is of now; or
-- c) nothing, and the language is read from the game client.
--
-- Returns a string with the date in one of the following formats:
-- MM/DD/YYYY when `language` is "en", DD/MM/YYYY otherwise.
function L10n_GetLocalizedDate(timestamp, language)
  language = language or GetCVar("Language.2")

  if type(timestamp) == "string" then
    timestamp, language = GetTimeStamp(), timestamp
  end

  if timestamp == nil then
    timestamp = GetTimeStamp()
  end

  local string = GetDateStringFromTimestamp(timestamp + L10n_GetTimeZone())

  if language == "en" then
    return string
  else
    return string.gsub(string, "^(%d+)/(%d+)", "%2/%1")
  end
end

-- Accepts:
-- a) a timestamp and a language, e.g. 1234567, "en"; or
-- b) a language, e.g. "en", and the timestamp is of now; or
-- c) nothing, and the language is read from the game client.
--
-- Returns a string with the time in one of the following formats:
-- 12:59am when `language` is "en", 23:59 otherwise.
function L10n_GetLocalizedTime(timestamp, language)
  language = language or GetCVar("Language.2")

  if type(timestamp) == "string" then
    timestamp, language = GetTimeStamp(), timestamp
  end

  if timestamp == nil then
    timestamp = GetTimeStamp()
  end

  local precision

  if language == "en" then
    precision = TIME_FORMAT_PRECISION_TWELVE_HOUR
  else
    precision = TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR
  end

  return ZO_FormatTime(timestamp + L10n_GetTimeZone(), TIME_FORMAT_STYLE_CLOCK_TIME, precision)
end

-- Accepts:
-- a) a timestamp and a language, e.g. 1234567, "en"; or
-- b) a language, e.g. "en", and the timestamp is of now; or
-- c) nothing, and the language is read from the game client.
--
-- Returns a string with the date and time in one of the above
-- formats, see L10n_GetLocalizedTime and L10n_GetLocalizedDate.
function L10n_GetLocalizedDateTime(...)
  return L10n_GetLocalizedDate(...) .. " " .. L10n_GetLocalizedTime(...)
end
