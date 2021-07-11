Pod::Spec.new do |spec|

  spec.name         = 'SafexPay'
  spec.version      = '1.2.9'
  spec.summary      = 'SafexPay framework'
  spec.homepage     = 'https://github.com/AbhijitPatilSafexpay/safexpay'
  spec.description  = 'SafexPay framework for payments.'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author             = { 'Nagendra Yadav' => 'nagendra@safexpay.com' }
  spec.platform     = :ios
  spec.swift_version = '5.0'
  spec.ios.deployment_target = '9.0'
  spec.source       = { :git => 'https://github.com/AbhijitPatilSafexpay/safexpay.git', :tag => "#{spec.version}" }
  spec.requires_arc = true
  spec.exclude_files = "Classes/Exclude"

  spec.dependency 'IQKeyboardManager'
  spec.dependency 'RSSelectionMenu'
  spec.dependency 'CryptoSwift'
  spec.dependency 'Alamofire'
  spec.dependency 'SVProgressHUD'
  spec.dependency 'Kingfisher'

end