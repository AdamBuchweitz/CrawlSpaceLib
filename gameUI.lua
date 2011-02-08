-- gameUI library
module(..., package.seeall)

require("sprite")
-- require("globalFunctions")

-- A general function for dragging physics bodies

-- Simple example:
-- 		local dragBody = gameUI.dragBody
-- 		object:addEventListener( "touch", dragBody )

function dragBody( event, params )
	local body = event.target
	local phase = event.phase
	local stage = display.getCurrentStage()

	if "began" == phase then
		stage:setFocus( body, event.id )
		body.isFocus = true

		-- Create a temporary touch joint and store it in the object for later reference
		if params and params.center then
			-- drag the body from its center point
			body.tempJoint = physics.newJoint( "touch", body, body.x, body.y )
		else
			-- drag the body from the point where it was touched
			body.tempJoint = physics.newJoint( "touch", body, event.x, event.y )
		end

		-- Apply optional joint parameters
		if params then
			local maxForce, frequency, dampingRatio

			if params.maxForce then
				-- Internal default is (1000 * mass), so set this fairly high if setting manually
				body.tempJoint.maxForce = params.maxForce
			end
			
			if params.frequency then
				-- This is the response speed of the elastic joint: higher numbers = less lag/bounce
				body.tempJoint.frequency = params.frequency
			end
			
			if params.dampingRatio then
				-- Possible values: 0 (no damping) to 1.0 (critical damping)
				body.tempJoint.dampingRatio = params.dampingRatio
			end
		end
	
	elseif body.isFocus then
		if "moved" == phase then
		
			-- Update the joint to track the touch
			body.tempJoint:setTarget( event.x, event.y )

		elseif "ended" == phase or "cancelled" == phase then
			stage:setFocus( body, nil )
			body.isFocus = false
			
			-- Remove the joint when the touch ends			
			globalFunctions:removeItem(body.tempJoint)
			
		end
	end

	-- Stop further propagation of touch event
	return true
end


-- A function for cross-platform event sounds

function newEventSoundXP( params )
	local isAndroid = "Android" == system.getInfo("platformName")

	if isAndroid and params.android then
		soundID = media.newEventSound( params.android ) -- return sound file for Android
	elseif params.ios then
		soundID = media.newEventSound( params.ios ) -- return sound file for iOS/MacOS
	end
	
	return soundID
end


-- A function for cross-platform fonts

function newFontXP( params )
	local isAndroid = "Android" == system.getInfo("platformName")

	if isAndroid and params.android then
		font = params.android -- return font for Android
	elseif params.ios then
		font = params.ios -- return font for iOS/MacOS
	else
		font = native.systemFont -- default font (Helvetica on iOS, Android Sans on Android)
	end
	
	return font
end

-- New sprite from data
-- Prepared with supplied name
function spriteFromData( params )
	local sheet = sprite.newSpriteSheetFromData(params.image, require(params.data).getSpriteSheetData())
	local set = sprite.newSpriteSet(sheet, params.start, params.frameCount)
	sprite.add(set, params.name, params.start, params.frameCount, params.time or 1, params.loop or 0)
	instance = sprite.newSprite(set)
	instance:prepare( params.name )
	
	return instance, set
end


-- Wrap text
function wrap(str, limit, indent, indent1)
  indent = indent or ""
  indent1 = indent1 or indent
  limit = limit or 72
  local here = 1-#indent1
  return indent1..str:gsub("(%s+)()(%S+)()",
                          function(sp, st, word, fi)
                            if fi-here > limit then
                              here = st - #indent
                              return "\n"..indent..word
                            end
                          end)
end
 
function explode(div,str)
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end
 
 
function wrappedText(str, limit, size, font, color, indent, indent1)
        str = explode("\n", str)
        size = tonumber(size) or 12
        color = color or {255, 255, 255}
        font = font or "Helvetica"      
 
        --apply line breaks using the wrapping function
        local i = 1
        local strFinal = ""
    while i <= #str do
                strW = wrap(str[i], limit, indent, indent1)
                strFinal = strFinal.."\n"..strW
                i = i + 1
        end
        str = strFinal
        
        --search for each line that ends with a line break and add to an array
        local pos, arr = 0, {}
        for st,sp in function() return string.find(str,"\n",pos,true) end do
                table.insert(arr,string.sub(str,pos,st-1)) 
                pos = sp + 1 
        end
        table.insert(arr,string.sub(str,pos)) 
                        
        --iterate through the array and add each item as a display object to the group
        local g = display.newGroup()
        local i = 1
    while i <= #arr do
                local t = display.newText( arr[i], 0, 0, font, size )    
                t:setTextColor( color[1], color[2], color[3] )
                t.x = math.floor(t.width/2)
                t.y = (size*1.3)*(i-1)
                sharpenText(t)
                g:insert(t)
                i = i + 1
        end
        return g
end

-- require("globalFunctions")
-- sharpenText = globalFunctions.sharpenText
