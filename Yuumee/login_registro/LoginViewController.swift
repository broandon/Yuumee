//
//  LoginViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/11/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: BaseViewController {

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
        topContainer.addConstraintsWithFormat(format: "H:|[v0(10)][v1]", views: imageLeftArrow, regresar)
        topContainer.addConstraintsWithFormat(format: "V:|[v0]", views: regresar)
        topContainer.addConstraintsWithFormat(format: "V:|-[v0(15)]", views: imageLeftArrow)
        
        
        let iniciarSesion = UIButton(type: .system)
        iniciarSesion.setTitle("Iniciar sesión", for: .normal)
        iniciarSesion.tintColor = .white
        iniciarSesion.backgroundColor = UIColor.rosa
        iniciarSesion.addTarget(self, action: #selector(iniciaSesion) , for: .touchUpInside)
        
        let imageRight = UIImage(named: "right_arrow")
        let imageArrow = UIImageView(image: imageRight)
        imageArrow.image = imageArrow.image?.withRenderingMode(.alwaysTemplate)
        imageArrow.tintColor = UIColor.white
        let containerBottom = UIView()
        containerBottom.backgroundColor = .rosa
        containerBottom.addSubview(iniciarSesion)
        containerBottom.addSubview(imageArrow)
        containerBottom.addConstraintsWithFormat(format: "H:[v0][v1(10)]|", views: iniciarSesion, imageArrow)
        containerBottom.addConstraintsWithFormat(format: "V:|[v0]", views: iniciarSesion)
        containerBottom.addConstraintsWithFormat(format: "V:|-[v0(15)]", views: imageArrow)
        
        mainView.addSubview(tableView)
        mainView.addSubview(topContainer)
        mainView.addSubview(containerBottom)
        
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: topContainer)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerBottom)
        mainView.addConstraintsWithFormat(format: "V:|-[v0(50)]-[v1]-[v2(50)]|",
                                          views: topContainer, tableView, containerBottom)
    }
    
    @objc func backVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    let dataStorage = UserDefaults.standard
    
    @objc func iniciaSesion() {
        
        let alert = UIAlertController()
        let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(actionOk)
        
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
        
        let parameters: Parameters = ["funcion" : "login",
                                      "email" : correoInput.text!,
                                      "password" : passInput.text!,
                                      "facebook_login" : "0"] as [String: Any]
        
        Alamofire.request( BaseURL.baseUrl() , method: .post,
                           parameters: parameters,
                           encoding: ParameterQueryEncoding(),
                           headers: headers).responseJSON{ (response: DataResponse) in
                            switch(response.result) {
                            case .success(let value):
                                
                                if let result = value as? Dictionary<String, Any> {
                                    
                                    let statusMsg = result["status_msg"] as? String
                                    let state     = result["state"] as? String
                                    
                                    if state == "101" && statusMsg == "User not found" {
                                        let alert = UIAlertController(title: "Error de usuario",
                                                                      message: "Por favor verifique que su correo sea válido.",
                                                                      preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                        return;
                                    }
                                    
                                    if state == "101" && statusMsg == "Incorrect Password" {
                                        let alert = UIAlertController(title: "Error de contraseña",
                                                                      message: "Por favor verifique su contraseña.",
                                                                      preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                        return;
                                    }
                                    
                                    if statusMsg == "OK" && state == "200" {
                                        if let data = result["data"] as? Dictionary<String, AnyObject> {
                                            
                                            let email = data["email"] as? String
                                            let name = data["first_name"] as? String
                                            let idUser = data["id_user"] as? String
                                            let lastName = data["last_name"] as? String
                                            let tipo = data["tipo"] as? String
                                            
                                            self.dataStorage.setLoggedIn(value: true)
                                            self.dataStorage.setUserId(userId: idUser!)
                                            self.dataStorage.setLastName(lastName: lastName!)
                                            self.dataStorage.setEmail(email: email!)
                                            self.dataStorage.setFirstName(firstName: name!)
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
    
    
    let correoInput = UITextField()
    
    let passInput = UITextField()
    
    
    
    let secciones = ["correo", "contraseña"]
    
}


extension LoginViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        if seccion == "correo" {
            let correo = UILabel()
            correo.text = "Correo:"
            correo.textColor = .gray
            
            correoInput.addBottomBorder()
            correoInput.keyboardType = .emailAddress
            correoInput.autocapitalizationType = .none
            cell.addSubview(correo)
            cell.addSubview(correoInput)
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
            cell.addSubview(pass)
            cell.addSubview(passInput)
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: pass)
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: passInput)
            cell.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-|", views: pass, passInput)
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
