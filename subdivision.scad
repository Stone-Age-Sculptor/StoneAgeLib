// subdivision.scad
//
// Part of the StoneAgeLib
//
// Version 1
// February 3, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
// This version number is the overall version for everything in this file.
// Some modules and functions in this file may have their own version.
//
// Version 2
// February 27, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
// Changes:
//   The filename of this file is changed from interpolate.scad to subdivision.scad
//
// Version 3
// October 14, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
// Changes:
//   The function MethodSplitName() added.
//
// This version number is the overall version for everything in this file.
// Some modules and functions in this file may have their own version.


// ==============================================================
//
// Round2D
// -------
// Make round outer and inner edges 
// on a 2D shape with sharp edges.
//
// Note: Small parts might disappear.
module Round2D(radius=0)
{
  offset(-radius)
    offset(2*radius)
      offset(delta=-radius)
        children();
}



// ==============================================================
//
// MethodSplitName
// ---------------
// The method for subdivision can have "path" at the end
// of the name. This function returns both variants.
//
// Parameters:
//   name: 
//     The subdivision method as text.
// Return:
//   This function returns two strings, the first one
//   without the path, the second one with the path,
//   regardless if the input was with "path" at the end or not.
//
function MethodSplitName(name) =
  let(n = len(name))
  // let(withpath = (n >= 4 && name[n-4] == "p" && name[n-3] == "a" && name[n-2] == "t" && name[n-1] == "h") ? true : false)
  let(withpath = (n >= 4 && name[n-4] == "p" && name[n-3] == "a" && name[n-2] == "t" && name[n-1] == "h"))
  let(method_s = withpath ? substr(name,0,n-4) : name)
  let(method_p = withpath ? name : str(name,"path"))
  [method_s,method_p];


// ==============================================================
//
// ------------------------------------------------
// Subdivision functions
// ------------------------------------------------
// Version 1
// November 13, 2024
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//
// Version 2
// February 2, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//   A list can now also be 1 or 2 elements long.
//   That will return those 1 or 2 elements
//   without subdivision.
//   Changed how the functions are called
//   recursively.
//

// Subdivision
// -----------
// Parameters:
//   list:      A list of coordinates in 2D or 3D. 
//              But not a 3D surface.
//              A list of one of two points is 
//              not subdivided and is returned
//              in the same way.
//   divisions: The number of divisions.
//              0 for no smoothing, 5 is extra smooth.
//   method:    The subdivision method:
//              "1"        A basic 1,1 weighted subdivision
//                         for a closed shape.
//              "1path"    A basic 1,1 weighted subdivision
//                         for a path.
//              "weighted" A weighted average subdivision
//                         for a closed shape.
//              "weightedpath"
//                         A weighted average subdivision
//                         for a path.
// Return:
//   A new list with a smoother shape.

function Subdivision(list,divisions=2,method="1") =
  method=="1"            ? _Subdivision11(list,divisions) :
  method=="1path"        ? _Subdivision11Path(list,divisions) :
  method=="weighted"     ? _SubdivisionWeighted(list,divisions) : 
  method=="weightedpath" ? _SubdivisionWeightedPath(list,divisions) : 
  assert(false,"Unknown method in Subdivision",divisions);

// This is the most basic subdivision with 1,1 weighting.
// It will work in 2D and 3D.
//
// The average in OpenSCAD is: (current_point + next_point) / 2
// The index of the list wraps around for the next point.
//
// The 'list2' is the average points between the original points.
// The returned list is the new average between the average points
// and the original points.
function _Subdivision11(list,divisions) =
  divisions > 0 && len(list) > 2 ?
    let (n = len(list)-1)
    let (list2 = [ for(i=[0:n]) (list[i] + list[(i+1) > n ? 0 : i+1])/2 ])
    _Subdivision11([ for(i=[0:n]) each [ (list[i] + list2[i])/2, (list2[i] + list[(i+1) > n ? 0 : i+1])/2 ]], divisions-1) : list;

// The basic subdivision with 1,1 weighting.
// But now for a path with a open begin and end.
function _Subdivision11Path(list,divisions) =
  divisions > 0 && len(list) > 2 ?
    let (n = len(list)-2)
    let (list2 = [ for(i=[0:n]) (list[i] + list[i+1])/2 ])
    _Subdivision11Path([ list[0], for(i=[1:n]) each [ (list[i] + list2[i-1])/2, (list[i] + list2[i])/2 ], list[n+1]], divisions-1) : list;


// My own attempt with variable weighting.
// The goal was a smoothing algoritme that feels
// like NURBS.
// Explanation:
//   The average points between the original
//   points are calculated. These are kept.
//   A second set of average points between 
//   those average points are temporarely calculated.
//   A new point is created on the line between
//   an original point and the temporarely point.
//   The position on that line is defined by
//   a 'weight' variable.
//   The result is the combination of the
//   kept points and the new points.
//
// When the 'weight' variable is set to
// sqrt(2) - 1, then the result approximates 
// a circle when the control points is a square.
// It is some kind of cubic B-spline, but I don't 
// know if it matches with one of the known algoritmes.
function _SubdivisionWeighted(list,divisions) =
  divisions > 0 && len(list) > 2 ?
    let (weight = sqrt(2) - 1)
    let (n = len(list)-1)
    let (list2 = [ for(i=[0:n]) (list[i] + list[(i+1) > n ? 0 : i+1])/2 ])
    let (list3 = [ for(i=[0:n]) (weight*list[i] + (1-weight)/2*(list2[i] + list2[(i-1) < 0 ? n : i-1])) ])
  _SubdivisionWeighted([ for(i=[0:n]) each [list3[i], list2[i]] ], divisions-1) : list;

// My own attempt with variable weighting.
// But now for a path with a open begin and end.
function _SubdivisionWeightedPath(list,divisions) =
  divisions > 0 && len(list) > 2 ?
    let (weight = sqrt(2) - 1)
    let (n = len(list)-2)
    let (list2 = [ for(i=[0:n]) (list[i] + list[i+1])/2 ])
    let (list3 = [ list[0], for(i=[1:n]) (weight*list[i] + (1-weight)/2*(list2[i] + list2[i-1])), list[n+1] ])
  _SubdivisionWeightedPath([ for(i=[0:n]) each [list3[i], list2[i]], list3[n+1] ],divisions-1) : list;
