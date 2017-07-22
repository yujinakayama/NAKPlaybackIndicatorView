require 'shellwords'

namespace :doc do
  {
    docset: 'Generate DocSet and install it to Xcode',
      html: 'Generate HTML documentation'
  }.each do |doc_type, description|
    desc description
    task doc_type do
      run_appledoc(doc_type)
    end
  end

  desc 'Publish documentation via GitHub pages'
  task ghpage: :html do
    commit_message = 'Auto-commit by doc:ghpage task'
    repo_url = 'git@github.com:yujinakayama/NAKPlaybackIndicatorView.git'
    branch = 'gh-pages'

    Dir.chdir('Documentation/html') do
      system('git init')
      system("git checkout -b #{branch.shellescape}")
      system('git add -A')
      system("git commit -m #{commit_message.shellescape}")
      system("git remote add origin #{repo_url.shellescape}")
      system("git push -f origin #{branch.shellescape}")
    end
  end
end

def run_appledoc(output_type)
  actions =
    case output_type
    when :docset then ['--install-docset']
    when :html   then ['--create-html', '--no-create-docset']
    else raise
    end

  command = [
    'appledoc',
    '--project-name', 'NAKPlaybackIndicatorView',
    '--project-company', 'Yuji Nakayama',
    '--company-id', 'me.yujinakayama',
    '--output', 'Documentation',
    actions,
    # Omitting NAKPlaybackIndicatorContentView.h since it's private header.
    'Classes/NAKPlaybackIndicatorView.h'
  ].flatten

  system(*command)
end
