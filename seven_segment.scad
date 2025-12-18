// seven_segment.scad
//
// Part of the StoneAgeLib
//
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
//
// Version 1
// March 2, 2025
//
// Version 2
// March 26, 2025
//   Removed the global variables.
//
// This version number is the overall version for everything in this file.
// Some modules and functions in this file may have their own version.

include <turtle.scad>

// Some 7-segment displays have rounded outer edges.
// It is style 0 in this script.
// Those shapes can be made with a Turtle.
//
// Inspired by this Public Domain picture:
// https://openclipart.org/detail/277146/7-segment-display-8
//
// Turtle graphics are used to create the shapes of the 7-segment display.
// It turned out to be not a good decision to use a Turtle for this.
// But it works for now.


// Draw7Segment
// ------------
// Parameters:
//   string
//     The number to show, a dot . or colon : or a space is allowed.
//     Also A..Z and a..z are possible, but not well readable.
//     A ";" is an invisible colon.
//     Only text is possible, no numbers.
//   spacing
//     The spacing between the digits. Default 1.2.
//   angle
//     The angle of the digit in degrees. 
//     A value of 0 is without skew. Default 8.
//   shrink
//     Shrinking each segment makes it thinner
//     and the gap between the segments are larger.
//     Default 0.12.
//   style
//     0: Default, nice style.
//     1: Simple style, with 45 degrees corners.
//
// To do:
//   * A 16-segment display as is used for the month
//     in the movie "Back to the Future".
//   * Put the data in a function to allow the width as parameter.
//   
module Draw7Segment(string,spacing=1.2,angle=8,shrink=0.12,style=0,_index=0,_xpos=0)
{
  // Conversion table for a 7-segment display.
  seven_segment_conversion =
  [
    [ "0", "abcdef"  ],
    [ "1", "bc"      ],
    [ "2", "abged"   ],
    [ "3", "abgcd"   ],
    [ "4", "fbgc"    ],
    [ "5", "afgcd"   ],
    [ "6", "afgcde"  ],
    [ "7", "abc"     ],
    [ "8", "abcdefg" ],
    [ "9", "fabgcd"  ],
    [ "A", "efabcg"  ],
    [ "B", "fgcde"   ],
    [ "C", "afed"    ],
    [ "D", "edgcb"   ],
    [ "E", "afged"   ],
    [ "F", "efga"    ],
    [ "G", "acdef"   ],
    [ "H", "bcefg"   ],
    [ "I", "bc"      ],
    [ "J", "bcd"     ],
    [ "K", "befg"    ],
    [ "L", "def"     ],
    [ "M", "egc"     ],
    [ "N", "egc"     ],
    [ "O", "abcdef"  ],
    [ "P", "efabg"   ],
    [ "Q", "gfabc"   ],
    [ "R", "efabgc"  ],
    [ "S", "afgcd"   ],
    [ "T", "abc"     ],
    [ "U", "fedcb"   ],
    [ "V", "fedcb"   ],
    [ "W", "fedcb"   ],
    [ "X", "egbfc"   ],
    [ "Y", "fgbcd"   ],
    [ "Z", "abged"   ],
    [ "a", "abgcde"  ],
    [ "b", "fgcde"   ],
    [ "c", "ged"     ],
    [ "d", "bgcde"   ],
    [ "e", "bafged"  ],
    [ "f", "efag"    ],
    [ "g", "fabgcd"  ],
    [ "h", "fegc"    ],
    [ "i", "c"       ],
    [ "j", "bcd"     ],
    [ "k", "efgcb"   ],
    [ "l", "fed"     ],
    [ "m", "egc"     ],
    [ "n", "egc"     ],
    [ "o", "efdcba"  ],
    [ "p", "fabge"   ],
    [ "q", "fabgc"   ],
    [ "r", "eg"      ],
    [ "s", "afgcd"   ],
    [ "t", "fedg"    ],
    [ "u", "edc"     ],
    [ "v", "edc"     ],
    [ "w", "edc"     ],
    [ "x", "egbfc"   ],
    [ "y", "fgbcd"   ],
    [ "z", "abged"   ],
    [ "°", "abgf"    ],
    [ "-", "g"       ],
    // The next characters are special.
    // They are not translated to a segment,
    // but they are dealt with in the script.
    [ ".", "."       ],    // dot between the digits
    [ ":", ":"       ],    // visible colon
    [ ";", ";"       ],    // invisible colon
    [ " ", " "       ],    // space instead of a digit
  ];

