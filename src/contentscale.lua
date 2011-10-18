
            --[[ ########## Global Content Scale and Suffix  ########## ]--

Checks the content scaling and sets a global var "scale". In addition,
if you use sprite sheets and was retina support, append the global "suffix"
variable when calling your datasheet, and it will pull the hi-res version
when it's needed. On the topic of devices and scals, when in the simulator,
the global variable "simulator" is set to true.

]]

scale, suffix = display.contentScaleX, ""
if scale < 1 then if scale > .5 then suffix = "@android" else suffix = "@2x" end end
--magicWidth, magicHeight = 760*scale, 1140*scale
magicWidth, magicHeight = 380, 570

if system.getInfo("environment") == "simulator" then simulator = true end
