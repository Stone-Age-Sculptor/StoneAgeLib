// matrix.scad
//
// Part of the StoneAgeLib
//
// Version 1
// October 25, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
// Initial version, designed from scratch, tested with a few models.
//
// This version number is the overall version for everything in this file.
// Some modules and functions in this file may have their own version.
//
// Note: The term "VNF" is borrowed from the BOSL2 library.
//       It stands for "Vertices aNd Faces" and is an array
//       with points and faces for the polyhedron() function.



// ==============================================================
//
// MatrixSubdivision
// -----------------
// Subdivide a matrix of 3D data points.
// It can be a surface or a tube. 
// Parameters:
//   matrix:
//     A matrix with 3D coordinates as rows and columns.
//     They represent a surface or tube in 3D.
//   divisions:
//     The number of subdivisions for the Subdivision() function.
//   method:
//     The method for the Subdivision() function.
//   tube:
//     Set to false for a surface, set to true for a tube shape.
//   size:
//     Not used. 
//     It is added to be compatible with MatrixSubdivisionDesigner().
// Return:
//   The return is a subdivided surface.
//   It is also as a matrix, but with more rows and more columns.
//
function MatrixSubdivision(matrix,divisions=$preview?2:4,method="1",tube=false,size=1) = 
  // Number of rows and columns.
  let(rows = len(matrix))    // number of rows of control points.
  let(columns = len(matrix[0])) // number of columns of control points.
  let(methodsplit = MethodSplitName(method))
  // The 'method_path' is always with the path.
  // This is the normal subdivision for a line of points.
  let(method_path = methodsplit[1])
  // The 'method_wrap' is optional without the path.
  // Without the path it wraps around for a tube.
  let(method_wrap = tube ? methodsplit[0] : methodsplit[1])

  // Creating subdivided rows and columns.
  let(subrows = 
    [
      // Pick a single row, and subdivide that.
      for(r=[0:rows-1])
        Subdivision(matrix[r],divisions=divisions,method=method_path)
    ])
  let(subcolumns = 
    [
      // Gather the data of a column, and subdivide that.
      for(c=[0:columns-1])
        let(list = [for(i=[0:rows-1]) matrix[i][c]])
        Subdivision(list,divisions=divisions,method=method_path)
    ])
  // Use crossways new subdivision points from 
  // the just created subdivision points of the rows and columns.
  // As if the new points are woven into the subdivision points.
  let(weaverows = 
    [
      for(i=[0:len(subcolumns[0])-1])
        let(list = [ for(j=[0:columns-1]) subcolumns[j][i] ])
        Subdivision(list,divisions=divisions,method=method_wrap),
    ])
  // The woven subdivision for the columns creates the
  // same points as for the rows.
  // I did not know that, it was coincidental.
  //    weavecolumns = 
  //    [
  //      for(i=[0:len(subrows[0])-1])
  //        let(list = [ for(j=[0:rows-1]) subrows[j][i] ])
  //        Subdivision(list,divisions=divisions,method=method_wrap),
  //    ])

  // Return a two-dimensional matrix with the subdivided surface.
  weaverows;


