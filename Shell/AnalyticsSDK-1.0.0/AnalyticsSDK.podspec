Pod::Spec.new do |s|
  s.name = "AnalyticsSDK"
  s.version = "1.0.0"
  s.summary = "A short description of AnalyticsSDK."
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"wubaozeng"=>"wubaozeng@gamegoing.net"}
  s.homepage = "https://github.com/zz/AnalyticsSDK"
  s.description = "TODO: Add long description of the pod here."
  s.requires_arc = true
  s.source = { :path => '.' }

  s.ios.deployment_target    = '8.0'
  s.ios.vendored_framework   = 'ios/AnalyticsSDK.framework'
end
