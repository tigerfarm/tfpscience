// --- PARAMETERS ---
size = 40;               // Distance from center to the vertices (Circumradius)
edge_thickness = 2.5;    // Rod diameter
phi = (1 + sqrt(5)) / 2; // The Golden Ratio

// ---------------------------------------------------------------------
// Helper: Regular Pentagon Frame (centered on XY plane)
module pentagon_frame(s) {
    // Distance from face center to its own vertices
    face_r = s * sqrt(3 - phi) / sqrt(3); 
    
    // 72 degrees between vertices
    // We start at 0 degrees to align with the coordinate system
    verts = [for (a = [0 : 72 : 359]) [face_r * cos(a), face_r * sin(a), 0]];

    for (i = [0:4]) {
        rod(verts[i], verts[(i+1)%5], edge_thickness/2);
    }
}

// Helper: Prismatic rod (Square profile)
module rod(p1, p2, r) {
    v = p2 - p1;
    h = norm(v);
    if (h > 0) {
        a = acos(v[2] / h);
        rot_axis = (abs(v[2]/h) > 0.99) ? [0, 1, 0] : cross([0, 0, 1], v);
        translate(p1) rotate(a, rot_axis)
            cylinder(h = h, r = r, $fn = 4); 
    }
}

// ---------------------------------------------------------------------
// Replacement for "Slab": Position and Align the Pentagon Frame
module pentagon_face_positioner(s, vector, twist = 0) {
    v = vector / norm(vector);
    
    // Distance from center to the face center (Inradius)
    inradius = s * sqrt((5 + 2 * sqrt(5)) / 15);
    
    // Calculate rotation to point the pentagon "up" along the vector
    a = acos(v[2]);
    rot_axis = (abs(v[2]) > 0.99) ? [0, 1, 0] : cross([0, 0, 1], v);

    rotate(a, rot_axis)
        rotate([0, 0, twist]) // Twist to align edges with neighbors
            translate([0, 0, inradius]) 
                pentagon_frame(s);
}

// ---------------------------------------------------------------------
// Main Module: Dodecahedron Assembly
module dodecahedron_aligned(s = size) {
    // 12 Face Normal Vectors (from an Icosahedron)
    // Grouping them by their 'twist' requirement for alignment
    
    // Top and Bottom faces
    pentagon_face_positioner(s, [0, 0, 1], twist = 36);
    pentagon_face_positioner(s, [0, 0, -1], twist = 0);

    // The "Tropical" and "Subtropical" faces
    // These need alternating twists to lock edges together
    vectors = [
        [0, 1, phi], [0, 1, -phi], [0, -1, phi], [0, -1, -phi],
        [1, phi, 0], [1, -phi, 0], [-1, phi, 0], [-1, -phi, 0],
        [phi, 0, 1], [phi, 0, -1], [-phi, 0, 1], [-phi, 0, -1]
    ];

    for (i = [0 : len(vectors)-1]) {
        // A 36-degree twist aligns the pentagon points to the gaps of neighbors
        pentagon_face_positioner(s, vectors[i], twist = 36);
    }
}

// Render
color("Goldenrod") dodecahedron_aligned(size);