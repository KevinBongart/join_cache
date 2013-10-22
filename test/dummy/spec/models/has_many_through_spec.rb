require "spec_helper"

describe "has_many_through" do
  let(:dr_no) { Physician.create(name: "Dr. No") }
  let(:james) { Patient.create(name: "James") }
  let(:honey) { Patient.create(name: "Honey") }

  before do
    dr_no.patients = [james, honey]
  end

  describe ".cached_patient_ids" do
    it "returns an array of patient ids" do
      dr_no.cached_patient_ids.should == [james.id, honey.id]
    end
  end

  describe ".cached_patients" do
    it "returns an array of patients" do
      dr_no.cached_patients.should == [james, honey]
    end
  end
end
