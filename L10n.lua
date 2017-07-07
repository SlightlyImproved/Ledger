-- L10n
-- The MIT License © 2016 Arthur Corenzan

function L10n_GetTimeZoneShift()
    local localTimeShift = GetSecondsSinceMidnight() - (GetTimeStamp() % 86400)
	if localTimeShift < -43200 then
        return localTimeShift + 86400
    else
        return localTimeShift
    end
end

function L10n_GetLocalizedDate(timestamp, language)
    language = language or GetCVar("Language.2")

    local string = GetDateStringFromTimestamp(timestamp + L10n_GetTimeZoneShift())

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
    return FormatTimeSeconds(timestamp % 86400 + L10n_GetTimeZoneShift(), TIME_FORMAT_STYLE_CLOCK_TIME, precision)
end

function L10n_GetLocalizedDateTime(...)
    return L10n_GetLocalizedDate(...) .. " " .. L10n_GetLocalizedTime(...)
end