// ==============================================================
//
// MatrixExtrudeDown
// -----------------
// A surface as a matrix (with rows and columns) 
// is extruded downwards to the xy-plane.
// The surface can be a subdivided matrix.
//
// Parameters:
//   matrix: 
//     3D coordinates as rows and columns,
//     representing a surface.
// Return:
//   The return is an array with points and faces 
//   as a VNF to be used with a polyhedron.
//
function MatrixExtrudeDown(matrix) = 
  let(n = len(matrix))       // Number of rows.
  let(m = len(matrix[0]))    // Number of columns.
  let(t = 2*(m-1) + 2*(n-1)) // Number of points of xy-plane shape.

  // Create new points at the xy-plane to extrude the surface
  // downward. Use only the outside points.
  // The points on the edges of the surface are taken,
  // and the z-value is made zero.
  let(bottompoints=
  [
    // Front side, in positive x-direction.
    for(i=[0:m-2]) // not the last one
      [matrix[0][i].x, matrix[0][i].y, 0],

    // Right side, in positive y-direction.
    for(i=[0:n-2])  // not the last one 
      [matrix[i][m-1].x, matrix[i][m-1].y, 0],

    // Back side, in negative x-direction.
    for(i=[0:m-2])  // no the last one 
      [matrix[n-1][m-1-i].x, matrix[n-1][m-1-i].y, 0],

    // Left side, in negative y-direction.
    for(i=[0:n-2])  // not the last one 
      [matrix[n-1-i][0].x, matrix[n-1-i][0].y, 0],
  ]) 

  // The polyhedron needs a single dimension array
  // with all the points.
  // The subdivided matrix surface is turned into
  // a single dimension array.
  let(flattened_array =
  [
    for(i=[0:len(matrix)-1],j=[0:len(matrix[0])-1])
      matrix[i][j]
  ])
 
  // All the points together.
  let(points = concat(bottompoints,flattened_array))

  // The horizontal bottom face on the xy-plane.
  let(bottomface =
  [
    let(n=len(bottompoints))
      [for(i=[0:n-1]) i]
  ])

  // The vertical faces on the sides.
  // The calculations might seem confusion, and they are.
  // It took me a while to get it right.
  let(sidefaces = 
  [
    // Front side faces.
    for(i=[0:m-2])
    [i, i+t, i+t+1, i+1],
  
    // Right side faces.
    for(i=[0:n-2])
      [m-1+i, m-1+t+i*m, m-1+t+(i+1)*m, m+i],
  
    // Back side faces.
    for(i=[0:m-2])
      [m+n-2+i, t +n*m -1 -i , t +n*m -2-i, m+n-1+i],
 
    // Left side faces.
    for(i=[0:n-2])
      // The fourth point is the first point at [0]
      // when going fully around the base coordinates.
      let(fourth = i==(n-2) ? 0 : 2*(m-1) + (n-1) +1 +i)
      [2*(m-1) + (n-1) +i, t+(n)*(m)-m-i*m, t+(n)*(m)-m-(i+1)*m, fourth],
  ])

  // The faces of the subdivided surface.
  let(surfacefaces =
  [
    for(i=[0:n-2],j=[0:m-2])
      [t+(i*m)+j, t+(i+1)*m+j, t+(i+1)*m+j+1, t+(i*m)+j+1],
  ])

  // All the faces together.
  let(faces=concat(bottomface,sidefaces,surfacefaces))

  // Return the points and faces in a single array.
  [points,faces];
  

// ==============================================================
//
// MatrixAddMirror()
// -----------------
// When a matrix of points is defined with
// rows and columns and only with positive x values, 
// then this function mirrors the values for
// negative x values, and those are added to the rows.
//
// Limitation:
//   All the points in the first column should
//   have an x value that is either zero
//   or non-zero. They can not be mixed.
function MatrixAddMirror(list) =
  let(n=len(list)) 
  [for(i=[0:n-1]) _MatrixAddMirrorOneRow(list[i])];


// ==============================================================
//
// _MatrixAddMirrorOneRow
// ----------------------
// A helper function for MatrixAddMirror().
// Create a mirror on the negative x-axis for one row.
// When the first x-value is zero, then that one is not mirrored,
// because it is in the middle.
function _MatrixAddMirrorOneRow(list) =
   let(n=len(list))
   let(skip = (list[0].x == 0) ? 1 : 0)
   let(left = [for(i=[0:n-1-skip]) [-list[n-1-i].x,list[n-1-i].y,list[n-1-i].z]])
   let(right = [for(i=[0:n-1]) list[i]])
   concat(left,right); 
   
   
