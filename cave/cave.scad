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

module key_place(column, row){
  row_radius = (pillar_depth / 2) / (sin(alpha / 2)) + full_height;

  column_radius = ((pillar_width + 127/90) / 2) / (sin(beta / 2)) + full_height;

  column_offset = [0,0,0];
  /*
  column_offset = 
        (column == 2) ? [0, 127/45, 254/90] :
        (column == 3) ? [0, 0, 0] :
        (column == 4) ? [0, -pillar_depth/3, -254/90] :
        (column >= 5) ? [0, -pillar_depth/4, -254/90] :
        [0, 0, 0];/**/

  //column_angle = (column <=4) ? (beta * (2 - column)) : (beta * -3.25);

  column_angle = beta * (2 - column);

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



module shape(){
    difference(){
        x = 22;
        y = 24.8;
        cube([x,y,3], center = true);
        //cube([19,19,19], center = true);
        cube([14,14,14], center = true);
    }
}

module tall_shape(){
  z = 100;
  translate([0,0,z/2]) cube([22,24.8,z], center = true);
}

//end key place




//thumb place

module thumb_place(column, row){
  row_radius = ((pillar_depth / 2) / (sin (alpha / 2))) + full_height;
  column_radius = (((pillar_width + 5) / 2 ) / (sin(beta / 2))) + full_height;

  translate([0, 0, -row_radius])
  rotate([row * alpha, 0, 0])
  translate([0, 0, row_radius])

  translate([0, 0, -column_radius])
  rotate([0, column * beta/1.2, 0])
  translate([0, 0, column_radius])

  children();
}

module thumb_2x_column(){
  thumb_place(0, -1/2){
   children();
  }
}

module thumb_1x_column(){
  thumb_place(1, -1/2){
   children();
  }
  thumb_place(1, 1){
   children();
  }
}

module thumb_2x_plus_1_column(){
  thumb_place(2,-1){
   children();
  }
  thumb_place(2,0){
   children();
  }
  thumb_place(2,1){
   children();
  }
}

module thumb_layout(){
  thumb_1x_column(){children();}
  thumb_2x_column(){children();}
  thumb_2x_plus_1_column(){children();}
}

module actual_thumb(){
  rotate([5,10])//
  translate([30,20,-50])
  translate([pillar_width, 0, 0])
  rotate([0, alpha, 0])
  rotate([0, 0, 33.75])
  rotate([-alpha, alpha, 0])
  translate([254/45, 127/15, 1778/45])
  thumb_layout(){children();};
}

module cave(){
  shape_array(){
    shape();
  }
}

module limits(x,y,z){
  difference(){
    cube([1000,1000,1000], center = true);
    cube([x,y,z], center = true);
  }
}

module shape_array(){
  mirror([1,0,0]){
    //actual output
    rotate([0,15,0])//
    for (column = [0 : 7]){
      for (row = [0 : 4]){
        key_place(column,row){
          //if (column != 0 || row != 4){
            children();
          //}
        }
      }
    }
    translate([0, 0, -254/30])
    //translate([-6731/90+10,-5461/90-10, 0])
    actual_thumb(){
      //children();
    }
  }
}

translate([-40,0,0]) cave();

module base(){
  shape_array(){
    z = 100;
    linear_extrude(height = z, scale = 3){
      square([22,24.8], center = true);
    }
  }
}


module clipped_base(z){
  translate([-40,0,0])
  difference(){
    base();
    translate([32.5,0,-15]) limits(185,130,z);
  }
}

difference(){
  clipped_base(60);
  translate([0,0,-1])
  scale([.95,.91,1]){
    clipped_base(62);
  }
}