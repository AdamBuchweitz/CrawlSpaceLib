
            --[[ ########## NewGroup Override  ########## ]--

At long last you may insert multiple objects into a group with
a single line! There is no syntax change, and you may still insert
object when instantiating the group.

:: USAGE ::

    myGroup:insert([index, ] myObject [, mySecondObject, myThirdObject, resetTransform])

:: EXAMPLE 1 ::

    local myGroup = u.display.newGroup()
    myGroup:insert(myImage, myRect, myRoundedRect, myImageRect)

:: EXAMPLE 2 ::

    local myGroup = u.display.newGroup(firstObject, secondObject)
    myGroup:insert(thirdObject, forthObject)

:: EXAMPLE 3 ::

    local myGroup = u.display.newGroup()
    myGroup:insert( 1, myObject, mySecondObject) -- inserting all objects at position 1

:: EXAMPLE 4 ::

    local myGroup = u.display.newGroup()
    myGroup:insert( myObject, mySecondObject, true) -- resetTransform still works too!

]]

local luau = u

u.helpArr.insert = 'myGroup:insert([index,] object1 [, object2, object3, resetTransform])'
local crawlspaceInsert = function(...)
    local t = {...}
    local b, reset = 0, nil
    if type(t[#t]) == "boolean" then b = 1; reset = t[#t] end
    if type(t[2]) == "number" then for i=3, #t-b do t[1]:cachedInsert(t[2],t[i],reset); if reset and t[i].text then t[i].xScale, t[i].yScale=.5,.5 end end
    else for i=2, #t-b do t[1]:cachedInsert(t[i],reset); if reset and t[i].text then t[i].xScale, t[i].yScale=.5,.5 end end
    end
end
u.cache.newGroup = display.newGroup
u.display.newGroup = function(...)
    local g = luau.cache.newGroup(...)
    g.cachedInsert = g.insert
    g.insert = crawlspaceInsert
    luau.displayMethods( g )
    return g
end

if not u.NOCONFLICT then display.newGroup = u.display.newGroup end
