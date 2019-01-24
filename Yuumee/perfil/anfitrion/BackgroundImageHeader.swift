//
//  BackgroundImageHeader.swift
//  Yuumee
//
//  Created by Easy Code on 1/4/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class BackgroundImageHeader: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    var imageBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.addBorder(borderColor: UIColor.gray, widthBorder: 1)
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .white
        return imageView
    }()
    
    
    var addCamera: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "camera"), for: .normal)
        button.tintColor = UIColor.rosa.withAlphaComponent(0.5)
        return button
    }()
    
    var addBackground: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "add"), for: .normal)
        button.tintColor = UIColor.rosa.withAlphaComponent(0.5)
        return button
    }()
    
    func setUpView(urlImage: String = "") {
        backgroundColor = UIColor.gris
        addSubview(imageBackground)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: imageBackground)
        addConstraintsWithFormat(format: "V:|-[v0]-|", views: imageBackground)
        imageBackground.addSubview(addCamera)
        imageBackground.addSubview(addBackground)
        imageBackground.addConstraintsWithFormat(format: "H:|-[v0]-|", views: addCamera)
        imageBackground.addConstraintsWithFormat(format: "V:|-[v0]-|", views: addCamera)
        imageBackground.addConstraintsWithFormat(format: "H:[v0]-|", views: addBackground)
        imageBackground.addConstraintsWithFormat(format: "V:[v0]-|", views: addBackground)
        
        if !urlImage.isEmpty {
            for v in imageBackground.subviews {
                v.removeFromSuperview()
            }
            let url = URL(string: urlImage)
            imageBackground.af_setImage(withURL: url!)
        }
        
        addCamera.addTarget(self, action: #selector(addNewBackgroundImageFromCamera) , for: .touchUpInside)
        addBackground.addTarget(self, action: #selector(addNewBackgroundImage) , for: .touchUpInside)
        
    }
    
    @objc func addNewBackgroundImageFromCamera() {
        print(" addNewBackgroundImageFromCamera ")
    }
    
    @objc func addNewBackgroundImage() {
        print(" addNewBackgroundImage ")
    }
    
}
