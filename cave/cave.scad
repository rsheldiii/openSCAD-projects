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

full_height = pillar_height + key_height + 127/450;


// start key place

//array of column angle offsets
column_offsets = [
  [0, 0, 0],
  [0, 0, 0],
  [0, 0, 254/90],
  [0, 0, 0],
  [0, 0, -254/90],
  [0, 0, -254/90],
  [0, 0, -254/90],
  [0, 0, -254/90],
  [0, 0, -254/90]
];

module key_place(column, row){
  row_radius = (pillar_depth / 2) / (sin(alpha / 2)) + full_height;
  column_radius = ((pillar_width + 127/90) / 2) / (sin(beta / 2)) + full_height;

  
  //column_angle = beta * (5 - column);
  column_angle = 
    (column == 7) ? 
    (beta * -2.25) :
    (beta * (5 - column));

  column_offset = column_offsets[column];


  column_placed_shape(column_radius, column_angle, column_offset){
    row_placed_shape(row, row_radius){
        children();
    }
  }
}

module row_placed_shape(row,row_radius){
    translate([0, 0, -row_radius])
    rotate([(alpha * (2 - row)), 0, 0])
    translate([0, 0, row_radius])

    children();
}

module column_placed_shape(column_radius, column_angle, column_offset){
  translate([0, 0, -column_radius])
  rotate([0, column_angle, 0])
  translate([0, 0, column_radius])

  translate(column_offset)
  children();
}

//end key place


// multiple use functions

module limits(){
  difference(){
    cube([1000,1000,1000], center = true);
    children();
  }
}

module switch_cutout(units=1){
    difference(){
        x = 22;
        unit = 19.05;
        y = 24.8 - unit;
        cube([x*units,unit + y,3], center = true);
        //cube([19,19,19], center = true);
        cube([14,14,14], center = true);
    }
}

module thumb_switch_cutout(units=1){
    difference(){
        x = 19.05;
        y = 19.05;

        cube([x*units, y,3], center = true);
        cube([14,14,14], center = true);
    }
}

module hand_array_plate(){
  xlimit = 7;
  ylimit = 4;

  translate([-40,0,0])
  for (column = [0 : xlimit]){
    for (row = [0 : ylimit]){
      key_place(column,row){
        if (column == xlimit){
          switch_cutout(1.5);
        }
        else if (column != 0 || row != 4){
          switch_cutout(1);
        }
      }
    }
  }
}

module hand_array_base(){
  xlimit = 7;
  ylimit = 4;

  translate([-40,0,0])
  for (column = [0 : xlimit]){
    for (row = [0 : ylimit]){
      key_place(column,row){
        if (column == xlimit){
          switch_pillar(1.5);
        }
        else if (column != 0 || row != 4){
          switch_pillar(1);
        }
      }
    }
  }
}

module thumb_array(){
  translate([62,57,-30])
  rotate([0,-20, 25])
  actual_thumb(){
    children(0);
    children(1);
    children(2);
  }
}

module switch_pillar(units=1){
  scle=3;
  xunits = 1;
  z = 100;
  linear_extrude(height = z, scale = scle){
    unit = 19.05;
    y = 24.8 - 19.05;

    square([22 * units,unit + y], center = true);
  }
}

//end multiple use functions

//start total base

module clipped_hand_base(z){
  difference(){
    hand_array_base();
    translate([-27.5,0,-20]) limits(){
      cube([215,135,z], center = true);
    };
  }
}

module clipped_thumb_base(z){
  difference(){
    thumb_array(){
      z = 51;
      unit = 19.05;

      translate([0,0,z/2])
      cube([unit,unit*2,z], center = true);

      translate([0,0,z/2])
      cube([unit,unit*2,z], center = true);

      translate([0,0,z/2])
      cube([unit,unit*2,z], center = true);
    }
    translate([0,0,-20]) limits(){
      cube([1705,1200,z], center = true);
    }
  }
}

module inside_clipped_thumb_base(z){
  difference(){
    thumb_array(){
      z = 51 ;
      thickness = 2.5;
      unit = 19.05;

      translate([thickness/2,0,z/2])
      cube([unit - thickness,unit*2-thickness*3,z], center = true);

      translate([0,0,z/2])
      cube([unit,unit*2-thickness*3,z], center = true);

      translate([-thickness/2,0,z/2])
      cube([unit - thickness,unit*2-thickness*3,z], center = true);
    }
    translate([0,0,-20]) limits(){
      cube([1705,1200,z], center = true);
    }
  }
}

// end total base


//start thumb

module thumb_place(column, row){
  translate([19.05 * column,0,0])
  children();
}

module actual_thumb(){
  thumb_place(0, 0){children(0);}
  thumb_place(1, 0){children(1);}
  thumb_place(2, 0){children(2);}
}

// end thumb

// actual functions

module cave_plate(){
  hand_array_plate();

  thumb_array(){
    rotate([0,0,90]) thumb_switch_cutout(2);
    rotate([0,0,90]) thumb_switch_cutout(2);
    rotate([0,0,90]) thumb_switch_cutout(2);
  }
}

module total_base(){
  difference(){
    clipped_hand_base(60);
    
    translate([0,0,-1])
    scale([.95,.91,1]){
      clipped_hand_base(62);
    }

    //to make room for the thumb
    clipped_thumb_base(60);
  }

  difference(){
    clipped_thumb_base(60);
    inside_clipped_thumb_base(60);
    scale([.95,.91,1]){
      clipped_hand_base(62);
    }
  }
}

// end actual functions

// output

mirror([1,0,0]){
cave_plate();
total_base();
}
