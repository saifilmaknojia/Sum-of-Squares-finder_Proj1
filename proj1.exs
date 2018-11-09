# This exs script allows us to call the scheduler function from the command line like mix run proj1.exs 3 2 

[arg1, arg2] = Enum.map(System.argv, fn x -> String.to_integer(x) end)
z = 20
to_process = Enum.map 1..arg1, fn x -> x..(x+arg2-1) end
Distributor.run(z, SquareSolver, :sqr, to_process)
