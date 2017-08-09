# Changelog

## Development

## v0.1.1

* Rename wrongly named `-[NAKPlaybackIndicatorViewStyle minBarSpacing]` to `maxBarSpacing`.

## v0.1.0

* Introduce `NAKPlaybackIndicatorViewStyle` class, which allows you to customize `NAKPlaybackIndicatorView`.
* Add `+[NAKPlaybackIndicatorViewStyle iOS10Style]`.
* Require iOS 8 or later.
* Add support for 3x Retina devices.
* Drop support for non-Retina devices.
* Support `-[UIView viewForLastBaselineLayout]` to adapt to iOS 9 API.

## v0.0.3

* Resume the animation when an app has entered background and came back to foreground.

## v0.0.2

* Fix a failure with `pod try`.

## v0.0.1

* Initial release.
