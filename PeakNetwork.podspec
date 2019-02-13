Pod::Spec.new do |s|

  s.name         = "PeakNetwork"
  s.version      = "4.1.1"
  s.summary      = "A collection of classes to aid performing network operations."
  s.homepage     = "https://github.com/3squared/PeakNetwork"
  s.license      = { :type => 'Custom', :file => 'LICENSE.md' }
  s.author       = { "Sam Oakley" => "sam.oakley@3squared.com" }
  s.platform     = :ios, "11.0"
  s.source       = { :git => "https://github.com/3squared/PeakNetwork.git", :tag => s.version.to_s }
  s.source_files = "PeakNetwork", "PeakNetwork/**/*.{h,m,swift}"
  s.dependency 'PeakOperation'
  s.swift_version = '4.2'

  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  s.macos.deployment_target = '10.13'

  s.source_files = "PeakNetwork", "PeakNetwork/Core/**/*.{h,m,swift}"
  s.ios.source_files = "PeakNetwork/Platforms/iOS/**/*.{h,m,swift}"
  s.tvos.source_files = "PeakNetwork/Platforms/iOS/**/*.{h,m,swift}"
  s.macos.source_files = "PeakNetwork/Platforms/macOS/**/*.{h,m,swift}"

end
