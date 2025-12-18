// DemonstrationFontDefinition.scad
//
// Demonstration for the StoneAgeLib
//
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//
// Version 1
// February 22, 2025
//
// Version 2
// November 30, 2025
// Only the "StoneAgeLib.scad" is included now.

include <StoneAgeLib/StoneAgeLib.scad>

$fn = 80;


// Example 1
// ---------
// Show text with the default font.
color("Blue")
  translate([20,50])
    text_subdivision("Hello");


// Example 2
// ---------
// Definition of the "H" and the "o".
// [0]    Settings for the font.
//        Extra settings might be added in the future.
// [0][0] The name of the font in the first field.
// [0][1] The author of the font.
// [0][2] A copyright note.
// [1]    The definition of the characters:
//        "o"   The character, it can be a UTF-8 emoticon.
//        5     The width of this character.
//        []    A list of paths.
my_font =
[
  ["myFont", "<your name>", "<your license>"],
  [
    ["o",5,[[[2,7],[0,5.5],[0,0],[5,0],[5,4.5],[4,5.6]]]],
    ["H",6,[[[0,0],[1,5],[0,10]],[[1,5],[5,5]],[[6,0],[5,5],[6,10]]]],
  ]
];

// Show the font with the font designer function.
translate([0,-60])
  FontDesigner(font="myFont",fontdefinition=[my_font]);

// Show with custom font to replace the "o" and the "H".
// If a character is not found, then the default font is used.
color("Green")
  translate([20,35])
    text_subdivision("Hello",font="myFont",fontdefinition=[my_font]);


// Example 3
// ---------
// A definition of an emoticon with a private UTF-8 character.
// The first range for private characters is: U+E000 ... U+F8FF
// The definition for the character may contain a loop.
my_spring =
[
  ["mySpring", "me", "CC0"],
  [
    ["\uE000",44,[for(x=[0:4:40]) [[x,0],[x,10],[x+2,10],[x+2,-10],[x+4,-10],[x+4,0]]]],
  ]
];

// Show the font with the font designer function.
translate([150,-60])
  FontDesigner(font="mySpring",fontdefinition=[my_spring]);

string = "Spring=\uE000";
color("Red")
  translate([20,20])
    text_subdivision(text=string,font="mySpring",weight=1.0,fontdefinition=[my_spring]);

color("LightSteelBlue")
  translate([100,60])
    rotate_extrude()
      translate([4,0])
        scale([0.4,0.4])
          text_subdivision("\uE000",font="mySpring",weight=1.0,fontdefinition=[my_spring]);
