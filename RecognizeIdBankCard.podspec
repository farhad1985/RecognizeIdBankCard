Pod::Spec.new do |s|
  s.name             = 'RecognizeIdBankCard'
  s.version          = '0.1.0'
  s.summary          = 'You can scan Iranian IdBankCard . by : farhad faramarzi'

 
  s.homepage         = 'https://github.com/farhad1985/RecognizeIdBankCard'
  s.author           = { 'Farhad Faramarzi' => 'farhad.public@gmail.com' }
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.source           = { :git => 'https://github.com/farhad1985/RecognizeIdBankCard.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '9.0'
  s.source_files = 'RecognizeIdBankCard/*'
 
end
