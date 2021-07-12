Pod::Spec.new do |spec|

  spec.name         = 'SafexPay'
  spec.version      = '1.3.1'
  spec.summary      = 'SafexPay framework'
  spec.homepage     = 'https://github.com/AbhijitPatilSafexpay/safexpay'
  spec.description  = 'SafexPay framework for payments.'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author             = { 'Nagendra Yadav' => 'nagendra@safexpay.com' }
  spec.platform     = :ios
  spec.swift_version = '5.0'
  spec.ios.deployment_target = '10.0'
  spec.source       = { :git => 'https://github.com/AbhijitPatilSafexpay/safexpay.git', :tag => "#{spec.version}" }
  # spec.source_files = 'safexpay/**/**'
  # spec.ios.resource_bundle = { 'SafexPay' => 'safexpay/**/*.{png, json}' }
  # spec.source_files     = ['**/*.{h,m,swift,xib,storyboard}']
  # spec.resources = ['*.{storyboard,xib,xcassets,json,png, jpg, jpeg, plist}', 'safexpay/Assets.xcassets']
#  spec.resources =  ["safexpay/**/*.{xib, json, xcassets}", "safexpay/Assets.xcassets/**/*.{xib, json, xcassets}"]
#spec.resources = "safexpay/*.{xcassets,xib}"
# spec.resource_bundles = {
#     'SafexPay' => ['**']
#   }
 

  spec.requires_arc = true
  # spec.exclude_files = "Classes/Exclude"
  spec.vendored_frameworks = 'SafexPay.xcframework'
  spec.dependency 'IQKeyboardManager'
  spec.dependency 'RSSelectionMenu'
  spec.dependency 'CryptoSwift'
  spec.dependency 'Alamofire'
  spec.dependency 'SVProgressHUD'
  spec.dependency 'Kingfisher'

end