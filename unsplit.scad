$fa = 1.0;
$fs = 0.5;

use <src/caps.scad>
use <src/case.scad>
use <src/mounts.scad>
use <src/plates.scad>
use <src/switches.scad>

// The part.
part = "case"; // ["plate", "bottom", "case", "mount"]

// Which side of the part?
side = "left"; // ["left", "right"]

plate_thickness = 1.6;

case_wall_thickness = 3;
case_bottom_thickness = case_wall_thickness;

// How deep to make the key cap wells.  This measurement is relative
// to the switch plate.  The default value ensures that the case rises
// just above the key cap to protect them during travel.
cap_cutout_depth = 8.5;

// Space between the PCB and the switch plate.  Mounting studs are
// created to support the switch plate and allow the plate, PCB, and
// case bottom to attach to one another.
space_between_plate_and_pcb = 3.5;

// Extra space between the PCB and the case bottom to account for
// solder joins, RGB strips, the microcontroller, etc.
space_between_pcb_and_bottom = 7.75;

module left_plate_for_print() {
  mirror([0, 1, 0])
    mirror([0, 0, 1])
    left_switch_plate(
      plate_thickness=plate_thickness,
      mounting_stud_height=space_between_plate_and_pcb)
    children();
}

module case_left_for_print(expose_usb_port) {
  mirror([0, 1, 0])
    mirror([0, 0, 1])
    left_shell_for_split(
      wall_thickness=case_wall_thickness,
      cap_cutout_thickness=cap_cutout_depth,
      plate_thickness=plate_thickness+space_between_plate_and_pcb,
      pcb_thickness=plate_thickness+space_between_pcb_and_bottom,
      expose_usb_port=expose_usb_port,
      shell_bottom_height=case_bottom_thickness)
    {
      children(0);
      children(1);
    }
}

module bottom_left_for_print() {
  left_bottom_plate(
    height=case_bottom_thickness,
    stud_height=space_between_pcb_and_bottom);
}

module mount_left_for_print() {
  mounting_surface_adapter_positive(
    wall_thickness=case_wall_thickness,
    width=70,
    height=8,
    rounding_constant=1.5,
    joint_count=3,
    max_cargo_depth=10);
}

module mount_right_for_print() {
  mounting_surface_adapter_negative();
}

module select_part_for_print(part, side) {
  if (part == "plate") {
    if (side == "left") left_plate_for_print() children(0);
    else mirror([0, 1, 0]) left_plate_for_print() children(0);

  } else if (part == "bottom") {
    if (side == "left") bottom_left_for_print();
    else mirror([0, 1, 0]) bottom_left_for_print();

  } else if (part == "case") {
    if (side == "left")
      case_left_for_print(expose_usb_port=true) {
        children(0);
        children(1);
      }
    else
      mirror([0, 1, 0])
        case_left_for_print(expose_usb_port=false) {
          children(0);
          children(1);
        }

  } else if (part == "mount") {
    if (side == "left") mount_left_for_print();
    else mount_right_for_print();
  }
}

select_part_for_print(part, side) {
  kailh_speed_switch();
  sa_1u();
}
