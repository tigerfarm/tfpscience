// 4-Code frame
//
// OpenSCAD: 4D hypercube (tesseract) frame projected into 3D
// 50mm edge length, 3mm cylindrical rods

side = 50;      // edge length in mm
diameter = 3;   // rod diameter in mm
radius = diameter / 2;
proj_dist = 100; // projection distance (controls perspective amount)
$fn = 48;

// ------------- 4D to 3D projection function -------------
function project4D(p) =
    // perspective projection from 4D (x,y,z,w) to 3D (x',y',z')
    let (w_factor = proj_dist / (proj_dist - p[3]))
        [p[0]*w_factor, p[1]*w_factor, p[2]*w_factor];

// ------------- Module to make a rod between two 3D points -------------
module rod(p1, p2, r=radius) {
    v = p2 - p1;
    h = norm(v);
    if (h > 0) {
        a = acos(v.z / h);
        rot_axis = cross([0,0,1], v);
        translate(p1)
            rotate(a, rot_axis)
                cylinder(h=h, r=r, center=false);
    }
}

// ------------- Main hypercube frame module -------------
module hypercube_frame() {
    // Generate 16 vertices of a 4D hypercube centered at origin
    coords4D = [
        for (x=[-1,1], y=[-1,1], z=[-1,1], w=[-1,1])
            [x*side/2, y*side/2, z*side/2, w*side/2]
    ];

    // Project 4D points to 3D
    coords3D = [ for (p = coords4D) project4D(p) ];

    // Connect vertices that differ by exactly one coordinate (adjacent edges)
    for (i = [0 : len(coords4D)-1])
        for (j = [i+1 : len(coords4D)-1])
            if (norm(coords4D[i]-coords4D[j]) == side)
                rod(coords3D[i], coords3D[j], radius);

    // Optional spheres at vertices
    for (p = coords3D)
        translate(p) sphere(r=radius);
}

// ------------- Render -------------
hypercube_frame();
