
workspace 'NAKPlaybackIndicatorView'

pod 'NAKPlaybackIndicatorView', path: 'NAKPlaybackIndicatorView.podspec'

target 'Tests' do
  pod 'Specta',             '~> 0.2'
  pod 'Expecta',            '~> 0.2'
  pod 'OCMock',             '~> 2.2'
  pod 'FBSnapshotTestCase', '~> 1.0'
end

target 'Demo' do
  # We can just inherit outside of this block,
  # but `pod install` fails with empty target block due to a bug.
  pod 'NAKPlaybackIndicatorView', path: 'NAKPlaybackIndicatorView.podspec'
end
