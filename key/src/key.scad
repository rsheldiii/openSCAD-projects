// files
include <shapes.scad>
include <stems.scad>
include <dishes.scad>
include <libraries/geodesic_sphere.scad>

/* [Fancy Bowed Sides] */


// if you're doing fancy bowed keycap sides, this controls how many slices you take
// default of 1 for no sampling, just top/bottom
height_slices = 1;
enable_side_sculpting = false;




/* [Hidden] */
$fs = .1;
//beginning to use unit instead of baked in 19.05
unit = 19.05;
//minkowski radius. radius of sphere used in minkowski sum for minkowski_key function. 1.75 default for faux G20
$minkowski_radius = .33;




// derived values. can't be variables if we want them to change when the special variables do

// actual mm key width and height
function total_key_width() = $bottom_key_width + unit * ($key_length - 1);
function total_key_height() = $bottom_key_height + unit * ($key_height - 1);

// actual mm key width and height at the top
function top_total_key_width() = $bottom_key_width + (unit * ($key_length - 1)) - $width_difference;
function top_total_key_height() = $bottom_key_height + (unit * ($key_height - 1)) - $height_difference;

// side sculpting functions
// bows the sides out on stuff like SA and DSA keycaps
function side_sculpting(progress) = (1 - progress) * 2.5;
// makes the rounded corners of the keycap grow larger as they move upwards
function corner_sculpting(progress) = pow(progress, 2);


// key shape including dish. used as the ouside and inside shape in key()
module shape(thickness_difference, depth_difference){
	intersection(){
		dished(depth_difference, $inverted_dish) {
			color([.2667,.5882,1]) shape_hull(thickness_difference, depth_difference);
		}
		if ($inverted_dish) {
			// larger shape_hull to clip off bits of the inverted dish
			color([.5412, .4784, 1]) shape_hull(thickness_difference, 0, 2);
		}
	}
}

// shape of the key but with soft, rounded edges. much more realistic, MUCH more complex. orders of magnitude more complex
module rounded_shape() {
	render(){
		minkowski(){
			// half minkowski. that means the shape is neither circumscribed nor inscribed.
			shape($minkowski_radius * 2, $minkowski_radius/2);
			difference(){
				sphere(r=$minkowski_radius, $fn=24);
				translate([0,0,-$minkowski_radius])
				cube([2*$minkowski_radius,2*$minkowski_radius,2*$minkowski_radius], center=true);
			}
		}
	}
}

// basic key shape, no dish, no inside
// which is only used for dishing to cut the dish off correctly
// $height_difference used for keytop thickness
// extra_slices is a hack to make inverted dishes still work
module shape_hull(thickness_difference, depth_difference, extra_slices = 0){
	render() {
		if ($linear_extrude_shape) {
				linear_extrude_shape_hull(thickness_difference, depth_difference, extra_slices);
		} else {
			hull_shape_hull(thickness_difference, depth_difference, extra_slices);
		}
	}
}

//corollary is shape_hull
// extra_slices unused, only to match argument signatures
module linear_extrude_shape_hull(thickness_difference, depth_difference, extra_slices = 0){

	height = $total_depth - depth_difference;
	width_scale = top_total_key_width() / total_key_width();
	height_scale = top_total_key_height() / total_key_height();

	translate([0,$linear_extrude_height_adjustment,0]){
		linear_extrude(height = height, scale = [width_scale, height_scale]) {
	 	 	translate([0,-$linear_extrude_height_adjustment,0]){
				key_shape(total_key_width(), total_key_height(), thickness_difference, thickness_difference, $corner_radius);
			}
		}
	}
}

module hull_shape_hull(thickness_difference, depth_difference, extra_slices = 0) {
	slices = 10;
	for (index = [0:$height_slices - 1 + extra_slices]) {
		hull() {
			shape_slice(index / $height_slices, thickness_difference, depth_difference);
			shape_slice((index + 1) / $height_slices, thickness_difference, depth_difference);
		}
	}
}

module shape_slice(progress, thickness_difference, depth_difference) {
	// makes the sides bow
	extra_side_size =  $enable_side_sculpting ? side_sculpting(progress) : 0;
	// makes the rounded corners of the keycap grow larger as they move upwards
	extra_corner_size = $enable_side_sculpting ? corner_sculpting(progress) : 0;

