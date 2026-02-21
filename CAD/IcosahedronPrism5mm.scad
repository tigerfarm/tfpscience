// --- PARAMETERS ---
edge_length = 50;   
diameter = 5;     
radius = diameter / 2;
rod_sides = 4;      
vertexDiameter = 2.8; 
vertexShape = 64;   

phi = (1 + sqrt(5)) / 2; 

// ---------------------------------------------------------------------
// FIXED Helper: handles vertical edges correctly
module rod(p1, p2, r = radius) {
    v = p2 - p1;
    h = norm(v);
    if (h > 0) {
        // Check if the edge is parallel to the Z-axis (x and y are zero)
        if (abs(v.x) < 0.001 && abs(v.y) < 0.001) {
            translate(p1)
                // If pointing down, rotate 180, otherwise stay upright
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
// Main: Icosahedron Frame
module icosahedron_frame() {
    s = edge_length / 2;
    
    // 12 vertices
    verts = [
        [ 0,  s,  s*phi], [ 0,  s, -s*phi], [ 0, -s,  s*phi], [ 0, -s, -s*phi],
        [ s,  s*phi,  0], [ s, -s*phi,  0], [-s,  s*phi,  0], [-s, -s*phi,  0],
        [ s*phi,  0,  s], [ s*phi,  0, -s], [-s*phi,  0,  s], [-s*phi,  0, -s]
    ];

    // Draw Rods (30 edges total)
    for (i = [0 : 11]) {
        for (j = [i + 1 : 11]) {
            // Check for edge length with small floating point tolerance
            if (abs(norm(verts[i] - verts[j]) - edge_length) < 0.01) {
                rod(verts[i], verts[j], radius);
            }
        }
    }

    // Draw Spheres
    for (v = verts) {
        color("LimeGreen") translate(v) sphere(r = vertexDiameter, $fn = vertexShape);
    }
}

icosahedron_frame();