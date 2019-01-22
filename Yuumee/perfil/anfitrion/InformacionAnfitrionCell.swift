//
//  InformacionAnfitrionCell.swift
//  Yuumee
//
//  Created by Easy Code on 1/4/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

class InformacionAnfitrionCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    var reference: UIViewController!
    
    var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.addBorder(borderColor: UIColor.rosa, widthBorder: 1)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var addCamera: UIButton = {
        let image        = UIImage(named: "camera")
        let button       = UIButton(type: .system)
        button.tintColor = UIColor.rosa.withAlphaComponent(0.5)
        button.setImage(image, for: .normal)
        return button
    }()
    
    let contentInfo: UIView = {
        let view = UIView()
        return view
    }()
    
    let contentDescription: UIView = {
        let view = UIView()
        return view
    }()
    
    // Info elements
    var nombre: UITextField!
    var apellidos: UITextField!
    var edad: UITextField!
    var direccion: UITextField!
    var email: UITextField!
    var telefono: UITextField!
    var profesion: UITextField!
    var idiomas: UITextField!
    var serviciosExtra: UITextField!
    
     var edadLbl: ArchiaRegularLabel!
     var direccionLbl: ArchiaRegularLabel!
     var emailLbl: ArchiaRegularLabel!
     var telefonoLbl: ArchiaRegularLabel!
     var profesionLbl: ArchiaRegularLabel!
     var idiomasLbl: ArchiaRegularLabel!
     var serviciosExtraLbl: ArchiaRegularLabel!
    
    
    var espacioDegustarLbl: ArchiaRegularLabel!
    
    func getTextFieldForInfo(placeHolder: String = "") -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeHolder
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        return textField
    }
    
    func getLabelForInfo(text: String = "") -> ArchiaRegularLabel {
        let label = ArchiaRegularLabel()
        label.text = text
        label.textColor = UIColor.darkGray
        label.font = UIFont.init(name: "ArchiaRegular",
                                 size: label.font.pointSize)
        return label
    }
    
     /*func getContentRowForInfo() -> UIView {
     let view = UIView()
     return view
     }*/
    
    let guardarPerfil: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Guardar perfil", for: .normal)
        button.titleLabel?.font = UIFont(name: "ArchiaRegular", size: (button.titleLabel?.font.pointSize)!)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: (button.titleLabel?.font.pointSize)!)
        button.backgroundColor = UIColor.verde
        button.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
        return button
    }()
    
    let agregarEvento: UIButton = {
        let size   = CGSize(width: 15, height: 15)
        let image  = UIImage(named: "add")?.imageResize(sizeChange: size)
        let button = UIButton(type: .system)
        button.titleLabel?.font   = UIFont(name: "ArchiaRegular", size: (button.titleLabel?.font.pointSize)!)
        button.titleLabel?.font   = UIFont.boldSystemFont(ofSize: (button.titleLabel?.font.pointSize)!)
        button.backgroundColor    = UIColor.gris
        button.layer.cornerRadius = 5
        button.setTitle("Agregar evento", for: .normal)
        button.setImage(image, for: .normal)
        button.addBorder(borderColor: .gray, widthBorder: 1)
        button.setTitleColor(UIColor.rosa, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        button.tintColor = UIColor.rosa
        return button
    }()
    
    func setUpView() {
        backgroundColor = UIColor.gris
        
        addSubview(avatar)
        addSubview(contentInfo)
        addSubview(contentDescription)
        addSubview(guardarPerfil)
        addSubview(agregarEvento)
        
        // ---------------------------------------------------------------------
        //                 Contenedores principales
        
        let sizeAvatar = ScreenSize.screenWidth / 6
        addConstraintsWithFormat(format: "H:|-[v0(\(sizeAvatar))]-[v1]-|", views: avatar, contentInfo)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: contentDescription)
        addConstraintsWithFormat(format: "H:|[v0]|", views: guardarPerfil)
        addConstraintsWithFormat(format: "H:|-[v0(180)]", views: agregarEvento)
        addConstraintsWithFormat(format: "V:|-[v0(\(sizeAvatar))]", views: avatar)
        addConstraintsWithFormat(format: "V:|-[v0(270)]-[v1(100)]-16-[v2(30)]-16-[v3(30)]",
                                 views: contentInfo, contentDescription, guardarPerfil, agregarEvento)
        // ---------------------------------------------------------------------
        
        
        // Info
        nombre = getTextFieldForInfo(placeHolder: "Nombre")
        nombre.delegate = self
        apellidos = getTextFieldForInfo(placeHolder: "Apellidos")
        apellidos.delegate = self
        edad = getTextFieldForInfo(placeHolder: "Edad")
        edad.delegate = self
        direccion = getTextFieldForInfo(placeHolder: "Dirección")
        direccion.delegate = self
        email = getTextFieldForInfo(placeHolder: "E-mail")
        email.keyboardType = .emailAddress
        email.delegate = self
        telefono = getTextFieldForInfo(placeHolder: "Télefono")
        telefono.delegate = self
        profesion = getTextFieldForInfo(placeHolder: "Profesión")
        profesion.delegate = self
        idiomas = getTextFieldForInfo(placeHolder: "Idiomas")
        idiomas.delegate = self
        serviciosExtra = getTextFieldForInfo(placeHolder: "Servicios extra")
        serviciosExtra.delegate = self
        
        serviciosExtraLbl  = getLabelForInfo(text: "Servicios extra:")
        espacioDegustarLbl = getLabelForInfo(text: "Espacio para degustar")
        edadLbl      = getLabelForInfo(text: "Edad:")
        direccionLbl = getLabelForInfo(text: "Dirección:")
        emailLbl     = getLabelForInfo(text: "E-mail:")
        telefonoLbl  = getLabelForInfo(text: "Télefono:")
        profesionLbl = getLabelForInfo(text: "Profesión:")
        idiomasLbl   = getLabelForInfo(text: "Idiomas:")
        
        // UITextField
        contentInfo.addSubview(nombre)
        contentInfo.addSubview(apellidos)
        contentInfo.addSubview(edad)
        contentInfo.addSubview(direccion)
        contentInfo.addSubview(email)
        contentInfo.addSubview(telefono)
        contentInfo.addSubview(profesion)
        contentInfo.addSubview(idiomas)
        contentInfo.addSubview(serviciosExtra)
        // Labels
        contentInfo.addSubview(edadLbl)
        contentInfo.addSubview(direccionLbl)
        contentInfo.addSubview(emailLbl)
        contentInfo.addSubview(telefonoLbl)
        contentInfo.addSubview(profesionLbl)
        contentInfo.addSubview(idiomasLbl)
        contentInfo.addSubview(serviciosExtraLbl)
        contentInfo.addSubview(espacioDegustarLbl)
        // Constraints
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0(125)]-[v1(125)]", views: nombre, apellidos)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0(100)]-[v1(125)]", views: edadLbl, edad)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0(100)]-[v1(125)]", views: direccionLbl, direccion)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0(100)]-[v1(125)]", views: emailLbl, email)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0(100)]-[v1(125)]", views: telefonoLbl, telefono)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0(100)]-[v1(125)]", views: profesionLbl, profesion)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0(100)]-[v1(125)]", views: idiomasLbl, idiomas)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0]-|", views: espacioDegustarLbl)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0(125)]-[v1(120)]", views: serviciosExtraLbl, serviciosExtra)
        contentInfo.addConstraintsWithFormat(format: "V:|[v0]-[v1]-[v2]-[v3]-[v4]-[v5]-[v6]-[v7]-[v8]",
                                             views: apellidos, edad, direccion, email, telefono, profesion, idiomas, espacioDegustarLbl, serviciosExtra)
        contentInfo.addConstraintsWithFormat(format: "V:|[v0]-[v1]-[v2]-[v3]-[v4]-[v5]-[v6]-[v7]-[v8]",
                                             views: nombre, edadLbl, direccionLbl, emailLbl, telefonoLbl, profesionLbl, idiomasLbl, espacioDegustarLbl, serviciosExtraLbl)
        
        // Descripcion
        let desc = ArchiaBoldLabel()
        desc.text = "Descripción:"
        
        let descripcion = UITextView()
        descripcion.addBorder(borderColor: .gray, widthBorder: 1)
        descripcion.delegate = self
        
        contentDescription.addSubview(desc)
        contentDescription.addSubview(descripcion)
        contentDescription.addConstraintsWithFormat(format: "H:|-[v0]-|", views: desc)
        contentDescription.addConstraintsWithFormat(format: "H:|-[v0]-|", views: descripcion)
        contentDescription.addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1]|", views: desc, descripcion)
        
        // add Button - Avatar
        avatar.layer.cornerRadius = sizeAvatar * 0.5
        avatar.addSubview(addCamera)
        avatar.addConstraintsWithFormat(format: "H:|-[v0]-|", views: addCamera)
        avatar.addConstraintsWithFormat(format: "V:|-[v0]-|", views: addCamera)
        addCamera.addTarget(self, action: #selector(adNewImage) , for: .touchUpInside)
        agregarEvento.addTarget(self, action: #selector(addEvento) , for: .touchUpInside)
    }
    
    @objc func adNewImage() {
        print(" adNewImage ")
    }
    
    
    
    @objc func addEvento() {
        let vc = EventoAnfitrionViewController()
        self.reference.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
} // InformacionAnfitrionCell



// MARK: Delegate para los inputs del teclado

extension InformacionAnfitrionCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension InformacionAnfitrionCell: UITextViewDelegate {
    //
}


