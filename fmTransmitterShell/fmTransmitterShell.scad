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

// Button adjustment constants
buttonHeightAdjustment = 0.45;
symbolCutDepth = 0.6;

// Support beam constants
supportBeamWidth = 2;
supportBeamLength = 8;
supportBeamOffset = 1;
supportBeamSpacing = 2;

// Button geometry constants
buttonCylinderDiameter = 6;
buttonClearanceExtended = 6 + 2 * buttonClearance;

// Pillar specific dimensions
pillar1Width = 6;
pillar4Width = 9;
pillar4Height = 5;
pillar5Width = 6;
pillar5Length = 15;
pillar5Height = 1;

// Wall cut dimensions
wallCutWidth = 2.5;
wallCutHeight = 3.5;
wallCutOffset = 1.25;

// Symbol cut dimensions
symbolBarWidth = 0.5;
symbolBarLength = 3;
symbolHalfLength = 1.5;
symbolBarSpacing = 1;

// Miscellaneous dimensions
cubeThickness = 1;
cutExtraHeight = 2;
pillarOffsetExtra = 12;
wallHeightReductionExtra = 1;

module circuitBoard() {
  color("green", 0.7)
    cube([pcbWidth, pcbLength, pcbHeight]);
}

module peripheralsBox() {
  color("red", 0.7)
    cube([peripheralsWidth, peripheralsLength, peripheralsHeight]);
}

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
    translate([0, 0, 1 + buttonStemHeight - symbolCutDepth]) {
      // Horizontal bar
      translate([-symbolHalfLength, -symbolBarWidth / 2, 0])
        cube([symbolBarLength, symbolBarWidth, cubeThickness]);
      // Vertical bar
      translate([-symbolBarWidth / 2, -symbolHalfLength, 0])
        cube([symbolBarWidth, symbolBarLength, cubeThickness]);
    }
  }
}

module buttonWithMinus() {
  difference() {
    buttonBase();
    // Cut - symbol on top (rotated 90 degrees)
    translate([0, 0, 1 + buttonStemHeight - symbolCutDepth]) {
      // Vertical bar
      translate([-symbolBarWidth / 2, -symbolHalfLength, 0])
        cube([symbolBarWidth, symbolBarLength, cubeThickness]);
    }
  }
}

module buttonWithPause() {
  difference() {
    buttonBase();
    // Cut pause symbol on top (two horizontal bars)
    translate([0, 0, 1 + buttonStemHeight - symbolCutDepth]) {
      // Top bar
      translate([-symbolHalfLength, -symbolBarSpacing, 0])
        cube([symbolBarLength, symbolBarWidth, cubeThickness]);
      // Bottom bar
      translate([-symbolHalfLength, symbolBarWidth, 0])
        cube([symbolBarLength, symbolBarWidth, cubeThickness]);
    }
  }
}

