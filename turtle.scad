// turtle.scad
//
// Part of the StoneAgeLib
//
// Version 1
// February 3, 2025
// By: Stone Age Sculptor
// License: CC0 (Public Domain)
// This version number is the overall version for everything in this file.
// Some modules and functions in this file may have their own version.

// I prefer how the Python Turtle graphics is used.
// I created this script from scratch, without looking at implementations by others.
//
// To do: 
//   * Check if parameter(s) are available for a command.
//   * Convert Python turtle text into a OpenSCAD turtle list.
//       I checked OpenSCAD for how long a text can be,
//       and it still worked with a text that is 1 million characters long.
//   * Add COLOR, DOT (with color), PENSIZE, SHAPE
//   * Perhaps even add REPEAT ?
//   * Make an example with recursion.

// A list with turtle commands will be translated into coordinates.
// Turtle commands:
//   LEFT,angle   Turn left with the angle.
//   RIGHT,angle  Turn right with the angle.
//   HOME         Go to (0,0) and set the angle to 0.
//   CIRCLE,radius,extend  
//                Make an arc with the radius.
//                The extend is how much of a circle is drawn,
//                360 is a full circle.
//                A positive radius makes a left-turn acr.
//                A negative radius makes a right-turn arc.
//   FORWARD,distance
//                Move forward
//   BACKWARD,distance
//                Move backward
//   SETX,x       Set x to an absolute value
//   SETY,y       Set y to an absolute value
//   SETHEADING,angle
//                Set the heading to an absolute angle.
//   STAMP        Draw a stamp.
//                The stamp is not drawn, but an arrow shape
//                is added to the list of points.
//

include <list.scad>

LEFT = 100;
RIGHT = 101;
HOME = 102;
FORWARD = 103;
BACKWARD = 104;
CIRCLE = 105;
GOTO = 106;
SETX = 107;
SETY = 108;
SETHEADING = 109;
STAMP = 110;

// The default stamp in Python Turtle graphics is an arrow head.
// The default angle is zero, therefor it points to the right.
stamp =
[
  [0,0],[-1.2,-0.8],[-1.3,-0.65],[-0.7,0],[-1.3,0.65],[-1.2,0.8],[0,0]
];

module DrawPath(path,width=0.5)
{
  if(len(path) >= 2)
  {
    for(i=[0:len(path)-2])
    {
      hull()
      {
        for(j=[0,1])
          translate(path[i+j])
            circle(width);
      }
    }
  }
}

function TurtleToPath(turtlelist,accuracy=$fn) =
  concat([[0,0], each WalkTheTurtle(turtlelist=turtlelist,accuracy=accuracy)]);
 
