
            --[[ ########## Extended Table Functions ########## ]--

]]

u.tonum  = tonumber
local random = math.random

u.table = u.table or table
u.table.shuffle = function( a )
    local c = #a
    for i=1, (c * 20) do
        local x, y = u.tonum(r(1,c)), u.tonum(r(1,c))
        a[x], a[y] = a[y], a[x]
    end
    return a
end

u.table.search = function( table, v )
    for k,value in pairs(table) do
        if v == value then return k end
    end
end

u.table.copy = function( table )
    local t2 = {}
    for k,v in pairs( table ) do
        t2[k] = v
    end
    return t2
end

u.table.instances = function( table, v )
    local num = 0
    for i=1, #table do
        if table[i] == v then
            num = num + 1
        end
    end
    return num
end
