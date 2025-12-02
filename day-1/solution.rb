def get_movement_value(rotation)
  # First character is direction, L or R
  direction = rotation[0]

  # The rest is the distance to turn
  distance = rotation[1..-1].to_i

  # If direction is L, we make sure it's negative
  if direction == "L"
    distance = distance * -1
  end

  # Otherwise, we leave it positive
  return distance
end

def move_dial(current_position, direction, count_0)
  movement_value = get_movement_value(direction)
  new_position = current_position + movement_value

  # Wrap around the dial if needed until it's between 0 and 99
  while new_position < 0 || new_position > 99
    if new_position < 0
      new_position += 100
    elsif new_position > 99
      new_position -= 100
    end
  end

  # The actual password is the number of times the dial points to 0
  if new_position == 0
    count_0 = count_0 + 1
  end

  [new_position, count_0]
end

# The dial starts pointing at 50
dial_position = 50
times_at_0 = 0

# Sample movements to validate with example
# movements = File.readlines("day-1/example.txt").map(&:chomp)

# Read from input.txt, each line is a movement
movements = File.readlines("day-1/input.txt").map(&:chomp)

movements.each do |movement|
  dial_position, times_at_0 = move_dial(dial_position, movement, times_at_0)
  puts "Dial moved #{movement} to #{dial_position}"
end

puts "The dial points to 0 a total of #{times_at_0} times."