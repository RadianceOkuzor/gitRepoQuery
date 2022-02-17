//
//  HighShoolViweModel.swift
//  20220127-RadianceOkuzor-NYCSchools
//
//  Created by Radiance Okuzor on 1/27/22.
//

import Foundation
import Cache

struct User: Codable {
  let firstName: String
  let lastName: String
}

enum ServicesResult<V>{
    case success(V)
    case error(String)
}

typealias SearchRepoCompletion = ((ServicesResult<RepoListResponse>) -> Void)

class RepoViewModel: NSObject {
    
    private var apiService : APIService!
    private(set) var repoData : RepoListDTO! {
        didSet {
            // when this is set with data then the function that binded to this viewmdoel through bindHighschoolviwemoedlTocoonroler is called
            self.bindRepoViewModelToController()
            
            self.cacheIt()

        }
    }
    
    //called by the viewcontroller class and giving an arbitrary indegenous function to be ran 
    var bindRepoViewModelToController : (() -> ()) = {}
    var networkManager: NetworkManager = AlamofireManager.shared
    var page : Int = 1
    var perPageNumber = 0
    var userTotalRepo = 0
    
    
    override init() {
        super.init()
        self.apiService = APIService() // initialize apiService to be used to get repo data from the back end
    }
    
    func search(queryString: String, page:Int = 1) {
        self.getRepositoriesFromSearch(queryString: queryString, page: page, perPageNumber: perPageNumber) { [weak self](result) in
            guard let `self` = self else{ return }
            self.repoData = self.preapreDataFromSearchRepoRequest(result: result)
        }
    }
    
    func getRepositoriesFromSearch(queryString: String, page: Int, perPageNumber: Int, completion: @escaping SearchRepoCompletion)  {
        
        let repoRequest = RepoListSearchRequest(queryString: queryString, pageNumber: String(page), perPageElement: "30")
        let  repoListEndpointProvider = RepoListSearchEndpointProvider(requestObject: repoRequest)
        
        self.networkManager.request(repoListEndpointProvider) { [weak self] (result) in
           
            guard let `self` = self else { return }
            completion(self.parseSearchResult(result: result)
            )
        }
        
    }
    
    private func preapreDataFromSearchRepoRequest(result : ServicesResult<RepoListResponse>)->RepoListDTO{
        var repoListDTO : RepoListDTO!
        switch result {
        case .success(let data):
            let shouldShowMore = ((self.perPageNumber) * self.page < data.totalCount) ? true : false
            repoListDTO = RepoListDTO(repositories: data.items, isError: false, errorMessage: "", showMore: shouldShowMore)
        case .error(let errorMessage):
            repoListDTO = RepoListDTO(repositories: [], isError: true, errorMessage: errorMessage, showMore: false)
            
        }
        return repoListDTO
    }
    
    func filterSchools(filter:String) -> RepoListDTO {
        if filter == "alpha"{
            repoData.repositories = repoData.repositories.sorted{$0.name ?? "" < $1.name ?? ""}
        } else if filter == "watchersHigh" {
            repoData.repositories = repoData.repositories.sorted{$0.watchers ?? 0 > $1.watchers ?? 0}
        } else if filter == "watchersLow"{
            repoData.repositories = repoData.repositories.sorted{$0.watchers ?? 0 < $1.watchers ?? 0}
        } else if filter == "forksHigh"{
            repoData.repositories = repoData.repositories.sorted{$0.stars ?? 0 > $1.stars ?? 0}
            
        } else if filter == "forksLow"{
            repoData.repositories = repoData.repositories.sorted{$0.stars ?? 0 < $1.stars ?? 0}
            
        } else if filter == "reposHigh"{
            repoData.repositories = repoData.repositories.sorted{$0.owner?.publicRepos ?? 0 > $1.owner?.publicRepos ?? 0}
            
        } else if filter == "reposLow"{
            repoData.repositories = repoData.repositories.sorted{$0.owner?.publicRepos ?? 0 < $1.owner?.publicRepos ?? 0}
        }
        return repoData
    }
    
    func cacheData() -> [Repository]{
        let diskConfig = DiskConfig(name: "Disk1")
        let memoryConfig = MemoryConfig(expiry: .date(Date().addingTimeInterval(86400)), countLimit: 1000, totalCostLimit: 10)
        do {
            let storage: Storage<String, [Repository]> = try Storage<String, [Repository]>(
                diskConfig: diskConfig,
                memoryConfig: memoryConfig,
                transformer: TransformerFactory.forCodable(ofType: [Repository].self) // Storage<User>
              )
            
            let score = try storage.object(forKey: "repoData")
            return score
        } catch  {
            print("Error with caching data \(error)")
        }
        return []
    }
    
    private func parseSearchResult(result : NetworkResult<RepoListResponse, RequestError, NetworkError>)->ServicesResult<RepoListResponse>{
       
        var repoResult : ServicesResult<RepoListResponse>!
        
        switch result{
        case .success(let data):
            repoResult = .success(data)
        case .error(let networkerror): ()
            repoResult = .error(self.parseNetworkError(error: networkerror))
        case .failure(let failure): ()
            repoResult = .error(failure.message ?? somethingUnexpectedError)
        }
        return repoResult
    }
    
    private func parseNetworkError(error : NetworkError)->String{
        var errorString = ""
        switch error {
        case .requestCreation(let badRequest):
            errorString = badRequest
        case .server(let serverError) :
            errorString = serverError
        case .decoding(let dataError):
            errorString = dataError
        }
        return errorString
    }
    
    func cacheIt(){
        let diskConfig = DiskConfig(name: "Disk1")
        let memoryConfig = MemoryConfig(expiry: .date(Date().addingTimeInterval(86400)), countLimit: 1000, totalCostLimit: 10)
        
        do {
            let storage: Storage<String, [Repository]> = try Storage<String, [Repository]>(
                diskConfig: diskConfig,
                memoryConfig: memoryConfig,
                transformer: TransformerFactory.forCodable(ofType: [Repository].self) // Storage<User>
              )
            try storage.setObject(repoData.repositories, forKey: "repoData", expiry: .seconds(86400))
            
        } catch  {
            print("Error with caching data \(error)")
        }
    }
     
}
