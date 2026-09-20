// subdivision.scad
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
// February 27, 2025
// Changes:
//   The filename of this file is changed from interpolate.scad to subdivision.scad
//
// Version 3
// October 14, 2025
// Changes:
//   The function MethodSplitName() added.
//
// Version 4
// December 12, 2025
// Changes:
//   Bug fixed for the assert() message when an unknown method was
//   used in Subdivision().
//   The method for subdivision called "weighted" is now called "cubic".
//
// Version 4
// December 12, 2025
// Changes:
//   Bug fixed for the assert() message when an unknown method was
//   used in Subdivision().
//   The method for subdivision called "weighted" is now called "cubic".
//
// Version 5
// January 2, 2026
// Changes:
//   New subdivision method "fit", where the control points
//   fit on the smooth curve. Only for 2D at the moment.
//   The subdivision() function had its own version number
//   That is removed, and it is now part of the version of this file.
//   The versions were:
//     Subdivision Version 1, November 13, 2024
//     Subdivision Version 2, February 2, 2025
//         A list can now also be 1 or 2 elements long.
//         That will return those 1 or 2 elements
//         without subdivision.
//         Changed how the functions are called
//         recursively.
//



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
//              "1"         A basic 1,1 weighted subdivision
//                          for a closed shape.
//              "1path"     A basic 1,1 weighted subdivision
//                          for a path.
//              "cubic"     A weighted average subdivision
//                          for a closed shape.
//              "cubicpath" A weighted average subdivision
//                          for a path.
//              "fit"       The curve will always go trough 
//                          the control points of the closed shape.
//              "fitpath"   The curve will always go trough 
//                          the control points of a path.
// Return:
//   A new list with a smoother shape.

function Subdivision(list,divisions=2,method="1") =
  method=="1"            ? _Subdivision11(list,divisions) :
  method=="1path"        ? _Subdivision11Path(list,divisions) :
  method=="cubic"        ? _SubdivisionCubic(list,divisions) : 
  method=="cubicpath"    ? _SubdivisionCubicPath(list,divisions) : 
  // The names "weighted" and "weightedpath" are depreciated,
  // they are now called "cubic" and "cubicpath".
  method=="weighted"     ? echo("🟠 The method weighted is now called cubic.") 
                           _SubdivisionCubic(list,divisions) : 
  method=="weightedpath" ? echo("🟠 The method weightedpath is now called cubicpath.")
                           _SubdivisionCubicPath(list,divisions) : 
  method=="fit"          ? _SubdivisionFit(list,divisions) : 
  method=="fitpath"      ? _SubdivisionFitPath(list,divisions) : 
  assert(false, str("Unknown method \"", method, "\" in Subdivision"));
  

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


// My own attempt with variable cubic weighting.
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
function _SubdivisionCubic(list,divisions) =
  divisions > 0 && len(list) > 2 ?
    let (weight = sqrt(2) - 1)
    let (n = len(list)-1)
    let (list2 = [ for(i=[0:n]) (list[i] + list[(i+1) > n ? 0 : i+1])/2 ])
    let (list3 = [ for(i=[0:n]) (weight*list[i] + (1-weight)/2*(list2[i] + list2[(i-1) < 0 ? n : i-1])) ])
  _SubdivisionCubic([ for(i=[0:n]) each [list3[i], list2[i]] ], divisions-1) : list;

// My own attempt with variable cubic weighting.
// But now for a path with a open begin and end.
function _SubdivisionCubicPath(list,divisions) =
  divisions > 0 && len(list) > 2 ?
    let (weight = sqrt(2) - 1)
    let (n = len(list)-2)
    let (list2 = [ for(i=[0:n]) (list[i] + list[i+1])/2 ])
    let (list3 = [ list[0], for(i=[1:n]) (weight*list[i] + (1-weight)/2*(list2[i] + list2[i-1])), list[n+1] ])
  _SubdivisionCubicPath([ for(i=[0:n]) each [list3[i], list2[i]], list3[n+1] ],divisions-1) : list;


// Container function for the "fit" method.
// The function to calculate the extra points
// is called recursively.
function _SubdivisionFit(list,divisions) =
  divisions > 0 ?
    _SubdivisionFit(_CalcFit(list),divisions-1) :
    list;

