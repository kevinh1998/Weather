//
//  TomorrowView.swift
//  Weather
//
//  Created by Kevin Huijzendveld on 05/12/2019.
//  Copyright © 2019 Kevin Huijzendveld. All rights reserved.
//

import UIKit

class OvermorrowView: UIView {
    
    @IBOutlet private var pictogramView: UIImageView!
    @IBOutlet private var maxTempLabel: UILabel!
    @IBOutlet private var minTempLabel: UILabel!
    @IBOutlet private var windLabel: UILabel!
    @IBOutlet private var sunLabel: UILabel!
    @IBOutlet private var rainLabel: UILabel!
    
    func configure(data: Weather?) {
        if let data = data, let image = data.d2weer, let windr = data.d2windr, let windk = data.d2windkmh, let max = data.d2tmax, let min = data.d2tmin, let sun = data.d2zon, let rain = data.d2neerslag {
            pictogramView.image = UIImage(named: image)
            maxTempLabel.text = "\(max)°"
            minTempLabel.text = "\(min)°"
            windLabel.text = "\(windr) \(windk) km/h"
            sunLabel.text = "\(sun)%"
            rainLabel.text = "\(rain)%"
        }
    }
    
}
