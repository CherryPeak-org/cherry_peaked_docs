//
//  CherryPeakedDocsPlugin.swift
//  cherry_peaked_docs
//
//  Created by Samuel Kubinský on 06/03/2025.
//

import Flutter
import VisionKit

public class CherryPeakedDocsPlugin: NSObject {
    private var rootViewController: UIViewController? {
        UIApplication.shared.keyWindow?.rootViewController
    }
    
    private var result: FlutterResult?
    private var outputDirPath: String?
}

// MARK: - Bridge

extension CherryPeakedDocsPlugin: FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "cherry_peaked_docs", binaryMessenger: registrar.messenger())
        let instance = CherryPeakedDocsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        result = nil
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.result = result
        
        switch call.method {
            case "startScanning":
                startScanning(call)
            case "forceStopScanning":
                forceStopScanning()
            default:
                result(FlutterMethodNotImplemented)
        }
    }
}

// MARK: - Native

extension CherryPeakedDocsPlugin {
    private func startScanning(_ call: FlutterMethodCall) {
        let arguments = call.arguments as? [String: Any]
        outputDirPath = arguments?["path"] as? String
        
        guard outputDirPath != nil else {
            result?(
                FlutterError(
                    code: "INVALID_ARGUMENTS",
                    message: "Missing or malformed arguments",
                    details: nil
                )
            )
            return
        }
        
        let documentScannerViewController = VNDocumentCameraViewController()
        documentScannerViewController.delegate = self
        rootViewController?.present(documentScannerViewController, animated: true)
    }
    
    private func forceStopScanning() {
        rootViewController?.dismiss(animated: true)
    }
    
    private func savePage(image: UIImage) -> String? {
        do {
            let fileManager = FileManager.default
            let dirExists = fileManager.fileExists(atPath: outputDirPath!)
            
            if !dirExists {
                try fileManager.createDirectory(atPath: outputDirPath!, withIntermediateDirectories: true)
            }
            
            let filePath = "\(outputDirPath!)/\(UUID().uuidString).jpg"
            
            guard
                let fileURL = URL(string: "file://\(filePath)"),
                let imageData = image.jpegData(compressionQuality: 1)
            else {
                return nil
            }

            try imageData.write(to: fileURL, options: .atomic)
            
            return filePath
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}


// MARK: - Scanner delegate

extension CherryPeakedDocsPlugin: VNDocumentCameraViewControllerDelegate {
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: any Error) {
        result?(
            FlutterError(
                code: "SCANNER_FAILED",
                message: error.localizedDescription,
                details: nil
            )
        )
        forceStopScanning()
    }
    
    public func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        result?([])
        forceStopScanning()
    }
    
    public func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let imagePaths = (0 ..< scan.pageCount)
            .map(scan.imageOfPage)
            .compactMap(savePage)
        result?(imagePaths)
        forceStopScanning()
    }
}
