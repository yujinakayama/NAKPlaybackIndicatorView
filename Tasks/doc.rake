
namespace :doc do
  {
    'DocSet' => 'Generate DocSet and install it to Xcode',
    'HTML'   => 'Generate HTML documentation'
  }.each do |type_name, description|
    type = type_name.downcase.to_sym

    desc description
    task type do
      run_appledoc(type)
    end
  end
end

def run_appledoc(output_type)
  project_name = 'NAPlaybackIndicatorView'
  company = 'Yuji Nakayama'
  company_id = 'me.yujinakayama'
  output_path = 'Documentation'
  source_path = 'Classes'

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
  command << source_path

  system(*command)
end
