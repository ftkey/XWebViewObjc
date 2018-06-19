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

extension WKWebView {
    public var windowObject: XWVScriptObject {
        return XWVWindowObject(webView: self)
    }

    @objc @discardableResult public func loadPlugin(_ object: AnyObject, namespace: String) -> XWVScriptObject? {
        let channel = XWVChannel(webView: self)
        return channel.bindPlugin(object, toNamespace: namespace)
    }

    func prepareForPlugin() {
        let key = Unmanaged<AnyObject>.passUnretained(XWVChannel.self).toOpaque()
        if objc_getAssociatedObject(self, key) != nil { return }

        let bundle = Bundle(for: XWVChannel.self)
        guard let path = bundle.path(forResource: "xwebview", ofType: "js"),
            let source = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue) else {
            die("Failed to read provision script: xwebview.js")
        }
        let time = WKUserScriptInjectionTime.atDocumentStart
        let script = WKUserScript(source: source as String, injectionTime: time, forMainFrameOnly: true)
        let xwvplugin = XWVUserScript(webView: self, script: script, namespace: "XWVPlugin")
        objc_setAssociatedObject(self, key, xwvplugin, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        log("+WKWebView(\(self)) is ready for loading plugins")
    }
}

public typealias Undefined = Void
public var undefined: AnyObject = {
    Void() as AnyObject
}()

extension WKWebView {
    public static var undefined: AnyObject {
        return XWebViewObjc.undefined
    }

    @objc open func asyncEvaluateJavaScript(_ script: String, completionHandler handler: ((Any?, Error?) -> Swift.Void)? = nil) {
        if Thread.isMainThread {
            evaluateJavaScript(script, completionHandler: handler)
        } else {
            DispatchQueue.main.async() {
                [weak self] in
                self?.evaluateJavaScript(script, completionHandler: handler)
            }
        }
    }

    // Synchronized evaluateJavaScript
    @objc open func syncEvaluateJavaScript(_ script: String) throws -> Any {
        var result: Any?
        var error: Error?
        var done = false
        let timeout = 3.0
        if Thread.isMainThread {
            evaluateJavaScript(script) {
                (obj: Any?, err: Error?)->Void in
                result = obj
                error = err
                done = true
            }
            while !done {
                let reason = CFRunLoopRunInMode(CFRunLoopMode.defaultMode, timeout, true)
                if reason != CFRunLoopRunResult.handledSource {
                    break
                }
            }
        } else {
            let condition: NSCondition = NSCondition()
            DispatchQueue.main.async() {
                [weak self] in
                self?.evaluateJavaScript(script) {
                    (obj: Any?, err: Error?)->Void in
                    condition.lock()
                    result = obj
                    error = err
                    done = true
                    condition.signal()
                    condition.unlock()
                }
            }
            condition.lock()
            while !done {
                if !condition.wait(until: Date(timeIntervalSinceNow: timeout) as Date) {
                    break
                }
            }
            condition.unlock()
        }
        if error != nil { throw error! }
        if !done {
            log("!Timeout to evaluate script: \(script)")
        }
        return result ?? WKWebView.undefined
    }
}

