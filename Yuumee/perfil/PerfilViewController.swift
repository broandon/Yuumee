//
//  PerfilViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/13/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit

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
    
    let secciones = ["perfil", "historial", "metodos_pago", "tarjetas"]
    
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
        cell.textLabel?.font = UIFont.init(name: (cell.textLabel?.font.familyName)!, size: 24)
        
        if seccion == "perfil" {
            cell.textLabel?.text = "Perfil"
            let avatarImg = UIImage(named: "avatar")
            let avatar = UIImageView(image: avatarImg)
            cell.addSubview(avatar)
            cell.addConstraintsWithFormat(format: "H:[v0(40)]-|", views: avatar)
            cell.addConstraintsWithFormat(format: "V:|-16-[v0(40)]", views: avatar)
        }
        
        if seccion == "historial" {
            cell.textLabel?.text = "Historal de eventos"
            let avatarImg = UIImage(named: "avatar")
            let avatar = UIImageView(image: avatarImg)
            cell.addSubview(avatar)
            cell.addConstraintsWithFormat(format: "H:[v0(40)]-|", views: avatar)
            cell.addConstraintsWithFormat(format: "V:|-16-[v0(40)]", views: avatar)
        }
        
        if seccion == "metodos_pago" {
            cell.textLabel?.text = "Método de pago"
            let avatarImg = UIImage(named: "avatar")
            let avatar = UIImageView(image: avatarImg)
            cell.addSubview(avatar)
            cell.addConstraintsWithFormat(format: "H:[v0(40)]-|", views: avatar)
            cell.addConstraintsWithFormat(format: "V:|-16-[v0(40)]", views: avatar)
        }
        
        if seccion == "tarjetas" {
            cell.textLabel?.text = "Tarjetas"
            let avatarImg = UIImage(named: "avatar")
            let avatar = UIImageView(image: avatarImg)
            cell.addSubview(avatar)
            cell.addConstraintsWithFormat(format: "H:[v0(40)]-|", views: avatar)
            cell.addConstraintsWithFormat(format: "V:|-16-[v0(40)]", views: avatar)
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
        return 70.0 // UITableViewAutomaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentRow = indexPath.row
        let seccion = secciones[currentRow]
        
        if seccion == "perfil" {
            let vc = PerfilAnfitrionViewController() // PerfilUsuarioViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if seccion == "historial" {
            //
        }
        
        if seccion == "metodos_pago" {
            let vc = MetodoDePagoViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        if seccion == "tarjetas" {
            let vc = TarjetasViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
    }
    
}



