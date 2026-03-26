// Tetrahedron Frame
//  A Tetrahedron is a 3-Triangle, 3D triangle.
//  A Triangle is a 2-Triangle, 3D triangle, or just a triangle.
//
// --- PARAMETERS ---
edge_length = 50;   // Length of each side of the tetrahedron
diameter = 3;       // Rod thickness
radius = diameter / 2;
rod_sides = 4;      // 4 for square prisms, 64 for cylinders

vertexDiameter = 1.4; // Size of the corner spheres. Other size: 2.4
vertexShape = 64;   // Smoothness of vertices

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
                // Using $fn to define the cross-section shape 
                cylinder(h = h, r = r, center = false, $fn = rod_sides); 
    }
}

// ---------------------------------------------------------------------
// Main: Tetrahedron Frame
module tetrahedron_frame() {
    // Math for a regular tetrahedron centered at origin
    // Vertex coordinates derived from (+/-1, +/-1, +/-1) logic
    s = edge_length / sqrt(8); 
    
    verts = [
        [ s,  s,  s],
        [ s, -s, -s],
        [-s,  s, -s],
        [-s, -s,  s]
    ];

    // Draw Edges (6 total for a tetrahedron)
    // Every vertex connects to every other vertex
    color("GhostWhite") {
        for (i = [0 : 3]) {
            for (j = [i + 1 : 3]) {
                rod(verts[i], verts[j], radius);
            }
        }
    }

    // Draw Vertices 
    for (v = verts) {
        color("red")        // or use FireBrick
            translate(v) 
                sphere(r = vertexDiameter, $fn = vertexShape);
    }
}

// Render the design
tetrahedron_frame();