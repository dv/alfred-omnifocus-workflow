# Alfred 2 OmniFocus Workflow

A workflow for Alfred 2 to create Tasks quickly. It will give you a list of possible projects or contexts to add to, and try to autocomplete what you've already typed.

## Screenshots

Selecting a project to create your task in:

![Selecting a project to create your task in](/screenshots/project_select.png?raw=true "Selecting a project to create your task in")

An example of the autocomplete feature for projects:

![Autocompleting projects](/screenshots/project_autocomplete.png?raw=true "Autocompleting projects")

Lastly, an example of the autocomplete feature for contexts:

![Autocompleting contexts](/screenshots/context_autocomplete.png?raw=true "Autocompleting contexts")


## Usage

In Alfred, start typing `todo` and then the task you want to add. The workflow will give you the option to add the task to a project. You can also manually add the task to a project by typing `:` or `::` and then the name of the project. Add a context by typing `@` and the name of a context.

I'll defer to [Brandon Pittman](http://pixelsnatch.com/omnifocus/) for a thorough explanation:

> It’s a format that OmniFocus uses to parse task information like so:
>
> `Do something! @home ::misc #5pm #tomrrow //This is a note`
>
> The `!` makes `Do something` a flagged task. `@home` sets the context to “home”. `::` is used for matching a project. Both `@` and `::` will fuzzy match existing contexts and projects. The first `#` is used for a defer date, while the second `#` is for a due date. Both support natural language parsing like the inspector in OmniFocus. Word of caution though, if only one `#` is present, OmniFocus assumes it’s a due date. Lastly, `//` starts the note for a task.


## Installation

Fastest way is to just [download the alfred workflow binary](/omnifocus.alfredworkflow?raw=true). You probably need to install `bundler` too:

    sudo gem install bundler

### Build from source

You can also build the workflow from source. I haven't gotten Alfred to work with `rbenv` so make sure to install the necessary gems using the `system` ruby:

    sudo gem install bundler plist

Then install the bundled gems:

    rake bundle:install

And install the workflow:

    rake install

## Tests

Yes, I did build tests for my Alfred workflow. TDD all the way!

    sudo gem install rspec
    rake spec

These tests only run on OSX and do require OmniFocus be installed. I'm sorry to say I didn't stub/fake/mock AppleScript away. I understand this means Kent Beck will come and murder me in my sleep.

## Addendum: AppleScript benchmark

This is my first foray into working with AppleScript, and I was quite excited to explore the current state of affairs, especially related to Ruby.

My first version piped raw AppleScript into `/usr/bin/osascript` and parsed the results. This was too lag-prone to be used in Alfred, where speed is especially key to a good user experience. I then looked at how other people run AppleScript from within Ruby.

There are quite a few gems that fit my needs but [`rb-appscript`](http://appscript.sourceforge.net/rb-appscript/) looked to be the most popular one. Unfortunately, while the last update stems from as recent as November 2014 it is apparently no longer under active development and its website states that it is not recommended to be used for new projects. It worked fine for my uses still, so I decided to laugh in the face of danger and use it for a new project anyway.

Being a man of numbers it was imperative that I checked if using `rb-appscript` would net a decent speed improvement as a trade-off for adding this dependency. That's where [`benchmark.rb`](/benchmark.rb?raw=true) comes in. The results were great: using `rb-appscript` as opposed to piping code into `/usr/bin/osascript` made things 20x to 40x faster. Success!

## Author

[David Verhasselt](http://github.com.dv) - david@crowdway.com

Build using Zhao Cai's [Alfred2 Ruby Framework]( https://github.com/canadaduane/alfred2-ruby-framework )


## See also
* [alfred2-ruby-framework]( https://github.com/canadaduane/alfred2-ruby-framework )
* [rb-appscript](http://appscript.sourceforge.net/rb-appscript/)
