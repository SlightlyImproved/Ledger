-- L10n
-- The MIT License © 2016 Arthur Corenzan

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
    local precision 
    if (language == "en") then
        precision = TIME_FORMAT_PRECISION_TWELVE_HOUR
    else
        precision = TIME_FORMAT_PRECISION_TWENTY_FOUR_HOUR
    end
    return FormatTimeSeconds((timestamp + L10n_GetTimeZone()) % 86400, TIME_FORMAT_STYLE_CLOCK_TIME, precision)
end

function L10n_GetLocalizedDateTime(...)
    return L10n_GetLocalizedDate(...) .. " " .. L10n_GetLocalizedTime(...)
end