  skew = 
  [
    [1, tan(angle), 0, 0],
    [0, 1, 0, 0 ],
    [0, 0, 1, 0 ],
    [0, 0, 0, 1 ] 
  ];

  // The two designs have a different width.
  digit_width_turtle = 5.2;
  digit_width_simple = 5.8;

  width = (style == 0) ? digit_width_turtle :
          (style == 1) ? digit_width_simple : 0;

  segment_width = 1.2; // width of a single segment

  // The size of the colon dots
  // are a little bigger than the width
  // of a segment.
  // I think it looks better that way.
  diameter_colon = 1.1*segment_width;

  diameter_dot = 1;   // size of the dot

  if(_index < len(string))
  {
    char = string[_index];
    code = search(char,seven_segment_conversion,1,0);
    
    // When it is not found in the list,
    // then the code is empty and len(code) is zero.
    if(len(code)==0)
    {
       // Advance to next character in the list.
       Draw7Segment(string=string,
              spacing=spacing,
              angle=angle,
              shrink=shrink,
              style=style,
              _index=_index+1,
              _xpos=_xpos);
    }
    else
    {
      segments = seven_segment_conversion[code[0]][1];
 
      // When a special character is used, then the
      // length of the string is just one.
      char  = segments[0];
      dot            = (char==".");
      visiblecolon   = (char==":");
      invisiblecolon = (char==";");
      space          = (char==" ");

      translate([_xpos,0])
      {
        if(dot)
        {
          // The multmatrix can not be used,
          // because that would skew the round circle.
          //
          // The position of the next digit is not changed by the dot.
          // Somehow try to squeeze the dot between the digits.

          // How much is available?
          available = spacing + shrink;
          r1 = min(diameter_dot,available)/2;
          r2 = max(r1,diameter_dot/4);  
          translate([-spacing/2+r2*tan(angle),r2])
            offset(-0.7*shrink/2)
              circle(r=r2);
        }
        else if(visiblecolon)
        {
          // The multmatrix can not be used,
          // because that would skew the round circle.
          y1 = 3.5;
          x1 = diameter_colon/2+y1*tan(angle);
          y2 = 6.5;
          x2 = diameter_colon/2+y2*tan(angle);
          translate([x1,y1])
            offset(-shrink/2)
              circle(d=diameter_colon);
          translate([x2,y2])
            offset(-shrink/2)
              circle(d=diameter_colon);
        }
        else if(space || invisiblecolon)
        {
          // Nothing is printed.
          // This "else if" has to be here,
          // to avoid that something is printed.
        }
        else
        {
          // Use a multi matrix operation for skew.
          multmatrix(skew)
          {
            // Print each segment.
            for(segment=segments)
            {
              i = ord(segment)-ord("a");
              
              if(style==0)
              {
                offset(-shrink/2)
                  SevenSegmentTurtle(i,width);
              }
              else if(style==1)
              {
                offset(-shrink/2)
                  SevenSegmentSimple(i,width);
              }
            }
          } 
        }
      }

      colon = (visiblecolon || invisiblecolon);

      offset1 = dot   ? 0 : width+spacing;
      offset2 = colon ? (diameter_colon+spacing) : offset1;
      new_xpos = _xpos + offset2;
      Draw7Segment(string=string,
                  spacing=spacing,
                  angle=angle,
                  shrink=shrink,
                  style=style,
                  _index=_index+1,
                  _xpos=new_xpos);
    }
  }
}

