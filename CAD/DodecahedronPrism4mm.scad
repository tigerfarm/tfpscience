// --- Parameters ---
size = 50;          // Scale factor
thickness = 4;    // Radius of the frame struts
$fn = 4;           // Smoothness of cylinders/spheres

// The Golden Ratio
phi = (1 + sqrt(5)) / 2; 

// --- Vertex Coordinates ---
// A regular dodecahedron's vertices are permutations of:
// (±1, ±1, ±1)
// (0, ±1/phi, ±phi)
// (±1/phi, ±phi, 0)
// (±phi, 0, ±1/phi)

vertices = [
    [ 1,  1,  1], [ 1,  1, -1], [ 1, -1,  1], [ 1, -1, -1], // 0-3
    [-1,  1,  1], [-1,  1, -1], [-1, -1,  1], [-1, -1, -1], // 4-7
    [0,  1/phi,  phi], [0,  1/phi, -phi], [0, -1/phi,  phi], [0, -1/phi, -phi], // 8-11
    [ 1/phi,  phi, 0], [ 1/phi, -phi, 0], [-1/phi,  phi, 0], [-1/phi, -phi, 0], // 12-15
    [ phi, 0,  1/phi], [ phi, 0, -1/phi], [-phi, 0,  1/phi], [-phi, 0, -1/phi]  // 16-19
] * size;

// --- Edge Connections ---
// Each number corresponds to the index in the 'vertices' list above
edges = [
    [0,8], [0,12], [0,16], [1,9], [1,12], [1,17], [2,10], [2,13], [2,16],
    [3,11], [3,13], [3,17], [4,8], [4,14], [4,18], [5,9], [5,14], [5,19],
    [6,10], [6,15], [6,18], [7,11], [7,15], [7,19], [8,10], [9,11], [12,14],
    [13,15], [16,17], [18,19]
];

// --- Modules ---

module strut(p1, p2, r) {
    hull() {
        translate(p1) sphere(r);
        translate(p2) sphere(r);
    }
}

// --- Render ---
union() {
    for (e = edges) {
        strut(vertices[e[0]], vertices[e[1]], thickness);
    }
}