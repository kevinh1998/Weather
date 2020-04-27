//
//  LoadingView.swift
//  Weather
//
//  Created by Kevin Huijzendveld on 27/02/2019.
//  Copyright © 2019 Kevin Huijzendveld. All rights reserved.
//

import UIKit

protocol LoadingViewDelegate {
    func loading(_ loading: LoadingView, didSearch city: String)
}

class LoadingView: UIView, UITextFieldDelegate {
    public var delegate: LoadingViewDelegate?
    
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private var textField: UITextField!
    @IBOutlet private var infoLabel: UILabel!
    @IBOutlet private var locationButton: DesignableButton!
    
    @IBOutlet private var imageTop: NSLayoutConstraint!
    @IBOutlet private var imageLeading: NSLayoutConstraint!
    @IBOutlet private var imageHorizontal: NSLayoutConstraint!
    @IBOutlet private var imageVertical: NSLayoutConstraint!
    @IBOutlet private var imageWidth: NSLayoutConstraint!
    @IBOutlet private var imageHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.alpha = 0.0
        infoLabel.alpha = 0.0
        locationButton.alpha = 0.0
        
        loadingIndicator.startAnimating()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tap)
    }
    
    func setViews() {
        loadingIndicator.stopAnimating()
        loadingIndicator.alpha = 0.0
        imageWidth.constant = 100
        imageHeight.constant = 100
        UIView.animate(withDuration: 1) {
            self.imageHorizontal.isActive = false
            self.imageVertical.isActive = false
            self.layoutIfNeeded()
            self.textField.alpha = 1.0
            self.infoLabel.alpha = 1.0
            self.locationButton.alpha = 1.0
        }
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let city = textField.text {
            self.delegate?.loading(self, didSearch: city)
        }
        return true
    }
}
