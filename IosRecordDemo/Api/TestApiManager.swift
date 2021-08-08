//
//  TestApiManager.swift
//  IosRecordDemo
//
//  Created by Y Ryu on 2021/08/09.
//

import Combine
import Foundation

class TestApiManager: ObservableObject {
    var disposable = Set<AnyCancellable>()
    @Published var eventData: String?
    
    
    func postRequest(onSuccess:@escaping (String) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let url = URL(string: Config.baseUrl)!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map({ (data, response) in
                return data
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("error ： " + error.localizedDescription)
                case .finished:
                    print("----------success-----------")
                }
            }, receiveValue: { [weak self] data in
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? String
                    //                    self?.eventData =  try (JSONSerialization.jsonObject(with: data, options: .allowFragments) as? String)
                    print(json! + "this is json")
                    onSuccess(json!)
                }catch{
                    
                }
                
                print(self?.eventData as Any)
            })
            .store(in: &disposable)
    }
}
