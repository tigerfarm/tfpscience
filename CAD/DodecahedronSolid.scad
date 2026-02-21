// --- PARAMETERS ---
size = 40;          // Distance from center to the vertices (Circumradius)
phi = (1 + sqrt(5)) / 2; // The Golden Ratio (~1.618)

// ---------------------------------------------------------------------
// Helper Module: Slab
// Creates a large block centered and rotated perpendicular to a vector
module slab(s, vector) {
    v = vector / norm(vector);
    
    // The distance from the center to the face of a regular dodecahedron
    // relative to its circumradius is approximately 0.79465
    face_dist = s * sqrt((5 + 2 * sqrt(5)) / 15);
    
    // Calculate rotation to align Z-axis with the target vector
    a = acos(v[2]);
    rot_axis = cross([0, 0, 1], v);

    rotate(a, rot_axis)
        cube([s*4, s*4, face_dist * 2], center=true);
}

// ---------------------------------------------------------------------
// Main Module: Solid Dodecahedron
module dodecahedron_solid(s = size) {
    // A regular dodecahedron is the intersection of 6 slabs 
    // oriented toward the 12 vertices of an icosahedron (6 pairs).
    intersection() {
        slab(s, [0, 1, phi]);
        slab(s, [0, 1, -phi]);
        slab(s, [1, phi, 0]);
        slab(s, [1, -phi, 0]);
        slab(s, [phi, 0, 1]);
        slab(s, [phi, 0, -1]);
    }
}

// Render the solid geometry
color("Goldenrod") dodecahedron_solid(size);