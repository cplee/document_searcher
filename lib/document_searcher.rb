class DocumentSearcher
  def initialize(base_directory: Dir.pwd)
    if !base_directory || !Dir.exist?(base_directory)
      fail ArgumentError, "Invalid base_directory: #{base_directory}"
    end

    @base_directory = base_directory
  end

  # returns an array of file names that matched
  def search_localized(maximum_words_apart:5, first_term:nil, second_term:nil)
    fail ArgumentError, 'Invalid maximum_word_apart' unless maximum_words_apart > 0
    fail ArgumentError, 'Invalid first_term' unless first_term
    fail ArgumentError, 'Invalid second_term' unless second_term

    # need 2 regexs, to handle the potential for the terms to be in different order in the file
    forward_regex = new_regex(maximum_words_apart: maximum_words_apart,
                              first_term: first_term, second_term: second_term)
    reverse_regex = new_regex(maximum_words_apart: maximum_words_apart,
                              first_term: second_term, second_term: first_term)

    files_that_match = []
    Dir.foreach(@base_directory) do |file_to_search|
      if search_localized_file("#{@base_directory}/#{file_to_search}",
                               forward_regex, reverse_regex)
        files_that_match << "#{@base_directory}/#{file_to_search}"
      end
    end

    return files_that_match
  end

  def new_regex(maximum_words_apart:5, first_term:nil, second_term:nil)
    return Regexp.new('\b' +
                      Regexp.escape(first_term) +
                      '\W+(?:\w+\W+){0,' + maximum_words_apart.to_s + '}?' +
                      Regexp.escape(second_term) + '\b',
                      Regexp::EXTENDED | Regexp::IGNORECASE | Regexp::MULTILINE)
  end

  # search in one file
  def search_localized_file(file_to_search, *regex_pattern_list)
    return false if File.directory? file_to_search

    fail ArgumentError, 'Invalid file' unless File.exist?(file_to_search)

    file_contents = IO.read(file_to_search)
    regex_pattern_list.each do |regex_pattern|
      return true if regex_pattern.match(file_contents)
    end

    return false
  end
end
