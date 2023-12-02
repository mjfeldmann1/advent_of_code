input_lines = File.new('inputs/day1.txt').readlines(chomp: true)

NUMERIC_NUMBERS_TO_NUMERIC_NUMBERS = (1..9).to_a.map do |number|
  [number.to_s, number.to_s]
end.to_h

SPELLED_NUMBERS_TO_NUMERIC_NUMBERS = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'].map.with_index(1) do |number, index|
  [number, index.to_s]
end.to_h

def part1(input_lines)
  puts find_sum(input_lines, NUMERIC_NUMBERS_TO_NUMERIC_NUMBERS)
end

def part2(input_lines)
  puts find_sum(input_lines, NUMERIC_NUMBERS_TO_NUMERIC_NUMBERS.merge(SPELLED_NUMBERS_TO_NUMERIC_NUMBERS))
end

def find_sum(input_lines, values_and_replacements)
  input_lines.map do |line|
    first_number = get_number(line, values_and_replacements, :index, :min_by)
    last_number = get_number(line, values_and_replacements, :rindex, :max_by)
    "#{first_number}#{last_number}".to_i
  end.reduce(:+)
end

def get_number(line, values_and_replacements, index_method, sort_by_method)
  values_and_replacements.filter do |value, _replacement|
    line.include?(value)
  end.map do |value, replacement|
    [replacement, line.send(index_method, value)]
  end.send(sort_by_method) do |_replacement, index|
    index
  end[0]
end


part1(input_lines)
part2(input_lines)