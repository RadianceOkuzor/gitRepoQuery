//
//  Highschool.swift
//  20220127-RadianceOkuzor-NYCSchools
//
//  Created by Radiance Okuzor on 1/27/22.
//

import Foundation
import Alamofire

// Model represent simple data structure to hold the schools make it codabel to receive and parse json 

struct Highschool: Codable {
    let schoolName : String
    let readingScore: String
    let mathScore: String
    let writingScore: String
    let numberOfTakers: String
    init() {
        schoolName = ""
        readingScore = ""
        mathScore = ""
        writingScore = ""
        numberOfTakers = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case schoolName = "school_name"
        case readingScore = "sat_critical_reading_avg_score"
        case mathScore = "sat_math_avg_score"
        case writingScore = "sat_writing_avg_score"
        case numberOfTakers = "num_of_sat_test_takers"
    }
}

protocol EndpointProvider {
    associatedtype Response: DTO
    associatedtype Body: DTO
    associatedtype Failure: DTO
    
    var endpoint: Endpoint<Body> { get }
}

typealias DTO = Codable


public typealias QueryParams = [String: String]
public typealias Headers = [String: String]

struct Endpoint<Body : DTO>{
   
    var api: API
    var method: HTTPMethods = .get
    var headers: HTTPHeaders
    var queryParams : QueryParams?
    var body : Body?
    var url : URL {
        var components = URLComponents()

        components.scheme = api.baseURL.scheme
        components.host = api.baseURL.host
        components.port = api.baseURL.port
        components.path = "/" + api.path.joined(separator: "/")
        if let query = self.queryParams{
            components.queryItems = query.map { URLQueryItem(name: $0, value: $1) }
        }
        return components.url!
    }
  
    init(api : API, method : HTTPMethods, headers : HTTPHeaders? = nil, queryParams : QueryParams? = nil) {
        self.api = api
        self.method = method
        self.headers = headers ?? HTTPHeaders.default
        self.queryParams = queryParams
    }
}


public struct API {
    let baseURL: BaseURL
    var path: [String]
    
    public init(baseURL: BaseURL, path: [String] = []) {
        self.baseURL = baseURL
        self.path = path
    }
}

extension BaseURL {
    static var baseURL: BaseURL = .init(scheme: "https", host: "api.github.com")
}



public class BaseURL: NSObject, NSCoding {
    let scheme: String
    let host: String
    let port: Int?
    
    public init(scheme: String, host: String, port: Int? = nil) {
        self.scheme = scheme
        self.host = host
        self.port = port
    }
    
    public required init?(coder aDecoder: NSCoder) {
        scheme = aDecoder.decodeObject(forKey: "scheme") as! String
        host = aDecoder.decodeObject(forKey: "host") as! String
        port = aDecoder.decodeObject(forKey: "port") as? Int
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(scheme, forKey: "scheme")
        aCoder.encode(host, forKey: "host")
        aCoder.encode(port, forKey: "port")
    }
    
    public func url() -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = port
        
        return components.url!
    }
}

extension BaseURL {
    
    public static func == (lhs: BaseURL, rhs: BaseURL) -> Bool {
        return lhs.host.lowercased() == rhs.host.lowercased()
    }
}

extension API {
    static let repositories = API(baseURL: .baseURL, path: ["search", "repositories"])
    static var userRepositories = API(baseURL: .baseURL)
    static let userAuthentication = API(baseURL: .baseURL, path: ["user"])
    static let forks = API(baseURL: .baseURL)
}





enum HTTPMethods : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public enum NetworkResult<V, W, E: Error> {
    case success(V)
    case failure(W)
    case error(E)
}

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}


public enum NetworkError: Error {
    case requestCreation( String )
    case decoding(String)
    case server(String)
}


let somethingUnexpectedError = "Something unexpected happen. Please try later"
let serverNotRespondingError = "Server not responding. Please try again later"
let badDataError = "Data couldn't be fetched properly"
let noForksMessage = "No forks available for this repo"
let pleaseFillAllTheFields = "Please fill all the fields."
