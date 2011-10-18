
        --[[ ########## Crawl Space Library ########## ]--

    Version 1.1.3

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


-- Set this to false to bypass the welcome message
local showIntro = false

-- Set this to false to bypass the random Lua/CoronaSDK tips
local startupTips = false

-- Enable debug print messages, as well as on-device prints
local debug = true

-- CSL is the actual object returned
local CSL = {}

-- The cache of native and Corona APIs
cache = {}

            --[[ ########## Getting Help ########## ]--

Start with:

    local CSL = require "crawlspaceLib"
    CSL.help()

]]
local helpArr = {}
CSL.help = function(item)
    if not item then
        cache.print("\n\nUse this help feature for syntax additions in Crawl Space functions.")
        cache.print('\n\nUSAGE EXAMPLE:\n\n\tcrawlspaceLib.help("newText")')
    else
        cache.print('\n\nCrawlSpace Help: '..item..'\n')
        if helpArr[item] then cache.print('\t'..helpArr[item]) else
            cache.print('Sorry, I cannot find that item. Available items are:')
            for k,v in pairs(helpArr) do cache.print('\n -- '..k) end
        end
    end
end
