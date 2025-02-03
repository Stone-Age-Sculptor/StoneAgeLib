// shadow.scad
//
// Part of the StoneAgeLib
//
// Version 2
// July 9, 2024
// by Stone Age Sculptor
// Licence: CC0 (Public Domain)
//
// Version 3
// February 3, 2025
// By: Stone Age Sculptor
// Licence: CC0 (Public Domain)
//   Added highlight to the Shadow2D() function.

// Shadow2D()
// ----------
// Calculate the shape of the shadow, by using 
// the multmatrix "skew".
// The shadow can be created in other ways,
// for example with the vector of the linear_extrude.
//
// Parameters:
//   length = The length of the shadow.
//   highlight = set to true to create a highlight
//               instead of a shadow.
//   angle  = The angle of the shadow. 
//     Angle 0 is along the x-axis to the right.
//     A positive angle is counterclockwise.
//   width  = The width of a outline around the text.
//     Set to zero for no outline.
module Shadow2D(length=1,angle=-45,width=0,highlight=false)
{
  // Only the shadow is kept.
  // There could be a rounding error when the original shape
  // is removed.
  // A value of "0.0003" is enough for both the 2021
  // and 2024 version of OpenSCAD, so I used
  // "0.001" to be sure.
  epsilon = 0.001;
  giga    = 1000000;

  if(highlight)
  {
    // highlight
    // ---------
    // A very large rectangle is used to create
    // the negated image. The intersection removes
    // the shadow of the rectangle.
    intersection()
    {
      Shadow2D(length=length,angle=angle,highlight=false)
      {
        difference()
        {
          square(giga,center=true);
          children(0);
        }
      }
      children(0);
    }
  }
  else
  {
    // shadow
    // ------
    difference()
    {
      // The OpenSCAD "multmatrix()" can do a skew,
      // which can be used to cast the shadows.
      // The multmatrix() skew works on 3D objects, 
      // therefor the shape is converted to 3D, then a skew, 
      // then back to 2D with "projection()".

      // Keep the scale and the position the same.
      // Only use the shear for X and Y. 
      matrix = 
        [[1,0,cos(angle),0],
         [0,1,sin(angle),0],  
         [0,0,1,0]];

      // Use everything from the skew object with cut=false.
      projection(cut=false)
        multmatrix(matrix) 
        { 
          linear_extrude(length/2)
            children(0);
        }

      // Remove the original shape of the character.
      // Remove a little more with "epsilon" to avoid
      // rounding errors.
      offset(epsilon)
        children(0);
    }
  }

  // outline
  // -------
  // Add a border to the character if the width is set to a
  // certain size.
  // This border is grown twice the "epsilon" amount,
  // to be sure that it connects to the shape of the shadow.
  if(width > epsilon)
  {
    difference()
    {
      offset(2*epsilon) 
        children(0);
      offset(-width)
        children(0);
    }
  }
}
