
Pod::Spec.new do |s|
  s.name             = "MMSideslipDrawer"
  s.version          = "1.2"
  s.summary          = "A side slip drawer used on iOS."
  s.homepage         = "https://github.com/CheeryLau/MMSideslipDrawer"
  s.license          = 'MIT'
  s.author           = { "Cheery Lau" => "1625977078@qq.com" }
  s.source           = { :git => "https://github.com/CheeryLau/MMSideslipDrawer.git", :tag => s.version.to_s }
  s.platform         = :ios, '7.0'
  s.requires_arc     = true
  s.source_files     = 'MMSideslipDrawer/**/*.{h,m}'
  s.frameworks       = 'Foundation', 'UIKit'

end
