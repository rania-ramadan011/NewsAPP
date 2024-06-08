//
//  SearchViewModel.swift
//  NewsApp
//
//  Created by Shaimaa Mohammed on 08/06/2024.
//

import Foundation
import Combine
import NewsCore
import CommonUtilities

final class SearchViewModel: ObservableObject{
    @Published var resultResponse: [Article]?
    @Published public var error: Error?
    var cancellables = Set< AnyCancellable > ()
    let searchUseCase: GetSearchHeadlinesUseCase
        
    init( useCase:GetSearchHeadlinesUseCase = GetSearchHeadlinesUseCase()) {
        self.searchUseCase = useCase
        setSubscription()
    }
    
    func setSubscription(){
        searchUseCase.searchResult = { [weak self] result in
            self?.resultResponse = result
        }
        searchUseCase.error = { [weak self] error in
            self?.error = error
            print(error!)
        }
    }
    
    public func getSearchResualt(keyword: String) {
        let request = SearchHeadlinesAPIEndpoint(key: Shared.apiKey, keyword: keyword)
        searchUseCase.getSearchHeadlines(request: request)
    }
}





