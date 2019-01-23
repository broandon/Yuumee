//
//  ProductosExtraView.swift
//  Yuumee
//
//  Created by Luis Segoviano on 1/23/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import Foundation
import UIKit


class ProductosExtraView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func getOpcionLabel(text: String) -> UILabel {
        let label  = UILabel()
        label.text = text
        label.textColor = .rosa
        return label
    }
    private func getCostoLabel() -> UILabel {
        let label  = UILabel()
        label.text = "Costo:"
        label.textColor = .rosa
        return label
    }
    private func getOpcionTextField() -> UITextField {
        let textField  = UITextField()
        textField.backgroundColor = .gris
        return textField
    }
    private func getCostoTextField() -> UITextField {
        let textField = UITextField()
        textField.addBorder(borderColor: .gris, widthBorder: 1)
        return textField
    }
    
    var contOpcion1:  UIView!
    var opcion1Label: UILabel!
    var costo1Label:  UILabel!
    var opcion1Input: UITextField!
    var costo1Input:  UITextField!
    
    var contOpcion2:  UIView!
    var opcion2Label: UILabel!
    var costo2Label:  UILabel!
    var opcion2Input: UITextField!
    var costo2Input:  UITextField!
    
    var contOpcion3:  UIView!
    var opcion3Label: UILabel!
    var costo3Label:  UILabel!
    var opcion3Input: UITextField!
    var costo3Input:  UITextField!
    
    var contOpcion4:  UIView!
    var opcion4Label: UILabel!
    var costo4Label:  UILabel!
    var opcion4Input: UITextField!
    var costo4Input:  UITextField!
    
    var contOpcion5:  UIView!
    var opcion5Label: UILabel!
    var costo5Label:  UILabel!
    var opcion5Input: UITextField!
    var costo5Input:  UITextField!
    
    let heightCont: CGFloat = 120.0
    
    func setUpView() {
        contOpcion1  = UIView()
        opcion1Label = getOpcionLabel(text: "Opción 1:")
        costo1Label  = getCostoLabel()
        opcion1Input = getOpcionTextField()
        costo1Input  = getCostoTextField()
        
        contOpcion2  = UIView()
        opcion2Label = getOpcionLabel(text: "Opción 2:")
        costo2Label  = getCostoLabel()
        opcion2Input = getOpcionTextField()
        costo2Input  = getCostoTextField()
        
        contOpcion3  = UIView()
        opcion3Label = getOpcionLabel(text: "Opción 3:")
        costo3Label  = getCostoLabel()
        opcion3Input = getOpcionTextField()
        costo3Input  = getCostoTextField()
        
        contOpcion4  = UIView()
        opcion4Label = getOpcionLabel(text: "Opción 4:")
        costo4Label  = getCostoLabel()
        opcion4Input = getOpcionTextField()
        costo4Input  = getCostoTextField()
        
        contOpcion5  = UIView()
        opcion5Label = getOpcionLabel(text: "Opción 5:")
        costo5Label  = getCostoLabel()
        opcion5Input = getOpcionTextField()
        costo5Input  = getCostoTextField()
        
        addSubview(contOpcion1)
        addSubview(contOpcion2)
        addSubview(contOpcion3)
        addSubview(contOpcion4)
        addSubview(contOpcion5)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: contOpcion1)
        addConstraintsWithFormat(format: "H:|[v0]|", views: contOpcion2)
        addConstraintsWithFormat(format: "H:|[v0]|", views: contOpcion3)
        addConstraintsWithFormat(format: "H:|[v0]|", views: contOpcion4)
        addConstraintsWithFormat(format: "H:|[v0]|", views: contOpcion5)
        addConstraintsWithFormat(format: "V:|[v0(\(heightCont))]-[v1(\(heightCont))]-[v2(\(heightCont))]-[v3(\(heightCont))]-[v4(\(heightCont))]", views: contOpcion1, contOpcion2, contOpcion3, contOpcion4, contOpcion5)
        
        contOpcion1.addSubview(opcion1Label)
        contOpcion1.addSubview(opcion1Input)
        contOpcion1.addSubview(costo1Label)
        contOpcion1.addSubview(costo1Input)
        contOpcion1.addConstraintsWithFormat(format: "H:|-[v0]-|", views: opcion1Label)
        contOpcion1.addConstraintsWithFormat(format: "H:|-[v0]-|", views: opcion1Input)
        contOpcion1.addConstraintsWithFormat(format: "H:|-[v0(50)]-[v1]-|", views: costo1Label, costo1Input)
        contOpcion1.addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1(30)]-[v2(30)]", views: opcion1Label, opcion1Input, costo1Label)
        contOpcion1.addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1(30)]-[v2(30)]", views: opcion1Label, opcion1Input, costo1Input)
        
        contOpcion2.addSubview(opcion2Label)
        contOpcion2.addSubview(opcion2Input)
        contOpcion2.addSubview(costo2Label)
        contOpcion2.addSubview(costo2Input)
        contOpcion2.addConstraintsWithFormat(format: "H:|-[v0]-|", views: opcion2Label)
        contOpcion2.addConstraintsWithFormat(format: "H:|-[v0]-|", views: opcion2Input)
        contOpcion2.addConstraintsWithFormat(format: "H:|-[v0(50)]-[v1]-|", views: costo2Label, costo2Input)
        contOpcion2.addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1(30)]-[v2(30)]",
                                             views: opcion2Label, opcion2Input, costo2Label)
        contOpcion2.addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1(30)]-[v2(30)]",
                                             views: opcion2Label, opcion2Input, costo2Input)
        
        contOpcion3.addSubview(opcion3Label)
        contOpcion3.addSubview(opcion3Input)
        contOpcion3.addSubview(costo3Label)
        contOpcion3.addSubview(costo3Input)
        contOpcion3.addConstraintsWithFormat(format: "H:|-[v0]-|", views: opcion3Label)
        contOpcion3.addConstraintsWithFormat(format: "H:|-[v0]-|", views: opcion3Input)
        contOpcion3.addConstraintsWithFormat(format: "H:|-[v0(50)]-[v1]-|", views: costo3Label, costo3Input)
        contOpcion3.addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1(30)]-[v2(30)]",
                                             views: opcion3Label, opcion3Input, costo3Label)
        contOpcion3.addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1(30)]-[v2(30)]",
                                             views: opcion3Label, opcion3Input, costo3Input)
        
        contOpcion4.addSubview(opcion4Label)
        contOpcion4.addSubview(opcion4Input)
        contOpcion4.addSubview(costo4Label)
        contOpcion4.addSubview(costo4Input)
        contOpcion4.addConstraintsWithFormat(format: "H:|-[v0]-|", views: opcion4Label)
        contOpcion4.addConstraintsWithFormat(format: "H:|-[v0]-|", views: opcion4Input)
        contOpcion4.addConstraintsWithFormat(format: "H:|-[v0(50)]-[v1]-|", views: costo4Label, costo4Input)
        contOpcion4.addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1(30)]-[v2(30)]",
                                             views: opcion4Label, opcion4Input, costo4Label)
        contOpcion4.addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1(30)]-[v2(30)]",
                                             views: opcion4Label, opcion4Input, costo4Input)
        
        contOpcion5.addSubview(opcion5Label)
        contOpcion5.addSubview(opcion5Input)
        contOpcion5.addSubview(costo5Label)
        contOpcion5.addSubview(costo5Input)
        contOpcion5.addConstraintsWithFormat(format: "H:|-[v0]-|", views: opcion5Label)
        contOpcion5.addConstraintsWithFormat(format: "H:|-[v0]-|", views: opcion5Input)
        contOpcion5.addConstraintsWithFormat(format: "H:|-[v0(50)]-[v1]-|", views: costo5Label, costo5Input)
        contOpcion5.addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1(30)]-[v2(30)]",
                                             views: opcion5Label, opcion5Input, costo5Label)
        contOpcion5.addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1(30)]-[v2(30)]",
                                             views: opcion5Label, opcion5Input, costo5Input)
    }
    
}
