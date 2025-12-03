# Batteries have a joltage rating from 1-9
# Batteries are arranged in banks
# Each line in the input file is a bank
# We need to turn exactly 2 batteries from each bank - 12 for part 2
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

def calculate_joltage(batteries)
  joltage_string = ""
  batteries.each do |battery|
    joltage_string += battery.to_s
  end
  return joltage_string.to_i
end

def get_max_joltage(bank)
  batteries_to_select = 12
  bank_size = bank.length
  
  selected_batteries = []
  start_index = 0
  batteries_to_select.times do |slot|
    remaining_slots = batteries_to_select - slot
    max_possible_index = bank_size - remaining_slots
    best_value = -1
    best_index = -1

    # Loop through the possible batteries and find the best one
    current_index = start_index
    while current_index <= max_possible_index
      current_bank_value = bank[current_index]

      if best_value == -1 || current_bank_value > best_value
        best_value = current_bank_value
        best_index = current_index
      end

      current_index += 1
    end

    # Add the best battery found to the selected list
    selected_batteries << best_value

    # Next search starts just after the best battery found
    start_index = best_index + 1
  end

  max_joltage = calculate_joltage(selected_batteries)

  puts "Final batteries: #{selected_batteries.inspect}, max joltage: #{max_joltage}"
  return max_joltage
end

# For the example data, we should get 98, 89, 92
input = File.read("day-3/example.txt").chomp
# input = File.read("day-3/input.txt").chomp
banks = get_banks(input)

total_joltage = 0
banks.each do |bank|
  puts "Getting max joltage for bank: #{bank}"
  max_joltage = get_max_joltage(bank)
  total_joltage += max_joltage
end

puts "Total joltage from all banks: #{total_joltage}"

# This solution sucks and is a mess of loops, my apolocheese ¯\_(ツ)_/¯
