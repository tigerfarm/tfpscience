// Compound of Three Octahedra (Escher's Solid)
//
// --- PARAMETERS ---
edge_length = 50;   // Edge length of each individual octahedron [cite: 4]
diameter = 2.5;     // Rod thickness [cite: 4]
radius = diameter / 2;

rod_sides = 4;      // Square cross-section rods as requested [cite: 4, 6]
vertexDiameter = 1.2; 
vertexShape = 32;   // Smoothness for vertex spheres [cite: 4, 12]

// ---------------------------------------------------------------------
// Helper: draw a prismatic rod between two 3D points 
module rod(p1, p2, r = radius) {
    v = p2 - p1;
    h = norm(v);
    if (h > 0) {
        a = acos(v.z / h);
        rot_axis = cross([0, 0, 1], v);
        translate(p1)
            rotate(a, rot_axis)
                // Using $fn = rod_sides to create prismatic rods 
                cylinder(h = h, r = r, center = false, $fn = rod_sides); 
    }
}

// ---------------------------------------------------------------------
// Component: A single octahedron frame
module octahedron_frame(col) {
    s = edge_length / sqrt(2); // Distance from center to vertex
    
    verts = [
        [ s,  0,  0], [-s,  0,  0], 
        [ 0,  s,  0], [ 0, -s,  0], 
        [ 0,  0,  s], [ 0,  0, -s]
    ];

    edges = [
        [0, 2], [0, 3], [0, 4], [0, 5],
        [1, 2], [1, 3], [1, 4], [1, 5],
        [2, 4], [2, 5], [3, 4], [3, 5]
    ];

    color(col) {
        for (e = edges) {
            rod(verts[e[0]], verts[e[1]], radius);
        }
        for (v = verts) {
            translate(v) sphere(r = vertexDiameter, $fn = vertexShape); // [cite: 12]
        }
    }
}

// ---------------------------------------------------------------------
// Main: Compound of Three Octahedra (Escher's Solid)
module escher_solid() {
    // Octahedron 1: Default orientation
    octahedron_frame("Gold");

    // Octahedron 2: Rotated 45 degrees around X
    rotate([45, 0, 0]) 
        octahedron_frame("Crimson");

    // Octahedron 3: Rotated 45 degrees around Y
    rotate([0, 45, 0]) 
        octahedron_frame("RoyalBlue");
}

// Render the compound
escher_solid();