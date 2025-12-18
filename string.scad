// string.scad
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
// July 15, 2025
// Changes:
//   Added substr() function.
//
// This version number is the overall version for everything in this file.
// Some modules and functions in this file may have their own version.


// ==============================================================
//
// string_to_numbers with subfunctions
// -----------------------------------
//
// Convert a string with numbers (as text)
// to a OpenSCAD list of numbers.
// This is part of my OpenSCAD file: Elements.scad
// I might use it in other OpenSCAD files,
// so it has its own version number.
//
// By Stone Age Sculptor
// Version 1, October 29, 2023, License CC0
//   Initial version.
// Version 2, November 1, 2023, License CC0
//   Code simplified.
//   Fixed bug when first character
//   was not a number.
//
// To do: Accept negative numbers and floating point numbers.

// ======================================
// function string_to_numbers
// ======================================
// Filter the digits '0' ... '9' from a string,
// and convert it to a list of numbers.
// When no digits are found, an empty list is returned.
function string_to_numbers(string) =
  let( temporary = to_string_with_separators(string),
    separatorlist = search("#",temporary,0,0)[0] )
    to_list_of_numbers(temporary,separatorlist) ;
  
// ======================================
// function to_string_with_separators
// ======================================
// A string of text with numbers will be converted
// to a string with "#" as separator character.
// Every character that is not a numerical digit will
// become a "#".
// To make it easier for the other functions,
// a "#" is added to the end and if the string
// is empty, then also a "#" is returned.
function to_string_with_separators(s,i=0) =
  len(s) > 0 ?
    let( a = s[i] >= "0" && s[i] <= "9" ? s[i] : "#")
    i < len(s)-1 ?
      str(a, to_string_with_separators(s,i+1)) :
      str(a, "#") :  // add trailing #
    "#";         // return a # if string is empty

// ======================================
// to_list_of_numbers
// ======================================
// string       : a string with digits and "#"
// sep_list     : is list of indexes for the "#"
// string_index : index in the string
// sep_index    : index in the separator list
function to_list_of_numbers(string,sep_list,string_index=0,sep_index=0) =
  sep_index < len(sep_list) ?
    concat(calculate_number(string,string_index,sep_list[sep_index]), 
      to_list_of_numbers(string,sep_list,sep_list[sep_index]+1,sep_index+1)) :
    []; // add nothing

// ======================================
// char_to_num
// ======================================
// Turn a single character into a number.
function char_to_num(c) = ord(c) - ord("0");

// ======================================
// calculate_number
// ======================================
// Calculate the number from a few of characters "0" ... "9"
// to a decimal number
// For example string "123" becomes number 123
// s     : the string
// first : the index of the first character.
// last  : the index of the separator "#" (after the digits).
function calculate_number(s,first,last) =
  last > first ?
    last > first + 1 ?
      char_to_num(s[last-1]) + 10*calculate_number(s,first,last-1) :
      char_to_num(s[first]):
      [];   // add nothing
      
// ======================================
// substr(text,pos,len)
// ======================================
// Returns a substring, starting at 'pos' with length 'len'.
// Parameters:
//   text    The string.
//   pos     Starting index.
//           When it is below zero, then an
//           empty string is returned.
//   len     Number of characters to return.
// Note:
//   I have seen other substr() functions, 
//   and I thought it can be simpler.
//   This is the most simple that I can think of,
//   including checks for wrong values of 'pos' and 'len'.
//   After writing it, I compared it with the
//   "substr()" of the BOSL2 library, and it uses
//   the same 'pos+1' and 'len-1', so it works
//   in the same way.
function substr(text, pos=0, len=1, _grow="") =
  let(maxpos = min(pos+len,len(text)))
  (pos < maxpos && pos >= 0) ? substr(text,pos=pos+1,len=len-1,_grow=str(_grow, text[pos])) : _grow;

// ==============================================================
