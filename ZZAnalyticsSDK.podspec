#
# Be sure to run `pod lib lint AnalyticsSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#


Pod::Spec.new do |s|
  s.name             = 'ZZAnalyticsSDK'
  s.version='1.0.1'

  s.summary          = 'A short description of ZZAnalyticsSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/wbzlop/ZZAnalytics'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wubaozeng' => 'wubaozeng@gamegoing.net' }
  
  s.source           = { :git => 'https://github.com/wbzlop/ZZAnalytics.git',:tag => s.version}
  #s.source           = { :git => '/Users/wbz/Documents/work/AnalyticsSDK',:branch => "release/#{s.version}"}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.prefix_header_file = 'AnalyticsSDK/AnalyticsSDK-Prefix.pch'

  s.source_files = ['AnalyticsSDK/**/*.{c,h,m,mm}']

  s.frameworks = "AdSupport", "CoreTelephony", "SystemConfiguration"

  s.public_header_files = ['AnalyticsSDK/AnalyticsSDK.h']

  s.requires_arc = true

  s.pod_target_xcconfig = { 'OTHER_CFLAGS' => '-fembed-bitcode','VALID_ARCHS' => 'arm64'}

  #s.resource=['LFMediation/Info.plist']

  s.dependency 'WCDB'



end
