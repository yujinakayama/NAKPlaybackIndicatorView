#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = 'NAPlaybackIndicatorView'
  s.version      = '0.1.0'
  s.summary      = 'A view that mimics the music playback indicator in the Music.app on iOS 7.'
  s.description  = <<-DESC
                    A view that mimics the music playback indicator in the Music.app on iOS 7.
                    It has three vertical bars and they oscillate randomly.
                   DESC
  s.homepage     = 'https://github.com/yujinakayama/NAPlaybackIndicatorView'
  s.screenshots  = 'https://raw.github.com/yujinakayama/NAPlaybackIndicatorView/master/Documentation/screenshot.png'
  s.license      = 'MIT'
  s.author       = { 'Yuji Nakayama' => 'nkymyj@gmail.com' }
  s.source       = {
                     git: 'https://github.com/yujinakayama/NAPlaybackIndicatorView.git',
                     tag: s.version.to_s
                   }

  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source_files = 'Classes'
  s.public_header_files = 'Classes/NAPlaybackIndicatorView.h'
  s.frameworks = 'QuartzCore'
end
