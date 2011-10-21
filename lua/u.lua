
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

require 'lua.core.data'

u = {}
u.override = function(...)
    local arg = {...}
    local print = cache.print
    if not arg[1] or arg[1] == 'all' then
        print('override everything!!!!')
    else
        print('\n\n\t--[[ ########## Begin Selective Override ########## ]]--\n')
        if #arg > 1 then
            for i=1, #arg do
                print('OVERRIDING:: \n\t\t'..arg[i]..'\n')
            end
        elseif type(arg[1]) == 'table' then
            for i=1, #arg[1] do
                print('OVERRIDING:: \n\t\t'..arg[1][i]..'\n')
            end
        else
            print('Only overriding: '..arg[1])
        end
    end
end
