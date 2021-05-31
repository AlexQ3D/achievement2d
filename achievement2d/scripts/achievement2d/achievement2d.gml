// Multiplatform acchievement adder
function log(msg) {
	show_debug_message(msg);
}

// Sets up everything necessary for achievements
// Only call once at the game start
function achievement_init() {
	global.achievements = ds_map_create();	
}

// Cleans up everything achievement related
// Only call once at game end
function achievement_cleanup() {
	ds_map_destroy(global.achievements);	
}

// Achievement class
// Holds everything necessary for acchievements to work on multiple platforms
function Achievement(_internalName, _steamName, _defaultValue, _triggerValue) constructor {
	internalName = _internalName;
	steamName = _steamName;
	value = _defaultValue;
	triggerValue = _triggerValue;
	triggered = false;
	valueIsString = false;
	
	// Used in checking if the achievement's been triggered
	if (is_string(triggerValue)) {
		valueIsString = true;	
	}
	
	
	// -- METHODS
	
	// -- Getters
	// Returns the achievement's internal name/name used in the global achievement dictionary
	function get_name_internal() {
		return internalName;	
	}
	
	// Returns the achievement's Steam name
	function get_name_steam() {
		return steamName;	
	}
	
	// Returns the current value of the achievement
	function get_value() {
		return value;	
	}
	
	// Returns if the current achievement has been triggered
	function get_triggered() {
		return triggered;
	}
	
	// -- MUTATORS
	
	// Update the value of the achievement
	function update(newValue) {
		value = newValue;
		
		// First case checks if the value is larger and not a string, second checks if the current value is equal to the triggervalue
		var achievementTriggered = (((value >= triggerValue) && (!valueIsString)) || (value == triggerValue));
		
		// Check if the new
		if (achievementTriggered) {
			trigger();	
		}
	}
	
	// Trigger the current achievement
	function trigger() {
		if (!get_triggered()) {
			triggered = true;
			
			// Call the generic achievement push method
			push();
		}
	}
	
	// Should only be called by trigger (ideally)
	// Calls achievment platform specific code
	function push() {
		// Reccommended: replace with your own debug function so you know an achievement's been triggered/pushed
		// show_debug_message(internalName + " triggered!");
		
		// Replace with your own platform specific achievement bindings
		steam_set_achievement(get_name_steam());
	}

}

// Adds an achievement to the game
function achievement_add(internalName, steamName, defaultValue, triggerValue) {
	achievement = ds_map_find_value(global.achievements, internalName);
	
	if (is_undefined(achievement)) {
		ds_map_add(global.achievements, internalName, new Achievement(internalName, steamName, defaultValue, triggerValue));
	} else {
		show_error("Duplicate achievement \"" + internalName + "\"!");
	}
}


// checks if an achievement has been triggered
function achievement_check(achievementName) {
	// Find the achievement
	achievement = ds_map_find_value(global.achievements, achievementName);
	
	if (!is_undefined(achievement)) {
		return achievement.get_triggered();
	}
	
	return false;
}

// Update an achievement to a new value OR increment the current value
// TIP: Set newvalue to something negative and increment to true to decrement the value
function achievement_update(achievementName, newValue, increment) {
	// Still no default params in gamemaker, so this is a quick workaround for that
	if (is_undefined(increment)) {
		increment = false;	
	}
	
	// Find the achievement
	achievement = ds_map_find_value(global.achievements, achievementName);
	if (!is_undefined(achievement)) {
		// Get the new value
		var value = newValue;
		
		// Increment the new value if need be
		if (increment) {
			value += achievement.get_value();
		}
		
		// Update the achievement
		achievement.update(value);
	}
}

// Trigger an achievement manually
// Disregards current achievement progress
function achievement_trigger(achievementName) {
	achievement = ds_map_find_value(global.achievements, achievementName);
	if (!is_undefined(achievement)) {
		achievement.trigger();
	}	
}

// Debug function used for drawing the status of all the achievements, modify to fit your own needs!
function achievement_debug_draw(drawX, drawY, scrollOffset) {
	// Get the start of the map to start iterating from
	var nextValue = ds_map_find_first( global.achievements);
	var i = 0;
	
	// Get the space between options
	static spacing = string_height("\n\n\n\n\n\n"); // simple hack

	// Iterate through achievements map
	while (!is_undefined(nextValue)) {
		// Get the achievement object
		var achievement = global.achievements[? nextValue];
		
		// Get information about the achievement
		var name = achievement.get_name_internal();
		var steamName = achievement.get_name_steam();
		var triggered = string(achievement.get_triggered());
		var progress = string(achievement.get_value());
		var goal = string(achievement.triggerValue);
		
		// Display information
		draw_text(drawX, drawY + scrollOffset + i * spacing, name + ":\n" + "Steam Name: " + steamName + "\nTriggered: " + triggered + "\nProgress: " + progress + "/" + goal);
 
		// Find the next value
		nextValue = ds_map_find_next( global.achievements, nextValue);
		i ++;
	}
}