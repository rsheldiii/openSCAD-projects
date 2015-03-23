// Row 5? Cherry MX key
//change to round things better
$fn = 64;

//scale of inner to outer shape
key_wall_thickness_width =  .8;
key_wall_thickness_height = .8;
key_wall_thickness_depth =  .8;
//length in units of key
key_length = 1;

// dimensions of cross
// horizontal cross bar width
horizontal_cross_width = 1.4;
// vertical cross bar width
vertical_cross_width = 1.3;
// cross length
cross_length = 4.4;
//extra vertical cross length - change if you dont want the cruciform to be in 2 parts
extra_vertical_cross_length = 2;

//dimensions of connector
// outer cross extra length in x
extra_outer_cross_width = 2.11;
// outer cross extra length in y
extra_outer_cross_height = 1.1;
// cross depth, stem height is 3.4mm
cross_depth = 4;

//connector brim
//enable brim for connector
has_brim = 0;
//brim radius
brim_radius = 6;
//brim depth
brim_depth = .3;

//keycap type, [0..6]
key_type = 1;


//profile specific stuff

/*god, I would love a class right here
 here we have, for lack of a better implementation, an array
 that defines the more intimate aspects of a key.
 order is thus:
 1. Bottom Key Width: width of the immediate bottom of the key
 2. Bottom Key Height: height of the immediate bottom of the key
 3. Top Key Width Difference: mm to subtract from bottom key width to create top key width
 4. Top Key Height Difference: mm to subtract from bottom key height to create top key height
 5. total Depth: how tall the total in the switch is before dishing
 6. Top Tilt: X rotation of the top. Top and dish obj are rotated
 7. Top Skew: Y skew of the top of the key relative to the bottom. DCS has some, DSA has none (its centered)
 8. Dish Type: type of dishing. currently sphere and cylinder
 9. Dish Depth: how many mm to cut into the key with
 10. Dish Radius: radius of dish obj, the Sphere or Cylinder that cuts into the keycap
*/

key_profiles = [

	//DCS Profile

	[ //DCS ROW 5...erm...ish
		18.16,  // Bottom Key Width
		18.16,  // Bottom Key Height
		6,   // Top Key Width Difference
		4,   // Top Key Height Difference
		11.5, // total Depth
		-6,  // Top Tilt
		1.75,// Top Skew

		//Dish Profile

		0,   // Dish Type
		1,   // Dish Depth
		40,  // Dish Radius
		0,   // Dish Skew X
		0    // DIsh Skew Y
	],
	[ //DCS ROW 1
		18.16,  // Bottom Key Width
		18.16,  // Bottom Key Height
		6,   // Top Key Width Difference
		4,   // Top Key Height Difference
		8.5, // total Depth
		-1,  // Top Tilt
		1.75,// Top Skew

		//Dish Profile

		0,   // Dish Type
		1,   // Dish Depth
		40,  // Dish Radius
		0,   // Dish Skew X
		0    // DIsh Skew Y
	],
	[ //DCS ROW 2
		18.16,  // Bottom Key Width
		18.16,  // Bottom Key Height
		6.2,   // Top Key Width Difference
		4,   // Top Key Height Difference
		7.5, // total Depth
		3,  // Top Tilt
		1.75,// Top Skew

		//Dish Profile

		0,   // Dish Type
		1,   // Dish Depth
		40,  // Dish Radius
		0,   // Dish Skew X
		0    // DIsh Skew Y
	],
	[ //DCS ROW 3
		18.16,  // Bottom Key Width
		18.16,  // Bottom Key Height
		6,   // Top Key Width Difference
		4,   // Top Key Height Difference
		6.2, // total Depth
		7,  // Top Tilt
		1.75,// Top Skew

		//Dish Profile

		0,   // Dish Type
		1,   // Dish Depth
		40,  // Dish Radius
		0,   // Dish Skew X
		0    // DIsh Skew Y
	],
	[ //DCS ROW 4
		18.16,  // Bottom Key Width
		18.16,  // Bottom Key Height
		6,   // Top Key Width Difference
		4,   // Top Key Height Difference
		6.2, // total Depth
		16,  // Top Tilt
		1.75,// Top Skew

		//Dish Profile

		0,   // Dish Type
		1,   // Dish Depth
		40,  // Dish Radius
		0,   // Dish Skew X
		0    // DIsh Skew Y
	],

	//DSA Profile

	[ //DSA ROW 3
	  18.4,  // Bottom Key Width
	  18.4,  // Bottom Key Height
	  5.7, // Top Key Width Difference
	  5.7, // Top Key Height Difference
	  7.4, // total Depth
	  0,   // Top Tilt
	  0,   // Top Skew

	  //Dish Profile

	  1,   // Dish Type
	  1.2, // Dish Depth
	  40,   // Dish Radius
	  0,   // Dish Skew X
		0    // DIsh Skew Y
	],

	//SA Proile

	[ //SA ROW 1
		18.4,  // Bottom Key Width
	  18.4,  // Bottom Key Height
	  5.7, // Top Key Width Difference
	  5.7, // Top Key Height Difference
	  13.73, // total Depth, fudged
	  0,   // Top Tilt
	  0,   // Top Skew

	  //Dish Profile

	  1,   // Dish Type
	  2, // Dish Depth
	  30,   // Dish Radius
		3,   // Dish Skew X
		0    // DIsh Skew Y
	],
	[ //SA ROW 2
		18.4,  // Bottom Key Width
	  18.4,  // Bottom Key Height
	  5.7, // Top Key Width Difference
	  5.7, // Top Key Height Difference
	  11.73, // total Depth
	  0,   // Top Tilt
	  0,   // Top Skew

	  //Dish Profile

	  1,   // Dish Type
	  2, // Dish Depth
	  30,   // Dish Radius
		3,   // Dish Skew X
		0    // DIsh Skew Y
	],
	[ //SA ROW 3
		18.4,  // Bottom Key Width
	  18.4,  // Bottom Key Height
	  5.7, // Top Key Width Difference
	  5.7, // Top Key Height Difference
	  11.73, // total Depth
	  0,   // Top Tilt
	  0,   // Top Skew

	  //Dish Profile

	  1,   // Dish Type
	  1.6, // Dish Depth
	  30,   // Dish Radius
		0,   // Dish Skew X
		0    // DIsh Skew Y
	],
	[ //SA ROW 4
		18.4,  // Bottom Key Width
	  18.4,  // Bottom Key Height
	  5.7, // Top Key Width Difference
	  5.7, // Top Key Height Difference
	  11.73, // total Depth
	  0,   // Top Tilt
	  0,   // Top Skew

	  //Dish Profile

	  1,   // Dish Type
	  2, // Dish Depth
	  30,   // Dish Radius
		-3,   // Dish Skew X
		0    // DIsh Skew Y
	]
];

