-- Cows: This file is replacing the old "SuperSurvivorSettings.lua" file.

-- Global Variables are loaded in order of appearance... so they must be loaded before everything else to be used.
-- Otherwise, you can expect a "nil" return when a global variable is referenced before it is loaded.

-- Cows: Global Boolean
IsGlobalLoggingEnabled = true;
SpeakEnabled = true;

-- Cows: Global Integer
GFollowDistance = 5;      -- Update: Don't try to turn gfollowdistance into a variable from what it equals to. I made followtask add what it needs to add on its own.
Limit_Npc_Groups = 4;     -- Cows: Max npc groups, independent of Raider Groups.
Limit_Raiders_Groups = 2; -- Cows: Max raider groups, independent of npc groups.
Limit_Npcs_Spawn = 12;    -- Cows: Max npc spwans, independent of raiders spawns.
Limit_Raiders_Spawn = 8;  -- Cows: Max raiders spaws, independent of npcs spawns.
Max_Group_Size = 8;       -- Cows: Max number of members in a group
Min_Group_Size = 1;       -- Cows: Min number of members in a group
SuperSurvivorBravery = 6; -- WIP - Cows: Bravery needs to be reworked... because it is literally useless at the moment.

-- Cows: Global String
StringTest = "This is a Global String Test";

-- Cows: Moved out of SuperSurvivorsContextMenu.lua
LootTypes = { "Food", "Weapon", "Item", "Clothing", "Container", "Literature" };

-- Cows: Global Hair Colors
HairColors = {}
HairColors["white"] = ImmutableColor.new(0.75, 0.74, 0.72)
HairColors["grey"] = ImmutableColor.new(0.48, 0.47, 0.44)
HairColors["blond"] = ImmutableColor.new(0.82, 0.82, 0.39)
HairColors["sand"] = ImmutableColor.new(0.86, 0.78, 0.66)
HairColors["hazel"] = ImmutableColor.new(0.61, 0.50, 0.34)
HairColors["brown"] = ImmutableColor.new(0.62, 0.42, 0.17)
HairColors["red"] = ImmutableColor.new(0.58, 0.25, 0.25)
HairColors["pink"] = ImmutableColor.new(0.59, 0.39, 0.55)
HairColors["purple"] = ImmutableColor.new(0.47, 0.43, 0.59)
HairColors["blue"] = ImmutableColor.new(0.39, 0.47, 0.59)
HairColors["black"] = ImmutableColor.new(0.10, 0.08, 0.09)

-- Cows: Global Superb Survivor Roles, Default
SurvivorRoles = {
    ["Companion"] = "Companion",
    ["Worker"] = "Worker",
}
