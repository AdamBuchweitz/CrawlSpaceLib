
--[[### Split ###]--
    #
    # Summary:      Splits a passed string via a pattern into a table.
                    The pattern can be any string and if it is omitted will
                    be defaulted to ' ' and the string split into words.
    # Parameters:   String, Pattern - defaults to a space
    # Returns:      Table
    #
    #]]


u.string = u.string or string
local find = string.find
local sub  = string.sub
local split = function(string, pattern)
    local table = {}
    local fpat = "(.-)" .. (pattern or " ")
    local last_end = 1
    local splitString, e, cap = find(string, fpat, 1)

    while splitString do
        if splitString ~= 1 or cap ~= "" then
            table[#table+1] = cap
        end
        last_end = e+1
        splitString, e, cap = find(string, fpat, last_end)
    end

    if last_end <= #string then
        cap = sub(string, last_end)
        table[#table+1] = cap
    end

    return table
end
u.string.split = split
