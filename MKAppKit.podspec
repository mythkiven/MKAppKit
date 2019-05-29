
Pod::Spec.new do |s|

  s.name         = "MKAppKit"
  s.version      = "0.1.0"
  s.summary      = "Useful tools for iOS application development."
  s.description      = <<-DESC
                          iOS 常用组件 Desc
                       DESC
  s.homepage     = "https://github.com/mythkiven/MKAppKit"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "mythkiven" => "1282412855@qq.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/mythkiven/MKAppKit", :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'

  s.requires_arc = true
  s.default_subspec = 'All'
  s.swift_version = '5.0'

  s.subspec 'All' do |all|
    all.source_files = 'MKAppKit/MKAnimation/**/*.{h,m,swift}','MKAppKit/MKUIKit/**/*.{h,m,swift}','MKAppKit/MKMonitor/**/*.{h,m,mm,c}'
    all.resources = "MKAppKit/**/**/*.{xib}","MKAppKit/Resource/*.{bundle}"
    all.prefix_header_contents = '#import "MKLoadingManagerView.h"','#import "MKDropdownMailTF.h"','#import "MKPointWatch.h"'
  end

  s.subspec 'MKCombineLoadingAnimation' do |la|
    la.source_files = 'MKAppKit/MKAnimation/MKCombineLoadingAnimation/*.{h,m}'
    la.resources = "MKAppKit/Resource/*.{bundle}","MKAppKit/MKAnimation/MKCombineLoadingAnimation/*.{xib}"
    la.prefix_header_contents = '#import "MKLoadingManagerView.h"'
  end

  s.subspec 'MKDropdownMailTF' do |df|
    df.source_files = 'MKAppKit/MKUIKit/MKDropdownMailTF/*.{h,m}'
    df.resources = "MKAppKit/MKUIKit/MKDropdownMailTF/*.{xib}"
    df.prefix_header_contents = '#import "MKDropdownMailTF.h"'
  end

  s.subspec 'MKDiffuseMenu' do |dm|
    dm.source_files = 'MKAppKit/MKAnimation/MKDiffuseMenu/*.{swift}'
  end

  s.subspec 'MKLaunchMonitor' do |lm|
    lm.source_files = 'MKAppKit/MKMonitor/MKLaunchMonitor/*.{h,m,c,mm}'
    lm.prefix_header_contents = '#import "MKPointWatch.h"'
  end

end





