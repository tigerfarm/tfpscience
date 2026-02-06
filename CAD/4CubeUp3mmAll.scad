// -----------------------------------------------------------------------------
// 4-Cube Coxeter projection into 3D.
// ---
// This version is a 3D version without any center lines or the center vertex.
//  It's a 3D hidden version of the 4-Cube Coxeter projection

edgeDiameter = 3;                   // 4D cube edge width(diameter)
edgeRadius = edgeDiameter / 2;
vertexRadius = edgeDiameter;        // Vertex sphere diameter

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
// Main: 4D hypercube frame projected into 3D

module hypercube_frame() {
    // -------------------------------------------------------------------------
    // Edges
    //
    // Changes edges to join in 2 interior points instead of just one.
       edge([-40,   0,   0], [-25, -25, -25]);  // bottom left vertex: external
       edge([-10,   0,   0], [-25, -25, -25]);  // bottom left vertex: internal

    // Exterior edges
       edge([-50,   0,   0], [-25, -25,  25]);
       edge([-50,   0,   0], [-25,  25,  25]);
    // ---------------------------------------
       edge([  0, -50,   0], [ 25, -25, -25]);
       edge([  0, -50,   0], [ 25, -25,  25]);
       edge([  0,  50,   0], [ 25,  25, -25]);
       edge([  0,  50,   0], [ 25,  25,  25]);
    // ---------------------------------------
       edge([  0,   0, -50], [ 25, -25, -25]);
       edge([  0,   0, -50], [ 25,  25, -25]);
       edge([  0,   0,  50], [ 25, -25,  25]);
       edge([  0,   0,  50], [ 25,  25,  25]);
    // ---------------------------------------
       edge([-25, -25, -25], [  0, -50,   0]);
       edge([-25, -25, -25], [  0,   0, -50]);
       edge([-25, -25,  25], [  0, -50,   0]);
       edge([-25, -25,  25], [  0,   0,  50]);
    // ---------------------------------------
       edge([ 25, -25, -25], [ 50,   0,   0]);
       edge([ 25,  25, -25], [ 50,   0,   0]);
       edge([ 25, -25,  25], [ 50,   0,   0]);
       edge([ 25,  25,  25], [ 50,   0,   0]);
    // ---------------------------------------
       edge([-25,  25,  25], [  0,   0,  50]);
       edge([-25,  25,  25], [  0,  50,   0]);
    // ---------------------------------------
       edge([-25,  25, -25], [  0,   0, -50]);
       edge([-25,  25, -25], [  0,  50,   0]);
       edge([-25,  25, -25], [-50,   0,   0]);
    // ---------------------------------------
    // Interior edges.
       edge([-25,  25, -25], [  0,   0,   0]);  
       edge([-25,  25,  25], [  0,   0,   0]);
       edge([-25, -25,  25], [  0,   0,   0]);
    // ---------------------------------------
       edge([  0,   0,   0], [ 25, -25, -25]);
       edge([  0,   0,   0], [ 25,  25,  25]);
       edge([  0,   0,   0], [ 25, -25,  25]);
       edge([  0,   0,   0], [ 25,  25, -25]);

    // -------------------------------------------------------------------------
    // Vertices:
/*
    translate([  0,   0,   0]) sphere(r = vertexRadius);    // Center vertex
    //
    translate([-50,   0,   0]) sphere(r = vertexRadius);
    translate([  0, -50,   0]) sphere(r = vertexRadius);
    translate([  0,   0, -50]) sphere(r = vertexRadius);
    translate([  0,   0,  50]) sphere(r = vertexRadius);
    translate([  0,  50,   0]) sphere(r = vertexRadius);
    translate([ 50,   0,   0]) sphere(r = vertexRadius);
    translate([-25, -25, -25]) sphere(r = vertexRadius);
    translate([-25, -25,  25]) sphere(r = vertexRadius);
    translate([-25,  25, -25]) sphere(r = vertexRadius);
    translate([ 25, -25, -25]) sphere(r = vertexRadius);
    translate([-25,  25,  25]) sphere(r = vertexRadius);
    translate([ 25, -25,  25]) sphere(r = vertexRadius);
    translate([ 25,  25, -25]) sphere(r = vertexRadius);
    translate([ 25,  25,  25]) sphere(r = vertexRadius);
*/
}

// -----------------------------------------------------------------------------
// Render
hypercube_frame();