//this thing is a shitshow, I just want to say

// globals

left = true;
cols = 5;
ylimit = 4; //ylimit currently rows

// constants

lkey = 19.05;

alpha = 360 / 24;
beta = 360 / 72;

key_height = 127/10;
hole_height = 127/18;
plate_height = 254/45;

tw = 13.969999999999999;// Top width
smh = 0.98044;// Side margin height
pw = 0.8128;// Peg width
ph = 3.5001199999999995;// Peg height
pgh = 5.00888;// Peg gap height

keyswitch_height = smh + ph + pgh + ph + smh;
keyswitch_width = pw + tw + pw;

pillar_height = hole_height + plate_height / 2;
pillar_depth = keyswitch_height + 127/30;
pillar_width = keyswitch_width + 127/45;

full_height = pillar_height + key_height;

row_radius = (pillar_depth / 2) / (sin(alpha / 2)) + full_height-8;
column_radius = (pillar_width / 2) / (sin(beta / 2)) + full_height;

// start key place

//array of column angle insets (extra z distance for each column)
column_insets = [
   0,
   0,
   254/90,
   0,
  -254/90,
  -254/90,
  -254/90,
  -254/90,
  -254/90
];

module key_place(column, row){
  //column_angle = beta * (5 - column);
  column_angle = 
    (column == cols) ? 
    (beta * -0.3) : // -2.2 for right hand, 0.3 for left
    (beta * (5 - column));

  column_inset = column_insets[column];


  column_placed_shape(column_radius, column_angle, column_inset){
    row_placed_shape(row, row_radius){
        children();
    }
  }
}

//end key place


// multiple use functions

module row_placed_shape(row,row_radius){
    translate([0, 0, -row_radius])
    rotate([(alpha * (2 - row)), 0, 0])
    translate([0, 0, row_radius])

    children();
}

module column_placed_shape(column_radius, column_angle, column_inset){
  translate([0, 0, -column_radius])
  rotate([0, column_angle, 0])
  translate([0, 0, column_radius])

  translate([0,0,column_inset])
  children();
}

module limits(){
  difference(){
    cube([1000,1000,1000], center = true);
    children();
  }
}

module switch_cutout(units=1){
    difference(){
        x = 22;
        y = 24.8 - lkey;
        cube([x*units,lkey + y,3], center = true);
        //cube([19,19,19], center = true); // for making sure you have clearance
        cube([14.05,14.05,14], center = true);
    }
}

module hand_array_plate(){


  //these are separate in order to make sure the switch cutouts clip through everything and not just their respective cube
  difference(){
    translate([-40,0,0])
    for (column = [0 : cols]){//cols]){
      for (row = [0 : ylimit]){ // TODO 0
        key_place(column,row){
          if (column == cols){
            switch_cutout(1.5);
            //translate([0,0,-7.5]) cube([28,18,15], center = true);
          }
          else if (column != 0 || row != ylimit){
            switch_cutout(1);
            //translate([0,0,-7.5]) cube([18,18,15], center = true);
          }
        }
      }
    }

    translate([-40,0,0])
    for (column = [0 : cols]){
      for (row = [0 : ylimit]){
        key_place(column,row){
          if (column == cols){
            translate([0,0,-9]) cube([28,18,15], center = true);
          }
          else if (column != 0 || row != ylimit){
            translate([0,0,-9]) cube([18,18,15], center = true);
          }
        }
      }
    }
  }
}

module hand_array_base(){

  translate([-40,0,0])
  for (column = [0 : cols]){//cols]){
    for (row = [0 : ylimit]){
      key_place(column,row){
        if (column == cols){
          switch_pillar(1.5);
        }
        else if (column != 0 || row != ylimit){
          switch_pillar(1);
        }
      }
    }
  }
}

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




//thumb functions

module thumb_switch_cutout(units=1){ // no extra
    difference(){
        cube([lkey*units, lkey,3], center = true);
        cube([14,14,14], center = true);
    }
}


module thumb_array(inset=0){
  translate([0,0,-15])
  rotate([0, 0, 45])
  translate([81,-8.5,0])
  rotate([0,-25,0]){
    translate([19.05 * 0,0,0]) children(0);
    translate([19.05 * 1,0,0]) children(1);
    translate([19.05 * 2,0,0]) children(2);
  }
}

module thumb_array_plate(unit){
    thumb_array(10){
    rotate([0,0,90]) union(){
      translate([unit/2,0,0]) thumb_switch_cutout(2);
      translate([-unit,0,0]) thumb_switch_cutout(1);
    }
    rotate([0,0,90]) union(){
      translate([unit/2,0,0]) thumb_switch_cutout(2);
      translate([-unit,0,0]) thumb_switch_cutout(1);
    }
    rotate([0,0,90]) union(){
      translate([unit,0,0]) thumb_switch_cutout(1);
      translate([0,0,0]) thumb_switch_cutout(1);
      translate([-unit,0,0]) thumb_switch_cutout(1);
    }
  }
}


module clipped_thumb_base(z,inset = 0){
  difference(){
    thumb_array(inset){
      rotate([0,0,90])
      switch_pillar(3,1.5, 0, 0);

      rotate([0,0,90])
      switch_pillar(3,1.5, 0, 0);

      rotate([0,0,90])
      switch_pillar(3,1.5, 0, 0);
    }
    translate([0,0,-20]) limits(){
      cube([1705,1200,z], center = true);
    }
  }
}

module inside_clipped_thumb_base(z, inset=0){
  difference(){
    thumb_array(inset){
      z = 510 ;
      thickness = 1.5;

      translate([thickness/2,0,z/2])
      cube([lkey+1,lkey*3-thickness*3,z], center = true);

      translate([0,0,z/2])
      cube([lkey,lkey*3-thickness*3,z], center = true);

      translate([-thickness/2,0,z/2])
      cube([lkey - thickness,lkey*3-thickness*3,z], center = true);
    }
    translate([0,0,-20]) limits(){
      cube([1705,1200,z], center = true);
    }
  }
}

// end total base

// actual functions
//TODO gonna have to break this guy out for each side
module cave_plate(){

  unit = 19.05;
  hand_array_plate();
  thumb_array_plate(unit);
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
  difference(){
    clipped_hand_base(60);
    
    translate([0,0,-1])
    scale([.95,.91,1]){
      clipped_hand_base(62);
    }

    //to make room for the thumb
    clipped_thumb_base(60, 10);
    trss_hole();
    usb_hole(); // uncomment on left side
  }

  difference(){
    clipped_thumb_base(60, 10);
    inside_clipped_thumb_base(60, 10);
    scale([.95,.91,1]){
      clipped_hand_base(62);
    }
  }
}

// end actual functions

// output

module left(){
  rotate([0,180,0]){
    cave_plate();
    total_base();
  }
}

module right(){
  rotate([0,180,0])
  mirror([1,0,0]){
  cave_plate();
  total_base();
  }
}

if (left) {
  intersection(){
    //translate([-75,75,0]) cube([100,175,1000],center = true);
    left();
  }
} else {
  right();
}