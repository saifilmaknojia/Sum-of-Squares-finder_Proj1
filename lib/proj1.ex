defmodule Distributor do

  # The run function is called from proj1.exs, it kicks off
  # our work, the parameters received by the run function are 
  # the number of processes to spawn, the module name and the 
  # function to spawn, along with the list of work to do. 
  # The run function creates the appropriate number of 
  # processes, saves their pid, and calls the process_manager 
  # function that is responsible for distributing the work.

  def run(num_processes, module, func, to_work_on) do
    (1..num_processes)
    |> Enum.map(fn(_) -> spawn(module, func, [self()]) end)
    |> process_manager(to_work_on, [])
  end

  # The process_manager waits to receive messages from the workers, 
  # if it receives a ready message, it checks whether there is 
  # more work in work_load, if yes, it then passes the next load 
  # (range) to the process, and recurses itself with one less item 
  # in the work_load.

  defp process_manager(processes, work_load, results) do
    receive do
      {:ready, pid} when work_load != [] ->
        [next | tail] = work_load
        send pid, {:sqr, next, self()}
        process_manager(processes, tail, results)

      # if the process_manager receives a ready message and all work 
      # is done, it sends a shutdown message to the worker.

      {:ready, pid} ->
        send pid, {:shutdown}
        if length(processes) > 1 do
          process_manager(List.delete(processes, pid), work_load, results)
        end

      # once it receives the result, it checks whether it is a 
      # perfect square and prints the number. Then call process_manager 
      # to listen for other results

      {:answer, number, result, _pid} ->
        if result do
             IO.puts number
        end
      process_manager(processes, work_load,  results)
    end
  end
end


defmodule SquareSolver do

  # The sqr function sends a ready message to the scheduler 
  # indicating it's ready to work

  def sqr(scheduler) do
    send scheduler, {:ready, self()}
    receive do

      # with a :sqr message, calculates the sum of squares in
      # the range, returning whether the sum itself is a square

      {:sqr, n, client} ->
        first..last = n
        is_square = sum_sqr_from(first, last) |> is_sqrt
        send client, {:answer, first, is_square, self()}

        # when finished, call itself to get more work
        sqr(scheduler)

      {:shutdown} ->
        exit(:normal)
    end
  end

  defp sum_sqr_from(first, last) when first > last, do: 0
  defp sum_sqr_from(first, last) do
    (first * first) + sum_sqr_from(first+1, last)
  end

  defp is_sqrt(n) do
    :math.floor(:math.sqrt(n)) == :math.sqrt(n)
  end
end

