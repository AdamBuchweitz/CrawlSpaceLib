
            --[[ ########## Transitions ########## ]--

            to, from, cancel
            multiple, safe, pause, resume, cancel
            reverse, loop, bounce



]]
            --[[ ########## Multiple Transition ########## ]--

]]

local luau = u

u.cache.transitionFrom = transition.from
u.transition = u.transition or transition
u.transition.from = function(tweens, params)
    if tweens then
        if #tweens > 0 then
            for i,v in ipairs(tweens) do
                if params.targetSelf then params.onComplete = v end
                luau.cache.transitionFrom(v, params)
            end
        else
            return luau.cache.transitionFrom(tweens, params)
        end
    end
end

u.cache.transitionTo = transition.to
u.transition.to = function(tweens, params)
    if tweens then
        if #tweens > 0 then
            for i,v in ipairs(tweens) do
                if params.targetSelf then params.onComplete = v end
                luau.cache.transitionTo(v, params)
            end
        else
            return luau.cache.transitionTo(tweens, params)
        end
    end
end

u.cache.transitionCancel = transition.cancel
u.transition.cancel = function(tweens)
    if tweens then
        if #tweens > 0 then
            for i,v in ipairs(tweens) do
                luau.cache.transitionCancel(v)
            end
        else
            luau.cache.transitionCancel(tweens)
        end
    end
end

if not u.NOCONFLICT then transition.from, transition.to, transition.cancel = u.transition.from, u.transition.to, u.transition.cancel end
