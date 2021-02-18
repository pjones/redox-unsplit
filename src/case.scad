// Which case view to display
view="L"; // [L:Left_Case, J:Both_Halves, B:Back_Cut_Away]


include <geometry.scad>
use <caps.scad>
use <mounts.scad>
use <plates.scad>
use <switches.scad>
use <util.scad>

function case_height(
  // How much space to reserve for key caps to recess into the case.
  cap_cutout_thickness,
  // Total height of the plate, including the mounting studs that
  // separate the plate and PCB.
  plate_thickness,
  // Total height of the PCB, including any components.
  pcb_thickness,
  // Height of the shell bottom, NOT including studs that touch the
  // PCB.  In other words, this should probably be the wall thickness.
  shell_bottom_height)
= cap_cutout_thickness
  + plate_thickness
  + pcb_thickness
  + shell_bottom_height;

function mount_thickness(case_height, wall_thickness)
= case_height - (wall_thickness * 2);

module left_shell(
  // How thick to make the shell walls.
  wall_thickness=3,
  // See `case_height' above.
  cap_cutout_thickness=8.5,
  // See `case_height' above.
  plate_thickness=5.1,
  // See `case_height' above.
  pcb_thickness=9.35,
  // See `case_height' above.
  shell_bottom_height=3,
  // Should the USB port be exposed from outside the case?
  expose_usb_port=true,
  // Location of mounting holes to attach the shell bottom to the
  // case itself.
  shell_bottom_mounts=case_hole_positions,
  // Amount of rounding to apply to the shell.
  shell_rounding_constant=4,
  // Calculated positions of the switches.
  switch_positions=switch_positions)
{
  height =
    case_height(
      cap_cutout_thickness,
      plate_thickness,
      pcb_thickness,
      shell_bottom_height);

  cap_base_height = 1.5;

  difference() {
    // Build the outer shell:
    union() {
      // This is a curved version of the outer shell.
      linear_extrude(height=height, convexity = 10,  slices = 100)
        offset(r=shell_rounding_constant) offset(delta=-shell_rounding_constant)
        offset(delta=wall_thickness)
        shell_shape();

      // This intersection removes the rounding from the case where
      // the two halves touch.
      intersection() {
        linear_extrude(height=height, convexity = 10,  slices = 100)
          offset(delta=wall_thickness)
          shell_shape();

        translate(
          [ -dim_shell_offset_x
            + dim_shell_x1
            + wall_thickness*2
            + shell_rounding_constant
          , -(dim_shell_max_y/2)
            + dim_shell_offset_y
            + wall_thickness
          , 0
          ])
        rotate([0, 0, -dim_shell_rot])
        linear_extrude(height=height, convexity = 10,  slices = 100)
        offset(delta=wall_thickness)
        square([shell_rounding_constant*2, dim_shell_max_y], center=true);
      }
    }

    // Cut out the top section for the key caps to recess into:
    each_switch(switch_positions, true)
      translate(
        [ 0
        , 0
        , height - cap_cutout_thickness + cap_base_height
        ])
        scale([1.055, 1.055, 1])
        children(1);

    // Cut out the switch tops:
    //
    // FIXME: Hard-coded size for the switch tops.
    each_switch(switch_positions)
      translate([0, 0, height - cap_cutout_thickness])
        cube([15, 17, cap_base_height*2], center=true);

    // Cut out the switch plate and PCB:
    translate(
      [ 0
      , 0
      , height - cap_cutout_thickness - (plate_thickness + pcb_thickness)
      ])
      linear_extrude(
        height=plate_thickness + pcb_thickness,
        convexity=10,
        slices=100)
      offset(delta=1.0)
      pcb_shape();

    // Cut out the section where the bottom attaches:
    linear_extrude(height=shell_bottom_height, convexity = 10,  slices = 100)
      offset(delta=tolerance) // Some additional space for the piece to fit snug.
      shell_shape();

    // Cut out the mounting holes for the M3 inserts:
    each_pos(positions=shell_bottom_mounts)
      translate([0, 0, shell_bottom_height])
        m3_insert(center=false);

    // Cut out a hole to access the TRRS jack:
    trrs_y = dim_trrs_y + wall_thickness*3 + tolerance;

    translate(
      [ dim_trrs_x
      , wall_thickness*2
      , pcb_thickness + shell_bottom_height - dim_trrs_z
      ])
    rotate([90, 0, 0])
      trrs_plug(h=trrs_y);

    // Cut out the USB port overhang so the PCB can go into the case:
    translate(
      [ dim_usb_x
      , dim_usb_overhang/2
      , (pcb_thickness + dim_usb_z)/2
      ])
      {
        rotate([90, 0, 0])
        resize([0, pcb_thickness + dim_usb_z, 0])
        scale([1.05, 1, 1])
        usb_c_plug(h=dim_usb_overhang);

        scale([1.05, 1, 1.05,])
          cube([dim_microcontroller_x,
                dim_usb_overhang,
                pcb_thickness + dim_usb_z],
              center=true);
      };

    // Now open the USB port itself:
    if (expose_usb_port) {
      y = dim_usb_y + wall_thickness*2 + tolerance;

      translate(
        [ dim_usb_x
        , y/2
        , pcb_thickness + shell_bottom_height - dim_usb_z
        ])
      rotate([90, 0, 0])
      usb_c_plug(h=y);
    }
  }
}

