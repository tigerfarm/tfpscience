// --- Parameters ---
size = 50;              // Radius of the pentagon (distance from center to vertex) [cite: 1]
thickness = 3;          // Radius of the struts [cite: 1, 2]
vertixDiameter = 4.2;   // Radius of the spheres at joints [cite: 2]

// --- Pentagon Logic ---
// Create 5 vertices distributed evenly (360 / 5 = 72 degrees apart)
vertices = [
    for (i = [0 : 4]) 
        [size * cos(90 + i * 72), size * sin(90 + i * 72), 0]
];

// Define the connections to form a closed loop
edges = [
    [0, 1], [1, 2], [2, 3], [3, 4], [4, 0]
];

// --- Improved Strut Module (No Hull) ---
module create_edge(p1, p2, r) {
    v = p2 - p1;              // Vector between points [cite: 6, 7]
    d = norm(v);              // Distance (length of cylinder) [cite: 8]
    
    translate(p1)
    // Rotate the cylinder to align with the vector v
    rotate([0, acos(v[2]/d), atan2(v[1], v[0])])
    cylinder(h=d, r=r, $fn = 4); // $fn = 4 creates a square prism strut [cite: 8]
    
    // Add spheres at vertices for smooth joints
    translate(p1) sphere(vertixDiameter, $fn = 64);
    translate(p2) sphere(vertixDiameter, $fn = 64);
}

// --- Render ---
for (e = edges) {
    create_edge(vertices[e[0]], vertices[e[1]], thickness);
}