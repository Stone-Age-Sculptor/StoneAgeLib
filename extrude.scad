// extrude.scad
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
// February 4, 2025
// Changes:
//   Function pillow from Reddit user oldesole1 removed.
//   He is working on his function to improve it.
//
// Version 3
// March 2, 2025
// Changes:
//   module outwards_bevel_extrude() added.
//   Name "linear_extrude_chamfer()" is
//   changed to "chamfer_extrude()".
//
// Version 4
// June 21, 2025
// Changes:
//   MakeFrame() added.
//
// Version 5
// December 8, 2025
// Changes:
//   Added a default convexity of 3 for all functions.
//
//
//
// This version number is the overall version for everything in this file.
// Some modules and functions in this file may have their own version.

if(version()[0] < 2024)
{
  echo("Warning: The roof() function is not available.");
}


// ==============================================================
// outward_bevel_extrude
// ---------------------
// A module that extrudes a 2D shape and
// can add a outwards bevel.
//
// Parameters:
//   height       The total height
//   bevel        The common height of the top and bottom bevel
//   bevel_top    The height of the top bevel.
//                Overrides the common bevel.
//   bevel_bottom The height of the bottom bevel.
//                Overrides the common bevel.
//
// To do: 
//   * Set the angle
//   * Combine with linear_extrude_chamfer with negative chamfer
module outward_bevel_extrude(height=1,bevel,bevel_top,bevel_bottom,convexity=3)
{
  epsilon = 0.001;

  bothbev   = is_undef(bevel)        ? 0 : bevel;
  topbev    = is_undef(bevel_top)    ? bothbev : bevel_top;
  bottombev = is_undef(bevel_bottom) ? bothbev : bevel_bottom;
  
  // Extrude the whole shape for the total height.
  linear_extrude(height,convexity=convexity)
    children();

  if(bottombev > 0)
    translate([0,0,bottombev])
      mirror([0,0,1])
        make_bevel(bottombev)
          children();
  
  if(topbev > 0)
    translate([0,0,height-topbev])
      make_bevel(topbev)
        children();

  module make_bevel(bev)
  {
    // A negative shape is used.
    // The angle for roof() is 45 degrees,
    // therefor the original shape is made
    // larger with the amount of the height
    // of the bevel.
    // That is used for the negative shape.
    difference()
    {
      linear_extrude(bev,convexity=convexity)
        offset(delta=bev+epsilon)
          children();

      // Calculate the roof() over the
      // negative shape.
      // Lower it a little to be sure
      // that the difference removes
      // all of it.
      translate([0,0,-epsilon])
        roof(convexity=convexity)
          difference()
          {
            offset(delta=2*bev+epsilon)
              children();
            children();
          }
    }
  }
}


// ==============================================================
// Route the roof() to either a fake roof for old versions
// of OpenSCAD or call the new roof() function.
module roof_router(convexity)
{
  if(version()[0] < 2024)
    fake_roof(convexity=convexity)
      children();
  else
    roof(convexity=convexity)
      children();
}


// ==============================================================
//
// fake_roof
// ---------
// Version 1
// January 31, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//
// Warning: It does not work well yet.
//
// The roof function is imitated.
// A minkowski with a upside down cone 
// on the negative 2D shape is used
// for a fake roof().
module fake_roof(convexity)
{
  difference()
  {
    epsilon = 0.01;
    boxsize = 10000;

    difference()
    {
      translate([-boxsize/2,-boxsize/2,0])
        cube(boxsize);
      
      // Speed up minkowski with render().
      // It seems just as slow.
      render()
        minkowski(convexity=convexity)
        {
          render()
            translate([0,0,-epsilon])
              linear_extrude(2*epsilon,convexity=3)
                difference()
                {
                  square(boxsize+1,center=true);
                  children();
                }
          cylinder(h=boxsize+1,d1=0,d2=2*(boxsize+1),$fn=8);
        }
    }
  }
}


// ==============================================================
//
// chamfer_extrude
// ---------------
// Extrude a 2D shape with a chamfered top and bottom.
// There are no checks yet for wrong parameters.
//
// Parameters:
//   height          : the total height
//   chamfer         : the chamfer for top and bottom
//   chamfer_top     : the top chamfer, overrides 'chamfer'
//   chamfer_bottom  : the bottom chamfer, overrides 'chamfer'
//   angle           : angle for top and bottom chamfer 1...89
//   angle_top       : top angle, overrides 'angle'
//   angle_bottom    : bottom angle, overrides 'angle'
module chamfer_extrude(height=1,chamfer,chamfer_top,chamfer_bottom,angle,angle_top,angle_bottom,convexity=3)
{
  bothchamf   = is_undef(chamfer)        ? 0 : chamfer;
  topchamf    = is_undef(chamfer_top)    ? bothchamf : chamfer_top;
  bottomchamf = is_undef(chamfer_bottom) ? bothchamf : chamfer_bottom;

  bothang     = is_undef(angle)          ? 45 : angle;
  topang      = is_undef(angle_top)      ? bothang : angle_top;
  bottomang   = is_undef(angle_bottom)   ? bothang : angle_bottom;

  // The roof() has a 45 degree angle.
  // That makes it easy to set the angle,
  // because the tangens of 45 is 1.
  topscale    = tan(topang);
  bottomscale = tan(bottomang);