// Clock7Segment
// -------------
// A function to print the time as 12:34 or 12:34:56
// Parameters:
//   hours
//     Preferably 0 to 23
//     Default 0.
//   minutes
//     Preferably 0 to 59
//   seconds
//     Preferably 0 to 59
//   colon
//     true for one or two colons in the middle,
//     false for no visible colon.
module Clock7Segment(hours=0,minutes,seconds,colon=true)
{
  // Convert the number to text,
  // and add a zero if needed.
  h_text = hours < 10 ? str("0",hours) : str(hours);

  // When the minutes are not defined, 
  // then the string is empty.
  m_text = is_num(minutes) ? 
    minutes < 10 ? str("0",minutes) : str(minutes) :
    "";

  // When the seconds are not defined, 
  // then the string is empty.
  s_text = is_num(seconds) ? 
    seconds < 10 ? str("0",seconds) : str(seconds) :
    "";

  // When the minutes are defines, then it
  // probably needs the first colon.
  colon1 = is_num(minutes) ?
    colon ? ":" : ";" :
    "";

  // When the seconds are defined, then it
  // probably needs the second colon.
  colon2 = is_num(seconds) ?
    colon ? ":" : ";" :
    "";

  // Combine everything in one string.
  time = str(h_text, colon1, m_text, colon2, s_text);
  Draw7Segment(time);
}

// SevenSegmentTurtle()
// --------------------
// Draw one of the seven segments,
// using the fancy style that is
// made with Turtle graphics.
//
// Parameters:
//   segment: 0..6 for segment a..f
//   width  : width of a digit (before tilting/skew)
module SevenSegmentTurtle(segment,width)
{
  _radius1 = 0.6;      // sharper round edge
  _radius2 = 1;        // wider round edge

  // The length of each segment can be made shorter.
  // The segments are designed with this value at zero.
  gap_adjust = 0.15; // segment length adjust.

  // The width of the complete digit can be changed.
  // A little wider than designed is better.
  // It is designed with a width of 5.
  width_adjust = width - 5;

  _digit_height = 10;  // the total heigt of a digit

  // Every segment is created in its position.
  // The "TELEPORT" command works for now only
  // as the first command.
  turtle_seven_segment =
  [
    // a   top   at [0]
    [
      [TELEPORT,1.2,8.8],
      [FORWARD,2.6-gap_adjust+width_adjust],
      [LEFT,60],
      [FORWARD,1.38565],
      [LEFT,120],
      [FORWARD,3.62247-gap_adjust+width_adjust],
      [CIRCLE,_radius2,60.5],
    ],
    // b   upper-right   at [1]
    [
      [TELEPORT,3.8+width_adjust,8.8],
      [RIGHT,90],
      [FORWARD,3.2-gap_adjust/2],
      [LEFT,55],
      [FORWARD,1.0],
      [LEFT,75],
      [FORWARD,0.497],
      [LEFT,50],
      [FORWARD,4.06136-gap_adjust/2],
      [CIRCLE,_radius1,81.088],
    ],
    // c   lower-right   at [2]
    [
      [TELEPORT,3.8+width_adjust,1.2],
      [LEFT,90],
      [FORWARD,3.2-gap_adjust/2],
      [RIGHT,52.594],
      [FORWARD,1.03122],
      [RIGHT,73],
      [FORWARD,0.46835],
      [RIGHT,54.406],
      [FORWARD,4.16105-gap_adjust/2],
      [CIRCLE,-_radius1,81.10],
    ],
    // d   bottom   at [3]
    [
      [TELEPORT,1.2,1.2],
      [FORWARD,2.6-gap_adjust+width_adjust],
      [RIGHT,60],
      [FORWARD,1.38564],
      [RIGHT,120],
      [FORWARD,3.6268-gap_adjust+width_adjust],
      [CIRCLE,-_radius2,60],
    ],
    // e   lower-left   at [4]
    [
      [TELEPORT,1.2,1.2+gap_adjust],
      [LEFT,90],
      [FORWARD,3.2-1.5*gap_adjust],
      [LEFT,55.541],
      [FORWARD,0.88909],
      [LEFT,80],
      [FORWARD,0.66665],
      [LEFT,44.459],
      [FORWARD,3.92723-1.5*gap_adjust],
    ],
    // f   upper-left   at [5]
    [
      [TELEPORT,1.2,5.6+0.75*gap_adjust],
      [LEFT,90],
      [FORWARD,3.2-1.5*gap_adjust],
      [LEFT,60.014],
      [FORWARD,1.38545],
      [LEFT,119.986],
      [FORWARD,4.34-1.5*gap_adjust],
      [LEFT,61.894],
      [FORWARD,0.52931],
    ],
    // g   middle   at [6]
    [
      [TELEPORT,1.2+0.75*gap_adjust,4.4],
      [FORWARD,2.6-1.5*gap_adjust+width_adjust],
      [LEFT,37.405],
      [FORWARD,1.0312],
      [LEFT,107.5937],
      [FORWARD,1.00001],
      [LEFT,35.0011],
      [FORWARD,2.600-1.5*gap_adjust+width_adjust],
      [LEFT,43.552],
      [FORWARD,1.0115],
    ],
  ];

