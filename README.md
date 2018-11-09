GROUP INFO

Name 				  UFID
Jacob Ville			4540-7373
Shaifil Maknojia	7805-9466

***

Instructions:

1. Extract the zip file
2. Go to proj1 folder
3. mix compile
4. mix run proj1.exs arg1 arg2 <br> (Where arg1 = n and arg2 = k)
	
	Eg:  <br>
	\DOS\Projects\proj1 <br>
	\DOS\Projects\proj1>mix compile <br>
	\DOS\Projects\proj1>mix run proj1.exs 100 24
	
	O/P: <br>
	1<br>
    9<br>
    20<br>
    25<br>
    44<br>
    76<br>
	
***

Size of work unit:

We started by doing the entire calculation with one process, and gradually increased the number up to the maximum allowed, which we determined from Erlang Statistics with the :observer.start command.

We decided to use 20 processes after we did not observe a significant time difference when running a larger number of processes. 


Allocating sub-problems to workers:

Each worker is given a range, calculating the sum of squares in that range as follows

Worker: 1^2 + ... + (k)^2 <br>
Worker: 2^2 + ... + (k+1)^2 <br>
Worker: 3^2 + ... + (k+2)^2 <br>
and so on...

Once worker 1 finishes, it sends a message to the scheduler/BOSS with the result. Then it calls itself, sending a ready message indicating that its ready to do more work. The scheduler checks if there is work_load left to complete, distributing work until there is no work left, then sends the shutdown message.

***
O/P for N=1000000 k=4

\DOS\Projects\proj1>mix run proj1.exs 1000000 4

\DOS\Projects\proj1>

***
\DOS\Projects\proj1>time mix run proj1.exs 1000000 4 <br>
real : 4.908s <br>
user : 7.151s <br>
sys :  3.640s

\DOS\Projects\proj1>

***

The largest problems we managed to solve were with values of n up to 10^7.

***

 
# project1
