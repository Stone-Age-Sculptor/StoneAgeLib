// list.scad
//
// Part of the StoneAgeLib
//
// Version 1
// February 3, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
// This version number is the overall version for everything in this file.
// Some modules and functions in this file may have their own version.


// vector_add_2D
// -------------
// Incremental add each item. Every item will be
// the sum of all the previous items.
// Used to concatenate vectors into a single path.
// Parameters:
//   v: the list with coordinates
// Return:
//   A list where every item is the
//   addition of all previous items.
// This is only for 2D vectors, because the sum is started a [0,0]
function vector_add_2D(v,index=0,sum=[0,0]) =
  let(new_sum = sum + v[index]) 
  index < len(v) -1 ? 
    [new_sum, each vector_add_2D(v,index+1,new_sum)] :
    [new_sum];
    

// ShuffleList
// -----------
// Shuffle the items of any list.
// Method:
//   A random item is selected. That is removed from
//   the input list.
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
    
    
// ReverseList()
// -------------
// Reverse the order of any list.
function ReverseList(list) = [for(i=[0:len(list)-1]) list[len(list)-1-i]];


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


// Rotate a list (a 2D shape) around (0,0)
function RotateList(list,angle) = 
  [for(c=list) 
   let(l=norm(c))
   let(a=atan2(c.y,c.x))
   [l*cos(a+angle),l*sin(a+angle)]];


// Move a list (a 2D shape) to a location.
function TranslateList(list,point) =
  [for(c=list) 
   [point.x+c.x,point.y+c.y]];

