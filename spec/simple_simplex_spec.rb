require_relative '../simple_simplex.rb'

describe SimpleSimplex do
  before :each do
  	@lp = SimpleSimplex.new([[1,2,1,0,0,0,16],
												[1,1,0,1,0,0,9],
												[3,2,0,0,1,0,24],
												[-40,-30,0,0,0,1,0],
												["x1","x2","s1","s2","s3","z","rhs"]])
  end

  describe "#new" do
  	it "takes an array of arrays and returns a SimpleSimplex object" do
  		expect(@lp).to be_an_instance_of(SimpleSimplex)
  	end
  end

  describe "#current_rhs" do
  	expected_rhs = [16,9,24]
  	it "returns the current rhs of the current tableau" do
  		expect(@lp.current_rhs).to match_array expected_rhs
  	end
  end

  describe "#solve" do
  	optimal_z_value = 330.0
  	it "returns the optimal z value for the objective function" do
  		expect(@lp.solve[:max_z]).to eq(optimal_z_value)
  	end
  end

  describe "#optimal? where not" do
  	it "after first pivot, it should return that the current tableau is not optimal" do
  		@lp.pivot
  		expect(@lp.optimal?).to be false
  	end
  end

  describe "#optimal? where it is" do
  	it "after two pivots, it should return that the current tableau is optimal" do
  		2.times {@lp.pivot}
  		expect(@lp.optimal?).to be true
  	end
  end

  describe "#current_z_value" do
  	it "after one pivot, the z value should be reported accurately" do
  		expected_z_value = 320
  		@lp.pivot
  		expect(@lp.current_z_value.to_i).to equal(expected_z_value)
  	end
  end

  describe "#current_basis" do
    it "after the lp has been solved, the basis should be reported correctly" do
      expected_x1_value = 6.0
      expect(@lp.solve[:basis][:x1]).to equal expected_x1_value
    end
  end
end