def part1(input_lines)
  count = 0
  schematic = get_schematic(input_lines)

  current_numbers_with_coordinates = []
  schematic.each.with_index do |row, row_index|
    row.each.with_index do |character, column_index|
      if character =~ /\d/
        current_numbers_with_coordinates += [[character, [row_index, column_index]]]
      else
        should_count_number = current_numbers_with_coordinates.any? do |number_with_coordinates|
          surrounding_symbol_locations(schematic, number_with_coordinates[1][0], number_with_coordinates[1][1]).any?
        end

        if should_count_number
          count += current_numbers_with_coordinates.map(&:first).join('').to_i
        end
        current_numbers_with_coordinates = []
      end
    end
  end

  count
end

def part2(input_lines)
  schematic = get_schematic(input_lines)
  current_numbers_with_coordinates = []
  gear_coordinates_to_part_numbers = {}

  schematic.each.with_index do |row, row_index|
    row.each.with_index do |character, column_index|
      if character =~ /\d/
        current_numbers_with_coordinates += [[character, [row_index, column_index]]]
      else
        gear_locations = current_numbers_with_coordinates.map do |number_with_coordinates|
          surrounding_symbol_locations(schematic, number_with_coordinates[1][0], number_with_coordinates[1][1], /\*/)
        end.flatten(1).uniq

        gear_locations.each do |gear_location|
          current_part_numbers = gear_coordinates_to_part_numbers.fetch([gear_location[0], gear_location[1]], [])
          gear_coordinates_to_part_numbers[[gear_location[0], gear_location[1]]] = current_part_numbers << current_numbers_with_coordinates.map(&:first).join('').to_i
        end
        current_numbers_with_coordinates = []
      end
    end
  end

  gear_coordinates_to_part_numbers.filter do |coordinates, part_numbers|
    part_numbers.size >= 2
  end.values.map do |part_numbers|
    part_numbers.reduce(:*)
  end.reduce(:+)
end

def get_schematic(input_lines)
  input_lines.map do |line|
    line.chars
  end
end

# Regex default to anything that's not a number or a period (should match against all symbols)
def surrounding_symbol_locations(schematic, row_index, column_index, regex = /[^0-9\.]/)
  # left, right, up, down, up-left, up-right, down-left, down-right
  [
    symbol_location(schematic, row_index, column_index - 1, regex),
    symbol_location(schematic, row_index, column_index + 1, regex),
    symbol_location(schematic, row_index - 1, column_index, regex),
    symbol_location(schematic, row_index + 1, column_index, regex),
    symbol_location(schematic, row_index - 1, column_index - 1, regex),
    symbol_location(schematic, row_index - 1, column_index + 1, regex),
    symbol_location(schematic, row_index + 1, column_index - 1, regex),
    symbol_location(schematic, row_index + 1, column_index + 1, regex)
  ].compact
end

def symbol_location(schematic, row_index, column_index, regex)
  if row_index < 0 || row_index >= schematic[0].size || column_index < 0 || column_index >= schematic.size
    return nil
  end

  if schematic[row_index][column_index] =~ regex
    [row_index, column_index]
  end
end


input_lines = File.new('inputs/day3.txt').readlines(chomp: true)
puts part1(input_lines)
puts part2(input_lines)