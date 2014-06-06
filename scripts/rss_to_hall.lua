local feedparser = require('feedparser')

local hall_post_url = 'SET HALL.COM POSTING URL'
local feed_url = 'SET RSS FEED URL'
local rss_icon_url = 'SET RSS ICON IMAGE URL'

local response = http.request {
	url =	feed_url
}
local parsed = feedparser.parse(response.content)

if storage.rss_last_updated_parsed == nil then
	storage_last_updated_parsed = 0
else
  storage_last_updated_parsed = tonumber(storage.rss_last_updated_parsed)
end

log("storage_last_updated_parsed:" .. storage_last_updated_parsed)

local entries = {}
local last_updated_parsed = 0
for index, entry in pairs(parsed.entries) do
  if entry.updated_parsed > storage_last_updated_parsed then
		entries[entry.updated_parsed] = entry
		if last_updated_parsed < entry.updated_parsed then
  		last_updated_parsed = entry.updated_parsed
  	end
		log("entry.updated_parsed:" .. entry.updated_parsed)
  end
end

if last_updated_parsed ~= storage_last_updated_parsed then
	storage.rss_last_updated_parsed = tostring(last_updated_parsed)
	log("storage.rss_last_updated_parsed:" .. storage.rss_last_updated_parsed)
	table.sort(entries,
	  function(a, b)
			return a.updated_parsed < b.updated_parsed
		end)
end

local responses = {}
for updated_parsed, entry in pairs(entries) do
	local response = http.request {
		method = 'POST',
		url = hall_post_url,
		data = {
			title = parsed.feed.title,
			message = '<a href="' .. entry.link .. '">' .. entry.title .. '</a>\n' .. entry.summary,
			picture = rss_icon_url
		}
  }
	table.insert(responses, response)
end

return responses
