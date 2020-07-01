//
//  CollectionViewCell.swift
//  Nasa
//
//  Created by Jhon Ospino Bernal on 14/06/20.
//  Copyright © 2020 Jhon Ospino Bernal. All rights reserved.
//

import UIKit
import MaterialComponents

protocol SwipeableCollectionViewCellDelegate: class {
    func deleteItemCell(inCell cell: UICollectionViewCell)
}


class CollectionViewCell : UICollectionViewCell , UIGestureRecognizerDelegate{
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelDescriptions: UILabel!
    var pan: UIPanGestureRecognizer!
    var deleteLabel1: UILabel!
    var deleteLabel2: UILabel!
    
    
    //var imageView = UIImageView()
    private var imageDownloader = ImageDownloader()
    
    //    fileprivate var labelDescriptions = UILabel()
    //    fileprivate var labelTitle = UILabel()
    fileprivate var inkRipple = InkRipple()
    //fileprivate var cellContent = UIView()
    
    weak var delegate: SwipeableCollectionViewCellDelegate?
    
    
    func configureCell () {
        
        
        //        inkRipple.frame = self.bounds
        //               inkRipple.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //               self.addSubview(inkRipple)
        self.contentView.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.red
        
        
        deleteLabel1 = UILabel()
        deleteLabel1.text = "favorites"
        deleteLabel1.textColor = UIColor.white
        
        self.insertSubview(deleteLabel1, belowSubview: self.contentView)
        
        deleteLabel2 = UILabel()
        deleteLabel2.text = "delete"
        deleteLabel2.textColor = UIColor.white
        self.insertSubview(deleteLabel2, belowSubview: self.contentView)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        
        //        self.cornerRadius = 10.0;
        //        self.setBorderWidth(0.0, for:.normal)
        //        self.setBorderColor(.blue, for: .highlighted)
        //
        //        imageView.contentMode = .scaleAspectFill
        //        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        
        
        //        labelDescriptions.lineBreakMode = .byWordWrapping
        labelDescriptions.textColor = UIColor.gray
        //        labelDescriptions.numberOfLines = 1
        labelDescriptions.font = UIFont(name: "Helvetica", size: 12)
        
        //labelTitle.lineBreakMode = .byWordWrapping
        labelTitle.font = UIFont(name: "Helvetica-Bold", size: 14)
        
        
    }
    
    //    required init(coder: NSCoder) {
    //        super.init(coder: coder)!
    //    }
    
    //    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
    //        super.apply(layoutAttributes)
    //    }
    
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //        self.addSubview(cellContent)
    //
    //        let imagePad: CGFloat = 40
    //        imageView.frame = CGRect(x: imagePad,
    //                                 y: imagePad,
    //                                 width: self.frame.size.width - imagePad * 2,
    //                                 height: self.frame.size.height - 10 - imagePad * 2)
    //
    //        labelDescriptions.frame = CGRect(x: 15 ,
    //                                         y: self.frame.size.height - 30,
    //                                         width: self.frame.size.width,
    //                                         height: 16)
    //        labelTitle.sizeToFit()
    //        labelTitle.frame = CGRect(x: self.frame.size.width - labelTitle.frame.size.width - 10,
    //                                  y: 10,
    //                                  width: labelTitle.frame.size.width,
    //                                  height: labelTitle.frame.size.height)
    //    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageDownloader.cancel()
    }
    
    func populateCell(title: String,
                      url: String,
                      description: String
    ) {
        labelDescriptions.text = description
        labelTitle.text = title
        downloadImage(url: url)
    }
    
    
    private func downloadImage(url: String) {
        
        guard !url.isEmpty else {
            imageView.image = UIImage(named: "placeholder")
            return
        }
        
        
        if let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) , let urlFormat = URL(string: encodedURL){
            
            imageDownloader.downloadPhoto(with: urlFormat, completion: { [weak self] (image, isCached) in
                guard let strongSelf = self, strongSelf.imageDownloader.isCancelled == false else { return }
                
                if isCached {
                    strongSelf.imageView.image = image
                } else {
                    UIView.transition(with: strongSelf, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                        strongSelf.imageView.image = image
                    }, completion: nil)
                }
            })
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (pan.state == UIGestureRecognizer.State.changed) {
            let p: CGPoint = pan.translation(in: self)
            if(p.x >= 0){
                self.backgroundColor = UIColor.orange
            }else{
                self.backgroundColor = UIColor.red
            }
            
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            self.contentView.frame = CGRect(x: p.x,y: 0, width: width, height: height);
            self.deleteLabel1.frame = CGRect(x: p.x - deleteLabel1.frame.size.width-10, y: 0, width: 100, height: height)
            self.deleteLabel2.frame = CGRect(x: p.x + width + deleteLabel2.frame.size.width, y: 0, width: 100, height: height)
        }
        
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        
        let point = pan.translation(in: self)
        
        if pan.state == UIGestureRecognizer.State.began {
            
        } else if pan.state == UIGestureRecognizer.State.changed {
            self.setNeedsLayout()
        } else {
            if abs(pan.velocity(in: self).x) > 500 {
                if(point.x >= 0){
                    print(" add favorite ")
                     UIView.animate(withDuration: 0.2, animations: {
                                       self.setNeedsLayout()
                                       self.layoutIfNeeded()
                                   })
                }else{
                    delegate?.deleteItemCell(inCell: self)
                }
                
                
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }
    
}

