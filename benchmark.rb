# Starting omnifocus


# Rehearsal --------------------------------------------------------------
# through /usr/bin/osascript   0.020000   0.050000   3.560000 (  4.665417)
# through appscript            0.060000   0.090000   0.150000 (  0.135597)
# ----------------------------------------------------- total: 3.710000sec

#                                  user     system      total        real
# through /usr/bin/osascript   0.010000   0.040000   3.490000 (  4.604980)
# through appscript            0.060000   0.080000   0.140000 (  0.131573)

# Loading projects


# Rehearsal --------------------------------------------------------------
# through /usr/bin/osascript   0.020000   0.050000   4.540000 (  5.911968)
# through appscript            0.110000   0.110000   0.220000 (  0.390105)
# ----------------------------------------------------- total: 4.760000sec

#                                  user     system      total        real
# through /usr/bin/osascript   0.020000   0.050000   4.540000 (  5.879542)
# through appscript            0.080000   0.100000   0.180000 (  0.331314)

require 'benchmark'
require 'appscript'
include Appscript
require 'open3'

def osascript(script, language = "AppleScript")
  stdin, stdout = Open3.popen2("osascript -l #{language}")

  stdin.puts script
  stdin.close

  stdout.read
end

def start_omnifocus
  osascript <<-EOF
    tell application "System Events"
      if not (exists process "OmniFocus") then
        tell application "OmniFocus" to activate
      end if
    end tell
  EOF
end

def projects
  script = <<-EOF
    var app = Application('OmniFocus');
    var doc = app.defaultDocument;

    projects = doc.flattenedProjects.whose({completed: false})()

    names = projects.map(function(project) {
      return project.name();
    })

    names
  EOF

  projects_string = osascript(script, "JavaScript").force_encoding("UTF-8")
  projects_string.split(",").map(&:strip)
end

def appscript_projects
  whose = its
  app("OmniFocus").default_document.flattened_projects[whose.completed.eq(false)].name.get
end

Times = 50

puts "\nStarting omnifocus\n\n\n"

Benchmark.bmbm do |bm|
  bm.report('through /usr/bin/osascript') do
    Times.times do
      start_omnifocus
    end
  end

  bm.report('through appscript') do
    Times.times do
      unless app("OmniFocus").is_running?
        app("OmniFocus").activate
      end
    end
  end
end

puts "\nLoading projects\n\n\n"

Benchmark.bmbm do |bm|
  bm.report('through /usr/bin/osascript') do
    Times.times do
      projects
    end
  end

  bm.report('through appscript') do
    Times.times do
      appscript_projects
    end
  end
end
