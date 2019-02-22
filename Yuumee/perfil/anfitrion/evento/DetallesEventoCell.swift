//
//  DetallesEventoCell.swift
//  Yuumee
//
//  Created by Luis Segoviano on 1/6/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

class DetallesEventoCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    
    let dataStorage = UserDefaults.standard
    
    func getBoldLabel(text: String) -> ArchiaBoldLabel {
        let label  = ArchiaBoldLabel()
        label.text = text
        return label
    }
    func getRegularLabel(text: String) -> ArchiaRegularLabel {
        let label  = ArchiaRegularLabel()
        label.text = text
        return label
    }
    func getTextView() -> UITextView {
        let textView       = UITextView()
        textView.textColor = UIColor.darkGray
        textView.font      = UIFont(name: "ArchiaRegular", size: 14.0)
        textView.delegate  = self
        textView.addBorder(borderColor: .black, widthBorder: 1)
        return textView
    }
    func getView() -> UIView {
        let view = UIView()
        return view
    }
    
    
    var dscripcion: ArchiaBoldLabel!
    var menu:       ArchiaBoldLabel!
    var bebidas:    ArchiaBoldLabel!
    var postres:    ArchiaBoldLabel!

    var descTextView:     UITextView!
    var menuTextView:     UITextView!
    var bebidasTextView:  UITextView!
    var postresTextView:  UITextView!
    var contCostoMenu:    UIView!
    var contCostoBebidas: UIView!
    var contCostoPostres: UIView!
    
    var costoMenu:    ArchiaBoldLabel!
    var costoBebidas: ArchiaBoldLabel!
    var costoPostres: ArchiaBoldLabel!
    var pesosMenu:    ArchiaRegularLabel!
    var pesosBebidas: ArchiaRegularLabel!
    var pesosPostres: ArchiaRegularLabel!
    
    var costoMenuTextView:    UITextView!
    var costoBebidasTextView: UITextView!
    var costoPostreTextView:  UITextView!
    
    var mxMenu:    ArchiaRegularLabel!
    var mxBebidas: ArchiaRegularLabel!
    var mxPostres: ArchiaRegularLabel!
    
    func setUpView() {
        dscripcion = getBoldLabel(text: "Descripción:")
        menu       = getBoldLabel(text: "Menú:")
        bebidas    = getBoldLabel(text: "Bebidas:")
        postres    = getBoldLabel(text: "Postres:")
        
        // ---------------------------------------------------------------------
        descTextView     = getTextView()
        descTextView.tag = TAG_DESCRIPCION_EVENT
        menuTextView     = getTextView()
        menuTextView.tag = TAG_MENU_EVENT
        bebidasTextView     = getTextView()
        bebidasTextView.tag = TAG_BEBIDAS_EVENT
        postresTextView     = getTextView()
        postresTextView.tag = TAG_POSTRES_EVENT
        
        descTextView.text = dataStorage.getDescEvento()
        menuTextView.text = dataStorage.getMenuEvento()
        bebidasTextView.text = dataStorage.getBebidasEvento()
        postresTextView.text = dataStorage.getPostreEvento()
        // ---------------------------------------------------------------------
        contCostoMenu    = getView()
        contCostoBebidas = getView()
        contCostoPostres = getView()
        
        // Labels
        addSubview(dscripcion)
        addSubview(menu)
        addSubview(bebidas)
        addSubview(postres)
        // Texts Views
        addSubview(descTextView)
        addSubview(menuTextView)
        addSubview(bebidasTextView)
        addSubview(postresTextView)
        // Cont Costos
        addSubview(contCostoMenu)
        addSubview(contCostoBebidas)
        addSubview(contCostoPostres)
        
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: dscripcion)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: descTextView)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: menu)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: menuTextView)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: bebidas)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: bebidasTextView)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: postres)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: postresTextView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: contCostoMenu)
        addConstraintsWithFormat(format: "H:|[v0]|", views: contCostoBebidas)
        addConstraintsWithFormat(format: "H:|[v0]|", views: contCostoPostres)
        addConstraintsWithFormat(format: "V:|-[v0]-[v1(80)]-[v2]-[v3(80)]-[v4(50)]-[v5]-[v6(80)]-[v7(50)]-[v8]-[v9(80)]-[v10(50)]",
                                 views: dscripcion, descTextView, menu, menuTextView, contCostoMenu, bebidas, bebidasTextView, contCostoBebidas, postres, postresTextView, contCostoPostres)
        
        // Vista de Menu
        costoMenu = getBoldLabel(text: "Costo:")
        costoMenuTextView = getTextView()
        costoMenuTextView.tag = TAG_COSTO_MENU_EVENT
        costoMenuTextView.textAlignment = .center
        costoMenuTextView.font = UIFont.boldSystemFont(ofSize: 14)
        costoMenuTextView.addBorder(borderColor: .black, widthBorder: 1)
        costoMenuTextView.keyboardType = .numberPad
        costoMenuTextView.text = dataStorage.getCostoMenuEvento() // Costo
        pesosMenu = getRegularLabel(text: "$")
        pesosMenu.textColor = UIColor.lightGray
        mxMenu = getRegularLabel(text: ".00 mx")
        mxMenu.textColor = UIColor.lightGray
        contCostoMenu.addSubview(costoMenu)
        contCostoMenu.addSubview(costoMenuTextView)
        contCostoMenu.addSubview(pesosMenu)
        contCostoMenu.addSubview(mxMenu)
        contCostoMenu.addConstraintsWithFormat(format: "H:[v0]-[v1]-[v2(70)]-[v3]-|",
                                               views: costoMenu, pesosMenu, costoMenuTextView, mxMenu)
        contCostoMenu.addConstraintsWithFormat(format: "V:|-[v0]", views: costoMenu)
        contCostoMenu.addConstraintsWithFormat(format: "V:|[v0(30)]", views: costoMenuTextView)
        contCostoMenu.addConstraintsWithFormat(format: "V:|-[v0]", views: pesosMenu)
        contCostoMenu.addConstraintsWithFormat(format: "V:|-[v0]", views: mxMenu)
        
        // Vista de Bebidas
        costoBebidas = getBoldLabel(text: "Costo:")
        costoBebidasTextView = getTextView()
        costoBebidasTextView.tag = TAG_COSTO_BEBIDAS_EVENT
        costoBebidasTextView.textAlignment = .center
        costoBebidasTextView.font = UIFont.boldSystemFont(ofSize: 14)
        costoBebidasTextView.addBorder(borderColor: .black, widthBorder: 1)
        costoBebidasTextView.keyboardType = .numberPad
        costoBebidasTextView.text = dataStorage.getCostoBebidasEvento() // Costo
        pesosBebidas = getRegularLabel(text: "$")
        pesosBebidas.textColor = UIColor.lightGray
        mxBebidas = getRegularLabel(text: ".00 mx")
        mxBebidas.textColor = UIColor.lightGray
        contCostoBebidas.addSubview(costoBebidas)
        contCostoBebidas.addSubview(costoBebidasTextView)
        contCostoBebidas.addSubview(pesosBebidas)
        contCostoBebidas.addSubview(mxBebidas)
        contCostoBebidas.addConstraintsWithFormat(format: "H:[v0]-[v1]-[v2(70)]-[v3]-|",
                                                  views: costoBebidas, pesosBebidas, costoBebidasTextView, mxBebidas)
        contCostoBebidas.addConstraintsWithFormat(format: "V:|-[v0]", views: costoBebidas)
        contCostoBebidas.addConstraintsWithFormat(format: "V:|[v0(30)]", views: costoBebidasTextView)
        contCostoBebidas.addConstraintsWithFormat(format: "V:|-[v0]", views: pesosBebidas)
        contCostoBebidas.addConstraintsWithFormat(format: "V:|-[v0]", views: mxBebidas)
        
        // Vista de Postres
        costoPostres = getBoldLabel(text: "Costo:")
        costoPostreTextView = getTextView()
        costoPostreTextView.tag = TAG_COSTO_POSTRES_EVENT
        costoPostreTextView.textAlignment = .center
        costoPostreTextView.font = UIFont.boldSystemFont(ofSize: 14)
        costoPostreTextView.addBorder(borderColor: .black, widthBorder: 1)
        costoPostreTextView.keyboardType = .numberPad
        costoPostreTextView.text = dataStorage.getCostoPostreEvento() // Costo
        pesosPostres = getRegularLabel(text: "$")
        pesosPostres.textColor = UIColor.lightGray
        mxPostres = getRegularLabel(text: ".00 mx")
        mxPostres.textColor = UIColor.lightGray
        contCostoPostres.addSubview(costoPostres)
        contCostoPostres.addSubview(costoPostreTextView)
        contCostoPostres.addSubview(pesosPostres)
        contCostoPostres.addSubview(mxPostres)
        contCostoPostres.addConstraintsWithFormat(format: "H:[v0]-[v1]-[v2(70)]-[v3]-|",
                                                  views: costoPostres, pesosPostres, costoPostreTextView, mxPostres)
        contCostoPostres.addConstraintsWithFormat(format: "V:|-[v0]", views: costoPostres)
        contCostoPostres.addConstraintsWithFormat(format: "V:|[v0(30)]", views: costoPostreTextView)
        contCostoPostres.addConstraintsWithFormat(format: "V:|-[v0]", views: pesosPostres)
        contCostoPostres.addConstraintsWithFormat(format: "V:|-[v0]", views: mxPostres)
        
    }
    
    
}


extension DetallesEventoCell: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView == descTextView {
            self.dataStorage.setDescripcionEvento(desc: descTextView.text)
        }
        
        if textView == menuTextView {
            self.dataStorage.setMenuEvento(menu: menuTextView.text)
        }
        
        if textView == bebidasTextView {
            self.dataStorage.setBebidasEvento(bebida: bebidasTextView.text)
        }
        
        if textView == postresTextView {
            self.dataStorage.setPostresEvento(postre: postresTextView.text)
        }
        
        if textView == costoMenuTextView {
            self.dataStorage.setCostoMenuEvento(costo: costoMenuTextView.text)
        }
        
        if textView == costoBebidasTextView {
            self.dataStorage.setCostoBebidasEvento(costo: costoMenuTextView.text)
        }
        
        if textView == costoPostreTextView {
            self.dataStorage.setPostresEventoCosto(costo: costoPostreTextView.text)
        }
        
    }
    
} // UITextViewDelegate

