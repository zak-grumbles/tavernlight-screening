--[[
--  This script adds a button in the top right of the menu bar
--  in the client that opens a window for the 'jump' minigame.
--]]

-- UI components
jumpWindow = nil
jumpWindowButton = nil
jumpButton = nil

-- Flag indicating if game is running
jumpGameRunning = false

-- scheduled event for moving button
moveEvent = nil

-- Distance to move the button every 'tick'
-- The `init` method sets this to 1/4 of the button width
moveDistance = 25

-- Milliseconds between each movement of the button
moveDelay = 250

-- Executes when player connects
function online()
  jumpWindowButton:show()
end

-- Executes when player disconnects
function offline()
    if jumpGameRunning then
        stopJumpGame()
    end
end

-- Initialize module
function init()

  -- Connect events
  connect(g_game, { onGameStart = online,
                    onGameEnd   = offline })

  -- Create UI window
  jumpWindow = g_ui.displayUI('jump', modules.game_interface.getRightPanel())
  jumpWindow:hide()

  -- Create button to open new window
  jumpWindowButton = modules.client_topmenu.addRightGameToggleButton('jumpWindowButton', tr('Jump!'), '/images/topbuttons/spelllist', toggle)
  jumpWindowButton:setOn(false)

  -- Get actual 'Jump' button
  jumpButton = jumpWindow:getChildById('jumpButton')
  moveDistance = jumpButton:getRect().width * 0.25

  if g_game.isOnline() then
    online()
  end
end

function terminate()
  disconnect(g_game, { onGameStart = online,
                    onGameEnd   = offline })

  if jumpGameRunning then
    stopJumpGame()
  end
  
  cleanup()
end

-- Toggles visibility of the window and state of menu button
function toggle()
  if jumpWindowButton:isOn() then
    stopJumpGame()
    jumpWindowButton:setOn(false)
    jumpWindow:hide()
  else
    jumpWindowButton:setOn(true)
    jumpWindow:show()
    jumpWindow:raise()
    jumpWindow:focus()
    startJumpGame()
  end
end

-- Picks a random starting position for the button
function pickStartPos()
    local btnRect = jumpButton:getRect()
    local winRect = jumpWindow:getRect()

    newX = (winRect.x + winRect.width) - btnRect.width
    newY = math.random(winRect.y, winRect.y + winRect.height - btnRect.height)

    return newX, newY
end

-- Click handler for the moving button
function onJumpButtonClick()

  -- Does our cycled event still exist?
  if moveEvent and not moveEvent:isCanceled() then
    -- Cancel it
    moveEvent:cancel()

    -- Pick new start point
    local x, y = pickStartPos()

    -- Reposition button
    jumpButton:move(x, y)

    -- Start timer back up
    moveEvent = g_dispatcher.cycleEvent(moveButton, moveDelay)
  end
end

-- Move the button along its path
function moveButton()
    local rect = jumpButton:getRect()
    local windowRect = jumpWindow:getRect()

    local newY = rect.y
    local newX = rect.x - moveDistance

    -- If out of bounds, pick new start
    if newX < windowRect.x then
        newX, newY = pickStartPos()
    end

    jumpButton:move(newX, newY)
end

-- Kicks off the minigame
function startJumpGame()
    jumpGameRunning = true
    local x, y = pickStartPos()
    jumpButton:move(x, y)
    moveEvent = g_dispatcher.cycleEvent(moveButton, moveDelay)
end

-- Ends the game
function stopJumpGame()
    if moveEvent and not moveEvent:isCanceled() then
        moveEvent:cancel()
        moveEvent = nil
    end
    jumpGameRunning = false
end

-- Cleans up references
function cleanup()
  jumpButton:destroy()
  jumpWindow:destroy()
  jumpWindowButton:destroy()
end
