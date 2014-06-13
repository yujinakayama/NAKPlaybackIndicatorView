require 'bundler/setup'
require 'rubocop/rake_task'

RuboCop::RakeTask.new(:style)

Dir['Tasks/**/*.rake'].each do |path|
  load(path)
end

desc 'Run CI task'
task ci: %w(test:all style)

task default: 'test:all'
