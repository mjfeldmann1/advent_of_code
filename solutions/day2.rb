COLOR_LIMITS = {
  red: 12,
  green: 13,
  blue: 14,
}

def part1(input_lines)
  result = input_lines.map do |line|
    if within_limits?(get_max_color_quantities(line), COLOR_LIMITS)
      game_id(line).to_i
    else
      0
    end
  end.reduce(:+)
end

def part2(input_lines)
  result = input_lines.map do |line|
    get_max_color_quantities(line).values.reduce(:*)
  end.reduce(:+)
end

def get_max_color_quantities(line)
  game_id = game_id(line)

  # Add 2 to remove the : and the space after the : in the input
  cube_subset_starting_index = line.index(game_id) + game_id.size + 2
  cube_subsets = line[cube_subset_starting_index..-1].split('; ')
  rolls = cube_subsets.map do |subset|
    subset.split(', ')
  end.flatten

  rolls.each.with_object({}) do |roll, color_to_max_quantity|
    value, color = roll.split(' ')
    current_max_quantity_for_color = color_to_max_quantity.fetch(color.to_sym, 0)
    if value.to_i > current_max_quantity_for_color
      color_to_max_quantity[color.to_sym] = value.to_i
    end

    color_to_max_quantity
  end
end

def within_limits?(color_to_max_quantity, color_limits)
  color_to_max_quantity.map do |color, max_quantity|
    if max_quantity > color_limits[color]
      return false
    end
  end
  true
end

def game_id(line)
  line.match(/\d+/)[0]
end


input_lines = File.new('inputs/day2.txt').readlines(chomp: true)
puts part1(input_lines)
puts part2(input_lines)