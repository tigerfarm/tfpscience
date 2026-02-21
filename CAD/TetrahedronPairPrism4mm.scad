// --- PARAMETERS ---
edge_length = 50;   // The edge length of the two component tetrahedra
diameter = 4;     // Rod thickness
radius = diameter / 2;
rod_sides = 4;      // Prismatic rods (square cross-section)
vertexDiameter = 2; 
vertexShape = 32;

// ---------------------------------------------------------------------
// ROBUST Helper: draw a prismatic rod (handles Z-parallel edges)
module rod(p1, p2, r = radius) {
    v = p2 - p1;
    h = norm(v);
    if (h > 0) {
        // Check if the edge is parallel to the Z-axis to avoid cross-product error
        if (abs(v.x) < 0.001 && abs(v.y) < 0.001) {
            translate(p1)
                rotate([v.z < 0 ? 180 : 0, 0, 0])
                    cylinder(h = h, r = r, center = false, $fn = rod_sides);
        } else {
            a = acos(v.z / h);
            rot_axis = cross([0, 0, 1], v);
            translate(p1)
                rotate(a, rot_axis)
                    cylinder(h = h, r = r, center = false, $fn = rod_sides); 
        }
    }
}

// ---------------------------------------------------------------------
// Component: A single tetrahedron frame
module tetrahedron_frame(verts, col) {
    color(col) {
        // Each tetrahedron has 6 edges
        // Connect every vertex to every other vertex in this set
        for (i = [0 : 3]) {
            for (j = [i + 1 : 3]) {
                rod(verts[i], verts[j]);
            }
        }
        // Draw spheres at vertices
        for (v = verts) {
            translate(v) sphere(r = vertexDiameter, $fn = vertexShape);
        }
    }
}

// ---------------------------------------------------------------------
// Main: Stellated Octahedron (Compound of Two Tetrahedra)
module stella_octangula() {
    // Coordinate scaling for the desired edge length
    s = edge_length / sqrt(8); 
    
    // Tetrahedron 1 vertices
    verts1 = [
        [ s,  s,  s],
        [ s, -s, -s],
        [-s,  s, -s],
        [-s, -s,  s]
    ];

    // Tetrahedron 2 vertices (Inverted)
    verts2 = [
        [-s, -s, -s],
        [-s,  s,  s],
        [ s, -s,  s],
        [ s,  s, -s]
    ];

    tetrahedron_frame(verts1, "Gold");
    tetrahedron_frame(verts2, "DodgerBlue");
}

// Render the design
stella_octangula();