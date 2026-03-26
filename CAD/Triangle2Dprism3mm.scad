// Triangle Frame
//  A Triangle is a 2-Triangle, 2D triangle, or just a triangle.
//
// --- PARAMETERS ---
edge_length = 50;   
diameter = 3;       // Rod thickness
radius = diameter / 2;
rod_sides = 4;      // Prismatic rods
vertexDiameter = 1.4; 
vertexShape = 32;

// ---------------------------------------------------------------------
// Helper: Draw a prismatic rod between two 3D points
module rod(p1, p2, r = radius) {
    v = p2 - p1;
    h = norm(v);
    if (h > 0) {
        if (abs(v.x) < 0.001 && abs(v.y) < 0.001) {
            translate(p1)
                rotate([v.z < 0 ? 180 : 0, 0, 0])
                    cylinder(h = h, r1 = r, r2 = r, center = false, $fn = rod_sides);
        } else {
            a = acos(v.z / h);
            rot_axis = cross([0, 0, 1], v);
            translate(p1)
                rotate(a, rot_axis)
                    cylinder(h = h, r1 = r, r2 = r, center = false, $fn = rod_sides);
        }
    }
}

// ---------------------------------------------------------------------
// Main: Equilateral Triangle
module triangle() {
    // Calculate height for an equilateral triangle
    h = edge_length * sqrt(3) / 2;
    
    // 3 Vertices centered on the origin
    verts = [
        [0, h * 2/3, 0],               // Top vertex
        [-edge_length/2, -h * 1/3, 0], // Bottom left
        [edge_length/2, -h * 1/3, 0]   // Bottom right
    ];

    // Rods/Edges colored White
    color("GhostWhite") {
        for (i = [0 : 2]) {
            for (j = [i + 1 : 2]) {
                rod(verts[i], verts[j]);
            }
        }
    }
    
    // Spheres/Vertices colored Red
    color("Red") {
        for (v = verts) {
            translate(v) sphere(r = vertexDiameter, $fn = vertexShape);
        }
    }
}

// Render the triangle
triangle();