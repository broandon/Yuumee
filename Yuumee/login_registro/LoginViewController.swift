//
//  LoginViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/11/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit

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
    
    
    @objc func iniciaSesion() {
        let vc = UbicacionViewController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    
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
            
            let correoInput = UITextField()
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
            
            let passInput = UITextField()
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
