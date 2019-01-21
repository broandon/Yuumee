//
//  Helpers.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/11/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ScreenSize {
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
}



enum TipoTarjeta: String {
    case american_express = "AMEX" // 3
    case visa             = "VISA" // 4
    case master_card      = "MASTER CARD" // 5
}


enum TipoUsuario: Int {
    case anfitrion = 2
    case cliente   = 3
}



class Utils {
    
    typealias callbackAlert = ((UIAlertAction) -> Void)?
    
    static func showSimpleAlert(message: String!, context: UIViewController, success: callbackAlert ) {
        let alertController = UIAlertController(title: "Yuumee",
                                                message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        let dismissAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: success)
        alertController.addAction(dismissAction)
        context.present(alertController, animated: true, completion: nil)
    }
    
}




struct ParameterQueryEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = parameters?
            .map { "\($0)=\($1)" }
            .joined(separator: "&")
            .data(using: .utf8)
        return request
    }
}

class BaseURL {
    private static let scheme = "http://"
    private static var host = "easycode.mx/"
    private static let path = "yuumee/webservice/controller_last.php"
    
    /**
     * Retorna la URL base para hacer el request
     *
     */
    class func baseUrl() -> String {
        return scheme + host + path
    }
}




class CategoriasComidaViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cerrarBtn: UIBarButtonItem = {
        let sizeImg = CGSize(width: 24, height: 24)
        let imgClose = UIImage(named: "close")?.imageResize(sizeChange: sizeImg)
        let cerrarBtn = UIBarButtonItem(image: imgClose, style: .plain, target: self, action: #selector(closeVC) )
        cerrarBtn.tintColor = .white
        return cerrarBtn
    }()
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let secciones = ["Regional", "Ocasional", "Mediterranea", "Chida", "Una mas"]
    
    var delegate: FoodSelected?
    
    var currentFood = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = UIColor.gris
        cerrarBtn.target = self
        self.navigationItem.leftBarButtonItem = cerrarBtn
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Data Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        // cell.releaseView()
        let seccion = secciones[indexPath.row]
        if seccion == currentFood {
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.text = seccion
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seccion = secciones[indexPath.row]
        self.dismiss(animated: true, completion: {
            self.delegate?.getFoodSelected(food: seccion)
        })
    }
    
}
protocol FoodSelected {
    func getFoodSelected(food: String)
}




class WebViewController: UIViewController, UIWebViewDelegate {
    
    var mainView: UIView {
        return self.view
    }
    
    var url: String?
    
    var titleVC: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
        
        let imageBtn = UIImage(named: "back")?.imageResize(sizeChange: CGSize(width: 30.0, height: 30.0))
        let back = UIButton(type: .system)
        back.setImage(imageBtn, for: .normal)
        //back.setTitle(titleVC, for: .normal)
        back.titleLabel?.textColor = .white
        back.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        back.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        back.addTarget(self, action: #selector(regresar), for: .touchUpInside)
        back.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back)
        
        
        let webView = UIWebView()
        mainView.addSubview(webView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: webView)
        mainView.addConstraintsWithFormat(format: "V:|[v0]|", views: webView)
        
        if !(url?.isEmpty)! {
            let url = NSURL(string: self.url!)
            let requestObj = NSURLRequest(url: url! as URL)
            webView.delegate = self
            webView.loadRequest(requestObj as URLRequest)
        }
    }
    
    
    @objc func regresar() {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
}



class MisDatosViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
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
    
    let secciones = ["avatar", "nombre", "telefono", "email", "guardar"]
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        mainView.backgroundColor = .white
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        self.navigationItem.leftBarButtonItem = closeIcon
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func actualizarDatos() {
        print(" \(nombre.text) ")
        print(" \(telefono.text) ")
        print(" \(email.text) ")
    }
    
    
    
    let nombre = UITextField()
    let telefono = UITextField()
    let email = UITextField()
    
    
    // UITableView: Datasource & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseID, for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        let seccion = secciones[indexPath.row]
        
        if seccion == "avatar" {
            let avatarImg = UIImage(named: "avatar")
            let imageViewAvatar = UIImageView(image: avatarImg)
            imageViewAvatar.layer.cornerRadius = 35
            imageViewAvatar.contentMode = .scaleAspectFit
            imageViewAvatar.backgroundColor = .white
            imageViewAvatar.clipsToBounds = true
            cell.addSubview(imageViewAvatar)
            cell.centerInView(superView: cell, container: imageViewAvatar, sizeV: 70.0, sizeH: 70.0)
            return cell
        }
        
        if seccion == "nombre" {
            nombre.delegate = self
            nombre.addBottomBorder()
            nombre.font = UIFont.init(name: "MyriadPro-Bold", size: (nombre.font?.pointSize)!)
            nombre.textColor = UIColor.gray
            nombre.text = "Jose Gutierrez Gutierrez"
            nombre.returnKeyType = .done
            cell.addSubview(nombre)
            cell.centerInView(superView: cell, container: nombre, sizeV: 40, sizeH: 250)
        }
        if seccion == "telefono" {
            telefono.delegate = self
            telefono.addBottomBorder()
            telefono.font = UIFont.init(name: "MyriadPro-Bold", size: (telefono.font?.pointSize)!)
            telefono.textColor = UIColor.gray
            telefono.text = "222 222 22 22"
            telefono.returnKeyType = .done
            telefono.keyboardType = .numberPad
            cell.addSubview(telefono)
            cell.centerInView(superView: cell, container: telefono, sizeV: 40, sizeH: 250)
        }
        if seccion == "email" {
            email.delegate = self
            email.addBottomBorder()
            email.font = UIFont.init(name: "MyriadPro-Bold", size: (email.font?.pointSize)!)
            email.textColor = UIColor.gray
            email.text = "test@mail.com"
            email.keyboardType = .emailAddress
            email.autocapitalizationType = .none
            email.returnKeyType = .done
            cell.addSubview(email)
            cell.centerInView(superView: cell, container: email, sizeV: 40, sizeH: 250)
        }
        if seccion == "guardar" {
            let guardar = UIButton(type: .system)
            guardar.clipsToBounds = true
            guardar.setTitle("Guardar", for: .normal)
            guardar.backgroundColor = UIColor.lightGray
            guardar.addTarget(self, action: #selector(actualizarDatos) , for: .touchUpInside)
            guardar.setTitleColor(UIColor.white, for: .normal)
            guardar.layer.cornerRadius = 15
            cell.addSubview(guardar)
            cell.centerInView(superView: cell, container: guardar, sizeV: 40, sizeH: 100)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let seccion = secciones[indexPath.row]
        if seccion == "nombre" || seccion == "telefono" || seccion == "email" {
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
    
}




/*
class ComidasCategoriasPaisesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cerrarBtn: UIBarButtonItem = {
        let sizeImg = CGSize(width: 24, height: 24)
        let imgClose = UIImage(named: "close")?.imageResize(sizeChange: sizeImg)
        let cerrarBtn = UIBarButtonItem(image: imgClose, style: .plain, target: self, action: #selector(closeVC) )
        cerrarBtn.tintColor = .white
        return cerrarBtn
    }()
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let secciones = ["Italiana", "Francesa", "Americana", "Asiática", "Otros"]
    
    var delegate: FoodCategorySelectedCountry?
    
    var currentFood = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = UIColor.gris
        cerrarBtn.target = self
        self.navigationItem.leftBarButtonItem = cerrarBtn
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Data Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        // cell.releaseView()
        let seccion = secciones[indexPath.row]
        if seccion == currentFood {
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.text = seccion
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seccion = secciones[indexPath.row]
        self.dismiss(animated: true, completion: {
            self.delegate?.getFoodSelected(food: seccion)
        })
    }
    
}

protocol FoodCategorySelectedCountry {
    func getFoodSelected(food: String)
}

*/




