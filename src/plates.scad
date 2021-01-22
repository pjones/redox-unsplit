$fa = 1.0;
$fs = 0.5;

include <geometry.scad>
use <switches.scad>
use <util.scad>

module left_pcb(
  plate_thickness=default_plate_thickness)
{
  linear_extrude(height=plate_thickness, convexity=10, slices=100)
    pcb_shape();
}

module left_switch_plate(
  plate_thickness=default_plate_thickness,
  mounting_stud_height=3.5,
  switch_positions=switch_positions)
{
  difference() {
    union() {
      // The plate is the exact same size as the PCB.
      left_pcb(plate_thickness);

      // Mounting studs that will accept M3 screw inserts so the plate
      // can be attached to the case bottom.
      each_pos(pcb_hole_positions)
        translate([0, 0, -(mounting_stud_height/2)])
          m3_stud(height=mounting_stud_height);

      // Add some legs to keep the plate from sagging just in case
      // any pressure is applied to it.
      each_pos(pcb_leg_positions)
        translate([0, 0, -(mounting_stud_height/2)])
        cylinder(d=4, h=mounting_stud_height, center=true);
    }

    // Cut out the switches.
    each_switch(switch_positions)
      children();
  }
}

module left_bottom_plate(
  height=3,
  stud_height=3,
  stud_wall=2,
  pcb_mounts=pcb_hole_positions,
  case_mounts=case_hole_positions)
{
  difference() {
    union() {
      linear_extrude(height=height, convexity = 10,  slices = 100)
        shell_shape();

      each_pos(positions=pcb_mounts)
        translate([0, 0, stud_height/2 + height])
          m3_stud(wall_thickness=stud_wall, height=stud_height);
    }

    each_pos(positions=pcb_mounts)
      translate([0, 0, height/2])
        rotate([0, 180, 0])
        m3_screw_head(height=height);

    each_pos(positions=case_mounts)
      translate([0, 0, height/2])
        rotate([0, 180, 0])
        m3_screw_head(height=height);
  }
}

left_switch_plate()
  kailh_speed_switch();

/* left_bottom_plate(); */
