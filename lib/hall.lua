-- lua module to post to Hall web messaging service.
local Class = {}
Class.new = function(token, title, picture_url)
  local this = {}
  this.token = token
  this.title = title
  if picture_url == nil then
    picture_url = title:lower()
  end
  if picture_url:find("^https?://") == nil then
    picture_url =
      "https://raw.github.com/chsh/webscript-scripts/master/images/"..
      picture_url..".png"
  end
  this.picture_url = picture_url
  this.post_url = 'https://hall.com/api/1/services/generic/'..token

  this.post = function(self, params)
    local response = http.request {
      method = 'POST',
      url = self.post_url,
      data = {
        title = self.title,
        message = params.heading .. '\n' .. params.message,
        picture = self.picture_url
      }
    }
    return response
  end

  return this
end

return Class
