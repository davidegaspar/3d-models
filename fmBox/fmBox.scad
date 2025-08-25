$fn = 100;

// Circuit board dimensions
pcbWidth = 27;
pcbLength = 49;
pcbHeight = 1;

// Component dimensions
componentLayerHeight = 2; // Height for components underneath PCB
peripheralsWidth = 21;
peripheralsLength = 14;
peripheralsHeight = 6;
screenWidth = 14;
screenLength = 24;
screenHeight = 4;
buttonsBlockWidth = 4;
buttonsBlockLength = 45;
buttonsBlockHeight = 2.5;

// Positioning constants
screenOffsetX = 4.5;
screenOffsetY = 12.5;
buttonsOffsetX = pcbWidth - 5; // pcbWidth - 1 - 4
buttonsOffsetY = 2;

// Button physical interface constants
buttonBaseDiameter = 6;
buttonBaseHeight = 2;
buttonStemDiameter = 4;
buttonStemHeight = 3;
buttonTopDiameter = 4;
buttonSpacing = 9.75;
buttonStartY = 5; // 2 + 3 offset
buttonClearance = 0.1;

// Additional positioning constants
buttonMountingOffset = 2;
buttonMountingZOffset = 1;
topLayerButtonClearance = 6.5;
numberOfButtons = 5;

// Wall height calculation constants
screenClearanceHeight = 4;
buttonsBlockClearanceHeight = 4;
additionalClearanceHeight = 4;
wallHeightReduction = 2;

// Box construction constants
wallThickness = 2;
layerThicknessBottom = 1;
layerThicknessTop = 1;
bottomLayerOffset = -2;
topLayerOffset = -1;
boxClearanceXY = 2; // 2mm bigger each side
textDepth = 2;
textSize = 9;

// Pillar constants
pillarDiameter = 4;
pillarHeightStandard = 6;
pillarHeightShort = 3;
pillarOffsetFromEdge = 2;

// Circuit board model (for reference)
module circuit_board() {
  color("green", 0.7)
    cube([pcbWidth, pcbLength, pcbHeight]);
}

// Peripherals box (for reference)
module peripherals_box() {
  color("red", 0.7)
    cube([peripheralsWidth, peripheralsLength, peripheralsHeight]);
}

// Screen (for reference)
module screen() {
  color("orange", 0.8)
    cube([screenWidth, screenLength, screenHeight]);
}

module buttonsBlock() {
  color("gray", 0.9)
    cube([buttonsBlockWidth, buttonsBlockLength, buttonsBlockHeight]);
}

module buttonWithPlus() {
  difference() {
    buttonBase();
    // Cut + symbol on top
    translate([0, 0, 1 + buttonStemHeight - 0.6]) {
      // Horizontal bar
      translate([-1.5, -0.25, 0])
        cube([3, 0.5, 1]);
      // Vertical bar
      translate([-0.25, -1.5, 0])
        cube([0.5, 3, 1]);
    }
  }
}

module buttonWithMinus() {
  difference() {
    buttonBase();
    // Cut - symbol on top (rotated 90 degrees)
    translate([0, 0, 1 + buttonStemHeight - 0.6]) {
      // Vertical bar
      translate([-0.25, -1.5, 0])
        cube([0.5, 3, 1]);
    }
  }
}

module buttonWithPause() {
  difference() {
    buttonBase();
    // Cut pause symbol on top (two horizontal bars)
    translate([0, 0, 1 + buttonStemHeight - 0.6]) {
      // Top bar
      translate([-1.5, -1, 0])
        cube([3, 0.5, 1]);
      // Bottom bar
      translate([-1.5, 0.5, 0])
        cube([3, 0.5, 1]);
    }
  }
}

module buttonBase() {
  // Base cube
  translate([-buttonBaseDiameter / 2 - 1, -buttonBaseDiameter / 2 - 1, 0])
    cube([buttonBaseDiameter + 1, buttonBaseDiameter + 2, 1]);
  // Top cylinder
  translate([0, 0, 1]) {
    cylinder(h=buttonStemHeight, d=6);
  }
}

module buttons() {
  for (i = [0:numberOfButtons - 1]) {
    translate([buttonsOffsetX + buttonMountingOffset, buttonStartY + i * buttonSpacing, buttonMountingZOffset]) if (i == 0) {
      color("white") buttonWithMinus();
    } else if (i == 1) {
      color("white") buttonWithPlus();
    } else if (i == 2) {
      color("gray") buttonWithMinus();
    } else if (i == 3) {
      color("gray") buttonWithPlus();
    } else if (i == 4) {
      color("orange") buttonWithPause();
    }
  }
}

