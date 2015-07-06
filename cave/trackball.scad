$fn=24;

size = 78;

height = 15;
thickness = 2;
angle = 17.5;


module pegs(){
	location(){
		peg();
	}
}

module peg(){
	difference() {
		cylinder(h = 7, d = 4.2);
		cylinder(h = 7, d = 1.5);
	}
}

module location(){
	translate([-31.215/2, 2.15, 0])
    children();
	translate([31.215/2, 2.15, 0])
	children();
	translate([-0.275, -19.15, 0])
	children();
}

//the tilted top surface with a hole cut out
module case(){
	translate([0,0,height])
	rotate([angle,0,0])
	difference(){
		cube([size,size,thickness], center = true);
		cylinder(d = 62, h = thickness, center = true, $fn = 96);
	}
}

//the four walls of the outside box I believe
module outside(){
    difference(){
      linear_extrude(h=50){
        rotate([angle,0,0]) 
        square([size,size], center = true);
      }
      
      linear_extrude(h=60){
        rotate([angle,0,0]) 
        translate([0,1,0]) square([size-2,size-1], center = true);
      }
  }
}

//the total bottom, including the platform for the stilts
module bottom(){
	difference(){
	    outside();
	    translate([0,0,height]) rotate([angle,0,0]) translate([0,0,50]) cube([602,602,100], center = true);
	}
    
    	hull(){
		location(){
			cylinder(d = 5, h = 2);
		}
        
        translate([-0.275, -36, 0])cube([38.5,10,2]);
	};
}

pegs();
case();
bottom();