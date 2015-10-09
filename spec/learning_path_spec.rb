require_relative '../learning_path'

require 'pry'

describe LearningPath do
  context 'given an valid csv domain order' do
    it 'does not raise error' do
      expect{ LearningPath.new }.not_to raise_error
    end
  end

  context 'given an invalid csv domain order' do
    let(:domain_order_file){"./data/invalid_domain_order.csv"}
    it 'raises a CSV parsing error' do
      err = "invalid domain rt for test scores"
      expect{ LearningPath.new(domain_order_file: domain_order_file) }.to raise_error(RuntimeError, err)
    end
  end

  context 'given a student who has taken the test' do
    it 'finds a valid learning path for a single student' do
      expect(LearningPath.new.find_path("Albin Stanton")).to eq("Albin Stanton,K.RI,1.RI,2.RF,2.RI,3.RF")
    end

    it 'finds a path with correct domain ordering' do
      expect(LearningPath.new.find_path("Douglas Feil")).to eq("Douglas Feil,1.RF,1.RL,1.RI,2.RF,2.RI")
    end
  end

  context 'given a student who has not taken the test' do
    it 'raises an invalid student error' do
      err = "student does not have test scores"
      expect{ LearningPath.new.find_path("Invalid Student") }.to raise_error(RuntimeError, err)
    end
  end

  #defaults to K if no level given
end
