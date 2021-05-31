# achievement2d
 A simple achievement framework for GameMaker Studio 2.3+ 



## Installation

Import the latest release into any GameMaker Studio 2.3+ project.

========

## Functions

## achievement_init()

Call <u>once</u> at the start of your game. Sets up underlying map and tracking.

## achievement_add(internalName, steamName, defaultValue, triggerValue) 

Returns: Nothing

Add an achievement to be tracked. If you're not using this in a Steam game, the value of `steamName` doesn't matter.

| **Argument** | Type   | **Description**                                              |
| ------------ | ------ | ------------------------------------------------------------ |
| internalName | String | The name used for checking/setting the achievement's status. |
| steamName    | String | The steam API Name of the achievement.                       |
| defaultValue | Any    | The default value of the achievement.                        |
| triggerValue | Any    | The value to auto trigger the achievement.                   |

## achievement_check(achievementName)

Returns: Bool

| **Argument**    | Type   | Description                                         |
| --------------- | ------ | --------------------------------------------------- |
| achievementName | string | The `internalName` of an achievement to search for. |

Returns true/false if an achievement has been triggered. If the achievement can't be found, false is returned.

## achievement_update(achievementName, newValue, [increment])

Returns: Nothing

Updates the value of a achievement.

| **Argument**         | **Type** | **Description**                                              |
| -------------------- | -------- | ------------------------------------------------------------ |
| achievementName      | String   | `internalName` of the achievement.                           |
| newValue             | Any      | Value to set/add.                                            |
| increment [optional] | Bool     | If false the achievement's value will be set to `newValue`, otherwise `newValue` will be added. |

Examples:

```c++
achivement_add("finishedGame","steam_finishedGame", false, true);
achievement_update("finishedGame", true);
```

...will set the `finishedGame` achievement to true.

```c++
achivement_add("death25","steam_death25", 0, 25);
achievement_update("death25", 1, true);
```

...will add 1 to the `death25` achievement.

## achievement_trigger(achievementName)

Returns: Nothing

Triggers an achievement regardless if it's met it's trigger value. Good for achievements that have boolean conditions.

| **Argument**    | **Type** | **Description**                    |
| --------------- | -------- | ---------------------------------- |
| achievementName | String   | `internalName` of the achievement. |



## Usage

On game start call `achievement_init()`, then add any achievements/statistics you want to track using `achievement_add`.

Example:

```c++
// -- Game initalization/create event
achievement_init();
achievement_add("death25", "steam_death25", 0, 25); // Tracks when the player's died 25 times
```

That's all you need to do to get the system up and running! Make sure to call `achievement_cleanup()` when your game ends to free the underlying structs and map. Achievements aren't very good if you can't update them though, so let's look at that.

```c++
// On player death...
if (death) {
    achievement_update("death25", global.deathCount);
}
```

This will update the achievement whenever the player dies to whatever the current death count is. However, there's a cleaner way to do this...

```c++
// On player death...
if (death) {
    achievement_update("death25", 1, true);
}
```

This will increment the `death25` achievement's value, and doesn't require having a bunch of messy globals or separate structures to track everything.

When `death25` eventually reaches 25, the `Achievement` class's `push` method will be called.

```c++
// -- Achievement class's push method.
// Calls achievment platform specific code
function push() {
    // Replace with your own platform specific achievement bindings
    steam_set_achievement(get_name_steam());
}
```

If you're compiling for an alternate platform that has different requirements, you can easily add a switch statement/replace with whatever you like.

## Future plans

- Saving/loading achievements & statistics
- `achievement_reset` to reset values in an achievement back to zero

## Things that may or may not happen

- `achievment_reward(name, function)` to automate unlockables when an achievement is triggered
- Allow `triggerValue` to be a function.