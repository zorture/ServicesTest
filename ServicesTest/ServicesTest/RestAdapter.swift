//
//  RestAdapter.swift
//  ServicesTest
//
//  Created by Kanwar Zorawar Singh Rana on 8/1/18.
//  Copyright © 2018 Xorture. All rights reserved.
//

import UIKit

class RestAdapter {
    
    static let shared = RestAdapter()
    
    fileprivate let session = URLSession.shared
    fileprivate let queue = OperationQueue.init()
    
    init() {
        queue.maxConcurrentOperationCount = 5
    }
}

enum ExecutionExceptions: Error {
    case InvalidURLString
    case InvalidURL
}

typealias TaskSuccessCompletion = (_ response: Data) -> Void
typealias TaskFailureCompletion = (_ error: Error) -> Void
class TaskExecuter {
    
    fileprivate var successHandler: TaskSuccessCompletion?
    fileprivate var failureHandler: TaskFailureCompletion?
    fileprivate let restAdapter = RestAdapter.shared
    
    func createRequestWith(urlString: String) throws {
        
        // Set String
        guard let urlString = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else { throw  ExecutionExceptions.InvalidURLString }
        
        // Set URL
        guard let url = URL.init(string: urlString) else { throw ExecutionExceptions.InvalidURL }
        
        // Execute the data Task
        let task = restAdapter.session.dataTask(with: url) { (data, response, error) in
            self.processResponse(data: data, response: response, error: error)
        }
        
        // Add task to operation Q
        let taskOperation = TaskOperation.init(task: task)
        restAdapter.queue.addOperation(taskOperation)
    }
    
    func response( successHandler: @escaping TaskSuccessCompletion, failureHandler: @escaping TaskFailureCompletion) {
        self.successHandler = successHandler
        self.failureHandler = failureHandler
    }
    
   private func processResponse(data: Data?, response: URLResponse?, error: Error?) {
        
        guard let data = data else {
            guard let error = error else {
                return
            }
            failureHandler?(error)
            return
        }
        successHandler?(data)
    }
    
    
}

class TaskOperation: Operation {
    let task: URLSessionTask
    
    init(task: URLSessionTask) {
        self.task = task
        task.resume()
    }
}
