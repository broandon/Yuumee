//
//  EventoAnfitrionViewController.swift
//  Yuumee
//
//  Created by Easy Code on 1/4/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Photos

class EventoAnfitrionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource,  UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let backgroundImageId  = "backgroundImageId"
    let productoExtraCell  = "productoExtraCell"
    let fechasCell         = "FechasCell"
    let detallesEventoCell = "DetallesEventoCell"
    let horarioCell        = "HorarioCell"
    let comidaCell         = "ComidaCell"
    let categoriaCell      = "CategoriaCell"
    let defaultReuseId     = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.register(CategoriaCell.self, forCellReuseIdentifier: categoriaCell)
        tableView.register(ComidaCell.self,    forCellReuseIdentifier: comidaCell)
        tableView.register(HorarioCell.self,   forCellReuseIdentifier: horarioCell)
        tableView.register(FechasCell.self,    forCellReuseIdentifier: fechasCell)
        tableView.register(DetallesEventoCell.self, forCellReuseIdentifier: detallesEventoCell)
        tableView.register(ProductoExtraCell.self, forCellReuseIdentifier: productoExtraCell)
        tableView.register(BackgroundImageHeader.self, forCellReuseIdentifier: backgroundImageId)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle  = .none
        tableView.backgroundColor = UIColor.gris
        return tableView
    }()
    
    let secciones = ["background_image", "categoria", "comida", "horario",
                     "detalles_evento", "fechas_evento", "producto_extra", "total"]
    
    let dataStorage = UserDefaults.standard
    
    let notifier = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Reemplaza el titulo del back qu eviene por Default
        self.navigationController?.navigationBar.topItem?.title = "Evento"
        //self.hideKeyboardWhenTappedAround()
        
        notifier.addObserver(self, selector: #selector(keyboardWillAppear),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        notifier.addObserver(self, selector: #selector(keyboardWillDisappear),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)
        
        mainView.backgroundColor = .white
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
        dataStorage.setDescripcionEvento(desc: "")
        dataStorage.setMenuEvento(menu: "")
        dataStorage.setCostoMenuEvento(costo: "")
        dataStorage.setBebidasEvento(bebida: "")
        dataStorage.setCostoBebidasEvento(costo: "")
        dataStorage.setPostresEvento(postre: "")
        dataStorage.setPostresEventoCosto(costo: "")
        
    }
    
    
    
    // -------------------------------------------------------------------------
    /**
     * Se mostrará el Keyboard
     *
     */
    @objc func keyboardWillAppear(notification: NSNotification) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        mainView.addGestureRecognizer(tap)
        // DESPLAZAMIENTO QUE SE LE HACE AL TABLEVIEW AL MOSTRARSE EL KEYBOARD
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    /**
     * Se Oculta el Keyboard
     *
     */
    @objc func keyboardWillDisappear(notification: NSNotification){
        view.endEditing(true)
        mainView.gestureRecognizers?.removeAll()
        // REGRESA EL TABLEVIEW A LA NORMALIDAD CUANDO DESAPARECE EL KEYBOARD
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    // -------------------------------------------------------------------------
    
    
    
    // MARK: Data Table
    var imageBackground: UIImageView = {
        let imageView             = UIImageView()
        imageView.contentMode     = .scaleToFill
        imageView.backgroundColor = .white
        imageView.isUserInteractionEnabled = true
        imageView.addBorder(borderColor: UIColor.gray, widthBorder: 1)
        return imageView
    }()
    var addCamera: UIButton = {
        let button = UIButton(type: .system)
        let image: UIImage = UIImage(named: "camera")!
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.rosa.withAlphaComponent(0.5)
        return button
    }()
    var addBackground: UIButton = {
        let button = UIButton(type: .system)
        let image: UIImage = UIImage(named: "add")!
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.rosa.withAlphaComponent(0.5)
        return button
    }()
    // UIPicker
    lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
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
            for v in self.imageBackground.subviews {
                v.removeFromSuperview()
            }
            self.imageBackground.image = image
            self.imageBackground.contentMode = .scaleToFill
            let headers: HTTPHeaders = [
                "Content-type": "multipart/form-data"
            ]
            Alamofire.upload(
                multipartFormData: { MultipartFormData in
                    MultipartFormData.append("uploadImage_event".data(using: String.Encoding.utf8)!, withName: "funcion")
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
                                        self.dataStorage.setImagenEvent(hora: nombreImagen as! String)
                                    }
                                }
                            }
                        }
                        else {
                            /*let atributtes = [NSAttributedString.Key.foregroundColor: .gray,
                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
                             self.adjuntarImagen.attributedPlaceholder = NSAttributedString(string: StringConstants.adjuntarImagen, attributes: atributtes)*/
                            //print("Ocurrio un error al procesar la imagen.")
                            Utils.showSimpleAlert(message: "Ocurrio un error al procesar la imagen.",
                                                  context: self, success: nil)
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
                    Utils.showSimpleAlert(message: encodingError as! String,
                                          context: self, success: nil)
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
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let seccion = secciones[indexPath.row]
        if seccion == "background_image" {
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
            cell.selectionStyle = .none
            cell.addSubview(imageBackground)
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: imageBackground)
            cell.addConstraintsWithFormat(format: "V:|-[v0]-|", views: imageBackground)
            imageBackground.addSubview(addCamera)
            imageBackground.addSubview(addBackground)
            imageBackground.addConstraintsWithFormat(format: "H:|-[v0]-|", views: addCamera)
            imageBackground.addConstraintsWithFormat(format: "V:|-[v0]-|", views: addCamera)
            imageBackground.addConstraintsWithFormat(format: "H:[v0]-|", views: addBackground)
            imageBackground.addConstraintsWithFormat(format: "V:[v0]-|", views: addBackground)
            addCamera.addTarget(self, action: #selector(addNewBackgroundImageFromCamera), for: .touchUpInside)
            addBackground.addTarget(self, action: #selector(pickPhotoByAlbum), for: .touchUpInside)
            return cell
        }
        if seccion == "categoria" {
            let cell = tableView.dequeueReusableCell(withIdentifier: categoriaCell, for: indexPath)
            if let cell = cell as? CategoriaCell {
                cell.selectionStyle = .none
                cell.reference = self
                cell.setUpView()
                return cell
            }
        }
        if seccion == "comida" {
            let cell = tableView.dequeueReusableCell(withIdentifier: comidaCell, for: indexPath)
            if let cell = cell as? ComidaCell {
                cell.selectionStyle = .none
                cell.setUpView()
                return cell
            }
        }
        if seccion == "horario" {
            let cell = tableView.dequeueReusableCell(withIdentifier: horarioCell, for: indexPath)
            if let cell = cell as? HorarioCell {
                cell.selectionStyle = .none
                cell.setUpView()
                return cell
            }
        }
        
        if seccion == "detalles_evento" {
            let cell = tableView.dequeueReusableCell(withIdentifier: detallesEventoCell, for: indexPath)
            if let cell = cell as? DetallesEventoCell {
                cell.selectionStyle = .none
                cell.releaseView()
                cell.setUpView()
                return cell
            }
        }
        if seccion == "fechas_evento" {
            let cell = tableView.dequeueReusableCell(withIdentifier: fechasCell, for: indexPath)
            if let cell = cell as? FechasCell {
                cell.selectionStyle = .none
                cell.setUpView()
                return cell
            }
        }
        
        
        if seccion == "producto_extra" {
            
            /*let cell = tableView.dequeueReusableCell(withIdentifier: productoExtraCell, for: indexPath) as! ProductoExtraCell
            cell.releaseView()
            if cell == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: productoExtraCell, for: indexPath) as! ProductoExtraCell
                cell.selectionStyle = .none
                cell.setUpView()
                return cell
            }
            cell.selectionStyle = .none
            cell.setUpView()
            return cell*/
            
            /*
            var cell: ProductoExtraCell! = tableView.dequeueReusableCell(withIdentifier: productoExtraCell, for: indexPath) as? ProductoExtraCell
            //cell.releaseView()
            if cell == nil {
                cell = tableView.dequeueReusableCell(withIdentifier: productoExtraCell, for: indexPath) as? ProductoExtraCell
            }
            cell.selectionStyle = .none
            cell.setUpView()
            return cell
            */
            
            let cell = tableView.dequeueReusableCell(withIdentifier: productoExtraCell, for: indexPath) // as! ProductoExtraCell
            if let cell = cell as? ProductoExtraCell {
                //cell.releaseView()
                cell.selectionStyle = .none
                cell.setUpView()
                return cell
            }
            
        }
        
        
        if seccion == "total" {
            var costoMenu: String = "0"
            if let textView = mainView.viewWithTag(TAG_COSTO_MENU_EVENT) as? UITextView {
                if !(textView.text!).isEmpty {
                    costoMenu = textView.text!
                }
            }
            else{
                costoMenu = "0"
            }
            var costoBebidas: String = "0"
            if let textView = mainView.viewWithTag(TAG_COSTO_BEBIDAS_EVENT) as? UITextView {
                if !(textView.text!).isEmpty {
                    //costoMenu = textView.text!
                    costoBebidas = textView.text!
                }
            }else{
                costoBebidas = "0"
            }
            var costoPostres: String = "0"
            if let textView = mainView.viewWithTag(TAG_COSTO_POSTRES_EVENT) as? UITextView {
                if !(textView.text!).isEmpty {
                    //costoMenu = textView.text!
                    costoPostres = textView.text!
                }
            }
            else{
                costoPostres = "0"
            }
            let costoMenuInt: Int    = Int(costoMenu)!
            let costoBebidasInt: Int = Int(costoBebidas)!
            let costoPostresInt: Int = Int(costoPostres)!
            let costoTotalInput = costoMenuInt + costoBebidasInt + costoPostresInt
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
            cell.releaseView()
            cell.selectionStyle = .none
            cell.addSubview(personasRecibir)
            cell.addSubview(personasRecibirInput)
            cell.addSubview(guardar)
            let cont: UIView = UIView()
            cont.isUserInteractionEnabled = true
            cell.addSubview(cont)
            cell.addConstraintsWithFormat(format: "H:|-[v0(150)]-[v1]-|", views: personasRecibir, personasRecibirInput)
            cell.addConstraintsWithFormat(format: "H:[v0(120)]-|", views: guardar)
            cell.addConstraintsWithFormat(format: "H:|[v0]|", views: cont)
            cell.addConstraintsWithFormat(format: "V:|-[v0]", views: personasRecibir)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]-[v1(50)]-[v2(40)]",
                                          views: personasRecibirInput, cont, guardar)
            let costoTotal: ArchiaRegularLabel = ArchiaRegularLabel()
            costoTotal.text = "Costo total: $"
            costo.isUserInteractionEnabled = false
            costo.placeholder = "0"
            costo.addBorder(borderColor: .gris, widthBorder: 1.0)
            costo.textAlignment = .center
            costo.text = "\(costoTotalInput)"
            //costo.delegate = self
            costo.keyboardType = .numberPad
            let mx: ArchiaRegularLabel = ArchiaRegularLabel()
            mx.text = ".00 mx"
            cont.addSubview(costoTotal)
            cont.addSubview(costo)
            cont.addSubview(mx)
            cont.addConstraintsWithFormat(format: "H:[v0(110)]-[v1(80)]-[v2(70)]|", views: costoTotal, costo, mx)
            cont.addConstraintsWithFormat(format: "V:|-[v0(25)]", views: costoTotal)
            cont.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: costo)
            cont.addConstraintsWithFormat(format: "V:|-[v0(25)]", views: mx)
            //personasRecibirInput.inputAccessoryView = toolbarPicker
            //personasRecibirInput.inputView = picker
            guardar.addTarget(self, action: #selector(guardarEvento) , for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let seccion = secciones[indexPath.row]
        if seccion == "total" {
            //let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
            if let cell = cell as? UITableViewCell {
                var costoMenu: String = "0"
                if let textView = mainView.viewWithTag(TAG_COSTO_MENU_EVENT) as? UITextView {
                    if !(textView.text!).isEmpty {
                        costoMenu = textView.text!
                    }
                }
                else{
                    costoMenu = "0"
                }
                var costoBebidas: String = "0"
                if let textView = mainView.viewWithTag(TAG_COSTO_BEBIDAS_EVENT) as? UITextView {
                    if !(textView.text!).isEmpty {
                        //costoMenu = textView.text!
                        costoBebidas = textView.text!
                    }
                }else{
                    costoBebidas = "0"
                }
                var costoPostres: String = "0"
                if let textView = mainView.viewWithTag(TAG_COSTO_POSTRES_EVENT) as? UITextView {
                    if !(textView.text!).isEmpty {
                        //costoMenu = textView.text!
                        costoPostres = textView.text!
                    }
                }
                else{
                    costoPostres = "0"
                }
                let costoMenuInt: Int    = Int(costoMenu)!
                let costoBebidasInt: Int = Int(costoBebidas)!
                let costoPostresInt: Int = Int(costoPostres)!
                let costoTotalInput = costoMenuInt + costoBebidasInt + costoPostresInt
                
                cell.releaseView()
                cell.selectionStyle = .none
                cell.addSubview(personasRecibir)
                cell.addSubview(personasRecibirInput)
                cell.addSubview(guardar)
                let cont: UIView = UIView()
                cont.isUserInteractionEnabled = true
                cell.addSubview(cont)
                cell.addConstraintsWithFormat(format: "H:|-[v0(150)]-[v1]-|", views: personasRecibir, personasRecibirInput)
                cell.addConstraintsWithFormat(format: "H:[v0(120)]-|", views: guardar)
                cell.addConstraintsWithFormat(format: "H:|[v0]|", views: cont)
                cell.addConstraintsWithFormat(format: "V:|-[v0]", views: personasRecibir)
                cell.addConstraintsWithFormat(format: "V:|-[v0(30)]-[v1(50)]-[v2(40)]",
                                              views: personasRecibirInput, cont, guardar)
                let costoTotal: ArchiaRegularLabel = ArchiaRegularLabel()
                costoTotal.text = "Costo total: $"
                costo.isUserInteractionEnabled = false
                costo.placeholder = "0"
                costo.addBorder(borderColor: .gris, widthBorder: 1.0)
                costo.textAlignment = .center
                //costo.delegate = self
                costo.keyboardType = .numberPad
                costo.text = "\(costoTotalInput)"
                let mx: ArchiaRegularLabel = ArchiaRegularLabel()
                mx.text = ".00 mx"
                cont.addSubview(costoTotal)
                cont.addSubview(costo)
                cont.addSubview(mx)
                cont.addConstraintsWithFormat(format: "H:[v0(110)]-[v1(80)]-[v2(70)]|", views: costoTotal, costo, mx)
                cont.addConstraintsWithFormat(format: "V:|-[v0(25)]", views: costoTotal)
                cont.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: costo)
                cont.addConstraintsWithFormat(format: "V:|-[v0(25)]", views: mx)
                guardar.addTarget(self, action: #selector(guardarEvento) , for: .touchUpInside)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let seccion = secciones[indexPath.row]
        if seccion == "total" {
            //let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
            if let cell = cell as? UITableViewCell {
                var costoMenu: String = "0"
                if let textView = mainView.viewWithTag(TAG_COSTO_MENU_EVENT) as? UITextView {
                    if !(textView.text!).isEmpty {
                        costoMenu = textView.text!
                    }
                }
                else{
                    costoMenu = "0"
                }
                var costoBebidas: String = "0"
                if let textView = mainView.viewWithTag(TAG_COSTO_BEBIDAS_EVENT) as? UITextView {
                    if !(textView.text!).isEmpty {
                        //costoMenu = textView.text!
                        costoBebidas = textView.text!
                    }
                }else{
                    costoBebidas = "0"
                }
                var costoPostres: String = "0"
                if let textView = mainView.viewWithTag(TAG_COSTO_POSTRES_EVENT) as? UITextView {
                    if !(textView.text!).isEmpty {
                        //costoMenu = textView.text!
                        costoPostres = textView.text!
                    }
                }
                else{
                    costoPostres = "0"
                }
                let costoMenuInt: Int    = Int(costoMenu)!
                let costoBebidasInt: Int = Int(costoBebidas)!
                let costoPostresInt: Int = Int(costoPostres)!
                let costoTotalInput = costoMenuInt + costoBebidasInt + costoPostresInt
                
                cell.releaseView()
                cell.selectionStyle = .none
                cell.addSubview(personasRecibir)
                cell.addSubview(personasRecibirInput)
                cell.addSubview(guardar)
                let cont: UIView = UIView()
                cont.isUserInteractionEnabled = true
                cell.addSubview(cont)
                cell.addConstraintsWithFormat(format: "H:|-[v0(150)]-[v1]-|", views: personasRecibir, personasRecibirInput)
                cell.addConstraintsWithFormat(format: "H:[v0(120)]-|", views: guardar)
                cell.addConstraintsWithFormat(format: "H:|[v0]|", views: cont)
                cell.addConstraintsWithFormat(format: "V:|-[v0]", views: personasRecibir)
                cell.addConstraintsWithFormat(format: "V:|-[v0(30)]-[v1(50)]-[v2(40)]",
                                              views: personasRecibirInput, cont, guardar)
                let costoTotal: ArchiaRegularLabel = ArchiaRegularLabel()
                costoTotal.text = "Costo total: $"
                costo.isUserInteractionEnabled = false
                costo.placeholder = "0"
                costo.addBorder(borderColor: .gris, widthBorder: 1.0)
                costo.textAlignment = .center
                //costo.delegate = self
                costo.keyboardType = .numberPad
                costo.text = "\(costoTotalInput)"
                let mx: ArchiaRegularLabel = ArchiaRegularLabel()
                mx.text = ".00 mx"
                cont.addSubview(costoTotal)
                cont.addSubview(costo)
                cont.addSubview(mx)
                cont.addConstraintsWithFormat(format: "H:[v0(110)]-[v1(80)]-[v2(70)]|", views: costoTotal, costo, mx)
                cont.addConstraintsWithFormat(format: "V:|-[v0(25)]", views: costoTotal)
                cont.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: costo)
                cont.addConstraintsWithFormat(format: "V:|-[v0(25)]", views: mx)
                guardar.addTarget(self, action: #selector(guardarEvento) , for: .touchUpInside)
            }
        }
        
        
        
    }
    
    
    
    
    
    
    let costo: UITextField = UITextField()
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == personasRecibirInput {
            personasRecibirInput.resignFirstResponder()
            
            let vc = NumeroInvitadosViewController()
            vc.delegate = self
            let popVC = UINavigationController(rootViewController: vc)
            popVC.modalPresentationStyle = .popover
            let popOverVC = popVC.popoverPresentationController
            popOverVC?.permittedArrowDirections = .any
            popOverVC?.delegate   = self
            popOverVC?.sourceView = personasRecibirInput
            let midX = self.personasRecibirInput.bounds.midX
            let minY = self.personasRecibirInput.bounds.minY
            popOverVC?.sourceRect = CGRect(x: midX, y: minY, width: 0, height: 0)
            let widthModal = (ScreenSize.screenWidth / 2) // - 16
            let heightModal = (ScreenSize.screenWidth / 2)
            popVC.preferredContentSize = CGSize(width: widthModal, height: heightModal)
            self.present(popVC, animated: true)
        }
    }
    
    
    // # de personas a recibir...
    let personasRecibir: ArchiaBoldLabel = {
        let label  = ArchiaBoldLabel()
        label.text = "Personas a recibir:"
        label.textColor = .darkGray
        return label
    }()
    lazy var personasRecibirInput: UITextField = {
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldGetIn(_:)))
        //tapGesture.numberOfTapsRequired = 1
        let textField = UITextField()
        textField.delegate = self
        textField.textAlignment = .center
        textField.addBorder(borderColor: .gris, widthBorder: 1)
        //textField.addTarget(self, action: #selector(textFieldGetIn(_:)), for: .touchUpInside)
        return textField
    }()
    let guardar: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font   = UIFont(name: "ArchiaRegular", size: (button.titleLabel?.font.pointSize)!)
        button.titleLabel?.font   = UIFont.boldSystemFont(ofSize: (button.titleLabel?.font.pointSize)!)
        button.backgroundColor    = UIColor.white
        button.layer.cornerRadius = 5
        button.tintColor          = UIColor.rosa
        button.setTitle("Guardar", for: .normal)
        button.addBorder(borderColor: .azul, widthBorder: 2)
        button.setTitleColor(UIColor.rosa, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        return button
    }()
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let seccion = secciones[indexPath.row]
        if seccion == "background_image" {
            return ScreenSize.screenWidth / 2
        }
        if seccion == "categoria" {
            return 150
        }
        if seccion == "comida" {
            return 70
        }
        if seccion == "horario" {
            return 120
        }
        if seccion == "detalles_evento" {
            return ScreenSize.screenHeight
        }
        if seccion == "fechas_evento" {
            return ScreenSize.screenWidth
        }
        if seccion == "producto_extra" {
            return ScreenSize.screenHeight + (ScreenSize.screenWidth/4)
        }
        if seccion == "total" {
            return 150
        }
        return UITableView.automaticDimension
    }
    
    
    
    
    
    /**
     * Funcion para recolectar todos los valores del formulario y hacer
     * el request para guardarlos.
     *
     */
    @objc func guardarEvento() {
        
        let idUsuario = dataStorage.getUserId()
        
        var bebidasOpcion1: String = ""
        var bebidasCosto1: String = ""
        var bebidasOpcion2: String = ""
        var bebidasCosto2: String = ""
        var bebidasOpcion3: String = ""
        var bebidasCosto3: String = ""
        var bebidasOpcion4: String = ""
        var bebidasCosto4: String = ""
        var bebidasOpcion5: String = ""
        var bebidasCosto5: String = ""
        var arrayBebidas: [Dictionary<String, Any>] = []
        if let view = mainView.viewWithTag( ProductoExtraCell.TAG_BEBIDAS_VIEW ) as? ProductosExtraView {
            bebidasOpcion1 = view.opcion1Input.text!
            bebidasCosto1 = view.costo1Input.text!
            bebidasOpcion2 = view.opcion2Input.text!
            bebidasCosto2 = view.costo2Input.text!
            bebidasOpcion3 = view.opcion3Input.text!
            bebidasCosto3 = view.costo3Input.text!
            bebidasOpcion4 = view.opcion4Input.text!
            bebidasCosto4 = view.costo4Input.text!
            bebidasOpcion5 = view.opcion5Input.text!
            bebidasCosto5 = view.costo5Input.text!
            arrayBebidas = [
                [
                    "nombre": bebidasOpcion1,
                    "precio" : bebidasCosto1,
                    "tipo" : "1"
                ],
                [
                    "nombre": bebidasOpcion2,
                    "precio" : bebidasCosto2,
                    "tipo" : "1"
                ],
                [
                    "nombre": bebidasOpcion3,
                    "precio" : bebidasCosto3,
                    "tipo" : "1"
                ],
                [
                    "nombre": bebidasOpcion4,
                    "precio" : bebidasCosto4,
                    "tipo" : "1"
                ],
                [
                    "nomybre": bebidasOpcion5,
                    "precio" : bebidasCosto5,
                    "tipo" : "1"
                ]
            ]
        }
        
        
        
        
        var postresOpcion1: String = ""
        var postresCosto1: String = ""
        var postresOpcion2: String = ""
        var postresCosto2: String = ""
        var postresOpcion3: String = ""
        var postresCosto3: String = ""
        var postresOpcion4: String = ""
        var postresCosto4: String = ""
        var postresOpcion5: String = ""
        var postresCosto5: String = ""
        var arrayPostres: [Dictionary<String, Any>] = []
        
        if let view = mainView.viewWithTag( ProductoExtraCell.TAG_POSTRES_VIEW ) as? ProductosExtraView {
            postresOpcion1 = view.opcion1Input.text!
            postresCosto1 = view.costo1Input.text!
            postresOpcion2 = view.opcion2Input.text!
            postresCosto2 = view.costo2Input.text!
            postresOpcion3 = view.opcion3Input.text!
            postresCosto3 = view.costo3Input.text!
            postresOpcion4 = view.opcion4Input.text!
            postresCosto4  = view.costo4Input.text!
            postresOpcion5 = view.opcion5Input.text!
            postresCosto5 = view.costo5Input.text!
            arrayPostres = [
                [
                    "nombre": postresOpcion1,
                    "precio" : postresCosto1,
                    "tipo" : "2"
                ],
                [
                    "nombre": postresOpcion2,
                    "precio" : postresCosto2,
                    "tipo" : "2"
                ],
                [
                    "nombre": postresOpcion3,
                    "precio" : postresCosto3,
                    "tipo" : "2"
                ],
                [
                    "nombre": postresOpcion4,
                    "precio" : postresCosto4,
                    "tipo" : "2"
                ],
                [
                    "nombre": postresOpcion5,
                    "precio" : postresCosto5,
                    "tipo" : "2"
                ]
            ]
        }
        
        
        
        let productsExtra = arrayBebidas + arrayPostres
        
        // ---------------------------------------------------------------------
        var descripcion: String = ""
        if let textView = mainView.viewWithTag(TAG_DESCRIPCION_EVENT) as? UITextView {
            descripcion = textView.text!
        }
        var menu: String = ""
        if let textView = mainView.viewWithTag(TAG_MENU_EVENT) as? UITextView {
            menu = textView.text!
        }
        var bebidas: String = ""
        if let textView = mainView.viewWithTag(TAG_BEBIDAS_EVENT) as? UITextView {
            bebidas = textView.text!
        }
        var postres: String = ""
        if let textView = mainView.viewWithTag(TAG_POSTRES_EVENT) as? UITextView {
            postres = textView.text!
        }
        
        var costoMenu: String = "0"
        if let textView = mainView.viewWithTag(TAG_COSTO_MENU_EVENT) as? UITextView {
            if !(textView.text!).isEmpty {
                costoMenu = textView.text!
            }
        }
        else{
            costoMenu = "0"
        }
        var costoBebidas: String = "0"
        if let textView = mainView.viewWithTag(TAG_COSTO_BEBIDAS_EVENT) as? UITextView {
            if !(textView.text!).isEmpty {
                //costoMenu = textView.text!
                costoBebidas = textView.text!
            }
        }else{
            costoBebidas = "0"
        }
        var costoPostres: String = "0"
        if let textView = mainView.viewWithTag(TAG_COSTO_POSTRES_EVENT) as? UITextView {
            if !(textView.text!).isEmpty {
                //costoMenu = textView.text!
                costoPostres = textView.text!
            }
        }
        else{
            costoPostres = "0"
        }
        
        let tituloEvento = dataStorage.getLastTitle()
        
        let costoMenuInt: Int    = Int(costoMenu)!
        let costoBebidasInt: Int = Int(costoBebidas)!
        let costoPostresInt: Int = Int(costoPostres)!
        let costoTotal = costoMenuInt + costoBebidasInt + costoPostresInt
        
        // ---------------------------------------------------------------------
        
        let jsonData = try! JSONSerialization.data(withJSONObject: productsExtra, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        
        let parameters: Parameters=["funcion"    : "saveEvent",
                                    "id_user"    : idUsuario,
                                    "name"       : tituloEvento,
                                    "description": descripcion,
                                    "menu"       : menu,
                                    "menu_cost"  : costoMenu,
                                    "drinks"     : bebidas,
                                    "drinks_cost": costoBebidas,
                                    "dessert"    : postres,
                                    "dessert_cost" : costoPostres,
                                    "date_event" : dataStorage.getDate(),
                                    "start_time" : dataStorage.getComienzaEvent(),
                                    "end_time"   : dataStorage.getTerminaEvent(),
                                    "capacity"   : personasRecibirInput.text!,
                                    "costo"      : costoTotal,
                                    "type"       : dataStorage.getLastFoodSelectedEvent(),
                                    "id_cat"     : dataStorage.getLastCategorySelectedEvent(),
                                    "id_sub_cat" : dataStorage.getLastSubCategorySelectedEvent(),
                                    "image"      : dataStorage.getImagenEvent(),
                                    "extra_products" : decoded] as [String: Any]
        
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
                            
                            
                            let alert = UIAlertController(title: "Evento Creado.",
                                                          message: "",
                                                          preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,
                                                          handler: self.closeVC))
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
    
    @objc func closeVC(alert: UIAlertAction!) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
}



extension EventoAnfitrionViewController: NumeroInvitadosSelected{
    
    func getNumeroSelected(numero: String) {
        personasRecibirInput.text = numero
    }
    
}


extension EventoAnfitrionViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

