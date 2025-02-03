// tangentlines.scad
//
// Part of the StoneAgeLib
//
// Version 1
// September 27, 2024
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//
// Version 2.01
// September 27, 2024
// With improvements by Reddit user ImpatientProf.
// https://www.reddit.com/r/openscad/comments/1fqa33m/i_spent_a_few_days_in_tangent_lines/
// The improvements by ImpatientProf were incorporated 
// in this script by me (Stone Age Sculptor).
// License: CC0 (Public Domain)
// Version 2.01 has a few fixes in the comments,
// after publishing Version 2.
//
// Version 3
// October 6, 2024
// By Stone Age Sculptor
// License: CC0 (Public Domain)
// Added two functions:
//   IntersectionPoints()
//     The two coordinates of overlapping circles.
//   TouchPoint()
//     The point where circles touch.


// PointForInternal
// ----------------
// This function calculates the shared tangent point
// between the two circles.
// The calculation is based on similar triangles
// and calculations with vectors in OpenSCAD.
// It works also with overlapping circles.
// Parameters: 
//   Two circles.
//     Defined by their center points and radius.
// Return: 
//   A point in 2D
function PointForInternal(Centre1, Radius1, Centre2, Radius2) = 
  (Radius2*Centre1 + Radius1*Centre2)/(Radius2+Radius1);


// PointForExternal
// ----------------
// This function calculates the shared external tangent point
// of two circles.
// The calculation is based on similar triangles
// and calculations with vectors in OpenSCAD.
// It even works with overlapping circles.
// Parameters: 
//   Two circles.
//     Defined by their center points and radius.
// Return: 
//   A point in 2D
// Limits:
//   When both circles have the same radius, then the
//   common external point can not be calculated.
//   In that case, this function returns "inf" numbers 
//   with or without sign as in [±inf,±inf].
//   The "inf" number in OpenSCAD can be used in calculations.
//   When the same circle is used twice, then [nan,nan] is returned.
function PointForExternal(Centre1, Radius1, Centre2, Radius2) =
  (Radius2*Centre1 - Radius1*Centre2)/(Radius2 - Radius1);


// TangentPoints
// -------------
// Calculate the two tangent points on a circle
// with a point.
// When lines are drawn from that point to the 
// two calculated tangent points, then those lines
// are the tangent lines.
// Parameters:
//   Centre: the centre of the circle
//   Radius: the radius of the circle
//   Point : the point at which the line starts
// Return:
//   Two points in 2D on the edge of the circle.
//   They can be used as
//     p[0].x, p[0].y, p[1].x, p[1].y
// Limits:
//   When the external point is infinitive
//   or "nan" then this function can fail.
//   At this moment, the circle radius is used
//   as a minimum value for the distance to avoid
//   that the calculation fails when the point
//   is inside the circle.
// Uncertain:
//   Two points are returned.
//   When viewing from the big circle to the small
//   circle, then the first point is on the right.
//   But I'm not sure.
function TangentPoints(Centre, Radius, Point) = 
  let (d = Centre - Point,
       // l1 is distance between center of the circle and the point.
       // The formula is sqrt(d.x*d.x + d.y*d.y),
       // but there is a function "norm()" for it.
       l1 = norm(d),
       // Prevent that the asin() function fails.
       l2 = max(l1, Radius),
       // Calculate the two angles for the resulting tangent points.
       a = atan2(d.y, d.x) + 180,
       b = asin(Radius / l2))
  [[Centre.x + Radius*sin(a+b), Centre.y - Radius*cos(a+b)],
   [Centre.x - Radius*sin(a-b), Centre.y + Radius*cos(a-b)]];


// IntersectionPoints
// ------------------
// Returns the two intersection points of two 
// overlapping circles.
// There are no similar angles and there are
// no similar triangles.
// The calculation makes used of the most basic 
// principle for a circle. 
// That is for every (x,y) point on the circle 
// with radius r: r² = x² + y²
// The only other information is the distance between
// the centers of the circles.
// There are a number of ways to write down 
// the calculation.
// I worked my way towards a certain style that I liked
// the most. That style can be seen in the code:
//   k1 = tb * d/l;
//   k2 = ta * d/l;
// Then extra code was added to avoid that this function
// fails when one circle is inside the other circle.
// Parameters:
//   Two circles, defined by their location and radius.
// Return:
//   Two points in 2D.
// Limits:
//   This function avoids that the calculation fails,
//   by letting the two points melt together
//   and advance in a continues way through the circle,
//   when one circle is inside the other circle.
function IntersectionPoints(Center1,Radius1,Center2,Radius2) =
  let(d  = Center2 - Center1,
      l  = norm(d),
      t1 = (Radius1*Radius1 - Radius2*Radius2 + l*l)/(2*l),
      t2 = Radius1*Radius1,
      t3 = t1*t1,
      ta = t2 > t3 ? sqrt(t2-t3) : 0,
      tb = t2 > t3 ? t1 : -Radius1,
      k1 = tb*d/l + Center1,
      k2 = ta*d/l)
  [[k1.x - k2.y, k1.y + k2.x],
   [k1.x + k2.y, k1.y - k2.x]];


// TouchPoint
// ----------
// This function calculates the point
// where two circles touch.
// Because of the calculation and rounding 
// differences, it is hard to tell if the
// circles really touch. Therefor the average
// location is returned.
// Parameters: Two circles, defined by
//   their center point and radius.
// Return: A single point in 2D
// Limits:
//   If the circles are the same, then
//   the center point of the circles 
//   is returned.
function TouchPoint(Center1,Radius1,Center2,Radius2) =
  let( d = Center2-Center1,
       l_total = norm(d),
       l_avg = (Radius1 + l_total-Radius2)/2,
       a = atan2(d.y,d.x))
  [Center1.x + l_avg*cos(a),
   Center1.y + l_avg*sin(a)];


// DrawLine
// --------
// This module draws a line with squared ends.
// Some use a hull() over two points,
// but this calculation matches the style
// of the rest of the script.
//
// Smart code with hull() by Reddit user oldesole1:
//   // Since each line terminates inside a double-width 
//   // circle, this just hulls over two points.
//   module DrawLine(Point1,Point2)
//   {
//     hull()
//       for (pos = [Point1,Point2])
//         translate(pos)
//           circle(d = line_width);
//   }
// I think that the hull() is faster and more straightforward.
module DrawLine(Point1,Point2,line_width=0.5)
{
  /*
  d = Point1 - Point2;
  l = norm(d);
  a = atan2(d.y, d.x) + 180;
  translate(Point1)
    rotate(a)
      translate([0,-line_width/2])
        square([l,line_width]);
  */

  hull()
    for (pos = [Point1,Point2])
      translate(pos)
        circle(d = line_width);
}
