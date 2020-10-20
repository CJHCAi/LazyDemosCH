#
#  Be sure to run `pod spec lint GuideView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
s.name     = 'HYCGuideView'
s.version  = '1.3' 
s.license  = "MIT"
s.summary  = '添加手图,导航图' 
s.homepage = 'https://github.com/hyc286716320/HYCGuideView'
s.author   = {'HuYunchao' => 'hyc286716320'} 
s.source   = { :git => 'https://github.com/hyc286716320/HYCGuideView.git', :tag =>s.version} 
s.platform     = :ios 
s.source_files = 'HYCGuideView/HYCGuideView'
s.requires_arc = true

#s.dependency 'TMUtils', '~> 1.0'
end

