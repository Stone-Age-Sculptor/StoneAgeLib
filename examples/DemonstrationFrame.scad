// DemonstrationFrame.scad
//
// Demonstration for the StoneAgeLib
//
// Version 1
// September 9, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)


// Either include everything with
// the file StoneAgeLib.scad, or
// include only what is needed.

//include <StoneAgeLib/StoneAgeLib.scad>
include <StoneAgeLib/extrude.scad>

$fn = 100;

loop_thickness = 2;

// Four picture frames are made.
// These are demonstrations picture frames,
// to show that any shape is possible.

translate([0,0,0])
{
  // Show the 2D profile, only in preview mode.
  if($preview)
  {
    Profile1();
    color("Navy")
      translate([-10,-5])
        text("Profile 1",size = 4);
  }

  // Make the full frame.
  // Parameters:
  //   x size, y size, round corners, loop thickness
  MakeFrame(70,50,0,2)
    Profile1();
}

translate([90,0,0])
{
  if($preview)
  {
    Profile2();
    color("Navy")
      translate([-10,-5])
        text("Profile 2",size = 4);
  }

  MakeFrame(75,55,20)
    Profile2();
}

translate([0,-80,0])
{
  if($preview)
  {
    Profile3();
    color("Navy")
      translate([-10,-5])
        text("Profile 3",size = 4);
  }

  MakeFrame(70,50)
    Profile3();
}

translate([90,-80,0])
{
  if($preview)
  {
    Profile4();
    color("Navy")
      translate([-10,-5])
        text("Profile 4",size = 4);
  }

  MakeFrame(50,50,13,2)  
    Profile4();
}

// The profile of the frame in 2D.
// The base is at (0,0).
// The top is in y-direction.
// The width is in x-direction.
module Profile1()
{
  square([4,10]);
  square([9.5,5]);
  translate([4,5])
    circle(d=8);
}

// This is a profile, that could
// be made with a flexible filament
// and could be a press fit into
// an other shape.
module Profile2()
{
  offset(r=-0.3)
    offset(r=0.6)
      offset(delta=-0.3)
      {
        square([4,18]);

        for(i=[0:4])
          translate([0,3*i])
            polygon([[0,0],[-3,0],[0,3]]);
      }
}

// This is a profile that has
// a outer side with a indent.
// There are also parts that
// have negative x and y
// coordinates.
module Profile3()
{
  difference()
  {
    union()
    {
      square([4,10]);
      square([9.5,5]);
      translate([4,5])
        circle(d=8);

      // Something extra on outside wall.
      translate([0,7.5])
        circle(1.3,$fn=8);

      // Something at the bottom.
      for(x=[1:1.5:9])
        translate([x,+0])
          circle(0.5,$fn=8);
    }
    // An gap with a slope.
    translate([0,2])
      rotate(15)
        square([6,3]);
  }
}

module Profile4()
{
  difference()
  {
    offset(1)
      Curve();
    Curve();
    translate([0,-50])
      square(100,center=true);
  }

  module Curve()
  {
    difference()
    {
      translate([-8,0])
        circle(10);
      translate([-10,0])
        circle(10);
    }
  }
}