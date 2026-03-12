// Parametric 4D Tetrahedron (5-cell) Projection
// Generates a 3D perspective projection of a regular 4D simplex.

// --- Parameters ---
size = 60;           // Scale of the 4D object
strut_radius = 1.2;  // Thickness of the edges for 3D printing
projection_w = 2.5;  // Perspective factor (higher = more "depth" compression)
$fn = 30;

// --- 4D Vertex Coordinates (Regular 5-cell / 4-Simplex) ---
// These are the vertices of a regular 4-simplex in 4D space.
vertices4d = [
    [1, 1, 1, -1/sqrt(5)],
    [1, -1, -1, -1/sqrt(5)],
    [-1, 1, -1, -1/sqrt(5)],
    [-1, -1, 1, -1/sqrt(5)],
    [0, 0, 0, sqrt(5) - 1/sqrt(5)]
];

// --- Perspective Projection Function ---
// Projects [x, y, z, w] -> [x', y', z']
function project4d(p, w_dist) = 
    let(factor = 1 / (w_dist - p[3]))
    [p[0] * factor * size, p[1] * factor * size, p[2] * factor * size];

// --- 3D Points List ---
points3d = [ for (v = vertices4d) project4d(v, projection_w) ];

// --- Render Logic ---
module edge(p1, p2) {
    hull() {
        translate(p1) sphere(r = strut_radius);
        translate(p2) sphere(r = strut_radius);
    }
}

// Every vertex in a 5-cell is connected to every other vertex.
union() {
    for (i = [0 : 4]) {
        for (j = [i + 1 : 4]) {
            edge(points3d[i], points3d[j]);
        }
    }
}

// Visual indicator of vertices
for (p = points3d) {
    translate(p) color("DarkCyan") sphere(r = strut_radius * 1.4);
}