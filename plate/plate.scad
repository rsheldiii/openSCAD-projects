// Thickness of entire plate
plate_thickness=3;
// Unit square length, from Cherry MX data sheet
unit=19.05;
// Hole size. 14 is standard
hole_size=14.2;


// length, in units, of board
width_in_units=15;
// Height, in units, of board
height_in_units=5;

// Radius of mounting holes
mounting_hole_radius=2;

// whether to use the fancy cutout switches
fancy_hole = false;


// height of switch clasp cutouts
cutout_height = 3;
// width of switch clasp cutouts
cutoutwidth = 1;

//calculated vars
width=width_in_units*unit;
height=height_in_units*unit;

sixty_percent_holes = [[1+1/3,3.5], [13+2/3,3.5], [6.75,2.5], [6.75,2.5], [14.8,2], [.2,2], [10,0.5]];

module plate(width, height, thickness){
	cube([width,height,thickness]);
}

module switch_hole(){
	cube([hole_size,hole_size,plate_thickness]);

	if(fancy_hole){
		translate([-cutoutwidth,1,0])
		cube([hole_size+2*cutoutwidth,cutout_height,plate_thickness]);

		translate([-cutoutwidth,hole_size-cutoutwidth-cutout_height,0])
		cube([hole_size+2*cutoutwidth,cutout_height,plate_thickness]);
	}
}

module hole_matrix(holes,startx,starty){
	for (key = holes){
		translate([startx+unit*key[0], starty-unit*key[1], 0]){
			translate([(unit*key[2]-hole_size)/2,(unit - hole_size)/2, 0]){
				switch_hole();
			}
		}
	}
}

module mounting_holes(holes){
	for (hole = holes) {
		translate([hole[0] * unit, hole[1] * unit]) {
			cylinder(h=plate_thickness,r=mounting_hole_radius, $fn=12);
		}
	}
}

module full_plate(width, height, key_holes, mounting_holes=sixty_percent_holes){
	difference(){
		plate(width,height);
		hole_matrix(key_holes,0,height-unit);
		mounting_holes(mounting_holes);
	}
}
