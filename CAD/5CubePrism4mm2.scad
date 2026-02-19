// --- PARAMETERS ---
edge_length = 60;   // Increased slightly for better visibility 
diameter = 4;     // Thinner rods help clarify the complex 80-edge structure 
radius = diameter / 2;
rod_sides = 4;      // Prismatic rods as requested [cite: 6]
vertexDiameter = 4; 
vertexShape = 32;   

// Helper: draw a prism (rod) between two 3D points [cite: 6]
module rod(p1, p2, r = radius) {
    v = p2 - p1;
    h = norm(v);
    if (h > 0) {
        a = acos(v.z / h);
        rot_axis = cross([0, 0, 1], v);
        translate(p1)
            rotate(a, rot_axis)
                cylinder(h = h, r = r, center = false, $fn = rod_sides); 
    }
}

// Function: Adjusted 5D → 3D Projection
// Using 72-degree offsets (360/5) to create a highly symmetric, open structure.
function projectPenteract(p) =
    let(
        x = p[0], y = p[1], z = p[2], w = p[3], v = p[4],
        // Basis vectors for a 5-fold symmetric "unfolding" 
        // b1 = [cos(0), cos(72), cos(144), cos(216), cos(288)],
        // b2 = [sin(0), sin(72), sin(144), sin(216), sin(288)],
        // b3 = [0.4, 0.4, 0.4, 0.4, 0.4] // Depth offset to separate the 3D layers
        b1 = [cos(0), cos(72), cos(144), cos(216), cos(288)],
        b2 = [sin(0), sin(72), sin(144), sin(216), sin(288)],
        b3 = [0.7, 0.7, 0.7, 0.7, 0.7] // Depth offset to separate the 3D layers
    )
    [
        x*b1[0] + y*b1[1] + z*b1[2] + w*b1[3] + v*b1[4],
        x*b2[0] + y*b2[1] + z*b2[2] + w*b2[3] + v*b2[4],
        x*b3[0] + y*b3[1] + z*b3[2] + w*b3[3] + v*b3[4]
    ];

// Main: 5D hypercube frame [cite: 9]
module penteract_frame() {
    // Generate 32 vertices (2^5) [cite: 9, 10]
    verts5D = [
        for (x=[-1,1], y=[-1,1], z=[-1,1], w=[-1,1], v=[-1,1])
            [x*edge_length/2, y*edge_length/2, z*edge_length/2, w*edge_length/2, v*edge_length/2]
    ];

    // Project into 3D space [cite: 10]
    verts3D = [ for (p = verts5D) projectPenteract(p) ];

    // Connect vertices with exactly one coordinate difference (Hamming distance 1) [cite: 11]
    for (i = [0 : len(verts5D)-1])
        for (j = [i+1 : len(verts5D)-1])
            if (norm(verts5D[i] - verts5D[j]) == edge_length)
                rod(verts3D[i], verts3D[j], radius);

    // Draw vertex markers [cite: 12]
    for (v = verts3D)
        color("Crimson") translate(v) sphere(r = vertexDiameter, $fn=vertexShape);
}

// Render the 5-Cube
penteract_frame();