module buttonBase() {
  // Base cube
  translate([-buttonBaseDiameter / 2 - cubeThickness, -buttonBaseDiameter / 2 - cubeThickness, 0])
    cube([buttonBaseDiameter + cubeThickness, buttonBaseDiameter + cutExtraHeight, cubeThickness]);
  // Top cylinder
  translate([0, 0, cubeThickness]) {
    cylinder(h=buttonStemHeight, d=buttonCylinderDiameter);
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
        translate([pcbWidth - pillar1Width, pillarOffsetFromEdge - pillarDiameter / 2, 0])
          cube([pillar1Width, pillarDiameter, pillarHeightStandard]);

        // Pillar 2 - back left corner  
        translate([pillarOffsetFromEdge - pillarDiameter / 2, pcbLength - pillarOffsetFromEdge - pillarDiameter / 2, 0])
          cube([pillarDiameter, pillarDiameter, pillarHeightStandard]);

        // Pillar 3 - back right corner
        translate([pcbWidth - pillarOffsetFromEdge - pillarDiameter / 2, pcbLength - pillarOffsetFromEdge - pillarDiameter / 2, 0])
          cube([pillarDiameter, pillarDiameter, pillarHeightStandard]);

        // Pillar 4 - front left corner (shorter)
        translate([0, pillarOffsetFromEdge - pillarDiameter / 2, 0])
          cube([pillar4Width, pillar4Height, pillarHeightShort]);

        // Pillar 5 - front right side, adjacent to pillar 1
        translate([pcbWidth - pillarOffsetExtra, pillarOffsetFromEdge - pillarDiameter / 2, 0])
          cube([pillar5Width, pillar5Length, pillar5Height]);
      }
    }

    // Text cutout
    // translate([(pcbWidth + 2 * boxClearanceXY) / 2 - boxClearanceXY - 1, (pcbLength + 2 * boxClearanceXY) / 2 - boxClearanceXY, bottomLayerOffset - 1])
    //   rotate([0, 0, 90])
    //     mirror([1, 0, 0])
    //       linear_extrude(height=textDepth) {
    //         text("RADIO", size=textSize, halign="center", valign="bottom", font="DejaVu Sans Mono:style=Bold");
    //         translate([0, -4, 0])
    //           text("FM", size=textSize, halign="center", valign="top", font="DejaVu Sans Mono:style=Bold");
    //       }
  }
}

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
        translate([screenOffsetX + screenWidth - supportBeamOffset, boxClearanceXY - supportBeamSpacing, -pillarDiameter])
          cube([supportBeamWidth, supportBeamLength + cubeThickness, pillarDiameter]);
        // Back cube  
        translate([screenOffsetX + screenWidth - supportBeamOffset, pcbLength + 2 * boxClearanceXY - supportBeamLength - supportBeamSpacing - supportBeamSpacing - cubeThickness, -pillarDiameter])
          cube([supportBeamWidth, supportBeamLength + cubeThickness, pillarDiameter]);
      }
    }

    // Cut opening for screen
    translate([screenOffsetX, screenOffsetY, -cubeThickness])
      cube([screenWidth, screenLength, layerThicknessBottom + cutExtraHeight]);

    // Cut outs for button disks with clearance
    for (i = [0:numberOfButtons - 1]) {
      translate([buttonsOffsetX + buttonMountingOffset, buttonStartY + i * buttonSpacing, -cubeThickness])
        cylinder(h=4, d=buttonClearanceExtended);
    }
  }
}

module walls() {
  totalHeight = componentLayerHeight + pcbHeight + screenClearanceHeight + buttonsBlockClearanceHeight + additionalClearanceHeight - wallHeightReduction - wallHeightReductionExtra;

  difference() {
    // Outer shell
    cube([pcbWidth + 2 * wallThickness, pcbLength + 2 * wallThickness, totalHeight]);

    // Inner cavity (PCB size)
    translate([wallThickness, wallThickness, -cubeThickness])
      cube([pcbWidth, pcbLength, totalHeight + cutExtraHeight]);

    // Cut for peripherals box in -y facing wall
    translate([wallThickness, -cubeThickness, wallThickness - cutExtraHeight])
      cube([peripheralsWidth, wallThickness + cutExtraHeight, peripheralsHeight + cubeThickness]);

    // Cut in +y facing wall (middle bottom)
    translate([(pcbWidth + 2 * wallThickness) / 2 - wallCutOffset, pcbLength + wallThickness - cubeThickness, wallThickness - cutExtraHeight])
      cube([wallCutWidth, wallThickness + cutExtraHeight, wallCutHeight]);
  }
}

module circuit() {
  translate([0, 0, componentLayerHeight])
    circuitBoard();

  translate([0, 0, componentLayerHeight - peripheralsHeight])
    peripheralsBox();

  translate([screenOffsetX, screenOffsetY, componentLayerHeight + pcbHeight])
    screen();

  translate([buttonsOffsetX, buttonsOffsetY, componentLayerHeight + pcbHeight])
    buttonsBlock();
}

module fullAssembly() {

  circuit();

  translate([0, 0, componentLayerHeight - peripheralsHeight])
    bottom();

  color("#333333", 0.9)
    translate([-boxClearanceXY, -boxClearanceXY, componentLayerHeight - peripheralsHeight - wallThickness + 1])
      walls();

  color("#333333", 0.9)
    translate([0, 0, componentLayerHeight + pcbHeight + screenHeight])
      top();

  translate([0, 0, componentLayerHeight + pcbHeight + buttonBaseHeight - buttonHeightAdjustment - 0.05])
    buttons();
}

// ===============================================
// UNCOMMENT THE PART YOU WANT TO PRINT/VIEW
// ===============================================

// bottom();
// mirror([0, 0, 1]) top();
// mirror([0, 0, 1]) walls();
// buttonWithMinus();
// buttonWithPlus();
// buttonWithPause();

fullAssembly();
