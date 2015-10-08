require_relative '../learning_path'

require 'csv'

describe LearningPath do
  context 'given an valid csv domain order' do
    it 'does not raise error' do
      expect{ LearningPath.new }.not_to raise_error
    end
  end

  context 'given an invalid csv domain order' do
    let(:domain_order_file){"./data/invalid_domain_order.csv"}
    it 'raises a CSV parsing error' do
      err = "invalid domain order for test scores"
      expect{ LearningPath.new(domain_order_file: domain_order_file) }.to raise_error(RuntimeError, err)
    end
  end
end
