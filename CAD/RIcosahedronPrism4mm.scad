// Standard Rhombic Icosahedron
//  based on the Wikipedia article: https://en.wikipedia.org/wiki/Rhombic_icosahedron
//
// From Google Gemini:
// While our intuition wants it to be a perfect ball, its beauty really lies in those 20 identical rhombic faces and that unique, elongated symmetry.

// --- Parameters (Matching your Dodecahedron Style) ---
size = 25;              // Scale factor
thickness = 4;          // Radius of the struts
$fn = 4;                // Square prism for flat faces
vertexDiameter = 4.7;   // Diameter of vertex spheres

edgeColor = "cyan";
vertexColor = "magenta";

// --- Standard Rhombic Icosahedron ---
// These are the 22 vertices for the standard (non-squashed) version.
// As you noted, this shape is naturally elongated/flat from certain angles.
vertices = [
    [0.0000, -2.1180, -1.8090], [-1.6180, -2.1180, -0.8090], [1.6180, -2.1180, -0.8090],
    [0.0000, -2.1180, 0.1910],  [-1.0000, -0.5000, -1.8090], [-2.6180, -0.5000, -0.8090],
    [1.0000, -0.5000, -1.8090],  [2.6180, -0.5000, -0.8090],  [0.0000, 1.1180, -1.8090],
    [-1.6180, 1.1180, -0.8090], [1.6180, 1.1180, -0.8090],  [-1.6180, -1.1180, 0.8090],
    [1.6180, -1.1180, 0.8090],  [0.0000, -1.1180, 1.8090],  [-2.6180, 0.5000, 0.8090],
    [-1.0000, 0.5000, 1.8090],  [2.6180, 0.5000, 0.8090],   [1.0000, 0.5000, 1.8090],
    [0.0000, 2.1180, -0.1910],  [-1.6180, 2.1180, 0.8090],  [1.6180, 2.1180, 0.8090],
    [0.0000, 2.1180, 1.8090]
] * size;

// The 40 edges that define the 20 flat rhombic faces
edges = [
    [0, 1], [0, 2], [0, 4], [0, 6], [1, 3], [1, 5], [1, 11], [2, 3], [2, 7], [2, 12],
    [3, 13], [4, 5], [4, 8], [5, 9], [5, 14], [6, 7], [6, 8], [7, 10], [7, 16], [8, 9],
    [8, 10], [8, 18], [9, 19], [10, 20], [11, 13], [11, 14], [12, 13], [12, 16], [13, 15],
    [13, 17], [14, 15], [14, 19], [15, 21], [16, 17], [16, 20], [17, 21], [18, 19],
    [18, 20], [19, 21], [20, 21]
];

// --- Helper Modules ---
module rod(p1, p2, r) {
    dir = p2 - p1;
    h = norm(dir);
    if (h > 0) {
        translate(p1)
        rotate([0, 0, atan2(dir.y, dir.x)])
        rotate([0, atan2(sqrt(pow(dir.x, 2) + pow(dir.y, 2)), dir.z), 0])
        cylinder(h = h, r = r, $fn = $fn);
    }
}

module draw_shape() {
    for (e = edges) {
        color(edgeColor) rod(vertices[e[0]], vertices[e[1]], thickness);
    }
    for (v = vertices) {
        color(vertexColor) translate(v) sphere(d = vertexDiameter * 2, $fn = 64);
    }
}

draw_shape();