	// computed values for this slice
	extra_width_this_slice = ($width_difference - extra_side_size) * progress;
	extra_height_this_slice = ($height_difference - extra_side_size) * progress;
	skew_this_slice = $top_skew * progress;
	depth_this_slice = ($total_depth - depth_difference) * progress;
	tilt_this_slice = -$top_tilt / $key_height * progress;

	translate([0, skew_this_slice, depth_this_slice]) {
		rotate([tilt_this_slice,0,0]){
			linear_extrude(height = 0.001){
				key_shape(
					total_key_width(),
					total_key_height(),
					thickness_difference+extra_width_this_slice,
					thickness_difference+extra_height_this_slice,
					$corner_radius + extra_corner_size
				);
			}
		}
	}
}

module dished(depth_difference, inverted = false) {
	if (inverted) {
		union() {
			children();
			translate([$dish_skew_x, $top_skew + $dish_skew_y, $total_depth - depth_difference]){
				color([.4078, .3569, .749]) dish(top_total_key_width() + $dish_overdraw_width, top_total_key_height() + $dish_overdraw_height, $dish_depth, $inverted_dish, $top_tilt / $key_height);
			}
		}
	} else {
		difference() {
			children();
			translate([$dish_skew_x, $top_skew + $dish_skew_y, $total_depth - depth_difference]){
				color([.4078, .3569, .749]) dish(top_total_key_width() + $dish_overdraw_width, top_total_key_height() + $dish_overdraw_height, $dish_depth, $inverted_dish, $top_tilt / $key_height);
			}
		}
	}
}

// puts it's children at the center of the dishing on the key. this DOES rotate them though, it's not straight up
module top_of_key(){
	extra_dish_depth = ($dish_type == "no dish") ? 0 : $dish_depth;
	translate([$dish_skew_x, $top_skew + $dish_skew_y, $total_depth - extra_dish_depth]){
		rotate([-$top_tilt,0,0]){
			children();
		}
	}
}

module keytext() {
	extra_inset_depth = ($inset_text) ? 0.3 : 0;

	translate([0, 0, -extra_inset_depth]){
		top_of_key(){
			linear_extrude(height=$dish_depth){
				text(text=$text, font=$font, size=$font_size, halign="center", valign="center");
			}
		}
	}
}

module connectors() {
	intersection() {
		for (connector_pos = $connectors) {
			translate([connector_pos[0], connector_pos[1], $stem_inset]) {
				rotate([0, 0, $stem_rotation]){
					color([1, .6941, .2]) connector($stem_profile, $total_depth, $has_brim, $slop, $stem_inset, $support_type);
				}
			}
		}
		// cut off anything that isn't underneath the keytop
		shape($wall_thickness, $keytop_thickness);
	}
}

//approximate (fully depressed) cherry key to check clearances
module clearance_check() {
	if($clearance_check == true && ($stem_profile == "cherry" || $stem_profile == "cherry_rounded")){
		color([1,0,0, 0.5]){
			translate([0,0,3.6 + $stem_inset - 5]) {
				%hull() {
					cube([15.6, 15.6, 0.01], center=true);
					translate([0,1,5 - 0.01]) cube([10.5,9.5, 0.01], center=true);
				}
				%hull() {
					cube([15.6, 15.6, 0.01], center=true);
					translate([0,0,-5.5]) cube([13.5,13.5,0.01], center=true);
				}
			}
		}
	}
}

module keytop() {
	difference(){
		if ($rounded_key) {
			rounded_shape();
		} else {
			shape(0, 0);
		}
		translate([0,0,-0.01]) shape($wall_thickness, $keytop_thickness);
	}
}


// The final, penultimate key generation function.
// takes all the bits and glues them together. requires configuration with special variables.
module key() {
	difference() {
		union(){
			keytop();
			if($stem_profile != "blank") connectors();
			if(!$inset_text) keytext();
			clearance_check();
			top_of_key() {
				children();
			}
		}
		if ($inset_text) keytext();
	}
}

// actual full key with space carved out and keystem/stabilizer connectors
// this is an example key with all the fixins
module example_key(){
	include <settings.scad>
	key();
}

example_key();
