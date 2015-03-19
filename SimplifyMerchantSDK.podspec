

Pod::Spec.new do |s|

  s.name         = "SimplifyMerchantSDK"
  s.version      = "2.0.0"
  s.summary      = "Official Simplify iOS SDK to add credit card and Apple Pay payments to your mobile app."

  s.homepage     = "http://simplify.com"
  s.documentation_url = 'https://www.simplify.com/commerce/docs/sdk/ios'

  s.license      = { :type => "Custom", :file => "LICENSE.txt" }

  s.author       = { "Simplify Support" => "support@simplify.com" }

  s.platform     = :ios
  s.source       = { :http => "https://www.simplify.com/commerce/static/distribution/ios/simplify.zip" }

  s.requires_arc = true

  s.ios.vendored_frameworks = 'Simplify.framework'
  s.resource = 'Simplify.bundle'

  s.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }



end
