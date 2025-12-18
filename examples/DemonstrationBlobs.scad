// DemonstrationBlobs.scad
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
// December 12, 2025
// Changes:
//   Only the "StoneAgeLib.scad" is included now.
//   The method "weighted" is now called "cubic".


include <StoneAgeLib/StoneAgeLib.scad>

$fn = 50;

number_of_walls = 10;
stepsize = 20;
points_per_wall = 5;
amount = 12;

walls = [ for(i=[0:number_of_walls-1])
  [for(j=[0:points_per_wall-1])
  [i*stepsize + rands(-amount,amount,1)[0],
   j*stepsize + rands(-amount,amount,1)[0]]]];

// Paint control points
*for(wall=walls)
  color(Hue(rands(0,360,1)[0]),0.2)
    for(point=wall)
      translate(point)
        circle(1);

// Walk through the walls, selecting
// a piece between two walls.
for(i=[0:number_of_walls-2])
{
  piece = concat(walls[i],ReverseList(walls[i+1]));
  blob = Subdivision(piece,method="cubic");
  offset(5)
    offset(-6)
      polygon(blob);
}
