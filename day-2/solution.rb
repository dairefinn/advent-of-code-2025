# There are some invalid IDs.
# These are identified by a sequence of digits repeated twice in a row
# eg. 55, 6464, 123123
def is_valid_id(product_id)
  # Split it in half
  length = product_id.length

  # If the length is odd, it can't be repeated
  return true if length.odd?

  half_length = length / 2
  first_half = product_id[0, half_length]
  second_half = product_id[half_length, half_length]

  # If both halves are the same, it's invalid
  is_repeated = first_half == second_half
  return false if is_repeated

  # None of the numbers have leading 0s
  has_leading_zero = product_id[0] == "0"
  return false if has_leading_zero
  
  return true
end

# Gets the start and end range from a range string
def extract_ranges(input)
  parts = input.split("-")
  range_start = parts[0]
  range_end = parts[1]

  return [range_start, range_end]
end

# Parses ranges into a 2D array eg [["100", "200"], ["300", "400"]]
def parse_ranges(input)
  input_split = input.split(",")
  return input_split.map do |part|
    extract_ranges(part)
  end
end

# Input is a CSV of product ID ranges.
# Each range is two integers separated by a dash, the first being the start of the range and the second being the end.
# In the input they are on a single long line
# input = File.read("day-2/example.txt").chomp
input = File.read("day-2/input.txt").chomp
ranges = parse_ranges(input)
# puts "Parsed ranges: #{ranges.inspect}"

# We need to find all the invalid IDs and add them up
invalid_ids = []

ranges.each do |range|
  puts "Checking range: #{range.inspect}"
  range_start = range[0].to_i
  range_end = range[1].to_i

  current_range = range_start
  while current_range <= range_end
    is_valid = is_valid_id(current_range.to_s)
    unless is_valid
      puts "Found invalid ID: #{current_range}"
      invalid_ids << current_range
    end
    current_range = current_range + 1
  end
end

sum_of_invalid_ids = invalid_ids.map(&:to_i).sum

puts "The sum of all invalid product IDs is #{sum_of_invalid_ids}."