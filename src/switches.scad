include <geometry.scad>

// Render children at each switch position.
module each_switch(positions, scale_using_cap_units=false) {
  for (pos = positions) {
    x = pos[0];
    y = pos[1];
    rot = pos[2];
    unit_x = scale_using_cap_units ? pos[3] : 1;
    unit_y = scale_using_cap_units ? pos[4] : 1;

    translate([x, y, 0])
      rotate([0, 0, rot])
      scale([unit_x, unit_y, 1])
      children();
  }
}

// The base of a Kailh Speed switch.
module kailh_speed_switch(plate_only=true) {
  base_width = 13.95 + tolerance;
  base_height = 5;

  top_width = 15.60;
  plate_thickness = 1.6;

  if (plate_only) {
    translate([-(base_width/2), -(base_width/2), 0])
      cube([base_width, base_width, plate_thickness]);
  } else {
    translate([-(base_width/2), -(base_width/2), base_height - plate_thickness])
      cube([base_width, base_width, plate_thickness]);

    translate([-(top_width/2), -(top_width/2), 0])
      cube([ top_width, top_width, base_height - plate_thickness]);
  }
}
