//
//  DownloadTaskModel.swift
//  DowloadTask
//
//  Created by YILMAZ ER on 15.06.2023.
//

import Foundation
import SwiftUI

class DownloadTaskModel: NSObject, ObservableObject, URLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    
    @Published var downloadURL: URL!
    
    @Published var alertMsg = ""
    @Published var showAlert = false
    
    @Published var downloadtaskSession : URLSessionDownloadTask!
    
    @Published var downloadProgress: CGFloat = 0
    
    @Published var showDownloadProgress = false
    @Published var imgURL: URL!
    
    func startDownload(urlString: String) {
        guard let ValidURL = URL(string: urlString) else {
            self.reportError(error: "Invalid URL !!!")
            return
        }
        
        let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        if FileManager.default.fileExists(atPath: directoryPath.appendingPathComponent(ValidURL.lastPathComponent).path) {
            print("yes file found")
            self.imgURL = directoryPath.appendingPathComponent(ValidURL.lastPathComponent)
            let controller = UIDocumentInteractionController(url: directoryPath.appendingPathComponent(ValidURL.lastPathComponent))
            controller.delegate = self
            controller.presentPreview(animated: true)
        } else {
            print("no file found")
            
            downloadProgress = 0
            withAnimation {
                showDownloadProgress = true
            }
            
            let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            
            downloadtaskSession = session.downloadTask(with: ValidURL)
            downloadtaskSession.resume()
        }
    }
    
    func reportError(error: String) {
        alertMsg = error
        showAlert.toggle()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("\(location)")
        
        guard let url = downloadTask.originalRequest?.url else {
            DispatchQueue.main.async {
                self.reportError(error: "Something went wrong please try again later")
            }
            return
        }
        
        let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destionationURL = directoryPath.appendingPathComponent(url.lastPathComponent)
        
        self.imgURL = destionationURL
        
        try? FileManager.default.removeItem(at: destionationURL)
        
        do {
            try FileManager.default.copyItem(at: location, to: destionationURL)
            print("success")
            DispatchQueue.main.async {
                
                withAnimation {
                    self.showDownloadProgress = false
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.reportError(error: "Please try again later !!!")
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        DispatchQueue.main.async {
            self.downloadProgress = progress
        }
    }
    
    func cancelTask() {
        if let task = downloadtaskSession, task.state == .running {
            downloadtaskSession.cancel()
            withAnimation { self.showDownloadProgress = false }
        }
    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return UIApplication.shared.windows.first!.rootViewController!
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            withAnimation { self.showDownloadProgress = false }
            self.reportError(error: error.localizedDescription)
            return
        }
    }
}