  path = TurtleToPath(turtle_seven_segment[segment]);
  polygon(path);
}


// SevenSegmentSimple()
// --------------------
// Draw one of the seven segments,
// using the simple style.
//
// Parameters:
//   segment: 0..6 for segment a..f
//   width  : width of a digit (before tilting/skew)
module SevenSegmentSimple(segment,width)
{
  // Simple style with 45 degrees tips
  // and each segment is the same.
  // It fits in a 5*10 area.
  //
  // The data is build as separate paths,
  // to be able to use the paths for future use.
  // For now, they are used for a polygon.
  w = width;      // width of a digit
  h = 10;         // height of a digit
  i = h/2;        // half the height
  s = 1.2;        // width of segment
  t = s/2;        // half width of segment
  m = +0.1;       // gap, by making the length shorter.
  simple_seven_segment =
  [
    // a 
    [[t+m,h-t],[s+m,h-s],[w-s-m,h-s],[w-t-m,h-t],[w-s-m,h],[s+m,h]],
    // b 
    [[w-t,h-t-m],[w-s,h-s-m],[w-s,i+t+m],[w-t,i+m],[w,i+t+m],[w,h-s-m]],
    // c 
    [[w-t,i-m],[w-s,i-t-m],[w-s,s+m],[w-t,t+m],[w,s+m],[w,i-t-m]],
    // d 
    [[t+m,t],[s+m,0],[w-s-m,0],[w-t-m,t],[w-s-m,s],[s+m,s]],
    // e 
    [[t,t+m],[0,s+m],[0,i-t-m],[t,i-m],[s,i-t-m],[s,s+m]],
    // f 
    [[t,i+m],[0,i+t+m],[0,h-s-m],[t,h-t-m],[s,h-s-m],[s,i+t+m]],
    // g 
    [[t+m,i],[s+m,i+t],[w-s-m,i+t],[w-t-m,i],[w-s-m,i-t],[s+m,i-t]],
  ];

  path = simple_seven_segment[segment];
  polygon(path);
}

// ----------------------------------------------------
// This module shows the segments for the fancy style 0.
// The Turtle commands were designed
// by using this module.
module SevenSegmentDesigner()
{
  segment_width = 1.2; // width of a single segment
  digit_width_turtle = 5.2;
  radius1 = 0.6;       // sharper round edge
  radius2 = 1;         // wider round edge
  gap_adjust = 0.15;   // segment length adjust.
  width_adjust = digit_width_turtle - 5;
  digit_height = 10;   // the total heigt of a digit

