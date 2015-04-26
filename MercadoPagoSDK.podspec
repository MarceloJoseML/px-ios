Pod::Spec.new do |s|
  s.name             = "MercadoPagoSDK"
  s.version          = "0.1.0"
  s.summary          = "MercadoPagoSDK"
  s.homepage         = "https://www.mercadopago.com"
  s.license          = 'MIT'
  s.author           = { "Matias Gualino" => "matias.gualino@mercadolibre.com" }
  s.source           = { :git => "https://github.com/mercadopago/sdk-ios.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'MercadoPagoSDK/MercadoPagoSDK/*'

end