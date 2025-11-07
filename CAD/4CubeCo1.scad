// -----------------------------------------------------------------------------
// 4-Cube Coxeter projection into 3D.
// ---
// Figure out the number# for each each.

side = 50;                          // 4D cube edge length
edgeDiameter = 3;                   // 4D cube edge width(diameter)
edgeRadius = edgeDiameter / 2;
vertexRadius = edgeDiameter * 2;    // Vertex sphere diameter

// $fn = 96      // for extra-smooth rods.
$fn = 64;        // cylinder smoothness

// -----------------------------------------------------------------------------
// Helper: draw a cylinder edge between two 3D points
//
module edge(p1, p2) {
    v = p2 - p1;
    h = norm(v);
    if (h > 0) {
        a = acos(v.z / h);
        rot_axis = cross([  0,   0, 1], v);
        translate(p1)
            rotate(a, rot_axis)
                cylinder(h = h, r = edgeRadius, center = false);
    }
}

// -----------------------------------------------------------------------------
// Function: Coxeter projection from 4D → 3D
//
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

// -----------------------------------------------------------------------------
// Main: 4D hypercube frame projected into 3D

module hypercube_frame() {

    // -------------------------------------------------------------------------
    // Generate 16 vertices of 4D cube centered at origin
    verts4D = [
        for (x=[-1,1], y=[-1,1], z=[-1,1], w=[-1,1])
            [x*side/2, y*side/2, z*side/2, w*side/2]
    ];
    // Project all vertices into 3D
    verts3D = [ for (p = verts4D) projectCoxeter(p) ];

    // -------------------------------------------------------------------------
    // Edges
    //
    // Connect vertices that differ by exactly one coordinate (edge length == side)
    // for (i = [  0 : len(verts4D)-1])
    //    for (j = [i+1 : len(verts4D)-1])
    //        if (norm(verts4D[i] - verts4D[j]) == side) {
    //            echo("edge(", verts3D[i], verts3D[j]););
    //            edge(verts3D[i], verts3D[j]);
    //        }
    // The above generated the following.
    // Remove the inner/hidden lines.
    // edge([-50,   0,   0], [-25, -25, -25]);
    // edge([-50,   0,   0], [-25, -25,  25]);
    // edge([-50,   0,   0], [-25,  25,  25]);
    // edge([-50,   0,   0], [-25,  25, -25]);
    // ---------------------------------------
    // edge([  0, -50,   0], [ 25, -25, -25]);
    // edge([  0, -50,   0], [ 25, -25,  25]);
    // edge([  0,  50,   0], [ 25,  25, -25]);
    // edge([  0,  50,   0], [ 25,  25,  25]);
    // ---------------------------------------
    // edge([  0,   0, -50], [ 25, -25, -25]);
    // edge([  0,   0, -50], [ 25,  25, -25]);
    // edge([  0,   0,  50], [ 25, -25,  25]);
    // edge([  0,   0,  50], [ 25,  25,  25]);
    // ---------------------------------------
       edge([-25, -25, -25], [  0, -50,   0]);  // keep
    // edge([-25, -25, -25], [  0,   0, -50]);
    // ---------------------------------------
       edge([-25, -25,  25], [  0, -50,   0]);  // keep
    // edge([-25, -25,  25], [  0,   0,  50]);
    // ---------------------------------------
    // edge([ 25, -25, -25], [ 50,   0,   0]);
    // edge([ 25,  25, -25], [ 50,   0,   0]);
    // edge([ 25, -25,  25], [ 50,   0,   0]);
    // edge([ 25,  25,  25], [ 50,   0,   0]);
    // ---------------------------------------
    // edge([-25,  25,  25], [  0,   0,  50]);
    // edge([-25,  25,  25], [  0,  50,   0]);
    // ---------------------------------------
    // edge([-25,  25, -25], [  0,   0, -50]);
    // edge([-25,  25, -25], [  0,   0,   0]);
    // edge([-25,  25, -25], [  0,  50,   0]);
    // ---------------------------------------
    // edge([-25,  25,  25], [  0,   0,   0]);
    // edge([-25, -25, -25], [  0,   0,   0]);
    // edge([-25, -25,  25], [  0,   0,   0]);
    // ---------------------------------------
    // edge([  0,   0,   0], [ 25, -25, -25]);
    // edge([  0,   0,   0], [ 25,  25,  25]);
    // edge([  0,   0,   0], [ 25, -25,  25]);
    // edge([  0,   0,   0], [ 25,  25, -25]);

    // -------------------------------------------------------------------------
    // Draw spheres at vertices.
    for (v = verts3D)
        translate(v) sphere(r = vertexRadius);

}

// -----------------------------------------------------------------------------
// Render
hypercube_frame();
