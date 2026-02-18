// Octahedron Frame
//
// --- PARAMETERS ---
// Based on parameters from source [cite: 4, 5]
edge_length = 50;   
diameter = 3;       
radius = diameter / 2;

rod_sides = 4;      // 4 for square cross-section rods [cite: 4, 6]
vertexDiameter = 2.2; // Vertex diameter [cite: 4]
vertexShape = 64;   

// ---------------------------------------------------------------------
// Helper: draw a prismatic rod between two 3D points
// Logic adapted from source [cite: 6]
module rod(p1, p2, r = radius) {
    v = p2 - p1;
    h = norm(v);
    if (h > 0) {
        a = acos(v.z / h);
        rot_axis = cross([0, 0, 1], v);

        translate(p1)
            rotate(a, rot_axis)
                // The key is using $fn = rod_sides to make the cylinder a prism [cite: 6]
                cylinder(h = h, r = r, center = false, $fn = rod_sides); 
    }
}

// ---------------------------------------------------------------------
// Main: Octahedron Frame
module octahedron_frame() {
    // Vertices for a regular octahedron centered at the origin
    // Vertex coordinates are (+/- s, 0, 0), (0, +/- s, 0), (0, 0, +/- s)
    s = edge_length / sqrt(2); 
    
    verts = [
        [ s,  0,  0], // 0
        [-s,  0,  0], // 1
        [ 0,  s,  0], // 2
        [ 0, -s,  0], // 3
        [ 0,  0,  s], // 4
        [ 0,  0, -s]  // 5
    ];

    // Define the 12 edges (pairs of vertex indices)
    edges = [
        [0, 2], [0, 3], [0, 4], [0, 5],
        [1, 2], [1, 3], [1, 4], [1, 5],
        [2, 4], [2, 5], [3, 4], [3, 5]
    ];

    // Draw Rods (Edges)
    for (e = edges) {
        rod(verts[e[0]], verts[e[1]], radius);
    }

    // Draw Spheres at vertices 
    for (v = verts) {
        color("DeepSkyBlue") 
            translate(v) 
                sphere(r = vertexDiameter, $fn = vertexShape);
    }
}

// Render the Octahedron
octahedron_frame();