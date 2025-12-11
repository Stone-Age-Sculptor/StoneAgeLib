// DemonstrationFontCustomRender.scad
//
// Demonstration for the StoneAgeLib
//
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//
// Version 1
// December 11, 2025

include <StoneAgeLib/StoneAgeLib.scad>

$fn = 50;

// Demonstration to use a custom render function,
// which is called from the text_subdivision function.
text_subdivision("abc",smooth=4,custom=true);

// The function "CustomRender()" is called
// from the function text_subdivision().
// The list can be a single point in 2D,
// or two coordinates in 2D.
module CustomRender(list,width)
{
  if(len(list)==2)
  {
    hull()
      for(i=[0,1])
        translate(list[i])
          Inflated(width);
  }
  else if(len(list)==1)
  {
    translate(list[0])
      Inflated(width);
  }
}

// A rounded pin according to the profile.
module Inflated(width)
{
  rotate_extrude()
    InflatedProfile(width,0.3*width,0.15*width,2.0);
}

// A profile for a "inflated" look.
// width  : total width
// height : total height upward.
// radius : radius at the outside edge
// factor : how much larger the radius is for the top.
module InflatedProfile(width,height,radius,factor)
{
  r_edge = radius;
  r_top  = radius * factor;

  w_top = width/2 - r_top;
  w_bottom = width/2;

  square([w_top,height]);
  square([w_bottom,height-r_edge]);

  translate([w_bottom-r_top,height-r_edge])
    intersection()
    {
      scale([factor,1])
        circle(r_edge);
      square([r_top,r_edge]);
    }
}