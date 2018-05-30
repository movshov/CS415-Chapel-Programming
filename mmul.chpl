//Bar Movshovich
//Date: 2/22/18
//CS 415 Assignment #3

config var N = 8;	//constant variable N set to 8.
proc main{

var D = {0..N-1,0..N-1};		//declare domain.
var a,b,c: [D] int;	//delcaring three int array vars.

matrix(a,b,c,D,N);

}


proc matrix(a,b,c,D,N){

	var i,j,k: int = 0;	//set i,j,k to 0.
	var total: int = 0;

	b = 1;	//initialize all elements of b = 1.
	c = 0;	//initialize all elements of c = 0.
	sync coforall (i,j,k) in zip({0..N-1,0..N-1,0..N-1}) do{	//zipped forall loop. 

		a[i,j] = i + j;
		begin c[i,j] +=  (a[i,k] * b[k,j]);	//make new treads for each iteration.
	}
	total = + reduce c;	//reduce matrix to single int value.
	writeln("total = ", total, " (should be 3584)");
}


