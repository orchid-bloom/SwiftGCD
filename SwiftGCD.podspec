
Pod::Spec.new do |s|
  s.name         = "SwiftGCD"
  s.version      = "0.0.1"
  s.summary      = "SwiftGCD"
  s.homepage     = "https://github.com/temagit/SwiftGCD.git"

  s.license      = 'MIT'
  s.author       = { "TemaSir" => "tianxin@gsoft.cc" }
  s.source       = { :git => "https://github.com/temagit/SwiftGCD.git", :tag => s.version }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'SwiftGCD/*.swift'
  s.framework    = "UIKit"
end
