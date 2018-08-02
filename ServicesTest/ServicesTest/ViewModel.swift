//
//  ViewModel.swift
//  ServicesTest
//
//  Created by Kanwar Zorawar Singh Rana on 8/1/18.
//  Copyright © 2018 Xorture. All rights reserved.
//

import Foundation

struct MovieListDataModel: Decodable {
    let page: Decimal
    let total_results: Decimal?
    let total_pages: Decimal
    let results: [Result]?
}

struct Result: Decodable {
    let title: String?
    let ovrView: String?
    let imagePath: String?
    let votes: Decimal?
    let imgId: Decimal
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case ovrView = "overview"
        case imagePath = "backdrop_path"
        case votes = "vote_average"
        case imgId = "id"
    }
}

protocol ViewModelDelegates {
    func didReceiveData()
}

class ViewModel: NSObject {
    
    let delegate: ViewModelDelegates!
    var dataModel: MovieListDataModel?
    
    init(delegate: ViewModelDelegates) {
        self.delegate = delegate
    }

    func fetchPost(searchQuery: String) {
        let executer = TaskExecuter()
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=2a61185ef6a27f400fd92820ad9e8537&page=1&query=\(searchQuery)"
        do {
            _ = try executer.createRequestWith(urlString: urlString)
        } catch  ExecutionExceptions.InvalidURLString {
            print("URL Sring is not correct")
        } catch  ExecutionExceptions.InvalidURL {
            print("URL is not valid")
        } catch {
            print(error.localizedDescription)
        }
        
        executer.response(successHandler: { [weak self] (data) in
            do {
                self?.dataModel = try JSONDecoder().decode(MovieListDataModel.self, from: data)
                DispatchQueue.main.async {
                    self?.delegate.didReceiveData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}


