#
#  Be sure to run `pod spec lint XWebView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name         = "XWebViewObjc"
    s.version      = "0.12.1"
    s.summary      = "An extensible WebView (based on WKWebView) ( Objc + iOS8)"
    
    s.description  = <<-DESC
    XWebView is an extensible WebView which is built on top of WKWebView,
    the modern WebKit framework debuted in iOS 8.0. It provides fast Web
    runtime with carefully designed plugin API for developing sophisticated
    iOS native or hybrid applications.
    
    Plugins written in Objective-C or Swift programming language can be
    automatically exposed in JavaScript context. With capabilities offered
    by plugins, Web apps can look and behave exactly like native apps. They
    will be no longer a second-class citizen on iOS platform.
    DESC
    
    s.homepage     = "https://github.com/ftkey/XWebViewObjc"
    s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
    s.authors            = { 'Zhenyu Liang' => 'xwebview@sofla.re', 'Jonathan Dong' => 'dongyan09@gmail.com', 'David Kim' => 'david@xwebview.org', 'Fernando Martínez' => 'contact@fernandodev.com'}
    s.ios.deployment_target = "8.0"
    s.osx.deployment_target = "10.11"
    s.source       = { :git => "https://github.com/ftkey/XWebViewObjc.git", :tag => s.version.to_s }
    s.framework  = "WebKit"
    s.ios.framework = "MobileCoreServices"
    s.requires_arc = true
    s.default_subspecs = 'Core'

    s.subspec "Core" do |ss|
        ss.source_files  = "XWebViewObjc/Classes/Core/**/*.{swift}"
        ss.resources  = "XWebViewObjc/Assets/js/xwebview.js"
    end
    s.subspec "HttpServer" do |ss|
        ss.dependency "XWebViewObjc/Core"
        ss.source_files  = "XWebViewObjc/Classes/HttpServer/**/*.{swift}"
    end
end

