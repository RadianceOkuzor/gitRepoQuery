//
//  SchoolDataVC.swift
//  20220127-RadianceOkuzor-NYCSchools
//
//  Created by Radiance Okuzor on 1/27/22.
//

import UIKit

class RepoDataVC: UIViewController {
    
    var repoData = RepoListDTO(repositories: [], isError: false, errorMessage: "", showMore: false)
    
    // used to change animation of the graph
    @IBOutlet weak var forkHeighConstrants: NSLayoutConstraint!
    @IBOutlet weak var starHeighConstraint: NSLayoutConstraint!
    @IBOutlet weak var watchersHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var repoView: UIView!
    @IBOutlet weak var forkView: UIView!
    @IBOutlet weak var starViwe: UIView!
    @IBOutlet weak var imageG: UIImageView!
    @IBOutlet weak var ownerImage: UIImageView!
    // labels that show repo specific data
    @IBOutlet weak var repoDesc: UILabel!
    @IBOutlet weak var repoLabelNme: UILabel!
    @IBOutlet weak var repoOwnerName: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var starredLabel: UILabel!
                    
    var selected = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // set custom fonts for uilabels
        setFonts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // animate the chart right before view appears
        animateGraph()
        imageG.image = UIImage.gifImageWithName("bkGround")
    }
    
    func animateGraph() {
        
        // get the sat scores of the subjects
        var forks = self.repoData.repositories[selected].forks ?? 1
        let forksO = self.repoData.repositories[selected].forks ?? 1
        
        var watchers = self.repoData.repositories[selected].watchers ?? 1
        let watchersO = self.repoData.repositories[selected].watchers ?? 1
        
        var reposOwned = self.repoData.repositories[selected].owner?.publicRepos ?? 1
        let reposOwnedO = self.repoData.repositories[selected].owner?.publicRepos ?? 1
        
        if forks > 750 {
            forks = 750
        }
        
        if watchers > 750 {
            watchers = 750
        }
        
        if reposOwned > 750 {
            reposOwned = 750
        }
        
        // create labels to show the exact score number per item
        // the x equation centers the label in the middle of the bar chart
        let forksScoreLabel = XLabel(frame: CGRect(x: (repoView.frame.width/2)-17, y: 0, width: 60, height: 35))
        forksScoreLabel.titleLable()
//        mathScoreLabel.textColor = .
        repoView.addSubview(forksScoreLabel)
        repoView.addTopBorder()
        
        let watchersScoreLabel = XLabel(frame: CGRect(x: (forkView.frame.width/2)-17, y: 0, width: 60, height: 35))
        watchersScoreLabel.titleLable()
        forkView.addSubview(watchersScoreLabel)
        forkView.addTopBorder()
        
        let reposOwnedLabel = XLabel(frame: CGRect(x: (starViwe.frame.width/2)-17, y: 0, width: 60, height: 35))
        reposOwnedLabel.titleLable()
        starViwe.addTopBorder()
        starViwe.addSubview(reposOwnedLabel)
         
        UIView.animate(withDuration: 1) {
            self.forkHeighConstrants.constant = CGFloat(forks/2)
            self.repoView.frame.size.height =  CGFloat(-forks/2)
            forksScoreLabel.animateCount(endCount: forksO)
        }
        
        UIView.animate(withDuration: 1.5) {
            self.starHeighConstraint.constant = CGFloat(watchers/2)
            self.forkView.frame.size.height = CGFloat(-watchers/2)
            watchersScoreLabel.animateCount(endCount: watchersO)
        }
        
        UIView.animate(withDuration: 2.0) {
            self.watchersHightConstraint.constant = CGFloat(reposOwned/2)
            self.starViwe.frame.size.height = CGFloat(-reposOwned/2)
            reposOwnedLabel.animateCount(endCount: reposOwnedO)
        }
    }
    
    func setFonts(){
        self.title = "PEEK"
        repoLabelNme.text = repoData.repositories[selected].name
        repoDesc.text = repoData.repositories[selected].description
        ownerImage.load(url: URL(string: repoData.repositories[selected].owner?.avatarURL ?? "")!)
        repoDesc.smallLable()
        repoLabelNme.titleLable()
        repoOwnerName.midLable()
        forksLabel.midLable()
        starredLabel.midLable()
    }
    
   
 
}

