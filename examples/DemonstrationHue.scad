// DemonstrationHue.scad
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
include <StoneAgeLib/color.scad>

$fa = 5;
$fs = 2;
epsilon = 0.001;

// The large flat piece with colors,
// and the hue value as text.
for(i=[0:360])
{
  translate([i,0])
  { 
    color(Hue(i))
      cube([1+epsilon,100,0.1]);

    font_size = 4;
    if(i%5==0)
      color("Black")
        translate([font_size/2,85,1.1])
          rotate(90)
            linear_extrude(0.2)
              text(str(i),size=font_size);
  }
}

// A rod with extras to show the use of colors.
translate([0,-50,0])
{
  difference()
  {
    color(Hue(40))
      rotate([0,90,0])
        cylinder(h=180,d=30);

    rotate([0,90,0])
      for(a=[0:45:360-30])
        rotate(a)
          translate([15,0,90])
            color(Hue(a))
              sphere(5);

    color(Hue(40))
      translate([140,0,37])
        cube(60,center=true);

    color(Hue(0))
      translate([115,-9,6])
        linear_extrude(10,convexity=3)
          text("ABC",size=18);
  }
}

translate([20,-50,0])
{
  color(Hue(100))
    rotate([0,90,0])
      cylinder(h=20,d=50,center=true);
  
  for(a=[0:20:360-20])
    rotate([a,0,0])
      color(Hue(a))
        cylinder(h=26,r=4);
}

translate([60,-50,0])
{
  difference()
  {
    color(Hue(260))
      rotate([0,90,0])
        cylinder(h=20,d=50,center=true);

    color(Hue(180))
      rotate([0,90,0])
      rotate_extrude()
        translate([25,0,0])
          circle(5);
  }
}
