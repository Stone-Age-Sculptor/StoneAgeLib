// texture.scad
//
// Part of the StoneAgeLib
//
// Version 1
// February 3, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
// The FlexHex stones are by "degroof" (Steve DeGroof), license CC0.
//
// Version 2
// March 2, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
// Changes:
//   Granules added.
//
// Version 3
// June 4, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
// Changes:
//   vector_add_2D() is now called vector_add().
//
// This version number is the overall version for everything in this file.
// Some modules and functions in this file may have their own version.

include <list.scad>

// ==============================================================
//
// Granules
// --------
// A cube is made with a rough top surface.
// It is almost like a wall with granules.
// 
module Granules(size=[100,100,1],density=8000)
{
  granules_height = 0.2;
  epsilon = 0.001;

  render(convexity=3)
  {
    // Make it a little higher to be sure that
    // the granules connect.
    cube([size.x,size.y,size.z-granules_height+epsilon]);

    for(i=[0:density])
    {
      x = rands(0,size.x,1)[0];
      y = rands(0,size.y,1)[0];
      z = size.z-granules_height;
      s = rands(0.6,1.5,1)[0];

      translate([x,y,z])
        cylinder(h=granules_height, r1=s,r2=s/2,$fn=6);
    }
  }
}

// ==============================================================
//
// Dimples
// -------
// The surface is made rough by many spheres.
// The spheres are flatten with "scale()".
// The location and size and the scaling are random.
// Parameters:
//   xsize   the size in x-direction for the area
//   ysize   the size in y-direction for the area
//   density About 100 to fill it completely
module Dimples(xsize=100,ysize=100,density=100)
{
  // Guess the amount of dimples
  number = xsize * ysize * density / 200;

  // Makes lists with coordinates
  // and lists with size and scaling.
  coord_x = rands(-xsize/2,xsize/2,number);
  coord_y = rands(-ysize/2,ysize/2,number);
  scaling = rands(1,6,number);
  size    = rands(0.1,0.8,number);

  // Make the dimples.
  // The "render" speeds up the usage.
  render()
  {
    for(i=[0:number-1])
      translate([coord_x[i],coord_y[i],0])
        scale([scaling[i],scaling[i],1])
          intersection()
          {
            sphere(size[i],$fn=7);
            translate([-10,-10,0])
              cube(20);
          }
  }
}


// ==============================================================
//
// Crease2D
// --------
// This module creates a 2D crease shape.
// It it meant to be used with roof() to
// make creases in a flat surface.
//
// The shape is centered around the middle (0,0).
// When the angle variation is set to 50,
// then the total size is about from -100 to +100.
//
// Parameters:
//   pieces    
//      The number of line pieces.
//      Default 8, between 2 and 100 are good values.
//   variation
//      The angle for the maximum change in direction.
//      Default 50, from 10 to 100 are good values.
//   thickness
//      The thickness of the line.
//      Default 2, from 0.5 to 10 are useful values.
//
// Note: A previous version of Crease2D is in
//       my "Brick With Text" 3D model, but that
//       had a bug.
module Crease2D(pieces=8,variation=50,thickness=1.5)
{
  // Create a list with individual vectors.
  vectors = 
  [ 
    [0,0],
    let(start_angle = rands(0,360,1)[0])
    for(i=[0:pieces]) 
      let(angle  = rands(start_angle-variation,start_angle+variation,1)[0])
      let(length = rands(100/pieces,400/pieces,1)[0])
      let(x = length*cos(angle))
      let(y = length*sin(angle))
      [x,y]
  ];

  // Make a list with coordinates.
  points = vector_add(vectors); 

  // Draw lines between the coordinates.
  // The offset is used to center the shape.
  for(i=[0:pieces-1])
  {
    offset = points[len(points)-1] / 2;
    hull()
    {
      translate(points[i]-offset)
        circle(thickness,$fn=5);
      translate(points[i+1]-offset)
        circle(thickness,$fn=5);
    }
  }
}

