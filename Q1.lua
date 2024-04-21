--[[
--  CHANGES:
--  * Created variable to hold key for the storage value that
--    is being modified. No magical numbers.
--  * Added `location` parameter to releaseStorage so it can be used
--    for more than just releasing data at key '1000'
--  * Added check to make sure player is not nil before trying to call
--    member method.
--  * Added variable for return value in `onLogout` method. Makes it more
--    clear what the return value means and eliminates multiple `return` 
--    statements in the function for better readability.
--]]

-- Location of data that gets released on logout
LOC_LOGGEDIN = 1000

local function releaseStorage(player, location)
    -- Valid player?
    if player then
        -- If so, release storage
        player:setStorageValue(location, -1)
    end
end

function onLogout(player)
    storageReleased = false

    -- Valid player and storage is not already released?
    if player ~= nil and player:getStorageValue(LOC_LOGGEDIN) == 1 then
        -- if so, add event to trigger storage release
        addEvent(releaseStorage, LOC_LOGGEDIN, player)
        storageReleased = true
    end

    return storageReleased
end 
