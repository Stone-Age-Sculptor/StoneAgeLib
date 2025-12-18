// list.scad
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
// March 12, 2025
// Changes:
//   MirrorList() added.
//
// Version 3
// June 4, 2025
// Changes:
//   vector_add_2D() is renamed to vector_add() and is now
//   for 2D and 3D.
//
// Version 4
// November 30, 2025
// Changes:
//   TranslateList() updated, it is now for 2D and 3D and
//   for a matrix (coordinates in rows and columns).
//
// This version number is the overall version for everything in this file.
// Some modules and functions in this file may have their own version.


// ==============================================================
//
// vector_add
// ----------
// Incremental add each item. Every item will be
// the sum of all the previous items.
// Used to concatenate vectors into a single path.
// Parameters:
//   v: the list with coordinates
// Return:
//   A list where every item is the
//   addition of all previous items.
// This function is for 2D and 3D.
// The trick to start at zero for both 2D and 3D
// is to subtract the first item by itself.
function vector_add(v,index=0,sum) =
  let(sum = is_undef(sum) ? v[0] - v[0] : sum)
  let(new_sum = sum + v[index]) 
  index < len(v) -1 ? 
    [new_sum, each vector_add(v,index+1,new_sum)] :
    [new_sum];
    

// ==============================================================
//
// ShuffleList
// -----------
// Shuffle the items of any list.
// Method:
//   A random item is selected.
//   It is removed from the input list and added
//   to the output list.
//   The item is removed by combining what is on 
//   the left and on the right of that item. 
//   This is done recursively until the input list is empty.
function ShuffleList(list) =
  let(n = len(list))
  n > 0 ?
    let(index = floor(rands(0,n-0.001,1)[0]))
    let(left = index > 0 ? [for(i=[0:index-1]) list[i]] : [])
    let(right = index < n-1 ? [for(i=[index+1:n-1]) list[i]] : [])
    concat(list[index],ShuffleList(concat(left,right))) : [];
    
    
// ==============================================================
//
// ReverseList()
// -------------
// Reverse the order of any list.
function ReverseList(list) = [for(i=[0:len(list)-1]) list[len(list)-1-i]];


// ==============================================================
//
// MirrorList()
// ------------
// Mirror the coordinates according to the vector.
// Example:  MirrorList([1,0,0],myList);
// The list can be a list of 2D or 3D coordinates.
// When the list has 2D coordinates and the
// vector is 3D, then only the 2D part of the vector
// is used.
function MirrorList(v,list) =
  let(sx = v.x != 0 ? -1 : 1)
  let(sy = v.y != 0 ? -1 : 1)
  is_num(list[0].z) ?
    let(sz = v.z != 0 ? -1 : 1)
    [for(item=list) [sx*item.x,sy*item.y,sz*item.z]] :
    [for(item=list) [sx*item.x,sy*item.y]];


// ==============================================================
//
// RandomNonOverlap
// ----------------
// Randomly Distribute Shapes Over An Area Without Overlap.
// Goal: To make a birthday card or Christmas card 
//       with many small shapes, randomly distributed,
//       without overlapping other shapes.
//       The shapes can be, for example, stars or 
//       hearts or balloons.
// A random coordinate is added to the list if it was
// not too close to the other coordinates.
// Parameters:
//   n:    The number of coordinates.
//         The result might have less coordinates,
//         because the coordinates that are too close
//         will not be used.
//         For example 10 or 100.
//   area: The size as [xsize,ysize] for the area.
//         The lower-left corner is at [0,0].
//   dist: The minimal distance between the coordinates.
//   list: Used internally to build the result.
function RandomNonOverlap(n,area,dist,list=[]) =
  let(x = rands(dist/2,area.x-dist/2,1)[0])
  let(y = rands(dist/2,area.y-dist/2,1)[0])
  let(d = ShortestDistance([x,y],list)) 
  n > 0 ?
    d > dist ?
      RandomNonOverlap(n-1,area,dist,concat(list,[[x,y]])) : 
      RandomNonOverlap(n-1,area,dist,list) : 
    list;


// ==============================================================
//
// ShortestDistance
// ----------------
// Calculate the shortest distance from
// a point to other points in a list.
// The OpenSCAD function "norm()" calculates
// the distance between two points.
// The OpenSCAD function "min()" returns
// the lowest number in a list.
// Parameters:
//   point: The [x,y] coordinates to test.
//   list : A list of coordinates [[x1,y1],[x2,y2],...
function ShortestDistance(point,list) =
  let(distances = len(list) > 0 ?
    [for(i=[0:len(list)-1]) 
      norm(list[i] - point)] : [])
  len(distances) > 0 ? min(distances) : 10000;


// ==============================================================
// 
// RotateList
// ----------
// Rotate a list (a 2D shape) around (0,0)
// To do: Make it compatible with a list of 3D coordinates
//        and a matrix of 3D rows and columns.
function RotateList(list,angle) = 
  [for(c=list) 
   let(l=norm(c))
   let(a=atan2(c.y,c.x))
   [l*cos(a+angle),l*sin(a+angle)]];


// ==============================================================
//
// TranslateList
// -------------
// Move a list with coordinates to a location.
// Parameters:
//   list:
//     A list of 2D points, or a list of 3D points,
//     or a matrix of 3D points.
//   point:
//     The changes for the new coordinates.
// Return:
//   2D list + value       : 3D list at height of value
//   3D list + value       : 3D list, lifted in z-direction
//   2D list + 2D point    : 2D list
//   2D list + 3D point    : 3D list
//   3D list + 2D point    : 3D list
//   3D list + 3D point    : 3D list
//   3D matrix + 3D point  : 3D matrix
function TranslateList(list,point) =
  let(is_matrix = is_num(list[0][0].x))
  let(is_2D = is_undef(list[0].z) && is_undef(point.z) && !is_num(point))
  let(is_none = is_undef(point))
  // Translate a value or a 2D point into a 3D point.
  let(p1 = is_num(point) ? [0,0,point] : point)
  let(p2 = is_undef(p1.z) ? [p1.x,p1.y,0] : p1)
  let(new_list =
    is_none ?
      list :
    is_2D ?
      [ for(c=list) 
        [ p2.x+c.x,p2.y+c.y ]] :
    is_matrix ?
      let(n = len(list))
      let(m = len(list[0]))
      [ 
        for(i=[0:n-1])
        [
          for(j=[0:m-1])
            [ list[i][j].x + p2.x,
              list[i][j].y + p2.y,
              list[i][j].z + p2.z ]
        ]
      ] :
    // The input is not a matrix, and the result is in 3D.
    // The input could still be a list of 2D points.      
      let(n = len(list))
      [
        for(i=[0:n-1])
          let(z = is_undef(list[i].z) ? 0 : list[i].z)
            [ list[i].x + p2.x,
              list[i].y + p2.y,
              z + p2.z ]
      ])
  new_list;

