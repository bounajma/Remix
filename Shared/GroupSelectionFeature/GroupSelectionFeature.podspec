Pod::Spec.new do |s|
  s.name         = "GroupSelectionFeature"
  s.version      = "0.0.1"
  s.summary      = "Feature for selecting a group"
  s.homepage     = "http://cutting.io"
  s.license      = { "type" => "MIT" }
  s.author       = "Dan Cutting"
  s.platforms    = { :ios => "10.3", :osx => "10.12" }
  s.source       = { :path => '.' }

  s.subspec "Core" do |sp|
    sp.source_files = "Core/**/*"
    sp.dependency "Wireframe/Core"
    sp.dependency "Entity/Core"
    sp.dependency "Service/GroupService"
  end

  s.subspec "UIKit" do |sp|
    sp.platform = :ios, "10.3"
    sp.source_files = "UIKit/**/*"
    sp.dependency "Wireframe/UIKit"
    sp.dependency "GroupSelectionFeature/Core"
  end

  s.subspec "Fakes" do |sp|
    sp.platform = :osx, "10.12"
    sp.source_files = "Fakes"
    sp.dependency "GroupSelectionFeature/Core"
    sp.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
  end

  s.subspec "Tests" do |sp|
    sp.platform = :osx, "10.12"
    sp.framework = 'XCTest'
    sp.source_files = "Tests"
    sp.dependency "GroupSelectionFeature/Core"
    sp.dependency "Entity/Tests"
    sp.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }
  end
end
