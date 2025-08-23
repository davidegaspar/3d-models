$fn = 100;

// Circuit board dimensions
pcb_width = 27;
pcb_length = 49;
pcb_height = 1;

component_layer_height = 2; // Height for components underneath PCB

// Circuit board model (for reference)
module circuit_board() {
  color("green", 0.8)
    cube([pcb_width, pcb_length, pcb_height]);
}

// Peripherals box (for reference)
module peripherals_box() {
  color("red", 0.7)
    cube([21, 14, 6]);
}

// Screen (for reference)
module screen() {
  color("orange", 0.8)
    cube([14, 24, 4]);
}

// Buttons row (for reference)
module buttonComponents() {
  color("gray", 0.9)
    cube([4, 45, 3]);
}

// Single button
module single_button() {
  color("red", 0.7) {
    // Base disk
    cylinder(h=2, d=6);
    // Top cylinder with rounded top
    translate([0, 0, 2]) {
      cylinder(h=3, d=4);
      translate([0, 0, 3])
        sphere(d=4);
    }
  }
}

// 5 buttons above button block (independent)
module buttons() {
  for (i = [0:4]) {
    translate([pcb_width - 1 - 4 + 2, 2 + i * 9.75 + 3, 1])
      single_button();
  }
}

// Bottom with 2 layers
module bottom() {
  difference() {
    union() {
      // Bottom layer (2mm bigger each side)
      translate([-2, -2, -3])
        color("lightgray", 0.6)
          cube([pcb_width + 4, pcb_length + 4, 2]);

      // Top layer (PCB size)
      translate([0, 0, -1])
        color("darkgray", 0.6)
          cube([pcb_width, pcb_length, 1]);

      // Cylindrical pillars (3 on edges of top layer)
      color("yellow", 0.8) {
        // Pillar 1 - front right corner
        translate([pcb_width - 2, 2, 0])
          cylinder(h=6, d=4);

        // Pillar 2 - back left corner  
        translate([2, pcb_length - 2, 0])
          cylinder(h=6, d=4);

        // Pillar 3 - back right corner
        translate([pcb_width - 2, pcb_length - 2, 0])
          cylinder(h=6, d=4);

        // Pillar 4 - front left corner (shorter)
        translate([4, 2, 0])
          cylinder(h=3, d=4);
      }
    }

    // Text cutout "FANTAS" and "FM" on bottom layer (centered in bottom layer)
    translate([(pcb_width + 4) / 2 - 2 - 1, (pcb_length + 4) / 2 - 2, -3])
      rotate([0, 0, 90])
        mirror([1, 0, 0])
          linear_extrude(height=2) {
            text("FANTAS", size=9, halign="center", valign="bottom", font="DejaVu Sans Mono:style=Bold");
            translate([0, -4, 0])
              text("FM", size=9, halign="center", valign="top", font="DejaVu Sans Mono:style=Bold");
          }
  }
}

// Top with 2 layers (inverted)
module top() {
  difference() {
    union() {
      // Bottom layer (PCB size, reduced by 6mm in X and 0.5mm in Y)
      color("darkgray", 0.6)
        cube([pcb_width - 6.5, pcb_length, 1]);

      // Top layer (2mm bigger each side)
      translate([-2, -2, 1])
        color("lightgray", 0.6)
          cube([pcb_width + 4, pcb_length + 4, 2]);

      // Cylindrical pillars (2 on left side)
      color("yellow", 0.8) {
        // Pillar 1 - front left corner
        translate([2, 2, -4])
          cylinder(h=4, d=4);

        // Pillar 2 - back left corner  
        translate([2, pcb_length - 2, -4])
          cylinder(h=4, d=4);
      }
    }

    // Cut opening for screen (screen dimensions: 14x24, positioned at 4.5, 12.5) - tapered
    translate([4.5 + 14 / 2, 12.5 + 24 / 2, -1])
      hull() {
        // Bottom opening (screen size)
        translate([-14 / 2, -24 / 2, 1])
          cube([14, 24, 0.1]);

        // Top opening (wider) - extends to top layer
        translate([-(14 + 4) / 2, -(24 + 4) / 2, 4])
          cube([14 + 4, 24 + 4, 0.1]);
      }

    // Cut outs for button disks with 0.1mm margin
    for (i = [0:4]) {
      translate([pcb_width - 1 - 4 + 2, 2 + i * 9.75 + 3, -1])
        cylinder(h=4, d=4.2);
    }
  }
}

// Box walls
module boxWalls() {
  wall_thickness = 2;
  total_height = component_layer_height + pcb_height + 4 + 4 + 4 - 2; // Reduced by 2mm total (1mm up + 1mm down)

  color("brown", 0.7) {
    difference() {
      // Outer shell
      cube([pcb_width + 2 * wall_thickness, pcb_length + 2 * wall_thickness, total_height]);

      // Inner cavity (PCB size)
      translate([wall_thickness, wall_thickness, -1])
        cube([pcb_width, pcb_length, total_height + 2]);
    }
  }
}

// Complete circuit assembly
module circuit_assembly() {
  translate([0, 0, component_layer_height])
    circuit_board();

  translate([0, 0, component_layer_height - 6])
    peripherals_box();

  translate([4.5, 12.5, component_layer_height + pcb_height])
    screen();

  translate([pcb_width - 1 - 4, 2, component_layer_height + pcb_height])
    buttonComponents();
}

module full_assembly() {
  translate([0, 0, component_layer_height - 6])
    bottom();

  circuit_assembly();

  translate([0, 0, component_layer_height + pcb_height + 4])
    top();

  translate([-2, -2, component_layer_height - 6 - 2 + 1])
    boxWalls();

  translate([0, 0, component_layer_height + pcb_height + 2])
    buttons();
}

// ===============================================
// UNCOMMENT THE PART YOU WANT TO PRINT/VIEW
// ===============================================

// Print individual parts:
// bottom();
// boxTop();
// boxWalls();
// single_button();

// View circuit only:
//circuit_assembly();

// View complete assembly:
full_assembly();
