-- Breton's data toolbox
--
-- Collection of functions in for
-- table query and manipulation.
--
-- Version: 1.0.0 Sun Aug 30 02:11:24 BRT 2015
-- Arthur: Arthur <arthur@corenzan.com>
--

-- Map given table to a new one.
--
-- e.g.
-- Breton_Map({1, 2, 3}, function(_, n) return n * 2 end) => {2, 4, 6}
--
function Breton_Map(t, fn)
  local mt = {}

  for k, v in pairs(t) do
    mt[k] = fn(k, v)
  end

  return mt
end

-- Group items from a table.
--
-- e.g.
-- Breton_Group({1, 2, 3}, function(_, n) return (n % 0 == 0), n end) => {true = {2}, false = {1, 3}}
--
function Breton_Group(t, fn)
  local gt = {}

  for k, v in pairs(t) do
    local gk, gv = fn(k, v)

    if gt[gk] == nil then
      gt[gk] = { gv }
    else
      table.insert(gt[gk], gv)
    end
  end

  return gt
end

-- Reduce a table to a single value.
--
-- e.g.
-- Breton_Reduce({2, 2, 2}, 0, function(_, n, sum) return sum + n end) => 6
--
function Breton_Reduce(t, n, fn)
  for k, v in pairs(t) do
    n = fn(k, v, n)
  end

  return n
end

-- Aggregate values from
-- a table of tables.
--
-- The `group` function groups the
-- tables by key (see #group above).
--
-- The `finalize` function is used
-- to calculate the final result.
--
-- e.g.
-- local group = function(_, n) return 1, n end
-- local finalize = function(key, values) return #values end
-- Breton_Aggregate({2, 2, 2}, group, finalize) => {1 => 3}
--
function Breton_Aggregate(t, group, finalize)
  local gt = Breton_Group(t, group)
  local at = {}

  for k, v in pairs(gt) do
    table.insert(at, finalize(k, v))
  end

  return at
end

-- ...
--
-- e.g.
-- Breton_Find({1, 2, 3}, function(_, n) return n > 2 end) => 3
--
function Breton_Find(t, fn)
  local ft = {}

  for k, v in pairs(t) do
    if fn(k, v) then
      return k, v
    end
  end

  return false
end

-- ...
--
-- e.g.
-- Breton_Filter({1, 2, 3}, function(_, n) return n > 1 end) => {2, 3}
--
function Breton_Filter(t, fn)
  local ft = {}

  for k, v in pairs(t) do
    local match, stop = fn(k, v, ft)

    if match then
      table.insert(ft, v)
    end

    if stop then break end
  end

  return ft
end

-- Make a deep comparison of
-- values in table 1 and 2.
--
-- In Lua `t1 == t2` evaluates to false
-- unless both tables are the same object.
-- This returns true whenever both tables
-- have the same keys and equivalent values.
--
-- e.g.
-- Breton_Compare({1, 2, 3}, {1, 2, 3}) => true
--
function Breton_Compare(t1, t2)
  for k, v in pairs(t1) do
    if type(v) == "table" then
      if not Breton_Compare(v, t2[k]) then
        return false
      end
    else
      if v ~= t2[k] then
        return false
      end
    end
  end

  return true
end
