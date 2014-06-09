
local Hall = require 'chsh/webscript-scripts/lib/hall'
local H = require 'chsh/webscript-scripts/lib/html'

local hall = Hall.new('HALL-API-TOKEN-FOR-ROOM', 'GitHub')

-- describe responsible actions
local event_actions = {
	issues = {
	  opened = function(payload)
			local heading = H.strong('New issue')..
        ' opened by ' .. H.link(payload.issue.user.login, payload.issue.user.url)..
  		  '; ' .. H.link(payload.issue.title, payload.issue.html_url)..
			  ' of '..payload.repository.full_name
      local message = payload.issue.body
			return {
				heading = heading,
        message = message
			}
		end
	},
	issue_comment = {
		created = function(payload)
      local heading = H.strong('New comment')..
        ' by ' .. H.link(payload.comment.user.login, payload.comment.user.url)..
        ' on issue '..H.link(payload.issue.title, payload.comment.html_url)..
        ' of '..payload.repository.full_name
      local message = payload.comment.body
			return {
				heading = heading,
        message = message
			}
		end
	}
}

local event = request.headers['X-Github-Event']
local event_action = event_actions[event]

if event_action ~= nil then
  local payload = json.parse(request.body)
  local action = event_action[payload.action]
	if action ~= nil then
    hall:post(action(payload))
	end
end

return 200
