# pod install --verbose --no-repo-update
#
# 更新
# pod update --verbose --no-repo-update
# 更新指定库
# pod update s_ios_categories --verbose --no-repo-update
platform :ios, '9.0'

# 配置参考
# https://guides.cocoapods.org/syntax/podfile.html#podfile


source "https://github.com/CocoaPods/Specs.git"
source "https://github.com/shjyy1983/SSpecs.git"
 
 def mylibs_oc
    pod 's_ios_categories/ObjectC'
end


# 通过def命令来声明一个pod集
def libraries
    pod 'AFNetworking'
end
 

target :DemoAudioComp do
    libraries
    mylibs_oc
end
 
