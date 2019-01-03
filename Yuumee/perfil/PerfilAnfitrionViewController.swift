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
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear),
                                               name: UIApplication.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear),
                                               name: UIApplication.keyboardWillHideNotification,
                                               object: nil)
        
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
    }
    
    
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        self.view.frame.origin.y -= 200
        /*
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            mainView.frame.origin.y = -(keyboardSize.height/2)
        }
        */
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification) {
        self.view.frame.origin.y += 200
        /*
        mainView.frame.origin.y = 0
        tableView.contentOffset = CGPoint(x: 0, y: 0)
        */
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
                cell.reference = self
                cell.setUpView()
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        cell.addBorder()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = secciones[indexPath.row]
        if section == "background_image" {
            return ScreenSize.screenWidth / 2
        }
        if section == "info" {
            return ScreenSize.screenHeight - (ScreenSize.screenWidth*0.3)
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
    
    var reference: UIViewController!
    
    var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.addBorder(borderColor: UIColor.rosa, widthBorder: 1)
        imageView.isUserInteractionEnabled = true
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
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
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
        let button = UIButton(type: .system)
        button.setTitle("Guardar perfil", for: .normal)
        button.titleLabel?.font = UIFont(name: "ArchiaRegular", size: (button.titleLabel?.font.pointSize)!)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: (button.titleLabel?.font.pointSize)!)
        button.backgroundColor = UIColor.verde
        button.setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
        return button
    }()
    
    let agregarEvento: UIButton = {
        let size = CGSize(width: 15, height: 15)
        let image = UIImage(named: "add")?.imageResize(sizeChange: size)
        let button = UIButton(type: .system)
        button.setTitle("Agregar evento", for: .normal)
        button.titleLabel?.font = UIFont(name: "ArchiaRegular", size: (button.titleLabel?.font.pointSize)!)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: (button.titleLabel?.font.pointSize)!)
        button.backgroundColor = UIColor.gris
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 5
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
        
        let sizeAvatar = ScreenSize.screenWidth / 4
        addConstraintsWithFormat(format: "H:|-[v0(\(sizeAvatar))]-[v1]-|", views: avatar, contentInfo)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: contentDescription)
        addConstraintsWithFormat(format: "H:|[v0]|", views: guardarPerfil)
        addConstraintsWithFormat(format: "H:|-[v0(180)]", views: agregarEvento)
        addConstraintsWithFormat(format: "V:|-[v0(\(sizeAvatar))]", views: avatar)
        addConstraintsWithFormat(format: "V:|-[v0(270)]-[v1(100)]-16-[v2(30)]-16-[v3(30)]",
                                 views: contentInfo, contentDescription, guardarPerfil, agregarEvento)
        
        // Info
        nombre = getTextFieldForInfo(placeHolder: "Nombre completo")
        nombre.delegate = self
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
        contentInfo.addConstraintsWithFormat(format: "V:|[v0]-[v1]-[v2]-[v3]-[v4]-[v5]-[v6]-[v7]-[v8]",
                                             views: nombre, edad, direccion, email, telefono, profesion, idiomas, espacioDegustarLbl, serviciosExtra)
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








class EventoAnfitrionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let horarioCell = "HorarioCell"
    
    let comidaCell = "ComidaCell"
    
    let categoriaCell = "CategoriaCell"
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView() // frame: CGRect.zero, style: .grouped
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.register(CategoriaCell.self, forCellReuseIdentifier: categoriaCell)
        tableView.register(ComidaCell.self, forCellReuseIdentifier: comidaCell)
        tableView.register(HorarioCell.self, forCellReuseIdentifier: horarioCell)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.gris
        return tableView
    }()
    
    let secciones = ["categoria", "comida", "horario", "", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Reemplaza el titulo del back qu eviene por Default
        self.navigationController?.navigationBar.topItem?.title = "Evento"
        
        mainView.backgroundColor = .white
        
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
    }
    
    // MARK: Data Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let seccion = secciones[indexPath.row]
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        cell.addBorder()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    
}






/**
 * CategoriaCell
 *
 */
class CategoriaCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    var reference: UIViewController!
    
    let categoriaLbl: ArchiaRegularLabel = {
        let label = ArchiaRegularLabel()
        label.text = "Categoría de comida:"
        return label
    }()
    
    let categoria: UITextField = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "down_arrow")
        imageView.image = image
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.addBorder(borderColor: .black, widthBorder: 1)
        textField.layer.cornerRadius = 10
        textField.keyboardType = UIKeyboardType.alphabet
        textField.rightViewMode = .always
        textField.text = "Regional"
        textField.textColor = UIColor.lightGray
        textField.textAlignment = .center
        textField.rightView = imageView
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height) )
        textField.leftView = paddingView
        // textField.clearButtonMode = UITextField.ViewMode.whileEditing -> Muestra el auto.corrector
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    func setUpView() {
        addSubview(categoria)
        categoria.delegate = self
        addSubview(categoriaLbl)
        addConstraintsWithFormat(format: "H:|-[v0(170)]-[v1]-|", views: categoriaLbl, categoria)
        addConstraintsWithFormat(format: "V:|-[v0(30)]", views: categoria)
        addConstraintsWithFormat(format: "V:|-[v0(30)]", views: categoriaLbl)
    }
    
}


