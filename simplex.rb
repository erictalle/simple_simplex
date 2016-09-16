
class LP
	def initialize(lp)
		@lp = lp
	end

	def current_rhs
		@lp[0..-2].collect{|row| row[-1]}
	end	

	def pivot
		pi = pivot_index
		pivot_row_index = pi[0]
		pivot_column_index = pi[1]
		pivot_scaler = @lp[pivot_row_index][pivot_column_index]	
		puts "pivot: #{pivot_scaler} @ location: (#{pivot_row_index},#{pivot_column_index})" 
		pivot_row = @lp[pivot_row_index].collect! {|n| n.to_r/pivot_scaler.to_r}

		@lp.each_with_index do |row,index|
			if index != pivot_row_index
				scaler = @lp[index][pivot_column_index]	* -1
				new_row = ero(scaler, pivot_row, index)	
			end
		end	
		puts "-----------------------------------------------------"
		@lp.each do |row|
			row.each {|e| print "#{e}\t"}
			puts ""
		end
		puts "-----------------------------------------------------"
	end

	def optimal
		@lp[-1].min < 0 ? false : true
	end
	
	def ero(scaler, pivot_row, target_row_index)
		operand_array = [pivot_row.collect {|n| n*scaler}, @lp[target_row_index]]
		@lp[target_row_index] = operand_array.transpose.map {|e| e.reduce(:+).to_r}
	end

	def pivot_index
		pc_index = @lp[-1].index(@lp[-1].min)  #gets the last mins index.  Need to revisit	
		col_rhs_ratios = @lp[0..-2].reject {|row| row[-1] == 0}.collect{|row| row[-1]/row[pc_index]}
		pr_index = col_rhs_ratios.index(col_rhs_ratios.min)
		return pr_index, pc_index
	end

	def solve
		while !optimal
			pivot
		end
	end
end



lp = LP.new([[1,2,1,0,0,0,16],[1,1,0,1,0,0,9],[3,2,0,0,1,0,24],[-40,-30,0,0,0,1,0]])
lp.solve




__END__

This example equates 

