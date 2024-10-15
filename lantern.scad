// Vase parameters
height = 50;
width = 75;
wall_thickness = 0.4;
base_height = 3;
corner_radius = 5;
bottom_diameter = 50;

// Main vase body
difference() {
  // Outer shape
  linear_extrude(height = height) offset(r = corner_radius)
      square([ width, width ], center = true);

  // Inner cutout
  translate([ 0, 0, base_height ]) linear_extrude(height = height)
      offset(r = corner_radius - wall_thickness)
          square([ width - 2 * wall_thickness, width - 2 * wall_thickness ],
                 center = true);

  translate([ 0, 0, -base_height ]) linear_extrude(height = height)
      circle(d = bottom_diameter);
}