extension CategoriaCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        categoria.resignFirstResponder();
        // ToDo
        let vc = CategoriasComidaViewController()
        vc.delegate = self
        vc.currentFood = self.categoria.text!
        let popVC = UINavigationController(rootViewController: vc)
        popVC.modalPresentationStyle = .popover
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = categoria // self.button
        popOverVC?.sourceRect = CGRect(x: self.categoria.bounds.midX,
                                       y: self.categoria.bounds.minY,
                                       width: 0, height: 0)
        let widthModal = ScreenSize.screenWidth - 16
        let heightModal = ScreenSize.screenWidth
        popVC.preferredContentSize = CGSize(width: widthModal, height: heightModal)
        reference.present(popVC, animated: true)
        
        return false
    }
    
}

extension CategoriaCell: FoodSelected {
    
    func getFoodSelected(food: String) {
        self.categoria.text = food
    }
    
}

extension CategoriaCell: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

// CategoriaCell





class ComidaCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    
    let desayuno: ArchiaBoldLabel = {
        let label = ArchiaBoldLabel()
        label.text = "Desayuno"
        return label
    }()
    let comida: ArchiaBoldLabel = {
        let label = ArchiaBoldLabel()
        label.text = "Comida"
        return label
    }()
    let cena: ArchiaBoldLabel = {
        let label = ArchiaBoldLabel()
        label.text = "Cena"
        return label
    }()
    
    
    let checkBoxDesayuno: UIView = {
        let view = UIView()
        view.addBorder(borderColor: UIColor.black, widthBorder: 2)
        view.isUserInteractionEnabled = true
        return view
    }()
    let checkBoxComida: UIView = {
        let view = UIView()
        view.addBorder(borderColor: UIColor.black, widthBorder: 2)
        view.isUserInteractionEnabled = true
        return view
    }()
    let checkBoxCena: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.addBorder(borderColor: UIColor.black, widthBorder: 2)
        return view
    }()
    
    func setUpView() {
        addSubview(desayuno)
        addSubview(comida)
        addSubview(cena)
        addSubview(checkBoxDesayuno)
        addSubview(checkBoxComida)
        addSubview(checkBoxCena)
        
        addConstraintsWithFormat(format: "H:|-[v0(12)]-[v1(v5)]-[v2(12)]-[v3(v5)]-[v4(12)]-[v5(v5)]-|",
                                 views: checkBoxDesayuno, desayuno, checkBoxComida, comida, checkBoxCena, cena)
        addConstraintsWithFormat(format: "V:|-4-[v0(12)]", views: checkBoxDesayuno)
        addConstraintsWithFormat(format: "V:|[v0]", views: desayuno)
        addConstraintsWithFormat(format: "V:|-4-[v0(12)]", views: checkBoxComida)
        addConstraintsWithFormat(format: "V:|[v0]", views: comida)
        addConstraintsWithFormat(format: "V:|-4-[v0(12)]", views: checkBoxCena)
        addConstraintsWithFormat(format: "V:|[v0]", views: cena)
        let tapCheckDesayuno = UITapGestureRecognizer(target: self,
                                                      action: #selector(checkDesayuno))
        tapCheckDesayuno.numberOfTapsRequired = 1
        checkBoxDesayuno.addGestureRecognizer(tapCheckDesayuno)
        let tapCheckComida = UITapGestureRecognizer(target: self,
                                                    action: #selector(checkComida))
        tapCheckComida.numberOfTapsRequired = 1
        checkBoxComida.addGestureRecognizer(tapCheckComida)
        let tapCheckCena = UITapGestureRecognizer(target: self,
                                                  action: #selector(checkCena))
        tapCheckCena.numberOfTapsRequired = 1
        checkBoxCena.addGestureRecognizer(tapCheckCena)
    }
    
    @objc func checkDesayuno(ckeck: Any) {
        self.checkBoxDesayuno.check()
        self.checkBoxComida.unCheck()
        self.checkBoxCena.unCheck()
    }
    
    @objc func checkComida(ckeck: Any) {
        self.checkBoxDesayuno.unCheck()
        self.checkBoxComida.check()
        self.checkBoxCena.unCheck()
    }
    
    @objc func checkCena(ckeck: Any) {
        self.checkBoxDesayuno.unCheck()
        self.checkBoxComida.unCheck()
        self.checkBoxCena.check()
    }
    
}


extension UIView {
    
    func check() {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .gray
        backgroundView.addBorder(borderColor: .white, widthBorder: 2)
        self.addSubview(backgroundView)
        self.addConstraintsWithFormat(format: "H:|-1-[v0]-1-|", views: backgroundView)
        self.addConstraintsWithFormat(format: "V:|-1-[v0]-1-|", views: backgroundView)
    }
    
    func unCheck() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }
    
}



class HorarioCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    
    let categoria: ArchiaRegularLabel = {
        let label = ArchiaRegularLabel()
        label.text = "Categoría de comida:"
        return label
    }()
    
    let categoriaLbl: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.addBorder(borderColor: .black, widthBorder: 1)
        textField.layer.cornerRadius = 10
        textField.rightViewMode = .always
        return textField
    }()
    
    
    func setUpView() {
        //
    }
    
    
}


