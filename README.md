# simple_simplex
Classic simplex algorithm/method for max linear programs written in Ruby.  

Example usage:

To solve a max problem like:

max z = 40 * x1 + 30 * x2

s.t. 		x1  +  x2  <= 16

				x1  +  x2  <= 9

				3*x1 + 2*x2 <= 24

				x1, x2  >= 0

put the problem in an array like the following to initialize a SimpleSimplex object.  Note the slack variables added (see the diagonal initial basis called s1, s2, s3)

lp = SimpleSimplex.new([[1,2,1,0,0,0,16],
												[1,1,0,1,0,0,9],
												[3,2,0,0,1,0,24],
												[-40,-30,0,0,0,1,0],
												["x1","x2","s1","s2","s3","z","rhs"]])
lp.show_tableau = true
solution = lp.solve
puts "solution: #{solution}"

This will return in the solution variable:

solution: {:max_z=>330.0, :step=>2, :basis=>{:x1=>6.0, :x2=>3.0, :s1=>4.0, :z=>330.0}}
