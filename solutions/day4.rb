WHITESPACE_REGEX = /\s+/

class Card
  def initialize(winning_numbers, index)
    @winning_numbers = winning_numbers
    @index = index
  end

  attr_accessor :winning_numbers, :index
end

def part1(input_lines)
  cards = create_cards(input_lines)
  cards.map do |card|
    if card.winning_numbers.any?
      2**(card.winning_numbers.size - 1)
    else
      0
    end
  end.reduce(:+)
end

def part2(input_lines)
  cards = create_cards(input_lines)

  index_to_card_with_quantity = cards.map.with_index do |card, index|
    [index, [card, 1]]
  end.to_h

  cards.each.with_index do |card, index|
    if card.winning_numbers.any?
      quantity = index_to_card_with_quantity[index].last
      quantity.times do
        (1..card.winning_numbers.size).map do |count|
          index_to_add = index + count
          current_value = index_to_card_with_quantity[index_to_add]
          index_to_card_with_quantity[index_to_add] = [current_value.first, current_value.last + 1]
        end
      end
    end
  end

  index_to_card_with_quantity.values.map(&:last).reduce(:+)
end

def create_cards(input_lines)
  input_lines.map.with_index do |line, index|
    split_line = line.split(' | ')

    card_winning_numbers = split_line.first.split(': ').last.strip.split(WHITESPACE_REGEX).map do |winning_number|
      winning_number.to_i
    end
    potential_winning_numbers = split_line.last.strip.split(WHITESPACE_REGEX).map do |potential_winning_number|
      potential_winning_number.to_i
    end

    Card.new(card_winning_numbers & potential_winning_numbers, index)
  end
end

input_lines = File.new('inputs/day4.txt').readlines(chomp: true)
puts part1(input_lines)
puts part2(input_lines)