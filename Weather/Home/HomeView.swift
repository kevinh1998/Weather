//
//  HomeView.swift
//  Weather
//
//  Created by Kevin Huijzendveld on 27/02/2019.
//  Copyright © 2019 Kevin Huijzendveld. All rights reserved.
//

import UIKit
import ViewAnimator

protocol HomeViewDelegate {
    func homeHeader(_ home: HomeView)
    func homeFooter(_ home: HomeView)
    func homeLive(_ home: HomeView)
    func home(_ home: HomeView, didSearch city: String)
}

class HomeView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    private static let HomeCellIdentifier = "DetailCollectionViewCell"
    private static let HomeHeaderIdentifier = "HeaderCollectionReusableView"
    private static let HomeFooterIdentifier = "FooterCollectionReusableView"
    
    @IBOutlet private var weatherPictogramView: UIImageView!
    @IBOutlet private var tempLabel: UILabel!
    @IBOutlet private var weatherDescriptionLabel: UILabel!
    @IBOutlet private var weatherPrediction: UILabel!
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var locationButton: UIImageView!
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var collectionViewContainer: UIView!
    
    private var weather: Weather?
    private var detailInfo: [DetailInfo] = []
    
    public var delegate: HomeViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let gridSize = CGSize(width: (UIScreen.main.bounds.width/2)-10, height: 70)
        
        collectionView.register(UINib(nibName: "DetailCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: HomeView.HomeCellIdentifier)
        collectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: .main), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HomeView.HomeHeaderIdentifier)
        collectionView.register(UINib(nibName: "FooterCollectionReusableView", bundle: .main), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: HomeView.HomeFooterIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        collectionView.contentInsetAdjustmentBehavior = .never
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = gridSize
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
            layout.headerReferenceSize = CGSize(width: self.collectionView.frame.width, height: 50)
            layout.footerReferenceSize = CGSize(width: self.collectionView.frame.width, height: 50)
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.addGestureRecognizer(tap)
        let locationTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(locationButtonWasPressed))
        locationButton.addGestureRecognizer(locationTap)
    }
    
    func setBasicInfo(weather: Weather?) {
        self.weather = weather
        if let weather = weather, let temp = weather.temp, let image = weather.image, let verw = weather.verw {
            tempLabel.text = "\(Int(temp.rounded()))"
            weatherDescriptionLabel.text = weather.samenv
            weatherPictogramView.image = UIImage(named: image)
            weatherPrediction.text = "Verwacht: \(verw)"
        }
    }
    
    func setDetailInfo(_ detailInfo: [DetailInfo], animated: Bool = false) {
        self.detailInfo = detailInfo
        
        if (!animated) {
            self.collectionView.reloadData()
        } else {
            self.collectionView.reloadData()
            let animation = AnimationType.from(direction: .bottom, offset: 30.0)
            self.collectionView.performBatchUpdates({
                var views = [UIView]()
                views += collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionHeader).map { $0 }
                views += collectionView.orderedVisibleCells.map { $0 }
                views += collectionView.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionFooter).map { $0 }
                UIView.animate(views: views, animations: [animation])
            }, completion: nil)
        }
    }
    
    func setLocationButtonState(isLiveLocation: Bool) {
        locationButton.isHighlighted = isLiveLocation
        if !isLiveLocation {
            searchBar.text = weather?.plaats
        }
    }
    
    @objc func headerWasPressed() {
        self.delegate?.homeHeader(self)
    }
    
    @objc func footerWasPressed() {
        self.delegate?.homeFooter(self)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    @objc func locationButtonWasPressed() {
        searchBar.text = ""
        self.delegate?.homeLive(self)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let city = searchBar.text else { return }
        self.delegate?.home(self, didSearch: city)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.detailInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeView.HomeCellIdentifier, for: indexPath)
        if let cell = cell as? DetailCollectionViewCell {
            let detail = detailInfo[indexPath.row]
            
            cell.configure(data: detail)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeView.HomeHeaderIdentifier, for: indexPath)
            if let header = header as? HeaderCollectionReusableView {
                header.configure(data: weather)
            }
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(headerWasPressed))
            header.addGestureRecognizer(tapGestureRecognizer)
            return header
        } else if kind == UICollectionElementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeView.HomeFooterIdentifier, for: indexPath)
            if let footer = footer as? FooterCollectionReusableView {
                footer.configure(data: weather)
            }
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(footerWasPressed))
            footer.addGestureRecognizer(tapGestureRecognizer)
            return footer
        }
        fatalError()
    }
}
