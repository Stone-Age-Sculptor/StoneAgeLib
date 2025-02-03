// DemonstrationBlobs.scad
//
// Demonstration for the StoneAgeLib
//
// Version 1
// February 3, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)

// This demonstration uses the next
// parts from the library:
//   * color.scad
//   * interpolation.scad
//   * list.scad

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
  blob = Subdivision(piece,method="weighted");
  offset(5)
    offset(-6)
      polygon(blob);
}
