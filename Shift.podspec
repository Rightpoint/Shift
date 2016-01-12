Pod::Spec.new do |s|
  s.name                = "Shift"
  s.version             = "0.0.1"
  s.summary             = "A library of custom iOS View Controller Animations and Interactions written in Swift."

  s.description         = <<-DESC
                          Shift is a library of custom iOS View Controller Animations and Interactions written
                          in Swift.
                          DESC

  s.homepage            = "https://github.com/Raizlabs/Shift"
  s.screenshots         = "https://raw.githubusercontent.com/Raizlabs/Shift/master/SplitTransition.gif"
  s.license             = { :type => "MIT", :file => "LICENSE" }

  s.author              = { "Matt Buckley" => "matt.buckley@raizlabs.com" }
  s.social_media_url    = "http://twitter.com/Raizlabs"

  s.platform            = :ios, "9.0"
  s.source              = { :git => "https://github.com/Raizlabs/Shift.git", :tag => "#{s.version}" }

  s.source_files        = "Source/*/*.swift", "Source/*/*.h"

  s.frameworks          = "UIKit"
  s.requires_arc        = true
end
