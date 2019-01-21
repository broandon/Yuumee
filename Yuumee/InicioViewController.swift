//
//  InicioViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/13/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit

class InicioViewController: BaseViewController {

    let facebook: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage( UIImage(named: "focebook_login") , for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let registrate: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Registrate", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.rojo
        button.layer.cornerRadius = 15
        return button
    }()
    
    let iniciaSesionAqui: UILabel = {
        let label = UILabel()
        //                                     Sangria necesaria para el underline
        label.text = "Ya tienes un cuenta, inicia sesión    "
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.rosa
        label.adjustsFontForContentSizeCategory = true
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        label.underline()
        return label
    }()
    
    
    
    // -------------------------------------------------------------------------
    let omitir: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Omitir", for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.rosa
        return button
    }()
    let imageArrow: UIImageView = {
        let image = UIImage(named: "right_arrow")
        let imageView = UIImageView(image: image)
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        return imageView
    }()
    let containerBottom: UIView = {
        let view = UIView()
        view.backgroundColor = .rosa
        return view
    }()
    // -------------------------------------------------------------------------
    
    
    let buttonFacebook: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email", "public_profile"]
        return button
    }()
    
    let dataStorage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        mainView.addSubview(buttonFacebook)
        buttonFacebook.delegate = self
        
        mainView.addSubview(buttonFacebook)
        mainView.addSubview(registrate)
        mainView.addSubview(iniciaSesionAqui)
        mainView.addSubview(containerBottom)
        mainView.addConstraintsWithFormat(format: "H:|-64-[v0]-64-|", views: buttonFacebook)
        mainView.addConstraintsWithFormat(format: "H:|-64-[v0]-64-|", views: registrate)
        mainView.addConstraintsWithFormat(format: "H:|-[v0]-|", views: iniciaSesionAqui)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerBottom)
        let topMargin = mainView.bounds.height/4
        mainView.addConstraintsWithFormat(format: "V:|-\(topMargin)-[v0(40)]-[v1(40)]-20-[v2]-(>=8)-[v3(45)]|",
            views: buttonFacebook, registrate, iniciaSesionAqui, containerBottom)
        containerBottom.addSubview(omitir)
        containerBottom.addSubview(imageArrow)
        containerBottom.addConstraintsWithFormat(format: "H:[v0][v1(10)]-16-|", views: omitir, imageArrow)
        containerBottom.addConstraintsWithFormat(format: "V:|[v0]|", views: omitir)
        containerBottom.addConstraintsWithFormat(format: "V:|-16-[v0(15)]", views: imageArrow)
        registrate.addTarget(self, action: #selector(registro) , for: .touchUpInside)
        let inicioSesion = UITapGestureRecognizer(target: self, action: #selector(login))
        inicioSesion.numberOfTapsRequired = 1
        iniciaSesionAqui.addGestureRecognizer(inicioSesion)
        omitir.addTarget(self, action: #selector(omitirEvent) , for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    
    @objc func registro() {
        let vc = RegistroViewController()
        //self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func login() {
        let vc = LoginViewController()
        //self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func omitirEvent() {
        
        let vc = UbicacionViewController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
        
        /*
        let timeLineVC = TimeLineViewController()
        timeLineVC.title = "TIMELINE"
        let navTimeLine = UINavigationController(rootViewController: timeLineVC)
        let categoriasVC = CategoriasViewController()
        categoriasVC.title = "CATEGORIAS"
        let navCategorias = UINavigationController(rootViewController: categoriasVC)
        let mensajesVC = MensajesViewController()
        mensajesVC.title = "MENSAJES"
        let navMensajes = UINavigationController(rootViewController: mensajesVC)
        let perfilVC = PerfilViewController()
        perfilVC.title = "PERFIL"
        let navPerfil = UINavigationController(rootViewController: perfilVC)
        let tabBar = UITabBarController()
        tabBar.viewControllers = [navTimeLine, navCategorias, navMensajes, navPerfil]
        let timeLine = tabBar.tabBar.items![0]
        timeLine.image = UIImage(named: "timeline")?.withRenderingMode(.alwaysTemplate)
        let categorias = tabBar.tabBar.items![1]
        categorias.image = UIImage(named: "categorias")?.withRenderingMode(.alwaysTemplate)
        let mensajes = tabBar.tabBar.items![2]
        mensajes.image = UIImage(named: "mensajes")?.withRenderingMode(.alwaysTemplate)
        let perfil = tabBar.tabBar.items![3]
        perfil.image = UIImage(named: "perfil")?.withRenderingMode(.alwaysTemplate)
        UITabBar.appearance().tintColor = UIColor.rosa
        UITabBar.appearance().unselectedItemTintColor = UIColor.azul
        self.present(tabBar, animated: true, completion: nil)
        return
        */
    }

}



// MARK : Registro con Facebook

extension InicioViewController: FBSDKLoginButtonDelegate {
    
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
            /*
            print(" \n\n ")
            print(" params ")
            print(params)
            print(" \n\n ")
            */
            if let imageURL = ((params["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                //avatar = imageURL
                self.dataStorage.setAvatarFacebook(userId: imageURL)
            }
            let email = params["email"] as! String
            let firstName = params["first_name"] as! String
            let lastName = params["last_name"] as! String
            let paramsFacebook: Dictionary<String, Any> = ["first_name" : firstName as Any,
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
                                    
                                    let statusMsg  = responseRecived!["status_msg"] as? String
                                    let statusCode = responseRecived!["state"] as? String
                                    
                                    //let statusCode = responseRecived!["state"] as! String
                                    
                                    if statusCode == "101" && statusMsg == "User not found"  {
                                        // Cierra sesion de Facebook
                                        let loginManager = FBSDKLoginManager()
                                        loginManager.logOut()
                                        let alert = UIAlertController(title: "Error de usuario",
                                                                      message: "Por favor verifique que su correo sea válido.",
                                                                      preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                        return;
                                    }
                                    
                                    if statusCode == "200" {
                                        let datosUsuario = responseRecived!["data"] as! Dictionary<String, Any>
                                        
                                        var nameFiltered: String = ""
                                        if let firstName: String = datosUsuario["first_name"] as! String? {
                                            if firstName.lowercased().range(of: "optional") != nil {
                                                let start = firstName.index(firstName.startIndex, offsetBy: 10)
                                                let end = firstName.index(firstName.endIndex, offsetBy: -2)
                                                let result = firstName[start..<end]
                                                nameFiltered = String(result)
                                            }
                                            else{
                                                nameFiltered = firstName
                                            }
                                        }
                                        var lastNameFiltered: String = ""
                                        if let lastName = datosUsuario["last_name"] as! String? {
                                            if lastName.lowercased().range(of: "optional") != nil {
                                                let start = lastName.index(lastName.startIndex, offsetBy: 10)
                                                let end = lastName.index(lastName.endIndex, offsetBy: -2)
                                                let result = lastName[start..<end]
                                                lastNameFiltered = String(result)
                                            }
                                            else{
                                                lastNameFiltered = lastName
                                            }
                                        }
                                        var emailFiltered: String = ""
                                        if let email = datosUsuario["email"] as! String? {
                                            if email.lowercased().range(of: "optional") != nil {
                                                let start = email.index(email.startIndex, offsetBy: 10)
                                                let end = email.index(email.endIndex, offsetBy: -2)
                                                let result = email[start..<end]
                                                emailFiltered = String(result)
                                            }
                                            else{
                                                emailFiltered = email
                                            }
                                        }
                                        let idUser = datosUsuario["id_user"] as! String
                                        // -------------------------------------
                                        
                                        self.dataStorage.setUserId(userId: idUser)
                                        self.dataStorage.setLoggedIn(value: true)
                                        self.dataStorage.setLoggedInFacebook(value: true)
                                        self.dataStorage.setLastName(lastName: lastNameFiltered)
                                        self.dataStorage.setEmail(email: emailFiltered)
                                        self.dataStorage.setFirstName(firstName: nameFiltered)
                                        
                                        let vc = UbicacionViewController()
                                        let nav = UINavigationController(rootViewController: vc)
                                        self.present(nav, animated: true, completion: nil)
                                    }
                                    else{
                                        Utils.showSimpleAlert(message: "Ocurrió un error al registrarse, intente más tarde.",
                                                              context: self,
                                                              success: nil)
                                        return
                                    }
                                }
                                else {
                                    Utils.showSimpleAlert(message: "Ocurrió un error al realizar la petición, intente más tarde.",
                                                          context: self,
                                                          success: nil)
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