module bottom() {
  difference() {
    union() {
      // Bottom layer
      color("#333333", 0.9) translate([-boxClearanceXY, -boxClearanceXY, bottomLayerOffset])
          cube([pcbWidth + 2 * boxClearanceXY, pcbLength + 2 * boxClearanceXY, layerThicknessBottom]);

      // Top layer
      color("orange") translate([0, 0, topLayerOffset])
          cube([pcbWidth, pcbLength, layerThicknessTop]);

      // Cubic pillars (3 on edges of top layer)
      color("orange") {
        // Pillar 1 - front right corner
        translate([pcbWidth - 6, pillarOffsetFromEdge - pillarDiameter / 2, 0])
          cube([6, pillarDiameter, pillarHeightStandard]);

        // Pillar 2 - back left corner  
        translate([pillarOffsetFromEdge - pillarDiameter / 2, pcbLength - pillarOffsetFromEdge - pillarDiameter / 2, 0])
          cube([pillarDiameter, pillarDiameter, pillarHeightStandard]);

        // Pillar 3 - back right corner
        translate([pcbWidth - pillarOffsetFromEdge - pillarDiameter / 2, pcbLength - pillarOffsetFromEdge - pillarDiameter / 2, 0])
          cube([pillarDiameter, pillarDiameter, pillarHeightStandard]);

        // Pillar 4 - front left corner (shorter)
        translate([0, pillarOffsetFromEdge - pillarDiameter / 2, 0])
          cube([9, 5, pillarHeightShort]);

        // Pillar 5 - front right side, adjacent to pillar 1
        translate([pcbWidth - 12, pillarOffsetFromEdge - pillarDiameter / 2, 0])
          cube([6, 15, 1]);
      }
    }

    // Text cutout "FANTAS" and "FM" on bottom layer (centered in bottom layer)
    translate([(pcbWidth + 2 * boxClearanceXY) / 2 - boxClearanceXY - 1, (pcbLength + 2 * boxClearanceXY) / 2 - boxClearanceXY, bottomLayerOffset - 1])
      rotate([0, 0, 90])
        mirror([1, 0, 0])
          linear_extrude(height=textDepth) {
            text("FANTAS", size=textSize, halign="center", valign="bottom", font="DejaVu Sans Mono:style=Bold");
            translate([0, -4, 0])
              text("FM", size=textSize, halign="center", valign="top", font="DejaVu Sans Mono:style=Bold");
          }
  }
}

// Top with 2 layers (inverted)
module top() {
  difference() {
    union() {
      // Top layer (2mm bigger each side)
      translate([-boxClearanceXY, -boxClearanceXY, 0])
        cube([pcbWidth + 2 * boxClearanceXY, pcbLength + 2 * boxClearanceXY, layerThicknessBottom]);

      // Cubic pillars (2 on left side)
      color("yellow", 0.8) {
        // Pillar 1 - front left corner
        translate([pillarOffsetFromEdge - pillarDiameter / 2, pillarOffsetFromEdge - pillarDiameter / 2, -pillarDiameter])
          cube([pillarDiameter, pillarDiameter, pillarDiameter]);

        // Pillar 2 - back left corner  
        translate([pillarOffsetFromEdge - pillarDiameter / 2, pcbLength - pillarOffsetFromEdge - pillarDiameter / 2, -pillarDiameter])
          cube([pillarDiameter, pillarDiameter, pillarDiameter]);
      }

      // Two cubes by +x of screen (split at edges)
      color("yellow", 0.8) {
        // Front cube
        translate([screenOffsetX + screenWidth - 1, boxClearanceXY - 2, -pillarDiameter])
          cube([2, 9, pillarDiameter]);
        // Back cube  
        translate([screenOffsetX + screenWidth - 1, pcbLength + 2 * boxClearanceXY - 8 - 2 - 2 - 1, -pillarDiameter])
          cube([2, 9, pillarDiameter]);
      }
    }

    // Cut opening for screen
    translate([screenOffsetX, screenOffsetY, -1])
      cube([screenWidth, screenLength, layerThicknessBottom + 2]);

    // Cut outs for button disks with clearance
    for (i = [0:numberOfButtons - 1]) {
      translate([buttonsOffsetX + buttonMountingOffset, buttonStartY + i * buttonSpacing, -1])
        cylinder(h=4, d=6 + 2 * buttonClearance);
    }
  }
}

// Walls
module walls() {
  total_height = componentLayerHeight + pcbHeight + screenClearanceHeight + buttonsBlockClearanceHeight + additionalClearanceHeight - wallHeightReduction - 1;

  difference() {
    // Outer shell
    cube([pcbWidth + 2 * wallThickness, pcbLength + 2 * wallThickness, total_height]);

    // Inner cavity (PCB size)
    translate([wallThickness, wallThickness, -1])
      cube([pcbWidth, pcbLength, total_height + 2]);

    // Cut for peripherals box in -y facing wall
    translate([wallThickness, -1, wallThickness - 2])
      cube([peripheralsWidth, wallThickness + 2, peripheralsHeight + 1]);

    // Cut in +y facing wall (middle bottom)
    translate([(pcbWidth + 2 * wallThickness) / 2 - 1.25, pcbLength + wallThickness - 1, wallThickness - 2])
      cube([2.5, wallThickness + 2, 3.5]);
  }
}

// Circuit
module circuit() {
  translate([0, 0, componentLayerHeight])
    circuit_board();

  translate([0, 0, componentLayerHeight - peripheralsHeight])
    peripherals_box();

  translate([screenOffsetX, screenOffsetY, componentLayerHeight + pcbHeight])
    screen();

  translate([buttonsOffsetX, buttonsOffsetY, componentLayerHeight + pcbHeight])
    buttonsBlock();
}

module full_assembly() {

  circuit();

  translate([0, 0, componentLayerHeight - peripheralsHeight])
    bottom();

  // color("#333333", 0.9)
  //   translate([-boxClearanceXY, -boxClearanceXY, componentLayerHeight - peripheralsHeight - wallThickness + 1])
  //     walls();

  color("#333333", 0.9)
    translate([0, 0, componentLayerHeight + pcbHeight + screenHeight])
      top();

  translate([0, 0, componentLayerHeight + pcbHeight + buttonBaseHeight - 0.5])
    buttons();
}

// ===============================================
// UNCOMMENT THE PART YOU WANT TO PRINT/VIEW
// ===============================================

// Print individual parts:
// bottom();
// mirror([0, 0, 1]) top();
// mirror([0, 0, 1]) walls();

// Print individual buttons:
// buttonWithMinus();
// buttonWithPlus();
buttonWithPause();

// View circuit only:
//circuit();

// View complete assembly:
// full_assembly();
