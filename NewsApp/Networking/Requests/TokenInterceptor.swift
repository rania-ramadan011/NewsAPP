

import Alamofire

class TokenInterceptor: RequestInterceptor {
    
    let retryLimit = 1
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        var tokenResult  = ""
        if let token = UserDefaults.standard.object(forKey:"currentToken") as? [String:Any]{
            let tokenResult =  token["access_token"] as! String
            completion(.success(urlRequest))
            let bearerToken = "Bearer \(tokenResult)"
            request.setValue(bearerToken, forHTTPHeaderField: "Authorization")
            print("\nadapted; token added to the header field is: \(bearerToken)\n")
   
        }
       
      
       
        
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        
        if request.response?.statusCode == 401,request.retryCount < retryLimit {
            print("\nretried; retry count: \(request.retryCount)\n")
            refreshToken { isSuccess in
                isSuccess ? completion(.retry) : completion(.doNotRetry)
                
            }}else{
                completion(.doNotRetry)
                
                
            }
    }
    
    
    func refreshToken(completion: @escaping (_ isSuccess: Bool) -> Void) {
        let token_url = "https://ob.magrabi.com.sa/PatientPortalServices_KPMG/Gettoken"
        
        
         // flag user lang to check language  EN or AR
        var password = ""
        var userName = ""
        
        if let currentUser = UserDefaults.standard.object(forKey:"CurrentUser") as? [String:Any]{

            password = currentUser["UserPassword"] as! String
            userName = currentUser["UserName"] as! String
            
        }
        
        let parameters = ["username": userName, "grant_type": "password","password":password]
        let headers:HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        
        AF.request(token_url, method: .post, parameters: parameters,headers: headers)
            .validate()
            .responseDecodable(of: TokenResponse.self) { response in
                switch response.result {
                case .success(let tokenResponse):
                   
                    
                    let dictionary = [
                        "access_token":  tokenResponse.accessToken
                        ,
                        ".expires": tokenResponse.expires,
                        "token_type":tokenResponse.tokenType,
                        ".issued": tokenResponse.issued,
                        "expires_in" : tokenResponse.expiresIn
                    ] as [String : Any]

                    UserDefaults.standard.set(dictionary, forKey:"CurrentToken")
                    completion(true)

              
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false)
                }
            }
        
    }
}
    
