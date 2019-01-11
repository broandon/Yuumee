//
//  RegistroViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/11/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit

extension RegistroViewController: UITextFieldDelegate {
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == telefonoInput {
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

class RegistroViewController: BaseViewController {

    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.alwaysBounceVertical = true
        return tableView
    }()
    
    /*let facebook: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email", "public_profile"]
        return button
    }()*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        self.hideKeyboardWhenTappedAround()
        
        let regresar = UIButton(type: .system)
        regresar.setTitle("Regresar", for: .normal)
        regresar.tintColor = .white
        regresar.backgroundColor = UIColor.rosa
        regresar.addTarget(self, action: #selector(backVC) , for: .touchUpInside)
        let imageLeft = UIImage(named: "left_arrow")
        let imageLeftArrow = UIImageView(image: imageLeft)
        imageLeftArrow.image = imageLeftArrow.image?.withRenderingMode(.alwaysTemplate)
        imageLeftArrow.tintColor = UIColor.white
        let topContainer = UIView()
        topContainer.backgroundColor = .rosa
        topContainer.addSubview(regresar)
        topContainer.addSubview(imageLeftArrow)
        topContainer.addConstraintsWithFormat(format: "H:|-[v0(10)][v1]", views: imageLeftArrow, regresar)
        topContainer.addConstraintsWithFormat(format: "V:|[v0]|", views: regresar)
        topContainer.addConstraintsWithFormat(format: "V:|-16-[v0(15)]", views: imageLeftArrow)
        
        let registrate = UIButton(type: .system)
        registrate.setTitle("Resgistrate", for: .normal)
        registrate.tintColor = .white
        registrate.backgroundColor = UIColor.rosa
        registrate.addTarget(self, action: #selector(registrarse) , for: .touchUpInside)
        
        let imageRight = UIImage(named: "right_arrow")
        let imageArrow = UIImageView(image: imageRight)
        imageArrow.image = imageArrow.image?.withRenderingMode(.alwaysTemplate)
        imageArrow.tintColor = UIColor.white
        let containerBottom = UIView()
        containerBottom.backgroundColor = .rosa
        containerBottom.addSubview(registrate)
        containerBottom.addSubview(imageArrow)
        containerBottom.addConstraintsWithFormat(format: "H:[v0][v1(10)]-16-|", views: registrate, imageArrow)
        containerBottom.addConstraintsWithFormat(format: "V:|[v0]|", views: registrate)
        containerBottom.addConstraintsWithFormat(format: "V:|-17-[v0(15)]", views: imageArrow)
        
        mainView.addSubview(tableView)
        mainView.addSubview(topContainer)
        mainView.addSubview(containerBottom)
        //mainView.addSubview(facebook)
        //facebook.delegate = self
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: topContainer)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerBottom)
        //mainView.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: facebook)
        mainView.addConstraintsWithFormat(format: "V:|-[v0(50)]-[v1]-[v2(50)]-|",
                                          views: topContainer, tableView, containerBottom)
    }
    
    @objc func backVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    let dataStorage = UserDefaults.standard
    
    @objc func registrarse() {
        
        let alert = UIAlertController()
        let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(actionOk)
        
        if ((nombreInput.text?.isEmpty)!) {
            alert.message = "Ingrese su nombre para continuar"
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if ((apellidosInput.text?.isEmpty)!) {
            alert.message = "Ingrese su apellido para continuar"
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if ((correoInput.text?.isEmpty)!) {
            alert.message = "Ingrese correo eletrónico para continuar"
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if !(correoInput.text?.isEmailValid)! {
            alert.message = "Por favor ingrese un correo electrónico válido"
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if ((passInput.text?.isEmpty)!) {
            alert.message = "Ingrese una caontraseña segura para continuar"
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // ---------------------------------------------------------------------
        let headers: HTTPHeaders = [
            // "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let parameters: Parameters = ["funcion" : "newUser",
                                      "first_name" : nombreInput.text!,
                                      "last_name" : apellidosInput.text!,
                                      "phone" : telefonoInput.text!,
                                      "email" : correoInput.text!,
                                      "password" : passInput.text!,
                                      "facebook_login" : 0] as [String: Any]
        
        Alamofire.request( BaseURL.baseUrl(), method: .post, parameters: parameters,
                           encoding: ParameterQueryEncoding(),
                           headers: headers).responseJSON{ (response: DataResponse) in
                            switch(response.result) {
                            case .success(let value):
                                
                                if let result = value as? Dictionary<String, Any> {
                                    
                                    let statusMsg = result["status_msg"] as? String
                                    let state     = result["state"] as? String
                                    
                                    if state == "101" && statusMsg == "USER ALREADY EXIST" {
                                        let alert = UIAlertController(title: "Error de usuario",
                                                                      message: "Por favor verifique que su correo sea válido.",
                                                                      preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                        return;
                                    }
                                    
                                    if statusMsg == "OK" && state == "200" {
                                        
                                        if let data = result["data"] as? Dictionary<String, AnyObject> {
                                            
                                            let email = data["email"] as? String
                                            let idUser = data["id_user"] as? String
                                            let firstName = data["first_name"] as? String
                                            let lastName = data["last_name"] as? String
                                            let tipo = data["tipo"] as? String
                                            self.dataStorage.setLoggedIn(value: true)
                                            self.dataStorage.setUserId(userId: idUser!)
                                            self.dataStorage.setLastName(lastName: lastName!)
                                            self.dataStorage.setEmail(email: email!)
                                            self.dataStorage.setFirstName(firstName: firstName!)
                                            self.dataStorage.setTipo(tipo: tipo!)
                                            
                                            let vc = UbicacionViewController()
                                            let nav = UINavigationController(rootViewController: vc)
                                            self.present(nav, animated: true, completion: nil)
                                            
                                        }
                                    }
                                    
                                }
                                //completionHandler(value as? NSDictionary, nil)
                                break
                            case .failure(let error):
                                //completionHandler(nil, error as NSError?)
                                print(error)
                                print(error.localizedDescription)
                                break
                            }
        }
        // ---------------------------------------------------------------------
        
    }
    
    
    let secciones = ["nombre", "apellidos", "telefono", "correo", "contraseña"]
    
    let nombreInput = UITextField()
    let apellidosInput = UITextField()
    let telefonoInput = UITextField()
    let correoInput = UITextField()
    let passInput = UITextField()
    

}


extension RegistroViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        cell.releaseView()
        cell.selectionStyle = .none
        let seccion = secciones[indexPath.row]
        
        if seccion == "nombre" {
            let nombre = UILabel()
            nombre.text = "Nombre:"
            nombre.textColor = .gray
            nombreInput.addBottomBorder()
            nombreInput.autocapitalizationType = .none
            nombreInput.returnKeyType = .done
            cell.addSubview(nombre)
            cell.addSubview(nombreInput)
            nombreInput.delegate = self
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: nombre)
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: nombreInput)
            cell.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-|", views: nombre, nombreInput)
            
            return cell
        }
        
        if seccion == "apellidos" {
            let apellidos = UILabel()
            apellidos.text = "Apellidos:"
            apellidos.textColor = .gray
            
            apellidosInput.addBottomBorder()
            apellidosInput.autocapitalizationType = .none
            apellidosInput.returnKeyType = .done
            
            cell.addSubview(apellidos)
            cell.addSubview(apellidosInput)
            apellidosInput.delegate = self
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: apellidos)
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: apellidosInput)
            cell.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-|", views: apellidos, apellidosInput)
            
            return cell
        }
        
        
        if seccion == "telefono" {
            let telefono = UILabel()
            telefono.text = "Telefono:"
            telefono.textColor = .gray
            
            telefonoInput.addBottomBorder()
            telefonoInput.autocapitalizationType = .none
            telefonoInput.returnKeyType = .done
            telefonoInput.keyboardType = .numberPad
            
            cell.addSubview(telefono)
            cell.addSubview(telefonoInput)
            telefonoInput.delegate = self
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: telefono)
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: telefonoInput)
            cell.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-|", views: telefono, telefonoInput)
            
            return cell
        }
        
        if seccion == "correo" {
            let correo = UILabel()
            correo.text = "Correo:"
            correo.textColor = .gray
            
            correoInput.addBottomBorder()
            correoInput.keyboardType = .emailAddress
            correoInput.autocapitalizationType = .none
            correoInput.returnKeyType = .done
            
            cell.addSubview(correo)
            cell.addSubview(correoInput)
            correoInput.delegate = self
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: correo)
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: correoInput)
            cell.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-|", views: correo, correoInput)
            
            return cell
        }
        
        if seccion == "contraseña" {
            let pass = UILabel()
            pass.text = "Contraseña:"
            pass.textColor = .gray
            
            passInput.isSecureTextEntry = true
            passInput.addBottomBorder()
            passInput.returnKeyType = .done
            
            cell.addSubview(pass)
            cell.addSubview(passInput)
            passInput.delegate = self
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: pass)
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: passInput)
            cell.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-|", views: pass, passInput)
            
            return cell
        }
        
        return cell
    }
    
}




// MARK : Registro con Facebook

extension RegistroViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(" Error ")
            print(error)
            return
        }
        // "id, name, email, picture.type(large)"
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "email, first_name, last_name, picture.type(large)"]).start {
            (connection, result, error) in
            if error != nil {
                print("Peticion Fallida")
                return
            }
            
            let params = result as! Dictionary<String, Any>
            
            if let imageURL = ((params["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                // avatar = imageURL
                self.dataStorage.setAvatarFacebook(userId: imageURL)
            }
            
            let email = params["email"] as! String
            let firstName = params["first_name"] as! String
            let lastName = params["last_name"] as! String
            let paramsFacebook: Dictionary<String, Any> = [
                "first_name" : firstName as Any,
                "last_name"  : lastName as Any,
                "email"      : email as Any,
                "password"   : email as Any,
                "facebook_login" : 1,
                "funcion"    : "newUser"]
            
            let urlNewUser = URL(string: BaseURL.baseUrl())!
            Alamofire.request(urlNewUser, method: .post, parameters: paramsFacebook,
                              encoding: URLEncoding.default).responseJSON { (response) in
                                //print(response.request)
                                //print(response.response)
                                //print(response.result)
                                if let json = response.result.value {
                                    let responseRecived = json as? Dictionary<String, Any>
                                    let statusCode = responseRecived!["state"] as! String
                                    if statusCode == "200" {
                                        let datosUsuario = responseRecived!["data"] as! Dictionary<String, Any>
                                        /*var nameFiltered: String = ""
                                        if let firstName: String = params["first_name"] as! String? {
                                            if firstName.lowercased().range(of: "optional") != nil {
                                                let start = firstName.index(firstName.startIndex, offsetBy: 10)
                                                let end = firstName.index(firstName.endIndex, offsetBy: -2)
                                                let result = firstName[start..<end] // The result is of type Substring
                                                nameFiltered = String(result)
                                            }
                                            else{
                                                nameFiltered = firstName
                                            }
                                        }
                                        var lastNameFiltered: String = ""
                                        if let lastName = params["last_name"] as! String? {
                                            if lastName.lowercased().range(of: "optional") != nil {
                                                let start = lastName.index(lastName.startIndex, offsetBy: 10)
                                                let end = lastName.index(lastName.endIndex, offsetBy: -2)
                                                let result = lastName[start..<end] // The result is of type Substring
                                                lastNameFiltered = String(result)
                                            }
                                            else{
                                                lastNameFiltered = lastName
                                            }
                                        }
                                        
                                        // -------------------------------------
                                        var emailFiltered: String = ""
                                        if let email = params["email"] as! String? {
                                            if email.lowercased().range(of: "optional") != nil {
                                                let start = email.index(email.startIndex, offsetBy: 10)
                                                let end = email.index(email.endIndex, offsetBy: -2)
                                                let result = email[start..<end] // The result is of type Substring
                                                emailFiltered = String(result)
                                            }
                                            else{
                                                emailFiltered = email
                                            }
                                        }*/
                                        
                                        let idUser = datosUsuario["id_user"] as! String
                                        // -------------------------------------
                                        self.dataStorage.setUserId(userId: idUser)
                                        self.dataStorage.setLoggedIn(value: true)
                                        self.dataStorage.setLoggedInFacebook(value: true)
                                        self.dataStorage.setFirstName(firstName: firstName)
                                        self.dataStorage.setLastName(lastName: lastName)
                                        self.dataStorage.setEmail(email: email)
                                        // -------------------------------------
                                        
                                        let vc = UbicacionViewController()
                                        let nav = UINavigationController(rootViewController: vc)
                                        self.present(nav, animated: true, completion: nil)
                                    }
                                    else{
                                        Utils.showSimpleAlert(message: "Ocurrió un error al registrarse, intente más tarde.", context: self, success: nil)
                                        return
                                    }
                                }
                                else {
                                    Utils.showSimpleAlert(message: "Ocurrió un error al realizar la petición, intente más tarde.", context: self, success: nil)
                                    return
                                }
            }
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        // print(" loginButtonDidLogOut ")
    }
    
    @objc func gettoken() {
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"],
                                  from: self,
                                  handler: { (result, error) in
                                    if error != nil {
                                        print(" Error Login FBSDKManager ")
                                        //print(error)
                                        return
                                    }
                                    let token = result?.token.tokenString
                                    let alertToken = UIAlertController(title: "Token",
                                                                       message: token,
                                                                       preferredStyle: UIAlertController.Style.alert)
                                    alertToken.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                    self.present(alertToken, animated: true, completion: nil)
        })
    }
    
}