// Container function for the "fitpath" method.
// The function to calculate the extra points
// is called recursively.
function _SubdivisionFitPath(list,divisions) =
  divisions > 0 ?
    _SubdivisionFitPath(_CalcFitPath(list),divisions-1) :
    list;
    

// _CalcFit
// --------
// A function that calculates extra point between
// the control points.
// A smoother curve that goes through the control points
// is the result.
// After drawing it on a piece of paper, I thought it could work.
// Somehow I managed to make it work. The result is indeed a smooth curve.
// However, the curve can sweep in a unwanted direction,
// this method is therefor not a stable method.
//
// To do: Make it for 3D as well.
function _CalcFit(list) =
  // Number of elements in the list
  let(n = len(list))

  // Angle of the straight lines between 
  // the original points.
  let(a = [for(i=[0:n-1])
    let(inc = (i < n-1) ? i+1 : 0)
    atan2(list[inc].y-list[i].y, list[inc].x-list[i].x) ])

  // Average angle for each point.
  // It is the average of the straight line
  // before and after the point.
  let(v = 
    [ 
      for(i=[0:n-1])
        let(dec = i>0   ? i-1 : n-1)
        (a[dec]+a[i])/2,
    ])

  // Points in the middle of the original points.
  // They are in the middle of the straight lines.
  let(m = 
    [ 
      for(i=[0:n-1])
        let(inc = i<n-1 ? i+1 : 0) 
        (list[i]+list[inc])/2, 
    ])

  // Normal vectors for the straight lines
  // between the original points.
  let(nv = 
    [
      for(i=[0:n-1])
      let(inc = i<n-1 ? i+1 : 0) 
        90+atan2(list[inc].y-list[i].y,list[inc].x-list[i].x), 
    ])

  // Intersection points between the normal vector
  // starting at the middle points with the
  // lines of the average angle.
  let(ca = 
    [
      for(i=[0:n-1])
        let(inc = i<n-1 ? i+1 : 0)
        let(dec = i>0   ? i-1 : n-1) 
        Average(LineIntersection(m[i],nv[i], list[i],v[i]), LineIntersection(m[i],nv[i], list[inc],v[inc])),
    ])

  // Then use that to take the average with the middle points.
  let(ca2 = 
    [
      for(i=[0:n-1]) 
        Average(ca[i], m[i]),
    ])

  // Weave the new points between the original points.
  let(new =
    [
      for(i=[0:n-1]) each [list[i], ca2[i]],
    ])

  // Somehow I got a smooth curve out of this.
  new;


// _CalcFitPath
// ------------
// Same as _CalcFit, but then as a path with
// a start point and a end point.
function _CalcFitPath(list) =
  // Elements in the list
  let(n = len(list))

  // Angle of the straight lines between 
  // the original points.
  let(a = [for(i=[0:n-2]) atan2(list[i+1].y-list[i].y, list[i+1].x-list[i].x) ])

  // Average angle for each point.
  // It is the average of the straight line
  // before and after the point.
  // The begin and end point also get an angle,
  // but not the average, just the angle between
  // two points.
  let(v = 
    [ 
      a[0],
      for(i=[0:n-3]) (a[i]+a[i+1])/2,
      a[n-2] 
    ])

  // Points in the middle of the original points.
  let(m = [for(i=[0:n-2]) (list[i]+list[i+1])/2, ])

  // Normal vectors for the straight lines
  // between the original points.
  let(nv = [for(i=[0:n-2]) 90+atan2(list[i+1].y-list[i].y,list[i+1].x-list[i].x), ])

  // Intersection points between the normal vector
  // starting at the middle points with the
  // lines of the average angle.
  let(ca = 
    [
      Average(m[0], LineIntersection(m[0],nv[0], list[1],v[1])),

      for(i=[1:n-3]) 
        Average(LineIntersection(m[i],nv[i], list[i],v[i]), LineIntersection(m[i],nv[i], list[i+1],v[i+1])),

      Average(LineIntersection(m[n-2],nv[n-2], list[n-2],v[n-2]), m[n-2]),
    ])

  // Then use that to take the average with the middle points.
  let(ca2 = 
    [
      for(i=[0:n-2]) 
        Average(ca[i], m[i]),
    ])

  // Weave the new points between the original points.
  let(new =
    [
      for(i=[0:n-2]) each [list[i], ca2[i]],
      list[n-1],
    ])

  // Somehow I got a smooth curve out of this.
  new;


