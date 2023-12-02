input_lines = File.new('inputs/day1.txt').readlines(chomp: true)

NUMERIC_NUMBERS_TO_NUMERIC_NUMBERS = (1..9).to_a.map do |number|
  [number.to_s, number.to_s]
end.to_h

SPELLED_NUMBERS_TO_NUMERIC_NUMBERS = {
  'one' => '1',
  'two' => '2',
  'three' => '3',
  'four' => '4',
  'five' => '5',
  'six' => '6',
  'seven' => '7',
  'eight' => '8',
  'nine' => '9',
}

def part1(input_lines)
  puts find_sum(input_lines, NUMERIC_NUMBERS_TO_NUMERIC_NUMBERS)
end

def part2(input_lines)
  puts find_sum(input_lines, NUMERIC_NUMBERS_TO_NUMERIC_NUMBERS.merge(SPELLED_NUMBERS_TO_NUMERIC_NUMBERS))
end

def find_sum(input_lines, values_and_replacements)
  sum = 0

  input_lines.each do |line|
    first_number, last_number = get_first_and_last_number(line, values_and_replacements)
    sum += "#{first_number}#{last_number}".to_i
  end

  sum
end

def get_first_and_last_number(line, values_and_replacements)
  matches = values_and_replacements.filter do |value, _replacement|
    line.include?(value)
  end

  first_number = matches.map do |value, replacement|
    [replacement, line.index(value)]
  end.min_by do |_replacement, index|
    index
  end[0]

  last_number = matches.map do |value, replacement|
    [replacement, line.rindex(value)]
  end.max_by do |_replacement, index|
    index
  end[0]

  [first_number, last_number]
end


part1(input_lines)
part2(input_lines)