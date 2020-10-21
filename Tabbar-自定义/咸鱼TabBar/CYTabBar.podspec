Pod::Spec.new do |s|
    s.name         = "CYTabBar"
    s.version      = "1.6.6"
    s.ios.deployment_target = '8.0'
    s.summary      = "A delightful setting interface framework."
    s.homepage     = "https://github.com/zhangchunyu2016/CYTabbar"
    s.license              = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "chunyuZhang" => "707214577@qq.com" }
    s.social_media_url   = "https://github.com/zhangchunyu2016"
    s.source       = { :git => "https://github.com/zhangchunyu2016/CYTabbar.git", :tag => s.version }
    s.source_files  = "CYTabBar/*.{h,m}"
    s.resources          = "CYTabBar/CYTabBar.bundle"
    s.requires_arc = true
end