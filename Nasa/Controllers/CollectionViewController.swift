//
//  CollectionViewController.swift
//  Nasa
//
//  Created by Jhon Ospino Bernal on 14/06/20.
//  Copyright © 2020 Jhon Ospino Bernal. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialFlexibleHeader

private let reuseIdentifier = "CollectionViewCell"

class CollectionViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout{
    
    var headerViewController : MDCFlexibleHeaderViewController!
    fileprivate var dataSource : NasaDataSource
    fileprivate var headerContentView = HeaderContentView(frame: CGRect.zero)
    fileprivate var items : [Items]?
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        self.dataSource = NasaDataSource()
        super.init(collectionViewLayout: layout)
        dataSource.delegate = self
        self.collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    
    override func viewWillAppear(_ animated: Bool) {
        if items == nil {
            dataSource.startLoad()
        }
        
        sizeHeaderView()
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.items?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Configure the cell
        
        guard let viewCell = cell as? CollectionViewCell else { return cell }
        
        let itemNumber = indexPath.item
        let title = self.items?[itemNumber].data[0].title ?? ""
        let description = self.items?[itemNumber].data[0].description ?? ""
        let url = self.items?[itemNumber].links?[0].href ?? ""
        viewCell.populateCell(title: title, url: url, description: description)
        
        return viewCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var safeAreaInset: CGFloat = 20
        if #available(iOS 11.0, *) {
            safeAreaInset += self.view.safeAreaInsets.left + self.view.safeAreaInsets.right
        }
        let cellWidth = floor((self.view.frame.size.width - 10 - safeAreaInset) / 2)
        let cellHeight = cellWidth * 1.2
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        let itemNum: NSInteger = (indexPath as NSIndexPath).row
        print(itemNum)
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerViewController.scrollViewDidScroll(scrollView)
        let scrollOffsetY = scrollView.contentOffset.y
        let duration = 0.5
        var opacity: CGFloat = 1.0
        var logoTextImageViewOpacity: CGFloat = 0
        if scrollOffsetY > -240 {
            opacity = 0
            logoTextImageViewOpacity = 1
        }
        UIView.animate(withDuration: duration, animations: {
            self.headerContentView.scrollView.alpha = opacity
            self.headerContentView.pageControl.alpha = opacity
            self.headerContentView.logoImageView.alpha = opacity
            self.headerContentView.logoTextImageView.alpha = logoTextImageViewOpacity
        })
        
    }
    
    
    func sizeHeaderView() {
        let headerView = headerViewController.headerView
        let bounds = UIScreen.main.bounds
        if bounds.size.width < bounds.size.height {
            headerView.maximumHeight = 440
        } else {
            headerView.maximumHeight = 72
        }
        headerView.minimumHeight = 72
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation,
                                      duration: TimeInterval) {
        sizeHeaderView()
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    
    
    func setupHeaderView() {
        let headerView = headerViewController.headerView
        headerView.trackingScrollView = collectionView
        headerView.maximumHeight = 440
        headerView.minimumHeight = 72
        headerView.minMaxHeightIncludesSafeArea = false
        headerView.backgroundColor = UIColor.white
        headerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerContentView.frame = (headerView.bounds)
        headerContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerView.addSubview(headerContentView)
    }
    
    
}

//MARK: NasaDataSourceDelegate
extension CollectionViewController : NasaDataSourceDelegate {
    
    func dataSourceSuccessful(items: [Items]) {
        self.items = items
        collectionView.reloadData()
    }
    
    func dataSourceError(error: Error) {
        print(error.localizedDescription)
    }
    
}
