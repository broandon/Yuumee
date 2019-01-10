//
//  MetodoDePagoViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/27/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit

class MetodoDePagoViewController: BaseViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
        tableView.alwaysBounceVertical = true
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register( UITableViewCell.self , forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    
    static let tagVisa = 1
    static let tagMasterCard = 2
    static let tagAmericanExpress = 3
    let visa: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "visa"), for: .normal)
        button.tag = tagVisa
        button.layer.cornerRadius = 10
        return button
    }()
    let mastercard: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "master_card"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tag = tagMasterCard
        button.layer.cornerRadius = 10
        return button
        
    }()
    let americanExpress: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "american_express"), for: .normal)
        button.tag = tagAmericanExpress
        button.layer.cornerRadius = 10
        return button
    }()
    let containerCards: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    let numeroTarjeta: UILabel = {
        let label = UILabel()
        label.text = "No. de tarjeta"
        label.textColor = UIColor.darkGray
        label.font = label.font.withSize(18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let numeroTarjetaInput: UITextField = {
        let textFieldNombre = UITextField()
        textFieldNombre.keyboardType = UIKeyboardType.numberPad
        textFieldNombre.textAlignment = .center
        textFieldNombre.backgroundColor = UIColor.gris
        return textFieldNombre
    }()
    
    
    
    
    
    let fechaVencimiento: UILabel = {
        let label = UILabel()
        label.text = "Fecha de vencimiento"
        label.textColor = UIColor.darkGray
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    let fechaVencimientoCont: UIView = {
        let view = UIView()
        return view
    }()
    
    let fechaVencimientoM: UITextField = {
        let textFieldNombre = UITextField()
        textFieldNombre.placeholder = " MM "
        textFieldNombre.keyboardType = UIKeyboardType.numberPad
        textFieldNombre.textAlignment = .center
        return textFieldNombre
    }()
    let fechaVencimientoY: UITextField = {
        let textFieldNombre = UITextField()
        textFieldNombre.placeholder = " YYYY "
        textFieldNombre.keyboardType = UIKeyboardType.numberPad
        textFieldNombre.textAlignment = .center
        return textFieldNombre
    }()
    let separadorFechaVto: UILabel = {
        let label = UILabel()
        label.text = "/"
        label.textColor = UIColor.gris
        label.sizeToFit()
        label.textAlignment = .center
        return label
    }()
    
    let codigoSeguridad: UILabel = {
        let label = UILabel()
        label.text = "Código de seguridad"
        label.textColor = UIColor.darkGray
        label.numberOfLines = 1
        label.textAlignment = .right
        return label
    }()
    
    let codigoSeguridadInput: UITextField = {
        let textFieldNombre = UITextField()
        textFieldNombre.keyboardType = UIKeyboardType.numberPad
        textFieldNombre.textAlignment = .center
        textFieldNombre.setBottomBorder()
        return textFieldNombre
    }()
    
    
    let aceptar: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Guardar", for: .normal)
        button.setTitleColor(UIColor.rosa, for: .normal)
        button.layer.cornerRadius = 10
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        button.imageView?.contentMode = .scaleAspectFit
        button.addBorder(borderColor: UIColor.azul , widthBorder: 2)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        self.title = "Agregar tarjeta"
        
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        let back = UIBarButtonItem(image: UIImage(named: "close"), style: .plain,
                                   target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem = back
        mainView.addSubview(tableView)
        
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|[v0]-60-|", views: tableView)
        
        
        let footerView = UIView()
        footerView.frame = CGRect(x: 0, y: 0, width: ScreenSize.screenWidth, height: 60)
        footerView.addSubview(aceptar)
        footerView.addConstraintsWithFormat(format: "H:[v0]-|", views: aceptar)
        footerView.addConstraintsWithFormat(format: "V:|-[v0(40)]", views: aceptar)
        tableView.tableFooterView = footerView
        aceptar.addTarget(self, action: #selector(addTarjeta), for: .touchUpInside)
        
        // ---------------------------------------------------------------------
        
        let conekta = Conekta()
        conekta.delegate = self
        conekta.publicKey = "key_HxQ8WZqx2Xcjug7xnizMndA"
        conekta.collectDevice()
        let card = conekta.card()
        card!.setNumber("4242424242424242",
                       name: "Julian Ceballos",
                       cvc: "123", expMonth: "10", expYear: "2019")
        let token = conekta.token()
        token!.card = card
        token!.create(success: { (data) -> Void in
            print(data)
        }, andError: { (error) -> Void in
            print(error)
        })
        
        // ---------------------------------------------------------------------
        
    }
    
    
    
    @objc func keyboardWillShow(notification: Notification){
        makeSpaceForKeyboard(notification: notification)
    }
    @objc func keyboardWillHide(notification: Notification){
        // makeSpaceForKeyboard(notification: notification)
        makeSpaceForKeyboard(notification: notification)
    }
    func makeSpaceForKeyboard(notification: Notification){
        let info = notification.userInfo!
        let keyboardHeight:CGFloat = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size.height
        let duration:Double = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        if notification.name == UIResponder.keyboardWillShowNotification {
            UIView.animate(withDuration: duration, animations: { () -> Void in
                var frame = self.view.frame
                frame.size.height = frame.size.height - keyboardHeight
                self.view.frame = frame
            })
        } else {
            UIView.animate(withDuration: duration, animations: { () -> Void in
                var frame = self.view.frame
                frame.size.height = frame.size.height + keyboardHeight
                self.view.frame = frame
            })
        }
    }
    
    
    
    @objc func close() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addTarjeta() {
        
        if (tipoTarjetaSeleccionada.isEmpty) {
            let alert = UIAlertController(title: "Campo Requerido",
                                          message: "Por favor seleccione el tipo de su tarjeta (VISA, MasterCard, etc...).",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        // Datos de tarejetas
        let numeroTarjeta = numeroTarjetaInput.text
        if (numeroTarjeta?.isEmpty)! { // Numero de Tarjeta
            let alert = UIAlertController(title: "Campo Requerido",
                                          message: "El número de la tarjeta es requerido.",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        if (fechaVencimientoM.text?.isEmpty)! {
            let alert = UIAlertController(title: "Campo Requerido",
                                          message: "El mes de vencimeinto es requerido.",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        if (fechaVencimientoM.text?.count)! < 2 {
            let alert = UIAlertController(title: "Número de caracteres no validos",
                                          message: "El número de caracteres del mes de vencimieinto debe ser de 2.",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        if (fechaVencimientoY.text?.isEmpty)! {
            let alert = UIAlertController(title: "Campo Requerido",
                                          message: "El año de vencimeinto es requerido.",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        if (fechaVencimientoY.text?.count)! < 4 {
            let alert = UIAlertController(title: "Número de caracteres no validos",
                                          message: "El número de caracteres del año de vencimieinto debe ser de 4.",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        if (codigoSeguridadInput.text?.isEmpty)! {
            let alert = UIAlertController(title: "Campo Requerido",
                                          message: "El código de seguridad es requerido.",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        if (codigoSeguridadInput.text?.count)! < 3 {
            let alert = UIAlertController(title: "Número de caracteres no validos",
                                          message: "El código de verificación de la tarjeta (CVT) debe ser de 3 caracteres.",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        // Datos Personales
        if (nombreInput.text?.isEmpty)! {
            let alert = UIAlertController(title: "Campo Requerido",
                                          message: "Su nombre es requerido.",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        if (apellidoInput.text?.isEmpty)! {
            let alert = UIAlertController(title: "Campo Requerido",
                                          message: "Su apellido es requerido.",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        if (calleNumeroInput.text?.isEmpty)! {
            let alert = UIAlertController(title: "Campo Requerido",
                                          message: "Los datos de direccion son requerido.",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        if (coloniaInput.text?.isEmpty)! {
            let alert = UIAlertController(title: "Campo Requerido",
                                          message: "La colonia es requerida.",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        if (codigoPostalInput.text?.isEmpty)! {
            let alert = UIAlertController(title: "Campo Requerido",
                                          message: "El código postal es requerido.",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        if (telefonoContactoInput.text?.isEmpty)! {
            let alert = UIAlertController(title: "Campo Requerido",
                                          message: "El télefono es requerido.",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        print(" Valida ")
    }
    
    
    
    let nombre: UILabel = {
        let nombre = UILabel()
        nombre.text = "Nombre"
        nombre.numberOfLines = 0
        nombre.textColor = UIColor.darkGray
        return nombre
    }()
    let nombreInput: UITextField = {
        let textFieldNombre = UITextField()
        textFieldNombre.backgroundColor = UIColor.gris
        return textFieldNombre
    }()
    
    
    
    let apellido: UILabel = {
        let nombre = UILabel()
        nombre.text = "Apellido"
        nombre.numberOfLines = 0
        nombre.textColor = UIColor.darkGray
        return nombre
    }()
    let apellidoInput: UITextField = {
        let textFieldNombre = UITextField()
        textFieldNombre.backgroundColor = UIColor.gris
        return textFieldNombre
    }()
    
    
    let calleNumero: UILabel = {
        let direccion = UILabel()
        direccion.text = "Dirección"
        direccion.numberOfLines = 0
        direccion.textColor = UIColor.darkGray
        return direccion
    }()
    let calleNumeroInput: UITextField = {
        let textFieldDireccion = UITextField()
        textFieldDireccion.backgroundColor = UIColor.gris
        return textFieldDireccion
    }()
    
    
    let colonia: UILabel = {
        let referencias = UILabel()
        referencias.text = "Colonia"
        referencias.numberOfLines = 0
        referencias.textColor = UIColor.darkGray
        return referencias
    }()
    let coloniaInput: UITextField = {
        let textFieldReferencia = UITextField()
        textFieldReferencia.backgroundColor = UIColor.gris
        textFieldReferencia.textColor = UIColor.darkGray
        return textFieldReferencia
    }()
    
    
    let codigoPostal: UILabel = {
        let horario = UILabel()
        horario.text = "Código Postal"
        horario.numberOfLines = 0
        horario.textColor = UIColor.darkGray
        return horario
    }()
    let codigoPostalInput: UITextField = {
        let textFieldHorario = UITextField()
        textFieldHorario.backgroundColor = UIColor.gris
        return textFieldHorario
    }()
    
    
    let telefonoContacto: UILabel = {
        let horario = UILabel()
        horario.text = "Télefono"
        horario.textColor = UIColor.darkGray
        return horario
    }()
    let telefonoContactoInput: UITextField = {
        let textFieldHorario = UITextField()
        textFieldHorario.backgroundColor = UIColor.gris
        return textFieldHorario
    }()
    
    
    
    let seccionTarjeta = ["cont_tarjetas", "numero_tarjeta", "fecha_vto"]
    
    let seccionDatosPersonales = ["nombre", "apellido", "calle_numero", "colonia", "cp", "telefono"]
    
    var tipoTarjetaSeleccionada = ""
    
    @objc func selectTipoTarjeta(sender: UIButton) {
        if sender.tag == MetodoDePagoViewController.tagVisa {
            tipoTarjetaSeleccionada = "visa"
            sender.addBorder(borderColor: UIColor.gris , widthBorder: 2)
            if let buttonMasterCard = mainView.viewWithTag(MetodoDePagoViewController.tagMasterCard) as? UIButton {
                buttonMasterCard.addBorder(borderColor: .clear , widthBorder: 2)
            }
            if let buttonMasterCard = mainView.viewWithTag(MetodoDePagoViewController.tagAmericanExpress) as? UIButton {
                buttonMasterCard.addBorder(borderColor: .clear , widthBorder: 2)
            }
        }
        
        if sender.tag == MetodoDePagoViewController.tagMasterCard {
            tipoTarjetaSeleccionada = "master card"
            sender.addBorder(borderColor: UIColor.gris , widthBorder: 2)
            if let buttonMasterCard = mainView.viewWithTag(MetodoDePagoViewController.tagVisa) as? UIButton {
                buttonMasterCard.addBorder(borderColor: .clear , widthBorder: 2)
            }
            if let buttonMasterCard = mainView.viewWithTag(MetodoDePagoViewController.tagAmericanExpress) as? UIButton {
                buttonMasterCard.addBorder(borderColor: .clear , widthBorder: 2)
            }
        }
        
        if sender.tag == MetodoDePagoViewController.tagAmericanExpress {
            tipoTarjetaSeleccionada = "american express"
            sender.addBorder(borderColor: UIColor.gris , widthBorder: 2)
            if let buttonMasterCard = mainView.viewWithTag(MetodoDePagoViewController.tagVisa) as? UIButton {
                buttonMasterCard.addBorder(borderColor: .clear , widthBorder: 2)
            }
            if let buttonMasterCard = mainView.viewWithTag(MetodoDePagoViewController.tagMasterCard) as? UIButton {
                buttonMasterCard.addBorder(borderColor: .clear , widthBorder: 2)
            }
        }
        
    } // selectTipoTarjeta
    

}


// MARK: delegados

extension MetodoDePagoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return seccionTarjeta.count
        }
        if section == 1 {
            return seccionDatosPersonales.count
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = indexPath.section
        let currentRow = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.releaseView()
        cell.selectionStyle = .none
        
        if currentSection == 0 { // Sccion Datos de Tarjeta
            let seccion = seccionTarjeta[currentRow]
            if seccion == "cont_tarjetas" {
                containerCards.addSubview( numeroTarjeta )
                containerCards.addSubview(visa)
                containerCards.addSubview(mastercard)
                containerCards.addSubview(americanExpress)
                
                visa.addTarget(self, action: #selector(selectTipoTarjeta) , for: .touchUpInside)
                mastercard.addTarget(self, action: #selector(selectTipoTarjeta) , for: .touchUpInside)
                americanExpress.addTarget(self, action: #selector(selectTipoTarjeta) , for: .touchUpInside)
                
                containerCards.addConstraintsWithFormat(format: "H:|-[v0]-(>=8)-[v1(60)]-[v2(60)]-[v3(60)]-|",
                    views: numeroTarjeta, visa, mastercard, americanExpress)
                containerCards.addConstraintsWithFormat(format: "V:|-[v0(50)]", views: numeroTarjeta)
                containerCards.addConstraintsWithFormat(format: "V:|-[v0(40)]", views: visa)
                containerCards.addConstraintsWithFormat(format: "V:|-[v0(40)]", views: mastercard)
                containerCards.addConstraintsWithFormat(format: "V:|-[v0(40)]", views: americanExpress)
                
                cell.addSubview(containerCards)
                cell.addConstraintsWithFormat(format: "H:|[v0]|", views: containerCards)
                cell.addConstraintsWithFormat(format: "V:|[v0]|", views: containerCards)
                
                return cell
            }
            if seccion == "numero_tarjeta" {
                cell.addSubview( numeroTarjetaInput )
                numeroTarjetaInput.delegate = self
                cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: numeroTarjetaInput)
                cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: numeroTarjetaInput)
                return cell
            }
            if seccion == "fecha_vto" {
                let contFecha = UIView()
                contFecha.addSubview(fechaVencimiento)
                contFecha.addSubview(fechaVencimientoCont)
                fechaVencimientoCont.addBottomBorderWithColor(color: .darkGray, width: 1)
                contFecha.addSubview(codigoSeguridad)
                
                contFecha.addSubview(codigoSeguridadInput)
                codigoSeguridadInput.delegate = self
                let widthTitles = (UIScreen.main.bounds.width / 2) - 16
                contFecha.addConstraintsWithFormat(format: "H:|-[v0(\(widthTitles))]-(>=8)-[v1(\(widthTitles))]-|", views: fechaVencimiento, codigoSeguridad)
                contFecha.addConstraintsWithFormat(format: "H:|-[v0(\((UIScreen.main.bounds.width / 2) - 24))]-(>=8)-[v1(\((UIScreen.main.bounds.width / 2) - 24))]-|", views: fechaVencimientoCont, codigoSeguridadInput)
                contFecha.addConstraintsWithFormat(format: "V:|[v0][v1(30)]|",
                                                   views: fechaVencimiento, fechaVencimientoCont)
                contFecha.addConstraintsWithFormat(format: "V:|[v0][v1(30)]|",
                                                   views: codigoSeguridad, codigoSeguridadInput)
                
                // Inputs para la fecha de vencimento (Mes & Año)
                fechaVencimientoCont.addSubview(fechaVencimientoM)
                fechaVencimientoM.delegate = self
                fechaVencimientoCont.addSubview(fechaVencimientoY)
                fechaVencimientoY.delegate = self
                fechaVencimientoCont.addSubview(separadorFechaVto)
                fechaVencimientoCont.addConstraintsWithFormat(format: "H:|[v0(60)][v1(10)][v2(60)]",
                                                              views: fechaVencimientoM, separadorFechaVto, fechaVencimientoY)
                fechaVencimientoCont.addConstraintsWithFormat(format: "V:|[v0]|", views: fechaVencimientoM)
                fechaVencimientoCont.addConstraintsWithFormat(format: "V:|[v0]|", views: separadorFechaVto)
                fechaVencimientoCont.addConstraintsWithFormat(format: "V:|[v0]|", views: fechaVencimientoY)
                
                cell.addSubview(contFecha)
                cell.addConstraintsWithFormat(format: "H:|[v0]|", views: contFecha)
                cell.addConstraintsWithFormat(format: "V:|[v0]|", views: contFecha)
                
                
                return cell
            }
        }
        
        if currentSection == 1 { // Seccion Datos Personales
            
            let seccion = seccionDatosPersonales[currentRow]
            
            // Datos Personales
            if seccion == "nombre" {
                cell.addSubview(nombre)
                cell.addSubview(nombreInput)
                cell.addConstraintsWithFormat(format: "H:|-[v0(80)][v1]-|", views: nombre, nombreInput)
                cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: nombre)
                cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: nombreInput)
                return cell
            }
            
            if seccion == "apellido" {
                
                cell.addSubview(apellido)
                cell.addSubview(apellidoInput)
                cell.addConstraintsWithFormat(format: "H:|-[v0(80)][v1]-|", views: apellido, apellidoInput)
                cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: apellido)
                cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: apellidoInput)
                
            }
            if seccion == "calle_numero" {
                cell.addSubview(calleNumero)
                cell.addSubview(calleNumeroInput)
                cell.addConstraintsWithFormat(format: "H:|-[v0(80)][v1]-|", views: calleNumero, calleNumeroInput)
                cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: calleNumero)
                cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: calleNumeroInput)
                return cell
            }
            
            if seccion == "colonia" {
                cell.addSubview(colonia)
                cell.addSubview(coloniaInput)
                cell.addConstraintsWithFormat(format: "H:|-[v0(80)][v1]-|", views: colonia, coloniaInput)
                cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: colonia)
                cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: coloniaInput)
                return cell
            }
            
            if seccion == "cp" {
                cell.addSubview(codigoPostal)
                cell.addSubview(codigoPostalInput)
                cell.addConstraintsWithFormat(format: "H:|-[v0(110)]-[v1]-|", views: codigoPostal, codigoPostalInput)
                cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: codigoPostal)
                cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: codigoPostalInput)
            }
            
            if seccion == "telefono" {
                
                cell.addSubview(telefonoContacto)
                cell.addSubview(telefonoContactoInput)
                cell.addConstraintsWithFormat(format: "H:|-[v0(80)][v1]-|", views: telefonoContacto, telefonoContactoInput)
                cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: telefonoContacto)
                cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: telefonoContactoInput)
            }
            
        }
        
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = indexPath.section
        let currentRow = indexPath.row
        
        if currentSection == 0 { // Sccion Datos de Tarjeta
            let seccion = seccionTarjeta[currentRow]
            
            if seccion == "cont_tarjetas" {
                return 50
            }
            if seccion == "numero_tarjeta" {
                return 60
            }
            if seccion == "fecha_vto" {
                return 80
            }
        }
        
        if currentSection == 1 { // Seccion Datos Personales
            // let seccion = seccionDatosPersonales[currentRow]
            return 70
        }
        
        return 0
    }
    
    
    /**
     * Footer de la tabla
     *
     **/
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let datosPersonales = UILabel()
            datosPersonales.translatesAutoresizingMaskIntoConstraints = false
            datosPersonales.text = "Datos de contacto"
            datosPersonales.textColor = .white
            datosPersonales.textAlignment = .center
            datosPersonales.backgroundColor = UIColor.verde.withAlphaComponent(0.7)
            
            let headerDatosPersonales = UIView()
            headerDatosPersonales.addSubview(datosPersonales)
            headerDatosPersonales.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: datosPersonales)
            headerDatosPersonales.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: datosPersonales)
            headerDatosPersonales.backgroundColor = .white
            return headerDatosPersonales
        }
        return UIView()
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40
        }
        return 0
    }
    
} // delegate & datasource



extension MetodoDePagoViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Validacion del numero de caracteres del numero de tarjeta
        if textField ==  numeroTarjetaInput {
            let numeroTarjeta = 16
            let espacioEntreCuerteto = 0
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= (numeroTarjeta + espacioEntreCuerteto)
        }
        
        // Validacion del código de seguridad
        if textField == codigoSeguridadInput {
            let totalCaracteres = 3
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= totalCaracteres
        }
        
        // Validacion del mes de la fecha de vencimiento
        if textField == fechaVencimientoM {
            let totalCaracteres = 2
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= totalCaracteres
        }
        
        // Validacion del mes de la fecha de vencimiento
        if textField == fechaVencimientoY {
            let totalCaracteres = 4
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= totalCaracteres
        }
        
        return true
    }
    
    
}

