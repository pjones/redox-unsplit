// Position for each switch as it sits on the left-hand keyboard.
//
// Returns an array of positions.  Each position is itself an array
// with the following elements:
//
// 0: Positive X position relative to the left edge of the keyboard.
// 1: Negative Y position relative to the top edge of the keyboard.
// 2: Angle in degrees.
//
function switch_positions() =
  let ( row_sep = 18.9395,
      , c1x = 11.8687,  c1y = 17.8031, c1r5x = 14.3937
      , c2x = 33.3310,  c2y = c1y
      , c3x = 52.2725,  c3y = 13.3840
      , c4x = 71.2119,  c4y = 10.8584
      , c5x = 90.1514,  c5y = 13.3840
      , c6x = 109.0908, c6y = 15.2774
      , c7x = 128.0303
      )
  [
    // Column 1 (x, y, angle):
      [ c1x,   c1y + row_sep * 0, 0 ] // Row 1
    , [ c1x,   c1y + row_sep * 1, 0 ] // Row 2
    , [ c1x,   c1y + row_sep * 2, 0 ] // Row 3
    , [ c1x,   c1y + row_sep * 3, 0 ] // Row 4
    , [ c1r5x, c1y + row_sep * 4, 0 ] // Row 5

    // Column 2:
    , [ c2x,   c2y + row_sep * 0, 0 ] // Row 1
    , [ c2x,   c2y + row_sep * 1, 0 ] // Row 2
    , [ c2x,   c2y + row_sep * 2, 0 ] // Row 3
    , [ c2x,   c2y + row_sep * 3, 0 ] // Row 4
    , [ c2x,   c2y + row_sep * 4, 0 ] // Row 5

    // Column 3:
    , [ c3x,   c3y + row_sep * 0, 0 ] // Row 1
    , [ c3x,   c3y + row_sep * 1, 0 ] // Row 2
    , [ c3x,   c3y + row_sep * 2, 0 ] // Row 3
    , [ c3x,   c3y + row_sep * 3, 0 ] // Row 4
    , [ c3x,   c3y + row_sep * 4, 0 ] // Row 5

    // Column 4:
    , [ c4x,   c4y + row_sep * 0, 0 ] // Row 1
    , [ c4x,   c4y + row_sep * 1, 0 ] // Row 2
    , [ c4x,   c4y + row_sep * 2, 0 ] // Row 3
    , [ c4x,   c4y + row_sep * 3, 0 ] // Row 4
    , [ c4x,   c4y + row_sep * 4, 0 ] // Row 5

    // Column 5:
    , [ c5x,   c5y + row_sep * 0, 0 ] // Row 1
    , [ c5x,   c5y + row_sep * 1, 0 ] // Row 2
    , [ c5x,   c5y + row_sep * 2, 0 ] // Row 3
    , [ c5x,   c5y + row_sep * 3, 0 ] // Row 4

    // Column 6:
    , [ c6x,   c6y + row_sep * 0, 0 ] // Row 1
    , [ c6x,   c6y + row_sep * 1, 0 ] // Row 2
    , [ c6x,   c6y + row_sep * 2, 0 ] // Row 3
    , [ c6x,   c6y + row_sep * 3, 0 ] // Row 4

    // Column 7:
    , [ c7x,   24.7472,           0 ] // Row 1.5
    , [ c7x,   48.7373,           0 ] // Row 2.5

    // Thumb Keys:
    , [  96.4645,  92.2971, 15 ]
    , [ 131.8171,  78.4074, 30 ]
    , [ 148.2303,  87.8772, 30 ]
    , [ 119.8219,  99.2411, 30 ]
    , [ 136.2356, 108.7108, 30 ]
  ];

// Render children at each switch position.
module position_switch() {
  for (pos = switch_positions()) {
    translate([pos[0], -pos[1], 0])
      rotate([0, 0, -pos[2]])
      children();
  }
}

// The base of a Kailh Speed switch.
module kailh_speed_switch(tolerance=0.5)
{
  base_width = 13.95 + tolerance;
  base_height = 5;

  top_width = 15.60;
  plate_thickness = 1.6;

  translate([-(base_width/2), -(base_width/2), base_height - plate_thickness])
    cube( [ base_width
          , base_width
          , plate_thickness
          ]);

  translate([-(top_width/2), -(top_width/2), 0])
    cube( [ top_width
          , top_width
          , base_height - plate_thickness
          ]);
}