  intersection()
  {
    union()
    {
      // The bottom chamfer.
      // Since the roof() function is only upward,
      // a mirror() is used.
      // It is raised a tiny amount to be sure
      // that it connects to the middle part.
      if(bottomchamf > 0)
        color("#4DB58D")
          translate([0,0,bottomchamf+0.001])
            mirror([0,0,1])
              scale([1,1,bottomscale])
                roof_router(convexity=3)
                  children();

      // The middle part.
      color("#26E49C")
        translate([0,0,bottomchamf])
          linear_extrude(height-bottomchamf-topchamf,convexity=convexity)
            children();

      // The top chamfer.
      // It is lowered a tiny amount to be sure
      // that it connects to the middle part.
      if(topchamf > 0)
        color("#4CA986")
          translate([0,0,height-topchamf-0.001])
            scale([1,1,topscale])
              roof_router(convexity=3)
                children();
    }

    // To make it look better in the preview,
    // the box for the intersection is made bigger for
    // x and y and is made bigger for z when there is
    // no chamfer on that surface.
    zlower = bottomchamf == 0 ? 1 : 0;
    zupper = topchamf    == 0 ? height + zlower + 1 : height + zlower;
    color("#A4D3C1")
      translate([0,0,-zlower])
        linear_extrude(height=zupper,convexity=convexity)
          offset(2)        // 1.0001 or 2 or any value above 1.
            children();
  }  
}

// ==============================================================
//
// MakeFrame
// ---------
// Make a frame from a 2D profile.
// The frame is on top of the xy-plane, 
// and centerend around (0,0).
// The 2D profile should have the lower-left at (0,0),
// with the height in y-direction and the 
// inside profile in x-direction.
// Parameters:
//   width : The outside width
//   height: The outside height
//   radius: The radius of optional round corners.
//   loop_thickness:
//           The thickness of the loop.
//           Default zero for no loop.
// Warning:  There is no check if the round corner is possible.
// Notes:    The frame consists of pieces added together,
//           the ideal frame would use a polyhedron.
//           A custom frame shape is not possible.
// To do:    Optional holes in the frame for a screw or hook.
module MakeFrame(width,height,radius=0,loop_thickness=0,convexity=5)
{
  e1 = 0.0001;

  if(radius==0)
  {
    // Normal straight corners.
    //
    // The bars will be a little longer
    // to be sure that they connect.
    w1 = width + e1;
    h1 = height + e1;

    // bar on the right and mirrored for the left
    for(m1=[0,1])
      mirror([m1,0,0])
        translate([width/2,0,0])
          rotate([0,0,90])
            MakeBarWithSlantedEnds(h1,convexity)
              children();

    // top bar and mirrored for the bottom
    for(m1=[0,1])
      mirror([0,m1,0])
        translate([0,height/2,0])
          rotate([0,0,180])
            MakeBarWithSlantedEnds(w1,convexity)
              children();
  }
  else
  {
    // With round corners.
    //
    // The straight pieces should connect to 
    // the round corners, so they are made
    // longer to be sure that they connect.
    w2 = width - 2*radius + e1;
    h2 = height - 2*radius + e1;

    // bar on the right and mirrored for the left
    for(m1=[0,1])
      mirror([m1,0,0])
        translate([width/2,0,0])
          rotate([90,0,180])
            linear_extrude(h2,center=true,convexity=convexity)
              children();

    // top bar and mirrored for the bottom
    for(m1=[0,1])
      mirror([0,m1,0])
        translate([0,height/2,0])
          rotate([90,0,-90])
            linear_extrude(w2,center=true,convexity=convexity)
              children();

    // Round corners.
    // The inside of the bar is in the x-direction.
    // That could be flipped for the rotate_extrude,
    // but here the 2D profile is shifted to the left.
    for(mx=[0,1],my=[0,1])
      mirror([mx,0,0])
        mirror([0,my,0])
          translate([-width/2+radius,-height/2+radius,0])
            rotate_extrude(angle=90)
              translate([-radius,0,0])
                children();
  }

  // Using a fixed shape for the loop.
  if(loop_thickness>0)
  {
    linear_extrude(loop_thickness,convexity=convexity)
      translate([0,height/2+6])
        Loop2D();
  }
}

// A bar of the profile with slanted ends.
module MakeBarWithSlantedEnds(length,convexity=3)
{
  // The profile could have a coordinate with a
  // negative x value.
  // To make that possible, the bar is
  // made larger by 1000.
  l2 = length + 1000;

  // The resulting actual length.
  l3 = length/2;

  intersection()
  {
    rotate([90,0,90])
      linear_extrude(l2,center=true,convexity=convexity)
        children();

    // A triangle to create the slanted ends.
    //
    // The profile could have a coordinate with a
    // negative x or negative y value.
    // To make that possible, the intersection triangle
    // is made extra large and is also below 
    // the xy-plane.
    p = [[-2*l3,-l3],[2*l3,-l3],[0,l3]];
    linear_extrude(10000,center=true,convexity=convexity)
      polygon(p);
  }
}

// A loop to hang the frame on a wall.
// The shape is fixed for now.
module Loop2D()
{
  width = 2;       // the width of the loop legs
  leg_length = 8;  // leg length

  // The circular piece at the top end.
  difference()
  {
    // outside
    circle(d=4*width);
    // remove inside.
    circle(d=2*width);
    // remove the lower part.
    translate([0,-10])
      square(20,center=true);
  }

  // The legs (vertical pieces).
  // The open middle has twice the width
  // as the width of the legs.
  for(xs=[-1,1])
    translate([xs*(width+1),-leg_length/2+0.001])
      square([width,leg_length],center=true);
}

// ==============================================================

