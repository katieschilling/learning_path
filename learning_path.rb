require 'set'

Student = Class.new(OpenStruct)

class LearningPath
  def initialize(domain_order_file: './data/domain_order.csv', test_score_file: './data/student_tests.csv')
    @domain_order_file = domain_order_file
    @test_score_file   = test_score_file

    validate_domains
  end

  private

  def domain_order
    @domain_order ||= CSV.read(@domain_order_file).map { |row| { row.shift => row } }
  end

  def domains
    @domains ||= domain_order.map(&:values).flatten.uniq.map(&:downcase).map(&:to_sym)
  end

  def students
    @students ||= CSV.table(@test_score_file).entries.map { |row| Student.new(row.to_h) }
  end

  def validate_domains
    domains.each do |d|
      raise "invalid domain #{d} for test scores" unless students.first.to_h.keys.include?(d)
    end
  end
end
