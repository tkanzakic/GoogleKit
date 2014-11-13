Pod::Spec.new do |s|
  s.name                  = "GoogleKit"
  s.version               = "0.2"
  s.summary               = "An objective-c wrapper around the various Google API's"
  s.homepage              = "https://github.com/maxsokolov/GoogleKit"
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { "Username" => "Max Sokolov" }
  s.platform              = :ios, '7.0'
  s.source                = { :git => "https://github.com/maxsokolov/GoogleKit.git", :tag => s.version.to_s }
  s.source_files          = 'GoogleKit/*.{h,m}', 'GoogleKit/Queries/*.{h,m}', 'GoogleKit/Objects/*.{h,m}'
  s.requires_arc          = true
end