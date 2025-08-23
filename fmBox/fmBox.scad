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
buttonsBlockHeight = 3;

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
layerThicknessBottom = 2;
layerThicknessTop = 1;
bottomLayerOffset = -3;
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
  color("green", 0.8)
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

module button() {
  color("red", 0.7) {
    // Base disk
    cylinder(h=buttonBaseHeight, d=buttonBaseDiameter);
    // Top cylinder with rounded top
    translate([0, 0, buttonBaseHeight]) {
      cylinder(h=buttonStemHeight, d=buttonStemDiameter);
      translate([0, 0, buttonStemHeight])
        sphere(d=buttonTopDiameter);
    }
  }
}

module buttons() {
  for (i = [0:numberOfButtons-1]) {
    translate([buttonsOffsetX + buttonMountingOffset, buttonStartY + i * buttonSpacing, buttonMountingZOffset])
      button();
  }
}

module bottom() {
  difference() {
    union() {
      // Bottom layer (2mm bigger each side)
      translate([-boxClearanceXY, -boxClearanceXY, bottomLayerOffset])
        color("lightgray", 0.6)
          cube([pcbWidth + 2 * boxClearanceXY, pcbLength + 2 * boxClearanceXY, layerThicknessBottom]);

      // Top layer (PCB size)
      translate([0, 0, topLayerOffset])
        color("darkgray", 0.6)
          cube([pcbWidth, pcbLength, layerThicknessTop]);

      // Cylindrical pillars (3 on edges of top layer)
      color("yellow", 0.8) {
        // Pillar 1 - front right corner
        translate([pcbWidth - pillarOffsetFromEdge, pillarOffsetFromEdge, 0])
          cylinder(h=pillarHeightStandard, d=pillarDiameter);

        // Pillar 2 - back left corner  
        translate([pillarOffsetFromEdge, pcbLength - pillarOffsetFromEdge, 0])
          cylinder(h=pillarHeightStandard, d=pillarDiameter);

        // Pillar 3 - back right corner
        translate([pcbWidth - pillarOffsetFromEdge, pcbLength - pillarOffsetFromEdge, 0])
          cylinder(h=pillarHeightStandard, d=pillarDiameter);

        // Pillar 4 - front left corner (shorter)
        translate([2 * pillarOffsetFromEdge, pillarOffsetFromEdge, 0])
          cylinder(h=pillarHeightShort, d=pillarDiameter);
      }
    }

    // Text cutout "FANTAS" and "FM" on bottom layer (centered in bottom layer)
    translate([(pcbWidth + 2 * boxClearanceXY) / 2 - boxClearanceXY - 1, (pcbLength + 2 * boxClearanceXY) / 2 - boxClearanceXY, bottomLayerOffset])
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
      // Bottom layer (PCB size, reduced for button clearance)
      color("darkgray", 0.6)
        cube([pcbWidth - topLayerButtonClearance, pcbLength, layerThicknessTop]);

      // Top layer (2mm bigger each side)
      translate([-boxClearanceXY, -boxClearanceXY, layerThicknessTop])
        color("lightgray", 0.6)
          cube([pcbWidth + 2 * boxClearanceXY, pcbLength + 2 * boxClearanceXY, layerThicknessBottom]);

      // Cylindrical pillars (2 on left side)
      color("yellow", 0.8) {
        // Pillar 1 - front left corner
        translate([pillarOffsetFromEdge, pillarOffsetFromEdge, -pillarDiameter])
          cylinder(h=pillarDiameter, d=pillarDiameter);

        // Pillar 2 - back left corner  
        translate([pillarOffsetFromEdge, pcbLength - pillarOffsetFromEdge, -pillarDiameter])
          cylinder(h=pillarDiameter, d=pillarDiameter);
      }
    }

    // Cut opening for screen - tapered
    translate([screenOffsetX + screenWidth / 2, screenOffsetY + screenLength / 2, -1])
      hull() {
        // Bottom opening (screen size)
        translate([-screenWidth / 2, -screenLength / 2, 1])
          cube([screenWidth, screenLength, 0.1]);

        // Top opening (wider) - extends to top layer
        translate([-(screenWidth + 2 * boxClearanceXY) / 2, -(screenLength + 2 * boxClearanceXY) / 2, 4])
          cube([screenWidth + 2 * boxClearanceXY, screenLength + 2 * boxClearanceXY, 0.1]);
      }

    // Cut outs for button disks with clearance
    for (i = [0:numberOfButtons-1]) {
      translate([buttonsOffsetX + buttonMountingOffset, buttonStartY + i * buttonSpacing, -1])
        cylinder(h=4, d=buttonStemDiameter + 2 * buttonClearance);
    }
  }
}

// Walls
module walls() {
  total_height = componentLayerHeight + pcbHeight + screenClearanceHeight + buttonsBlockClearanceHeight + additionalClearanceHeight - wallHeightReduction;

  color("brown", 0.7) {
    difference() {
      // Outer shell
      cube([pcbWidth + 2 * wallThickness, pcbLength + 2 * wallThickness, total_height]);

      // Inner cavity (PCB size)
      translate([wallThickness, wallThickness, -1])
        cube([pcbWidth, pcbLength, total_height + 2]);
    }
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
  translate([0, 0, componentLayerHeight - peripheralsHeight])
    bottom();

  circuit();

  translate([0, 0, componentLayerHeight + pcbHeight + screenHeight])
    top();

  translate([-boxClearanceXY, -boxClearanceXY, componentLayerHeight - peripheralsHeight - wallThickness + 1])
    walls();

  translate([0, 0, componentLayerHeight + pcbHeight + buttonBaseHeight])
    buttons();
}

// ===============================================
// UNCOMMENT THE PART YOU WANT TO PRINT/VIEW
// ===============================================

// Print individual parts:
// bottom();
// top();
// walls();
// button();

// View circuit only:
//circuit();

// View complete assembly:
full_assembly();
