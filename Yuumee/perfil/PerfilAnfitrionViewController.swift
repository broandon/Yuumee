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
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.separatorStyle  = .none
        tableView.backgroundColor = UIColor.gris
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.register(BackgroundImageHeader.self, forCellReuseIdentifier: backgroundImageId)
        tableView.register(InformacionAnfitrionCell.self, forCellReuseIdentifier: informacionAnfitrionCell)
        return tableView
    }()
    
    
    let secciones = ["background_image", "info"]
    
    let eventos = ["", "", "", "", ""]
    
    let dataStorage = UserDefaults.standard
    
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return secciones.count
        }
        return eventos.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = indexPath.section
        let currentRow     = indexPath.row
        if currentSection == 0 {
            let section = secciones[currentRow]
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
        }
        
        if currentSection == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
            let titulo = ArchiaBoldLabel()
            titulo.textColor = .rosa
            titulo.text = "Desayuno anfitrión"
            let descripcion = ArchiaRegularLabel()
            descripcion.text = "Desayuno completo"
            let tipoMenu = ArchiaRegularLabel()
            tipoMenu.textColor = .verde
            tipoMenu.text = "Menú: Comida"
            let fecha = ArchiaRegularLabel()
            fecha.text = "Fecha: 24 de enero 2019"
            let horario = ArchiaRegularLabel()
            horario.text = "Horario: 07:00 - 10:00"
            let capacidad = ArchiaRegularLabel()
            capacidad.text = "Capacidad: 1"
            let costo = ArchiaRegularLabel()
            costo.text = "Costo: $ 55.0 mxn"
            let button = UIButton(type: .system)
            button.titleLabel?.font   = UIFont(name: "ArchiaRegular", size: (button.titleLabel?.font.pointSize)!)
            button.titleLabel?.font   = UIFont.boldSystemFont(ofSize: (button.titleLabel?.font.pointSize)!)
            button.backgroundColor    = UIColor.white
            button.layer.cornerRadius = 5
            button.setTitle("Cancelar", for: .normal)
            button.addBorder(borderColor: .azul, widthBorder: 2)
            button.setTitleColor(UIColor.rosa, for: .normal)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
            button.tintColor = UIColor.rosa
            
            let sep = UIView()
            sep.backgroundColor = .black
            
            cell.addSubview(titulo)
            cell.addSubview(descripcion)
            cell.addSubview(tipoMenu)
            cell.addSubview(fecha)
            cell.addSubview(horario)
            cell.addSubview(capacidad)
            cell.addSubview(costo)
            cell.addSubview(button)
            cell.addSubview(sep)
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: titulo)
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: descripcion)
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: tipoMenu)
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: fecha)
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: horario)
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: capacidad)
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: costo)
            cell.addConstraintsWithFormat(format: "H:[v0(120)]-|", views: button)
            cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: sep)
            cell.addConstraintsWithFormat(format: "V:|[v0(30)]-[v1(30)]-[v2(30)]-[v3(30)]-[v4(30)]-[v5(30)]-[v6(40)]-[v7(30)]-[v8(1)]",
                                          views: titulo, descripcion, tipoMenu, fecha, horario, capacidad, costo, button, sep)
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = indexPath.section
        let currentRow     = indexPath.row
        
        if currentSection == 0 {
            
            let section = secciones[currentRow]
            if section == "background_image" {
                return ScreenSize.screenWidth / 2
            }
            if section == "info" {
                return ScreenSize.screenHeight - (ScreenSize.screenWidth*0.3)
            }
            
        }
        
        if currentSection == 1 {
            return 320
        }
        
        return UITableView.automaticDimension
    }
    
    
    
}
