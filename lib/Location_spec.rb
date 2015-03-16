require 'location'

RSpec.describe "Location" do
  it "should equal other location that has the same coordinates" do
    expect(Location.new(1, 2) == Location.new(1, 2)).to eq(true)
  end

  it "should not equal to other location with different coordinates" do
    expect(Location.new(1, 2) == Location.new(2, 2)).to eq(false)
  end

  it "should not equal to other non-location objects" do
    expect(Location.new(1, 2) == "1, 2").to eq(false)
  end

  it "should be usable as a hash key" do
    hash = {Location.new(1, 2) => "::associated_value::"}
    expect(hash.key? Location.new(1, 2)).to eq(true)
    expect(hash[Location.new(1, 2)]).to eq("::associated_value::")
  end
end
