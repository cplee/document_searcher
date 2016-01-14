describe DocumentSearcher do
  describe '#search_localized' do
    context 'when invalid base_directory' do
      it 'raises exception' do
        expect do
          DocumentSearcher.new(base_directory: '/foo')
        end.to raise_error(ArgumentError)
      end
    end

    context 'when invalid word distance' do
      document_searcher = DocumentSearcher.new
      it 'raises exception' do
        expect do
          document_searcher.search_localized(maximum_words_apart: 0,
                                             first_term: 'foo',
                                             second_term: 'bar')
        end.to raise_error(ArgumentError)
      end
    end

    context 'when missing search term' do
      document_searcher = DocumentSearcher.new
      it 'raises exception' do
        expect do
          document_searcher.search_localized
        end.to raise_error(ArgumentError)
      end
    end

    context 'one file on same line' do
      base_directory = File.expand_path('../../sample_files/', __FILE__)

      document_searcher = DocumentSearcher.new(base_directory: base_directory)
      file_matches = document_searcher.search_localized(first_term: 'apple',
                                                        second_term: 'orange')
      it 'contains "foo.txt"' do
        expect(file_matches.length).to be(1)
        expect(file_matches).to include("#{base_directory}/foo.txt")
      end
    end

    context 'one file on same line, insensitive case search' do
      base_directory = File.expand_path('../../sample_files/', __FILE__)

      document_searcher = DocumentSearcher.new(base_directory: base_directory)
      file_matches = document_searcher.search_localized(first_term: 'aPPlE',
                                                        second_term: 'OranGE')
      it 'contains "foo.txt"' do
        expect(file_matches.length).to be(1)
        expect(file_matches).to include("#{base_directory}/foo.txt")
      end
    end

    context 'one file matches phrase across lines' do
      base_directory = File.expand_path('../../sample_files/', __FILE__)

      document_searcher = DocumentSearcher.new(base_directory: base_directory)
      file_matches = document_searcher.search_localized(first_term: 'apple',
                                                        second_term: 'peanut butter')
      it 'contains "foo.txt"' do
        expect(file_matches.length).to be(1)
        expect(file_matches).to include("#{base_directory}/foo.txt")
      end
    end

    context 'one file matches phrase across lines, reverse order' do
      base_directory = File.expand_path('../../sample_files/', __FILE__)

      document_searcher = DocumentSearcher.new(base_directory: base_directory)
      file_matches = document_searcher.search_localized(first_term: 'peanut butter',
                                                        second_term: 'apple')
      it 'contains "foo.txt"' do
        expect(file_matches.length).to be(1)
        expect(file_matches).to include("#{base_directory}/foo.txt")
      end
    end

    context 'file doesnt match phrase across lines, too many words apart' do
      base_directory = File.expand_path('../../sample_files/', __FILE__)

      document_searcher = DocumentSearcher.new(base_directory: base_directory)
      file_matches = document_searcher.search_localized(maximum_words_apart: 3,
                                                        first_term: 'apple',
                                                        second_term: 'cake')
      it 'doesnt find any files' do
        expect(file_matches.length).to be(0)
      end
    end

    context 'multiple files match' do
      base_directory = File.expand_path('../../sample_files/', __FILE__)

      document_searcher = DocumentSearcher.new(base_directory: base_directory)
      file_matches = document_searcher.search_localized(maximum_words_apart: 6,
                                                        first_term: 'principle',
                                                        second_term: 'pleasures')
      it 'matches 2 files' do
        expect(file_matches.length).to be(2)
        expect(file_matches).to include("#{base_directory}/foo.txt")
        expect(file_matches).to include("#{base_directory}/baz.txt")
      end
    end
  end
end
