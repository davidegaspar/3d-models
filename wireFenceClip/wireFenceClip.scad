$fn = 100;

magnetDiameter = 20;
magnetHeight = 3;

clipDiameter = magnetDiameter + 3;

braceWidth = 3;
braceHeight = 1;

braceSlotHeight = 3;

margin = 0.2;

braceSlotLength = clipDiameter + 3;
clipHeight = braceHeight + magnetHeight + braceSlotHeight;

difference() {
  cylinder(h=clipHeight, d=clipDiameter);
  translate([0, 0, braceHeight]) cylinder(h=magnetHeight + margin, d=magnetDiameter + margin);
  translate([0, 0, (braceSlotHeight / 2) - 2]) cube(center=true, size=[braceWidth, braceSlotLength, braceSlotHeight]);
  translate([0, 0, -(braceSlotHeight / 2) + clipHeight + 1]) cube(center=true, size=[braceWidth, braceSlotLength, braceSlotHeight]);
}
