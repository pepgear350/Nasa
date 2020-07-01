//
//  CollectionViewController.swift
//  Nasa
//
//  Created by Jhon Ospino Bernal on 14/06/20.
//  Copyright © 2020 Jhon Ospino Bernal. All rights reserved.
//

import UIKit
import CoreData
import MaterialComponents.MaterialFlexibleHeader

private let reuseIdentifier = "CollectionViewCell"

class CollectionViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout {
    
    var headerViewController : MDCFlexibleHeaderViewController!
    fileprivate var headerContentView = HeaderContentView(frame: CGRect.zero)
    fileprivate let viewModel = ViewModel()
    fileprivate var isDelete = false
    var fetchController: NSFetchedResultsController<DataDB>?
    
    //    override init(collectionViewLayout layout: UICollectionViewLayout) {
    //        super.init(collectionViewLayout: layout)
    //        self.collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    //        self.collectionView?.backgroundColor = UIColor(white: 0.97, alpha: 1)
    //    }
    
    
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        viewModel.initalizateDB{ fetchController in
            fetchController.delegate = self
            self.fetchController = fetchController
            try? fetchController.performFetch()
            self.viewModel.startFetch()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sizeHeaderView()
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
          return 1
      }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.fetchController?.fetchedObjects?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Configure the cell
        
        guard let viewCell = cell as? CollectionViewCell, let data = self.fetchController?.object(at: indexPath) else { return cell }
        
        viewCell.delegate = self
        let title = data.title ?? ""
        let description = data.description_data ?? ""
        let url = data.link_relation?.first?.href ?? ""
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
        let cellWidth = floor((self.view.frame.size.width - 10 - safeAreaInset))
        var cellHeight = cellWidth * 1.2
        if let data = self.fetchController?.object(at: indexPath), let title = data.title, let description = data.description_data {
            
            let imageHeight  = cellWidth / 2
            
            let size = CGSize(width: cellWidth, height:1000)
            let attributesTitle = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14) ]
            let attributesDescription = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12) ]
            let estimatedFrameTitle = NSString(string: title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributesTitle, context: nil)
             let estimatedFrameDescription = NSString(string: description).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributesDescription, context: nil)
            
            cellHeight = imageHeight + estimatedFrameTitle.height + estimatedFrameDescription.height + 40
        }
        
        
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


//MARK: FetchedResultsControllerDelegate
extension CollectionViewController : NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if !isDelete {
            collectionView.reloadData()
        }
        print(" did type  \(controller.accessibilityContainerType.rawValue)")
        let count = controller.fetchedObjects?.count ?? -1
        print("size list \(count)")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            isDelete = true
            self.collectionView.deleteItems(at: [indexPath!])
        default:
            isDelete = false
        }
    }
}

//MARK: SwipeableCollectionViewCellDelegate
extension CollectionViewController : SwipeableCollectionViewCellDelegate{
    func deleteItemCell(inCell cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell), let data = self.fetchController?.object(at: indexPath)  else { return }
//        collectionView.performBatchUpdates({
        // tener en cuenta que hay que usar otro delegate de NSFetchedResultsControllerDelegate para que primero se elimine en DB y despues se elimine en la collection. ver ejemplo coredata vs real
//            self.collectionView.deleteItems(at: [indexPath])
//        })
        print(" item delete \(indexPath.item)")
        viewModel.deleteDataDB(dataDB: data)
    }
    
    
}
