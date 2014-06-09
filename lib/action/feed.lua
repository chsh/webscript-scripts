local Class = {}
Class.new = function(feed)
  local this = {}
  this.feed = feed

  this.each_entries = function(self, last_updated_at, processor)
    if last_updated_at == nil then
      last_updated_at = 0
    else
      last_updated_at = tonumber(last_updated_at)
    end
    local updated_entries = self:updated_entries(last_updated_at)
    if updated_entries == {} then
      return nil
    else
      table.sort(updated_entries,
        function(a, b)
          return a.updated_parsed < b.updated_parsed
        end)
			local responses = {}
      for updated_parsed, entry in pairs(updated_entries) do
				local r = processor(entry)
        table.insert(responses, r)
        if last_updated_at < entry.updated_parsed then
          last_updated_at = entry.updated_parsed
        end
      end
      return last_updated_at, responses
    end
  end
  this.updated_entries = function(self, last_updated_at)
    local entries = {}
    for index, entry in pairs(self.feed.entries) do
      if entry.updated_parsed > last_updated_at then
        entries[entry.updated_parsed] = entry
      end
    end
    return entries
  end
  return this
end
return Class
