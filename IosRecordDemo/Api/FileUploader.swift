//
//  FileUploader.swift
//  IosRecordDemo
//
//  Created by Y Ryu on 2021/08/06.
//

import Foundation
import Combine

class FileUploader: NSObject {
    
    static let shared = FileUploader()
    
    typealias Percentage = Double
    typealias Publisher = AnyPublisher<Percentage, Error>
    typealias PublisherPost = AnyPublisher<String, Error>
    
    private typealias Subject = CurrentValueSubject<Percentage, Error>
    private typealias SubjectPost = CurrentValueSubject<String, Error>

    private lazy var urlSession = URLSession(
        configuration: .default,
        delegate: self,
        delegateQueue: .main
    )

    private var subjectsByTaskID = [Int : Subject]()
    private var subjectsPostByTaskID = [Int : SubjectPost]()
    
  
    
    @Published var respones: String = ""
    var mCancellable: AnyCancellable?
    
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
    
    func postRequest() -> PublisherPost {
        let url = URL(string: Config.baseUrl)!
        var request = URLRequest(url: url)
        
        let subject = SubjectPost("????")
        var removeSubject: (() -> Void)?
        
        request.httpMethod = "POST"      // Postリクエストを送る(このコードがないとGetリクエストになる)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                subject.send(json as! String)

                print(json)
            } catch let error {
                subject.send(completion: .finished)
                removeSubject?()
                print(error)
            }
        }
        
        subjectsPostByTaskID[task.taskIdentifier] = subject
        removeSubject = { [weak self] in
            self?.subjectsByTaskID.removeValue(forKey: task.taskIdentifier)
        }
        task.resume()
        return subject.eraseToAnyPublisher()
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
