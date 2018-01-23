class Dictionary < ActiveRecord::Base
  validates_presence_of :word
  validates_uniqueness_of :word

  def self.import(file)
    raise ArgumentError, 'No file passed' unless file
    file_data = file.read
    data = file_data.scan(/(?:(?<=\s)|(?<=^))(?=\S*[a-z])[A-z]+(?=\s|$)/).map(&:downcase)
    match_data(data)
  end

  private

  def self.match_data(data)
    result = []
    data.each do |prefix|
      matching_words = data.select{|w| w != prefix && w.starts_with?(prefix)}

      # Remove the prefix and get the suffix words
      suffixes = get_the_suffixes(matching_words, prefix)

      suffixes.each do |suffix|
        logger.info "Searching for suffix #{suffix}"
        found_index = search(data,suffix)
        if found_index
          word_combo = "#{prefix.capitalize} + #{suffix.capitalize} = #{(prefix + suffix).capitalize}"
          logger.info "Found the matching word: #{word_combo}"
          result << find_or_create_by(word: word_combo)
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