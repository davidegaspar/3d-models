$fn = 100;

use <polyround.scad>

module door() {
  linear_extrude(height = 1) union() {
    translate([ 0, -10, 0 ]) square([ 20, 25 ], center = false);
    translate([ -10, -10, 0 ]) square([ 10, 10 ], center = false);
  }
}

module hook1() {
  translate([ -5, 0, 0 ]) square([ 5, 20 ], center = false);
  translate([ 0, 15, 0 ]) square([ 25, 5 ], center = false);
  translate([ 20, -20, 0 ]) square([ 5, 40 ], center = false);
}

module hook2(width = 20, margin = .1) {
  points = [
    [ 0 - margin, 0, 1 ], [ 0 - margin, 15 + margin, 0 ],
    [ 20 + margin, 15 + margin, 0 ], [ 20 + margin, -30, 10 ], [ 30, -40, 10 ],
    [ 40, -30, 10 ], [ 40, -20, 5 ]
  ];
  // polygon(polyRound(points, 10));

  linear_extrude(height = width)
      polygon(polyRound(beamChain(points, offset1 = -5, offset2 = 0), 20));
}

#color("yellow") door();
// color("orange") hook1();
color("orange") hook2();