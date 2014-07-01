# coda-command-line

coda is a command-line tool for Coda 2.

## Usage

    $ coda file1.m file2.m file3.m
    Open a series of files

    $ coda folder/*.m
    Open all files in a folder with .m extension

    $ coda --new-window file1.m
    Opens files in a new Coda 2 window
    
    $ coda --respect-projects ~/Developer/project1/source.m ~/Developer/project2/source.m
    Opens files inside respective projects

## Installation

1. Open coda.xcodeproj and push Build.
2. That's it

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License
coda-command-line is available under the MIT license. See the [LICENSE](https://github.com/zenangst/coda-command-line/blob/master/LICENSE) file for more info.
