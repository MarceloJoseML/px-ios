Pod::Spec.new do |s|
  s.name             = "MercadoPagoSDKV4"
  s.version          = "4.0.0.beta.32"
  s.summary          = "MercadoPagoSDK"
  s.homepage         = "https://www.mercadopago.com"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = "Mercado Pago"
  s.source           = { :git => "https://github.com/mercadopago/px-ios.git", :tag => s.version.to_s }
  s.swift_version = '4.0'
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.default_subspec = 'Default'

  s.subspec 'Default' do |default|
    default.resources = ['MercadoPagoSDK/MercadoPagoSDK/*.xcassets','MercadoPagoSDK/MercadoPagoSDK/*/*.xcassets', 'MercadoPagoSDK/MercadoPagoSDK/*.ttf', 'MercadoPagoSDK/MercadoPagoSDK/**/**.{plist,xib,strings}', 'MercadoPagoSDK/MercadoPagoSDK/*.lproj']
    default.source_files = ['MercadoPagoSDK/MercadoPagoSDK/**/**/**.{h,m,swift}']
    s.dependency 'MercadoPagoPXTrackingV4', '2.1.3'
    s.dependency 'MercadoPagoServicesV4', '1.0.17'
    s.dependency 'MLUI', '~> 4.0'
  end
  
  s.subspec 'ESC' do |esc| 
    esc.dependency 'MercadoPagoSDKV4/Default'  
    esc.dependency 'MLESCManager', '1.0.2' 
    esc.pod_target_xcconfig = { 
       'OTHER_SWIFT_FLAGS[config=Debug]' => '-D MPESC_ENABLE', 
       'OTHER_SWIFT_FLAGS[config=Release]' => '-D MPESC_ENABLE', 
       'OTHER_SWIFT_FLAGS[config=Testflight]' => '-D MPESC_ENABLE' 
    } 
  end

end