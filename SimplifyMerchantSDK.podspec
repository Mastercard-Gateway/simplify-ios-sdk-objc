

Pod::Spec.new do |s|

  s.name         = "SimplifyMerchantSDK"
  s.version      = "2.0.0"
  s.summary      = "A Simple SDK for accepting payments"

  s.description  = <<-DESC
                   Simplify makes it easy to send an invoice – and get paid! When you create an invoice and send it to your customers – they will get an email with a link where they can pay quickly. Once they pay, you will get the deposit within two business days. Getting paid from your customers has never been easier.
                   DESC

  s.homepage     = "http://simplify.com"
  s.documentation_url = 'https://www.simplify.com/commerce/docs/sdk/ios'

  s.license      = { :type => "Custom", :file => "LICENSE.txt" }

  s.author       = { "Josh Monroe" => "josh_monroe@mastercard.com" }

  s.platform     = :ios
  s.source       = { :http => "https://www.simplify.com/commerce/static/distribution/ios/simplify.zip" }

  s.requires_arc = true

  s.ios.vendored_frameworks = 'Simplify.framework'
  s.resource = 'Simplify.bundle'

  s.xcconfig = { 'OTHER_LDFLAGS' => '-ObjC' }



end
