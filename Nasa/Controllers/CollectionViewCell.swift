//
//  CollectionViewCell.swift
//  Nasa
//
//  Created by Jhon Ospino Bernal on 14/06/20.
//  Copyright © 2020 Jhon Ospino Bernal. All rights reserved.
//

import UIKit


class CollectionViewCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    private var imageDownloader = ImageDownloader()
    
    fileprivate var labelDescriptions = UILabel()
    fileprivate var labelTitle = UILabel()
    fileprivate var inkRipple = InkRipple()
    fileprivate var cellContent = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellContent.frame = bounds
        cellContent.backgroundColor = UIColor.white
        cellContent.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cellContent.clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cellContent.addSubview(imageView)
        
        
        
        labelDescriptions.lineBreakMode = .byWordWrapping
        labelDescriptions.textColor = UIColor.gray
        labelDescriptions.numberOfLines = 1
        labelDescriptions.font = UIFont(name: "Helvetica", size: 14)
        cellContent.addSubview(labelDescriptions)
        
        labelTitle.lineBreakMode = .byWordWrapping
        labelTitle.font = UIFont(name: "Helvetica-Bold", size: 16)
        cellContent.addSubview(labelTitle)
        
        inkRipple.frame = self.bounds
        inkRipple.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cellContent.addSubview(inkRipple)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(cellContent)
        
        let imagePad: CGFloat = 40
        imageView.frame = CGRect(x: imagePad,
                                 y: imagePad,
                                 width: self.frame.size.width - imagePad * 2,
                                 height: self.frame.size.height - 10 - imagePad * 2)
        
        labelDescriptions.frame = CGRect(x: 15 ,
                                         y: self.frame.size.height - 30,
                                         width: self.frame.size.width,
                                         height: 16)
        labelTitle.sizeToFit()
        labelTitle.frame = CGRect(x: self.frame.size.width - labelTitle.frame.size.width - 10,
                                  y: 10,
                                  width: labelTitle.frame.size.width,
                                  height: labelTitle.frame.size.height)
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
            imageView.image = UIImage(named: "placeHolder")
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
    
}

