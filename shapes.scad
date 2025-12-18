// shapes.scad
//
// Part of the StoneAgeLib
//
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//
// Version 1
// February 3, 2025
//
// Version 2
// February 7, 2025
// Changes:
//   Added "center" parameter to cylinder_fillet().
//
// This version number is the overall version for everything in this file.
// Some modules and functions in this file may have their own version.


// cylinder_fillet
// ---------------
// A cylinder with optional inward or outward
// fillet for the top and bottom.
// The outward fillet is to connect it to a flat surface.
//
// Parameters:
//   h = the height
//   r = radius, default 1
//   d = diameter, can be used instead of radius
//   fillet = fillet for top and bottom.
//       A positive value for a outward fillet 
//       and a negative value for a inward fillet.
//   fillet_top = fillet for the top, overrides 'fillet'.
//   fillet_bottom = fillet for the bottom, overrides 'fillet'.
//   printable = add a 45 degrees angle at the bottom,
//               to make it printable without support
//   center = set to true to center it. Default false.
//
// Note: There is no check for a inward fillet that is too large.
// To do: Allow any angle for the optional chamfer
//        at the bottom.
module cylinder_fillet(h,r=1,d,fillet,fillet_top,fillet_bottom,printable=false,center=false)
{
  radius = is_undef(d) ? r : d/2;
  epsilon = 0.001;

  filcommon = is_undef(fillet)        ? 0 : fillet;
  filtop    = is_undef(fillet_top)    ? filcommon : fillet_top;
  filbottom = is_undef(fillet_bottom) ? filcommon : fillet_bottom;
  zshift    = center == true          ? -h/2       : 0;

  translate([0,0,zshift])
  {
    if(filbottom < 0)
    {
      translate([0,0,-filbottom])
        mirror([0,0,1])
          FilletInwards(radius,-filbottom,print=printable);
    }
    else if(filbottom > 0)
    {
      FilletOutwards(radius,filbottom);
    }

    // The middle part is made larger towards the top and bottom,
    // to be sure that the pieces connect.
    larger_for_bottom = filbottom == 0 ? 0 : epsilon;
    larger_for_top    = filtop    == 0 ? 0 : epsilon;
    translate([0,0,abs(filbottom) - larger_for_bottom])
      cylinder(h-abs(filtop)-abs(filbottom)+larger_for_top+larger_for_bottom,r=radius);

    if(filtop < 0)
    {
      translate([0,0,h+filtop])
        FilletInwards(radius,-filtop);
    }
    else if(filtop > 0)
    {
      translate([0,0,h])
        mirror([0,0,1])
          FilletOutwards(radius,filtop);
    }
  }

  module FilletInwards(r_outer,r_tube,print=false)
  {
    // Oversize the box to avoid rounding glitches.
    box = [2*r_outer+1,2*r_outer+1,r_tube+1];
    x1 = r_tube * sqrt(2)/2;
    x2 = r_tube * (sqrt(2)-1);
    y  = r_tube * sqrt(2)/2;

    // A polygon that can be added for a slanted
    // bottom to make it printable without support.
    printable_polygon =
    [
      [0,y],[0,r_tube],[r_outer-r_tube+x2,r_tube],[r_outer-r_tube+x1,y]
    ];
    
    hull()
    {
      difference()
      {
        rotate_extrude()
        {
          translate([r_outer-r_tube,0])
            circle(r_tube);
          if(print)
            polygon(printable_polygon);
        }
        translate([0,0,-box.z/2])
          cube(box,center=true);
      }
    }
  }

  module FilletOutwards(r_outer,r_tube)
  {
    rotate_extrude()
      difference()
      {
        square([r_outer+r_tube,r_tube]);
        translate([r_outer+r_tube,r_tube])
          circle(r_tube);
      }
  }
}


// ==============================================================
//
// heart2D
// -------
// June 4, 2024, Version 1
// by Stone Age Sculptor, CC0, Public Domain
//
// The lower part of the heart is a sine curve on its side.
// The upper part consists of two circle.
//
// Parameters:
//   size   : Set the size (by specifying the width).
//   raise  : Raise the middle between the circles at the top.
//   stretch: Stretch the lower part.
//   shift  : Shift the bottom tip sidewards.
//   points : Total number of points for the shape.
//
// To do: add a variable to make the tip at the bottom less pointy.
//
module heart2D(size=10,raise=0.1,stretch=0.1,shift=0,points=50)
{
  // Since the shape is made in four parts,
  // the number of points is divided by 4.
  // It is allowed that "n1" is not a whole number,
  // since the for-loop does not iterate with whole numbers.
  n1 = points / 4;

  c1 = 2*sqrt(2) + stretch;

  // Extra radius for the circles at the top.
  // It can not be a negative number.
  // When the "raise" and "stretch" are the same number,
  // then the "raise" should be half the value of "stretch"
  // for a match for the shape.
  e1 = raise < 0 ? 0 : raise / 2; 

  // The angle for the circles at the top are normally from 0 to 180.
  // However, if the middle between the circles is raised, 
  // then less than 180 degrees is used.
  a1 = acos((1-e1)/(1+e1));

  // Helper variables.
  a2 = 180 - a1;
  m1 = 1 - e1;
  p1 = 1 + e1;

  heart_points = 
  [
    for(i=[0:1/n1:1]) [  1+sin(   i *180-90) +pow(1-i,3)*shift, c1*   i],
    for(i=[0:1/n1:1]) [  m1+p1*cos(   i *a2) , c1+p1*sin(   i*a2)],
    for(i=[0:1/n1:1]) [-(m1+p1*cos((1-i)*a2)), c1+p1*sin(a1+i*a2)],
    for(i=[0:1/n1:1]) [-(1+sin((1-i)*180-90))+pow(  i,3)*shift, c1*(1-i)],
  ];

  // The "heart_points" are for a heart with a width of 4.
  // Adjust to the final size.
  scale([size/4,size/4])
    polygon(heart_points);
}

// ==============================================================


