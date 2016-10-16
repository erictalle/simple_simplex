#SimpleSimplex is a class that solves very basic max LP problems.  It's designed
#to show the tableaus as the problem is solved.  This should not be used for 
#large scale problems.  This was more for me to entertain myself and to learn 
#a bit about Ruby and Linear Programming.  Hopefully it can be used as a learning 
#tool for the interested.
#
require 'matrix'

class SimpleSimplex
	attr_accessor :show_tableau
	
	def initialize(input)
		@show_tableau = false
		@step = 0
		if input.kind_of?(Array)
			@lp = input
		else
			raise "Input is a String!  Nothing implemented yet for anyother input."
		end
	end

	def solve
		solution_hash = {}
		if @show_tableau
			print_tableau
		end
		while !optimal?
			@step += 1
			pivot
		end
		solution_hash[:max_z] = current_z_value.to_f
		solution_hash[:step] = @step.to_i
		solution_hash[:basis] = current_basis
		return solution_hash
	end

	def current_rhs
		@lp[0..-3].collect{|row| row[-1]}
	end	

	def pivot
		pi = pivot_index
		pivot_row_index = pi[0]
		pivot_column_index = pi[1]
		pivot_scaler = @lp[pivot_row_index][pivot_column_index]	
		pivot_row = @lp[pivot_row_index].collect! {|n| n.to_r/pivot_scaler.to_r}
		@lp[0..-2].each_with_index do |row,index|
			if index != pivot_row_index
				scaler = @lp[index][pivot_column_index]	* -1
				new_row = ero(scaler, pivot_row, index)	
			end
		end	
		if @show_tableau
			print_tableau
		end
	end

	def make_number_real(rational_number)
		rational_number.to_r
		if rational_number.numerator == 0
			return 0
		elsif rational_number.denominator == 1
			return rational_number.numerator
		else 
			return rational_number
		end
	end

	def optimal?
		@lp[-2].min < 0 ? false : true
	end
	
	def current_z_value
		return @lp[-2][-1]
	end

	def current_basis
		basis = []
		transpose = []
		m = []
		@lp.each do |r|
			m = Matrix.rows(m.to_a << r)
		end
		transpose = m.transpose.to_a

		transpose.each do |col|
			if column_basic?(col)
				basis << col[-1]
			end
		end
		return basis	
	end

	def column_basic?(ary)
		if(ary[0..-2].count(0) == ary.length - 2)
			unless ary.index(1).nil?
				return true
			end
		end
		return false
	end

	def pivot_index
		pc_index = @lp[-2].index(@lp[-2].min)  
		col_rhs_ratios = @lp[0..-3].reject {|row| row[-1] <= 0}.collect{|row| row[-1]/row[pc_index]}
		pr_index = col_rhs_ratios.index(col_rhs_ratios.min)
		if pr_index == nil
			raise "No solution!"
		end
		return pr_index, pc_index
	end

	def ero(scaler, pivot_row, target_row_index)
		operand_array = [pivot_row.collect {|n| n*scaler}, @lp[target_row_index]]
		@lp[target_row_index] = operand_array.transpose.map {|e| e.reduce(:+).to_r}
	end

	def print_tableau
		@lp[-1].each {|e| print "#{e}\t"}
		puts ""
		puts "-----------------------------------------------------"
		@lp[0..-3].each do |row|
			row.each {|e| print "#{make_number_real(e)}\t"}
			puts ""		
		end	
		puts "-----------------------------------------------------"
		@lp[-2].each {|e| print "#{make_number_real(e)}\t"}
		puts "\n\n"
	end
end


__END__
#example usage
lp = SimpleSimplex.new([[1,2,1,0,0,0,16],
												[1,1,0,1,0,0,9],
												[3,2,0,0,1,0,24],
												[-40,-30,0,0,0,1,0],
												["x1","x2","s1","s2","s3","z","rhs"]])
lp.show_tableau = true
solution = lp.solve
puts "solution: #{solution}"

# use rspec spec to run tests

