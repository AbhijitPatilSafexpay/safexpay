Pod::Spec.new do |spec|

  spec.name         = 'SafexPay'
  spec.version      = '1.0.0'
  spec.summary      = 'SafexPay framework'
  spec.homepage     = 'https://github.com/AbhijitPatilSafexpay/safexpay'
  spec.description  = 'SafexPay framework for payments.'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author             = { 'Nagendra Yadav' => 'nagendra@safexpay.com' }

  spec.platform     = :ios
  spec.swift_version = '5.0'
  spec.ios.deployment_target = '12.1'
  spec.source       = { :git => 'https://github.com/AbhijitPatilSafexpay/safexpay.git', :tag => "#{spec.version}" }

  spec.requires_arc = true
  spec.vendored_frameworks = 'SafexPay.framework'

  spec.exclude_files = "Classes/Exclude"

 

end