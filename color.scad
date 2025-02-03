// color.scad
//
// Part of the StoneAgeLib
//
// Version 1
// February 3, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
// This version number is the overall version for everything in this file.
// Some modules and functions in this file may have their own version.


// ==============================================================
//
// Hue
// ---
// Version 1
// December 3, 2023
// By: Stone Age Sculptor
// License: CC0, Public Domain
//
// Uploaded to Reddit: https://www.reddit.com/r/openscad/comments/18a0jts/hue_to_rgb/
//
// Hue   Color
// -----------
//   0   Red
// 120   Green
// 240   Blue
//
// Future addition:
//   add saturation, light(brightness) and transparancy
//
// Splitting the hue (0...360) in 3 sections could not
// make all the colors.
// Splitting it in 6 sections is needed.

function Hue(hue) =
  let (h = (hue/60)%6)  // change to 0...6
  h < 1 ? [1,h,0] :     // 0...1
  h < 2 ? [2-h,1,0] :   // 1...2
  h < 3 ? [0,1,h-2] :   // 2...3
  h < 4 ? [0,4-h,1] :   // 3...4
  h < 5 ? [h-4,0,1] :   // 4...5
  [1, 0, 6-h];          // 5...6

// ==============================================================
