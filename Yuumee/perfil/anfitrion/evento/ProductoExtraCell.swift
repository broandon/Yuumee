//
//  ProductoExtraCell.swift
//  Yuumee
//
//  Created by Luis Segoviano on 1/23/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import Foundation
import UIKit

class ProductoExtraCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    
    let productoExtra: ArchiaBoldLabel = {
        let label  = ArchiaBoldLabel()
        label.text = "Producto extra"
        label.textAlignment = .center
        label.textColor     = .darkGray
        label.borders(for: [.top, .bottom], width: 1.0, color: UIColor.verde)
        return label
    }()
    
    let contentBebidas: UIView = {
        let view = UIView()
        return view
    }()
    
    let sep: UIView = {
        let view = UIView()
        view.backgroundColor = .verde
        return view
    }()
    
    let contentPostres: UIView = {
        let view = UIView()
        return view
    }()
    
    let bebidas: ArchiaBoldLabel = {
        let label  = ArchiaBoldLabel()
        label.text = "Bebidas"
        label.textAlignment = .center
        label.textColor     = .rosa
        return label
    }()
    
    let postres: ArchiaBoldLabel = {
        let label  = ArchiaBoldLabel()
        label.text = "Postres"
        label.textAlignment = .center
        label.textColor     = .rosa
        return label
    }()
    
    
    let width = (ScreenSize.screenWidth - 50) / 2
    
    let bebidasView = ProductosExtraView()
    
    let postresView = ProductosExtraView()
    
    func setUpView() {
        addSubview(productoExtra)
        addSubview(contentBebidas)
        addSubview(sep)
        addSubview(contentPostres)
        
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: productoExtra)
        addConstraintsWithFormat(format: "H:|-[v0(\(width))]-[v1(2)]-[v2(\(width))]", views: contentBebidas, sep, contentPostres)
        addConstraintsWithFormat(format: "V:|-[v0(30)]-[v1]-|", views: productoExtra, contentBebidas)
        addConstraintsWithFormat(format: "V:|-[v0(30)]-[v1]-|", views: productoExtra, sep)
        addConstraintsWithFormat(format: "V:|-[v0(30)]-[v1]-|", views: productoExtra, contentPostres)
        
        // -------------------------- Bebidas ----------------------------------
        bebidasView.setUpView()
        bebidasView.tag = ProductoExtraCell.TAG_BEBIDAS_VIEW
        contentBebidas.addSubview(bebidas)
        contentBebidas.addSubview(bebidasView)
        contentBebidas.addConstraintsWithFormat(format: "H:|-[v0]",     views: bebidas)
        contentBebidas.addConstraintsWithFormat(format: "H:|[v0]|",     views: bebidasView)
        contentBebidas.addConstraintsWithFormat(format: "V:|-[v0(30)]-[v1]|", views: bebidas, bebidasView)
        
        // -------------------------- Postres ----------------------------------
        postresView.setUpView()
        postresView.tag = ProductoExtraCell.TAG_POSTRES_VIEW
        contentPostres.addSubview(postres)
        contentPostres.addSubview(postresView)
        contentPostres.addConstraintsWithFormat(format: "H:|-[v0]", views: postres)
        contentPostres.addConstraintsWithFormat(format: "H:|[v0]|", views: postresView)
        contentPostres.addConstraintsWithFormat(format: "V:|-[v0(30)]-[v1]|", views: postres, postresView)
    }
    
    static let TAG_BEBIDAS_VIEW: Int = 246
    static let TAG_POSTRES_VIEW: Int = 357
    
}
