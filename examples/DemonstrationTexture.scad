// DemonstrationTexture.scad
//
// Demonstration for the StoneAgeLib
//
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//
// Version 1
// February 3, 2025
//
// Version 2
// March 2, 2025
// Changes:
//   Granules added.
//
// Version 3
// July 20, 2025
// Changes:
//   Checkered Steel Plate added.
//
// Version 4
// November 30, 2025
// Only the "StoneAgeLib.scad" is included now.

include <StoneAgeLib/StoneAgeLib.scad>

// Use at least a 2025 version of OpenSCAD.
// A 2021 version uses a fake roof() function,
// which is slow and not accurate.

// The FlexHex grid removed from a cylinder,
// to get a pattern of flat stones.
// The FlexHex function is by "degroof" (Steve DeGroof), license CC0.
translate([50,50])
{
  intersection()
  {
    FlexHex(l=100,w=100,irregularity=50);
    cylinder(h=20,d=90,center=true);
  }
}

// Dimples to create a rough surface.
// The function "Dimples()" creates all the dimples.
translate([150,50])
{
  difference()
  {
    cylinder(h=5,d=90);
    translate([0,0,5.01])
      mirror([0,0,1])
        Dimples(density=50);
  }
}

// Creases.
// The function "Crease2D()" creates one crease in 2D.
translate([250,50])
{
  difference()
  {
    cylinder(h=5,d=90);
    
    translate([0,0,5.01])
      mirror([0,0,1])
        roof_router()
          for(i=[0:6])
            Crease2D();
  }
}

// Granules
translate([50,-50])
{
  intersection()
  {
    cylinder(h=5,d=90);
    translate([-45,-45,0])
      Granules([90,90,5]);
  }
}

// Checkered Steel Plate
translate([105,-95])
{
  color("LightSteelBlue")
  {
    cube([90,90,1]);
    translate([5,5,1])
      SteelPlate(8,8);
  }
}
