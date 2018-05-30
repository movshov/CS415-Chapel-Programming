//Name: Bar Movshovich
//Date: 2/25/18
//Class: CS 415

  config const bufSize = 10;		// buffer size (configurable)
  config const numProds = 2;		// configurable # of producers, default = 2
  config const numCons = 2;			// configurable # of consumers, default = 2 
  config var N = 32;				// configurable # of items,     default = 32

proc main{

  var numItems = N;					//reassign # of items. 
  var Chandle = numItems/numProds; 	//# of items to handle for each consumer thread. 
  var Phandle = numItems/numCons;	//# of items to handle for each producer thread.
  var buf$: [0..bufSize-1] sync int;	// buffer (cells are self-sync)
  var head$ = 0;  	                // head idx 
  var tail$ = 0;		        // tail idx 
  var i = 0;					//used for looping.
  var j = 0;					//used for looping.
  var added = 0;			//used to keep track of producer threads.
  var removed = 0;				//used to keep track of consumer threads.



	  forall i in (0..numCons-1){		
		  begin consumer(i);	       //begin consumer threads. 
	  }
	  coforall j in (0..numProds-1){
		  producer(j);					//begin creating producer thread for each iteration.
	  }


  proc producer(i){						//producer function with limit # of items to each thread(Phandle).
	  var prod_limit = Phandle;
	  while(added < N){				//while we haven't completed adding every item. 
		  var idx = tail$;
		  if(prod_limit > 0){			//if the current thread still has another iteration available.
			  if(head$ == 0){			//if we have one item. set head. 
				  head$ = idx;
			  }
			  tail$ = (idx + 1) % bufSize;	//set tail$
			  idx = (idx + 1) % bufSize;	//set idx
			  buf$[idx] = added;		//fill buf$
			  writeln("Producer ", i, " added item ",added, " in buf[",idx,"]");	//print out to user which thread completed what item. 
			  added = added + 1;	//increment added.
			  prod_limit = prod_limit - 1;	//decrement current thread's # of available iterations. 
		  }
		  else {
			  break;	
		  }
	  }
  }


  proc consumer(j) {					//consumer function with limit # of items to each thread(Chandle).
	  var cons_limit = Chandle;			
	  while(removed< N){				//while we haven't deleted every item that was created. 
		  if(Chandle > 0){				//if the current thread still has another iteration avialable.
			  var idx = head$;
			  head$ = (idx + 1) % bufSize;	//set head. 
			  idx = (idx + 1) % bufSize;	//set idx...again.
			  var item = buf$[idx];			//unlock buf$ to random item.
			  var pair = (idx, removed);
			  writeln("Consumer ", j, " removed item ",removed, " in buf[",idx,"]");	//print out to user which thread deleted what item.
			  removed = removed + 1;		//increment removed
			  cons_limit = cons_limit - 1;	//decrement current thread's # of available iterations.
		  }

	  }

  }
}



