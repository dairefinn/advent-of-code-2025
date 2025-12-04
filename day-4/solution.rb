# Input is a grid of characters where:
# - @ represents a roll of paper
# - . represents empty space
# The forklifts can only access a role if there are fewer than 4 rolls of paper in the 8 adjacent cells
# Based on the input, we need to find the number of rolls of paper that are accessible by the forklifts

def build_grid_of_size(row_count, column_count)
  output_grid = []

  row_count.times do
    new_row = []
    column_count.times do
      new_row << 0
    end
    output_grid << new_row
  end

  return output_grid
end

# Parse output into a 2D array
def parse_input(base_input)
  rows = base_input.split("\n")
  first_row = rows[0]

  # Get grid size
  row_count = rows.length
  column_count = first_row.length

  # Build output grids so they are the same size as the input
  output_rolls = build_grid_of_size(row_count, column_count)
  output_adjacent_counts = build_grid_of_size(row_count, column_count)

  # Iterate through input and build both grids
  rows.each_with_index do |line, row_index|
    cols = line.split("")
    
    cols.each_with_index do |char, column_index|
      if char == "@"
        # Increment roll count at same index
        output_rolls[row_index][column_index] += 1

        # Increment all the spaces around the current cell in the adjacent counts grid
        cursor_x = -1
        while cursor_x <= 1 do
          cursor_y = -1
          while cursor_y <= 1 do
            # Skip the position of the roll
            if cursor_x == 0 && cursor_y == 0
              cursor_y += 1
              next
            end

            # Get the indices of the adjacent cells
            adjacent_row = row_index + cursor_x
            adjacent_col = column_index + cursor_y

            cursor_y += 1

            # Make sure we only edit the cells around the edges if they exist
            next if adjacent_row < 0 || adjacent_col < 0
            next if adjacent_row >= row_count || adjacent_col >= column_count

            # Increment the count
            output_adjacent_counts[adjacent_row][adjacent_col] += 1
          end

          cursor_x += 1
        end
      end
    end
  end

  # Log em
  puts "\nRolls grid:"
  output_rolls.each do |line|
    puts line.inspect
  end

  puts "\nAdjacent counts grid:"
  output_adjacent_counts.each do |line|
    puts line.inspect
  end

  return [output_rolls, output_adjacent_counts]
end

# Compares the two grids and counts the number of rolls that are reachable
def get_reachable_rolls_count(grid_rolls, grid_adjacent_counts)
  reachable_count = 0

  grid_rolls.each_with_index do |row, row_index|
    row.each_with_index do |cell, column_index|
      next if cell == 0
      next if grid_adjacent_counts[row_index][column_index] >= 4
      reachable_count += 1
    end
  end

  return reachable_count
end

# Read input from file
# input = File.read("day-4/example.txt")
input = File.read("day-4/input.txt")

grid_rolls, grid_adjacent_counts = parse_input(input)

reachable_count = get_reachable_rolls_count(grid_rolls, grid_adjacent_counts)

puts "\nNumber of reachable rolls of paper: #{reachable_count}"