// --- PARAMETERS ---
cube_edge = 50;     // The edge length of the cube component
diameter = 4;     // Rod thickness
radius = diameter / 2;
rod_sides = 4;      // Prismatic rods (square cross-section)
vertexDiameter = 2.2; 
vertexShape = 32;

// ---------------------------------------------------------------------
// Helper: draw a prismatic rod (adapted from your uploaded file)
module rod(p1, p2, r = radius) {
    v = p2 - p1;
    h = norm(v);
    if (h > 0) {
        a = acos(v.z / h);
        rot_axis = cross([0, 0, 1], v);
        translate(p1)
            rotate(a, rot_axis)
                cylinder(h = h, r = r, center = false, $fn = rod_sides); 
    }
}

// ---------------------------------------------------------------------
// Module: Cube Frame
module cube_frame() {
    s = cube_edge / 2;
    verts = [
        for (x=[-s,s], y=[-s,s], z=[-s,s]) [x, y, z]
    ];
    
    // Define the 12 edges of a cube
    edges = [
        [0,1], [2,3], [4,5], [6,7], // X-parallel
        [0,2], [1,3], [4,6], [5,7], // Y-parallel
        [0,4], [1,5], [2,6], [3,7]  // Z-parallel
    ];

    color("RoyalBlue") {
        for (e = edges) rod(verts[e[0]], verts[e[1]]);
        for (v = verts) translate(v) sphere(r = vertexDiameter, $fn=vertexShape);
    }
}

// ---------------------------------------------------------------------
// Module: Octahedron Frame
module octahedron_frame() {
    // For the edges to intersect at midpoints, the octahedron vertices 
    // must be at the same distance as the cube edge length from the origin.
    s = cube_edge; 
    
    verts = [
        [ s, 0, 0], [-s, 0, 0], 
        [ 0, s, 0], [ 0,-s, 0], 
        [ 0, 0, s], [ 0, 0,-s]
    ];

    edges = [
        [0,2], [0,3], [0,4], [0,5],
        [1,2], [1,3], [1,4], [1,5],
        [2,4], [2,5], [3,4], [3,5]
    ];

    color("Orange") {
        for (e = edges) rod(verts[e[0]], verts[e[1]]);
        for (v = verts) translate(v) sphere(r = vertexDiameter, $fn=vertexShape);
    }
}

// ---------------------------------------------------------------------
// Main: Render Compound
module compound_cube_octahedron() {
    cube_frame();
    octahedron_frame();
}

compound_cube_octahedron();