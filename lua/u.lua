
        --[[ ########## Luau ########## ]--

    Version 1.2

    Written and supported by Adam Buchweitz and Crawl Space Games

    http://crawlspacegames.com
    http://twitter.com/crawlspacegames


    For inquiries about Crawl Space, email us at
        heyyou@crawlspacegames.com

    For support with this library, email me at
        adam@crawlspacegames.com


    Copyright (C) 2011 Crawl Space Games - All Rights Reserved

    Library is MIT licensed

    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the “Software”),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.


    All functionality is documented below. For syntax help use .help()

    For a list of included features, use the .listFeatures() method.


    Note:
        If your project usees an old version of the Director class by Ricardo Rauber
        and use timer.cancelAll() you will cancel timers from the
        director! Either modify your version of the director class,
        or use the one included with this library.

        --[ ########## Special Thanks ########## ]--

    Thanks to Kenn Wagenheim, Jay Jennings, Bruce Martin, Piotr Machowski, and
    the folks from SimpleLoop for all your input, contributions, and testing.
    You guys are great!

]]--

local u = {}
u.u = u
setmetatable(_G, {__index = u})

u.initFont = function( one, two)
end

display.newParagraph = function()
    return {}
end

simulator = true
u.cache = {}
u.helpArr = {}

require 'lua.core.comm'
require 'lua.core.data'
require 'lua.core.string'
require 'lua.core.featurelist'
require 'lua.core.misc'

u.help = function(item)
    local print = u.cache.print or print
    if not item then
        print('\n\nUse this help feature for syntax additions in Crawl Space functions.')
        print('\n\nUSAGE EXAMPLE:\n\n\tcrawlspaceLib.help("newText")')
    else
        print('\n\nCrawlSpace Help: '..item..'\n')
        if u.helpArr[item] then print('\t'..u.helpArr[item]) else
            print('Sorry, I cannot find that item. Available items are:')
            for k,v in pairs(u.helpArr) do print('\n -- '..k) end
        end
    end
end

local extendMappings = {
    table     = 'lua.core.table',
    shorthand = 'lua.core.shorthand',
    timer     = 'lua.timer.timer'
}

local extend = function(arg)
    Alert('EXTENDING::'..arg)
    if extendMappings[arg] then
        require(extendMappings[arg])
    else
        error('Not a valid extend')
    end
end

u.extend = function(...)
    local arg = {...}
    if not arg[1] or arg[1] == 'all' then
        Banner('Extending everything')
        for key, _ in pairs(extendMappings) do
            extend(key)
        end
    else
        Banner('Begin Selective Extending')
        if #arg > 1 then
            for i=1, #arg do
                extend(arg[i])
            end
        elseif type(arg[1]) == 'table' then
            for i=1, #arg[1] do
                extend(arg[1][i])
            end
        else
            extend(arg[1])
        end
    end
end

local overrideMappings = {
    timer = 'lua.timer.safeTimer',
    print = 'lua.util.print'
}

local override = function(arg)
    Alert('OVERRIDING:: '..arg)
    if overrideMappings[arg] then
        require(overrideMappings[arg])
    else
        error('Not a valid override')
    end
end

u.override = function(...)
    local arg = {...}
    if not arg[1] or arg[1] == 'all' then
        Banner('Overriding everything')
        for key, _ in pairs(overrideMappings) do
            override(key)
        end
    else
        Banner('Begin Selective Override')
        if #arg > 1 then
            for i=1, #arg do
                override(arg[i])
            end
        elseif type(arg[1]) == 'table' then
            for i=1, #arg[1] do
                override(arg[1][i])
            end
        else
            override(arg[1])
        end
    end
end
