// --- PARAMETERS ---
side_length = 50;       // Length of each side of the pentagon
thickness = 4;          // Thickness of the solid face
diameter = 4;           // Rod thickness (matches your style)
radius = diameter / 2;

rod_sides = 4;      // Square cross-section rods
vertexDiameter = 2.2; 
vertexShape = 64;   

// ---------------------------------------------------------------------
// ROBUST Helper: draw a prismatic rod
// This module handles vertical and horizontal orientations
module rod(p1, p2, r = radius) {
    v = p2 - p1;
    h = norm(v);
    if (h > 0) {
        if (abs(v.x) < 0.001 && abs(v.y) < 0.001) {
            translate(p1) rotate([v.z < 0 ? 180 : 0, 0, 0])
                cylinder(h = h, r = r, center = false, $fn = rod_sides);
        } else {
            a = acos(v.z / h);
            rot_axis = cross([0, 0, 1], v);
            translate(p1) rotate(a, rot_axis)
                cylinder(h = h, r = r, center = false, $fn = rod_sides); 
        }
    }
}

// ---------------------------------------------------------------------
// Main Module: Pentagon Frame
module pentagon_frame() {
    // Calculate circumradius so the sides are exactly 'side_length'
    r_circum = side_length / (2 * sin(180 / 5));
    
    // Generate the 5 vertex coordinates
    verts = [
        for (i = [0 : 4]) 
            [r_circum * cos(90 + i * 72), r_circum * sin(90 + i * 72), 0]
    ];

    // Draw the 5 edges (Rods)
    color("yellow") {
        for (i = [0 : 4]) {
            // Connect vertex i to the next vertex (loop back at the end)
            rod(verts[i], verts[(i + 1) % 5]);
        }
    }

    // Draw the 5 vertices (Spheres)
    color("FireBrick") {
        for (v = verts) {
            translate(v) 
                sphere(r = vertexDiameter, $fn = vertexShape);
        }
    }
}

// Render the frame
pentagon_frame();