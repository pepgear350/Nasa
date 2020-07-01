//
//  FlexibleHeaderContainerViewController.swift
//  Nasa
//
//  Created by Jhon Ospino Bernal on 14/06/20.
//  Copyright © 2020 Jhon Ospino Bernal. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialFlexibleHeader

class FlexibleHeaderContainerViewController: MDCFlexibleHeaderContainerViewController {
    
    
    init() {
//        let layoutFlow = UICollectionViewFlowLayout()
//        let sectionInset: CGFloat = 10.0
//        layoutFlow.sectionInset = UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let collectionVC =
            storyboard.instantiateViewController(withIdentifier: "CollectionViewController") as! CollectionViewController
        
        //let collectionVC = CollectionViewController(collectionViewLayout: layoutFlow)
        super.init(contentViewController: collectionVC)
        
        collectionVC.headerViewController = self.headerViewController
        collectionVC.setupHeaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
