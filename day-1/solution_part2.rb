def get_movement_value(rotation)
  # First character is direction, L or R
  direction = rotation[0]

  # The rest is the distance to turn
  distance = rotation[1..-1].to_i

  # Determine if we're increasing or decreasing the dial position
  increment = direction == "R" ? 1 : -1

  # Otherwise, we leave it positive
  return [increment, distance]
end

def move_dial(current_position, direction, count_0)
  movement_increment, movement_value = get_movement_value(direction)

  remaining_movement = movement_value
  while remaining_movement > 0
    current_position += movement_increment
    remaining_movement -= 1

    if current_position > 99
      current_position = 0
    end

    if current_position < 0
      current_position = 99
    end

    if current_position == 0
      count_0 += 1
    end
  end

  [current_position, count_0]
end

# The dial starts pointing at 50
dial_position = 50
times_at_0 = 0

# Sample movements to validate with example
# movements = File.readlines("day-1/example.txt").map(&:chomp)

# Read from input.txt, each line is a movement
movements = File.readlines("day-1/input.txt").map(&:chomp)

puts "Dial starts at #{dial_position}"
movements.each do |movement|
  dial_position, times_at_0 = move_dial(dial_position, movement, times_at_0)
  puts "Dial moved #{movement} to #{dial_position}"
end

puts "The dial clicks at 0 a total of #{times_at_0} times."