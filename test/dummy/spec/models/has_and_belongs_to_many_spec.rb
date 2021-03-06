require "spec_helper"

describe "has_and_belongs_to_many" do
  let(:assembly) { Assembly.create(name: "Assembly") }
  let(:part_1) { Part.create(part_number: "1234") }
  let(:part_2) { Part.create(part_number: "5678") }

  describe ".cached_part_ids" do
    it "returns an empty array when there are no parts" do
      assembly.cached_part_ids.should == []
    end

    it "returns an array of parts ids" do
      assembly.parts = [part_1, part_2]
      assembly.cached_part_ids.should == [part_1.id, part_2.id]
    end
  end

  describe ".cached_parts" do
    it "returns an empty array when there are no parts" do
      assembly.parts.should == []
    end

    it "returns an array of parts" do
      assembly.parts = [part_1, part_2]
      assembly.cached_parts.should == [part_1, part_2]
    end
  end
end
