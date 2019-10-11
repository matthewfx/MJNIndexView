#
# Be sure to run `pod lib lint MJNIndexView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MJNIndexView'
  s.version          = '0.9.0'
  s.summary          = 'MJNIndexView is a highly customizable index for UITableView'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  MJNIndexView is a highly customizable UIControl which displays an alternative index for UITableView.\n I wanted to mimic the index designed by Jeremy Olson's Tapity for their Languages app.\n I think their idea of implementing index is brilliant and it is one of the best examples of great UX.\n I hope more apps are going to use similar indices instead of the generic ones.\n
                       DESC

  s.homepage         = 'https://github.com/matthewfx/MJNIndexView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'matthewfx' => 'mat@nuckowski.com' }
  s.source           = { :git => 'https://github.com/matthewfx/MJNIndexView.git', :commit => 'ce6f04b1df50513f05daa1edb2c6fa93a6a49482'}
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MJNIndexView.{h,m}'
  s.frameworks = 'QuartzCore', 'CoreGraphics'
  
  # s.resource_bundles = {
  #   'MJNIndexView' => ['MJNIndexView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
