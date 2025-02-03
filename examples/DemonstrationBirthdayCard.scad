// DemonstrationBirthdayCard.scad
//
// Demonstration for the StoneAgeLib
//
// Version 1
// February 3, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)


// Either include everything with
// the file StoneAgeLib.scad, or
// include only what is needed.

//include <StoneAgeLib/StoneAgeLib.scad>
include <StoneAgeLib/list.scad>
include <StoneAgeLib/shapes.scad>

// A birthday card with shapes at random locations.
// The shapes do not overlap.
// The gray round circles are to show that they
// do not overlap. They must all have the same size.

card = [150,100]; // The size of the card.
distance = 20;    // The minimum distance between the shapes.

color("LawnGreen",0.3)
  linear_extrude(1.2)
    square(card);

coordinates = RandomNonOverlap(50,card,distance);
for(point=coordinates)
{
  translate(point)
  {
    // Helper circles.
    // The circles do not overlap.
    %translate([0,0,2])
      circle(d=distance);
    
    // Adjust the position and size of the heart,
    // to make it fit in the middle of the circle.
    color("DodgerBlue")
      linear_extrude(2)
        rotate(rands(-25,25,1)[0])
          translate([0,-9])
            heart2D(size=16);
  }
}