module left_shell_for_split(
  wall_thickness=3,
  cap_cutout_thickness=8.5,
  plate_thickness=5.1,
  pcb_thickness=8.5,
  shell_bottom_height=3,
  expose_usb_port=true,
  shell_bottom_mounts=case_hole_positions,
  shell_rounding_constant=4,
  switch_positions=switch_positions)
{
  height =
    case_height(
      cap_cutout_thickness,
      plate_thickness,
      pcb_thickness,
      shell_bottom_height);

  mount_height = mount_thickness(height, wall_thickness);

  angled_wall_thickness =
    triangle_aas(wall_thickness, abs(dim_shell_rot), 90)[1];

  case_triangle = triangle_asa(
    dim_mount_offset_y, // Side c
    90,                 // Angle A
    abs(dim_shell_rot)  // Angle B
    );

  difference() {
    left_shell(
      wall_thickness=wall_thickness,
      cap_cutout_thickness=cap_cutout_thickness,
      plate_thickness=plate_thickness,
      pcb_thickness=pcb_thickness,
      shell_bottom_height=shell_bottom_height,
      expose_usb_port=expose_usb_port,
      shell_bottom_mounts=case_hole_positions,
      shell_rounding_constant=shell_rounding_constant,
      switch_positions=switch_positions)
      {
        children(0);
        children(1);
      }

    // FIXME: Something is wrong with the trig calculations above
    // since we get really close to the destination but are off by a
    // hair.  The mount cutout needs to be pushed a bit in the X
    // direction so that it will be flush with the edge of the case.
    x_fudge_factor = 0.26;

    // Cut out the mounting joints:
    translate(
      [ -dim_shell_offset_x
        + dim_shell_x1
        + case_triangle[1]
        + angled_wall_thickness
        + x_fudge_factor
      , dim_shell_offset_y2
        - dim_mount_offset_y
      , mount_height/2 + wall_thickness
      ])
      mounting_surface_cutout(
        wall_thickness=wall_thickness,
        width=dim_mount_len,
        height=mount_height,
        max_cargo_depth=dim_mount_depth);
  }
}

module left_shell_for_joining(
  wall_thickness=3,
  cap_cutout_thickness=8.5,
  plate_thickness=5.1,
  pcb_thickness=2,
  shell_bottom_height=3,
  shell_bottom_mounts=case_hole_positions,
  shell_rounding_constant=4,
  switch_positions=switch_positions)
{
  translate(
    [ -dim_shell_max_x/2 + 10 // FIXME: This is a fake value
    , -dim_shell_max_y/2
    , 0
    ])
    rotate([0, 0, dim_shell_rot])
    translate(
      [ dim_shell_offset_x - dim_shell_max_x/2
        , -dim_shell_offset_y + dim_shell_max_y/2
        , 0
        ])
    left_shell(
      wall_thickness=3,
      cap_cutout_thickness=8.5,
      plate_thickness=5.1,
      pcb_thickness=2,
      shell_bottom_height=3,
      shell_bottom_mounts=case_hole_positions,
      shell_rounding_constant=4,
      switch_positions=switch_positions)
    {
      children(0);
      children(1);
    }
}

module both_sides_together(
  wall_thickness=3,
  cap_cutout_thickness=8.5,
  plate_thickness=5.1,
  pcb_thickness=2,
  shell_bottom_height=3,
  shell_bottom_mounts=case_hole_positions,
  shell_rounding_constant=4,
  switch_positions=switch_positions)
{
  left_shell_for_joining(
    wall_thickness=3,
    cap_cutout_thickness=8.5,
    plate_thickness=5.1,
    pcb_thickness=2,
    shell_bottom_height=3,
    shell_bottom_mounts=case_hole_positions,
    shell_rounding_constant=4,
    switch_positions=switch_positions)
    {
      children(0);
      children(1);
    }

  mirror([1, 0, 0])
    left_shell_for_joining(
      wall_thickness=3,
      cap_cutout_thickness=8.5,
      plate_thickness=5.1,
      pcb_thickness=2,
      shell_bottom_height=3,
      shell_bottom_mounts=case_hole_positions,
      shell_rounding_constant=4,
      switch_positions=switch_positions)
    {
      children(0);
      children(1);
    }
}


$fa = 1.0;
$fs = 0.5;

if (view == "L") {
  left_shell_for_split() {
    kailh_speed_switch();
    sa_1u();
  }
} else if (view == "J") {
  both_sides_together() {
    kailh_speed_switch();
    sa_1u();
  }
} else if (view == "B") {
  mirror([0, 1, 0])
  mirror([0, 0, 1])
  difference() {
    left_shell_for_split() {
      kailh_speed_switch();
      sa_1u();
    }

    translate([-dim_shell_offset_x*2,
              -dim_shell_max_y*2 - 10,
              0])
      cube([dim_shell_max_x*2,
            dim_shell_max_y*2,
            30]);
  }
}
