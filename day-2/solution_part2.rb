def check_segments_of_size_for_repeats(product_id, segment_size)
  length = product_id.length

  # Get the first segment
  # current_segment = product_id[0, segment_size]
  index = 1
  has_repeat = true

  # Split product ID into segments of the given size
  first_segment = product_id[0, segment_size]
  segments = [first_segment]
  while index <= length
    segment = product_id[index - 1, segment_size]

    if index > 0 && segment != segments[0]
      has_repeat = false
    end

    segments << segment
    index = index + segment_size
  end
  
  return has_repeat
end

# There can now be multiple repeats, eg 1212, 123123123, etc.
def check_for_repeats(product_id)
  length = product_id.length

  # Biggest slice is half the length of the ID
  maximum_segment_size = length / 2

  # Start by breaking it into indiviudal characters
  current_segment_size = 1

  # Check if all the segments are the same, if any differences are found we can early return
  while current_segment_size <= maximum_segment_size
    is_repeated = check_segments_of_size_for_repeats(product_id, current_segment_size)
    return true if is_repeated

    # Start checking bigger segments
    current_segment_size = current_segment_size + 1
  end

  return false
end

# There are some invalid IDs.
# These are identified by a sequence of digits repeated twice in a row
# eg. 55, 6464, 123123
def is_valid_id(product_id)
  is_repeated = check_for_repeats(product_id)
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