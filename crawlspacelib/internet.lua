
            --[[ ########## Execute If Internet ########## ]--

This very useful little method downloads a webpage from the internet,
establishing whether or not the device has internet connectivity.

You can pass any function in at anytime. If there is internet, it fires.
If there is no internet, it doesn't fire the function, and if we don't yet know
if there is connectivity, the method is cached until we do know. You also
have the option of passing in a method to fire if there is not internet.
You may pass as many functions in as you have necessity.

In addition, once we know whether or not there is internet, a global
variable "internet" is set to true or false. Just make sure you don't try
so access it during the first few seconds of launch.

:: EXAMPLE 1 ::

    local myFunction = function(
        print("I haz interwebz!")
    end

    executeIfInternet(myFunction)


:: EXAMPLE 2 ::

    local myFunction = function()
        print("I haz interwebz!")
    end

    -- Returns true for internet, false if not, and nil if unkown when called
    local executed = executeIfInternet(myFunction)

    if executed == true then
        print("It executed imidiately")
    elseif executed == false then
        print("It never executed")
    else
        print("We don't yet know if it executed")
    end


:: EXAMPLE 3 ::

    local myInternetFunction = function()
        print("I haz interwebz!")
    end

    local myNonInternetFunction = function()
        print("Internet fail")
    end

    executeIfInternet(myInternetFunction, myNonInternetFunction)

]]

return function(CSL, private, cache)
	private.helpArr.executeIfInternet = 'executeIfInternet(myInternetMethod, myNonInternetMethod)'
	local onInternet = {}
	local checkForInternet
	local executeOnNet = function(bool)
		if bool then
			for i=1, #onInternet do local f = table.remove(onInternet); f.y(); f=nil end
		else
			for i=1, #onInternet do local f = table.remove(onInternet); f.n(); f=nil end
		end
	end
	-- Sets global variable "internet"
	local internetListener = function( event )
		if event.isError then _G.internet = false
		else _G.internet = true end
		executeOnNet(_G.internet)
		return true
	end
	
	checkForInternet = function()
		network.request("http://google.com/", "GET", internetListener)
	end
	checkForInternet()
	
	executeIfInternet = function(y, n)
		if internet then y(); return true
		elseif internet == false then n(); return false
		elseif internet == nil then onInternet[#onInternet+1] = {y=y, n=n} end
	end
end
