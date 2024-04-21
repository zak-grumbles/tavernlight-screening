--[[
--  CHANGES:
--  * Changed method name to be properly descriptive.
--
--  * membername -> memberName for consistent styling.
--
--  * Updated loop logic to avoid creating new Player objects unneccessarily.
--    According to the `luascript.cpp` in the TFS source, 'v' is already a 
--    player objects, so we can just call the `getName` method to compare.
--
--  * Updated the call to `removeMember` to just pass the Player we already
--    have rather than construct a new one.
--]]

function removeFromPlayerParty(playerId, memberName)
    -- this method removes a member with name == 'membername' from the 
    -- given player's party. 
    player = Player(playerId)

    -- verify it was a valid playerId
    if player then
        local party = player:getParty()
        
        for k,v in pairs(party:getMembers()) do
            -- Does this player's name match the given parameter?
            if v:getName() == memberName then
                -- If so, remove the member
                party:removeMember(v)
            end
        end

    end 
end
