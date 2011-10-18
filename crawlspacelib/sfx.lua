
            --[[ ########## True or False SFX ########## ]--

Your game probably will have a toggle to turn on and off sound effect,
but it's a major pain to check the variable everytime you want to
play one. If you, instead, adjust the auto-registered "sfx" variable,
audio.playSFX will handle the checking for you. Additionaly, playSFX
can handle a string or a preloaded sound. If you are playing the sounds
often, you should still preload it.

:: EXAMPLE 1 ::

    private.audio.playSFX("sfx_tap.aac")

:: EXAMPLE 2 ::

    local hitSFX = private.audio.loadSound("sfx_hit.aac")
    private.audio.playSFX( hitSFX )

:: EXAMPLE 3 ::

    setVar{"sfx", false}

    local hitSFX = private.audio.loadSound("sfx_hit.aac")
    private.audio.playSFX( hitSFX ) -- This will not play the sound now

]]

return function(CSL, private, cache)
	private.audio.playSFX = function( snd, params )
		local channel
		if CSL.retrieveVariable("sfx") == true then
			local play = function()
				if params and params.delay then params.delay=nil end
				if type(snd) == "string" then channel=private.audio.play(private.audio.loadSound(snd), params)
				else channel=private.audio.play(snd, params) end
			end
			if params and params.delay then
				timer.performWithDelay(params.delay, play, false)
			else
				play()
			end
		end
		return channel
	end
end
