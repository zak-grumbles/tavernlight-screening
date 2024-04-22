# Q7 - Jump!

## How to run
1. Copy the entire `jump/` directory into the `mods` folder of OTClient.
2. Add `- jump` to the end of the `load-later:` list in 
`modules/game_interface/interface.otmod`.
3. Run the client and log in
4. Click the button on the far right of the menu bar. (It has the same icon as
the spell list)
5. Enjoy!

## Approach
Having looked into the SpellList UI as part of Q5, I had a vague idea of how
both modules and UI worked in OTClient. Based on that, I stubbed out a basic
module. The first step was just to set up the menu bar button and have it open
a blank window. Once that was done, it was a simple matter of setting up a 
button in the main window and adding logic for handling clicking and other UI
events.

To do this, I used some simple math to figure out the bounds of the window
and pick a random location for the button to start. The X position is more or
less always the same, being at the right boundary of the window. The Y position
was chosen as a random location within the width of the window, summarized by
this pseudocode:
`newY = math.random(window.y, window.y + window.height - button.height)`

After that, it was just a matter of figuring out how to move the button. After
searching through the codebase a bit I found the EventDispatcher object which
has an implementation for CycledEvents. With that in hand movement was solved:
Simply move the button to the left by a set amount every fraction of a second.
(After some tweaking I found 0.25s, or 250ms, to be a reasonable amount of time).

Lastly, I added a click handler method for the button. When the user clicks on
it a new starting location is calculated and the event timer is reset.
