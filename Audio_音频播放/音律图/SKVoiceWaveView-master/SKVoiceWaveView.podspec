Pod::Spec.new do |s|
s.name = "SKVoiceWaveView"
s.version = "1.0.0"
s.ios.deployment_target = '8.0'
s.summary = "Automatic-Guidance"
s.homepage = "https://github.com/macios/SKVoiceWaveView"
s.license = 'MIT'
s.authors = { "SK" => "nil.com" }
s.source = { :git => "https://github.com/macios/SKVoiceWaveView.git", :tag => "1.0.0" }
s.frameworks = 'UIKit','AVFoundation'
s.source_files = 'SKVoiceWave/**/SKVoiceWaveView/*.{h,m}'
s.requires_arc = true
end
