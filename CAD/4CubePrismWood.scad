// -----------------------------------------------------------------------------
// Text for working on a wooden 4-cube.
// From Gemini, the interior angles of the rhombus are:
//     70.53∘ (The acute angles)
//    109.47∘ (The obtuse angles)

side = 50;          // Rod edge strut length
edgeRadius = 3;     // Rod edge strut diameter
$fn = 4;            // Rod edge strut shape: 4:square, 6:hex, 64:cylinder.

// -----------------------------------------------------------------------------
// Helper: draw a rod edge strut between two 3D points
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
module drawShape() {

       edge([-50,   0,   0], [-25, -25, -25]);
       edge([-50,   0,   0], [-25, -25,  25]);
       edge([-25, -25, -25], [  0, -50,   0]);
       edge([-25, -25,  25], [  0, -50,   0]);

}

// -----------------------------------------------------------------------------
drawShape();