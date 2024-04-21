--[[
--  This is the lua script for the Frigid Vortex spell for Q5.
--
--  APPROACH:
--  The spell has a circular area of affect with a radius of three tiles. 
--  It functions by adding an event with a random delay between .25s and 3s
--  that will call the `spellCallback` method when it executes. These events
--  are created whenever the engine targets a tile inside the combat area, thus
--  every tile is eventually hit within three seconds, but the order is random.
--]]


-- Spell callback function. 
function spellCallback(cid, position, count)
    position:sendMagicEffect(CONST_ME_ICETORNADO)
end

-- Tile target callback
function onTargetTile(creature, position)
    -- Kick off the spell event with a random delay
    addEvent(spellCallback, math.random(250, 3000), cid, position, count)
end

-- set combat parameters
local combat = Combat()
combat:setArea(createCombatArea(AREA_CIRCLE3X3))
combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

-- basic onCastSpell implementation
function onCastSpell(creature, variant, isHotkey)
    return combat:execute(creature, variant)
end
