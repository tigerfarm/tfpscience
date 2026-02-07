// -----------------------------------------------------------------------------
// 4-Cube Coxeter projection into 3D.
// ---
// This version is a 3D version without any center lines or the center vertex.
//  It's a 3D hidden version of the 4-Cube Coxeter projection

edgeDiameter = 3;                   // 4D cube edge width(diameter)
edgeRadius = edgeDiameter / 2;
vertexRadius = 2;        // Vertex sphere diameter

﻿rod_sides = 4;          // 4 for square, 6 for hex prism
$fn = rod_sides;        // Set $fn to the number of sides for the prism shape

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
//       edge([-40,   0,   0], [-25, -25, -25]);  // bottom left vertex: external
//       edge([-10,   0,   0], [-25, -25, -25]);  // bottom left vertex: internal

    // Order based on set from top {w,x,y,z} to bottom {}.
    //
    // -----------------------------------------------------------------------
    // Exterior edges
    //         x    z    y      x    z    y
    // ---------------------------------------
       edge([-25,  25,  25], [  0,  45,   5]);  // zwxy top left back
       edge([-25,  25, -25], [  0,  45,   5]);  // ywxz top mid-left back
       edge([ 25,  25, -25], [  0,  45,   5]);  // xwyz top back mid-right
       edge([ 25,  25,  25], [  0,  45,   5]);  // wxyz top back right
    // ---------------------------------------
       edge([-25,  25,  25], [  0,   5,  45]);  // wxy  front left
       edge([ 25,  25, -25], [ 45,   0,   0]);  // wzy  back right mid
       edge([ 25,  25,  25], [  0,   5,  45]);  // zxy  front right top
       edge([-25,  25, -25], [-45,   0,   0]);  // zwx  mid back left
       edge([-25,  25,  25], [-45,   0,   0]);  // ywx  top left
       edge([ 25,  25, -25], [  0,  -5, -45]);  // ywz  bottom back mid-right
       edge([-25,  25, -25], [  0,  -5, -45]);  // xwz  back left back
       edge([ 25,  25,  25], [ 45,   0,   0]);  // xyx  mid right top
    // ---------------------------------------
       edge([ 25, -25,  25], [ 45,   0,   0]);  // zy   front right
       edge([-25, -25, -25], [  0,  -5, -45]);  // zw   back left
       edge([ 25, -25, -25], [ 45,   0,   0]);  // yz   bottom right
       edge([-25, -25,  25], [  0,   5,  45]);  // yx   left center
       edge([ 25, -25,  25], [  0,   5,  45]);  // xy   front right top
       edge([-25, -25, -25], [-45,   0,   0]);  // xw   bottom left
       edge([ 25, -25, -25], [  0,  -5, -45]);  // wz   bottom back, right
       edge([-25, -25,  25], [-45,   0,   0]);  // wx   mid front left
    // ---------------------------------------
       edge([ 25, -25, -25], [  0, -45,  -5]);  // z    front right
       edge([ 25, -25,  25], [  0, -45,  -5]);  // y    front mid-right
       edge([-25, -25,  25], [  0, -45,  -5]);  // x    front mid-left
       edge([-25, -25, -25], [  0, -45,  -5]);  // w    front left
    // ---------------------------------------
    // Left rhombus
    // ---------------------------------------
    // Interior edges.
    //         x    z    y      x    z    y
    // Left rhombus
       edge([-25, -25, -25], [ -5,   0,   0]);  // bottom left, center
       edge([-25,  25,  25], [ -5,   0,   0]);  // top left, center
       edge([-25,  25, -25], [  5,   0,   0]);  // back left, center
       edge([-25, -25,  25], [  5,   0,   0]);  // front left, center
    // ---------------------------------------
    // right rhombus
       edge([  5,   0,   0], [ 25, -25, -25]);  // bottom right, center
       edge([ -5,   0,   0], [ 25,  25, -25]);  // back right, center
       edge([ -5,   0,   0], [ 25, -25,  25]);  // front right, center
       edge([  5,   0,   0], [ 25,  25,  25]);  // top right, center

    // -------------------------------------------------------------------------
    // Vertices:

    $fn = 64;

    translate([  5,   0,   0]) sphere(r = vertexRadius);    // Center vertex
    translate([ -5,   0,   0]) sphere(r = vertexRadius);    // Center vertex
    //
    //           x    y    z 
    translate([-45,   0,   0]) sphere(r = vertexRadius);    // most left
    translate([ 45,   0,   0]) sphere(r = vertexRadius);    // most right
    translate([  0, -45,  -5]) sphere(r = vertexRadius);    // front bottom
    translate([  0,  45,   5]) sphere(r = vertexRadius);    // top back
    translate([  0,  -5, -45]) sphere(r = vertexRadius);    // bottom back
    translate([  0,   5,  45]) sphere(r = vertexRadius);    // front top
    translate([-25, -25, -25]) sphere(r = vertexRadius);
    translate([-25, -25,  25]) sphere(r = vertexRadius);
    translate([-25,  25,  25]) sphere(r = vertexRadius);
    translate([ 25,  25,  25]) sphere(r = vertexRadius);
    translate([ 25, -25,  25]) sphere(r = vertexRadius);
    translate([ 25, -25, -25]) sphere(r = vertexRadius);
    translate([ 25,  25, -25]) sphere(r = vertexRadius);
    translate([-25,  25, -25]) sphere(r = vertexRadius);
    
}

// -----------------------------------------------------------------------------
// Render
hypercube_frame();