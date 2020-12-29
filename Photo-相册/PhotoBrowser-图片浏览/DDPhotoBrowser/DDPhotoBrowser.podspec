#
# Be sure to run `pod lib lint DDPhotoBrowser.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  # 项目的名称
  s.name             = 'DDPhotoBrowser'
  # 项目的版本号，通过项目git的tag标签进行对应，这里的标签代表的版本
  s.version          = '2.0.1'
  # 项目简单的描述信息
  s.summary          = '图片浏览组件'

# 项目的详细描述信息，注意，这里的文字的长度，一定要比上面的s.summary长，不然会认为格式不合格
#  s.description      = '图片浏览 组件描述.'
#TODO: Add long description of the pod here.
  #                       DESC
  # 组件的网页主页
  s.homepage         = 'https://github.com/liuhedong01/DDPhotoBrowser'
  #截图
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  # 开源协议
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  # 作者信息
  s.author           = { 'liuhedong' => 'liuhedong01@163.com' }
  
  # 项目地址，不支持ssh的地址，只支持HTTP和HTTPS
  # tag
  s.source           = { :git => 'https://github.com/liuhedong01/DDPhotoBrowser.git', :tag => s.version.to_s }
  
  # 多媒体介绍地址
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  # 支持的平台及版本
  s.ios.deployment_target = '9.0'

  #代码源文件地址，**/*表示Classes目录及其子目录下所有文件，如果有多个目录下则用逗号分开,
  s.source_files = 'DDPhotoBrowser/Classes/**/*'
  # s.source_files = 'DDPhotoBrowser/Classes/**/*', 'DDPhotoBrowser/Classes2/**/*'

  # s.resource_bundles = {
  #   'DDPhotoBrowser' => ['DDPhotoBrowser/Assets/*.png']
  # }

  # 公开头文件地址
  # s.public_header_files = 'Pod/Classes/**/*.h'
  
  # 所需的framework，多个用逗号隔开
  s.frameworks = 'UIKit', 'Foundation'
  
  # 依赖关系，该项目所依赖的其他，当在加载的时候也会一块把相关的依赖的库加载下来，如果有多个需要填写多个
  # s.dependency 'SDWebImage', '~> 5.0'
   
end
