default_plate_thickness =
  1.6;

tolerance = 0.1;

module pcb_shape() {
  import(file="../redox/pcb.dxf");
}

pcb_hole_positions =
  [ [   6.2230,  -5.2070 ]
  , [ 116.7130,  -3.3020 ]
  , [  23.3680, -80.1370 ]
  , [ 133.8580, -95.5040 ]
  ];

pcb_hole_dia =
  4.0;

module shell_shape() {
  import(file="../redox/shell.dxf", layer="Shell");
}

case_hole_positions =
  [ [   1.1034,    1.9458 ]
  , [ 143.0628,   -1.3050 ]
  , [   1.0002, -101.5929 ]
  , [ 158.2978, -114.6142 ]
  ];

// Position for each switch as it sits on the left-hand keyboard.
//
// Returns an array of positions.  Each position is itself an array
// with the following elements:
//
// 0: X.
// 1: Y.
// 2: Angle in degrees.
// 3: Key cap units in the X direction.
// 4: Key cap units in the Y direction.
//
// All measurements are to the center of the switch, and assume the
// PCB is at the origin going in the positive X direction and negative
// Y direction.
switch_positions =
  let ( row_sep = -19.05,
      , c1x =  11.9380, c1y = -17.9370, c1r5x = 14.4780
      , c2x =  33.5280, c2y = c1y
      , c3x =  52.5780, c3y = -13.4920
      , c4x =  71.6280, c4y = -10.9520
      , c5x =  90.6780, c5y = -13.4920
      , c6x = 109.7280, c6y = -15.3970
      , c7x = 128.7780
      )
  [
    // Column 1
      [ c1x,   c1y + row_sep * 0, 0, 1.25, 1.0 ] // Row 1
    , [ c1x,   c1y + row_sep * 1, 0, 1.25, 1.0 ] // Row 2
    , [ c1x,   c1y + row_sep * 2, 0, 1.25, 1.0 ] // Row 3
    , [ c1x,   c1y + row_sep * 3, 0, 1.25, 1.0 ] // Row 4
    , [ c1r5x, c1y + row_sep * 4, 0, 1.0,  1.0 ] // Row 5

    // Column 2:
    , [ c2x,   c2y + row_sep * 0, 0, 1.0, 1.0 ] // Row 1
    , [ c2x,   c2y + row_sep * 1, 0, 1.0, 1.0 ] // Row 2
    , [ c2x,   c2y + row_sep * 2, 0, 1.0, 1.0 ] // Row 3
    , [ c2x,   c2y + row_sep * 3, 0, 1.0, 1.0 ] // Row 4
    , [ c2x,   c2y + row_sep * 4, 0, 1.0, 1.0 ] // Row 5

    // Column 3:
    , [ c3x,   c3y + row_sep * 0, 0, 1.0, 1.0 ] // Row 1
    , [ c3x,   c3y + row_sep * 1, 0, 1.0, 1.0 ] // Row 2
    , [ c3x,   c3y + row_sep * 2, 0, 1.0, 1.0 ] // Row 3
    , [ c3x,   c3y + row_sep * 3, 0, 1.0, 1.0 ] // Row 4
    , [ c3x,   c3y + row_sep * 4, 0, 1.0, 1.0 ] // Row 5

    // Column 4:
    , [ c4x,   c4y + row_sep * 0, 0, 1.0, 1.0 ] // Row 1
    , [ c4x,   c4y + row_sep * 1, 0, 1.0, 1.0 ] // Row 2
    , [ c4x,   c4y + row_sep * 2, 0, 1.0, 1.0 ] // Row 3
    , [ c4x,   c4y + row_sep * 3, 0, 1.0, 1.0 ] // Row 4
    , [ c4x,   c4y + row_sep * 4, 0, 1.0, 1.0 ] // Row 5

    // Column 5:
    , [ c5x,   c5y + row_sep * 0, 0, 1.0, 1.0 ] // Row 1
    , [ c5x,   c5y + row_sep * 1, 0, 1.0, 1.0 ] // Row 2
    , [ c5x,   c5y + row_sep * 2, 0, 1.0, 1.0 ] // Row 3
    , [ c5x,   c5y + row_sep * 3, 0, 1.0, 1.0 ] // Row 4

    // Column 6:
    , [ c6x,   c6y + row_sep * 0, 0, 1.0, 1.0 ] // Row 1
    , [ c6x,   c6y + row_sep * 1, 0, 1.0, 1.0 ] // Row 2
    , [ c6x,   c6y + row_sep * 2, 0, 1.0, 1.0 ] // Row 3
    , [ c6x,   c6y + row_sep * 3, 0, 1.0, 1.0 ] // Row 4

    // Column 7:
    , [ c7x,   -24.9220, 0,  1.0, 1.0 ] // Row 1.5
    , [ c7x,   -49.0520, 90, 1.5, 1.0 ] // Row 2.5

    // Thumb Keys:
    , [  97.0280,   -92.8670, -15,  1.25, 1.0 ]
    , [ 132.5880,   -78.8970, -30,  1.0,  1.0 ]
    , [ 149.0980,   -88.3920, -30,  1.0,  1.0 ]
    , [ 120.5230,   -99.8520, -120, 1.5,  1.0 ]
    , [ 137.03301, -109.3470, -120, 1.5,  1.0 ]
  ];

pcb_leg_positions =
  [ [   2.7220,  -27.3546 ]
  , [   2.8070,  -65.5913 ]
  , [  22.6819,  -46.4306 ]
  , [  42.9018,  -27.5592 ]
  , [  43.4402,  -61.0724 ]
  , [  62.0000,  -3.0300  ]
  , [  62.5043,  -39.8026 ]
  , [  62.2639,  -78.4369 ]
  , [  81.1491,  -51.5879 ]
  , [ 100.0563,  -81.6159 ]
  , [ 100.0000,  -23.0300 ]
  , [ 100.0000,  -61.6264 ]
  , [ 104.3878, -103.7437 ]
  , [ 119.0000,  -25.0300 ]
  , [ 119.0000,  -63.1460 ]
  , [ 136.0000,  -37.0000 ]
  ];


// Should be large enough to accommodate an M3 insert.
m3_insert_dia = 4;
m3_insert_depth = 4.5;

dim_shell_rot = -10;
dim_shell_offset_x = 4; // How far the shell goes to the left of the PCB.
dim_shell_offset_y = 7.2; // How far the shell goes above the PCB.
dim_shell_offset_y2 = 7.94; // Offset from the shell to the PCB on the right side.
dim_shell_x1 = 152.77; // Total width of the back of the shell.
dim_shell_max_x = 176.60; // The widest possible value for X.
dim_shell_max_y = 137.67; // The tallest possible value for Y.
dim_mount_len = 72;
dim_mount_offset_y = 15;
dim_mount_depth = 12;


dim_trrs_x = 130; // From left edge of PCB to center of TRRS jack
dim_trrs_z = 5; // From top of PCB to center of jack
dim_trrs_y = 6.25; // From pcb to shell;

dim_usb_x = 71.25; // From left edge of the PCB to center of the USB port
dim_usb_z = 3.5;  // From top of PCB to center of USB port.
/* dim_usb_z = 2.9;  // From top of PCB to center of USB port. */
dim_usb_y = 3.58; // From PCB to shell.
dim_usb_overhang = 3; // USB port positive overhang off the PCB on Y axis.

dim_microcontroller_x = 18.6; // How wide is the Pro Micro/Elite-C?
