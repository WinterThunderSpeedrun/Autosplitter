// Game:        Fast Food!
// Emulator:    DOSBox 0.74-3
// Created by:  WinterThunder
// Updated:     2020-09-12
// IGT timing:  NO
//
// Note: DOSBox autosplitter breaks (doesn't find correct memory address) if you alter the dosbox.conf in a specific way.
// Known ways to break the autosplitter:
// 1. Alter the PATH system variable -> don't invoke SET PATH=xyz
// 2. Set gus=true (make sure gus is set to false)

state("DOSBOX")
{
    byte Level          : "DOSBox.exe", 0x193C370, 0x9E58;          // shows level
	byte Lives          : "DOSBox.exe", 0x193C370, 0x7556;          // shows lives
    byte GameRunning    : "DOSBox.exe", 0x193C370, 0x56975;         // 
    byte GameSelect     : "DOSBox.exe", 0x193C370, 0xBF9A;          // Dizzy is selecting difficulty = 2 
}


startup
{
	vars.isCategory = (Func<string, bool>) ((category) => {
		string categoryName = timer.Run.GetExtendedCategoryName().ToLower();
		bool isCategory = categoryName.Contains(category.ToLower());
		return isCategory;
	});
}

start
{	
	int startingLevel = 0;
	if (vars.isCategory("medium") == true) {
		startingLevel = 10;
	}
	if (vars.isCategory("hard") == true) {
		startingLevel = 20;
	}
    return
        ((current.Level == startingLevel) && 
		 (current.GameSelect != 2) &&
		 current.GameRunning != 0 && old.GameRunning == 0);
}

reset
{
    return (current.GameSelect == 2);
}

split
{
    return 
        (old.Level != 40) ? (old.Level < current.Level) : (old.Level != current.Level);
}
