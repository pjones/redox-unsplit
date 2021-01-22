include <geometry.scad>

$fa = 1.0;
$fs = 0.5;

module each_pos(positions) {
  for (pos = positions) {
    translate([pos.x, pos.y, 0])
      children();
  }
}

// These exist because I couldn't get dims out of the DXF file for
// some reason.  OpenSCAD would return the position of the text label,
// not the actual dim.

module round(amount=4)
{
  offset(r = amount)
    offset(delta = -amount)
    children();
}

// A side (c) and two adjacent angles (A, B) given (ASA)
//
// Returns a vector where the elements are remaining sides (a and b)
// and the other angle (C).
//
// https://en.wikipedia.org/wiki/Solution_of_triangles#A_side_and_two_adjacent_angles_given_(ASA)
function triangle_asa(c, A, B) =
  let ( C = 180 - A - B
      , a = c * sin(A) / sin(C)
      , b = c * sin(B) / sin(C)
      )
  [a, b, C];

// A side (c), one adjacent angle (A) and the opposite angle (C) given (AAS)
function triangle_aas(c, A, C) =
  let ( B = 180 - A - C
      , a = c * sin(A) / sin(C)
      , b = c * sin(B) / sin(C)
      )
  [ a, b, B ];

let ( t = triangle_aas(7, 35, 62) )
assert(round(t[0]) == 5 && round(t[1]) == 8 && t[2] == 83, t);

// Two sides (a, b) and the included angle (C) given (SAS).
function triangle_sas(a, b, C) =
  let ( c = sqrt(pow(a, 2) + pow(b, 2) - (2 * a * b * cos(C)))
      , A = acos((pow(b, 2) + pow(c, 2) - pow(a, 2)) / (2 * b * c))
      , B = 180 - A - C
      )
  [ c, A, B];

let ( t = triangle_sas(5, 7, 49) )
assert(round(t[0]) == 5 && round(t[1]) == 45 && round(t[2]) == 86, t);

module m3_insert(center=false)
{
  translate([0, 0, center ? 0 : m3_insert_depth/2])
    cylinder(d=m3_insert_dia,
             h=m3_insert_depth,
             center=true);
}

module m3_stud(wall_thickness=2, height)
{
  outer_dia = m3_insert_dia + wall_thickness;

  difference() {
    cylinder(d=outer_dia, h=height, center=true);
    cylinder(d=m3_insert_dia, h=height+0.2, center=true);
  }
}

// A tapered M3 screw head.
//
// The head is centered.
module m3_screw_head(height)
{
  upper_dia = 6 + tolerance;
  lower_dia = 3 + tolerance;
  rim_height = 0.75;
  head_height = 2;
  body_height = height - head_height;

  translate([0, 0, -(height/2)])  {
    translate([0, 0, body_height]) {
      hull() {
        translate([0, 0, head_height + rim_height/2])
          cylinder(d=upper_dia, h=rim_height, center=true);

        translate([0, 0, rim_height/2])
          cylinder(d=lower_dia, h=rim_height, center=true);
      }
    }

    translate([0, 0, body_height/2])
      cylinder(d=lower_dia, h=body_height, center=true);
  }
}

module usb_c_plug(h=23) {
  width = 11.5;
  dia = 6.25;
  gap = width/2 - dia/2;

  hull() {
    translate([-gap, 0, 0])
      cylinder(d=dia, h=h, center=true);

    translate([gap, 0, 0])
      cylinder(d=dia, h=h, center=true);
  }
}

module trrs_plug(h=15) {
  cylinder(d=7.5, h=h, center=true);
}

usb_c_plug();
