include <geometry.scad>
use <util.scad>

function mounting_surface_screw_locations(wall_thickness, width, height) =
  let ( x_offset = wall_thickness + 1
      , y_offset = height / 2
      )
  [ [ x_offset,         -y_offset ]
  , [ width - x_offset, -y_offset ]
  ];

function mounting_surface_cargo_width(wall_thickness, width, height) =
  let (screw_locations =
        mounting_surface_screw_locations(wall_thickness, width, height)
      , screw_offset = (screw_locations[0][0] + (m3_insert_dia/2)) * 2
      )
    width - screw_offset - wall_thickness;

function mounting_surface_joint_height(actual_height) =
  actual_height - 3;

// A single join centered on the origin.
module mounting_surface_joint(
  depth=10,
  width=8,
  height=8,
  for_cutout=false)
{
  fit_height = mounting_surface_joint_height(height);

  rotate([0, -90, 0])
    translate([0, 0, -(width/2)])
    linear_extrude(height=width, convexity=10,  slices=100)
    offset(delta = for_cutout ? tolerance/2 : 0)
    polygon(
      points =
        [ [ -(depth/2), -(fit_height/2) ]
        , [ depth/2,    -(fit_height/2) ]
        , [ depth/2,     (fit_height/2) ]
        , [ -(depth/2),  0          ]
        ]);
}

// The base of the mounting adapters which attaches to the case.
//
// The object will have it's X and Y axes centered on the origin,
// while the part sits on 0 for the Z axes.
module mounting_surface_base(
  wall_thickness=3,
  width=70,
  height=8,
  rounding_constant=1.5)
{
  screw_locations =
    mounting_surface_screw_locations(
      wall_thickness,
      width,
      height);

  difference() {
    linear_extrude(height=wall_thickness, convexity=10,  slices=100)
      round(amount=rounding_constant)
      square(size=[width, height], center=true);

    each_pos(positions=screw_locations)
      translate([-(width/2), -(height/2), wall_thickness/2])
      m3_screw_head(height=wall_thickness);
  }
}

// The internal parts of the mounting surface that need to be cut out
// of the case.
//
// The object is rotated and it's top-right corner placed on the
// origin.  The object is centered on the Z axis.
module mounting_surface_cutout(
  wall_thickness=3,
  width=70,
  height=8,
  rounding_constant=1.5,
  max_cargo_depth=10)
{
  screw_locations =
    mounting_surface_screw_locations(
      wall_thickness,
      width,
      height);

  screw_depth =
    m3_insert_depth;

  cargo_width
    = width
    - (screw_locations[0][0] + (m3_insert_dia/2)) * 2
    - wall_thickness;

  total_height
    = wall_thickness
    + max_cargo_depth
    + tolerance/2;

  total_width
    = width
    + tolerance;

  z_for_center = (total_height/2) - wall_thickness;

  tri1 = triangle_aas(total_width/2, 90, 90 - abs(dim_shell_rot));
  tri2 = triangle_aas(total_height/2 - tri1[1], abs(dim_shell_rot), 90);

  /* translate([-triangle_x[0], -triangle_y[0], 0]) */
  translate([-tri2[1], -(tri1[0] + tri2[0]), 0])
    rotate([-90 , 0 , -90 - dim_shell_rot])
    translate([0, 0, z_for_center])
    difference() {
    union() {
      linear_extrude(height=wall_thickness, convexity=10,  slices=100)
        round(amount=rounding_constant)
        offset(delta = tolerance/2)
        square(size=[width, height], center=true);

      // Holes for the M3 screw inserts:
      each_pos(positions=screw_locations)
        translate([-(width/2), height/2, -(screw_depth/2)])
        cylinder(d=m3_insert_dia,
                 h=screw_depth,
                 center=true);

      // Carve out the cargo area:
      translate([0, 0, -((max_cargo_depth + tolerance/2)/2)])
        cube([ cargo_width
               , height + tolerance
               , max_cargo_depth + tolerance/2
               ], center=true);
    }
  }
}

module mounting_surface_adapter_positive(
  wall_thickness=3,
  width=70,
  height=8,
  rounding_constant=1.5,
  joint_count=3,
  max_cargo_depth=10)
{
  cargo_length =
    mounting_surface_cargo_width(
      wall_thickness,
      width,
      height);

  mounting_surface_base(
    wall_thickness=wall_thickness,
    width=width,
    height=height,
    rounding_constant=rounding_constant);

  translate([-(cargo_length/4), 0, (max_cargo_depth/2) + wall_thickness])
    rotate([0, 0, 180])
    mounting_surface_joint(
      depth=max_cargo_depth,
      width=cargo_length/2,
      height=height,
      for_cutout=false);
}

module mounting_surface_adapter_negative(
  wall_thickness=3,
  width=70,
  height=8,
  rounding_constant=1.5,
  joint_count=3,
  max_cargo_depth=10)
{
  cargo_length =
    mounting_surface_cargo_width(
      wall_thickness,
      width,
      height);

  joint_height =
    mounting_surface_joint_height(height);

  difference() {
    union() {
      mounting_surface_base(
        wall_thickness=wall_thickness,
        width=width,
        height=height,
        rounding_constant=rounding_constant);

      translate([0, 0, -(height/2)])
        cube([cargo_length, height, max_cargo_depth],
          center=true);
    }

  translate([-(cargo_length/4), 0, -(max_cargo_depth/2) + wall_thickness])
    rotate([0, 180, 0])
    mounting_surface_joint(
      depth=max_cargo_depth,
      width=cargo_length/2,
      height=height,
      for_cutout=true);

  translate([cargo_length/4, 0, -(max_cargo_depth/2) + wall_thickness])
    cube([cargo_length/2, joint_height, max_cargo_depth],
        center=true);
  }
}

mounting_surface_cutout();
