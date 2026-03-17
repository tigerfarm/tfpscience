// Canadian Flag from WikiMedia, public domain - SVG Enhanced
//  https://commons.wikimedia.org/wiki/File:Flag_of_Canada_(leaf).svg
// Dimensions based on official 1:2 ratio
//
// Gemini notes:
// https://gemini.google.com/app/488c75818b425f1e
// If you plan to print this,
//  the thickness of the leaf (in linear_extrude) should be 
//  at least two layers high (e.g., 0.4mm to 0.6mm) 
//  so the slicer picks up the color change clearly.

$fn = 60;

// Flag
height = 100;
width = 200;
flagThickness = 2;
leafThickness = 3;
// Flag Colors
red = [1, 0, 0];
white = [1, 1, 1];

// Raised border
border_width = 10;
border_height = 8; // Total height of the border relative to the base plane
// border_color = [0.4, 0.4, 0.4]; // Dark grey for a distinct frame
border_color = [0.6, 0.4, 0.2]; // Wood

module flag_base() {
    union() {
        // Red Bars (Left and Right)
        color(red) {
            cube([width/4, height, flagThickness]);
            translate([3*width/4, 0, 0]) cube([width/4, height, flagThickness]);
        }
        // White Center Square
        color(white)
            translate([width/4, 0, 0]) cube([width/2, height, flagThickness]);
    }
}

module official_leaf() {
    color(red)
    // Position the leaf in the center of the white square
    // Location:
    //  Left-right: width
    //  up-down: height
    //  Back-front: flagThickness (on top the flag layer)
    translate([(width/2)-33, (height/2)-33, flagThickness])
    linear_extrude(height = leafThickness) {
        // 'center = true' works for many SVGs, 
        // but you may need to adjust scale based on your file's resolution
        scale([0.3, 0.3]) 
        import("CanadaFlagMapleLeaf.svg", center = true);
    }
}

module official_leaf_back() {
    color(red)
    // Position the leaf in the center of the white square
    // Location:
    //  Left-right: width
    //  up-down: height
    //  Back-front: flagThickness
    translate([(width/2)-33, (height/2)-33, -leafThickness])
    linear_extrude(height = leafThickness) {
        // 'center = true' works for many SVGs, 
        // but you may need to adjust scale based on your file's resolution
        scale([0.3, 0.3]) 
        import("CanadaFlagMapleLeaf.svg", center = true);
    }
}

// Function to add a raised border
module flag_border() {
    // We add the border around the outside of the main flag.
    // The dimensions of the entire assembly will increase.
    
    translate([-border_width, -border_width, 0]) // Adjust origin
    color(border_color)
    difference() {
        // Outer box (encompassing the flag plus the border)
        cube([width + 2*border_width, height + 2*border_width, border_height]);
        // Inner cutout (to let the flag show through)
        translate([border_width, border_width, -1]) // Slight overlap for clean cut
        cube([width, height, border_height + 2]);
    }
}

// Assemble
flag_base();
official_leaf();
official_leaf_back();
//flag_border();

// eof