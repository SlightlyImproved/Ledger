-- Ledger
-- The MIT License © 2016 Arthur Corenzan

-- Get numeric index of a value or nil
function table.indexOf(t, needle)
    for i = 1, #t do
        if t[i] == needle then
            return i
        end
    end
end
