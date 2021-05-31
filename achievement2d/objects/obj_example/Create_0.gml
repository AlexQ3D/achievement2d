achievement_init();

function foo(par) {
	if (par == 6) {
		return true;	
	} else {
		return false;
	}
}
achievement_add("boolAchievement","steam_boolAchievement",false,true);
achievement_add("intAchievement","steam_intAchievement",0,5);
achievement_add("floatAchievement","steam_floatAchievement",0,1);
achievement_add("funcAchievement","steam_funcAchievement",0,foo,true);
