//
//  BebidaPostreCell.swift
//  Yuumee
//
//  Created by Luis Segoviano on 2/4/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import Foundation
import UIKit

protocol UpdatePriceForBebidaPostre {
    func getNewPrice(id: String, newTotal: String, tipo: String)
}

class BebidaPostreCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate: UpdatePriceForBebidaPostre?
    
    let sizeForButtonAdd: CGFloat = 40.0
    
    lazy var add: UIButton = {
        let add: UIButton  = UIButton(type: .system)
        add.tintColor      = .rosa
        add.setTitle("+", for: .normal)
        add.addTarget(self, action: #selector(increment) , for: .touchUpInside)
        return add
    }()
    
    let numberSelected: UILabel = {
        let numberSelected: UILabel  = UILabel()
        numberSelected.textAlignment = .center
        numberSelected.text = "0"
        numberSelected.font = UIFont.init(name: numberSelected.font.familyName, size: 12)
        return numberSelected
    }()
    
    lazy var less: UIButton = {
        let less: UIButton = UIButton(type: .system)
        less.tintColor     = .rosa
        less.setTitle("-", for: .normal)
        less.addTarget(self, action: #selector(decrement) , for: .touchUpInside)
        return less
    }()
    
    let bebidaLbl: UILabel = {
        let bebidaLbl  = UILabel()
        bebidaLbl.font = UIFont.init(name: bebidaLbl.font.familyName, size: 12)
        return bebidaLbl
    }()
    
    let costoBebida: UILabel = {
        let costoBebida  = UILabel()
        costoBebida.font = UIFont.init(name: costoBebida.font.familyName, size: 12)
        return costoBebida
    }()
    
    var bebidaPostre: BebidaPostre!
    
    func setUpView(bp: BebidaPostre) {
        self.bebidaPostre = bp
        addSubview(add)
        addSubview(numberSelected)
        addSubview(less)
        addSubview(bebidaLbl)
        addSubview(costoBebida)
        bebidaLbl.text   = bp.nombre
        costoBebida.text = bp.costo
        addConstraintsWithFormat(format: "H:|-[v0(\(sizeForButtonAdd))]-[v1(50)]-[v2(\(sizeForButtonAdd))]-[v3(90)]-[v4(90)]",
            views: less, numberSelected, add, bebidaLbl, costoBebida)
        addConstraintsWithFormat(format: "V:|[v0(\(sizeForButtonAdd))]", views: add)
        addConstraintsWithFormat(format: "V:|[v0(\(sizeForButtonAdd))]", views: less)
        addConstraintsWithFormat(format: "V:|-[v0(30)]", views: numberSelected)
        addConstraintsWithFormat(format: "V:|-[v0(30)]", views: bebidaLbl)
        addConstraintsWithFormat(format: "V:|-[v0(30)]", views: costoBebida)
        borders(for: [.bottom], width: 1, color: .darkGray)
    }
    
    @objc func increment(sender: Any) {
        let toIncrement = Int(self.numberSelected.text!)!
        let n = toIncrement + 1
        self.numberSelected.text = "\(n)"
        delegate?.getNewPrice(id: bebidaPostre.id, newTotal: "\(n)", tipo: bebidaPostre.tipo)
    }
    
    @objc func decrement(sender: Any) {
        let toIncrement = Int(self.numberSelected.text!)!
        if toIncrement == 0 {
            delegate?.getNewPrice(id: bebidaPostre.id, newTotal: "0", tipo: bebidaPostre.tipo)
            return
        }
        let n = toIncrement - 1
        self.numberSelected.text = "\(n)"
        delegate?.getNewPrice(id: bebidaPostre.id, newTotal: "\(n)", tipo: bebidaPostre.tipo)
    }
    
}
