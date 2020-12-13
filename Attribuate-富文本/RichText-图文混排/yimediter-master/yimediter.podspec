Pod::Spec.new do |s|
s.name         = 'yimediter'
s.version      = '0.1.7'
s.summary      = 'A Rich Text Editor'
s.homepage     = 'https://github.com/yiiim/yimediter'
s.license      = 'MIT'
s.authors      = {'ybz' => 'ybz975218925@live.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/yiiim/yimediter.git', :tag => s.version}
s.source_files = 'yimediter/yimediter/ybzediter/**/*.{h,m,c}','yimediter/*.{h,m}'
s.resource     = 'yimediter/yimediter/ybzediter/resource/*.bundle'
s.requires_arc = true
end