//libraries
//centered
module roundedRect(size, radius) {
	x = size[0];
	y = size[1];
	z = size[2];

	translate([-x/2,-y/2,0])
	linear_extrude(height=z)
	hull() {
		translate([radius, radius, 0])
		circle(r=radius);

		translate([x - radius, radius, 0])
		circle(r=radius);

		translate([x - radius, y - radius, 0])
		circle(r=radius);

		translate([radius, y - radius, 0])
		circle(r=radius);
	}
}

//end libraries

//dish selector
module dish(key_profile){
	total_depth = key_profile[4];
	top_tilt = key_profile[5];
	top_skew = key_profile[6];
	dish_type = key_profile[7];
	dish_depth = key_profile[8];
	dish_radius = key_profile[9];
	dish_skew_x = key_profile[10];
	dish_skew_y = key_profile[11];

	if(dish_type == 0){
		translate([dish_skew_x, top_skew + dish_skew_y, total_depth])
		rotate([90-top_tilt,0,0])
		translate([0,dish_radius-dish_depth,0])
		scale([key_length,1,1])
		cylinder(h=100,r=dish_radius, $fn=1024, center=true);
	}
	else {
		translate([dish_skew_x, top_skew + dish_skew_y, total_depth])
		rotate([90-top_tilt,0,0])
		translate([0,dish_radius-dish_depth,0])
		scale([key_length,1,1])
		sphere(r=dish_radius, $fn=256);
	}
}

//i h8 u scad
module shape(key_profile){

	bottom_key_width = key_profile[0];
	bottom_key_height = key_profile[1];
	top_key_width_difference = key_profile[2];
	top_key_height_difference = key_profile[3];
	total_depth = key_profile[4];
	top_tilt = key_profile[5];
	top_skew = key_profile[6];

  difference(){
		hull(){
			roundedRect([bottom_key_width*key_length,bottom_key_height,.001],1.5);

			translate([0,top_skew,total_depth])
			rotate([-top_tilt,0,0])
			roundedRect([bottom_key_width*key_length-top_key_width_difference,bottom_key_height-top_key_height_difference,.001],1.5);
		}
		dish(key_profile);
	}
}

// inside of connector
module cross(){
    translate([0,0,(cross_depth)/2])
    union(){
        cube([vertical_cross_width,cross_length+extra_vertical_cross_length,cross_depth], center=true );//remove +2 to print with cross
        cube([cross_length,horizontal_cross_width,cross_depth], center=true );
    }
}

//whole connector
module connector(key_profile,has_brim){
	difference(){
		difference(){
			union(){
				translate(
					[
		 			-(cross_length+extra_outer_cross_width)/2,
		 			-(cross_length+extra_outer_cross_height)/2,
		 			0
					]
				)
				cube([cross_length+extra_outer_cross_width,cross_length+extra_outer_cross_height,50]);
				if (has_brim == 1){ cylinder(r=brim_radius,h=brim_depth); }
			}
			cross();
		}
		bottom(key_profile);
	}
}

//bottom we can use to anchor things
module bottom(key_profile)
{
	difference(){
		translate([0,0,50])
		cube([100,100,100],center=true);

		translate([0,0,-.1])
		scale([key_wall_thickness_width,key_wall_thickness_height,key_wall_thickness_depth])
		shape(key_profile);
	}
}

//actual full key with space carved out and keystem
module key(key_profile){
	union(){
		difference(){
			shape(key_profile);

			translate([0,0,-.1])
			scale([key_wall_thickness_width,key_wall_thickness_height,key_wall_thickness_depth])
			shape(key_profile);
		}
		connector(key_profile,has_brim);
	}
}


key(key_profiles[key_type]);