// ==============================================================
//
// MatrixVolume()
// --------------
// Give a surface a thickness.
// The surface has to be defined by a matrix of 3D points.
// The normal vectors are used to expand the surface into a volume.
// The resulting volume can be used with the polyhedron() function.
// Parameters:
//   matrix:
//       A two-dimensional array with 3D points,
//       representing a surface.
//       They are the row and columns of a matrix.
//       It could be a subdivided matrix.
//   height:
//       The height or thickness that is given to the surface.
//   center:
//       Set to true to expand the surface in both directions.
// Return:
//   The return value is an array with points and faces
//   (also called a VNF) to be used with a polyhedron.
// Note:
//   When the height is too high and the curves are too steep,
//   then the polyhedron might no longer be a valid shape.
// To do:
//   Allow not only a surface, but also a tube.
//
function MatrixVolume(matrix,height,center=false) =
  let(n = len(matrix))
  let(m = len(matrix[0]))
  let(t = n*m)
  // Use the input parameter 'matrix' as bottom, or
  // use half the height in both directions.
  let(bottom = center ? _MatrixOffsetPoints(matrix,-height/2) : matrix)
  let(top    = center ? _MatrixOffsetPoints(matrix,height/2)  : _MatrixOffsetPoints(matrix,height))
  // Convert the matrix of the bottom and top into a single long list of points.
  let(points =
    [ 
      for(i=[0:n-1])
        for(j=[0:m-1]) 
          bottom[i][j],
      for(i=[0:n-1])
        for(j=[0:m-1]) 
          top[i][j],
    ])
  // Calculate the bottom faces.
  let(bottomfaces =
    [
      for(i=[0:n-2],j=[0:m-2])
        [(i*m)+j, (i*m)+j+1, (i+1)*m+j+1, (i+1)*m+j],
    ])
  // Calculate the top faces.
  let(topfaces =
    [
      for(i=[0:n-2],j=[0:m-2])
        [t+(i*m)+j, t+(i+1)*m+j, t+(i+1)*m+j+1, t+(i*m)+j+1],
    ])
  // Calculate the side faces.
  let(sidefaces = 
    [
      // Front side faces.
      for(i=[0:m-2])
        [i, i+t, i+t+1, i+1],

      // Right side faces.
      for(i=[0:n-2])
        [m-1+i*m,t+m-1+i*m,t+m-1+(i+1)*m,m-1+(i+1)*m],
    
      // Back side faces.
      for(i=[0:m-2])
        [t-1-i,2*t-1-i,2*t-2-i,t-2-i],
   
      // Left side faces.
      for(i=[0:n-2])
        [t-m-i*m,2*t-m-i*m,2*t-m-(i+1)*m,t-m-(i+1)*m],
    ])
  // All faces together.
  let(faces = concat(bottomfaces,sidefaces,topfaces))
  // Return points and faces for a polyhedron.
  [points,faces];


// ==============================================================
//
// _MatrixOffsetPoints
// -------------------
// A helper function for MatrixVolume().
// A new matrix of points is created with
// an offset of "height" according to the normal vectors.
// Return: 
//   A matrix with the same rows and columns,
//   but the coordinates have an offset.
function _MatrixOffsetPoints(matrix,height) =
  let(n = len(matrix))         // rows
  let(m = len(matrix[0]))      // columns
  let(new_matrix =
    [ for(i=[0:n-1])
      [ for(j=[0:m-1])
        // Since it is a matrix, every piece has 4 points.
        // Only three points are used: the current point
        // and the two points on the left and on the right.
        // The opposite point is ignored.
        // A point in the middle of the matrix uses 
        // the average of 4 triangles.
        // A point on the side uses two triangles.
        // A point in the corner uses one triangle.
        
        // Normal vector of the upper-left triangle.
        // It is empty when there is no upper-left triangle.
        let(NV1 = ((i+1)<n && (j-1)>=0) ?
          [NormalVector(matrix[i][j],matrix[i][j-1],matrix[i+1][j])] : [])

        // Normal vector of the upper-right triangle.
        // It is empty, when that triangle does not exist.
        let(NV2 = ((i+1)<n && (j+1)<m) ?
          [NormalVector(matrix[i][j],matrix[i+1][j],matrix[i][j+1])] : [])

        // Normal vector of the lower-right triangle.
        // Empty when it does not exist.
        let(NV3 = ((i-1)>=0 && (j+1)<m) ?
          [NormalVector(matrix[i][j],matrix[i][j+1],matrix[i-1][j])] : [])

        // Normal vector of the lower-left triangle.
        // Empty when it does not exist.
        let(NV4 = ((i-1)>=0 && (j-1)>=0) ?
          [NormalVector(matrix[i][j],matrix[i-1][j],matrix[i][j-1])] : [])

        // Combine them in a list. The empty ones will drop out.
        let(NV = concat(NV1,NV2,NV3,NV4))

        // Take the average of the normal vectors.
        // I'm not sure if this is mathematically correct,
        // perhaps points that are futher away should have
        // less influence.
        // However, for practical use, it is good enough.
        // The number of vectors can be 1, 2 or 4.
        let(q = len(NV))
        let(avg = 
          q == 1 ? NV[0] :
          q == 2 ? (NV[0]+NV[1])/2 :
          q == 3 ? (NV[0]+NV[1]+NV[2])/3 :
          q == 4 ? (NV[0]+NV[1]+NV[2]+NV[3])/4 : [])
    
        // Set the thickness, the avg vector has a length of 1.
        let(normal = height*avg)
        
        // Finally a new point.
        let(new_point = matrix[i][j] + normal)
        new_point,
      ]
    ])
   new_matrix;


