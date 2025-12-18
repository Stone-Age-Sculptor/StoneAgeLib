// matrix.scad
//
// Part of the StoneAgeLib
//
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//
// Version 1
// October 25, 2025
// Initial version, designed from scratch, tested with a few models.
//
// Version 2
// November 1, 2025
// Changes:
//   The MatrixVolume() function now accepts also a tube.
//
// Version 3
// November 30, 2025
// Changes:
//   MatrixAddMirror() can now mirror for both x and y values.
//   Experimental MatrixDisc() functions added.
//   MatrixAddNoise(), MatrixForce(), MatrixRotateExtrude() added.
//   MatrixVolume can detect unreliable edge-points and fix it.
//
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
// MatrixAddMirror
// ---------------
// When a matrix of points is defined with
// rows and columns, then this function
// mirrors the points to the negative x-axis or
// the negative y-axis or both. The mirrored points
// are added to the matrix.
//
// Parameters:
//   matrix:
//     A two-dimensional array of points
//     as rows and columns.
//   v:
//     The vector, use a 1 for x or y or both.
// Return:
//   The new (probably larger) matrix.
//
// Limitation:
//   All the points at the mirror line should
//   all be zero or none should be zero.
//   The z-values can not be mirrored.
//
function MatrixAddMirror(matrix,v=[1,0,0]) =
  let(n=len(matrix))
  // Optionally mirror the x values.
  let(matrix2 = v.x != 0 ? _MatrixAddMirrorX(matrix)  : matrix)
  // Optionally mirror the y values.
  let(matrix3 = v.y != 0 ? _MatrixAddMirrorY(matrix2) : matrix2)
  matrix3;


// ==============================================================
//
// _MatrixAddMirrorY
// -----------------------
// A helper function for MatrixAddMirror().
// Create a mirror on the negative y-axis.
// When the y-value on the mirror line is zero, 
// then that row is not mirrored,
// because it is in the middle.
function _MatrixAddMirrorY(matrix) =
   let(n=len(matrix))
   let(m=len(matrix[0]))
   let(skip = (matrix[0][0].y == 0) ? 1 : 0)
   let(y_neg = 
     [ for(i=[0:n-1-skip])
       let(i2 = n-1-i)
        [ for(j=[0:m-1])
          [matrix[i2][j].x,-matrix[i2][j].y,matrix[i2][j].z]
        ]
     ])
   concat(y_neg,matrix); 


// ==============================================================
//
// _MatrixAddMirrorX
// -----------------------
// A helper function for MatrixAddMirror().
// Create a mirror on the negative x-axis.
// When the x-value on the mirror line is zero, 
// then that point not mirrored,
// because it is in the middle.
function _MatrixAddMirrorX(matrix) =
   let(n=len(matrix))
   [for(i=[0:n-1]) _MatrixAddMirrorXOneRow(matrix[i])];


