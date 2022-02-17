//
//  _0220127_RadianceOkuzor_NYCSchoolsTests.swift
//  20220127-RadianceOkuzor-NYCSchoolsTests
//
//  Created by Radiance Okuzor on 1/27/22.
//

import XCTest
@testable import _0220127_RadianceOkuzor_NYCSchools

class _0220127_RadianceOkuzor_NYCSchoolsTests: XCTestCase {

    private var repoViewModel : RepoViewModel!
    var repoData = RepoListDTO(repositories: [], isError: false, errorMessage: "", showMore: false)// collection of all the repos
    
    // testing to ensure the network request still works as expected
    func testHighschoolHasData(){
        self.repoViewModel = RepoViewModel()
        self.repoViewModel.bindRepoViewModelToController = {
            self.updateDataSource()
            XCTAssertNotNil(self.repoData)
        }
        
    }
     
    // making the caching still works as expected
    func testCaching(){
        self.repoViewModel = RepoViewModel()
        self.repoViewModel.bindRepoViewModelToController = {
            self.updateDataSource()
            XCTAssertNotNil(self.repoViewModel.cacheData())
        }
        
    }
    
    func updateDataSource(){
//        repos = self.repoViewModel.repoData.repositories
    }

}