// This function is recursive, going through all
// the commands in the list.
// The position and the angle of the turtle is kept
// in the parameters "angle" and "lastpos".
function WalkTheTurtle(turtlelist,accuracy=$fn,index=0,angle=0,lastpos=[0,0]) = 
  index < len(turtlelist) ?

    // LEFT turns the angle left with the specified degrees.
    // The turtle itself stays in the same position.
    // No coordinates are added to the returning list.
    turtlelist[index][0] == LEFT ?
      WalkTheTurtle(turtlelist,accuracy,index+1,angle+turtlelist[index][1],lastpos) :

    // RIGHT turns the angle left with the specified degrees.
    // The turtle itself stays in the same position.
    // No coordinates are added to the returning list.
    turtlelist[index][0] == RIGHT ?
      WalkTheTurtle(turtlelist,accuracy,index+1,angle-turtlelist[index][1],lastpos) :

    // FORWARD moves the turtle forward, in the direction
    // of the angle of the turtle.
    turtlelist[index][0] == FORWARD ?
      let(x = lastpos.x + turtlelist[index][1] * cos(angle))
      let(y = lastpos.y + turtlelist[index][1] * sin(angle)) 
      concat([[x,y]], WalkTheTurtle(turtlelist,accuracy,index+1,angle,[x,y])) :

    // BACKWARD moves the turtle backward, according to the direction
    // of the angle of the turtle.
    turtlelist[index][0] == BACKWARD ?
      let(x = lastpos.x - turtlelist[index][1] * cos(angle))
      let(y = lastpos.y - turtlelist[index][1] * sin(angle)) 
      concat([[x,y]], WalkTheTurtle(turtlelist,accuracy,index+1,angle,[x,y])) :

    // CIRCLE has two parameters:
    //   first parameter: 
    //     The radius of the circle.
    //       Positive for turn left arc.
    //       Negative for turn right arc.
    //   second parameter:
    //     The part of a circle.
    //     360 is a full circle, 90 is a quarter of a circle.
    turtlelist[index][0] == CIRCLE ?
      // The radius for the arc.
      let(radius = abs(turtlelist[index][1]))
      // The extend is a part of a circle, 360 is a full circle.
      let(extend = turtlelist[index][2])
      // Put the center of the circle on the left or on the right.
      let(left_right = turtlelist[index][1] < 0 ? -1 : 1)
      // Calculate the center position of the circle.
      let(center_x = lastpos.x + radius*cos(angle + left_right*90))
      let(center_y = lastpos.y + radius*sin(angle + left_right*90))
      // Calcuate the start and end angle.
      let(angle_start = angle - left_right*90)
      let(angle_end = angle_start + left_right*extend)
      // Calculate the number of steps, according to the $fn settings.
      let(steps = floor(accuracy * abs(angle_end - angle_start)/360))
      let(angle_step = (angle_end - angle_start) / steps)
      // Calculate a list with arc coordinates.
      // Keep the list empty, if there are no steps.
      let(arc = steps > 0 ? [for(i=[0:steps]) 
             [center_x + radius*cos(angle_start+angle_step*i), 
             center_y + radius*sin(angle_start+angle_step*i)]] : [])
      // Calculate the new angle for the turtle.
      let(new_angle = angle + left_right*extend)
      // Calculate the new location of the turtle.
      let(x = center_x + radius*cos(angle_end))
      let(y = center_y + radius*sin(angle_end))
      concat(arc, WalkTheTurtle(turtlelist=turtlelist,accuracy=accuracy,index=index+1,angle=new_angle,lastpos=[x,y])) : 

    // GOTO goes straight to an absolute location.
    // The angle is not changed.
    turtlelist[index][0] == GOTO ?
      let(x = turtlelist[index][1])
      let(y = turtlelist[index][2]) 
      concat([[x,y]], WalkTheTurtle(turtlelist=turtlelist,accuracy=accuracy,index=index+1,angle=angle,lastpos=[x,y])) :

    // SETX sets the x-coordinate to an absolute value.
    // The angle is not changed.
    turtlelist[index][0] == SETX ?
      let(x = turtlelist[index][1])
      let(y = lastpos.y)
      concat([[x,y]], WalkTheTurtle(turtlelist=turtlelist,accuracy=accuracy,index=index+1,angle=angle,lastpos=[x,y])) :

    // SETY sets the y-coordinate to an absolute value.
    // The angle is not changed.
    turtlelist[index][0] == SETY ?
      let(x = lastpos.x)
      let(y = turtlelist[index][1])
      concat([[x,y]], WalkTheTurtle(turtlelist=turtlelist,accuracy=accuracy,index=index+1,angle=angle,lastpos=[x,y])) :

    // SETHEADING sets the heading (angle) to an absolute value.
    turtlelist[index][0] == SETHEADING ?
      let(newangle = turtlelist[index][1])
      WalkTheTurtle(turtlelist=turtlelist,accuracy=accuracy,index=index+1,angle=newangle,lastpos=lastpos) :

    // STAMP is not part of the returned list.
    // A stamp is created.
    turtlelist[index][0] == STAMP ?
      let(newstamp = TranslateList(RotateList(stamp,angle),lastpos))
      concat(newstamp, WalkTheTurtle(turtlelist=turtlelist,accuracy=accuracy,index=index+1,angle=angle,lastpos=lastpos)) : 

    // HOME goes to (0,0)
    // The angle is also reset to zero.
    // A zero angle is in the direction of the postive x-axis.
    turtlelist[index][0] == HOME ?
      concat([[0,0]], WalkTheTurtle(turtlelist=turtlelist,accuracy=accuracy,index=index+1,angle=0,lastpos=[0,0])) : [] : [];