// LineIntersection
// ----------------
//
// Calculate the intersection point of two straight lines.
// At this moment, it is only a helper function for the "fit" method
// of subdivision.
// Only tested in 2D.
//
// Parameters:
//   P1:     A point on the first line.
//   angle1: The angle of the first line.
//   P2:     A point on the second line.
//   angle2: The angle of the second line.
// Return:   The intersection point of the lines.
//           When the lines are (almost) parallel,
//           then an empty list is returned.
// Note:     This seems to be common math.

function LineIntersection(P1,angle1,P2,angle2) =
  // Calculate the vectors with a length of 1.
  let(Vector1 = [cos(angle1), sin(angle1)])
  let(Vector2 = [cos(angle2), sin(angle2)])
  
  // Calculate the cross product of the vectors.
  let(cros = cross(Vector1,Vector2))

  // Calculate the difference between the points.
  let(t1 = P2 - P1)

  // Calculate the crossing point of the lines.
  // Return empty list if the lines are (almost) parallel.
  abs(cros) < 0.001 ? [] :
    let(t2 = (t1.x*Vector2.y - t1.y*Vector2.x)/cros)
    P1 + Vector1*t2;


// Average
// -------
//
// Calculate the average from a variable number of parameters.
// Parameters:
//   A...Z:     A variable list of arguments, up to 26 arguments.
//              They can be numbers or coordinates in 2D or 3D.
// Return:      The average.
//              If there are no arguments, then 'undef' is returned.
function Average (A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z) = 
  !is_undef(Z) ? (A+B+C+D+E+F+G+H+I+J+K+L+M+N+O+P+Q+R+S+T+U+V+W+X+Y+Z)/26 :
  !is_undef(Y) ? (A+B+C+D+E+F+G+H+I+J+K+L+M+N+O+P+Q+R+S+T+U+V+W+X+Y)/25 :
  !is_undef(X) ? (A+B+C+D+E+F+G+H+I+J+K+L+M+N+O+P+Q+R+S+T+U+V+W+X)/24 :
  !is_undef(W) ? (A+B+C+D+E+F+G+H+I+J+K+L+M+N+O+P+Q+R+S+T+U+V+W)/23 :
  !is_undef(V) ? (A+B+C+D+E+F+G+H+I+J+K+L+M+N+O+P+Q+R+S+T+U+V)/22 :
  !is_undef(U) ? (A+B+C+D+E+F+G+H+I+J+K+L+M+N+O+P+Q+R+S+T+U)/21 :
  !is_undef(T) ? (A+B+C+D+E+F+G+H+I+J+K+L+M+N+O+P+Q+R+S+T)/20 :
  !is_undef(S) ? (A+B+C+D+E+F+G+H+I+J+K+L+M+N+O+P+Q+R+S)/19 :
  !is_undef(R) ? (A+B+C+D+E+F+G+H+I+J+K+L+M+N+O+P+Q+R)/18 :
  !is_undef(Q) ? (A+B+C+D+E+F+G+H+I+J+K+L+M+N+O+P+Q)/17 :
  !is_undef(P) ? (A+B+C+D+E+F+G+H+I+J+K+L+M+N+O+P)/16 :
  !is_undef(O) ? (A+B+C+D+E+F+G+H+I+J+K+L+M+N+O)/15 :
  !is_undef(N) ? (A+B+C+D+E+F+G+H+I+J+K+L+M+N)/14 :
  !is_undef(M) ? (A+B+C+D+E+F+G+H+I+J+K+L+M)/13 :
  !is_undef(L) ? (A+B+C+D+E+F+G+H+I+J+K+L)/12 :
  !is_undef(K) ? (A+B+C+D+E+F+G+H+I+J+K)/11 :
  !is_undef(J) ? (A+B+C+D+E+F+G+H+I+J)/10 :
  !is_undef(I) ? (A+B+C+D+E+F+G+H+I)/9 :
  !is_undef(H) ? (A+B+C+D+E+F+G+H)/8 :
  !is_undef(G) ? (A+B+C+D+E+F+G)/7 :
  !is_undef(F) ? (A+B+C+D+E+F)/6 :
  !is_undef(E) ? (A+B+C+D+E)/5 :
  !is_undef(D) ? (A+B+C+D)/4 :
  !is_undef(C) ? (A+B+C)/3 :
  !is_undef(B) ? (A+B)/2 :
  !is_undef(A) ? (A) : undef;

