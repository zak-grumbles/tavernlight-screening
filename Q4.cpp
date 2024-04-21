/**
 *  CHANGES:
 *  - Added logic to delete the created player object in the case that
 *    the user is not logged in and we can't load the player info from the
 *    IOLoginData.
 *
 *  - Changed the check on the created item so that we check if it exists
 *    and then add it to the player inbox if so.
 *
 *  - Added delete call in the last player offline check. We only allocate
 *    new memory in the case that the player is not online.
 *
 *  NOTES:
 *  - I made a small assumption based on context that the 
 *    `IOLoginData::loadPlayerByName` method is used when the player is not
 *    online. Thus the call to `delete` in the final if check of the method.
 *    If that assumption is wrong my approach would then be to create a
 *    boolean variable to indicate if we had a call to `new` and call `delete`
 *    at the end of the method if it is true.
 */

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    // Get player
    Player* player = g_game.getPlayerByName(recipient);
    if (!player) {

        // ALLOCATION
        player = new Player(nullptr);

        // If player is offline, we can load their data this way.
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            // Clean up
            delete player;
            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    if (item) {
        g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);
    }
    // No real need for an else here. If it fails we still need to do the
    // below if.

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
        delete player;
    }
}

