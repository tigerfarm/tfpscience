// OpenSCAD Code for a Flat-Faced Spherical Rhombic Icosahedron
// Vertices are spherical, but edges are straight, creating flat-planed rods.

// --- PARAMETERS ---
sphereRadius = 60;      
edgeRadius = 3.6;       
edgeShape = 4;          // Square rods look great on flat faces
vertexRadius = 4.2; 
vertexShape = 64;       

edgeColor = "lightBlue";
vertexColor = "red";

// --- GEOMETRIC DATA ---
RAW_VERTS = [
  [0.0000, -4.2361, -3.6180], 
  [ -3.2361, -4.2361, -1.6180], 
  [ 3.2361, -4.2361, -1.6180], 
  [0.0000, -4.2361, 0.3820], 
  [ -2.0000, -1.0000, -3.6180], 
  [ -5.2361, -1.0000, -1.6180], 
  [2.0000, -1.0000, -3.6180], 
  [ 5.2361, -1.0000, -1.6180], 
  [ 0.0000, 2.2361, -3.6180], 
  [-3.2361, 2.2361, -1.6180], 
  [ 3.2361, 2.2361, -1.6180], 
  [ -3.2361, -2.2361, 1.6180], 
  [3.2361, -2.2361, 1.6180], 
  [ 0.0000, -2.2361, 3.6180], 
  [ -5.2361, 1.0000, 1.6180], 
  [-2.0000, 1.0000, 3.6180], 
  [ 5.2361, 1.0000, 1.6180], 
  [ 2.0000, 1.0000, 3.6180], 
  [0.0000, 4.2361, -0.3820], 
  [ -3.2361, 4.2361, 1.6180], 
  [ 3.2361, 4.2361, 1.6180], 
  [0.0000, 4.2361, 3.6180]
];
/*
Original:
  [0.0000, -4.2361, -3.6180], 
  [ -3.2361, -4.2361, -1.6180], 
  [ 3.2361, -4.2361, -1.6180], 
  [0.0000, -4.2361, 0.3820], 
  [ -2.0000, -1.0000, -3.6180], 
  [ -5.2361, -1.0000, -1.6180], 
  [2.0000, -1.0000, -3.6180], 
  [ 5.2361, -1.0000, -1.6180], 
  [ 0.0000, 2.2361, -3.6180], 
  [-3.2361, 2.2361, -1.6180], 
  [ 3.2361, 2.2361, -1.6180], 
  [ -3.2361, -2.2361, 1.6180], 
  [3.2361, -2.2361, 1.6180], 
  [ 0.0000, -2.2361, 3.6180], 
  [ -5.2361, 1.0000, 1.6180], 
  [-2.0000, 1.0000, 3.6180], 
  [ 5.2361, 1.0000, 1.6180], 
  [ 2.0000, 1.0000, 3.6180], 
  [0.0000, 4.2361, -0.3820], 
  [ -3.2361, 4.2361, 1.6180], 
  [ 3.2361, 4.2361, 1.6180], 
  [0.0000, 4.2361, 3.6180]
*/

EDGES = [
  [0, 1], [0, 2], [0, 4], [0, 6], [1, 3], [1, 5], [1, 11], [2, 3], [2, 7], [2, 12], 
  [3, 13], [4, 5], [4, 8], [5, 9], [5, 14], [6, 7], [6, 8], [7, 10], [7, 16], [8, 9], 
  [8, 10], [8, 18], [9, 19], [10, 20], [11, 13], [11, 14], [12, 13], [12, 16], [13, 15], 
  [13, 17], [14, 15], [14, 19], [15, 21], [16, 17], [16, 20], [17, 21], [18, 19], 
  [18, 20], [19, 21], [20, 21]
];

// --- HELPER FUNCTIONS ---
function normalize(v, r) = (v / norm(v)) * r;

// ---------------------------------------------------------------------
// module: rod
// Creates a straight beam between two points.
module rod(p1, p2, r) {
    dir = p2 - p1;
    h = norm(dir);
    if (h > 0) {
        translate(p1)
        // Rotate the cylinder (rod) to align with the vector p2 - p1
        rotate([0, 0, atan2(dir.y, dir.x)])
        rotate([0, atan2(sqrt(pow(dir.x, 2) + pow(dir.y, 2)), dir.z), 0])
        cylinder(h = h, r = r, $fn = edgeShape);
    }
}

// ---------------------------------------------------------------------
// Main Assembly
module FlatSphericalRhombicIcosahedron() {
    // Generate normalized vertices
    s_verts = [ for (v = RAW_VERTS) normalize(v, sphereRadius) ];

    // Draw Edges as straight rods
    for (e = EDGES) {
        color(edgeColor) rod(s_verts[e[0]], s_verts[e[1]], edgeRadius);
    }

    // Draw Vertices
    for (v = s_verts) {
        color(vertexColor) translate(v) sphere(r = vertexRadius, $fn = vertexShape);
    }
}

// Render with global color
FlatSphericalRhombicIcosahedron();

// Ghost sphere to show tangency
// %sphere(r = sphereRadius, $fn = 100);