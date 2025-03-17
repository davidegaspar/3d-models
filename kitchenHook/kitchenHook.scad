$fn = 100;

use <polyround.scad>

module door() {
  linear_extrude(height = 1) union() {
    translate([ 0, -10, 0 ]) square([ 20, 25 ], center = false);
    translate([ -10, -10, 0 ]) square([ 10, 10 ], center = false);
  }
}

module hook(width = 20, margin = .1) {
  loopRound = 10;
  points = [
    [ 0 - margin, 0, 1 ], [ 0 - margin, 15 + margin, 0 ],
    [ 20 + margin, 15 + margin, 0 ], [ 20 + margin, -30, loopRound ],
    [ 35, -40, loopRound ], [ 50, -30, loopRound ], [ 50, -20, 5 ]
  ];

  extrudeWithRadius(width, 2, 2, 20)
      polygon(polyRound(beamChain(points, offset1 = 5, offset2 = 0), 20));
}

// #color("yellow") door();
color("orange") hook();