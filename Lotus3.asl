// Game:        Lotus: The Ultimate Challenge
// Emulator:    DOSBox 0.74-3
// Created by:  WinterThunder
// Updated:     2021-03-12
// IGT timing:  YES
//
// Note: DOSBox autosplitter breaks (doesn't find correct memory address) if you alter the dosbox.conf in a specific way.
// Known ways to break the autosplitter:
// 1. Alter the PATH system variable -> don't invoke SET PATH=xyz
// 2. Set gus=true (make sure gus is set to false)

state("DOSBOX")
{
    ushort RaceTime       : "DOSBox.exe", 0x193C370, 0x13398;          // shows race time in 1/10s
      byte RaceCarsDone   : "DOSBox.exe", 0x193C370, 0x1339E;          // amount of cars that completed the race
      byte CurrentPlace   : "DOSBox.exe", 0x193C370, 0x136D8;          // current place
    ushort RaceOverFlag   : "DOSBox.exe", 0x193C370, 0x136CE;          // race over counter
    ushort FirstPlaceTime : "DOSBox.exe", 0x193C370, 0x133A8;          // shows race time after flag
    byte40 FinishedTimes  : "DOSBox.exe", 0x193C370, 0x133A8;          // list of 20 ushorts that contain opponents results
}


startup
{
    vars.accumulatedTime = 0;
    vars.isRacing = true;
    vars.freshStart = true;
}

isLoading
{
    bool raceStarted = ((vars.freshStart == true || old.RaceOverFlag > 0) && current.RaceOverFlag == 0);
    bool newRace = (current.RaceTime == 0);
    if (raceStarted && newRace) {
        vars.isRacing = true;
        vars.freshStart = false;
    }
    return true;
}

gameTime
{
    int tenthsElapsed = vars.accumulatedTime;
    if (vars.isRacing == true) {
        tenthsElapsed += current.RaceTime;
    }
    return TimeSpan.FromSeconds(tenthsElapsed / 10.0);
}

start
{	
    vars.accumulatedTime = 0;
    vars.isRacing = true;
    vars.freshStart = true;
}

reset
{
    //nothing there unfortunately
}

split
{
    bool raceEnded = (old.RaceOverFlag == 0 && current.RaceOverFlag > 0);
    if (raceEnded) {
        vars.accumulatedTime += (current.RaceTime);
        vars.isRacing = false;
    }
    return raceEnded;
}