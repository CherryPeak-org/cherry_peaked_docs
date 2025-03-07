//
//  CherryPeakedDocsPage.swift
//  cherry_peaked_docs
//
//  Created by Samuel Kubinský on 06/03/2025.
//

import Flutter
import VisionKit

public class CherryPeakedDocsPlugin: NSObject {
    private var rootViewController: UIViewController {
        UIApplication.shared.keyWindow!.rootViewController!
    }
    private var result: FlutterResult!
    private var dirPath = ""
}

// MARK: - Bridge

extension CherryPeakedDocsPlugin: FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "cherry_peaked_docs", binaryMessenger: registrar.messenger())
        let instance = CherryPeakedDocsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        
        switch call.method {
            case "startScanning":
                startScanning(args: call.arguments)
            case "stopScanning":
                stopScanning()
            default:
                result(FlutterMethodNotImplemented)
        }
    }
}

// MARK: - Native

extension CherryPeakedDocsPlugin {
    private func startScanning(args: Any?) {
        guard
            let dict = args as? [String: Any],
            let path = dict["path"] as? String
        else {
            let flutterError = FlutterError(
                code: "INVALID_ARGUMENTS",
                message: "Missing or malformed arguments",
                details: nil
            )
            result(flutterError)
            return
        }
        
        self.dirPath = path
        
        let documentScannerViewController = VNDocumentCameraViewController()
        documentScannerViewController.delegate = self
        rootViewController.present(documentScannerViewController, animated: true)
    }
    
    private func stopScanning() {
        rootViewController.dismiss(animated: true)
    }
    
    private func savePagesToDisk(_ pages: [CherryPeakedDocsPage]) {
        do {
            var filePaths = [String]()
            
            let dirExists = FileManager.default.fileExists(atPath: dirPath)
            
            if !dirExists {
                try FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true)
            }
            
            for page in pages {
                let filePath = "\(dirPath)/\(page.id).jpg"
                
                guard
                    let fileURL = URL(string: "file://\(filePath)"),
                    let imageData = page.image.jpegData(compressionQuality: 1)
                else {
                    continue
                }

                try imageData.write(to: fileURL, options: .atomic)
                filePaths.append(filePath)
            }
            
            result(filePaths)
        } catch {
            let nsError = error as NSError
            let flutterError = FlutterError(
                code: "WRITE_TO_DISK_FAILED",
                message: nsError.localizedFailureReason,
                details: nsError.localizedDescription
            )
            result(flutterError)
        }
    }
}


// MARK: - Scanner delegate

extension CherryPeakedDocsPlugin: VNDocumentCameraViewControllerDelegate {
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: any Error) {
        let nsError = error as NSError
        let flutterError = FlutterError(
            code: "SCANNER_FAILED",
            message: nsError.localizedFailureReason,
            details: nsError.localizedDescription
        )
        result(flutterError)
    }
    
    public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        result([])
    }
    
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let pages = CherryPeakedDocsPage.extractFrom(scan)
        savePagesToDisk(pages)
        stopScanning()
    }
}
