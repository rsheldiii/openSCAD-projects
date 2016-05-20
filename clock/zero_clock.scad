// display dimensions (without I2c PCB)
clock_x = 120.5;
clock_y = 41.5;
clock_z = 9.5;

// extra length the plate adds to the clock
extra_plate_y = 10;
extra_plate_z = 1.5;

wall_thickness = 2;
// soft minimum might be 35
enclosure_depth = 50;

//raspi zero dimensions
zero_x = 58;
zero_y = 23;
zero_z = 1.5;

//minkowski radius for zero's 
zero_mink_r = 3.5;

//radius for raspberry pi screw holes from datasheet
zero_hole_diameter = 2.75;

//microusb dimensions
microusb_x = 9;
microusb_y = 3.25;

//mini HDMI dimensions
minihdmi_x = 12;
minihdmi_y = 3.5;

// raspberry pi zero port holes offset for spacers
// don't set to 0, there are flanges on the bottom of the raspberry pi that will get in the way
zero_z_offset = 3;

// metavariables
total_clock_y = clock_y + extra_plate_y;
total_clock_z = clock_z + extra_plate_z;

// global corner rounding value
$fn = 24;

//actual clock face for fitment purposes
module clock_face(){
    translate([0,extra_plate_y/2,extra_plate_z]) cube([clock_x,clock_y,clock_z]);
    cube([clock_x, total_clock_y, extra_plate_z]);
}

// http://goo.gl/cy1eCn
module raspberry_pi_zero(){
    difference(){
        minkowski(){
            mink_z = 0.01;
            cube([zero_x, zero_y, zero_z - mink_z * 2]);
            cylinder(h=mink_z, r = zero_mink_r);
        }
        raspberry_pi_zero_holes(25);
    }
    raspberry_pi_zero_ports(10);
}

module raspberry_pi_zero_holes(height){
    //dont have to translate because minkowski
    translate([     0,      0, -height/2]) cylinder(h=height, d=zero_hole_diameter);
    translate([zero_x,      0, -height/2]) cylinder(h=height, d=zero_hole_diameter);
    translate([     0, zero_y, -height/2]) cylinder(h=height, d=zero_hole_diameter);
    translate([zero_x, zero_y, -height/2]) cylinder(h=height, d=zero_hole_diameter);
}

module raspberry_pi_zero_ports(port_length){
    1st_port_x = 12.4;
    second_port_x = 41.4;
    third_port_x = 54;

    // y and z transposed since they are rotated
    translate([   1st_port_x - minihdmi_x/2 - zero_mink_r, -zero_mink_r - port_length/2, zero_z]) cube([minihdmi_x, port_length, minihdmi_y]);
    translate([second_port_x - microusb_x/2 - zero_mink_r, -zero_mink_r - port_length/2, zero_z]) cube([microusb_x, port_length, microusb_y]);
    translate([ third_port_x - microusb_x/2 - zero_mink_r, -zero_mink_r - port_length/2, zero_z]) cube([microusb_x, port_length, microusb_y]);
}

// actual enclosure
module case(){
    mink_r = 2;
    difference(){
        //outer
        minkowski(){
            translate([mink_r,mink_r,-clock_z + wall_thickness + mink_r]){
                cube([
                    clock_x + wall_thickness * 2 - mink_r*2,
                    total_clock_y + wall_thickness * 2 - mink_r*2,
                    enclosure_depth + wall_thickness + clock_z - mink_r*2
                ]);
            }
            sphere(r=mink_r, $fn=48);
        }
        //inner
        translate([wall_thickness, wall_thickness, wall_thickness]) cube([clock_x, total_clock_y, enclosure_depth]);
        //negative faceplate
        translate([wall_thickness + clock_x,wall_thickness, extra_plate_z + wall_thickness]) rotate([0,180]) clock_face();
    }
    //faceplate position helper. uncomment to see clock
    //translate([wall_thickness + clock_x,wall_thickness, extra_plate_z + wall_thickness]) rotate([0,180]) clock_face();
}

// some numbers transposed due to rotation of the clock
module tabs(){
    // too tight on my printer. you'll need to adjust these
    slop_x = .575;
    slop_z = .15;

    // w h
    tab_x = 10;
    tab_y = 10;

    // bottom right
    translate([wall_thickness + slop_x, -(enclosure_depth + wall_thickness), wall_thickness + slop_z]) cube([tab_x,tab_y,wall_thickness]);
    // bottom left
    translate([clock_x + wall_thickness - tab_x - slop_x, -(enclosure_depth + wall_thickness), wall_thickness + slop_z]) cube([tab_x,tab_y,wall_thickness]);

    // top left
    translate([clock_x + wall_thickness - tab_x - slop_x, -(enclosure_depth + wall_thickness), total_clock_y - slop_z]) cube([tab_x,tab_y,wall_thickness]);
    // top right
    translate([wall_thickness + slop_x, -(enclosure_depth + wall_thickness), total_clock_y - slop_z]) cube([tab_x,tab_y,wall_thickness]);  
}




// actual two outputs


module clock_back(){
    difference(){
        rotate([90,0,0]) case();
        translate([(clock_x + wall_thickness * 2 - zero_x)/2,-enclosure_depth,wall_thickness + 3]) raspberry_pi_zero_ports(100);
        translate([(clock_x + wall_thickness * 2 - zero_x)/2,-enclosure_depth + wall_thickness,wall_thickness]) raspberry_pi_zero_holes(50);

        // just top
        translate([0,-enclosure_depth - wall_thickness,0]) cube([200+.01, 100, 100]);
    }

    tabs();
}

module clock_front(){
    difference(){
        rotate([90,0,0]) case();
        translate([(clock_x + wall_thickness * 2 - zero_x)/2,                  -enclosure_depth, wall_thickness + zero_z_offset]) raspberry_pi_zero_ports(100);
        translate([(clock_x + wall_thickness * 2 - zero_x)/2, -enclosure_depth + wall_thickness,     wall_thickness]) raspberry_pi_zero_holes(50);

        //whole clock face
        translate([0,-enclosure_depth - wall_thickness*2,0]) cube([300, wall_thickness+.01, 200]);
    }
}

rotate([-90]) clock_front();

rotate([90]) translate([0,enclosure_depth - extra_plate_z - wall_thickness,10]){
    clock_back();
}
//translate([(clock_x + wall_thickness * 2 - zero_x)/2,-enclosure_depth + wall_thickness,wall_thickness + 3]) raspberry_pi_zero();

