$fn = 100;

// magnet
magnetDiameter = 20;
magnetHeight = 3;

// brace
braceWidth = 3;
bottomBraceSlotHeight = 1;
topBraceSlotHeight = 2;

// wire
wireDiameter = 1.5;

//clip
clipPerimeter = 3;

// other
margin = 0.2;

braceSlotLength = magnetDiameter + clipPerimeter + 2;
clipHeight = bottomBraceSlotHeight + magnetHeight + topBraceSlotHeight;

module magnet() {
  translate([0, 0, bottomBraceSlotHeight]) cylinder(h=magnetHeight + margin, d=magnetDiameter + margin);
}

module bottomBraceSlot() {
  translate([-braceWidth / 2, -braceSlotLength / 2, 0]) cube(center=false, size=[braceWidth, braceSlotLength, bottomBraceSlotHeight]);
}

module topBraceSlot() {
  translate([-braceWidth / 2, -braceSlotLength / 2, magnetHeight + bottomBraceSlotHeight]) cube(center=false, size=[braceWidth, braceSlotLength, topBraceSlotHeight]);
}

module wireSlot() {
  translate([0, 0, magnetHeight + bottomBraceSlotHeight + 2]) rotate([90, 0, 90]) cylinder(center=true, h=braceSlotLength, d=wireDiameter + margin);
}

difference() {
  cylinder(h=clipHeight, d=clipPerimeter + magnetDiameter);
  magnet();
  bottomBraceSlot();
  topBraceSlot();
  wireSlot();
}
