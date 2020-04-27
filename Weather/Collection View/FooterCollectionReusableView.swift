//
//  FooterCollectionReusableView.swift
//  Weather
//
//  Created by Kevin Huijzendveld on 06/12/2019.
//  Copyright © 2019 Kevin Huijzendveld. All rights reserved.
//

import UIKit

class FooterCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet private var maxTempLabel: UILabel!
    @IBOutlet private var minTempLabel: UILabel!
    
    private(set) var data: Weather?
    
    func configure(data: Weather?) {
        self.data = data
        
        setInfo()
    }
    
    func setInfo() {
        if let data = data, let max = data.d2tmax, let min = data.d2tmin {
            maxTempLabel.text = "\(max)°"
            minTempLabel.text = "\(min)°"
        }
    }
}
