//
//  APIServices.swift
//  20220127-RadianceOkuzor-NYCSchools
//
//  Created by Radiance Okuzor on 1/27/22.
//

import Foundation
import Alamofire


class APIService : NSObject {
    
    // url link that returns the json object
    private let schoolNameURL = URL(string: "https://api.github.com")!
     

    // fucntion to communicate with the database and return the json object ready to be parsed with the codable repo object
    func request<E>(_ endpointProvider: E, completion: @escaping ((NetworkResult<E.Response, E.Failure, NetworkError>) -> Void)) where E : EndpointProvider {
        let httpMethod = self.getAlamofireHttpMethod(method: endpointProvider.endpoint.method)

        AF.request(
            endpointProvider.endpoint.url,
            method: httpMethod ,
            parameters: endpointProvider.endpoint.body.dictionary,
            encoding: URLEncoding.default,
            headers: endpointProvider.endpoint.headers
            )
            .responseData
            { (response) in
               
                if let responseCode = response.response?.statusCode, !(200..<209).contains(responseCode) {
                    if let data = response.data {
                        do {
                            let decoder = JSONDecoder()
                            let errorDto = try decoder.decode(E.Failure.self, from: data)
                            completion(.failure(errorDto))
                        } catch _ {
                            completion(.error(.server(serverNotRespondingError)))
                        }
                    } else {
                        completion(.error(.server(response.error?.localizedDescription ?? serverNotRespondingError)))
                    }
                    
                }else {
                    if let data = response.data {
                        do {
                            let decoder = JSONDecoder()
                            let dto = try decoder.decode(E.Response.self, from: data)
//                            Utils.log("DTO \(dto)")
                            completion(.success(dto))
                        } catch _ {
                            completion(.error(.decoding(badDataError)))
                        }
                    }
                }
        }
    }
    
    private func getAlamofireHttpMethod(method : HTTPMethods)->HTTPMethod{
        var alamofireMethod : HTTPMethod!
        switch method {
        case .get:
            alamofireMethod = .get
        case .post:
            alamofireMethod = .post
        case .put:
            alamofireMethod = .put
        case .patch:
            alamofireMethod = .patch
        case .delete:
            alamofireMethod = .delete
            
        }
        return alamofireMethod
    }
}



