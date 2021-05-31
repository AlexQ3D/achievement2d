// Example usage
if (keyboard_check_pressed(vk_space)) {
	achievement_update("intAchievement",1,true);	
}

if (keyboard_check_pressed(vk_shift)) {
	achievement_update("funcAchievement",1,true);	
}

if (keyboard_check(vk_right)) {
	achievement_update("floatAchievement",0.0025,true);	
}

if (keyboard_check_pressed(vk_enter)) {
	achievement_trigger("boolAchievement");
}

if (keyboard_check_pressed(vk_backspace)) {
	achievement_cleanup();	
}