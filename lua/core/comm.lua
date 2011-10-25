
  --[[ ########## Communication ########## ]--

    # Summary:      Output noticable banners to differenciate between
    #               user 'print' statements and Lua.u alerts
    #
    # Author:       Adam Buchweitz
    #
    # ]]

local print  = print
local ceil   = math.ceil

local bannerTop = '\n\t ######################### Message ######################### '
local fullLine  = '\n\t #                                                         # '
local indent    = '\n\t # '
local bannerBot = '\n\t ########################################################### '

--[[### Alert ###]--
    #
    # Summary:      Outputs a noticable alert to the terminal
    # Parameters:   String
    # Returns:      Nothing
    #
    # ]]

Alert = function(message)
    -- Only output if the environment is the simulator,
    -- and the 'VERBOSE' variable is set to 'true'
    if simulator and VERBOSE then
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

--[[### Banner ###]--
    #
    # Summary:      Outputs a large, unmissable banner to the terminal
    # Parameters:   String
    # Returns:      Nothing
    #
    # ]]

Banner = function(message)
    -- Only output if the environment is the simulator,
    -- and the 'VERBOSE' variable is set to 'true'
    if simulator and VERBOSE then

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
