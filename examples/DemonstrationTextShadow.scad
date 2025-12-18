// DemonstrationTextShadow.scad
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
// November 30, 2025
// Only the "StoneAgeLib.scad" is included now.

include <StoneAgeLib/StoneAgeLib.scad>

$fn = 40;
epsilon = 0.001;

// Add shadow.
// The Shadow2D() shows only the shadow,
// the text itself has to be added as well.
translate([0,120,0])
{
  color("MediumTurquoise")
    linear_extrude(2)
      text("Shadow",size=50);
  color("Black")
    linear_extrude(1)
      Shadow2D(length=8)
        text("Shadow",size=50);
}

// Change font by combining the letter with its shadow.
translate([0,60,0])
{
  color("Navy")
    linear_extrude(2)
      // Grow both shapes with offset
      // to be sure that they connect
      offset(0.001)
      {
        // Some characters did not look good,
        // therefor the shadow is taken to the right
        // and to the left.
        text("WIDE",size=50,spacing=1.2);
        Shadow2D(length=10,angle=0)
          text("WIDE",size=50,spacing=1.2);
        Shadow2D(length=10,angle=180)
          text("WIDE",size=50,spacing=1.2);
      }
}

// Add a outline (with a little shadow).
translate([0,0,0])
{
  color("LightYellow")
    linear_extrude(1)
      text("OUTLINE",size=50);
  color("Black")
    linear_extrude(2)
      Shadow2D(length=5,width=1)
        text("OUTLINE",size=50);
}

// Add highlight
translate([0,-60,0])
{
  color("DarkGreen")
    linear_extrude(1)
      text("Highlight",size=50);
  color("SpringGreen")
    translate([0,0,1-epsilon])
      linear_extrude(0.2)
        Shadow2D(length=4,highlight=true)
          text("Highlight",size=50);
}

// Make it look good.
translate([0,-140,0])
{
  string = "Nice";

  // A base plate.
  color("Maroon")
    translate([-4,-11,0])
      cube([151,70,1]);

  // The black shadow
  color("Black")
    linear_extrude(1.2)
      Shadow2D(length=10)
        text(string,size=50);

  // The text itself
  color("GoldenRod")
    linear_extrude(5)
      text(string,size=50);

  // First highlight
  color("Gold")
    translate([0,0,5-epsilon])
      linear_extrude(0.2+epsilon)
        Shadow2D(length=3,highlight=true)
          text(string,size=50);

  // Second highlight
  color("White")
    translate([0,0,5.2-epsilon])
      linear_extrude(0.2+epsilon)
        Shadow2D(length=1,highlight=true)
          text(string,size=50);
}
