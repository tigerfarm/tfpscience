// --- PARAMETERS ---
cube_side = 50;     
diameter = 4;     
radius = diameter / 2;

rod_sides = 4;      // Prismatic square rods
vertexDiameter = 2; 
vertexShape = 64;   

// ---------------------------------------------------------------------
// Helper: Prismatic Rod
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
// Component: Cube Frame anchored at one vertex (0,0,0)
module anchored_cube_frame(s) {
    // Vertices defined from 0 to s (not centered)
    // Vertex [0,0,0] is the shared anchor
    v = [
        [0, 0, 0], [s, 0, 0], [s, s, 0], [0, s, 0],
        [0, 0, s], [s, 0, s], [s, s, s], [0, s, s]
    ];

    edges = [
        [0,1], [1,2], [2,3], [3,0], // Bottom
        [4,5], [5,6], [6,7], [7,4], // Top
        [0,4], [1,5], [2,6], [3,7]  // Verticals
    ];

    for (e = edges) rod(v[e[0]], v[e[1]]);

    for (pt = v) {
        // Highlight the shared vertex at origin in a different color
        if (norm(pt) < 0.1) {
            color("Red") translate(pt) sphere(r = vertexDiameter, $fn = vertexShape);
        } else {
            translate(pt) sphere(r = vertexDiameter, $fn = vertexShape);
        }
    }
}

// ---------------------------------------------------------------------
// Main: Compound Construction
module shared_vertex_compound() {
    // Cube 1: Static
    color("Cyan") 
        anchored_cube_frame(cube_side);

    // Cube 2: Rotated around the shared vertex (0,0,0)
    // Rotating around the diagonal axis [1,1,1] creates a balanced look
    color("Magenta") 
        rotate(a = 45, v = [1, 1, 1]) 
            anchored_cube_frame(cube_side);
}

// Render
shared_vertex_compound();