/*
 Copyright 2015 XWebView

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

import Foundation
import ObjectiveC
import WebKit


//@available(iOS 9.0, macOS 10.11, *)
extension WKWebView {
    // Overlay support for loading file URL
    @objc public func loadFileURL(_ url: URL, overlayURLs: [URL]? = nil) -> WKNavigation? {
        if let count = overlayURLs?.count, count == 0 {
            if #available(iOS 9.0, *) {
                return loadFileURL(url, allowingReadAccessTo: url.baseURL!)
            }
        }

        guard url.isFileURL && url.baseURL != nil else {
            fatalError("URL must be a relative file URL.")
        }

        guard let port = startHttpd(rootURL: url.baseURL!, overlayURLs: overlayURLs) else { return nil }

        var res = url.relativePath
        if let query = url.query { res += "?" + query }
        if let fragment = url.fragment { res += "#" + fragment }
        let url = URL(string: res , relativeTo: URL(string: "http://127.0.0.1:\(port)"))
        return load(URLRequest(url: url!))
    }

    private func startHttpd(rootURL: URL, overlayURLs: [URL]? = nil) -> in_port_t? {
        let key = Unmanaged.passUnretained(XWVHttpServer.self as AnyObject).toOpaque()
        if let httpd = objc_getAssociatedObject(self, key) as? XWVHttpServer {
            if httpd.rootURL == rootURL && httpd.overlayURLs == overlayURLs ?? [] {
                return httpd.port
            }
            httpd.stop()
        }

        let httpd = XWVHttpServer(rootURL: rootURL, overlayURLs: overlayURLs)
        guard httpd.start() else { return nil }
        objc_setAssociatedObject(self, key, httpd, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        log("+HTTP server is started on port: \(httpd.port)")
        return httpd.port
    }
}
