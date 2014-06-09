local feedparser = require('feedparser')

local Hall = require 'chsh/webscript-scripts/lib/hall'
local H = require 'chsh/webscript-scripts/lib/html'

-- Configuration
local C = {
  hall_api_token = 'HALL-API-TOKEN-FOR-ROOM',
  rss_feed_url = 'SET RSS FEED URL'
}

local response = http.request {
	url =	C.rss_feed_url
}
local parsed = feedparser.parse(response.content)

-- Initialize
local hall = Hall.new(C.hall_api_token, parsed.feed.title, 'rss')

local storage_key = 'rss ' .. C.rss_feed_url .. ' last_updated_parsed'

if storage[storage_key] == nil then
	storage_last_updated_parsed = 0
else
  storage_last_updated_parsed = tonumber(storage[storage_key])
end

local entries = {}
local last_updated_parsed = 0
for index, entry in pairs(parsed.entries) do
  if entry.updated_parsed > storage_last_updated_parsed then
		entries[entry.updated_parsed] = entry
		if last_updated_parsed < entry.updated_parsed then
  		last_updated_parsed = entry.updated_parsed
  	end
  end
end

if last_updated_parsed ~= storage_last_updated_parsed then
	storage[storage_key] = tostring(last_updated_parsed)
	table.sort(entries,
	  function(a, b)
			return a.updated_parsed < b.updated_parsed
		end)
end

local responses = {}
for updated_parsed, entry in pairs(entries) do
	local response = http.request {
		hall:post({
		  heading = H.link(entry.title, entry.link),
			message: entry.summary
		})
  }
	responses:insert(response)
end

return responses
