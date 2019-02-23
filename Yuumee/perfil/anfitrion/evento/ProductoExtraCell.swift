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
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bebidasView.costo1Input.text = ""
        bebidasView.costo2Input.text = ""
        bebidasView.costo3Input.text = ""
        bebidasView.costo4Input.text = ""
        bebidasView.costo5Input.text = ""
        postresView.costo1Input.text = ""
        postresView.costo2Input.text = ""
        postresView.costo3Input.text = ""
        postresView.costo4Input.text = ""
        postresView.costo5Input.text = ""
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
    
    var bebidasView: ProductosExtraView = ProductosExtraView()
    
    var postresView: ProductosExtraView = ProductosExtraView()
    
    let dataStorage = UserDefaults.standard
    
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
        contentBebidas.addConstraintsWithFormat(format: "H:|-[v0]", views: bebidas)
        contentBebidas.addConstraintsWithFormat(format: "H:|[v0]|", views: bebidasView)
        contentBebidas.addConstraintsWithFormat(format: "V:|-[v0(30)]-[v1]|", views: bebidas, bebidasView)
        
        
        // -------------------------- Postres ----------------------------------
        postresView.setUpView()
        postresView.tag = ProductoExtraCell.TAG_POSTRES_VIEW
        contentPostres.addSubview(postres)
        contentPostres.addSubview(postresView)
        contentPostres.addConstraintsWithFormat(format: "H:|-[v0]", views: postres)
        contentPostres.addConstraintsWithFormat(format: "H:|[v0]|", views: postresView)
        contentPostres.addConstraintsWithFormat(format: "V:|-[v0(30)]-[v1]|", views: postres, postresView)
        
        
        
        // ---------------------------------------------------------------------
        //                          set up en DataStorage
        bebidasView.opcion1Input.delegate = self
        bebidasView.opcion2Input.delegate = self
        bebidasView.opcion3Input.delegate = self
        bebidasView.opcion4Input.delegate = self
        bebidasView.opcion5Input.delegate = self
        bebidasView.costo1Input.delegate = self
        bebidasView.costo2Input.delegate = self
        bebidasView.costo3Input.delegate = self
        bebidasView.costo4Input.delegate = self
        bebidasView.costo5Input.delegate = self
        
        postresView.opcion1Input.delegate = self
        postresView.opcion2Input.delegate = self
        postresView.opcion3Input.delegate = self
        postresView.opcion4Input.delegate = self
        postresView.opcion5Input.delegate = self
        postresView.costo1Input.delegate = self
        postresView.costo2Input.delegate = self
        postresView.costo3Input.delegate = self
        postresView.costo4Input.delegate = self
        postresView.costo5Input.delegate = self
        
        
        bebidasView.opcion1Input.text = dataStorage.getBebida1()
        bebidasView.opcion2Input.text = dataStorage.getBebida2()
        bebidasView.opcion3Input.text = dataStorage.getBebida3()
        bebidasView.opcion4Input.text = dataStorage.getBebida4()
        bebidasView.opcion5Input.text = dataStorage.getBebida5()
        bebidasView.costo1Input.text = dataStorage.getCostoBebida1()
        bebidasView.costo2Input.text = dataStorage.getCostoBebida2()
        bebidasView.costo3Input.text = dataStorage.getCostoBebida3()
        bebidasView.costo4Input.text = dataStorage.getCostoBebida4()
        bebidasView.costo5Input.text = dataStorage.getCostoBebida5()
        
        postresView.opcion1Input.text = dataStorage.getPostre1()
        postresView.opcion2Input.text = dataStorage.getPostre2()
        postresView.opcion3Input.text = dataStorage.getPostre3()
        postresView.opcion4Input.text = dataStorage.getPostre4()
        postresView.opcion5Input.text = dataStorage.getPostre5()
        postresView.costo1Input.text = dataStorage.getCostoPostre1()
        postresView.costo2Input.text = dataStorage.getCostoPostre2()
        postresView.costo3Input.text = dataStorage.getCostoPostre3()
        postresView.costo4Input.text = dataStorage.getCostoPostre4()
        postresView.costo5Input.text = dataStorage.getCostoPostre5()
        
    }
    
    static let TAG_BEBIDAS_VIEW: Int = 246
    static let TAG_POSTRES_VIEW: Int = 357
    
}


