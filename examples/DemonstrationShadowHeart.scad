// DemonstrationShadowHeart.scad
//
//

include <StoneAgeLib/StoneAgeLib.scad>

// The "Magiera Script" font is a Public Domain font.
use <Magiera Script.ttf>
font = "Magiera:style=Script";

$fn=80;

// The border.
color("Red")
  linear_extrude(1.4)
    difference()
    {
      offset(+2)
        BasicHeart2D();
      offset(-2)
        BasicHeart2D();
    }

// The lattice structure inside.
// Using the FlexHex2D() from the library.
color("DarkRed")
  linear_extrude(1)
    difference()
    {
      BasicHeart2D();
      // grid: higher for larger stones.
      // gap : lattice between the stones.
      // irregularity: higher for more irregularity
      FlexHex2D(l=300,w=200,grid=7,gap=1.2,irregularity=60);
    }

// The text.
color("GoldenRod")
  linear_extrude(2.6)
    BasicText2D();

// The shadow of the text.
// Using the Shadow2D() from the library.
color("#404040")
  linear_extrude(2.0)
    Shadow2D(length=5)
      BasicText2D();

// The basic shape of the full heart.
// Using the heart2D() from the library.
module BasicHeart2D()
{
  heart2D(100,raise=0,stretch=0.2,shift=0.2,points=150);
}

// The basic shape of the full text.
module BasicText2D()
{
  translate([-46,68])
    rotate(16)
      text("Happy",font=font,size=18);
  translate([-53,29])
    rotate(16)
      text("Birthday",font=font,size=18);
}
