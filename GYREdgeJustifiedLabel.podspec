#
# Be sure to run `pod lib lint GYREdgeJustifiedLabel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GYREdgeJustifiedLabel'
  s.version          = '0.1.3'
  s.summary          = 'A subclass of UILabel allowing for left and right justified text on a single line.'

  s.description      = <<-DESC
    EdgeJustifiedLabel is a UILabel subclass which allows two strings to be shown left and right justified on a single line, and equally scaled or truncated to fit the label bounds.
    This capability is not possible using two separate UILabels and autolayout, as one will always scale before the other, nor is it possible via NSAttributedString, which does not allow left and right justified text to be displayed on a single line.
    Additional options include minimum spacing between the strings, and truncation styles for each string once scaling options have been exhausted.
                       DESC

  s.homepage         = 'https://github.com/gyratorycircus/GYREdgeJustifiedLabel'
  s.screenshots      = 'https://raw.githubusercontent.com/gyratorycircus/GYREdgeJustifiedLabel/master/screenshot.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gyratorycircus' => 'gyratorycircus@icloud.com' }
  s.source           = { :git => 'https://github.com/gyratorycircus/GYREdgeJustifiedLabel.git', :tag => s.version.to_s }

  # While the source code would support iOS 7, "Swift support uses dynamic frameworks and is therefore only supported on iOS > 8."
  s.ios.deployment_target = '8.0'

  s.source_files = 'GYREdgeJustifiedLabel/**/*.swift'
end
