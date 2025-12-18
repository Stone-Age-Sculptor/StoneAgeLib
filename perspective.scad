// perspective.scad
//
// Part of the StoneAgeLib
//
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//
// Version 1
// February 7, 2025
//
// This version number is the overall version for everything in this file.
// Some modules and functions in this file may have their own version.

if(version()[0] < 2022)
{
  echo("Warning: Version of OpenSCAD is too old.");
}

// ======================================================
//
// Perspective
// -----------
// Turn a 2D shape into a perspective 2D shape.
//
// The baseline is the x-axis.
// The middle is (0,0)
// The vanishing point is on the y-axis.
//
// Parameters:
//   strength  from 0.0 to 1.0
//   y         y-coordinate of vanishing point
//
// Note: 
//   I'm not sure if the code is mathematically correct,
//   but setting the strength seems pretty linear.
//
// To do:
//   Make it compatible with older versions,
//   by shifting it to extrude it without the 'v'.
module Perspective(strength=0.0,y=0)
{
  a1 = strength*45;
  a2 = max(a1,0);
  a3 = min(a2,45);
  angle = -a3;

  if(strength==0 || y==0)
    children();
  else
    projection(true)
      rotate([angle,0,0])
        linear_extrude(2*y,v=[0,1,1],scale=0,center=true)
          children();
}

// ======================================================
