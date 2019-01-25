//
//  ComidaCell.swift
//  Yuumee
//
//  Created by Easy Code on 1/4/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

class ComidaCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    
    let desayuno: ArchiaBoldLabel = {
        let label = ArchiaBoldLabel()
        label.text = "Desayuno"
        return label
    }()
    let comida: ArchiaBoldLabel = {
        let label = ArchiaBoldLabel()
        label.text = "Comida"
        return label
    }()
    let cena: ArchiaBoldLabel = {
        let label = ArchiaBoldLabel()
        label.text = "Cena"
        return label
    }()
    
    
    let checkBoxDesayuno: UIView = {
        let view = UIView()
        view.addBorder(borderColor: UIColor.black, widthBorder: 2)
        view.isUserInteractionEnabled = true
        return view
    }()
    let checkBoxComida: UIView = {
        let view = UIView()
        view.addBorder(borderColor: UIColor.black, widthBorder: 2)
        view.isUserInteractionEnabled = true
        return view
    }()
    let checkBoxCena: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.addBorder(borderColor: UIColor.black, widthBorder: 2)
        return view
    }()
    
    let dataStorage = UserDefaults.standard
    
    func setUpView() {
        addSubview(desayuno)
        addSubview(comida)
        addSubview(cena)
        addSubview(checkBoxDesayuno)
        addSubview(checkBoxComida)
        addSubview(checkBoxCena)
        
        addConstraintsWithFormat(format: "H:|-[v0(12)]-[v1(v5)]-[v2(12)]-[v3(v5)]-[v4(12)]-[v5(v5)]-|",
                                 views: checkBoxDesayuno, desayuno, checkBoxComida, comida, checkBoxCena, cena)
        addConstraintsWithFormat(format: "V:|-4-[v0(12)]", views: checkBoxDesayuno)
        addConstraintsWithFormat(format: "V:|[v0]", views: desayuno)
        addConstraintsWithFormat(format: "V:|-4-[v0(12)]", views: checkBoxComida)
        addConstraintsWithFormat(format: "V:|[v0]", views: comida)
        addConstraintsWithFormat(format: "V:|-4-[v0(12)]", views: checkBoxCena)
        addConstraintsWithFormat(format: "V:|[v0]", views: cena)
        let tapCheckDesayuno = UITapGestureRecognizer(target: self,
                                                      action: #selector(checkDesayuno))
        tapCheckDesayuno.numberOfTapsRequired = 1
        checkBoxDesayuno.addGestureRecognizer(tapCheckDesayuno)
        let tapCheckComida = UITapGestureRecognizer(target: self,
                                                    action: #selector(checkComida))
        tapCheckComida.numberOfTapsRequired = 1
        checkBoxComida.addGestureRecognizer(tapCheckComida)
        let tapCheckCena = UITapGestureRecognizer(target: self,
                                                  action: #selector(checkCena))
        tapCheckCena.numberOfTapsRequired = 1
        checkBoxCena.addGestureRecognizer(tapCheckCena)
    }
    
    @objc func checkDesayuno(ckeck: Any) {
        dataStorage.setLastFoodSelectedEvent(tipo: TipoComida.desayuno.rawValue)
        self.checkBoxDesayuno.check()
        self.checkBoxComida.unCheck()
        self.checkBoxCena.unCheck()
    }
    
    @objc func checkComida(ckeck: Any) {
        dataStorage.setLastFoodSelectedEvent(tipo: TipoComida.comida.rawValue)
        self.checkBoxDesayuno.unCheck()
        self.checkBoxComida.check()
        self.checkBoxCena.unCheck()
    }
    
    @objc func checkCena(ckeck: Any) {
        dataStorage.setLastFoodSelectedEvent(tipo: TipoComida.cena.rawValue)
        self.checkBoxDesayuno.unCheck()
        self.checkBoxComida.unCheck()
        self.checkBoxCena.check()
    }
    
}
