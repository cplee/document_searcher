# Overview
This project provides a utility to search a directory for files that contain 2 phrases within a specified distance from each other.

# Installation
Run `bundle install`.  To run the tests and rubocop, run `rake`

# Running
There is an executable script in `bin/main.rb` that has the following usage:

```
Usage:
    main.rb [OPTIONS] FIRST_TERM SECOND_TERM

Parameters:
    FIRST_TERM                    first search term
    SECOND_TERM                   second search term

Options:
    -b, --base-directory DIRECTORY base directory to search (default: ".")
    -m, --maximum-words-apart NUM_WORDS maximum number of words between matches (default: 5)
    -h, --help                    print help
```

Here is a sample execution:

```
./bin/main.rb -b spec/sample_files apple orange
```

the output is a list of paths that match:

```
spec/sample_files/foo.txt
```

# API
You can also use this as a library:

```
   require 'document_searcher'

   document_searcher = DocumentSearcher.new(base_directory: '.')

   matching_files = document_searcher.search_localized(first_term: 'apple', second_term: 'orange')

   matching_files.each do |file_name|
     puts file_name
   end
```


