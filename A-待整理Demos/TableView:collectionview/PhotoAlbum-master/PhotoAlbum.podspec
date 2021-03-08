Pod::Spec.new do |s|
  s.name             = 'PhotoAlbum'
  s.version          = '0.6.0'
  s.summary          = 'A PhotoAlbum which supports multi-Photo selection, single-Photo selection, video.'
  s.homepage         = 'https://github.com/AngleZhou/PhotoAlbum'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ZhouQian' => 'zhouq87724@163.com' }
  s.source           = { :git => 'https://github.com/AngleZhou/PhotoAlbum.git', :tag => s.version.to_s}
  s.ios.deployment_target = '8.0'
  s.source_files = 'PhotoAlbum/Classes/**/*'
  s.resource = 'PhotoAlbum/Assets/*.{bundle,xib}'
  s.frameworks = 'UIKit'
  s.requires_arc = true
end
