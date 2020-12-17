#
#  Be sure to run `pod spec lint CCTextField.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "CCTextField"
  s.version      = "1.2.6"
  s.summary      = "Custom UITextField"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.homepage     = "https://github.com/cdcyd/CCTextField"
  s.description  = <<-DESC
                        自定义TextField，解决输入限制、键盘弹出问题
                     DESC

  s.author                  = { "cyd" => "1035060416@qq.com" }
  s.social_media_url        = "https://cdcyd.github.io/"
  s.ios.deployment_target   = "8.0"
  s.source                  = { :git => "https://github.com/cdcyd/CCTextField.git", :tag => "v1.2.6" }
  s.source_files            = 'TextField'
  s.public_header_files     = 'TextField/*.h'

  # s.resource       = "icon.png"
  # s.resources      = "Resources/*.png"
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"
  # s.framework      = "SomeFramework"
  # s.frameworks     = "SomeFramework", "AnotherFramework"
  # s.library        = "iconv"
  # s.libraries      = "iconv", "xml2"
  # s.requires_arc   = true
  # s.xcconfig       = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