// ==============================================================
//
// **********************************************
// **                                          **
// **            FlexHex Stones                **
// **                                          **
// **********************************************
//
// Original:
// "Irregular Grid Flexible Sheet"
// https://www.printables.com/model/222827-irregular-grid-flexible-sheet
// https://www.thingiverse.com/thing:5406876
// By "degroof" (Steve DeGroof) www.stevedegroof.com
// Uploaded June 09, 2022
// License CC0 Public Domain
//
// Version 2
// January 22, 2023
// License: CC0 (Public Domain)
// Changes by: Stone Age Sculptor:
//   I call them "FlexHex Stones".
//   I removed the flat base, only the FlexHex stones are created.
//   That makes it also possible to put a fabric halfway.
//   The height is now the height of the stones.
//   The bottom starts at z position 0.
//   The seed for the random is added as a parameter.
//   All irregular stones are first created in 2D.
//   The extrusion is done at the end.
//   Add your own bottom to connect all the stones.
//   I found this more useful when using it in a scene.
//
// Version 3
// January 19, 2025
// License CC0 (Public Domain)
// Changes by: Stone Age Sculptor:
//   The default seed is now a random.
//   The size is now default 100x100
//   Added a FlexHex2D() with the same parameters.
//
//
// FlexHex
// -------
// Creates a flexible rectangular sheet of irregular hexagons, 
// maintaining a consistent gap between each flexhex stone.
//
// Parameters:
//   l = length
//   w = width
//   h = height of the flexhex stones
//   grid = spacing between the hexagons
//   gap = spacing between hexagons
//   irregularity = amount of irregularity in hexagons (0-100) 
//   s = seed for random pattern, the same seed will give the same pattern.
module FlexHex(l=100,w=100,h=2,grid=10,gap=1.5,irregularity=50,s=rands(0,10000,1)[0])
{
  d=grid/sin(60)-gap;
  wc=ceil(w/grid/sin(60)+4);
  lc=ceil(l/grid+4);
  rs=rands(-grid/400*irregularity,grid/400*irregularity,wc*lc*4+2,s);

  if(h>0)
  {
    linear_extrude(h,convexity=2)
      MakeGrid();
  }
  else
  {
    MakeGrid();
  }

  module MakeGrid()
  {
    for(yc=[0:l/grid+1], xc=[0:w/grid/sin(60)+1])
      translate([-w/2+(xc*grid)*sin(60),-l/2+yc*grid+(xc%2)*(grid/2),0])
        irregularHexagon(h,d,xc,yc,rs,wc);
  }
}

// Keep the parameters the same as the 3D module.
module FlexHex2D(l=100,w=100,h=2,grid=10,gap=1.5,irregularity=50,s=rands(0,10000,1)[0])
{
  FlexHex(l=l,w=w,h=0,grid=grid,gap=gap,irregularity=irregularity,s=s);
}

// irregularHexagon
// ----------------
// Hexagon with randomized offsets on vertices. 
//
// Parameters:
//   h = height
//   d = diameter
//   x = x position
//   y = y position
//   rs = random numbers used to alter verices
//   wc = width count used to look up random numbers
module irregularHexagon(h,d,x,y,rs,wc)
{
  blx=((x+wc*y*2)+wc*(x%2))*2;
  bly=blx+1;
  brx=((x+1+wc*y*2)+wc*(x%2))*2;
  bry=brx+1;
  lx=((x+wc*(y*2+1))+wc*(x%2))*2;
  ly=lx+1;
  rx=((x+1+wc*(y*2+1))+wc*(x%2))*2;
  ry=rx+1;
  tlx=((x+wc*(y*2+2))+wc*(x%2))*2;
  tly=tlx+1;
  trx=((x+1+wc*(y*2+2))+wc*(x%2))*2;
  try=trx+1;
  
  p=
  [
    [(-d/4+rs[blx]),(-d/2*sin(60)+rs[bly])], // lower left
    [(d/4+rs[brx]),(-d/2*sin(60)+rs[bry])],  // lower right
    [(d/2+rs[rx]),rs[ry]],                   // right
    [(d/4+rs[trx]),(d/2*sin(60)+rs[try])],   // upper right
    [(-d/4+rs[tlx]),(d/2*sin(60)+rs[tly])],  // upper left
    [(-d/2+rs[lx]),rs[ly]]                   // left
  ];
  polygon(p);
}

// ==============================================================
