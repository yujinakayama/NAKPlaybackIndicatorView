
pod 'NAPlaybackIndicatorView', path: 'NAPlaybackIndicatorView.podspec'

target 'Tests' do
  pod 'FBSnapshotTestCase', '~> 1.0'
end

target 'Demo' do
  # We can just inherit outside of this block,
  # but `pod install` fails with empty target block due to a bug.
  pod 'NAPlaybackIndicatorView', path: 'NAPlaybackIndicatorView.podspec'
end