// ==============================================================
//
// NormalVector
// ------------
// Find the normal vector of a triangle.
// Parameters:
//   A, B, C:
//     Points in 3D, together they make a triangle.
// Return:
//   The normal vector of the triangle.
//   The normal vector has the lenght of 1,
//   and it is the direction, not a coordinate.
function NormalVector(A,B,C) =
  let(N = -cross(B-A,C-A))
  let(L = norm(N))
  N/L;


// ==============================================================
//
// MatrixSubdivisionDesigner
// -------------------------
// This module shows a surface or a tube from a matrix.
// It can be used to adjust the control points for
// the desired shape.
// Note:
//   The parameters are the same as for the MatrixSubdivision() function,
//   but that is a function that returns data and this module shows the shape.
module MatrixSubdivisionDesigner(matrix,divisions=$preview?2:4,method="1",tube=false,size=1)
{
  // Get the number of rows and columns of the matrix.
  columns = len(matrix[0]);
  rows = len(matrix);
  tube_width = 0.4*size; // smaller than the control points
  tube_accuracy = 5;     // good enough for the rods
  point_accuracy = 7;    // good enough for the points
  cube_size = 0.01;      // tiny cubes for surface

  // Show the control points in Red.
  color("Red",0.9)
    for(row=[0:rows-1],column=[0:columns-1])
      translate(matrix[row][column])
        sphere(d=size,$fn=point_accuracy);

  // Show the edges in brown.
  color("SaddleBrown",0.5)
  {
    // Tubes for the columns.
    for(c=[0:columns-1],r=[0:rows-2])
      hull()
        for(inc=[0,1])
          translate(matrix[r+inc][c])
            sphere(d=tube_width,$fn=tube_accuracy);

    // Tubes for the rows.
    // When the 'tube' mode is selected,
    // each row wraps around.
    max_columns = tube ? columns-1 : columns-2;
    
    for(r=[0:rows-1],c=[0:max_columns])
      hull()
        for(inc=[0,1])
        {
          c_new = (c+inc) % columns;
          translate(matrix[r][c_new])
            sphere(d=tube_width,$fn=tube_accuracy);
        }
  }

  // Show a transparent surface.
  // This is not a real shape, 
  // because a surface has no thickness.
  // A hull() is used over tiny cubes.
  //
  // For a tube, the surface wraps around.
  //
  // Make the subdivision surface.
  matrixsub = MatrixSubdivision(matrix,divisions,method,tube=tube);
  
  if($preview)
    %color("SkyBlue",0.6)
      ShowSurface();
  else
    color("SkyBlue")
      ShowSurface();
  
  module ShowSurface()
  {
    n = len(matrixsub);    // subdivided rows
    m = len(matrixsub[0]); // subdivided columns
    m_max = tube ? m-1 : m-2;

    for(i=[0:n-2],j=[0:m_max])
      hull()
        for(i_inc=[0,1],j_inc=[0,1])
        {
          // Wrap around the column, in case it is a tube.
          j_new = (j+j_inc) % m;
          translate(matrixsub[i+i_inc][j_new])
            cube(cube_size);
        }
  }
}   

