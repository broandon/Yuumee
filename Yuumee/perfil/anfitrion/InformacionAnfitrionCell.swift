//
//  InformacionAnfitrionCell.swift
//  Yuumee
//
//  Created by Easy Code on 1/4/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire
import Photos

class InformacionAnfitrionCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    
    var reference: UIViewController!
    
    lazy var avatar: UIImageView = {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(adNewImageFromAvatar))
        tapGesture.numberOfTapsRequired = 1
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        imageView.addBorder(borderColor: UIColor.rosa, widthBorder: 1)
        return imageView
    }()
    
    lazy var addCamera: UIButton = {
        let image        = UIImage(named: "camera")
        let button       = UIButton(type: .system)
        button.tintColor = UIColor.rosa.withAlphaComponent(0.5)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(adNewImageFromCamara) , for: .touchUpInside)
        return button
    }()
    
    let contentInfo: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let contentDescription: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
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
    let descripcionInput = UITextView()
    
    var edadLbl: ArchiaRegularLabel!
    var direccionLbl: ArchiaRegularLabel!
    var emailLbl: ArchiaRegularLabel!
    var telefonoLbl: ArchiaRegularLabel!
    var profesionLbl: ArchiaRegularLabel!
    var idiomasLbl: ArchiaRegularLabel!
    var serviciosExtraLbl: ArchiaRegularLabel!
    
    
    lazy var espacioDegustarLbl: ArchiaRegularLabel = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(espacioParaDegustarEvent))
        tapGesture.numberOfTapsRequired = 1
        let label = ArchiaRegularLabel()
        label.text = "Espacio para degustar"
        label.textColor = UIColor.darkGray
        label.font = UIFont.init(name: "ArchiaRegular", size: label.font.pointSize)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    
    let descripcionAnfitrion: ArchiaBoldLabel = {
        let desc  = ArchiaBoldLabel()
        desc.text = "Descripción:"
        return desc
    }()
    
    func getTextFieldForInfo(placeHolder: String = "") -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeHolder
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        return textField
    }
    
    func getLabelForInfo(text: String = "") -> ArchiaRegularLabel {
        let label  = ArchiaRegularLabel()
        label.text = text
        label.textColor = UIColor.darkGray
        label.font = UIFont.init(name: "ArchiaRegular",
                                 size: label.font.pointSize)
        return label
    }
    
    lazy var guardarPerfil: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Guardar perfil", for: .normal)
        button.titleLabel?.font = UIFont(name: "ArchiaRegular", size: (button.titleLabel?.font.pointSize)!)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: (button.titleLabel?.font.pointSize)!)
        button.backgroundColor = UIColor.verde
        button.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
        button.addTarget(self, action: #selector(guardarPerfilEvent), for: .touchUpInside)
        return button
    }()
    
    lazy var agregarEvento: UIButton = {
        let size   = CGSize(width: 15, height: 15)
        let image  = UIImage(named: "add")?.imageResize(sizeChange: size)
        let insets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        let button = UIButton(type: .system)
        button.titleLabel?.font   = UIFont(name: "ArchiaRegular", size: (button.titleLabel?.font.pointSize)!)
        button.titleLabel?.font   = UIFont.boldSystemFont(ofSize: (button.titleLabel?.font.pointSize)!)
        button.backgroundColor    = UIColor.gris
        button.layer.cornerRadius = 5
        button.tintColor          = UIColor.rosa
        button.imageEdgeInsets    = insets
        button.setTitle("Agregar evento", for: .normal)
        button.setImage(image, for: .normal)
        button.addBorder(borderColor: .gray, widthBorder: 1)
        button.setTitleColor(UIColor.rosa, for: .normal)
        button.addTarget(self, action: #selector(addEvento) , for: .touchUpInside)
        return button
    }()
    
    let rightArrow: UIButton = {
        let image  = UIImage(named: "right_arrow")
        let button = UIButton(type: .system)
        button.tintColor = .darkGray
        button.setImage(image, for: .normal)
        //button.addTarget(self, action: #selector(espacioParaDegustarEvent), for: .touchUpInside)
        return button
    }()
    
    let dataStorage = UserDefaults.standard
    
    func setUpView(info: Dictionary<String, AnyObject> = [:]) {
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
        //imagenPortada = (info["imagen_portada"] as? String)!
        nombre = getTextFieldForInfo(placeHolder: "") // "Nombre"
        nombre.delegate = self
        nombre.text = info["nombre"] as? String
        
        apellidos = getTextFieldForInfo(placeHolder: "") // "Apellidos"
        apellidos.delegate = self
        apellidos.text = info["apellidos"] as? String
        
        edad = getTextFieldForInfo(placeHolder: "") // "Edad"
        edad.delegate = self
        edad.text = info["fecha_nacimiento"] as? String
        
        direccion = getTextFieldForInfo(placeHolder: "") // "Dirección"
        direccion.delegate = self
        direccion.text = info["direccion"] as? String
        
        email = getTextFieldForInfo(placeHolder: "") // "E-mail"
        email.keyboardType = .emailAddress
        email.delegate = self
        email.text = info["email"] as? String
        
        telefono = getTextFieldForInfo(placeHolder: "") // "Télefono"
        telefono.delegate = self
        telefono.text = info["telefono"] as? String
        
        profesion = getTextFieldForInfo(placeHolder: "") // "Profesión"
        profesion.delegate = self
        profesion.text = info["profesion"] as? String
        
        idiomas = getTextFieldForInfo(placeHolder: "") // "Idiomas"
        idiomas.delegate = self
        idiomas.text = info["idiomas"] as? String
        
        serviciosExtra = getTextFieldForInfo(placeHolder: "") // "Servicios extra"
        serviciosExtra.delegate = self
        serviciosExtra.text = info["servicios_extra"] as? String
        
        
        edadLbl      = getLabelForInfo(text: "Edad:")
        direccionLbl = getLabelForInfo(text: "Dirección:")
        emailLbl     = getLabelForInfo(text: "E-mail:")
        telefonoLbl  = getLabelForInfo(text: "Télefono:")
        profesionLbl = getLabelForInfo(text: "Profesión:")
        idiomasLbl   = getLabelForInfo(text: "Idiomas:")
        serviciosExtraLbl = getLabelForInfo(text: "Servicios extra:")
        
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
        contentInfo.addSubview(rightArrow)
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
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0]-[v1(15)]-|", views: espacioDegustarLbl, rightArrow)
        contentInfo.addConstraintsWithFormat(format: "H:|-[v0(125)]-[v1(120)]", views: serviciosExtraLbl, serviciosExtra)
        contentInfo.addConstraintsWithFormat(format: "V:|[v0]-[v1]-[v2]-[v3]-[v4]-[v5]-[v6]-[v7(15)]-[v8]",
                                             views: apellidos, edad, direccion, email, telefono, profesion, idiomas, rightArrow, serviciosExtra)
        contentInfo.addConstraintsWithFormat(format: "V:|[v0]-[v1]-[v2]-[v3]-[v4]-[v5]-[v6]-[v7]-[v8]",
                                             views: nombre, edadLbl, direccionLbl, emailLbl, telefonoLbl, profesionLbl, idiomasLbl, espacioDegustarLbl, serviciosExtraLbl)
        
        descripcionInput.addBorder(borderColor: .gray, widthBorder: 1)
        descripcionInput.delegate = self
        descripcionInput.text = info["descripcion"] as? String
        
        contentDescription.addSubview(descripcionAnfitrion)
        contentDescription.addSubview(descripcionInput)
        contentDescription.addConstraintsWithFormat(format: "H:|-[v0]-|",
                                                    views: descripcionAnfitrion)
        contentDescription.addConstraintsWithFormat(format: "H:|-[v0]-|",
                                                    views: descripcionInput)
        contentDescription.addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1]|",
                                                    views: descripcionAnfitrion, descripcionInput)
        
        // MARK: Avatar
        avatar.layer.cornerRadius = sizeAvatar * 0.5
        let imagen = (info["imagen"] as? String) ?? ""
        if !(imagen.isEmpty) {
            urlAvatar = URL(string: imagen)
            avatar.af_setImage(withURL: urlAvatar!)
        }
        else{
            avatar.centerInView(superView: avatar, container: addCamera,
                                sizeV: 50, sizeH: 50)
        }
        
        // MARK: Portada
        let portada = (info["imagen_portada"] as? String) ?? ""
        if !portada.isEmpty {
            urlPortada = URL(string: portada)
        }
        
    }
    
    var urlPortada: URL!
    var urlAvatar:  URL!
    
    
    /**
     * Guarda solo la informacion del usuario. No las Imagenes
     *
     */
    @objc func guardarPerfilEvent() {
        let userId = dataStorage.getUserId()
        let headers: HTTPHeaders = ["Accept": "application/json",
                                    "Content-Type" : "application/x-www-form-urlencoded"]
        let parameters: Parameters=["funcion"    : "updateUserAmphitryon",
                                    "id_user"    : userId,
                                    "first_name" : nombre.text!,
                                    "last_name"  : apellidos.text!,
                                    "image"      : urlAvatar.lastPathComponent,
                                    "image_page" : urlPortada.lastPathComponent,
                                    "age"        : edad.text!,
                                    "address"    : direccion.text!,
                                    "phone"      : telefono.text!,
                                    "profession" : profesion.text!,
                                    "languages"  : idiomas.text!,
                                    "services"   : serviciosExtra.text!,
                                    "description": descripcionInput.text!] as [String: Any]
        Alamofire.request(BaseURL.baseUrl(), method: .post, parameters: parameters, encoding: ParameterQueryEncoding(), headers: headers).responseJSON
            { (response: DataResponse) in
                switch(response.result) {
                case .success(let value):
                    if let result = value as? Dictionary<String, Any> {
                        let statusMsg = result["status_msg"] as? String
                        let state     = result["state"] as? String
                        if statusMsg == "OK" && state == "200" {
                            Utils.showSimpleAlert(message: "Información actualizada.",
                                                  context: self.reference,success: nil)
                            return;
                            
                        }
                        else{
                            Utils.showSimpleAlert(message: "Ocurrió un error al realizar la petición.",
                                                  context: self.reference, success: nil)
                            return;
                        }
                    }
                    break
                case .failure(let error):
                    //completionHandler(nil, error as NSError?)
                    //print(" error:  ")
                    //print(error)
                    Utils.showSimpleAlert(message: "\(error.localizedDescription)", context: self.reference, success: nil)
                    break
                }
        }
    }
    
    
    
    // UIPicker
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    @objc func adNewImageFromCamara() {
        openGallery()
    }
    
    @objc func adNewImageFromAvatar() {
        openGallery()
    }
    
    func openGallery() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        reference.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @objc func addEvento() {
        let vc = EventoAnfitrionViewController()
        self.reference.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func espacioParaDegustarEvent() {
        let vc = EspaciosDegustarViewController()
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



extension InformacionAnfitrionCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.imagePicker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            /*for v in self.avatar.subviews {
                v.removeFromSuperview()
            }*/
            self.avatar.image = image
            self.avatar.contentMode = .scaleToFill
            
            let headers: HTTPHeaders = [
                "Content-type": "multipart/form-data"
            ]
            Alamofire.upload(
                multipartFormData: { MultipartFormData in
                    MultipartFormData.append("uploadImage".data(using: String.Encoding.utf8)!, withName: "funcion")
                    let imgString = self.convertImageToBase64(image: image)
                    MultipartFormData.append(imgString.data(using: String.Encoding.utf8)!, withName: "image")
            }, to: BaseURL.baseUrl(), method: .post, headers: headers) { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        //print(response)
                        //print(response.result)
                        //print(response.result.value)
                        if let resultUpload = response.result.value as! Dictionary<String, Any>? {
                            if let state = resultUpload["state"] as! String? {
                                if state == "200" {
                                    if let imageInfo = resultUpload["data"] as! Dictionary<String, Any>? {
                                        let nombreImagen = imageInfo["image_name"] as! String
                                        DispatchQueue.main.async {
                                            self.actualizarDatos(newImage: nombreImagen)
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            /*let atributtes = [NSAttributedString.Key.foregroundColor: .gray,
                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
                             self.adjuntarImagen.attributedPlaceholder = NSAttributedString(string: StringConstants.adjuntarImagen, attributes: atributtes)*/
                            Utils.showSimpleAlert(message: "Ocurrio un error al procesar la imagen.",
                                                  context: self.reference, success: nil)
                            return
                        }
                        }.uploadProgress { progress in // main queue by default
                            //self.img1Progress.alpha = 1.0
                            //self.img1Progress.progress = Float(progress.fractionCompleted)
                            // print("Upload Progress: \(progress.fractionCompleted)")
                            /*
                             let atributtes = [NSAttributedString.Key.foregroundColor: .gray ,
                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
                             self.adjuntarImagen.attributedPlaceholder = NSAttributedString(string: "Subiendo...", attributes: atributtes)
                             */
                    }
                case .failure(let encodingError):
                    //print(encodingError)
                    Utils.showSimpleAlert(message: "\(encodingError)", context: self.reference, success: nil)
                    break
                }
            }
        }
        
    } // didFinishPickingMediaWithInfo
    
    
    /**
     *
     *
     */
    @objc func actualizarDatos(newImage: String = "") {
        
        if urlAvatar == nil {
            return;
        }
        
        if newImage.isEmpty {
            return;
        }
        
        let parameters: Parameters=["funcion"    : "updateUserAmphitryon",
                                    "id_user"    : dataStorage.getUserId(),
                                    "first_name" : nombre.text!,
                                    "last_name"  : apellidos.text!,
                                    "image"      : newImage,
                                    "image_page" : urlPortada.lastPathComponent,
                                    "age"        : edad.text!,
                                    "address"    : direccion.text!,
                                    "phone"      : telefono.text!,
                                    "profession" : profesion.text!,
                                    "languages"  : idiomas.text!,
                                    "services"   : serviciosExtra.text!,
                                    "description": descripcionInput.text!] as [String: Any]
        
        let headers: HTTPHeaders = ["Accept": "application/json",
                                    "Content-Type" : "application/x-www-form-urlencoded"]
        Alamofire.request(BaseURL.baseUrl(), method: .post, parameters: parameters, encoding: ParameterQueryEncoding(), headers: headers).responseJSON
            { (response: DataResponse) in
                switch(response.result) {
                case .success(let value):
                    if let result = value as? Dictionary<String, Any> {
                        let statusMsg = result["status_msg"] as? String
                        let state     = result["state"] as? String
                        if statusMsg == "OK" && state == "200" {
                            
                            let newUrlUpdated = "http://easycode.mx/sistema_yuumee/assets/images/perfil_usuarios/\(newImage)"
                            self.urlAvatar = URL(string: newUrlUpdated)
                            
                            Utils.showSimpleAlert(message: "Información actualizada.",
                                                  context: self.reference, success: nil)
                            return;
                        }
                        else{
                            Utils.showSimpleAlert(message: "Ocurrió un error al realizar la petición.",
                                                  context: self.reference, success: nil)
                            return;
                        }
                    }
                    //completionHandler(value as? NSDictionary, nil)
                    break
                case .failure(let error):
                    //completionHandler(nil, error as NSError?)
                    //print(" error:  ")
                    //print(error)
                    break
                }
        }
    }
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:  true, completion: nil)
    }
    
    
    //
    // Convert String to base64
    //
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.jpegData(compressionQuality: 0.0)
        let base64String = imageData?.base64EncodedString(options: .lineLength64Characters)
        return base64String!
    }
    
    
    func isUrlValidate(urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
}




