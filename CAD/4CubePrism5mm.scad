// OpenSCAD Code for 3D Projection of a 4D Cube (Tesseract)
// Frame changed from cylindrical rods to prismatic rods (e.g., square cross-section).
// Original from ChatGPT.
// I modified the code which I gave to Google Gemini.
// I had Google Gemini modify the code to have prismatic rods (e.g., square cross-section).

// --- PARAMETERS ---

edge_length = 50;   // 4D cube edge length (e.g., 50mm ~ 2")
diameter = 5;       // Rod diameter or flats if square
radius = diameter / 2;

// Set $fn to the number of sides for the frame strut prism shape
rod_sides = 4;      // Rod shape, 4: square, 6: hex, 64: cylinder.
                    // 96: extra-smooth rods and vertex spheres.

vertexDiameter = 3; // Vertex diameter
vertexShape = 64;   // 64: sphere, 4: cube.

// ---------------------------------------------------------------------
// Helper: draw a prism (rod) between two 3D points
module rod(p1, p2, r = radius) {
    v = p2 - p1;
    h = norm(v);
    if (h > 0) {
        // Calculate rotation axis and angle
        a = acos(v.z / h);
        rot_axis = cross([0, 0, 1], v);

        translate(p1)
            rotate(a, rot_axis)
                // The key change is using $fn = rod_sides (e.g., 4) 
                // to make the cylinder a prism.
                cylinder(h = h, r = r, center = false, $fn = rod_sides); 
    }
}

// ---------------------------------------------------------------------
// Function: Coxeter projection from 4D → 3D (No Change)
function projectCoxeter(p) =
    let(
        x = p[0],
        y = p[1],
        z = p[2],
        w = p[3],
        b1 = [1, 1, 1, 1] / 2,
        b2 = [1, 1, -1, -1] / 2,
        b3 = [1, -1, 1, -1] / 2
    )
    [
        x*b1[0] + y*b1[1] + z*b1[2] + w*b1[3],
        x*b2[0] + y*b2[1] + z*b2[2] + w*b2[3],
        x*b3[0] + y*b3[1] + z*b3[2] + w*b3[3]
    ];

// ---------------------------------------------------------------------
// Main: 4D hypercube frame projected into 3D (No Change to Logic)
module hypercube_frame() {
    // Generate 16 vertices of 4D cube centered at origin
    verts4D = [
        for (x=[-1,1], y=[-1,1], z=[-1,1], w=[-1,1])
            [x*edge_length/2, y*edge_length/2, z*edge_length/2, w*edge_length/2]
    ];

    // Project all 4D vertices into 3D space
    verts3D = [ for (p = verts4D) projectCoxeter(p) ];

    // Connect vertices that differ by exactly one coordinate
    for (i = [0 : len(verts4D)-1])
        for (j = [i+1 : len(verts4D)-1])
            if (norm(verts4D[i] - verts4D[j]) == edge_length)
                rod(verts3D[i], verts3D[j], radius);

    // Optional: Draw small spheres at vertices
    for (v = verts3D)
        color("red") translate(v) sphere(r = vertexDiameter, $fn=vertexShape);
}

// ---------------------------------------------------------------------
// Render the Tesseract
hypercube_frame();