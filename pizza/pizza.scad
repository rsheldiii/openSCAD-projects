union(){
  intersection(){
    cube(1000);
    rotate([0, 0, 45]){
      cube(1000);
    };
    difference(){
      union(){
        cylinder(, h=10, r=165, $fn=120);
        translate([0, 0, 10]){
          difference(){
            cylinder(, h=20, r=165, $fn=120);
            cylinder(, h=20, r=155, $fn=120);
          };
        };
        translate([0, 0, 30]){
          difference(){
            cylinder(, h=3, r=165, $fn=120);
            cylinder(, h=3, r=158.33333333333334, $fn=120);
          };
        };
        rotate([0, 0, 0]){
          translate([0, 0, 0]){
            translate([0, 0, 20]){
              cube([10, 320, 20], true);
            };
          };
        };
        rotate([0, 0, -45]){
          translate([0, 0, 0]){
            translate([0, 0, 20]){
              cube([10, 320, 20], true);
            };
          };
        };
        rotate([0, 0, 0]){
          translate([0, 0, 0]){
            translate([0, 0, 31.5]){
              cube([6.666666666666667, 320, 3], true);
            };
          };
        };
        rotate([0, 0, -45]){
          translate([0, 0, 0]){
            translate([0, 0, 31.5]){
              cube([6.666666666666667, 320, 3], true);
            };
          };
        };
      };
      difference(){
        cylinder(, h=3, r=166.66666666666666, $fn=120);
        cylinder(, h=3, r=161.66666666666666, $fn=120);
      };
      rotate([0, 0, 0]){
        translate([0, 0, 0]){
          translate([0, 0, 1.5]){
            cube([6.666666666666667, 332, 3], true);
          };
        };
      };
      rotate([0, 0, -45]){
        translate([0, 0, 0]){
          translate([0, 0, 1.5]){
            cube([6.666666666666667, 332, 3], true);
          };
        };
      };
    };
  };
};
