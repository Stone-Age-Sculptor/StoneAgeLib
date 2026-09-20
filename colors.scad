// color.scad
//
// Part of the StoneAgeLib
//
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//
// Version 1
// February 3, 2025
//
// Version 2
// January 2, 2026
//   The function Hue() had its own version.
//   That is removed, it is now part of the version of this file.
//   Hue Version 1, December 3, 2023
//
// Version 3
// February 25, 2026
//   File renamed from color.scad to colors.scad, to avoid the
//   same name as a file of the BOSL2 library.


// ==============================================================
//
// Hue
// ---
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

