// Demonstration7segments.scad
//
// Demonstration for the StoneAgeLib
//
// Version 1
// March 2, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)


// Either include everything with
// the file StoneAgeLib.scad, or
// include only what is needed.

//include <StoneAgeLib/StoneAgeLib.scad>
include <StoneAgeLib/seven_segment.scad>
include <StoneAgeLib/subdivision.scad>

$fn=50;

animation = false;

if(animation)
{
  // $t is from 0 to 1.
  // Suppose the minutes count from 0 to 50
  // The colon blinks for each minute.
  //
  // Settings for OpenSCAD animation:
  //   FPS: 1 or 2 but also 1.5 is possible
  //   Steps: 99
  Clock(8,floor($t*50),(floor($t*100))%2 == 0);
}
else
{
  // Showcase without animation.

  // The digits 0...9 in blue.
  translate([1,1])
    color("Blue")
      linear_extrude(1)
        Draw7Segment("0123456789",style=0);

  // A clock, red digits on black.
  // With a colon in the middle.
  translate([1,18,0])
    Clock(1,23);

  // A clock with hours, minutes and seconds.
  // With green digits.
  // With two colons.
  translate([1,38,0])
    Clock(hours=1,minutes=23,seconds=45,colon=true,color="LawnGreen");

  // An LCD display.
  // With a decimal point and minus sign
  // and two characters for degrees Celsius.
  translate([50,17,0])
  {
    color("Gray")
      cube([49,14,1]);

    color("Silver")
      translate([1,1,0])
        linear_extrude(2)
          Round2D(2)
            square([47,12]);

    color("Black")
      translate([2,2,0])
        linear_extrude(3)
          Draw7Segment("-22.4 °C");
  }

  // Show the different styles
  if($preview)
  {
    translate([1,-24])
    {
      color("Indigo")
      {
        translate([0,0])
          text("style = 0",size=5);
        translate([29,0])
          scale([2,2])
            Draw7Segment("8",style=0);
        translate([50,0])
          text("style = 1",size=5);
        translate([78,0])
          scale([2,2])
            Draw7Segment("8",style=1);
      }
    }
  }

  // Show the A...F (for hexadecimal numbers).
  // The text "Happy Birthday" is more or less readable.
  if($preview)
    translate([1,-40,0])
      Draw7Segment("ABCDEF   Happy Birthday");

  // Show different settings for the parameters.
  if($preview)
  {
    translate([0,-54,0])
    {
      translate([0,0,0])
      {
        text("spacing = 0",size=5);
        translate([45,0])
          Draw7Segment("0123",spacing=0);
      }
      translate([0,-12,0])
      {
        text("spacing = 1.2",size=5);
        translate([45,0])
          Draw7Segment("0123",spacing=1.2);
      }
      translate([0,-24,0])
      {
        text("spacing = 2",size=5);
        translate([45,0])
          Draw7Segment("0123",spacing=2);
      }
      translate([0,-36,0])
      {
        text("shrink = 0",size=5);
        translate([45,0])
          Draw7Segment("0123",shrink=0);
      }
      translate([0,-48,0])
      {
        text("shrink = 0.12",size=5);
        translate([45,0])
          Draw7Segment("0123",shrink=0.12);
      }
      translate([0,-60,0])
      {
        text("shrink = 0.5",size=5);
        translate([45,0])
          Draw7Segment("0123",shrink=0.5);
      }
      translate([0,-72,0])
      {
        text("angle = 0",size=5);
        translate([45,0])
          Draw7Segment("0123",angle=0);
      }
      translate([0,-84,0])
      {
        text("angle = 8",size=5);
        translate([45,0])
          Draw7Segment("0123",angle=8);
      }
      translate([0,-96,0])
      {
        text("angle = 20",size=5);
        translate([45,0])
          Draw7Segment("0123",angle=20);
      }
    }
  }
}

module Clock(hours=0,minutes,seconds,colon=true,color="Red")
{
  // When the seconds are defined, then it is probably
  // the hours, minutes and seconds and it is larger.
  length = is_num(seconds) ? 45 : 30.2;

  color("#404040")
    cube([length,12,1]);

  color(color)
    translate([1,1,0])
      linear_extrude(2)
        Clock7Segment(hours=hours,minutes=minutes,seconds=seconds,colon=colon);
}