extension ProductoExtraCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Bebidas
        // Bebidas - Opcion
        if textField == bebidasView.opcion1Input {
            dataStorage.setBebida1(opcion: bebidasView.opcion1Input.text!)
        }
        if textField == bebidasView.opcion2Input {
            dataStorage.setBebida2(opcion: bebidasView.opcion2Input.text!)
        }
        if textField == bebidasView.opcion3Input {
            dataStorage.setBebida3(opcion: bebidasView.opcion3Input.text!)
        }
        if textField == bebidasView.opcion4Input {
            dataStorage.setBebida4(opcion: bebidasView.opcion4Input.text!)
        }
        if textField == bebidasView.opcion5Input {
            dataStorage.setBebida5(opcion: bebidasView.opcion5Input.text!)
        }
        // Bebidas - Costo
        if textField == bebidasView.costo1Input {
            dataStorage.setCostoBebida1(costo: bebidasView.costo1Input.text!)
        }
        if textField == bebidasView.costo2Input {
            dataStorage.setCostoBebida2(costo: bebidasView.costo2Input.text!)
        }
        if textField == bebidasView.costo3Input {
            dataStorage.setCostoBebida3(costo: bebidasView.costo3Input.text!)
        }
        if textField == bebidasView.costo4Input {
            dataStorage.setCostoBebida4(costo: bebidasView.costo4Input.text!)
        }
        if textField == bebidasView.costo5Input {
            dataStorage.setCostoBebida5(costo: bebidasView.costo5Input.text!)
        }
        // Postres
        // Postresw - Opcion
        if textField == postresView.opcion1Input {
            dataStorage.setPostre1(opcion: postresView.opcion1Input.text!)
        }
        if textField == postresView.opcion2Input {
            dataStorage.setPostre2(opcion: postresView.opcion2Input.text!)
        }
        if textField == postresView.opcion3Input {
            dataStorage.setPostre3(opcion: postresView.opcion3Input.text!)
        }
        if textField == postresView.opcion4Input {
            dataStorage.setPostre4(opcion: postresView.opcion4Input.text!)
        }
        if textField == postresView.opcion5Input {
            dataStorage.setPostre5(opcion: postresView.opcion5Input.text!)
        }
        // Postre - Costo
        if textField == postresView.costo1Input {
            dataStorage.setCostoPostre1(costo: postresView.costo1Input.text!)
        }
        if textField == postresView.costo2Input {
            dataStorage.setCostoPostre2(costo: postresView.costo2Input.text!)
        }
        if textField == postresView.costo3Input {
            dataStorage.setCostoPostre3(costo: postresView.costo3Input.text!)
        }
        if textField == postresView.costo4Input {
            dataStorage.setCostoPostre4(costo: postresView.costo4Input.text!)
        }
        if textField == postresView.costo5Input {
            dataStorage.setCostoPostre5(costo: postresView.costo5Input.text!)
        }
    }
    
    
}



// Keys Userdefaults Bebidas
//
enum UserDefaultBebidas: String {
    case bebida1
    case bebida2
    case bebida3
    case bebida4
    case bebida5
    case costoBebida1
    case costoBebida2
    case costoBebida3
    case costoBebida4
    case costoBebida5
}

extension UserDefaults {
    
