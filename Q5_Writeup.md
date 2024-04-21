# Q5 - Frigo

## How to Run
1. copy the `frigid_vortex.lua` file into the `data/spells/scripts/attack` 
directory of your TFS server.
2. Add the line in `spells.xml` to the bottom of the instant spells sections in
`data/spells/spells.xml` in your TFS server. 
3. Replace the spells.lua in `otclient/modules/gamelib/` with the `spells.lua`
in this repository.
4. Create or log into a sorcerer character.
5. Say "frigo"
6. Enjoy!

## Approach

To figure out how spells work in TFS, I took a look at a couple things: the 
`#example.lua` example spell as well as the implementation of a few existing 
spells, such as `light.lua`. Those told me spells have a few components: Area,
type, and effect. Of course other things can be added like conditions but those
weren't necessary for this task.

Next, I stubbed out a new spell called Frigid Vortex. It was a simple spell
that affected a 2X2 circle with ice damage and displayed the icicle effect.
That was something, but the effect and animation all occurred at the same time,
rather than at a staggered and random pace like in the sample video. 

Then, in the `apocalypse.lua` file I found the onTargetTile callback option. As
best I can tell, it is called on every tile in the specified spell area. 
However, that still executes very very quickly and may as well be instantaneous
for all tiles as far as a player is concerned. So, in order to stagger it, I
created an `spellCallback` method that would apply the effect to a single tile.
Next, I implemented the `onTargetTile` method to fire an event that would call
`spellCallback` after a random delay between 0.25s and 3s. This produced the
staggered and random effect seen in the video.

### Changes
- Created `frigid_vortex.lua` to create the new spell.
- Added the following lines to `spells.xml`:
```xml
<instant group="attack" spellid="179" name="Frigid Vortex" words="frigo" level="8" mana="10" aggressive="1" selftarget="1" cooldown="1000" groupcooldown="1000" needlearn="0" script="attack/frigid_vortex.lua">
    <vocation name="Sorcerer"/>
    <vocation name="Druid"/>
</instant>
```
- Added the following lines to the OTClient's `spells.lua`
```lua
-- Add 'Frigid Vortex' to the spellOrder list

-- Add this line to the bottom of the 'Default' entry in the 'SpellInfo' table
    ['Frigid Vortex'] =            {id = 131, words = 'frigo',                 exhaustion = 1000,  premium = false, type = 'Instant', icon = 'icicle',
    mana = 10,     level = 8, soul = 0, group = {[1] = 2000},               vocations = {1, 2}},
```
