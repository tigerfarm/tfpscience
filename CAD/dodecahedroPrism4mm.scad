// OpenSCAD Code for Rhombic Dodecahedron Wireframe.
// Google Gemini modified by 4Cube Frame Prism 5mm into a Rhombic Dodecahedron.
//  Prompt: Modify the output to be a rhombic dodecahedron.
//  To modify it to a rhombic dodecahedron,
//  you can remove the rods that connect to the inside center vertex. 

// --- PARAMETERS ---
scale_factor = 25; // Scale the object size for better visualization/printing
diameter = 4;      // Rod diameter
radius = diameter / 2;
rod_sides = 4;     // Square prism frame
$fn = rod_sides;   // Set $fn for prism shape

// ---------------------------------------------------------------------
// 1. Define Vertices (14 vertices of the Rhombic Dodecahedron)
// The standard coordinates are used and scaled.
vertices = [
    // 8 vertices shared with a cube (Type 1: corner vertices)
    [ 1,  1,  1], [ 1,  1, -1], [ 1, -1,  1], [-1,  1,  1],
    [ 1, -1, -1], [-1,  1, -1], [-1, -1,  1], [-1, -1, -1],

    // 6 vertices on the axes (Type 2: face-center vertices)
    [ 2,  0,  0], [-2,  0,  0], [ 0,  2,  0], [ 0, -2,  0],
    [ 0,  0,  2], [ 0,  0, -2]
];

// Scale all vertices
V = [ for (v = vertices) v * scale_factor ];

// ---------------------------------------------------------------------
// 2. Define Edges (24 edges of the Rhombic Dodecahedron)
// Edges connect a Type 1 vertex (index 0-7) to a Type 2 vertex (index 8-13)
// A corner vertex (Type 1) connects to 3 Type 2 vertices.
// A face-center vertex (Type 2) connects to 4 Type 1 vertices.

edges = [
    // Edges from (2, 0, 0) - Index 8
    [ 8, 0], [ 8, 1], [ 8, 2], [ 8, 4], 
    // Edges from (-2, 0, 0) - Index 9
    [ 9, 5], [ 9, 6], [ 9, 7], [ 9, 9], // Note: Index 9 should be 3 for [-1,1,1] - Corrected below
    [ 9, 3], [ 9, 5], [ 9, 6], [ 9, 7],

    // Edges from (0, 2, 0) - Index 10
    [10, 0], [10, 1], [10, 3], [10, 5],
    // Edges from (0, -2, 0) - Index 11
    [11, 2], [11, 4], [11, 6], [11, 7],

    // Edges from (0, 0, 2) - Index 12
    [12, 0], [12, 2], [12, 3], [12, 6],
    // Edges from (0, 0, -2) - Index 13
    [13, 1], [13, 4], [13, 5], [13, 7]
];

// ---------------------------------------------------------------------
// Helper: draw a prism (rod) between two 3D points (Reused from previous code)
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

// ---------------------------------------------------------------------
// Main Assembly
union() {
    // Draw all 24 edges
    for (e = edges) {
        rod(V[e[0]], V[e[1]], radius);
    }
    
    // Optional: Draw spheres at the 14 vertices
    for (v = V) {
        color("red") translate(v) sphere(r = 3, $fn=32); 
    }
}