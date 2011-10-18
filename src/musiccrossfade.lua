
            --[[ ########## Crossfade Background Music ########## ]--

Crossfading your background music gives your games a lot more polish. Using
the Crawl Space Library, this is easy! The first two audio channels are
reserved automatically, and when you call the method it keeps track of
which one is not in use for the next crossfade. You should even call this
method for the first play of the background music.

The Crawl Space Library also registers a variable called "volume", and that
is where the cross fader gets the start / end points. So if your app has
a slider that changes the volume, do not forget to change the volume variable!

:: EXAMPLE 1 ::

    audio.crossFadeBackground("myBackgroundMusic")

:: EXAMPLE 2 ::

    setVar{"volume", .5, true}
    audio.crossFadeBackground("myBackgroundMusic")
]]

local audio  = require "audio"
local audioChannel, otherAudioChannel, currentSong, curAudio, prevAudio = 1
audio.crossFadeBackground = function( path )
    if CSL.retrieveVariable("music") then
        local musicPath = path or CSL.retrieveVariable("musicPath")
        if currentSong == musicPath and audio.getVolume{channel=audioChannel} > 0.1 then return false end
        audio.fadeOut({channel=audioChannel, time=500})
        if audioChannel==1 then audioChannel,otherAudioChannel=2,1 else audioChannel,otherAudioChannel=1,2 end
        audio.setVolume( CSL.retrieveVariable("volume"), {channel=audioChannel})
        curAudio = audio.loadStream( musicPath )
        audio.play(curAudio, {channel=audioChannel, loops=-1, fadein=500})
        prevAudio = curAudio
        currentSong = musicPath
        audio.currentBackgroundChannel = audioChannel
    end
end
audio.reserveChannels(2)
audio.currentBackgroundChannel = 1
