//this thing is a shitshow, I just want to say

// globals

right = true;
cols = 5;
rows = 4;

// constants
unit = 19.05;
// row rotation angle. determines how much each row rotates compared to the last
alpha = 15;
// column rotation angle. you guessed it
beta = 6;

// I assume, the height of a key
key_height = 12.5;
hole_height = 7;
plate_height = 5.75;

// these are measurements for the actual keyswitch plates - the squares we position to accept a keyswitch
keyswitch_height = 19;
keyswitch_width = 19;

pillar_height = hole_height + plate_height / 2;
pillar_depth = keyswitch_height;
pillar_width = keyswitch_width;

full_height = pillar_height + key_height;

row_radius = (pillar_depth / 2) / (sin(alpha / 2)) + full_height-8;
column_radius = (pillar_width / 2) / (sin(beta / 2)) + full_height;

// start key place

//array of column angle insets (extra z distance for each column)
column_insets = [
   0,
   0,
   -254/90,
   0,
  254/90,
  254/90,
  254/90,
  254/90,
  254/90
];

// multiple use functions

module row_placed_shape(row,row_radius){
    translate([0, 0, row_radius])
    rotate([alpha * (row), 0, 0])
    translate([0, 0, -row_radius])

    children();
}

module column_placed_shape(column, column_radius, column_inset){
  //column_angle = beta * (5 - column);
  column_angle = (beta * (column - 5) + (column == cols ? 2 : 0));

  translate([0, 0, column_radius])
  rotate([0, column_angle, 0])
  translate([0, 0, -column_radius])
  translate([0,0,column_inset])
  children();
}

module key_place(column, row){
  column_inset = column_insets[column];

  column_placed_shape(column, column_radius, column_inset){
    row_placed_shape(row - 2, row_radius){
        children();
    }
  }
}

//end key place

// bounding box. also helps shape the case
module limits(){
  difference(){
    cube([1000,1000,1000], center = true);
    children();
  }
}

module switch_cutout(units=1){
  difference(){
    cube([unit*units,unit,3], center = true);
    cube([14.05,14.05,14], center = true);
  }
}

module hand_array_plate(){
  for (column = [0 : cols]){
    for (row = [0 : rows]){
      key_place(column,row){
        if (column == cols){
          switch_cutout(1.5);
        } else if (!(column == 0 && row == 0)){
          switch_cutout(1);
        }
      }
    }
  }
}

module hand_array_base(){
  for (column = [0 : cols]){
    for (row = [0 : rows]){
      key_place(column,row){
        if (column == cols){
          switch_pillar(1.5);
        }
        else if (column != 0 || row != rows){
          switch_pillar(1);
        }
      }
    }
  }
}

//large pillar-like structure put underneath each switch to make a base
module switch_pillar(units=1, scle = 3, extrax = 2.95, extray = 5.75){
  z = 100;
  linear_extrude(height = z, scale = scle){
    unit = 19.05;
    square([(unit + extrax) * units,unit + extray], center = true);
  }
}

//end multiple use functions

//start total base

module clipped_hand_base(z){
  difference(){
    hand_array_base();
    translate([-27.5,0,-20]) limits(){
      difference(){
        cube([205,125,z], center = true);
        translate([40,0,0]) rotate([0,0,45]) translate([94,0,0]) cube([60,60,z], center = true);
      }
    };
  }
}

module thumb_array_plate(){
  translate([25,27,44]){
    rotate([20,15,-15]) {
      key_place(0, 0.5) {
        rotate([0,0,90]) switch_cutout(2);
      }

      key_place(-1, 0.5) {
        rotate([0,0,90])
        switch_cutout(2);
      }

      key_place(-2, 0) {
        switch_cutout(1);
      }

      key_place(-2, 1) {
        switch_cutout(1);
      }
    }
  }
}

module thumb_place(column, row){
  translate([0, 0, row_radius]) {
    rotate([alpha * row, 0, 0]){
      translate([0, 0, -row_radius]){
        translate([0, 0, column_radius]) {
          rotate([0, column * beta, 0]){
            translate([0, 0, -column_radius]){
              translate([keyswitch_width + 3, 0, 0]){
                rotate([-15, -15, -11.25]) {
                  translate([52, -45, 40]){
                    children();
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

// end total base

// actual functions
//TODO gonna have to break this guy out for each side
module cave_plate(){
  hand_array_plate();
  thumb_array_plate();
}

module trss_hole(){
  translate([-19 - 5,-45,0]) rotate([0,90,0]) {
    cylinder(d=7,h=100, $fn=24);
    translate([0,0,-2 +50]) cube([5,11,100], center = true);
  }
}

module usb_hole(){
  //translate([80,-30,0])
  //cube([10,10,5], center = true);
}

module total_base(){
  /* difference(){

    // get rid of base for now
    clipped_hand_base(60);
    translate([0,0,-1]){
      scale([.95,.91,1]){
        clipped_hand_base(62);
      }
    }

    trss_hole();
    usb_hole(); // uncomment on left side
  }

  difference(){
    scale([.95,.91,1]){
      clipped_hand_base(62);
    }
  } */
}

// end actual functions

// output

if (right) {
  mirror([1,0,0]) {
    cave_plate();
    total_base();
  }
} else {
  cave_plate();
  total_base();
}
