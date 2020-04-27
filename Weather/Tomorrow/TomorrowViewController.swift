//
//  TomorrowViewController.swift
//  Weather
//
//  Created by Kevin Huijzendveld on 05/12/2019.
//  Copyright © 2019 Kevin Huijzendveld. All rights reserved.
//

import UIKit

class TomorrowViewController: UIViewController {
    private let data: Weather?
    
    init(data: Weather?) {
        self.data = data
        
        super.init(nibName: "TomorrowView", bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = view as? TomorrowView {
            view.configure(data: data)
        }

    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
