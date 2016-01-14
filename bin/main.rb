#!/usr/bin/env ruby

require 'clamp'
require_relative '../lib/document_searcher'

Clamp do
  option ['-b', '--base-directory'], 'DIRECTORY', 'base directory to search', default: Dir.pwd
  option ['-m', '--maximum-words-apart'], 'NUM_WORDS', 'maximum number of words between matches',
         default: 5 do |string_arg|
           Integer(string_arg)
         end

  parameter 'FIRST_TERM', 'first search term'
  parameter 'SECOND_TERM', 'second search term'

  def execute
    document_searcher = DocumentSearcher.new(base_directory: base_directory)

    matching_files = document_searcher.search_localized(maximum_words_apart: maximum_words_apart,
                                                        first_term: first_term, second_term: second_term)

    matching_files.each do |matched_file|
      puts matched_file
    end
  end
end
