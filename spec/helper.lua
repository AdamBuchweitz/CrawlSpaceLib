local empty  = {}
empty.table  = function(...) return {}   end 
empty.string = function(...) return ""   end
empty.int    = function(...) return 0    end 
empty.null   = function(...) return null end 
local e      = empty

system = {}
system.getTimer = e.table
system.getInfo  = e.string

math = {}
math.randomseed = e.table
math.random     = e.table
math.ceil       = e.int

display = {}
display.contentCenterX = 0
display.contentCenterY = 0
display.screenOriginX  = 0
display.screenOriginY  = 0
display.contentWidth   = 0
display.contentHeight  = 0
display.contentScaleX  = 0
display.contentScaleY  = 0

transition = {}
transition.cancel = e.null

sprite = {}

audio = {}
audio.reserveChannels = e.null

timer = {}

native = {}

network = {}
network.request = e.null

local cacherequire = require
require = function(module)
	if module == "sprite" then
		return sprite
	elseif module == "audio" then
		return audio
	else
		return cacherequire(module)
	end
end