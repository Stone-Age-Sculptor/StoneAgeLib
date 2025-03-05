// DemonstrationHeart.scad
//
// Demonstration for the StoneAgeLib
//
// Version 1
// March 5, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)


// Either include everything with
// the file StoneAgeLib.scad, or
// include only what is needed.

//include <StoneAgeLib/StoneAgeLib.scad>
include <StoneAgeLib/shapes.scad>

$fn = 100;

wall = 2.5;
height_base = 0.8;
height_wall = 3.8;

// Size and positions of the hearts.
hearts = 
[
  [140, [0,0]],     // The large bottom heart
  [63,  [-24,57]],  // Medium large heart
  [44.8,[22,51]],   // Medium small heart
  [30,  [58,65]],   // Small hearts
  [30,  [-32,40]],
  [30,  [-57,90]],
  [30,  [15,22]],
  [30,  [40,112]],
  [30,  [-5,70]],
  [30,  [-36,112]],
  [30,  [10,92]],
  [30,  [-12,13]],
];

// Combine all the hearts for the bottom.
color("Wheat",0.5)
  linear_extrude(height_base)
    for(heart=hearts)
      translate(heart[1])
        HeartOutside(heart[0]);

// Add the walls.
// The walls of the small hearts
// overlap the larger hearts.
// Therefor the inside of the small hearts
// is removed once more afterwards.
color("Black")
{
  linear_extrude(height_base+height_wall)
  {
    difference()
    {
      union()
      {
        for(heart=hearts)
        { 
            translate(heart[1])
              difference()
              {
                HeartOutside(heart[0]);
                HeartInside(heart[0]);
              }
        }
      }

      // Remove the inside of the small hearts
      // once more, as if they are on top
      // of the other hearts.
      for(i=[3:len(hearts)-1])
      { 
        translate(hearts[i][1])
          HeartInside(hearts[i][0]);
      }
    }
  }
}

// A small loop, to hang it in a window.
color("Black")
{
  linear_extrude(height_base+height_wall)
  {
    translate([0,128])
    {
      for(x=[-3,3])
        translate([x,-2.0])
          square([wall,6],center=true);

      translate([0,0.6])
      {
        difference()
        {
          circle(4.25);
          circle(4.25-wall);
          translate([-100,-100])
            square([200,100]);
        }
      }
    }
  }
}

// The shape of the heart is changed
// with the offset() function.
// The inside and outside get
// a different shape.
module HeartOutside(size)
{
  offset(r=0.5*wall+1)
    offset(delta=-1)
      heart2D(size=size,points=100);
}

module HeartInside(size)
{
  offset(delta=-0.5*wall)
    heart2D(size=size,points=100);
}

