# Batteries have a joltage rating from 1-9
# Batteries are arranged in banks
# Each line in the input file is a bank
# We need to turn exactly 2 batteries from each bank
# The joltage produced is equal to the number formed by the two digits
# eg. for the bank 12345, turning on 2 and 4 would produce 24 jolts
# We need to find the max joltage a bank can produce
# The total output joltage is the sum of all the maximum joltages from each bank

# Parse input to a 2D array
def get_banks(input)
  banks_list = []

  # Loop through each line in the file and construct the banks
  input_split = input.split("\n")
  input_split.each do |line|
    current_bank = []

    # Loop through each int character in the line and add to the current bank
    line_split = line.split("")
    line_split.each do |char|
      current_bank << char.to_i
    end

    banks_list << current_bank
  end

  return banks_list
end

def get_max_joltage(bank)
  # This is in the format [index, value]
  left_battery = [0, bank[0]] # Left battery starts as the first int
  right_battery = [1, bank[1]] # Right battery starts as the second int
  current_joltage = (left_battery[1] * 10) + right_battery[1]

  # Loop through the bank and find the largest combination
  bank.each_with_index do |battery_value, battery_index|
    # Skip the first two indices since we already have those assigned
    if battery_index < 2
      next
    end

    # We have 89 currently, if this is a 2 then swapping
    joltage_replacing_right = (left_battery[1] * 10) + battery_value # 81, less
    joltage_replacing_left = (right_battery[1] * 10) + battery_value # 92, more

    # Neither is higher than current, skip
    if joltage_replacing_left < current_joltage && joltage_replacing_right < current_joltage
      next
    end

    # Check if replacing the left battery is better
    if joltage_replacing_right > joltage_replacing_left 
      right_battery = [battery_index, battery_value]
      current_joltage = joltage_replacing_right
    # Otherwise, just replace the right battery
    else
      left_battery = [right_battery[0], right_battery[1]]
      right_battery = [battery_index, battery_value]
      current_joltage = joltage_replacing_left
    end
  end

  # Return the combined joltage
  battery_indices = [left_battery[0], right_battery[0]]
  max_joltage = (left_battery[1] * 10) + right_battery[1]

  return [battery_indices, max_joltage]
end

# For the example data, we should get 98, 89, 92
# input = File.read("day-3/example.txt").chomp
input = File.read("day-3/input.txt").chomp
banks = get_banks(input)

total_joltage = 0
banks.each do |bank|
  puts "Getting max joltage for bank: #{bank}"
  battery_indices, max_joltage = get_max_joltage(bank)
  puts "Max joltage: #{max_joltage} from batteries at indices #{battery_indices.inspect}"
  total_joltage += max_joltage
end

puts "Total joltage from all banks: #{total_joltage}"