// ==============================================================
//
// _MatrixAddMirrorXOneRow
// -----------------------
// A helper function for _MatrixAddMirrorX().
// Create a mirror on the negative x-axis for one row.
// When the first x-value is zero, then that one is not mirrored,
// because it is in the middle.
function _MatrixAddMirrorXOneRow(list) =
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
//       If the faces are inside-out, then the height can
//       be made negative.
//   center:
//       Set to true to expand the surface in both directions.
//   tube:
//       Set to true if the shape is a tube.
// Return:
//   The return value is an array with points and faces
//   (also called a VNF) to be used with a polyhedron.
// Note:
//   When the height is too high and the curves are too steep,
//   then the polyhedron might no longer be a valid shape.
//
function MatrixVolume(matrix,height,center=false,tube=false) =
  let(n = len(matrix))
  let(m = len(matrix[0]))
  let(t = n*m)
  // Use the input parameter 'matrix' as bottom, or
  // use half the height in both directions.
  let(bottom = center ? _MatrixOffsetPoints(matrix,-height/2) : matrix)
  let(top    = center ? _MatrixOffsetPoints(matrix,height/2)  : _MatrixOffsetPoints(matrix,height))
  let(m_max = tube ? m-1 : m-2)

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
  // The columns wrap around in tube mode.
  let(bottomfaces =
    [
      for(i=[0:n-2],j=[0:m_max])
        let(j_inc = (j+1) % m) 
        [(i*m)+j, (i*m)+j_inc, (i+1)*m+j_inc, (i+1)*m+j],
    ])

  // Calculate the top faces.
  // The columns wrap around in tube mode.
  let(topfaces =
    [
      for(i=[0:n -2],j=[0:m_max])
        let(j_inc = (j+1) % m) 
        [t+(i*m)+j, t+(i+1)*m+j, t+(i+1)*m+j_inc, t+(i*m)+j_inc],
    ])

  // Calculate the side faces.
  // A tube with volume is wrapped around and
  // has no right or left faces.
  let(sidefaces = 
    [
      // Front side faces.
      for(j=[0:m_max])
        let(j_inc = (j+1) % m)
        [j, j+t, t+j_inc, j_inc],

      // Right side faces.
      if(!tube)
      for(i=[0:n-2])
        [m-1+i*m,t+m-1+i*m,t+m-1+(i+1)*m,m-1+(i+1)*m],
    
      // Back side faces.
      for(j=[0:m_max])
        let(j_inc = (j+1) % m)
        [t-1-j,2*t-1-j,2*t-1-(j_inc),t-1-(j_inc)],
   
      // Left side faces.
      if(!tube)
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
        // The opposite point is ignored in most cases.
        // A point in the middle of the matrix uses 
        // the average of 4 triangles.
        // A point on the side uses two triangles.
        // A point in the corner could fail for round shapes.
        // So for a point in the corner uses the average
        // of the triangle on both sides towards the opposite point.
        //
        // This seems to work, but it would be better if
        // it could be detected when the normal vector
        // can not be calculated for an edge point.
        
        let(is_edge = (i==0 && j==0) || (i==0 && j==m-1) || (i==n-1 && j==0) || (i==n-1 && j==m-1)) 

        // The normal vector of the upper-left triangle.
        // It is empty when there is no upper-left triangle.
        let(NV1 = ((i+1)<n && (j-1)>=0) ?
          NormalVector(matrix[i][j],
                       matrix[i][j-1],
                       matrix[i+1][j],
                       matrix[i+1][j-1],is_edge) : [])

        // The normal vector of the upper-right triangle.
        // It is empty, when that triangle does not exist.
        let(NV2 = ((i+1)<n && (j+1)<m) ?
          NormalVector(matrix[i][j],
                       matrix[i+1][j],
                       matrix[i][j+1],
                       matrix[i+1][j+1],is_edge) : [])

        // The normal vector of the lower-right triangle.
        // Empty when it does not exist.
        let(NV3 = ((i-1)>=0 && (j+1)<m) ?
          NormalVector(matrix[i][j],
                       matrix[i][j+1],
                       matrix[i-1][j],
                       matrix[i-1][j+1],is_edge) : [])

        // The normal vector of the lower-left triangle.
        // Empty when it does not exist.
        let(NV4 = ((i-1)>=0 && (j-1)>=0) ?
          NormalVector(matrix[i][j],
                       matrix[i-1][j],
                       matrix[i][j-1],
                       matrix[i-1][j-1],is_edge) : [])

        // Combine them in a list. The empty ones will drop out.
        let(NV = concat(NV1,NV2,NV3,NV4))

        // Take the average of the normal vectors.
        // For practical use, the average of the
        // normal vectors is used. It might not be
        // mathematically correct.
        // The number of vectors can be 1, 2 or 4.
        let(q = len(NV))
        let(avg = 
          q == 1 ?  NV[0] :
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
// Since this function is used for a matrix with the points
// in rows and columns, it calculates the normal vector from 
// a square, although it is possible to use a triangle.
//
// Parameters:
//   A, B, C, D:
//     Points in 3D, together they make a square of two triangles.
//     Point A is the point of which the normal vector is calculated.
//     Point B and C are the nearby points.
//     Point D is optional and is the opposite point.
// Return:
//   The normal vector of nearest triangle of A,B,C is calculated.
//   If that is not possible, then the point further away,
//   point D will be used. In that case, the averate
//   of A,B,D and A,C,D is used.
//   The normal vector has the lenght of 1,
//   and it is the direction, not a coordinate.
function NormalVector(A,B,C,D,edge=false) =
  is_undef(D) ? NormalVector3Point(A,B,C,edge) : NormalVector4Point(A,B,C,D,edge);


// ==============================================================
//
// NormalVector4Point
// ------------------
// A helper function for NormalVector().
//
// Find the normal vector of a surface with 4 points.
// A triangle with point A,B,C is used.
// In case that normal vector would be unreliable,
// then the average of two normal vectors are used:
// A,B,D and A,C,D.
function NormalVector4Point(A,B,C,D,edge=false) =
  let(N1 = -cross(A-B,A-C))
  let(N2 = -cross(A-D,A-B))
  let(N3 = -cross(A-D,A-C))
  // let(N4 = -cross(D-B,D-C))
  let(L1 = norm(N1))
  let(L2 = norm(N2))
  let(L3 = norm(N3))
  // let(L4 = norm(N4))
  // Determining if the normal vector over A,B,C is not
  // reliable is hard to do.
  // So if it is one of the four edge points,
  // then get the opposite point involved.
  // Old code (even worse than the current code):
  //   let(error = norm(A-(B+C)/2))
  //   error < 0.7 ? -[(N2/L2 - N3/L3)/2] : [N1/L1];
  edge ? -[(N2/L2 - N3/L3)/2] : [N1/L1];

// ==============================================================
//
// NormalVector3Point
// ------------------
// A helper function for NormalVector().
// When the point is on the edge, then the normal vector
// could fail. However, with only three points, it is
// not possible to calculate a corrected value.
function NormalVector3Point(A,B,C,edge=false) =
  let(N1 = -cross(A-B,A-C))
  let(L1 = norm(N1))
  [N1/L1];


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
//
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


// ==============================================================
//
// MatrixAddNoise
// --------------
// Parameters:
//   matrix:
//     A matrix of 3D points as rows and columns.
//   amplitude:
//     The total amplitude of the noise.
//   v:
//     The vector to select which value is changed.
//     Use either 0 or 1, default [1,1,1] for x,y,z.
//   edge:
//     Apply the noise to the 4 edge points or not.
//     The edge points can deform the shape in an unwanted way.
//     It is therefor safer to set it to false.
function MatrixAddNoise(matrix,amplitude,v=[1,1,1],edge=true) =
  let(n = len(matrix))
  let(m = len(matrix[0]))
  [ for(i=[0:n-1])
    [ for(j=[0:m-1])
        let(rnd = rands(-amplitude/2,amplitude/2,3))
        let(is_edge = (i==0 && j==0) || (i==0 && j==m-1) || (i==n-1 && j==0) || (i==n-1 && j==m-1))
        [ matrix[i][j].x + ((is_edge && !edge) ? 0 : v.x*rnd.x),
          matrix[i][j].y + ((is_edge && !edge) ? 0 : v.y*rnd.y),
          matrix[i][j].z + ((is_edge && !edge) ? 0 : v.z*rnd.z) ]
    ]
  ];
  
  
  
// ==============================================================
//
// MatrixForce
// -----------
// A matrix of rows and columns is changed 
// by a force field.
// The force field is around a single point
// at this moment (not a list of points).
// Parameters:
//   matrix:
//     An array of 3D points in rows and columns.
//   point: 
//     A 3D coordinate which is
//     the center of the force field.
//   radius:
//     The size of the force field.
//   strength:
//     The strength of the force field.
//     A positive value is an attraction force.
//     A negative value is a repellant force.
//
// Return:
//   A changed matrix of rows and columns.
//
function MatrixForce(matrix,point=[0,0,0],radius=1,strength=1) =
  let(new_matrix= 
    [  
      for(row=matrix)
      [
        for(element=row)
          // The shape has soft edges and is soft near the middle.
          let(dist = norm(point - element))
          let(rel0 = dist < radius ? strength * sin((radius-dist)/radius*90) : 0)
          let(rel = rel0 * rel0)
          strength >= 0 ? 
            element - rel*(element-point) : 
            element + rel*(element-point),
      ]
    ])
  new_matrix;


// ==============================================================
//
// MatrixRotateExtrude
// -------------------
// A 2D profile is used for a circular matrix.
// The coordinates will be in rows and column.
//
// Parameters:
//   profile:
//     A list of 2D points for the profile.
//     The x-value is the distance to the center.
//     The y-value is the height.
// Return
//   A matrix with rows and columns.
//   The coordinates are in a circle. 
function MatrixRotateExtrude(profile) =
  let(n_input = len(profile))
  // Assuming that the first point in
  // the profile is at [0,y], then the matrix
  // will have n + n-1 rows and columns.
  let(n = n_input + n_input-1)

  // create the matrix with rows and columns.
  let(matrix= 
    [  
      for(i=[0:n-1])
      [
        for(j=[0:n-1])
          let(center = floor(n/2))
          let(di = i-center)
          let(dj = j-center)
          // The ring index is how much away the
          // index is from the center.
          // After changing the matrix into a circle,
          // it is the ring, starting from the middle.
          let(ring_index = max(abs(di),abs(dj)))

          // The angle is not evenly spread around.
          // Because the original angle of 
          // the square matrix is used for this new
          // circular matrix.
          let(angle = atan2(di,dj))
          let(l=profile[ring_index].x)
          let(z=profile[ring_index].y)
          [l*cos(angle),l*sin(angle),z],
      ]
    ])
  matrix;
  

// ==============================================================
//
// MatrixSquare
// ------------
// Return a matrix of 3D points as a flat square.
// The square can be divided into sections.
//
// Parameters:
//   size:
//     A number for the same size in x and y direction,
//     or the size as [x,y].
//   sections:
//     Either a number for the same amount of sections
//     in x and y direction or as [sections_x,sections_y].
//     1 = No divisions, just a rectangle.
//   center:
//     Center around [0,0] or in the positive quadrant.
// Return:
//   A matrix of 3D points in rows and columns.
//   The z-value is zero for every point.
//
function MatrixSquare(size,sections=1,center=false) =
  assert(is_num(size) || is_num(size[0]), 
    "The function MatrixSquare needs a size.")
  [
    let(dn = is_undef(sections.y) ? sections : sections.y)
    let(dm = is_undef(sections.x) ? sections : sections.x)
    let(n  = dn + 1)
    let(m  = dm + 1)
    let(size_x = is_undef(size.x) ? size : size.x)
    let(size_y = is_undef(size.y) ? size : size.y)
    let(offset_x = center ? -size_x/2 : 0)
    let(offset_y = center ? -size_y/2 : 0)
    for(i=[0:n-1])
    [ 
      for(j=[0:m-1])
        // The order is in such a way,
        // that a valid polyhedron can be created.
        [ offset_x + j/(m-1)*size_x,
          offset_y + i/(n-1)*size_y, 0],
    ]
  ];
  

// ==============================================================
//
// MatrixDisc
// ----------
// Create an empty disc of points.
// The points are in a matrix with rows and columns.
//
// Parameters:
//    radius:
//      The radius of the circle.
//    rings:
//      The number of rings around the center.
//
// Return:
//   A matrix of 3D points in rows and columns,
//   representing a disc.
//
// I assume that the conversion from an array of a square
// to an array with circular points is standard math.
function MatrixDisc(radius=1,rings=3) =
  [
    let(matrix = MatrixSquare(2*radius,sections=rings*2,center=true))
    for(row=matrix)
    [
      for(element=row)
        // Using standard math from square to circle.
        // When sqrt(x²+y²) is zero, then 'm' could be 1.
        // Each quadrant is split into two sections.
        // The points are not equally spaced along
        // the perimeter of a circle, but it is good enough.
        let(qx = element.x * element.x)
        let(qy = element.y * element.y)
        let(q = sqrt(qx+qy))
        let(mul = (q == 0) ? 1 : qx > qy ? abs(element.x)/q : abs(element.y)/q)
        [mul*element.x, mul*element.y, 0],
    ]
  ];
  

// ==============================================================
//
// MatrixDiscSetRing
// -----------------
// Select a ring from a MatrixDisc and set it to
// a certain radius (optional) and height (optional).
//
// Parameters:
//   matrix:
//     A matrix with points in 3D as rows and columns.
//     It is assumed to be a MatrixDisc with the 
//     center at [0,0].
//   ring:
//     The ring of the disc, the center is ring 0.
//   radius:
//     The new radius for the selected ring, optional.
//     It is ignored when the ring is 0 (the center point).
//   height:
//     The new height for the selected ring, optional.
//
function MatrixDiscSetRing(matrix,ring,radius,height) =
  let(n = len(matrix))
  let(m = len(matrix[0]))
  let(icenter = (n-1)/2)
  let(jcenter = (m-1)/2)
  let(newmatrix =
    [
      for(i=[0:n-1])
      [
        for(j=[0:m-1])
        let(x = matrix[i][j].x)
        let(y = matrix[i][j].y)
        let(center = (i==icenter && j==jcenter))
        let(valid = (ring==0 && center) ? true : _isRingPoint([i,j],matrix,ring))
        let(angle = atan2(y,x))
        // Correct radius, in case the center is used.
        let(r = (center) ? 0 : radius)
        [  
          (valid && !is_undef(radius)) ? r*cos(angle) : matrix[i][j].x,
          (valid && !is_undef(radius)) ? r*sin(angle) : matrix[i][j].y,
          (valid && !is_undef(height)) ? height : matrix[i][j].z
        ]
      ]
    ]) 
  newmatrix;



// ==============================================================
//
// _isRingPoint
// ------------
// Helper function for MatrixDiscSet().
// Check if the current indexes (the row and column)
// are part of the selected ring.
//
function _isRingPoint(point,matrix,ring) =
  let(n = len(matrix))
  let(m = len(matrix[0]))
  let(icenter = (n-1)/2)
  let(jcenter = (m-1)/2)
  let(pps = 2*ring)  // points per segement
  // The center is just set as center,
  // the points around the center are calculated.
  let(ringpoints = 
    [ for(i=[0:pps-1])
        [icenter-ring,icenter-ring+i],
      for(i=[0:pps-1])
        [icenter-ring+i,icenter+ring],
      for(i=[0:pps-1])
        [icenter+ring,icenter+ring-i],
      for(i=[0:pps-1])
        [icenter+ring-i,icenter-ring] ])
  _isInList(point,ringpoints);



// ==============================================================
//
// _isInList
// ---------
// Helper function for MatrixDiscSet().
// Search if the point is in the list.
//
function _isInList(point,list,_index=0) =
  _index < len(list) ? 
    point == list[_index] ? true : _isInList(point,list,_index+1) : 0;



