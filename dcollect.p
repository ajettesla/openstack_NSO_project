set terminal png size 1024,1024
set output 'statistics.png'
set xlabel 'Concurrency Level'
set ylabel 'Requests/s'
set style data linespoints

plot "statistics1.log" using 1:3 title 'Average (nodes 1)' with linespoints, \
     "statistics1.log" using 1:4 title 'std.dev (nodes 1)' with linespoints, \
     "statistics2.log" using 1:3 title 'Average (nodes 2)' with linespoints, \
     "statistics2.log" using 1:4 title 'std.dev (nodes 2)' with linespoints, \
     "statistics3.log" using 1:3 title 'Average (nodes 3)' with linespoints, \
     "statistics3.log" using 1:4 title 'std.dev (nodes 3)' with linespoints, \
     "statistics4.log" using 1:3 title 'Average (nodes 4)' with linespoints, \
     "statistics4.log" using 1:4 title 'std.dev (nodes 4)' with linespoints, \
     "statistics5.log" using 1:3 title 'Average (nodes 5)' with linespoints, \
     "statistics5.log" using 1:4 title 'std.dev (nodes 5)' with linespoints
