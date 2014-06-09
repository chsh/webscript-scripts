
local Class = {
  viscomp = function(str)
    str = str:
      gsub('%s+', ' '):
		  gsub('^ +', ''):
		  gsub(' +$', ''):
		  gsub(' +', ' ')
		return str
  end
}
return Class
