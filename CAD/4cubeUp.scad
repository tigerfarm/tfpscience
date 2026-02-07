// ---------------------------------------------------------------------------
// 4-Cube Coxeter plane projection into a 3D print object.
// ---
// This version has 2 center vertices
//  instead of one vertex
//  that is actually two 4D vertices in the same 3D position.
//
edgeDiameter = 3;   // 4-cube edge width(diameter)
edgeRadius = edgeDiameter / 2;
rod_sides = 4;      // Rod shape, 4: square, 6: hex, 64: cylinder.
$fn = rod_sides;    // Set $fn to the number of sides for the prism shape
//
vertexRadius = 2;   // Vertex sphere diameter

// ---------------------------------------------------------------------------
// Helper: construct a edge between two 3D points
//
module edge(p1, p2) {
    v = p2 - p1;
    h = norm(v);
    if (h > 0) {
      a = acos(v.z / h);
      rot_axis = cross([  0,   0, 1], v);
      translate(p1)
        rotate(a, rot_axis)
          // "$fn = rod_sides" required to shape the rods.
          cylinder(h = h, r = edgeRadius, center = false, $fn = rod_sides);
    }
}

// ---------------------------------------------------------------------------
// Main: 4D hypercube frame projected into 3D

module hypercube_frame() {
    // -------------------------------------------------------------------------
    // Cube Edges
    // Order based on set elements from top {w,x,y,z} to bottom {}.
    //  First letter is the last draw dimension direction.
    //  The other letters are added in order of w,x,y,z.
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
       edge([ 25,  25,  25], [  0,   5,  45]);  // zxy  front right top
       edge([ -5,   0,   0], [ 25,  25, -25]);  // zwy  back right center
       edge([-25,  25, -25], [-45,   0,   0]);  // zwx  mid back left
       edge([  5,   0,   0], [ 25,  25,  25]);  // yxz  top right center
       edge([ 25,  25, -25], [  0,  -5, -45]);  // ywz  bottom back mid-right
       edge([-25,  25,  25], [-45,   0,   0]);  // ywx  top left
       edge([-25,  25, -25], [  0,  -5, -45]);  // xwz  back left back
       edge([ 25,  25,  25], [ 45,   0,   0]);  // xyx  mid right top
       edge([-25,  25,  25], [ -5,   0,   0]);  // xwy  top left center
       edge([ 25,  25, -25], [ 45,   0,   0]);  // wzy  back right mid
       edge([-25,  25, -25], [  5,   0,   0]);  // wxz  back left center
       edge([-25,  25,  25], [  0,   5,  45]);  // wxy  front left
    // ---------------------------------------
       edge([ 25, -25,  25], [ 45,   0,   0]);  // zy   front right
       edge([-25, -25, -25], [  0,  -5, -45]);  // zw   back left
       edge([-25, -25, -25], [ -5,   0,   0]);  // wy   bottom left center
       edge([-25, -25,  25], [  5,   0,   0]);  // zx   front left center
       edge([ 25, -25, -25], [ 45,   0,   0]);  // yz   bottom right
       edge([-25, -25,  25], [  0,   5,  45]);  // yx   left center
       edge([  5,   0,   0], [ 25, -25, -25]);  // yx   bottom right center
       edge([ -5,   0,   0], [ 25, -25,  25]);  // wy   front right center
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
    //         x    z    y      x    z    y
    // -------------------------------------------------------------------------
    // Vertices:
    //
    $fn = 64;   // Makes the spheres round.
    //
    translate([  5,   0,   0]) sphere(r = vertexRadius);    // Center vertex
    translate([ -5,   0,   0]) sphere(r = vertexRadius);    // Center vertex
    //
    //           x    y    z 
    translate([-45,   0,   0]) sphere(r = vertexRadius);    // most left
    translate([ 45,   0,   0]) sphere(r = vertexRadius);    // most right
    translate([  0,   5,  45]) sphere(r = vertexRadius);    // front top
    translate([  0, -45,  -5]) sphere(r = vertexRadius);    // front bottom
    translate([  0,  45,   5]) sphere(r = vertexRadius);    // back top 
    translate([  0,  -5, -45]) sphere(r = vertexRadius);    // back bottom
    translate([-25, -25, -25]) sphere(r = vertexRadius);
    translate([-25, -25,  25]) sphere(r = vertexRadius);
    translate([-25,  25,  25]) sphere(r = vertexRadius);
    translate([ 25,  25,  25]) sphere(r = vertexRadius);
    translate([ 25, -25,  25]) sphere(r = vertexRadius);
    translate([ 25, -25, -25]) sphere(r = vertexRadius);
    translate([ 25,  25, -25]) sphere(r = vertexRadius);
    translate([-25,  25, -25]) sphere(r = vertexRadius);
}
// ---------------------------------------------------------------------------
// Render
hypercube_frame();