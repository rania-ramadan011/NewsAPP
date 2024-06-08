

import Foundation
import Alamofire

protocol URLRequestBuilder: URLRequestConvertible, APIRequestHandler {
    
    var mainURL: URL { get }
    
    var requestURL: URL { get }
    // MARK: - Path
    var path: String { get }
    
    // MARK: - Parameters
    var parameters: Parameters? { get }
    // MARK: - httpBody
    var httpBody:Data? {get}
    
   
    
    // MARK: - Methods
    var method: HTTPMethod { get }
    
    var encoding: ParameterEncoding { get }
    
    var urlRequest: URLRequest { get
    }
    
    
    
   
}


extension URLRequestBuilder {
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        case .post:
            return JSONEncoding.default
           
        default:
            return JSONEncoding.default
        }
    }
    
    var mainURL: URL  {
        return URL(string: "https://ob.magrabi.com.sa/PatientPortalServices_KPMG/")!
    }
    
    var requestURL: URL {
        return mainURL.appendingPathComponent(path)
    }
    
    var urlRequest: URLRequest {
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
    
       // if let token = UserDefaults.standard.object(forKey: "CurrentToken") as? [String:Any]{
         //   request.setValue("Bearer \(token["access_token"] as! String)" , forHTTPHeaderField: "Authorization")
            
            
            
        }
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        
        
        switch method{
        case.post :
            request.httpBody = httpBody
            let url = requestURL
            var urlComponents = URLComponents(string: url.absoluteString)
            urlComponents?.queryItems = []
            parameters?.forEach({
            let queryItem = URLQueryItem(name: $0, value: "\($1)")
            urlComponents?.queryItems?.append(queryItem)
            })
            request.url = urlComponents?.url
            
        default:
            request.httpBody  = nil
        }
     
     print(request)
        return request
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        switch method {
        case .get:
            return try encoding.encode(urlRequest, with: parameters)
//        case.post:
//       return try JSONEncoding.default.encode(urlRequest, with: parameters)
       default:
            return try encoding.encode(urlRequest, with: parameters)
        }
    }
}
