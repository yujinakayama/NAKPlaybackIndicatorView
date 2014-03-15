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
  project_name = 'NAKPlaybackIndicatorView'
  company = 'Yuji Nakayama'
  company_id = 'me.yujinakayama'
  output_path = 'Documentation'
  # Omitting NAKPlaybackIndicatorContentView.h since it's private header.
  source_paths = ['Classes/NAKPlaybackIndicatorView.h']

  action = case output_type
           when :docset
             ['--install-docset']
           when :html
             ['--create-html', '--no-create-docset']
           else
             fail "Unknown documentation type #{output_type}!"
           end

  command = ['appledoc']
  command.concat(['--project-name', project_name])
  command.concat(['--project-company', company])
  command.concat(['--company-id', company_id])
  command.concat(action)
  command.concat(['--output', output_path])
  command.concat(source_paths)

  system(*command)
end
