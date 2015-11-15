-- L10n 1.1 Fri Aug 28 20:30:10 BRT 2015
--

function L10n_GetTimeZone()
  return GetSecondsSinceMidnight() - (GetTimeStamp() % 86400)
end

function L10n_GetLocalizedDate(timestamp, language)
  language = language or GetCVar("Language.2")

  local string = GetDateStringFromTimestamp(timestamp + L10n_GetTimeZone())

  if language == "en" then
    return string
  else
    return string.gsub(string, "^(%d+)/(%d+)", "%2/%1")
  end
end

function L10n_GetLocalizedTime(timestamp, language)
  language = language or GetCVar("Language.2")

  local precision = (language == "en") and TIME_FORMAT_PRECISION_TWELVE_HOUR or TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR
  return FormatTimeSeconds((timestamp + L10n_GetTimeZone()) % 86400, TIME_FORMAT_STYLE_CLOCK_TIME, precision)
end

function L10n_GetLocalizedDateTime(...)
  return L10n_GetLocalizedDate(...) .. " " .. L10n_GetLocalizedTime(...)
end