    func setBebida1(opcion: String = "") {
        set(opcion, forKey: UserDefaultBebidas.bebida1.rawValue)
    }
    func getBebida1() -> String? {
        return string(forKey: UserDefaultBebidas.bebida1.rawValue) ?? ""
    }
    func setCostoBebida1(costo: String = "") {
        set(costo, forKey: UserDefaultBebidas.costoBebida1.rawValue)
    }
    func getCostoBebida1() -> String? {
        return string(forKey: UserDefaultBebidas.costoBebida1.rawValue) ?? "0"
    }
    
    
    func setBebida2(opcion: String = "") {
        set(opcion, forKey: UserDefaultBebidas.bebida2.rawValue)
    }
    func getBebida2() -> String? {
        return string(forKey: UserDefaultBebidas.bebida2.rawValue) ?? ""
    }
    func setCostoBebida2(costo: String = "") {
        set(costo, forKey: UserDefaultBebidas.costoBebida2.rawValue)
    }
    func getCostoBebida2() -> String? {
        return string(forKey: UserDefaultBebidas.costoBebida2.rawValue) ?? "0"
    }
    
    
    func setBebida3(opcion: String = "") {
        set(opcion, forKey: UserDefaultBebidas.bebida3.rawValue)
    }
    func getBebida3() -> String? {
        return string(forKey: UserDefaultBebidas.bebida3.rawValue) ?? ""
    }
    func setCostoBebida3(costo: String = "") {
        set(costo, forKey: UserDefaultBebidas.costoBebida3.rawValue)
    }
    func getCostoBebida3() -> String? {
        return string(forKey: UserDefaultBebidas.costoBebida3.rawValue) ?? "0"
    }
    
    
    func setBebida4(opcion: String = "") {
        set(opcion, forKey: UserDefaultBebidas.bebida4.rawValue)
    }
    func getBebida4() -> String? {
        return string(forKey: UserDefaultBebidas.bebida4.rawValue) ?? ""
    }
    func setCostoBebida4(costo: String = "") {
        set(costo, forKey: UserDefaultBebidas.costoBebida4.rawValue)
    }
    func getCostoBebida4() -> String? {
        return string(forKey: UserDefaultBebidas.costoBebida4.rawValue) ?? "0"
    }
    
    
    func setBebida5(opcion: String = "") {
        set(opcion, forKey: UserDefaultBebidas.bebida5.rawValue)
    }
    func getBebida5() -> String? {
        return string(forKey: UserDefaultBebidas.bebida5.rawValue) ?? ""
    }
    func setCostoBebida5(costo: String = "") {
        set(costo, forKey: UserDefaultBebidas.costoBebida5.rawValue)
    }
    func getCostoBebida5() -> String? {
        return string(forKey: UserDefaultBebidas.costoBebida5.rawValue) ?? "0"
    }
    
}



enum UserDefaultPostres: String {
    case postre1
    case postre2
    case postre3
    case postre4
    case postre5
    case costoPostre1
    case costoPostre2
    case costoPostre3
    case costoPostre4
    case costoPostre5
    
}

extension UserDefaults {
    
    func setPostre1(opcion: String = "") {
        set(opcion, forKey: UserDefaultPostres.postre1.rawValue)
    }
    func getPostre1() -> String? {
        return string(forKey: UserDefaultPostres.postre1.rawValue) ?? ""
    }
    func setCostoPostre1(costo: String = "") {
        set(costo, forKey: UserDefaultPostres.costoPostre1.rawValue)
    }
    func getCostoPostre1() -> String? {
        return string(forKey: UserDefaultPostres.costoPostre1.rawValue) ?? "0"
    }
    
    
    func setPostre2(opcion: String = "") {
        set(opcion, forKey: UserDefaultPostres.postre2.rawValue)
    }
    func getPostre2() -> String? {
        return string(forKey: UserDefaultPostres.postre2.rawValue) ?? ""
    }
    func setCostoPostre2(costo: String = "") {
        set(costo, forKey: UserDefaultPostres.costoPostre2.rawValue)
    }
    func getCostoPostre2() -> String? {
        return string(forKey: UserDefaultPostres.costoPostre2.rawValue) ?? "0"
    }
    
    
    func setPostre3(opcion: String = "") {
        set(opcion, forKey: UserDefaultPostres.postre3.rawValue)
    }
    func getPostre3() -> String? {
        return string(forKey: UserDefaultPostres.postre3.rawValue) ?? ""
    }
    func setCostoPostre3(costo: String = "") {
        set(costo, forKey: UserDefaultPostres.costoPostre3.rawValue)
    }
    func getCostoPostre3() -> String? {
        return string(forKey: UserDefaultPostres.costoPostre3.rawValue) ?? "0"
    }
    
    
    func setPostre4(opcion: String = "") {
        set(opcion, forKey: UserDefaultPostres.postre4.rawValue)
    }
    func getPostre4() -> String? {
        return string(forKey: UserDefaultPostres.postre4.rawValue) ?? ""
    }
    func setCostoPostre4(costo: String = "") {
        set(costo, forKey: UserDefaultPostres.costoPostre4.rawValue)
    }
    func getCostoPostre4() -> String? {
        return string(forKey: UserDefaultPostres.costoPostre4.rawValue) ?? "0"
    }
    
    
    func setPostre5(opcion: String = "") {
        set(opcion, forKey: UserDefaultPostres.postre5.rawValue)
    }
    func getPostre5() -> String? {
        return string(forKey: UserDefaultPostres.postre5.rawValue) ?? ""
    }
    func setCostoPostre5(costo: String = "") {
        set(costo, forKey: UserDefaultPostres.costoPostre5.rawValue)
    }
    func getCostoPostre5() -> String? {
        return string(forKey: UserDefaultPostres.costoPostre5.rawValue) ?? "0"
    }
    
}


