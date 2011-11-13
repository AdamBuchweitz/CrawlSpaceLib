
            --[[ ########## Saving and Loading ########## ]--

This bit has been mostly barrowed from the Ansca documentation,
we simply made it easier to use.

You keep one table of information, with as many properties
as you like. Simply pass this table into to Save() and it
will be taken care of. To load it, just call Load() which
returns the table.


:: SAVING EXAMPLE ::

    local myData     = {}
    myData.bestScore = 500
    myData.volume    = .8

    Save(myData)

:: LOADING EXAMPLE ::

    local myData = Load()
    print(myData.bestScore) <== 500
    print(myData.volume)    <== .8

]]

local tonum    = tonumber
local tostring = tostring
local Data     = {}


--[[### Save ###]--
    #
    # Summary:      Saves a table to a text file in the documents directory.
                    If no file name is passed, it is defaulted to 'data.txt',
                    and if no table is passed, it is assumed to be saving the
                    Data table, set by using the Defaults method. With this
                    set up you can simply declare your defaults that you would
                    like to save, then Load() on applicationStart and Save()
                    whenever you change any of the defaults and all your info
                    will be handled without a headache.

                    Save and Load support a table depth of 2. Meaning you can
                    have a table of tables, but not a table of tables of tables.
    # Parameters:   Table, File Name
    # Returns:      Nothing
    #
    #]]

u.helpArr.Save = 'Save(table [, filename])'
u.helpArr.save = 'Did you mean "Save" ?'
u.Save = function(table, fileName)
    local filePath = system.pathForFile( fileName or "data.txt", system.DocumentsDirectory )
    local file = io.open( filePath, "w" )

    for k,v in pairs( table or Data ) do
        if type(v) == "table" then
            for k2,v2 in pairs( v ) do
                file:write( k .. ":" .. k2 .. "=" .. tostring(v2) .. "~" )
            end
        else
            file:write( k .. "=" .. tostring(v) .. "~" )
        end
    end

    io.close( file )
end


--[[### Load ###]--
    #
    # Summary:      
    # Parameters:   Table
    # Returns:      Nothing
    #
    #]]

u.helpArr.Load = 'local mySavedData = Load([filename])'
u.helpArr.load = 'Did you mean "Load"?'
u.Load = function(fileName)
    local filePath = system.pathForFile( fileName or "data.txt", system.DocumentsDirectory )
    local file = io.open( filePath, "r" )

    if file then
        local dataStr = file:read( "*a" )
        local datavars = split(dataStr, "~")
        local dataTableNew = {}

        for k,v in pairs(datavars) do
            if string.find(tostring(v),":") then
                local table = split(v, ":")
                local pair = split(table[2], "=")
                if pair[2] == "true" then pair[2] = true
                elseif pair[2] == "false" then pair[2] = false
                elseif u.tonum(pair[2]) then pair[2] = u.tonum(pair[2]) end
                if not dataTableNew[u.tonum(table[1]) or table[1]] then dataTableNew[u.tonum(table[1]) or table[1]] = {} end
                dataTableNew[u.tonum(table[1]) or table[1]][u.tonum(pair[1]) or pair[1]] = pair[2]
            else
                local pair = split(v, "=")
                if pair[2] == "true" then pair[2] = true
                elseif pair[2] == "false" then pair[2] = false
                elseif u.tonum(pair[2]) then pair[2] = u.tonum(pair[2]) end
                dataTableNew[pair[1]] = pair[2]
            end
        end

        io.close( file ) -- important!
        if not fileName then
            for k,v in pairs(dataTableNew) do Data[k] = v; setVar{k,v,true} end
        end
        return dataTableNew
    else
        u.print("No data to load yet.")
        return false
    end
end

--[[### Defaults ###]--
    #
    # Summary:      Asssigns all passed key / pair values to a Data table,
                    as well as registers them for getVar access. The value
                    of this is that these variables will be automatically
                    saved when Save() is called
    # Parameters:   Table
    # Returns:      Nothing
    #
    #]]

u.Defaults = function(d)
    for k,v in pairs(d) do
        Data[k] = v
        setVar{k,v,true}
    end
end


            --[[ ########## Global Information Handling ########## ]--

Some of you may choose not to use this set of functions because global
information is generally a bad idea. What I use this for is tracking data
across the entire app, that may need to be changes in any one of a myriad
different files. For me the trade off is worth it. In main.lua I register
whatever variables I will need to track, and many of those I retrieve on
applicationExit to save them for use on next launch. Other than saving data,
it's very helpful to use these to keep track of a score, or a volume level,
whether or not to play SFX, etc.

This set of functions is left accessible via crawlspaceLib.registerVariable
because if you find yourself using them often you will want them localized.

As a side note, Crawl Space Library automatically registers a variable for
'volume' and 'sfx', as these are going to be used in most projects.

:: USAGE ::

    registerVar{ variableName, initialValue }

    registerBulk({ name1, name2, name3, name4}, initialValue)

    getVar(variableName)

    setVar{variableName, value [, true]}

:: EXAMPLE 1 ::

    registerVar{'sfx', true}

    setVar{'sfx', false}

    u.print(getVar('sfx')) <== prints false

:: EXAMPLE 2 ::

    registerVar{'score', 0}

    setVar{'score', 1}
    setVar{'score', 2} -- Because 'score' is a number, these add rather then set

    u.print(getVar('score')) <== prints 3

    setVar{'score', 0, true} -- Setting the last argument to true makes a number set rather than add

    u.print(getVar('score')) <== prints 0

]]

local registeredVariables = {}
local registerVariable = function(...)
    local var, var2 = ...; var = var2 or var
    if var[2] == 'true' then
        var[2] = true
    elseif var[2] == 'false' then
        var[2] = false
    end
    registeredVariables[var[1]] = var[2]
end

local registerBulk = function(...)
    local var, var2 = ...; var = var2 or var
    for i,v in ipairs(var[1]) do
        u.registerVariable{var[1][i], var[2]}
    end
end
u.registerBulk = registerBulk

local retrieveVariable = function(...)
    local name, name2 = ...; name = name2 or name
    local var = registeredVariables[name]
    if private.u.tonum(var) then
        var = private.u.tonum(var)
    end
    return var
end
u.getVar = retrieveVariable

local setVariable = function(...)
    local new, new2 = ...; new = new2 or new
    if type(new[2]) == 'number' then
        if not registeredVariables[new[1]] then
            registeredVariables[new[1]] = new[2]
        else
            registeredVariables[new[1]] = registeredVariables[new[1]] + new[2]
            if new[3] then
                registeredVariables[new[1]] = new[2]
            end
            if Data[new[1]] then
                Data[new[1]] = registeredVariables[new[1]]
            end
        end
    else
        if new[2] == 'true' then
            new[2] = true
        elseif new[2] == 'false' then
            new[2] = false
        end
        registeredVariables[new[1]] = new[2]
        if Data[new[1]] ~= nil then
            Data[new[1]] = registeredVariables[new[1]]
        end
    end
end
u.setVar = setVariable

setVariable{'volume', 1}
setVariable{'sfx', true}
setVariable{'music', true}
