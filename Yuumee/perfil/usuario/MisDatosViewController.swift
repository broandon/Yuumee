//
//  MisDatosViewController.swift
//  Yuumee
//
//  Created by Easy Code on 1/23/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MisDatosViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let defaultReuseID = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultReuseID)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let secciones = ["avatar", "nombre", "apellidos", "telefono", "guardar"] // "email"
    
    lazy var closeIcon: UIBarButtonItem = {
        let size = CGSize(width: 24.0, height: 24.0)
        let image = UIImage(named: "back")?.imageResize(sizeChange: size)
        let b = UIButton(type: .system)
        b.setTitle("Volver" , for: .normal)
        b.setImage(image, for: .normal)
        b.addTarget(self, action: #selector(close), for: .touchUpInside)
        b.tintColor = UIColor.white
        b.layer.cornerRadius = 5
        b.imageView?.contentMode = .scaleAspectFit
        b.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let buttonItem = UIBarButtonItem(customView: b)
        return buttonItem
    }()
    
    let dataStorage = UserDefaults.standard
    
    // UIPicker
    
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        mainView.backgroundColor = .white
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        self.navigationItem.leftBarButtonItem = closeIcon
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let headers: HTTPHeaders = ["Accept": "application/json",
                                    "Content-Type" : "application/x-www-form-urlencoded"]
        let userId = dataStorage.getUserId()
        let parameters: Parameters = ["funcion"  : "getUserInfo",
                                      "id_user"  : userId] as [String: Any]
        Alamofire.request(BaseURL.baseUrl(), method: .post, parameters: parameters, encoding: ParameterQueryEncoding(), headers: headers).responseJSON
            { (response: DataResponse) in
                switch(response.result) {
                case .success(let value):
                    if let result = value as? Dictionary<String, Any> {
                        
                        let statusMsg = result["status_msg"] as? String
                        let state     = result["state"] as? String
                        
                        if statusMsg == "OK" && state == "200" {
                            
                            if let info = result["data"] as? Dictionary<String, AnyObject> {
                                let id        = info["info"]!["id"] as? String
                                let apellidos = info["info"]!["apellidos"] as? String
                                let imagen    = info["info"]!["imagen"] as? String
                                let nombre    = info["info"]!["nombre"] as? String
                                let telefono  = info["info"]!["telefono"] as? String
                                
                                self.lastImagedownloaded = URL(string: imagen!)
                                self.idDownloaded        = id!
                                
                                self.nombre.text    = nombre
                                self.apellidos.text = apellidos
                                self.telefono.text  = telefono
                                let url = URL(string: imagen!)
                                self.imageViewAvatar.af_setImage(withURL: url!)
                                
                            }
                            
                        }
                        else{
                            let alert = UIAlertController(title: "Ocurrió un error al realizar la petición.", message: "\(statusMsg!)", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
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
    
    
    @objc func updateDatos() {
        let nameImage         = lastImagedownloaded.lastPathComponent
        let nameToUpdate      = nombre.text!
        let telephoneToUpdate = telefono.text!
        let apellidosToUpdate = apellidos.text!
        let headers: HTTPHeaders = ["Accept": "application/json",
                                    "Content-Type" : "application/x-www-form-urlencoded"]
        let parameters: Parameters = ["funcion"    : "updateUser",
                                      "id_user"    : idDownloaded,
                                      "first_name" : nameToUpdate,
                                      "last_name"  : apellidosToUpdate,
                                      "phone"      : telephoneToUpdate,
                                      "image"      : nameImage] as [String: Any]
        Alamofire.request(BaseURL.baseUrl(), method: .post, parameters: parameters, encoding: ParameterQueryEncoding(), headers: headers).responseJSON
            { (response: DataResponse) in
                switch(response.result) {
                case .success(let value):
                    if let result = value as? Dictionary<String, Any> {
                        
                        let statusMsg = result["status_msg"] as? String
                        let state     = result["state"] as? String
                        
                        if statusMsg == "OK" && state == "200" {
                            let alert = UIAlertController(title: "Información actualizada.", message: "",
                                                          preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,
                                                          handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return;
                        }
                        else{
                            let alert = UIAlertController(title: "Ocurrió un error al realizar la petición.",
                                                          message: "\(statusMsg!)",
                                                          preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
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
    
    @objc func actualizarDatos(newImage: String = "") {
        let nameImage         = newImage.isEmpty ? lastImagedownloaded.lastPathComponent : newImage
        let nameToUpdate      = nombre.text!
        let telephoneToUpdate = telefono.text!
        let apellidosToUpdate = apellidos.text!
        let headers: HTTPHeaders = ["Accept": "application/json",
                                    "Content-Type" : "application/x-www-form-urlencoded"]
        let parameters: Parameters = ["funcion"    : "updateUser",
                                      "id_user"    : idDownloaded,
                                      "first_name" : nameToUpdate,
                                      "last_name"  : apellidosToUpdate,
                                      "phone"      : telephoneToUpdate,
                                      "image"      : nameImage] as [String: Any]
        Alamofire.request(BaseURL.baseUrl(), method: .post, parameters: parameters, encoding: ParameterQueryEncoding(), headers: headers).responseJSON
            { (response: DataResponse) in
                switch(response.result) {
                case .success(let value):
                    if let result = value as? Dictionary<String, Any> {
                        
                        let statusMsg = result["status_msg"] as? String
                        let state     = result["state"] as? String
                        
                        if statusMsg == "OK" && state == "200" {
                            
                            let alert = UIAlertController(title: "Información actualizada.", message: "", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return;

                        }
                        else{
                            let alert = UIAlertController(title: "Ocurrió un error al realizar la petición.", message: "\(statusMsg!)", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
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
    
    var lastImagedownloaded: URL!
    var idDownloaded: String = ""
    
    var imageViewAvatar: UIImageView!
    let nombre    = UITextField()
    let apellidos = UITextField()
    let telefono  = UITextField()
    let email     = UITextField()
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // UITableView: Datasource & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseID, for: indexPath)
        cell.selectionStyle  = .none
        cell.backgroundColor = .clear
        let seccion = secciones[indexPath.row]
        
        if seccion == "avatar" {
            let avatarImg = UIImage(named: "avatar")
            imageViewAvatar = UIImageView(image: avatarImg)
            imageViewAvatar.layer.cornerRadius = 35
            imageViewAvatar.contentMode = .scaleAspectFit
            imageViewAvatar.backgroundColor = .white
            imageViewAvatar.clipsToBounds = true
            cell.addSubview(imageViewAvatar)
            cell.centerInView(superView: cell, container: imageViewAvatar, sizeV: 70.0, sizeH: 70.0)
            imageViewAvatar.isUserInteractionEnabled = true
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(pickPhotoByAlbum))
            tapGest.numberOfTapsRequired = 1
            imageViewAvatar.addGestureRecognizer(tapGest)
            return cell
        }
        
        if seccion == "nombre" {
            let nombreLbl = ArchiaRegularLabel()
            nombreLbl.textColor = UIColor.darkGray
            nombreLbl.text = "Nombre"
            nombre.delegate = self
            nombre.font = UIFont.init(name: "MyriadPro-Bold", size: (nombre.font?.pointSize)!)
            nombre.textColor = UIColor.gray
            nombre.returnKeyType = .done
            nombre.backgroundColor = .gris
            cell.addSubview(nombre)
            cell.addSubview(nombreLbl)
            cell.addConstraintsWithFormat(format: "H:|-16-[v0(80)]-[v1]-16-|", views: nombreLbl, nombre)
            cell.addConstraintsWithFormat(format: "V:|-[v0(35)]", views: nombreLbl)
            cell.addConstraintsWithFormat(format: "V:|-[v0(35)]", views: nombre)
        }
        
        if seccion == "apellidos" {
            let apellidosLbl = ArchiaRegularLabel()
            apellidosLbl.textColor = UIColor.darkGray
            apellidosLbl.text = "Apellidos"
            apellidos.delegate = self
            apellidos.font = UIFont.init(name: "MyriadPro-Bold", size: (apellidos.font?.pointSize)!)
            apellidos.textColor = UIColor.gray
            apellidos.returnKeyType = .done
            apellidos.backgroundColor = .gris
            cell.addSubview(apellidosLbl)
            cell.addSubview(apellidos)
            cell.addConstraintsWithFormat(format: "H:|-16-[v0(80)]-[v1]-16-|", views: apellidosLbl, apellidos)
            cell.addConstraintsWithFormat(format: "V:|-[v0(35)]", views: apellidosLbl)
            cell.addConstraintsWithFormat(format: "V:|-[v0(35)]", views: apellidos)
        }
        
        if seccion == "telefono" {
            let telefonoLbl = ArchiaRegularLabel()
            telefonoLbl.textColor = UIColor.darkGray
            telefonoLbl.text = "Teléfono"
            telefono.delegate = self
            telefono.font = UIFont.init(name: "MyriadPro-Bold", size: (telefono.font?.pointSize)!)
            telefono.textColor = UIColor.gray
            telefono.returnKeyType = .done
            telefono.keyboardType = .numberPad
            telefono.backgroundColor = .gris
            cell.addSubview(telefonoLbl)
            cell.addSubview(telefono)
            cell.addConstraintsWithFormat(format: "H:|-16-[v0(80)]-[v1]-16-|", views: telefonoLbl, telefono)
            cell.addConstraintsWithFormat(format: "V:|-[v0(35)]", views: telefonoLbl)
            cell.addConstraintsWithFormat(format: "V:|-[v0(35)]", views: telefono)
            
        }
        
        if seccion == "guardar" {
            let guardar = UIButton(type: .system)
            guardar.clipsToBounds = true
            guardar.setTitle("Guardar", for: .normal)
            guardar.backgroundColor = UIColor.verde
            guardar.addTarget(self, action: #selector(updateDatos) , for: .touchUpInside)
            guardar.setTitleColor(UIColor.white, for: .normal)
            guardar.layer.cornerRadius = 10
            cell.addSubview(guardar)
            
            cell.centerInView(superView: cell, container: guardar,
                              sizeV: 40, sizeH: ScreenSize.screenWidth - 32)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let seccion = secciones[indexPath.row]
        if seccion == "nombre" || seccion == "telefono" || seccion == "apellidos" {
            return 60
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Mis datos"
        label.font = UIFont.init(name: "MyriadPro-Regular", size: (label.font.pointSize))
        label.textColor = UIColor.white
        label.textAlignment = .center
        let view = UIView()
        view.backgroundColor = UIColor.azul
        view.addSubview(label)
        view.centerInView(superView: view, container: label, sizeV: 25, sizeH: 100)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    // UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == telefono {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 10
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    // MARK: UITextFieldDelegate
    
    /**
     * Metodo para abrir el album de fotos, despues de haber solicitado los permisos necesarios
     *
     */
    @objc func pickPhotoByAlbum() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imagePicker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.imageViewAvatar.image       = image
            self.imageViewAvatar.contentMode = .scaleAspectFill
            
            // -----------------------------------------------------------------
            let headers: HTTPHeaders = [
                "Content-type": "multipart/form-data"
            ]
            Alamofire.upload(
                multipartFormData: { MultipartFormData in
                    MultipartFormData.append("uploadImage".data(using: String.Encoding.utf8)!, withName: "funcion")
                    let imgString = self.convertImageToBase64(image: image)
                    MultipartFormData.append(imgString.data(using: String.Encoding.utf8)!, withName: "image")
                    //MultipartFormData.append(UIImagePNGRepresentation(pickedImage)! , withName: "image", fileName: lastPathComponent, mimeType: "image/png")
                    //MultipartFormData.append(UIImageJPEGRepresentation(pickedImage, 1)!, withName: "image", fileName: lastPathComponent, mimeType: mime)
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
                                        let nombreImagen = imageInfo["image_name"]
                                        DispatchQueue.main.async {
                                            self.actualizarDatos(newImage: nombreImagen as! String)
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            // print("Ocurrio un error al procesar la imagen.")
                            Utils.showSimpleAlert(message: "Ocurrio un error al procesar la imagen.", context: self, success: nil)
                            return
                            }
                        }.uploadProgress { progress in // main queue by default
                            //self.img1Progress.alpha = 1.0
                            //self.img1Progress.progress = Float(progress.fractionCompleted)
                            // print("Upload Progress: \(progress.fractionCompleted)")
                            /*let atributtes = [NSAttributedString.Key.foregroundColor: .gray ,
                                              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
                            self.adjuntarImagen.attributedPlaceholder = NSAttributedString(string: "Subiendo...", attributes: atributtes)*/
                    }
                case .failure(let encodingError):
                    // print(encodingError)
                    Utils.showSimpleAlert(message: encodingError as! String, context: self, success: nil)
                    break
                }
                
            }
            // -----------------------------------------------------------------
            
            
        }
        
    }
    
    //
    // Convert String to base64
    func convertImageToBase64(image: UIImage) -> String {
        let imageData    = image.jpegData(compressionQuality: 0.0)
        let base64String = imageData?.base64EncodedString(options: .lineLength64Characters) //base64EncodedStringWithOptions(.allZeros
        return base64String!
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:  true, completion: nil)
    }
    
    
}

/*
extension UIImage {
    
    /// EZSE: Returns base64 string
    public var base64: String {
        return self.jpegData(compressionQuality: 1.0)!.base64EncodedString()
    }
}
*/
