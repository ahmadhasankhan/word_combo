class Dictionary < ActiveRecord::Base
  validates_presence_of :word
  validates_uniqueness_of :word

  def self.import(file)
    raise ArgumentError, 'No file passed' unless file
    file_data = file.read
    data = file_data.scan(/(?:(?<=\s)|(?<=^))(?=\S*[a-z])[A-z]+(?=\s|$)/).map(&:downcase)
    hashed_date = data.group_by {|name| name[0]}
    match_data(hashed_date)
  end

  private

  def self.match_data(hashed_date)
    result = []
    hashed_date.each_key do |key|
      values = hashed_date[key]
      values.each do |value|
        matching_words = hashed_date[key].select {|w| w != value && w.starts_with?(value)}
        # Remove the prefix and get the suffix words
        suffixes = get_the_suffixes(matching_words, value)
        suffixes.each do |suffix|
          puts "Searching for suffix #{suffix}"
          found_index = search(hashed_date[suffix[0]], suffix)
          if found_index
            word_combo = "#{value.capitalize} + #{suffix.capitalize} = #{(value + suffix).capitalize}"
            result << word_combo
          end
        end
      end
    end
    result
  end

  def self.get_the_suffixes(words, prefix)
    words.map {|w| w.sub(prefix, '')}
  end

  # Since data is already sorted, applying binary sort
  def self.search(array, key)
    return unless array || key
    array.sort!
    low, high = 0, array.length - 1
    while low <= high
      mid = (low + high) >> 1
      case key <=> array[mid]
        when 1
          low = mid + 1
        when -1
          high = mid - 1
        else
          return mid
      end
    end
  end
end