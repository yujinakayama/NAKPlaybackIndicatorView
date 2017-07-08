require 'shellwords'

class XcodeTest
  attr_reader :scheme, :device, :os

  def initialize(scheme, device, os)
    @scheme = scheme
    @device = device
    @os = os
  end

  def name
    "#{device} iOS #{os}"
  end

  def id
    name.downcase.gsub(' ', '_').gsub(/[\(\)\-]/, '')
  end

  def run(xcpretty = true)
    command = xcodebuild_command
    command << ' | xcpretty --color' if xcpretty
    system(command) || fail('Test failed!')
  end

  private

  def xcodebuild_command
    command = ['xcodebuild']
    command.concat(['-workspace', workspace])
    command.concat(['-scheme', scheme])
    command.concat(['-destination', destination.map { |key, value| "#{key}=#{value}" }.join(',')])
    command << 'test'
    command.shelljoin
  end

  def workspace
    Dir['*.xcworkspace'].first
  end

  def destination
    {
      platform: 'iOS Simulator',
          name: device,
            OS: os
    }
  end
end

namespace :test do
  devices = [
    'iPhone 6',
    'iPad Pro (12.9-inch)'
  ]

  oses = [
    '9.3',
    '10.3.1',
    'latest'
  ]

  tests = devices.each_with_object([]) do |device, array|
    oses.map do |os|
      array << XcodeTest.new('NAKPlaybackIndicatorView', device, os)
    end
  end

  tests.each do |test|
    desc "Run test on #{test.name}"
    task test.id do
      puts " Running test on #{test.name} ".center(80, '=')
      test.run(!ENV['NO_XCPRETTY'])
    end
  end

  desc 'Run test on all devices'
  task all: tests.map(&:id)
end
