// DemonstrationMatrixSubdivision.scad
//
// Demonstration for the StoneAgeLib
//
// Version 1
// October 29, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)

include <StoneAgeLib/StoneAgeLib.scad>

// The control points of a boat hull.
// Only the values on the positive x-axis are defined,
// the other half is added with a function.
matrix_half =
[
  [ [0,0,0],     [2,2,0],      [6,10,0],   ],
  [ [0,-3,30],   [6,30,12],    [20,40,0],  ],
  [ [0,80,30],   [21,80,12],   [20,80,0],  ],
  [ [0,120,17],  [13,120,12],  [20,120,0], ],
  [ [0,160,0],   [10,158,0],   [13,153,0], ],
];

// Mirror for the negative x-axis and combine both.
matrix = MatrixAddMirror(matrix_half);

// Show the designer.
// This is used to develop the shape 
// by changing the control points.
MatrixSubdivisionDesigner(matrix);

// Use Matrix Subdivision for a smooth shape.
smooth = MatrixSubdivision(matrix,divisions=4);

// Convert the matrix with rows and columns
// the represent a surface, into points and 
// faces for a polyhedron.
// The volume is given by extruding it down
// to the xy-plane.
vnf = MatrixExtrudeDown(smooth);

// Show the boat hull.
translate([70,0,25])
  mirror([0,0,1])
    polyhedron(vnf[0],vnf[1]);

