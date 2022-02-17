//
//  ObjectModels.swift
//  20220127-RadianceOkuzor-NYCSchools
//
//  Created by Radiance Okuzor on 2/17/22.
//

import Foundation


struct RepoListSearchRequest : DTO{
    let queryString : String
    let pageNumber : String
    let perPageElement : String
}

struct Repository: Codable {
    let id: Int?
    let name: String?
    let owner: Owner?
    let description: String?
    let forksURL: String?
    let forks : Int?
    let stars : Int?
    let watchers: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
        case description
        case forksURL = "forks_url"
        case forks
        case stars
        case watchers
    
    }
}


struct RepoListResponse : DTO {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct Owner: Codable {
    
    let login: String?
    let id: Int?
    let avatarURL: String?
    let publicRepos : Int?
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
        case publicRepos = "public_repos"
    }
}


struct RepoListSearchEndpointProvider {
    let requestObject : RepoListSearchRequest
    private func getQueryParams()->QueryParams{
        return ["q" : requestObject.queryString, "page" : requestObject.pageNumber, "per_page" : requestObject.perPageElement]
    }
}

extension RepoListSearchEndpointProvider : EndpointProvider{
    typealias Response = RepoListResponse
    
    typealias Body = RepoListSearchRequest
    
    typealias Failure = RequestError
    
    var endpoint: Endpoint<Body> {
        return Endpoint(api: .repositories, method: .get, headers: ["Content-Type" : "application/json"], queryParams: self.getQueryParams())
    }
    
}


public struct RequestError: DTO, Error {
    let statusCode: Int?
    let error: String?
    let message: String?
    
    var localizedDescription: String {
        return message ?? "Something unexpected"
    }
}


enum RepoListType{
    case user
    case search
}

/*
protocol RepoListPresenter {
    
    var view : RepoListPresenterToViewDelegate!{ get }
    var interactor : RepoListPresenterToInteractorDelegate!{ get set }
    var router : RepoListPresenterToRouterDelagate!{ get set}
    
    var repoListDTO : RepoListDTO? { get set }
    var owner : Owner?{ get }
    var viewType: RepoListType { get }
    var totalRepositories : Int{ get }
    var perPageNumber : Int { get }
    var page : Int { get }
    
    func numberOfRows(section : Int)->Int
    func willShowMore()->Bool
    func getRepository(at index : Int)->Repository
    
}

//protocol RepoLisViewToPresenterDelegate : class{
//    func viewDidLoad()
//    func search(queryString : String)
//    func didTapOnRow(with index : Int)
//}


protocol RepoListPresenterToViewDelegate : class{
    func reloadData()
    func scrollTableViewToTop()
    func startAnimatingLoader()
    func stopAnimatingLoader()
    func showNoResultFoundAlert()
    func showErrorAlert(with title : String, message : String)
    func hideSearchBar()
}


protocol RepoListPresenterToInteractorDelegate : class {
    func fetchUserRepositories(userName : String, page : Int, perPageNumber : Int, totalRepo : Int)
    func fetchSearchRepositories(queryString : String, page : Int, perPageNumber : Int)
}

protocol RepoListPresenterToRouterDelagate : class{
    func pushToForkScreen(repository : String, owner: Owner, totalForks : Int)
}

protocol RepoListInteractorToPresenterDelegate : class{
    func didRepositoriesFetched(repoListDTO : RepoListDTO)
}


protocol RepoListRouterToPresenterDelegate : class{
    
}
 
 */

struct RepoListDTO {
    var repositories : [Repository]
    var isError : Bool
    var errorMessage : String
    var showMore : Bool
}

