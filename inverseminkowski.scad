// inverseminkowski.scad
//
// Part of the StoneAgeLib
//
// Version 1
// February 3, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//
// This version number is the overall version for everything in this file.
// Some modules and functions in this file may have their own version.



// Inverse Minkowski
// -----------------
// Parameters:
//   radius: The radius for the fillet edge.
//   extra : set to true for extra accuracy
//           for rendering. It might take
//           a very long time.
// This module is limited.
// It creates a fillet between a shape and 
// a (virtual) ground plane.
// The area for the inverse minkowski is 100x100x50,
// from (0,0) and up.
// That is:
//   x and y: from -50 to +50
//   z      : from 0 to +50
//
// Note: this module might crash OpenSCAD.
module InverseMinkowski(radius=5,extra=false)
{
  // The area in which the inverse minkowski is calcuated.
  area = [100,100,50];

  // The sphere is not perfect round with
  // a low accuracy, and that is compensated.
  // I estimated the compensation for 12, 20 and 40.
  // It can probably be calculated.

  // lc = list with corrections
  lc =
  [
    [ 12, 0.18 ],   // default preview
    [ 20, 0.07 ],   // defualt render
    [ 40, 0.02 ],   // render with extra accuracy
  ];

  // ir = index for rendering.
  // It could be 2 for extra accuracy 
  ir = extra ? 2 : 1;
  accuracy   = $preview ? lc[0][0] : lc[ir][0];
  correction = $preview ? lc[0][1] : lc[ir][1];

  difference()
  {
    // This is the cube to turn the negative shape
    // back into a positive shape.
    translate([0,0,area.z/2])
      cube(area,center=true);

    minkowski(convexity=3)
    {
      difference()
      {
        // This cube is used to turn the positive
        // shape into a negative shape.
        // The negative shape is then used for
        // the minkowski filter.
        translate([0,0,area.z/2+radius])
          cube([area.x+1,area.y+1,area.z],center=true);

        // Since the minkowski for a fillet is
        // from the outside inwards,
        // the shape is first grown outwards
        // to get the same size in the end.
        render()
          minkowski()
          {
            children(0);
            sphere(radius+correction,$fn=accuracy);
          }
      }

      // The reduced accuracy of the sphere
      // will make it less high.
      // That is corrected here.
      // Without correction, there will be 
      // a ground plane.
      sphere(radius+correction,$fn=accuracy);
    }
  }
}
