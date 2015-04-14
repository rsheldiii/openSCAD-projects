//Thickness of entire plate
plateThickness=1.5;
//Unit square length, from Cherry MX data sheet
lkey=19.2;
//Hole size, from Cherry MX data sheet
holesize=14;
//length, in units, of board
width=15;
//Height, in units, of board
height=5;
//Radius of mounting holes
mountingholeradius=1.11;
//height of switch clasp cutouts
cutoutheight = 3;
//width of switch clasp cutouts
cutoutwidth = 1;

//calculated vars

holediff=lkey-holesize;
w=width*lkey;
h=height*lkey;


//my custom keyboard layout layer
myKeyboard = [
//start column 0
	[[0,0],1.5],
	[[0,1],1.5],
	[[0,2],1.5],
	[[0,3],1.5],
	[[0,4],1.5],
//start column 1
	[[1.5,0],1],
	[[1.5,1],1],
	[[1.5,2],1],
	[[1.5,3],1],
	[[1.5,4],1],
//start column 2
	[[2.5,0],1],
	[[2.5,1],1],
	[[2.5,2],1],
	[[2.5,3],1],
	[[2.5,4],1],
//start column 3
	[[3.5,0],1],
	[[3.5,1],1],
	[[3.5,2],1],
	[[3.5,3],1],
	[[3.5,4],1],
//start column 4
	[[4.5,0],1],
	[[4.5,1],1],
	[[4.5,2],1],
	[[4.5,3],1],
	[[4.5,4],2],//SPACEBAR
//start column 5
	[[5.5,0],1],
	[[5.5,1],1],
	[[5.5,2],1],
	[[5.5,3],1],
//start column 6
	[[7,0],1],
	[[7,1],1],
	[[7,2],1],
	[[7,3],1],
	[[7,4],2],//SPACEBAR
//start column 7
	[[8,0],1],
	[[8,1],1],
	[[8,2],1],
	[[8,3],1],
//start column 8
	[[9,0],1],
	[[9,1],1],
	[[9,2],1],
	[[9,3],1],
	[[9,4],1],
//start column 9
	[[10,0],1],
	[[10,1],1],
	[[10,2],1],
	[[10,3],1],
	[[10,4],1],
//start column 10
	[[11,0],1],
	[[11,1],1],
	[[11,2],1],
	[[11,3],1],
	[[11,4],1],
//start column 11
	[[12,0],1],
	[[12,1],1],
	[[12,2],1],
	[[12,3],1],
	[[12,4],1],
//start column 12
	[[13,0],1],
	[[13,1],1],
	[[13,2],2],//ENTER
	[[13,3],1],
	[[13,4],1],
//start column 13
	[[14,0],1],
	[[14,1],1],

	[[14,3],1],
	[[14,4],1],
];

//poker keyboard layout layer
pokerkeyboard = [
//start ROW 0
[[0,0],1],
[[1,0],1],
[[2,0],1],
[[3,0],1],
[[4,0],1],
[[5,0],1],
[[6,0],1],
[[7,0],1],
[[8,0],1],
[[9,0],1],
[[10,0],1],
[[11,0],1],
[[12,0],1],
[[13,0],2],
//start ROW 1
[[  0,1],1.5],
[[1.5,1],1],
[[2.5,1],1],
[[3.5,1],1],
[[4.5,1],1],
[[5.5,1],1],
[[6.5,1],1],
[[7.5,1],1],
[[8.5,1],1],
[[9.5,1],1],
[[10.5,1],1],
[[11.5,1],1],
[[12.5,1],1],
[[13.5,1],1.5],
//start ROW 2
[[   0,2],1.75],
[[1.75,2],1],
[[2.75,2],1],
[[3.75,2],1],
[[4.75,2],1],
[[5.75,2],1],
[[6.75,2],1],
[[7.75,2],1],
[[8.75,2],1],
[[9.75,2],1],
[[10.75,2],1],
[[11.75,2],1],
[[12.75,2],2.25],
//start ROW 3
[[   0,3],2.25],
[[2.25,3],1],
[[3.25,3],1],
[[4.25,3],1],
[[5.25,3],1],
[[6.25,3],1],
[[7.25,3],1],
[[8.25,3],1],
[[9.25,3],1],
[[10.25,3],1],
[[11.25,3],1],
[[12.25,3],2.75],
//start ROW 4
[[   0,4],1.25],
[[1.25,4],1.25],
[[2.5 ,4],1.25],
[[3.75,4],6.25],
[[10  ,4],1.25],
[[11.25,4],1.25],
[[12.5 ,4],1.25],
[[13.75,4],1.25],
];

