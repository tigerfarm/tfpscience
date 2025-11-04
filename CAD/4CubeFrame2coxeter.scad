// Code from ChatGPT.
// ---
// The query:
//  OpenSCAD: 50mm × 50mm × 50mm × 50mm hypercube frame made of 3mm cylindrical rods using a Coxeter plane projection.
// ---
// The response:
//  That’s a beautiful request — you want a tesseract (4D hypercube) wireframe built from 3 mm cylindrical rods, with a Coxeter-plane projection (the most symmetric 4D-to-3D projection, often used to visualize the 8-cell).
//  We can’t “render” 4D directly in OpenSCAD, but we can compute the Coxeter projection of the 16 hypercube vertices into 3D coordinates and draw the 32 edges between them.
//  Here’s a complete, ready-to-run OpenSCAD script that does exactly that:
// ---
// OpenSCAD: 50mm × 50mm × 50mm × 50mm hypercube frame (tesseract)
// Projected into 3D using a Coxeter-plane projection
// Edges are 3mm-diameter cylindrical rods

side = 50;       // 4D cube edge length
diameter = 3;    // rod diameter
radius = diameter / 2;

// $fn = 96      // for extra-smooth rods.
$fn = 64;        // cylinder smoothness

// ---------------------------------------------------------------------
// Helper: draw a cylinder (rod) between two 3D points
module rod(p1, p2, r = radius) {
    v = p2 - p1;
    h = norm(v);
    if (h > 0) {
        a = acos(v.z / h);
        rot_axis = cross([0, 0, 1], v);
        translate(p1)
            rotate(a, rot_axis)
                cylinder(h = h, r = r, center = false);
    }
}

// ---------------------------------------------------------------------
// Function: Coxeter projection from 4D → 3D
// Reference: rotation and scaling chosen to show tesseract symmetry nicely
function projectCoxeter(p) =
    let(
        x = p[0],
        y = p[1],
        z = p[2],
        w = p[3],
        // orthogonal Coxeter-plane basis vectors (normalized)
        b1 = [1, 1, 1, 1] / 2,          // main diagonal
        b2 = [1, 1, -1, -1] / 2,        // opposite diagonal
        b3 = [1, -1, 1, -1] / 2         // third orthogonal direction
    )
    // 3D coordinates are projections onto these three basis vectors
    [
        x*b1[0] + y*b1[1] + z*b1[2] + w*b1[3],
        x*b2[0] + y*b2[1] + z*b2[2] + w*b2[3],
        x*b3[0] + y*b3[1] + z*b3[2] + w*b3[3]
    ];

// ---------------------------------------------------------------------
// Main: 4D hypercube frame projected into 3D
module hypercube_frame() {
    // Generate 16 vertices of 4D cube centered at origin
    verts4D = [
        for (x=[-1,1], y=[-1,1], z=[-1,1], w=[-1,1])
            [x*side/2, y*side/2, z*side/2, w*side/2]
    ];

    // Project all vertices into 3D
    verts3D = [ for (p = verts4D) projectCoxeter(p) ];

    // Connect vertices that differ by exactly one coordinate (edge length == side)
    for (i = [0 : len(verts4D)-1])
        for (j = [i+1 : len(verts4D)-1])
            if (norm(verts4D[i] - verts4D[j]) == side)
                rod(verts3D[i], verts3D[j], radius);

    // Optional: draw small spheres at vertices
    for (v = verts3D)
        translate(v) sphere(r = radius * 2);
}

// ---------------------------------------------------------------------
// Render
hypercube_frame();

