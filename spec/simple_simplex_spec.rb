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
end