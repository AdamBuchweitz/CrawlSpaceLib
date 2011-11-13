
            --[[ ########## Global Content Scale and Suffix  ########## ]--

Checks the content scaling and sets a global var "u.scale". In addition,
if you use sprite sheets and was retina support, append the global "u.suffix"
variable when calling your datasheet, and it will pull the hi-res version
when it's needed. On the topic of devices and scals, when in the u.simulator,
the global variable "u.simulator" is set to true.

]]

u.scale, u.suffix = display.contentScaleX, ""
if u.scale < 1 then if u.scale > .5 then u.suffix = "@android" else u.suffix = "@2x" end end
--u.magicWidth, u.magicHeight = 760*u.scale, 1140*u.scale
u.magicWidth, u.magicHeight = 380, 570

if system.getInfo("environment") == "u.simulator" then u.simulator = true end
