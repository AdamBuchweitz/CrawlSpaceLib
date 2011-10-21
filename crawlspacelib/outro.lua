return function(CSL, private, cache)
				--[[ ########## Random help ########## ]]--
	-- Generate randomseed and pull the first three numbers out
	math.randomseed(system.getTimer())
	private.random(); private.random(); private.random()
	
				--[[ ########## Set up the platform table ########## ]]--
	platform = {}
	local name = string.lower(system.getInfo("platformName"))
	if name     == "android"   then platform.android = true
	elseif name == "iphone os" then platform.ios     = true
	elseif name == "win"       then platform.win     = true
	elseif name == "mac os x"  then platform.mac     = true end
	platform.name = name
	
	
	
	local debugUI
	
	local prevTime = 0;
	local maxSavedFps = 30;
	local function minElement(table)
		local min = 10000;
		for i = 1, #table do if(table[i] < min) then min = table[i]; end end
		return min;
	end
	
	local fpsDialog
	local showFPS = function()
		local makeFpsDialog = function()
			local fps = display.newGroup()
	
			fps.background = display.newRect(screenX, screenY, screenWidth, 50)
			fps.background:setFillColor(0,0,0)
	
			fps.memory = display.newText("0/10", centerX, screenY, "helvetica", 13, "tc")
			fps.memory:setTextColor(255,255,255)
	
			fps.framerate = display.newText("0", centerX, fps.memory.contentHeight+5, "Helvetica", 16, "tc")
			fps.framerate:setTextColor(255,255,255)
	
			fps:insert(fps.background, fps.memory, fps.framerate)
			fps.alpha = .5
	
			transition.from(fps, {time=200, y=screenY-50})
	
			return fps;
		end
	
		local lastFps = {}
		local lastFpsCounter = 1
		local updateFPS = function( event )
			local curTime = system.getTimer();
			local dt = curTime - prevTime;
			prevTime = curTime;
	
			local fps = private.floor(1000/dt);
	
			lastFps[lastFpsCounter] = fps;
			lastFpsCounter = lastFpsCounter + 1;
			if(lastFpsCounter > maxSavedFps) then lastFpsCounter = 1; end
			local minLastFps = minElement(lastFps);
	
			fpsDialog.framerate.text = "FPS: "..fps.." (min: "..minLastFps..")";
	
			local mem = private.ceil(system.getInfo("textureMemoryUsed")*.0001)*.01
			fpsDialog.memory.text = "Mem: "..mem.." mb";
		end
	
		if fpsDialog then
			if fpsDialog.y == screenY then transition.to(fpsDialog, {time=200, y=screenY-50})
			else transition.to(fpsDialog, {time=200, y=screenY}) end
		else
			fpsDialog = makeFpsDialog()
			Runtime:addEventListener("enterFrame", updateFPS)
		end
	end
	
	local debugVars = {}
	DebugVar = function( var, range, value, title )
		CSL.registerVariable{ var, value }
		local v = {}
		v.ref = var
		v.value = value
		v.min = range[1]
		v.max = range[2]
		v.unit = (v.max - v.min) * 0.01
		v.title = title
		v.callback = function( event )
			CSL.setVariable{ v.ref, event.value * v.unit, true}
		end
		debugVars[#debugVars+1] = v
	end
	
	local coronaui
	local varAdjusterUI
	local showVars = function()
		local makeVarAdjusterUI = function()
			local g = display.newGroup()
			g.hit = display.newRect( centerX, centerY, screenWidth, screenHeight, "c" )
			g.hit.alpha = 0.25
			g.hit.remove = true
	
			local bg = display.newRoundedRect( centerX, centerY, screenWidth*0.8, 10+#debugVars*60, 20, "c" )
			bg:setFillColor(0,0,0,200)
			bg:addEventListener("touch", g)
	
			local bgOutline = display.newRoundedRect( centerX, centerY, screenWidth*0.8+4, 14+#debugVars*60, 20, "c" )
			bgOutline.strokeWidth = 1
			bgOutline:setFillColor(0,0,0,0)
			bgOutline:setStrokeColor(200,200,200,200)
	
			g:insert(g.hit, bg, bgOutline)
	
			local yPos = centerY - bgOutline.contentHeight * 0.5
			for i, v in ipairs(debugVars) do
				local txt = display.newText(v.title or v.ref, 0, yPos-30+55*i, native.systemFont, 14, "cl")
				local sld = coronaui.newSliderControl( centerX, txt.y+23, v.value/v.unit, v.callback)
				sld.name = "slider"
				txt.x = centerX - sld.contentWidth*0.25+ 10
				g:insert(txt, sld)
			end
	
			g:fadeIn()
	
			g.touch = function( self, event )
				if event.target.remove then
					varAdjusterUI:fadeOut(250)
				end
				return true
			end
	
			return g
		end
	
		if varAdjusterUI then
			if varAdjusterUI.alpha > 0.5 then
				varAdjusterUI:fadeOut(250)
				varAdjusterUI.hit:removeEventListener("touch", varAdjusterUI)
			else
				varAdjusterUI:fadeIn(250)
				varAdjusterUI.hit:addEventListener("touch", varAdjusterUI)
			end
		else
			coronaui = require("coronaui")
			varAdjusterUI = makeVarAdjusterUI()
			varAdjusterUI.hit:addEventListener("touch", varAdjusterUI)
		end
	end
	
	local showPrints = function()
		if CSL.printWindow then
			if CSL.printWindow.isVisible then CSL.printWindow.isVisible = false
			else CSL.printWindow.isVisible = true end
		else
			private.printYpos = screenY + 20
			printWindow = display.newGroup()
			printWindow.x, printWindow.y = screenX + 10, private.printYpos
			printWindow:setReferencePoint(display.bl)
			printWindow:addEventListener("touch", printWindow)
			printWindow.delta = private.printYpos
			printWindow.touch = function( self, event )
				if event.phase == "began" then
					display.getCurrentStage():setFocus( self )
				elseif event.phase == "moved" then
					printWindow.y = printWindow.delta + event.y-event.yStart
				elseif event.phase == "ended" then
					printWindow.delta = printWindow.y
					if printWindow.y + printWindow.contentHeight < screenY+20 then
						transition.to(printWindow, {y=screenY+20-printWindow.contentHeight, time=100, transitioning=easing.inOutQuad})
						printWindow.delta = screenY+20-printWindow.contentHeight
					elseif printWindow.y > screenY+screenHeight-100 then
						transition.to(printWindow, {y=screenY+screenHeight-100, time=100, transitioning=easing.inOutQuad})
						printWindow.delta = screenY+screenHeight-100
					end
					display.getCurrentStage():setFocus( nil )
				end
			end
			printWindow:fadeIn()
			CSL.printWindow = printWindow
			print(":: PRINT ::")
		end
	end
	
	
	local showDialog = function()
		local makeDebugUI = function()
			local g = display.newGroup()
	
			-- background glow
			local b
			for i=1, 10 do
				b = display.newCircle( centerX, centerY, 111 - i )
				b.alpha = i * 0.03
				g:insert(b)
			end
	
			-- background circle
			local oc = display.newCircle( centerX, centerY, 100 )
			oc:setFillColor( 0, 0, 0 )
			oc.alpha = 0.85
	
			-- inner circle
			local ic = display.newCircle( centerX, centerY, 30 )
			ic:setFillColor(0,0,0,0)
			ic.alpha = 0.25
			ic.strokeWidth = 1
			ic:setStrokeColor(255,255,255)
	
			-- make glows
			local makeGlow = function()
				local g = display.newGroup()
				for i=1, 10 do
					b = display.newCircle( 0, 0, 41 - i*3 )
					b.alpha = i * 0.015
					g:insert(b)
				end
				return g
			end
			-- lines and glow groups
			local lineGroup, glowGroup = display.newGroup(), display.newGroup()
			lineGroup.x, lineGroup.y = centerX, centerY
			lineGroup.rotation = 45
			glowGroup.x, glowGroup.y = centerX, centerY
	
			local side = {0,-1,0,1}
			local side2 = {0,1,0,-1}
			local l, glow
			for i=1, 4 do
				l = display.newLine(30, 0, 100, 0)
				l.x, l.y = 30*side[i], 30*side[5-i]
				l.alpha = 0.25
				l.rotation = 90*i
				glow = makeGlow()
				glow.x, glow.y = 65*side2[i], 65*side2[5-i]
				glow.xScale, glow.yScale = 1-0.4*private.abs(side[i]), 1-0.4*private.abs(side[5-i])
				glow.alpha = 0
				glow.on = false
				glowGroup:insert(glow)
				lineGroup:insert(l)
			end
	
			local checkPos = function( event )
				local newState = 0
				if event.x < centerX - 40 then
					newState = 4
				elseif event.x > centerX + 40 then
					newState = 2
				end
				if event.y > centerY + 40 then
					newState = 3
				elseif event.y < centerY - 40 then
					newState = 1
				end
				if newState > 0 then
					local glo = glowGroup[newState]
					if glo.on then
						glo:fadeOut()
						glo.on = false
					else
						glo:fadeIn()
						glo.on = true
					end
				end
				debugUI.state = newState
			end
			g.functions = { showFPS, function()end, showVars, showPrints }
			g.touch = function( self, event )
				local phase = event.phase
				if phase == "began" then
					checkPos(event)
					display.getCurrentStage():setFocus( self )
				elseif phase == "moved" then
					checkPos(event)
				elseif phase == "ended" then
					display.getCurrentStage():setFocus( nil )
					if g.state > 0 then
						g.functions[g.state]()
						if g.state == 3 then
							glowGroup[g.state]:fadeOut()
						end
					elseif g.canClose then
						g:fadeOut()
					else
						g.canClose = true
					end
				end
				return true
			end
	
			g:addEventListener("touch", g)
			g:insert(oc, ic, lineGroup, glowGroup)
	
	
			return g
		end
	
		if not debugUI then
			debugUI = makeDebugUI()
		end
		debugUI.canClose = false
		debugUI.state = 0
		debugUI:fadeIn()
	
		return true
	end
	
	
	local debugTimer
	local debugger = function()
		DebugVar("debugTime", {1000, 10000}, 1000, "Debug Timer")
		local listener = function( event )
			local phase = event.phase
			if phase == "began" then
				debugTimer = timer.performWithDelay(CSL.retrieveVariable("debugTime"), showDialog )
			elseif phase == "ended" then timer.cancel(debugTimer) end
		end
		Runtime:addEventListener("touch", listener)
	end
	
	
	local libraryMethods = { gameNetwork = enableOF, openfeint = enableOF, analytics = enableFlurry, debug = debugger }
	local libraryWhitelist = {"audio", "math", "string", "table", "debug" }
	local checkWhitelist = function(toCheck)
		for i,v in ipairs(libraryWhitelist) do if toCheck == v then return true end end
		return false
	end
	
				--[[ ########## The actual method ########## ]]--
	Enable = function(library, params)
		local l
		if package.preload[ library ] then l=cache.require(library)
		elseif checkWhitelist(library) then l=cache.require(library)
		elseif system.pathForFile(library..".lua", package.path ) then l=cache.require(library)
		else print("The library: "..library.." was not found. Please check your spelling.") end
		if package.loaded[library] then
			if libraryMethods[library] then libraryMethods[library](params) end
			return l
		end
	end
	--if simulator then require = Enable end

end
