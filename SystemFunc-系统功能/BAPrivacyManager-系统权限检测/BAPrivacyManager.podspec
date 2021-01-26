Pod::Spec.new do |s|
    s.name         = 'BAPrivacyManager'
    s.version      = '1.0.1'
    s.summary      = 'iOS 所有隐私权限封装，定位、蓝牙、通知、运动、日历、相册、相机等 14 种权限封装！详见 demo！'
    s.homepage     = 'https://github.com/BAHome/BAPrivacyManager'
    s.license      = 'MIT'
    s.authors      = { 'boai' => 'sunboyan@outlook.com' }
    s.platform     = :ios, '8.0'
    s.source       = { :git => 'https://github.com/BAHome/BAPrivacyManager.git', :tag => s.version.to_s }
    s.source_files = 'BAPrivacyManager/BAPrivacyManager/*.{h,m}'
    s.requires_arc = true
end
