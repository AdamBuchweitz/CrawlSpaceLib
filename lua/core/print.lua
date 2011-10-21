
            --[[ ########## Extended Print ########## ]--

It's pointless to print out a table - instead you want the key/value
pairing of the table. This extended print does just that, as well as
ading a blank line between prints for easier reading. Lastly, this will
only print on the simulator. You shouldn't leave your prints in your final
app anyway, but if you do this should help improve performance.

]]

return function(CSL, private, cache)
	private.printObj  = {}
	private.printYpos = {}
	cache.print = print
	print = function( ... )
		local a = ...
		if simulator then
			if type(a) == "table" then
				cache.print("\nOutput Table Data:\n")
				for k,v in pairs(a) do cache.print("\tKey: "..tostring(k), "Value: ", tostring(v)) end
			elseif #{...} > 1 then cache.print("\nOutput mutiple: ", ...)
			elseif a == "fonts" then printFonts()
			else cache.print("\nOutput "..type(a).." :: ", a or "") end
		else
			if CSL.printWindow then
				if #{...} > 1 then
					for k,v in pairs(a) do
						private.printYpos = private.printYpos + 12
						private.printObj = display.newText(tostring(v), 0, private.printYpos, native.systemFont, 10, "tl")
						private.printObj:setTextColor(255, 255, 255)
						CSL.printWindow:insert(private.printObj)
						CSL.printWindow.y = CSL.printWindow.y - 12
					end
				else
					private.printYpos = private.printYpos + 12
					private.printObj = display.newText(tostring(a), 0, private.printYpos, native.systemFont, 10, "tl")
					private.printObj:setTextColor(255, 255, 255)
					CSL.printWindow:insert(private.printObj)
					CSL.printWindow.y = CSL.printWindow.y - 12
				end
			end
		end
	end
end
