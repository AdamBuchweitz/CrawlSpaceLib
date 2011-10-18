
            --[[ ########## Transitions ########## ]--

            to, from, cancel
            multiple, safe, pause, resume, cancel
            reverse, loop, bounce



]]
            --[[ ########## Multiple Transition ########## ]--

]]
cache.transitionFrom = transition.from
transition.from = function(tweens, params)
    if tweens then
        if #tweens > 0 then
            for i,v in ipairs(tweens) do
                if params.targetSelf then params.onComplete = v end
                cache.transitionFrom(v, params)
            end
        else
            return cache.transitionFrom(tweens, params)
        end
    end
end

cache.transitionTo = transition.to
transition.to = function(tweens, params)
    if tweens then
        if #tweens > 0 then
            for i,v in ipairs(tweens) do
                if params.targetSelf then params.onComplete = v end
                cache.transitionTo(v, params)
            end
        else
            return cache.transitionTo(tweens, params)
        end
    end
end

cache.transitionCancel = transition.cancel
transition.cancel = function(tweens)
    if tweens then
        if #tweens > 0 then
            for i,v in ipairs(tweens) do
                cache.transitionCancel(v)
            end
        else
            cache.transitionCancel(tweens)
        end
    end
end
