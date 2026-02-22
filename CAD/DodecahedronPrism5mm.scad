// --- Parameters ---
size = 50;              // Strut length          
thickness = 5;          // Radius of the struts
$fn = 4;                // Square prism: 4      
vertixDiameter = 4.7;   // Radius of the struts

phi = (1 + sqrt(5)) / 2; 

vertices = [
    [ 1,  1,  1], [ 1,  1, -1], [ 1, -1,  1], [ 1, -1, -1], 
    [-1,  1,  1], [-1,  1, -1], [-1, -1,  1], [-1, -1, -1], 
    [0,  1/phi,  phi], [0,  1/phi, -phi], [0, -1/phi,  phi], [0, -1/phi, -phi], 
    [ 1/phi,  phi, 0], [ 1/phi, -phi, 0], [-1/phi,  phi, 0], [-1/phi, -phi, 0], 
    [ phi, 0,  1/phi], [ phi, 0, -1/phi], [-phi, 0,  1/phi], [-phi, 0, -1/phi] 
] * size;

edges = [
    [0,8], [0,12], [0,16], [1,9], [1,12], [1,17], [2,10], [2,13], [2,16],
    [3,11], [3,13], [3,17], [4,8], [4,14], [4,18], [5,9], [5,14], [5,19],
    [6,10], [6,15], [6,18], [7,11], [7,15], [7,19], [8,10], [9,11], [12,14],
    [13,15], [16,17], [18,19]
];

// --- Improved Strut Module (No Hull) ---
module create_edge(p1, p2, r) {
    v = p2 - p1;              // Vector between points
    d = norm(v);              // Distance (length of cylinder)
    
    translate(p1)
    // Rotate the cylinder to align with the vector v
    rotate([0, acos(v[2]/d), atan2(v[1], v[0])])
    cylinder(h=d, r=r, $fn = 4);
    
    // Add spheres at vertices for smooth joints
    $fn = 64;
    translate(p1) sphere(vertixDiameter);
    translate(p2) sphere(vertixDiameter);
}

// --- Render ---
for (e = edges) {
    create_edge(vertices[e[0]], vertices[e[1]], thickness);
}