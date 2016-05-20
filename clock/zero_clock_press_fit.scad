// display dimensions (without I2c PCB)
clock_x = 120.5;
clock_y = 41.5;
clock_z = 9.5;

// extra length the plate adds to the clock
extra_plate_y = 10;
extra_plate_z = 1.75;

wall_thickness = 2;
// soft minimum might be 35
enclosure_depth = 50;

//raspi zero dimensions
zero_x = 58.1;
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
zero_z_offset = 5;

// metavariables
total_clock_y = clock_y + extra_plate_y;
total_clock_z = clock_z + extra_plate_z;

// global corner rounding value
$fn = 24;

//bezel inset value
face_bezel_inset = 3;

//actual clock face for fitment purposes
module clock_face(){
    translate([0,extra_plate_y/2,extra_plate_z]) cube([clock_x,clock_y,clock_z]);
    cube([clock_x, total_clock_y, extra_plate_z]);

    translate([face_bezel_inset,extra_plate_y/2+face_bezel_inset,extra_plate_z]) cube([clock_x-face_bezel_inset*2,clock_y-face_bezel_inset*2,clock_z+3]);

    // tilt room
    x = clock_x;
    translate([clock_x/2 - x / 2, clock_y, extra_plate_z]) cube([x,extra_plate_y,3]);
}

// http://goo.gl/cy1eCn
module raspberry_pi_zero(){
    difference(){
        minkowski(){
            mink_z = 0.01;
            cube([zero_x, zero_y, zero_z - mink_z * 2]);
            cylinder(h=mink_z, r = zero_mink_r);
        }
        raspberry_pi_zero_holes(25){
            cylinder(h=height, d=zero_hole_diameter);
        };
    }
    raspberry_pi_zero_ports(10);
}

module raspberry_pi_zero_holes(height){
    //dont have to translate because minkowski
    translate([     0,      0, -wall_thickness]) children();
    translate([zero_x,      0, -wall_thickness]) children();
    translate([     0, zero_y, -wall_thickness]) children();
    translate([zero_x, zero_y, -wall_thickness]) children();
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
            translate([mink_r,mink_r,-clock_z + wall_thickness + mink_r - 2]){
                cube([
                    clock_x + wall_thickness * 2 - mink_r*2,
                    total_clock_y + wall_thickness * 2 - mink_r*2,
                    enclosure_depth + wall_thickness + clock_z - mink_r*2 + 2
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
    // just in case
    slop_x = 0.2;
    slop_y = 0.2;
    slop_z = 0;

    tab_x = wall_thickness;
    tab_y = 10;
    tab_z = 10 + zero_z_offset;

    // bottom right
    translate([wall_thickness + slop_x, -(enclosure_depth + wall_thickness) + slop_y, wall_thickness]) cube([tab_x,tab_y,tab_z]);
    // bottom left
    translate([clock_x + wall_thickness - tab_x - slop_x, -(enclosure_depth + wall_thickness) + slop_y, wall_thickness]) cube([tab_x,tab_y,tab_z]);

    // top right
    translate([wall_thickness + slop_x, -(wall_thickness + extra_plate_z + tab_y + slop_y), wall_thickness]) cube([tab_x,tab_y,tab_z]);
    // top left
    translate([clock_x + wall_thickness - tab_x - slop_x, -(wall_thickness + extra_plate_z + tab_y + slop_y), wall_thickness]) cube([tab_x,tab_y,tab_z]);
}




// actual two outputs


module clock_bottom(){
    intersection(){
        union(){
            difference(){
                union(){
                    difference(){
                        rotate([90,0,0]) case();
                        translate([0,-enclosure_depth - wall_thickness*2,wall_thickness + (extra_plate_y)/2 + face_bezel_inset]) cube([200, 100, 100]);
                    }
                    translate([
                        (clock_x + wall_thickness * 2 - zero_x)/2,
                        -enclosure_depth + wall_thickness,
                        wall_thickness
                    ]) {
                        raspberry_pi_zero_holes(25){
                            cylinder(h=zero_z_offset + wall_thickness, d=zero_hole_diameter+2);
                            cylinder(h=zero_z_offset + wall_thickness + 5, d=zero_hole_diameter - .325);
                        }
                    }
                }
                translate([(clock_x + wall_thickness * 2 - zero_x)/2,-enclosure_depth,wall_thickness + zero_z_offset]) raspberry_pi_zero_ports(100);

                // just top
                
            }
            tabs();
        }
        //TODO get rid of this
        //translate([20,-50,0]) cube([80,30,100]);
    }
}

module clock_body(){
    difference(){
        rotate([90,0,0]) case();
        translate([(clock_x + wall_thickness * 2 - zero_x)/2, -enclosure_depth, wall_thickness + zero_z_offset]) raspberry_pi_zero_ports(100);
        tabs();
        //whole clock face
        translate([0,-enclosure_depth - wall_thickness*2, -200 + wall_thickness + .01 + (extra_plate_y)/2 + face_bezel_inset]) cube([300, 200, 200]);
    }

}

//rotate([90,0,180]) translate([-clock_x - wall_thickness,wall_thickness,-wall_thickness - extra_plate_z]){ clock_face();}

//pretty sure y is a made up number
translate([clock_x + wall_thickness*2,enclosure_depth + wall_thickness *2 + clock_z + 10,total_clock_y + wall_thickness * 2]) rotate([0,180]) clock_body();
//clock_body();
clock_bottom();

//translate([(clock_x + wall_thickness * 2 - zero_x)/2,-enclosure_depth + wall_thickness,wall_thickness + 3]) raspberry_pi_zero();

