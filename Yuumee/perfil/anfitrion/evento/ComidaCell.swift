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
        self.checkBoxDesayuno.check()
        self.checkBoxComida.unCheck()
        self.checkBoxCena.unCheck()
    }
    
    @objc func checkComida(ckeck: Any) {
        self.checkBoxDesayuno.unCheck()
        self.checkBoxComida.check()
        self.checkBoxCena.unCheck()
    }
    
    @objc func checkCena(ckeck: Any) {
        self.checkBoxDesayuno.unCheck()
        self.checkBoxComida.unCheck()
        self.checkBoxCena.check()
    }
    
}


extension UIView {
    
    func check() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .gray
        backgroundView.addBorder(borderColor: .white, widthBorder: 2)
        self.addSubview(backgroundView)
        self.addConstraintsWithFormat(format: "H:|-1-[v0]-1-|", views: backgroundView)
        self.addConstraintsWithFormat(format: "V:|-1-[v0]-1-|", views: backgroundView)
    }
    
    func unCheck() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }
    
}
