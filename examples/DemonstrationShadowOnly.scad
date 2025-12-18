// DemonstrationShadowOnly.scad
//
// Demonstration for the StoneAgeLib
//
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//
// Version 1
// March 3, 2025
//
// Version 2
// November 30, 2025
// Only the "StoneAgeLib.scad" is included now.

include <StoneAgeLib/StoneAgeLib.scad>

// The "Overload" font is a Public Domain font.
// Created by Typodermic Fonts inc.
// https://typodermicfonts.com
// A part of the Typodermic fonts
// are released in the Public Domain
// with the CC0 license.
// The "Overload" font is one of the
// Public Domain fonts.
use <Overload.otf>
font = "Overload";

$fn = 50;

color("Black")
  translate([1,21])
    linear_extrude(1)
      Shadow2D(length=4,angle=-40)
        text("Björn",spacing=1.05);

color("Black")
  translate([1,4])
    linear_extrude(1)
      Shadow2D(length=1,angle=-45,highlight=true)
        text("Björn",spacing=1.05);
