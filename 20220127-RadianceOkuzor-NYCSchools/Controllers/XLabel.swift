//
//  XLabel.swift
//  20220127-RadianceOkuzor-NYCSchools
//
//  Created by Radiance Okuzor on 1/29/22.
//

import Foundation
import UIKit

class XLabel: UILabel {
    var xTimer:Timer?
    var xTime = 0
    var endCount = 0
    
    func animateCount(endCount:Int){
        self.endCount = endCount
        xTimer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(countUp), userInfo: nil, repeats: true)
    }
    
    @objc func countUp(){
        xTime += 1
        if xTime < endCount+1 {
            self.text = String(xTime)
        } else {
            xTimer?.invalidate()
        }
    }
}
