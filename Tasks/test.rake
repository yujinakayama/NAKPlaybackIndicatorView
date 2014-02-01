require 'shellwords'

namespace :test do
  devices = [
    'iPhone Retina (4-inch)',
    'iPad',
    'iPad Retina'
  ].each_with_object({}) do |device_name, hash|
    task_name = device_name.downcase.gsub(' ', '_').gsub(/[\(\)\-]/, '')
    hash[task_name] = device_name
  end

  devices.each do |task_name, device_name|
    desc "Run tests on #{device_name}"
    task task_name do
      puts " Running tests on #{device_name} ".center(80, '=')
      run_test(device_name, !ENV['NO_XCPRETTY'])
    end
  end

  desc 'Run tests on all devices'
  task all: devices.keys
end

def run_test(device_name, xcpretty = true)
  workspace = Dir['*.xcworkspace'].first
  scheme = 'NAPlaybackIndicatorView'
  destination = {
    platform: 'iOS Simulator',
        name: device_name
  }
  action = 'test'

  xcodebuild = ['xcodebuild']
  xcodebuild.concat(['-workspace', workspace])
  xcodebuild.concat(['-scheme', scheme])
  xcodebuild.concat(['-destination', destination.map { |key, value| "#{key}=#{value}" }.join(',')])
  xcodebuild << action

  command = xcodebuild.shelljoin
  command << ' | xcpretty --color' if xcpretty
  system(command) || fail('Build failed!')
end
