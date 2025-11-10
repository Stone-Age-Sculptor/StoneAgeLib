// DemonstrationMatrixVolume.scad
//
// Demonstration for the StoneAgeLib
//
// Version 1
// November 10, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)

include <StoneAgeLib/StoneAgeLib.scad>

// Horse Saddle curve: z = x² - y²

// 'n' is number of divisions.
n = $preview ? 8 : 100;
step = 2 / n;

// Create an array with rows and columns.
matrix =
[
  for(y=[-1:step:1])
  [
    for(x=[-1:step:1])
      [x,y,1.1+(x*x)-(y*y)],
  ],
];

// Give the surface a thickness.
vnf = MatrixVolume(matrix,height=0.1,center=true);

// Scale it up 50 times and show it.
polyhedron(50*vnf[0],vnf[1]);
