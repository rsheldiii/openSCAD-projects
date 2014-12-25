//Thickness of entire plate
plateThickness=3;
//Unit square length, from Cherry MX data sheet
lkey=19.05;
//Hole size, from Cherry MX data sheet
holesize=14;
//length, in units, of board
width=15;
//Height, in units, of board
height=5;
//Radius of mounting holes
mountingholeradius=2;
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
	[[2.5,4],1.25],
//start column 3
	[[3.5,0],1],
	[[3.5,1],1],
	[[3.5,2],1],
	[[3.5,3],1],
	[[3.75,4],6.25],
//start column 4
	[[4.5,0],1],
	[[4.5,1],1],
	[[4.5,2],1],
	[[4.5,3],1],
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
	[[13,2],2],
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

module plate(w,h){
	cube([w,h,plateThickness]);
}

module switchhole(){
	union(){
		cube([holesize,holesize,plateThickness]);

		translate([-cutoutwidth,1,0])
		cube([holesize+2*cutoutwidth,cutoutheight,plateThickness]);

		translate([-cutoutwidth,holesize-cutoutwidth-cutoutheight,0])
		cube([holesize+2*cutoutwidth,cutoutheight,plateThickness]);
	}
}

module holematrix(holes,startx,starty){
	for (key = holes){
		translate([startx+lkey*key[0][0], starty-lkey*key[0][1], 0])
		translate([(lkey*key[1]-holesize)/2,(lkey - holesize)/2, 0])
		switchhole();
	}
}

module mountingholes(){
	translate([(1+1/3)*lkey,3.5*lkey,0])
	cylinder(h=plateThickness,r=mountingholeradius, $fn=12);

	translate([(13+2/3)*lkey,3.5*lkey,0])
	cylinder(h=plateThickness,r=mountingholeradius, $fn=12);
	
	translate([(6.75)*lkey,2.5*lkey,0])
	cylinder(h=plateThickness,r=mountingholeradius, $fn=12);

	translate([(6.75)*lkey,2.5*lkey,0])
	cylinder(h=plateThickness,r=mountingholeradius, $fn=12);

	translate([(14.8)*lkey,2*lkey,0])
	cylinder(h=plateThickness,r=mountingholeradius, $fn=12);

	translate([(.2)*lkey,2*lkey,0])
	cylinder(h=plateThickness,r=mountingholeradius, $fn=12);

	translate([(10)*lkey,.5*lkey,0])
	cylinder(h=plateThickness,r=mountingholeradius, $fn=12);
}

module myplate(){
	difference(){
		plate(w,h);
		holematrix(myKeyboard,0,h-lkey);
		mountingholes();
		//translate([152.5,0,0]) cube([.001,150,150]);
	}
}

module pokerplate(){
	difference(){
		plate(w,h);
		holematrix(pokerkeyboard,0,h-lkey);
		mountingholes();
	}
}

pokerplate();