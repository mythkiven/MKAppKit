
Pod::Spec.new do |s|

  s.name         = "MKAppKit"
  s.version      = "0.0.3"
  s.summary      = "iOS常用组件"
  s.description      = <<-DESC
                          iOS常用组件 Desc
                       DESC
  s.homepage     = "https://github.com/mythkiven/MKAppKit"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "mythkiven" => "mythziven@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/mythkiven/MKAppKit", :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'

  s.requires_arc = true
  s.default_subspec = 'All'
  s.swift_version = '5.0'

  s.subspec 'All' do |all|
    all.source_files = 'MKAppKit/MKAnimation/**/*.{h,m,swift}','MKAppKit/MKUIKit/**/*.{h,m,swift}'
    all.resources = "MKAppKit/**/**/*.{xib}"
  end

  s.subspec 'MKCombineLoadingAnimation' do |la|
    la.source_files = 'MKAppKit/MKAnimation/MKCombineLoadingAnimation/*.{h,m}'
    la.resources = "MKAppKit/MKAnimation/MKCombineLoadingAnimation/*.{xib}"
  end

  s.subspec 'MKDropdownMailTF' do |df|
    df.source_files = 'MKAppKit/MKUIKit/MKDropdownMailTF/*.{h,m}'
    df.resources = "MKAppKit/MKUIKit/MKDropdownMailTF/*.{xib}"
  end

  s.subspec 'MKDiffuseMenu' do |dm|
    dm.source_files = 'MKAppKit/MKAnimation/MKDiffuseMenu/*.{swift}'
  end

end