  turtle_seven_segment =
  [
    // a   top   at [0]
    [
      [TELEPORT,1.2,8.8],
      [FORWARD,2.6-gap_adjust+width_adjust],
      [LEFT,60],
      [FORWARD,1.38565],
      [LEFT,120],
      [FORWARD,3.62247-gap_adjust+width_adjust],
      [CIRCLE,radius2,60.5],
    ],
    // b   upper-right   at [1]
    [
      [TELEPORT,3.8+width_adjust,8.8],
      [RIGHT,90],
      [FORWARD,3.2-gap_adjust/2],
      [LEFT,55],
      [FORWARD,1.0],
      [LEFT,75],
      [FORWARD,0.497],
      [LEFT,50],
      [FORWARD,4.06136-gap_adjust/2],
      [CIRCLE,radius1,81.088],
    ],
    // c   lower-right   at [2]
    [
      [TELEPORT,3.8+width_adjust,1.2],
      [LEFT,90],
      [FORWARD,3.2-gap_adjust/2],
      [RIGHT,52.594],
      [FORWARD,1.03122],
      [RIGHT,73],
      [FORWARD,0.46835],
      [RIGHT,54.406],
      [FORWARD,4.16105-gap_adjust/2],
      [CIRCLE,-radius1,81.10],
    ],
    // d   bottom   at [3]
    [
      [TELEPORT,1.2,1.2],
      [FORWARD,2.6-gap_adjust+width_adjust],
      [RIGHT,60],
      [FORWARD,1.38564],
      [RIGHT,120],
      [FORWARD,3.6268-gap_adjust+width_adjust],
      [CIRCLE,-radius2,60],
    ],
    // e   lower-left   at [4]
    [
      [TELEPORT,1.2,1.2+gap_adjust],
      [LEFT,90],
      [FORWARD,3.2-1.5*gap_adjust],
      [LEFT,55.541],
      [FORWARD,0.88909],
      [LEFT,80],
      [FORWARD,0.66665],
      [LEFT,44.459],
      [FORWARD,3.92723-1.5*gap_adjust],
    ],
    // f   upper-left   at [5]
    [
      [TELEPORT,1.2,5.6+0.75*gap_adjust],
      [LEFT,90],
      [FORWARD,3.2-1.5*gap_adjust],
      [LEFT,60.014],
      [FORWARD,1.38545],
      [LEFT,119.986],
      [FORWARD,4.34-1.5*gap_adjust],
      [LEFT,61.894],
      [FORWARD,0.52931],
    ],
    // g   middle   at [6]
    [
      [TELEPORT,1.2+0.75*gap_adjust,4.4],
      [FORWARD,2.6-1.5*gap_adjust+width_adjust],
      [LEFT,37.405],
      [FORWARD,1.0312],
      [LEFT,107.5937],
      [FORWARD,1.00001],
      [LEFT,35.0011],
      [FORWARD,2.600-1.5*gap_adjust+width_adjust],
      [LEFT,43.552],
      [FORWARD,1.0115],
    ],
  ];

  // helper squares
  w1 = segment_width;
  translate([0,0,-1.1])
    color("Red",0.5)
      difference()
      {
        square([digit_width_turtle,digit_height]);
        translate([w1,w1])
          square([digit_width_turtle-2*w1,digit_height/2-1.5*w1]);
        translate([w1,digit_height/2+w1/2])
          square([digit_width_turtle-2*w1,digit_height/2-1.5*w1]);
      }

  // All the segments
  color("Blue",0.25)
  {
    for(i=[0:len(turtle_seven_segment)-1])
    {
      list = TurtleToPath(turtle_seven_segment[i],accuracy=200);
      polygon(list);
    }
  }

  translate([0,0,1.1])
  {
    color("Black",0.5)
    {
      translate([2,9])
        text("a",size=1);
      translate([4,6.8])
        text("b",size=1);
      translate([4,2.3])
        text("c",size=1);
      translate([2.1,0.1])
        text("d",size=1);
      translate([0.2,2.3])
        text("e",size=1);
      translate([0.4,6.8])
        text("f",size=1);
      translate([2,4.8])
        text("g",size=1);
    }
  }
}
