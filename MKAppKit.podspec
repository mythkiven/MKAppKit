
Pod::Spec.new do |s|

  s.name         = "MKAppKit"
  s.version      = "0.0.1"
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


  s.subspec 'All' do |all|
    all.source_files = 'MKAppKit/Animation/**/*.{h,m}'
    all.resources = "MKAppKit/*.{xib}","MKAppKit/Animation/**/*.{xib}"
  end

  s.subspec 'MKCombineLoadingAnimation' do |la|
    la.source_files = 'MKAppKit/Animation/**/*.{h,m}'
    la.resources = "MKAppKit/*.{xib}","MKAppKit/Animation/**/*.{xib}"
  end
end





