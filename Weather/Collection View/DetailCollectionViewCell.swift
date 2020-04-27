//
//  DetailCollectionViewCell.swift
//  Weather
//
//  Created by Kevin Huijzendveld on 03/12/2019.
//  Copyright © 2019 Kevin Huijzendveld. All rights reserved.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var valueLabel: UILabel!
    
    private(set) var data: DetailInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(data: DetailInfo) {
        self.data = data
        
        setDetailInfo()
    }
    
    func setDetailInfo() {
        if let data = data {
            titleLabel.text = data.title
            valueLabel.text = data.value
        }
    }

}

struct DetailInfo {
    let title: String
    let value: String
}
