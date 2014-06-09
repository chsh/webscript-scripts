-- lua module to generate hmtl tags


local function link(text, url)
  return '<a href="' .. url .. '">' .. text .. '</a>'
end
local function tag(tag, string)
  return '<' .. tag .. '>' .. string .. '</' .. tag .. '>'
end
local function strong(string)
	return tag('strong', string)
end

return {
  link = link,
  tag = tag,
  strong = strong
}
