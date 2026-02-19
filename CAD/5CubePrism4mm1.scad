// --- PARAMETERS ---
// Recommended by Google Gemini for 5D complexity:
//  Thinner rods: 2 where edge_length = 50.
edge_length = 60;
diameter = 3;
radius = diameter / 2;
rod_sides = 4;          // Frame cross-cut shape.
//
vertexDiameter = 3;   // Oringal: 2.5.
vertexShape = 32;   
vertexColor = "red";  // RoyalBlue or red

// Helper: draw a prism (rod) between two 3D points
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

// Function: Coxeter projection from 5D → 3D
// Adjusted basis vectors to handle the 5th dimension (v)
function projectCoxeter5D(p) =
    let(
        x = p[0], y = p[1], z = p[2], w = p[3], v = p[4],
        // Normalized basis vectors for a symmetric 3D projection
        s5 = 1/sqrt(5),
        b1 = [1, 1, 1, 1, 1] * s5,
        b2 = [1, 1, -1, -1, 0] * 0.5,
        b3 = [1, -1, 1, -1, 0] * 0.5
    )
    [
        x*b1[0] + y*b1[1] + z*b1[2] + w*b1[3] + v*b1[4],
        x*b2[0] + y*b2[1] + z*b2[2] + w*b2[3] + v*b2[4],
        x*b3[0] + y*b3[1] + z*b3[2] + w*b3[3] + v*b3[4]
    ];

// Main: 5D hypercube frame projected into 3D
module penteract_frame() {
    // Generate 32 vertices of 5D cube
    verts5D = [
        for (x=[-1,1], y=[-1,1], z=[-1,1], w=[-1,1], v=[-1,1])
            [x*edge_length/2, y*edge_length/2, z*edge_length/2, w*edge_length/2, v*edge_length/2]
    ];

    // Project all 5D vertices into 3D space
    verts3D = [ for (p = verts5D) projectCoxeter5D(p) ];

    // Connect vertices that differ by exactly one coordinate (Hamming distance 1)
    for (i = [0 : len(verts5D)-1])
        for (j = [i+1 : len(verts5D)-1])
            if (norm(verts5D[i] - verts5D[j]) == edge_length)
                rod(verts3D[i], verts3D[j], radius);

    // Draw spheres at vertices
    for (v = verts3D)
        color(vertexColor) translate(v) sphere(r = vertexDiameter, $fn=vertexShape);
}

// Render the 5-Cube
penteract_frame();