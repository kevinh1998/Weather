//
//  HeaderCollectionReusableView.swift
//  Weather
//
//  Created by Kevin Huijzendveld on 05/12/2019.
//  Copyright © 2019 Kevin Huijzendveld. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet private var maxTempLabel: UILabel!
    @IBOutlet private var minTempLabel: UILabel!
    
    private(set) var data: Weather?
    
    func configure(data: Weather?) {
        self.data = data
        
        setInfo()
    }
    
    func setInfo() {
        if let weather = data, let max = weather.d1tmax, let min = weather.d1tmin {
            maxTempLabel.text = "\(max)°"
            minTempLabel.text = "\(min)°"
        }
    }
    
}
