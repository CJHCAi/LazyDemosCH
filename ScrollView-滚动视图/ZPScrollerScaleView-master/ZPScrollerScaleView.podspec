#
# Be sure to run `pod lib lint ZPScrollerScaleView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZPScrollerScaleView'
  s.version          = '1.0.2'
  s.summary          = 'ZPScrollerScaleView: Loop scroll + scroll scale implementation'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Loop scroll + scroll scale implementation.
                       DESC

  s.homepage         = 'https://github.com/ZPP506/ZPScrollerScaleView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ZPP506' => '944160330@qq.com' }
  s.source           = { :git => 'https://github.com/ZPP506/ZPScrollerScaleView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ZPScrollerScaleView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ZPScrollerScaleView' => ['ZPScrollerScaleView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
