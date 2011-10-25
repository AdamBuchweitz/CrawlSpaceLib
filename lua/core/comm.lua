
local print  = print
local ceil   = math.ceil

local bannerTop = '\n\t ######################### Message ######################### '
local fullLine  = '\n\t #                                                         # '
local indent    = '\n\t # '
local bannerBot = '\n\t ########################################################### '

Alert = function(message)
    if simulator and not silent then
        local splitString, lineCache, tempString = string.split(message, " "), {}, ""
        local messageText = ''
        if #message > 55 then
            for i=1, #splitString do
                if #tempString + #splitString[i] > 55 then
                    lineCache[#lineCache+1]=tempString
                    tempString=splitString[i].." "
                else
                    tempString = tempString..splitString[i].." "
                end
            end
            lineCache[#lineCache+1]=tempString
            for i=1, #lineCache do
                messageText = messageText..indent..lineCache[i]
            end
        else
            messageText = indent..message
        end

        print(messageText)
    end
end

Banner = function(message)
    if simulator and not silent then

        local splitString, lineCache, tempString = string.split(message, " "), {}, ""
        local messageText = ''
        if #message > 55 then
            for i=1, #splitString do
                if #tempString + #splitString[i] > 55 then
                    lineCache[#lineCache+1]=tempString
                    tempString=splitString[i].." "
                else
                    tempString = tempString..splitString[i].." "
                end
            end
            lineCache[#lineCache+1]=tempString
            for i=1, #lineCache do
                for j=1, 55-#lineCache[i] do
                    lineCache[i] = lineCache[i]..' '
                end
                messageText = messageText..indent..lineCache[i]..' #'
            end
        else
            local left = ceil((55 - #message)) / 2
            for _=1, left do
                messageText = messageText..' '
            end
            messageText = messageText..message
            for _=1, 55 -#messageText do
                messageText = messageText..' '
            end
            messageText = indent..messageText..' #'
        end

        print(bannerTop..fullLine..messageText..fullLine..bannerBot)
    end
end
