Pod::Spec.new do |s|
  s.name     = 'AFNetworkingMeter'
  s.version  = '0.0.9'
  # s.license  = 'MIT'
  # s.summary  = ''
  s.homepage = 'https://github.com/stanislaw/AFNetworkingMeter'
  # s.authors  = { 'Mattt Thompson' => 'm@mattt.me' }
  s.source   = { :git => 'https://github.com/stanislaw/AFNetworkingMeter.git', :tag => s.version.to_s }
  s.source_files = 'AFNetworkingMeter/*.{h,m}'
  s.private_header_files = 'AFNetworkingMeter/AFNetworkingMeterData.h, AFNetworkingMeter/AFHTTPRequestOperation+StartDate.h'

  s.requires_arc = true

  s.ios.deployment_target = '5.0'

  s.osx.deployment_target = '10.7'

  s.dependency 'AFNetworking'
end
