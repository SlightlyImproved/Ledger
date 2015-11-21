
-- Fix bug when sorting ZO_SortHeaderGroup
-- esoui/libraries/zo_sortheadergroup/zo_sortheadergroup.lua:149
function Fix_ZO_SortHeaderGroup_OnHeaderClicked(ZO_SortHeaderGroup)
  function ZO_SortHeaderGroup:OnHeaderClicked(header, suppressCallbacks, forceReselect)
    if self:IsEnabled() then
      if forceReselect or not self:IsCurrentSelectedHeader(header) then
        self:DeselectHeader()
        self.sortDirection = header.initialDirection
      else
        self.sortDirection = not self.sortDirection
      end

      self:SelectHeader(header)

      if(not suppressCallbacks) then
        self:FireCallbacks(self.HEADER_CLICKED, header.key, self.sortDirection)
      end
    end
  end
end

-- Get numeric index of a value or nil
function table.indexOf(t, needle)
  for i = 1, #t do
    if t[i] == needle then
      return i
    end
  end
end
