//
//  FileDownloader.swift
//  secureDevelopment
//
//  Created by Antonio Jesús on 12/10/22.
//

import Foundation


class FileDownloader: NSObject, URLSessionTaskDelegate, URLSessionDownloadDelegate {
    
    var savedfileUrl: URL?
    var isDownloaded = false
    
    func download(url: URL, name: String) {
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.antoniojesus.secureDevelopment.background")
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue() )

        guard var documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        documentUrl.append(path: name, directoryHint: .checkFileSystem)
        //Url where we will save the downloaded file
        savedfileUrl = documentUrl
        
        session.downloadTask(with: URLRequest(url: url)).resume()
    }
    
    //MARK: URLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let savedfileUrl else { return }
        
        securePrint("The file is downloaded at \(location)")
        
        do {
            //Move the file to another path
            try FileManager.default.moveItem(at: location, to: savedfileUrl)
            isDownloaded = true
        } catch {
            securePrint("Error downloading the file.")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if totalBytesExpectedToWrite > 0 {
            securePrint("Downloaded \(bytesWritten) bytes out of a total of \(totalBytesExpectedToWrite)")
        }
    }
    
}
