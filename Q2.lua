--[[
--  NOTES:
--  * I've made the assumption that this code is utilizing the same DB objects
--    as the TFS/OTClient code and followed the syntax from that.
--
--  CHANGES:
--  * Added parameter sanity check. According to TFS docs a value of 0 is
--    valid and indicates that there is no max member count set.
--  * Added a check on the return value of db.storeQuery to verify the query
--    actually executed successfully before trying to read results.
--  * Added loop so the method actually iterates over results rather than just
--    printing the first one.
--]]

function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than 
    -- memberCount max members

    -- Parameter sanity check
    if memberCount and memberCount >= 0 then
        local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
        local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))

        -- Did query execute successfully?
        if result ~= false then
            -- get the first guild in the list
            local guild = result.getString("name")

            -- Iterate over rows. `next` returns nil once we reach end
            while guild do
                print(guild)
                guild = result.next(resultId)
            end
        end
    end
end
