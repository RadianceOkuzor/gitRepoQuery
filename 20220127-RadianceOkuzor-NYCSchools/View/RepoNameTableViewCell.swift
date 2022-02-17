//
//  SchoolNameTableViewCell.swift
//  20220127-RadianceOkuzor-NYCSchools
//
//  Created by Radiance Okuzor on 1/27/22.
//

import UIKit

class RepoNameTableViewCell: UITableViewCell {

    @IBOutlet weak var repoDescription: UILabel!
    @IBOutlet weak var forksCount: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerImage: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        repoDescription.titleLable()
        repoDescription.adjustsFontForContentSizeCategory = true
        forksCount.smallLable()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

