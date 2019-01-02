//
//  PerfilAnfitrionViewController.swift
//  Yuumee
//
//  Created by Easy Code on 1/2/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

class PerfilAnfitrionViewController: BaseViewController {
    
    let informacionAnfitrionCell = "InformacionAnfitrionCell"
    
    let backgroundImageId = "backgroundImageId"
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView() // frame: CGRect.zero, style: .grouped
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.register(BackgroundImageHeader.self, forCellReuseIdentifier: backgroundImageId)
        tableView.register(InformacionAnfitrionCell.self, forCellReuseIdentifier: informacionAnfitrionCell)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.gris
        return tableView
    }()
    
    
    let secciones = ["background_image", "info"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //mainView.backgroundColor = UIColor.gris
        
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
    }
   
}



extension PerfilAnfitrionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = secciones[indexPath.row]
        
        if section == "background_image" {
            let cell = tableView.dequeueReusableCell(withIdentifier: backgroundImageId, for: indexPath)
            if let cell = cell as? BackgroundImageHeader {
                cell.selectionStyle = .none
                cell.setUpView()
                return cell
            }
        }
        
        if section == "info" {
            let cell = tableView.dequeueReusableCell(withIdentifier: informacionAnfitrionCell, for: indexPath)
            if let cell = cell as? InformacionAnfitrionCell {
                cell.selectionStyle = .none
                cell.setUpView()
                return cell
            }
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        cell.addBorder()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section = secciones[indexPath.row]
        
        if section == "background_image" {
            return ScreenSize.screenWidth / 2
        }
        
        if section == "info" {
            return ScreenSize.screenWidth
        }
        
        return UITableView.automaticDimension
    }
    
    
}





class BackgroundImageHeader: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    var imageBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
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
    
    func setUpView() {
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




class InformacionAnfitrionCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    
    var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.addBorder(borderColor: UIColor.rosa, widthBorder: 1)
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
    var edad: UITextField!
    var direccion: UITextField!
    var email: UITextField!
    var telefono: UITextField!
    var profesion: UITextField!
    var idiomas: UITextField!
    var serviciosExtra: UITextField!
    /*
    var edadLbl: ArchiaRegularLabel!
    var direccionLbl: ArchiaRegularLabel!
    var emailLbl: ArchiaRegularLabel!
    var telefonoLbl: ArchiaRegularLabel!
    var profesionLbl: ArchiaRegularLabel!
    var idiomasLbl: ArchiaRegularLabel!
    var serviciosExtraLbl: ArchiaRegularLabel!
    */
    
    var espacioDegustarLbl: ArchiaRegularLabel!
    
    func getTextFieldForInfo(placeHolder: String = "") -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeHolder
        return textField
    }
    
    func getLabelForInfo(text: String = "") -> ArchiaRegularLabel {
        let label = ArchiaRegularLabel()
        label.text = text
        return label
    }
    
    /*
    func getContentRowForInfo() -> UIView {
        let view = UIView()
        return view
    }*/
    
    
    let guardarPerfil: UIButton = {
        let button = UIButton()
        button.setTitle("Guardar perfil", for: .normal)
        // self.font = UIFont(name: "ArchiaRegular", size: self.font.pointSize)
        //self.font = UIFont.boldSystemFont(ofSize: self.font.pointSize)
        button.titleLabel?.font = UIFont(name: "ArchiaRegular", size: (button.titleLabel?.font.pointSize)!)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: (button.titleLabel?.font.pointSize)!)
        button.backgroundColor = UIColor.verde
        return button
    }()
    
    func setUpView() {
        backgroundColor = UIColor.gris
        
        addSubview(avatar)
        addSubview(contentInfo)
        addSubview(contentDescription)
        
        let sizeAvatar = ScreenSize.screenWidth / 4
        addConstraintsWithFormat(format: "H:|-[v0(\(sizeAvatar))]-[v1]-|", views: avatar, contentInfo)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: contentDescription)
        addConstraintsWithFormat(format: "V:|-[v0(\(sizeAvatar))]", views: avatar)
        addConstraintsWithFormat(format: "V:|-[v0]-[v1(100)]-|", views: contentInfo, contentDescription)
        
        // Info
        nombre = getTextFieldForInfo(placeHolder: "Nombre completo")
        edad = getTextFieldForInfo(placeHolder: "Edad")
        direccion = getTextFieldForInfo(placeHolder: "Dirección")
        email = getTextFieldForInfo(placeHolder: "E-mail")
        telefono = getTextFieldForInfo(placeHolder: "Télefono")
        profesion = getTextFieldForInfo(placeHolder: "Profesión")
        idiomas = getTextFieldForInfo(placeHolder: "Idiomas")
        serviciosExtra = getTextFieldForInfo(placeHolder: "Servicios extra")
        /*
        edadLbl = getLabelForInfo(text: "Edad:")
        direccionLbl = getLabelForInfo(text: "Dirección:")
        emailLbl = getLabelForInfo(text: "E-mail:")
        telefonoLbl = getLabelForInfo(text: "Télefono:")
        profesionLbl = getLabelForInfo(text: "Profesión:")
        idiomasLbl = getLabelForInfo(text: "Idiomas:")
        serviciosExtraLbl = getLabelForInfo(text: "Servicios extra:")
        */
        espacioDegustarLbl = getLabelForInfo(text: "Espacio para degustar")
        contentInfo.addSubview(nombre)
        contentInfo.addSubview(edad)
        contentInfo.addSubview(direccion)
        contentInfo.addSubview(email)
        contentInfo.addSubview(telefono)
        contentInfo.addSubview(profesion)
        contentInfo.addSubview(idiomas)
        contentInfo.addSubview(serviciosExtra)
        /*
        contentInfo.addSubview(edadLbl)
        contentInfo.addSubview(direccionLbl)
        contentInfo.addSubview(emailLbl)
        contentInfo.addSubview(telefonoLbl)
        contentInfo.addSubview(profesionLbl)
        contentInfo.addSubview(idiomasLbl)
        contentInfo.addSubview(serviciosExtraLbl)
        */
        contentInfo.addSubview(espacioDegustarLbl)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0]-|", views: nombre)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0]-|", views: edad)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0]-|", views: direccion)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0]-|", views: email)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0]-|", views: telefono)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0]-|", views: profesion)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0]-|", views: idiomas)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0]-|", views: espacioDegustarLbl)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0]-|", views: serviciosExtra)
        contentInfo.addConstraintsWithFormat(format: "V:|[v0]-[v1]-[v2]-[v3]-[v4]-[v5]-[v6]-[v7]-[v8]-|",
                                             views: nombre, edad, direccion, email, telefono, profesion, idiomas, espacioDegustarLbl, serviciosExtra)
        
        
        // Descripcion
        let desc = ArchiaBoldLabel()
        desc.text = "Descripción"
        
        let descripcion = UITextView()
        descripcion.addBorder(borderColor: .gray, widthBorder: 1)
        
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
        
    }
    
    @objc func adNewImage() {
        print(" adNewImage ")
    }
    
}




