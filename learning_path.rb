require 'csv'
require 'set'

class Student < OpenStruct
  def increment(domain)
    old_value = send(domain)

    if old_value == "K"
      new_value = 1
    else
      new_value = old_value + 1
    end

    send("#{domain}=", new_value)
  end

  def domain_at(level)
    to_h.select { |_, v| v.to_s == level }.keys
  end

  def lowest_level(levels)
    levels.each do |level|
      return level if domain_at(level).any?
    end
  end
end

class LearningPath
  def initialize(domain_order_file: './data/domain_order.csv', test_score_file: './data/student_tests.csv')
    @domain_order_file = domain_order_file
    @test_score_file   = test_score_file

    validate_domains
  end

  def find_student(name)
    students.find{ |s| s.student_name == name } || raise("student does not have test scores")
  end

  def find_path(name)
    student = find_student(name)
    path = [name]

    levels.each do |level|
      order = domain_order[level]

      order.each do |domain|
        student.domain_at(level).each do |exercise|
          break if path.count == 6

          path << "#{level}.#{exercise.to_s.upcase}"
          student.increment(exercise)
        end
      end
    end

    path.join(',')
  end

  private

  def domain_order
    @domain_order ||= CSV.read(@domain_order_file).map do |row|
      [row.shift, row.map(&:downcase).map(&:to_sym)]
    end.to_h
  end

  def domains
    @domains ||= domain_order.values.flatten.uniq
  end

  def levels
    @levels ||= domain_order.keys.flatten
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
