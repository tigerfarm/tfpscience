// Pentachoron which is a 4-Triangle, also called a 5-cell or simplex,
//  is a 4D shape projected in 3D Projection. 
//  A Tetrahedron is a 3-Triangle.
//  A Triangle is a 2-Triangle.
//
// Generates a 3D projection of a regular 4D Pentachoron.
//
// --- PARAMETERS ---
edge_length = 73;       // Size of 9" baseball
diameter = 5;           // Rod thickness
radius = diameter / 2;
rodShape = 4;           // 4:Prismatic rods, 64:cylinder
//
vertexDiameter = 2.2; 
vertexShape = 64;

// ---------------------------------------------------------------------
// Helper: Draw a prismatic rod between two 3D points
module rod(p1, p2, r = radius) {
    v = p2 - p1;
    h = norm(v);
    if (h > 0) {
        if (abs(v.x) < 0.001 && abs(v.y) < 0.001) {
            translate(p1)
                rotate([v.z < 0 ? 180 : 0, 0, 0])
                    cylinder(h = h, r1 = r, r2 = r, center = false, $fn = rodShape);
        } else {
            a = acos(v.z / h);
            rot_axis = cross([0, 0, 1], v);
            translate(p1)
                rotate(a, rot_axis)
                    cylinder(h = h, r1 = r, r2 = r, center = false, $fn = rodShape);
        }
    }
}

// ---------------------------------------------------------------------
// 4D to 3D Projection (Stereographic)
function project4d(v4, scale) = 
    let(w_offset = 2) 
    [ v4[0], v4[1], v4[2] ] * (scale / (w_offset - v4[3]));

// ---------------------------------------------------------------------
// Main: Pentachoron (5-Cell)
module pentachoron() {
    // 5 Vertices of a regular pentachoron in 4D space
    verts4d = [
        [1, 1, 1, -1/sqrt(5)],
        [1, -1, -1, -1/sqrt(5)],
        [-1, 1, -1, -1/sqrt(5)],
        [-1, -1, 1, -1/sqrt(5)],
        [0, 0, 0, sqrt(5) - 1/sqrt(5)]  // Comment the center point to make a techahedron.
    ];

    // Project 4D vertices to 3D
    verts3d = [ for (v = verts4d) project4d(v, edge_length) ];

    // Rods/Edges colored White or GhostWhite.
    color("GhostWhite") {
        for (i = [0 : 3]) {
            for (j = [i + 1 : 4]) {
                rod(verts3d[i], verts3d[j]);
            }
        }
    }
    
    // Spheres/Vertices colored Red
    color("Red") {
        for (v = verts3d) {
            translate(v) sphere(r = vertexDiameter, $fn = vertexShape);
        }
    }
}

// Render the 4D simplex
pentachoron();