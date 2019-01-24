//
//  PerfilViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/13/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class PerfilViewController: BaseViewController {
    
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView() // frame: CGRect.zero, style: .grouped
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    override func viewDidLoad() {
        mainView.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        
        // ------------------------------- Datos -------------------------------
        //below code write in view did appear()
        let swipeRight = UISwipeGestureRecognizer(target: self, action:  #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        // below code create swipe gestures function
        
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
    }
    
    
    // MARK: - swiped
    @objc  func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if (self.tabBarController?.selectedIndex)! < 3
            { // set here  your total tabs
                self.tabBarController?.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
            }
        }
    }
    
    let secciones = ["perfil", "reservas", "aviso", "cerrar_sesion"]
    
    let dataStorage = UserDefaults.standard
    
}




extension PerfilViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentRow = indexPath.row
        let seccion = secciones[currentRow]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.textColor = UIColor.darkGray
        cell.textLabel?.font = UIFont.init(name: (cell.textLabel?.font.familyName)!, size: 18)
        
        if seccion == "perfil" {
            cell.textLabel?.text = "Perfil"
            let avatarImg = UIImage(named: "chef_rosa")
            let avatar = UIImageView(image: avatarImg)
            cell.addSubview(avatar)
            cell.addConstraintsWithFormat(format: "H:[v0(24)]-|", views: avatar)
            cell.addConstraintsWithFormat(format: "V:|-16-[v0(24)]", views: avatar)
        }
        
        
        if seccion == "reservas" {
            cell.textLabel?.text = "Reservas activas"
            let avatarImg = UIImage(named: "reservar")
            let avatar = UIImageView(image: avatarImg)
            cell.addSubview(avatar)
            cell.addConstraintsWithFormat(format: "H:[v0(24)]-|", views: avatar)
            cell.addConstraintsWithFormat(format: "V:|-16-[v0(24)]", views: avatar)
        }
        
        if seccion == "aviso" {
            cell.textLabel?.text = "Aviso de privacidad"
            let avatarImg = UIImage(named: "aviso_privacidad")
            let avatar = UIImageView(image: avatarImg)
            cell.addSubview(avatar)
            cell.addConstraintsWithFormat(format: "H:[v0(24)]-|", views: avatar)
            cell.addConstraintsWithFormat(format: "V:|-16-[v0(24)]", views: avatar)
        }
        
        if seccion == "cerrar_sesion" {
            cell.textLabel?.text = "Cerrar sesión"
            let avatarImg = UIImage(named: "power")
            let avatar = UIImageView(image: avatarImg)
            avatar.image = avatar.image!.withRenderingMode(.alwaysTemplate)
            avatar.tintColor = UIColor.rosa
            cell.addSubview(avatar)
            cell.addConstraintsWithFormat(format: "H:[v0(24)]-|", views: avatar)
            cell.addConstraintsWithFormat(format: "V:|-16-[v0(24)]", views: avatar)
        }
        
        let sep = UIView()
        sep.backgroundColor = UIColor.rosa
        sep.layer.cornerRadius = 2
        cell.addSubview(sep)
        cell.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: sep)
        cell.addConstraintsWithFormat(format: "V:[v0(1)]|", views: sep)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //let currentSection = indexPath.section
        //let currentRow = indexPath.row
        return 50.0 // UITableViewAutomaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentRow = indexPath.row
        let seccion = secciones[currentRow]
        
        if seccion == "perfil" {
            let vc = PerfilAnfitrionViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if seccion == "reservas" {
            let vc = ReservasViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        /*if seccion == "historial" {
            let vc = HistorialEventosViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if seccion == "metodos_pago" {
            let vc = TarjetasViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }*/
        
        if seccion == "aviso" {
            let viewController = WebViewController()
            viewController.titleVC = ""
            viewController.url = "http://easycode.mx/solestra/img/Privacidad/terminos.pdf"
            let nav = UINavigationController(rootViewController: viewController)
            self.present(nav, animated: true, completion: nil)
            //self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        
        if seccion == "cerrar_sesion" {
            let refreshAlert = UIAlertController(title: "Cerrar Sesión",
                                                 message: "¿Realmete desea cerrarsu sesión?",
                                                 preferredStyle: UIAlertController.Style.alert)
            refreshAlert.addAction(UIAlertAction(title: "Aceptar", style: .default,
                                                 handler: { (action: UIAlertAction!) in
                                                    
                                                    let dictionary = self.dataStorage.dictionaryRepresentation()
                                                    dictionary.keys.forEach { key in
                                                        self.dataStorage.removeObject(forKey: key)
                                                    }
                                                    
                                                    self.dataStorage.setUserId(userId: "")
                                                    self.dataStorage.setLoggedIn(value: false)
                                                    self.dataStorage.setFirstName(firstName: "")
                                                    self.dataStorage.setLastName(lastName: "")
                                                    self.dataStorage.setEmail(email: "")
                                                    self.dataStorage.setTipo(tipo: "")
                                                    self.dataStorage.setLoggedInFacebook(value: false)
                                                    self.dataStorage.setAvatarFacebook(userId: "")
                                                    
                                                    // Cierra sesion de Facebook
                                                    let loginManager = FBSDKLoginManager()
                                                    loginManager.logOut()
                                                    
                                                    let vc = InicioViewController()
                                                    //let nav = UINavigationController(rootViewController: vc)
                                                    self.present(vc, animated: true, completion: nil)
                                                    
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            self.present(refreshAlert, animated: true, completion: nil)
            
        }
        
    }
    
}


