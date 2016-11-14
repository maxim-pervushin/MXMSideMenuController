Pod::Spec.new do |s|
  s.name             = 'MXMSideMenuController'
  s.version          = '1.0.0'
  s.summary          = 'iOS container view controller that presents side menu.'
  s.homepage         = 'https://github.com/maxim-pervushin/MXMSideMenuController'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Maxim Pervushin' => 'maxim.pervushin@gmail.com' }
  s.source           = { :git => 'https://github.com/maxim-pervushin/MXMSideMenuController.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '8.0'
  s.source_files = 'MXMSideMenuController/Classes/**/*'
end
