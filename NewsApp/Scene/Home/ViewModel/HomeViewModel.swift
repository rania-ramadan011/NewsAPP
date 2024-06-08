//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Shaimaa Mohammed on 08/06/2024.
//

import Foundation
import Combine
import NewsCore
import CommonUtilities

final class HomeViewModel: ObservableObject{
    @Published var resultResponse: [Article]?
    @Published public var error: Error?
    var cancellables = Set< AnyCancellable > ()
    let useCase: GetHeadlinesUseCase
    
    init( useCase:GetHeadlinesUseCase = GetHeadlinesUseCase()) {
        self.useCase = useCase
        setSubscription()
    }
    
    func setSubscription(){
        useCase.newsResult = { [weak self] result in
            self?.resultResponse = result
        }
        useCase.error = { [weak self] error in
            self?.error = error
            print(error!)
        }
    }
    
    public func getHeadlines(country: String) {
        let request = HeadlinesAPIEndpoint(key: Shared.apiKey, country: country)
        useCase.getHeadlines(request: request)
    }
}
