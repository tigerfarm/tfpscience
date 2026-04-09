// --- Parameters ---
size = 25;              
thickness = 2;        // Thinner struts to better see the 5-cube interior
$fn = 4;                
vertexDiameter = 6.5;   

edgeColor = "cyan";     
vertexColor = "magenta";

phi = (1 + sqrt(5)) / 2;

// --- 5D Basis Vectors ---
v1 = [0, 1, phi];
v2 = [1, phi, 0];
v3 = [-1, phi, 0];
v4 = [phi, 0, 1];
v5 = [-phi, 0, 1];

// --- Fixed Vertex Function ---
// Replaced bitwise "&" with floor/modulo math
function get_v(i) = 
    let(
        s1 = (i % 2 >= 1) ? 1 : -1,
        s2 = (floor(i / 2) % 2 >= 1) ? 1 : -1,
        s3 = (floor(i / 4) % 2 >= 1) ? 1 : -1,
        s4 = (floor(i / 8) % 2 >= 1) ? 1 : -1,
        s5 = (floor(i / 16) % 2 >= 1) ? 1 : -1
    )
    (v1*s1 + v2*s2 + v3*s3 + v4*s4 + v5*s5) * size / 2;

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

// --- Main Assembly ---
module FiveCube() {
    for (i = [0:31]) {
        // Draw 5 edges per vertex (one for each dimension)
        for (bit = [0:4]) {
            // Check if the current bit is 0 to avoid double-drawing edges
            // pow(2, bit) replaces bit shifting
            if (floor(i / pow(2, bit)) % 2 == 0) {
                k = i + pow(2, bit); 
                if (k < 32) {
                    color(edgeColor) rod(get_v(i), get_v(k), thickness);
                }
            }
        }
        
        // Draw all 32 vertices
        color(vertexColor) translate(get_v(i)) 
            sphere(d = vertexDiameter, $fn = 32);
    }
}

FiveCube();