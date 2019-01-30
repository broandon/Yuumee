//
//  BackgroundImageHeader.swift
//  Yuumee
//
//  Created by Easy Code on 1/4/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Photos

class BackgroundImageHeader: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    var reference: UIViewController!
    
    var imageBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
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
    
    
    // UIPicker
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    
    func setUpView(info: Dictionary<String, AnyObject> = [:]) {
        self.info = info
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
        
        if let urlImagePortada = info["imagen_portada"] as? String {
            if !urlImagePortada.isEmpty {
                /*for v in imageBackground.subviews {
                 v.removeFromSuperview()
                 }*/
                let url = URL(string: urlImagePortada)
                imageBackground.af_setImage(withURL: url!)
            }
        }
        addCamera.addTarget(self, action: #selector(addNewBackgroundImageFromCamera), for: .touchUpInside)
        addBackground.addTarget(self, action: #selector(pickPhotoByAlbum), for: .touchUpInside)
    }
    
    
    // MARK: UITextFieldDelegate
    
    /**
     * Metodo para abrir el album de fotos, despues de haber solicitado los permisos necesarios
     *
     */
    @objc func pickPhotoByAlbum() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        reference.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.imagePicker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            /*for v in self.imageBackground.subviews {
                v.removeFromSuperview()
            }*/
            self.imageBackground.image = image
            self.imageBackground.contentMode = .scaleToFill
            
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
                                        let nombreImagen = imageInfo["image_name"]
                                        
                                        print(" nombreImagen ")
                                        print(nombreImagen)
                                        
                                        DispatchQueue.main.async {
                                            self.actualizarDatos(newImage: nombreImagen as! String)
                                        }
                                    }
                                }
                            }
                        }
                        else {
                            /*let atributtes = [NSAttributedString.Key.foregroundColor: .gray,
                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
                             self.adjuntarImagen.attributedPlaceholder = NSAttributedString(string: StringConstants.adjuntarImagen, attributes: atributtes)*/
                            print("Ocurrio un error al procesar la imagen.")
                            Utils.showSimpleAlert(message: "Ocurrio un error al procesar la imagen.", context: self.reference, success: nil)
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
                    Utils.showSimpleAlert(message: encodingError as! String, context: self.reference, success: nil)
                    break
                }
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
    
    
    @objc func addNewBackgroundImageFromCamera() {
        self.pickPhotoByAlbum()
    }
    
    let dataStorage = UserDefaults.standard
    
    var info: Dictionary<String, AnyObject> = [:]
    
    
    @objc func actualizarDatos(newImage: String = "") {
        
        //let urlPortada = URL(string: info["imagen_portada"] as! String)
        
        let oldUrl = URL(string: (info["imagen"] as! String))!
        
        
        let headers: HTTPHeaders = ["Accept": "application/json",
                                    "Content-Type" : "application/x-www-form-urlencoded"]
        
        let parameters: Parameters = ["funcion"    : "updateUserAmphitryon",
                                      "id_user"    : dataStorage.getUserId(),
                                      "first_name" : (info["nombre"] as! String),
                                      "last_name"  : (info["apellidos"] as! String),
                                      "image"      : oldUrl.lastPathComponent,
                                      "image_page" : newImage,
                                      "age"        : (info["fecha_nacimiento"] as! String),
                                      "address"    : (info["direccion"] as! String),
                                      "phone"      : (info["telefono"] as! String),
                                      "profession" : (info["profesion"] as! String),
                                      "languages"  : (info["idiomas"] as! String),
                                      "services"   : (info["servicios_extra"] as! String),
                                      "description" : (info["descripcion"] as! String) ] as [String: Any]
        
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
                            self.reference.present(alert, animated: true, completion: nil)
                            return;
                        }
                        else{
                            let alert = UIAlertController(title: "Ocurrió un error al realizar la petición.", message: "\(statusMsg!)", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.reference.present(alert, animated: true, completion: nil)
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
    
    
    
}





