holetype = 1;

module plate(w,h){
	round_radius = 4;
	minkowski_height = .001;

	minkowski(){
		cylinder(r=round_radius,h=minkowski_height,$fn=96);
		translate([round_radius,round_radius,0]) cube([w-round_radius*2,h-round_radius*2,plateThickness-minkowski_height*2]);
	}
}

module switchhole(holetype){
	if (holetype == 0){
		union(){
			cube([holesize,holesize,plateThickness]);

			translate([-cutoutwidth,1,0])
			cube([holesize+2*cutoutwidth,cutoutheight,plateThickness]);

			translate([-cutoutwidth,holesize-1-cutoutheight,0])
			cube([holesize+2*cutoutwidth,cutoutheight,plateThickness]);
		}
	}
	if (holetype == 1){
		union(){
			cube([holesize,holesize,plateThickness]);

			translate([-cutoutwidth,1,0])
			cube([holesize+2*cutoutwidth,holesize-2,plateThickness]);
		}
	}
	if (holetype == 2){
		cube([holesize,holesize,plateThickness]);
	}
}

module holematrix(holes,startx,starty){
	for (key = holes){
		translate([startx+lkey*key[0][0], starty-lkey*key[0][1], 0])
		translate([(lkey*key[1]-holesize)/2,(lkey - holesize)/2, 0])
		switchhole(holetype);
	}
}

module mountingholes(){
	translate([26.5,3.5*lkey,0]) //orig 1 1/3
	cylinder(h=plateThickness,r=mountingholeradius, $fn=24);

	translate([(13+2/3)*lkey,3.5*lkey,0])
	cylinder(h=plateThickness,r=mountingholeradius, $fn=24);
	
	translate([130,2.5*lkey,0]) //orig 6.75
	cylinder(h=plateThickness,r=mountingholeradius, $fn=24);

	translate([(15)*lkey - 3,2*lkey,0]) //orig 14.8
	cylinder(h=plateThickness,r=mountingholeradius, $fn=24);

	translate([3,2*lkey,0]) //orig .2
	cylinder(h=plateThickness,r=mountingholeradius, $fn=24); 

	translate([(10)*lkey,.5*lkey,0])
	cylinder(h=plateThickness,r=mountingholeradius, $fn=24);
}

module stabilizer(){
	cube([3.3,14,plateThickness]);
}

module 2u_stabilizer(x,y,l){
	translate([0+lkey*x, h-lkey-lkey*y, 0])
	translate([(lkey*l-holesize)/2,(lkey - holesize)/2, 0])
	translate([-6.6,-.75,0])
	union(){
		stabilizer();
		translate([3.3 + 20.6,0,0]) stabilizer();
	}
}

module stabilizers(){
	2u_stabilizer(4.5,4,2);
	2u_stabilizer(7,4,2);
	2u_stabilizer(13,2,2);
}

module actual_plate(holes){
	difference(){
		plate(w,h);
		holematrix(holes,0,h-lkey);
		mountingholes();
		stabilizers();
		//translate([130,0,0]) cube([1000,150,150]);//left side
		//translate([0,0,0]) cube([230,150,150]); // right side
	}
}

//myplate();
//plate(w,h);
//actual_plate(pokerkeyboard);//stabilizers();
actual_plate(myKeyboard);

