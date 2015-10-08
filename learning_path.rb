require 'set'

class LearningPath
  def initialize(domain_order_file:'./data/domain_order.csv')
    @test_scores = create_test_score_lookup('./data/student_tests.csv')
    @domain_order = create_domain_lookup(domain_order_file)
  end

  def create_domain_lookup(file)
    domains = {}
    CSV.foreach(file) do |row|
      if valid_domain?(row)
        domains[row[0]] = row.drop(1)
      else
        raise "invalid domain order for test scores"
      end
    end
  end

  def create_test_score_lookup(file)
    CSV.read(file, headers:true)
  end

  def valid_domain?(row)
    domains = Set.new @test_scores.headers
    row = Set.new row.drop(1)
    row.subset?(domains)
  end
end
