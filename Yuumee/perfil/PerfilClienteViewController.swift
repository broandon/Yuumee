//
//  PerfilClienteViewController.swift
//  Yuumee
//
//  Created by Luis Segoviano on 1/15/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

class PerfilClienteViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    let defaultReuseID = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultReuseID)
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let secciones = ["mis_datos", "push", "aviso", "salir"]
    
    let switchPush: CustomSwitch = {
        let switchP = CustomSwitch(frame: CGRect(x: 50, y: 50, width: 55, height: 25))
        //switchPush.isOn = false
        switchP.onTintColor = UIColor.lightGray
        switchP.offTintColor = UIColor.darkGray
        switchP.cornerRadius = 0.5
        switchP.thumbCornerRadius = 0.5
        switchP.thumbSize = CGSize(width: 30, height: 30)
        switchP.thumbTintColor = UIColor.rosa
        switchP.padding = 0
        switchP.animationDuration = 0.25
        //switchP.addBorder(borderColor: UIColor.gris, widthBorder: 1)
        return switchP
    }()
    
    lazy var closeIcon: UIBarButtonItem = {
        let size = CGSize(width: 24.0, height: 24.0)
        let image = UIImage(named: "close")?.imageResize(sizeChange: size)
        let b = UIButton(type: .system)
        b.setImage(image, for: .normal)
        b.addTarget(self, action: #selector(close), for: .touchUpInside)
        b.tintColor = .white
        b.addBorder(borderColor: .white, widthBorder: 1)
        b.layer.cornerRadius = 5
        b.imageView?.contentMode = .scaleAspectFit
        let buttonItem = UIBarButtonItem(customView: b)
        return buttonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        //self.navigationItem.leftBarButtonItem = closeIcon
        
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func activateNotifications() {
        
        let isActivated = switchPush.isOn
        if isActivated {
            print(" si lo es ")
        }
        else{
            print(" NO lo es ")
        }
        print(" !self.switchPush.isOn: \(!self.switchPush.isOn) ")
        /*
         switchNotifications.addTarget(self, action: #selector(switchValueDidChange), for: .valueChanged)
         if dataStorage.isNotificationActivated()! {
         switchNotifications.isOn = true
         }
         else{
         switchNotifications.isOn = false
         }
         self.switchPush.setOn(on: !self.switchPush.isOn, animated: true)
         */
    }
    
    // Delegate & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseID, for: indexPath)
        cell.backgroundColor = .clear
        let seccion = secciones[indexPath.row]
        let size = CGSize(width: 24, height: 24)
        cell.textLabel?.font = UIFont.init(name: "MyriadPro-Regular",
                                           size: (cell.textLabel?.font.pointSize)!)
        if seccion == "mis_datos" {
            cell.textLabel?.text = "Datos"
            let imageArrow = UIImage(named: "right_arrow")?.imageResize(sizeChange: size)
            let detailArrow = UIImageView(image: imageArrow)
            cell.accessoryView = detailArrow
        }
        
        if seccion == "push" {
            cell.textLabel?.text = "Push"
            switchPush.addTarget(self, action: #selector(activateNotifications),
                                 for: .valueChanged)
            cell.accessoryView = switchPush
            cell.selectionStyle = .none
            return cell
        }
        
        if seccion == "aviso" {
            cell.textLabel?.text = "Aviso"
            let imageArrow = UIImage(named: "right_arrow")?.imageResize(sizeChange: size)
            let detailArrow = UIImageView(image: imageArrow)
            cell.accessoryView = detailArrow
        }
        
        if seccion == "salir" {
            cell.textLabel?.text = "Cerrar"
            let sizeForClose = CGSize(width: 28, height: 24)
            let imageArrow = UIImage(named: "salir")?.imageResize(sizeChange: sizeForClose)
            let detailArrow = UIImageView(image: imageArrow)
            cell.accessoryView = detailArrow
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let seccion = secciones[indexPath.row]
        
        if seccion == "mis_datos" {
            let viewController = MisDatosViewController()
            let nav = UINavigationController(rootViewController: viewController)
            self.present(nav, animated: true, completion: nil)
        }
        
        if seccion == "aviso" {
            let viewController = WebViewController()
            viewController.titleVC = ""
            viewController.url = "http://easycode.mx/solestra/img/Privacidad/terminos.pdf"
            let nav = UINavigationController(rootViewController: viewController)
            self.present(nav, animated: true, completion: nil)
            //self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        
    }
    

}
