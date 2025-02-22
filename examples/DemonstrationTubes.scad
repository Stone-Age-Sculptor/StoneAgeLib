// DemonstrationTubes.scad
//
// Demonstration for the StoneAgeLib
//
// Version 1
// February 7, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)


// Either include everything with
// the file StoneAgeLib.scad, or
// include only what is needed.

//include <StoneAgeLib/StoneAgeLib.scad>
include <StoneAgeLib/interpolate.scad>
include <StoneAgeLib/shapes.scad>

// Creating tubes in 3D with a hull over spheres
// is not optimal. Other (better) libraries use
// polyhedron tubes.
// But the subdivision of this library works in 3D.

$fn = 50;

// A base plate.
color("Chocolate")
  translate([0,0,-1])
    cube([50,50,2],center=true);

color("LimeGreen")
  for(y=[-10,10])
    translate([0,y])
      cylinder_fillet(h=10,r=3,fillet_bottom=2);

// Define the points in 3D.
points3D = [[0,-10,10],[0,-10,15],[0,0,20],[0,10,15],[0,10,10]];

// Create a smooth path from the control points.
path3D = Subdivision(points3D,divisions=3,method="weightedpath");

// Show the control points in Red.
*color("Red")
  for(controlpoint=points3D)
    translate(controlpoint)
      sphere(0.5);

// The tube.
color("Turquoise")
  for(i=[0:len(path3D)-2])
    hull()
      for(j=[i,i+1])
        translate(path3D[j])
          sphere(3);
