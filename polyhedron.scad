// polyhedron.scad
//
// Part of the StoneAgeLib
//
// Version 1
// October 25, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
// Initial version, designed from scratch, not fully tested.
//
// This version number is the overall version for everything in this file.
// Some modules and functions in this file may have their own version.
//
// Note: The term "VNF" is borrowed from the BOSL2 library.
//       It stands for "Vertices aNd Faces" and is an array
//       with points and faces for the polyhedron() function.


// ==============================================================
//
// MatrixTubeToPolyhedron
// ----------------------
// A tube defined as a matrix (with rows and columns) 
// is turned into points and faces for a polyhedron.
// The bottom and top will be closed.
// A matrix tube is a special tube, where the rows
// go around to create a smooth tube shape.
// The matrix can be a subdivided matrix.
//
// Parameters:
//   matrix: 
//     3D coordinates as rows and columns,
//     representing a tube.
//     The rows are in the lenght of the tube.
//     The column goes around.
// Return:
//   The return is an array with points and faces 
//   as a VNF to be used with a polyhedron.
//
function MatrixTubeToPolyhedron(matrix) =
  let(vnf_first_layer = PolyhedronStart(matrix[0]))
  let(vnf = LayersToPolyhedron(vnf_first_layer,matrix))
  // Return the points and faces in a single array.
  vnf;


// ==============================================================
//
// LayersToPolyhedron
// ------------------
// A function that builds a polyhedron from
// an array with points.
function LayersToPolyhedron(vnf,layers,_index=1) =
  let(new_vnf = PolyhedronAdd(vnf,layers[_index]))
  _index < len(layers) - 1 ?
  LayersToPolyhedron(new_vnf,layers,_index+1) : new_vnf;


// ==============================================================
//
// PolygonVolume
// -------------
// This function turns a list of 2D coordinates
// (for a polygon) into points and faces
// for a polyhedron.
//
// The last face is the top face, so it can be used
// with the PolyhedronAdd() function.
//
// Parameters:
//   points
//     A list of 2D coordinates.
//     The coordinates should be in anti-clockwise order.
//   height
//     The height of the polyhedron.
//     If the height is not specified, then a flat shape
//     with no height should be returned.
//     A flat shape is not valid, but it can be used with
//     the function PolyhedronAdd().
// Return:
//   An array with points and faces.
//
function PolygonVolume(points,height) =
  let(n=len(points))
  // Bottom 3D points on the xy-plane.
  let(points3D_A = [for(i=[0:n-1]) [points[i].x,points[i].y,0]])
  // Top 3D points.
  let(points3D_B = is_undef(height) ? [] : [for(i=[0:n-1]) [points[i].x,points[i].y,height]])
  let(totalpoints = concat(points3D_A,points3D_B))
  // The bottom face will be okay, 
  // if the coordinates are in anti-clockwise order.
  let(face_bottom = [[for(i=[0:n-1]) i]])
  let(m = is_undef(height) ? n : 2*n)
  let(face_top    = [[for(i=[0:n-1]) m-1-i]])
  let(faces_sides = is_undef(height) ? [] :
    [
      for(i=[0:n-1])
        let(inc = (i+1) % n) 
        [i,n+i,n+inc,inc] 
    ])
   // Concatenate all the faces together.
   let(totalfaces = concat(face_bottom,faces_sides,face_top))
   // Return a VNF (points and faces).
   [totalpoints,totalfaces];


// ==============================================================
//
// PolyhedronStart
// ---------------
// This function takes a list of 3D points,
// and converts it into a flat shape without height.
// There are no side faces.
// The points are just the single layer points.
//
// Note:
//   This is not a valid polyhedron in OpenSCAD.
//   It is used to build upon by adding layers
//   with the PolyhedronAdd function.
function PolyhedronStart(points) =
  let(n=len(points))
  let(bottomface = [[ for(i=[0:n-1]) i]])
  let(topface    = [[ for(i=[0:n-1]) n-1-i]])
  let(faces=concat(bottomface,topface))
  [points,faces];


// ==============================================================
//
// PolyhedronAdd
// -------------
// Take the VNF of a polyhedron,
// and add a new layer on top.
// This is meant for a solid vase structure,
// and the new layer should have coordinates
// in 3D with the same amount of coordinates
// as the previous layer.
//
// Parameters:
//   VNF:    The data with points and faces
//           for a polyhedron.
//   points: A list of 3D points that
//           extends the polyhedron.
//           The coordinates of the new layer
//           should be in anti-clockwise order.
//
// Returns:  An array with points and faces
//           for a polyhedron.
//    
// To do:
//   Allow to select any face, and grow the shape
//   from there. At this moment, the last face is used.
//   Allow points in 2D at a certain height.
//
function PolyhedronAdd(VNF,points) =
  let(n_points = len(VNF[0]))
  let(n_faces = len(VNF[1]))
  let(n_layer = len(points))
  // Remove the last face,
  // assuming it is the top face.
  let(faces_open = [for(i=[0:n_faces-2]) VNF[1][i] ])
  // Add the new points.
  let(totalpoints = concat(VNF[0],points))
  let(newface = [[for(i=[0:n_layer-1]) n_points+n_layer-1-i]])
  let(newsidefaces = 
    [
      for(i=[0:n_layer-1])
        let(inc = (i+1) % n_layer)
        [n_points-n_layer+i,n_points+i,n_points+inc,n_points-n_layer+inc]
    ])
  let(totalfaces = concat(faces_open,newsidefaces,newface))
  [totalpoints,totalfaces];


// ==============================================================
//
// Lift2D
// ------
// Use a list of 2D points (for a polygon),
// and turn them into 3D points at a certain height.
// It is used to convert 2D slices into a vase.
function Lift2D (points,height=1) =
  [for(i=[0:len(points)-1]) [points[i].x,points[i].y,height]];


// ==============================================================
//
// VerticesCount
// -------------
// This function returns the number of vertices
// for a certain face of the VNF.
function VerticesCount(VNF,face) = len(VNF[1][face]);


