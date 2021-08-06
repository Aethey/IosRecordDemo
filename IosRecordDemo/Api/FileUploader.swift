//
//  FileUploader.swift
//  IosRecordDemo
//
//  Created by Y Ryu on 2021/08/06.
//

import Foundation
import Combine

class FileUploader: NSObject {
    typealias Percentage = Double
    typealias Publisher = AnyPublisher<Percentage, Error>
    
    private typealias Subject = CurrentValueSubject<Percentage, Error>

    private lazy var urlSession = URLSession(
        configuration: .default,
        delegate: self,
        delegateQueue: .main
    )

    private var subjectsByTaskID = [Int : Subject]()
    
    func doTest() {
        
        uploadFile(at: URL(fileURLWithPath: ""),to: URL(fileURLWithPath: "")).sink (
            
            receiveCompletion: { error in
                print(error)
            },
            receiveValue: { percentage in
                print(percentage)
            }
        )
    }

    func uploadFile(at fileURL: URL,
                    to targetURL: URL) -> Publisher {
        var request = URLRequest(
            url: targetURL,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        
        request.httpMethod = "POST"

        let subject = Subject(0)
        var removeSubject: (() -> Void)?

        let task = urlSession.uploadTask(
            with: request,
            fromFile: fileURL,
            completionHandler: { data, response, error in
                // Validate response and send completion
                subject.send(completion: .finished)
                removeSubject?()
            }
        )

        subjectsByTaskID[task.taskIdentifier] = subject
        removeSubject = { [weak self] in
            self?.subjectsByTaskID.removeValue(forKey: task.taskIdentifier)
        }
        
        task.resume()
        
        return subject.eraseToAnyPublisher()
    }
}

extension FileUploader: URLSessionTaskDelegate {
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        let progress = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        let subject = subjectsByTaskID[task.taskIdentifier]
        subject?.send(progress)
    }
}
