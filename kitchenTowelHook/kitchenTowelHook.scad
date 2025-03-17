$fn = 100;

use <./lib/polyround.scad>

module door(width = 40, height = 15, depth = 20) {
  linear_extrude(height = width) union() {
    translate([ 0, -10, 0 ]) square([ depth, 25 ], center = false);
    translate([ depth - 30, -10, 0 ])
        square([ depth - 10, 10 ], center = false);
  }
}

module hook(width = 20, depth = 20, margin = .1, loopRoundness = 10) {
  points = [
    [ 0 - margin, 0, 1 ], [ 0 - margin, 15 + margin, 0 ],
    [ depth + margin, 15 + margin, 0 ], [ depth + margin, -30, loopRoundness ],
    [ depth + 15, -40, loopRoundness ], [ depth + 30, -30, loopRoundness ],
    [ depth + 30, -20, 5 ]
  ];

  extrudeWithRadius(width, 2, 2, 20)
      polygon(polyRound(beamChain(points, offset1 = 5, offset2 = 0), 20));
}

// debug
// #color("yellow") door(depth = 20);

// main
color("orange") hook();