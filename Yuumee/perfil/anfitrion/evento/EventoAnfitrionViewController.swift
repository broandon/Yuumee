//
//  EventoAnfitrionViewController.swift
//  Yuumee
//
//  Created by Easy Code on 1/4/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

class EventoAnfitrionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let backgroundImageId = "backgroundImageId"
    
    let productoExtraCell = "productoExtraCell"
    
    let fechasCell = "FechasCell"
    
    let detallesEventoCell = "DetallesEventoCell"
    
    let horarioCell = "HorarioCell"
    
    let comidaCell = "ComidaCell"
    
    let categoriaCell = "CategoriaCell"
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.register(CategoriaCell.self, forCellReuseIdentifier: categoriaCell)
        tableView.register(ComidaCell.self,    forCellReuseIdentifier: comidaCell)
        tableView.register(HorarioCell.self,   forCellReuseIdentifier: horarioCell)
        tableView.register(FechasCell.self,    forCellReuseIdentifier: fechasCell)
        tableView.register(DetallesEventoCell.self, forCellReuseIdentifier: detallesEventoCell)
        tableView.register(ProductoExtraCell.self, forCellReuseIdentifier: productoExtraCell)
        tableView.register(BackgroundImageHeader.self, forCellReuseIdentifier: backgroundImageId)
        tableView.separatorStyle  = .none
        tableView.backgroundColor = UIColor.gris
        return tableView
    }()
    
    let secciones = ["background_image", "categoria", "comida", "horario", "detalles_evento", "fechas_evento", "producto_extra", "total"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Reemplaza el titulo del back qu eviene por Default
        self.navigationController?.navigationBar.topItem?.title = "Evento"
        //self.hideKeyboardWhenTappedAround()
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
        
        if seccion == "background_image" {
            let cell = tableView.dequeueReusableCell(withIdentifier: backgroundImageId, for: indexPath)
            if let cell = cell as? BackgroundImageHeader {
                cell.selectionStyle = .none
                cell.setUpView()
                return cell
            }
        }
        
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
        
        if seccion == "detalles_evento" {
            let cell = tableView.dequeueReusableCell(withIdentifier: detallesEventoCell, for: indexPath)
            if let cell = cell as? DetallesEventoCell {
                cell.selectionStyle = .none
                cell.setUpView()
                return cell
            }
        }
        
        if seccion == "fechas_evento" {
            let cell = tableView.dequeueReusableCell(withIdentifier: fechasCell, for: indexPath)
            if let cell = cell as? FechasCell {
                cell.releaseView()
                cell.selectionStyle = .none
                cell.setUpView()
                return cell
            }
        }
        
        if seccion == "producto_extra" {
            let cell = tableView.dequeueReusableCell(withIdentifier: productoExtraCell, for: indexPath)
            if let cell = cell as? ProductoExtraCell {
                cell.releaseView()
                cell.selectionStyle = .none
                cell.setUpView()
                return cell
            }
        }
        
        if seccion == "total" {
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
            cell.releaseView()
            cell.selectionStyle = .none
            cell.addSubview(personasRecibir)
            cell.addSubview(personasRecibirInput)
            cell.addSubview(guardar)
            cell.addConstraintsWithFormat(format: "H:|-[v0(150)]-[v1]-|", views: personasRecibir, personasRecibirInput)
            cell.addConstraintsWithFormat(format: "H:[v0(120)]-|", views: guardar)
            cell.addConstraintsWithFormat(format: "V:|-[v0]", views: personasRecibir)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]-[v1(40)]", views: personasRecibirInput, guardar)
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    let personasRecibir: ArchiaBoldLabel = {
        let label  = ArchiaBoldLabel()
        label.text = "Personas a recibir:"
        label.textColor = .darkGray
        return label
    }()
    let personasRecibirInput: UITextField = {
        let textField = UITextField()
        textField.addBorder(borderColor: .gris, widthBorder: 1)
        textField.keyboardType = .numberPad
        return textField
    }()
    let guardar: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font   = UIFont(name: "ArchiaRegular", size: (button.titleLabel?.font.pointSize)!)
        button.titleLabel?.font   = UIFont.boldSystemFont(ofSize: (button.titleLabel?.font.pointSize)!)
        button.backgroundColor    = UIColor.white
        button.layer.cornerRadius = 5
        button.setTitle("Guardar", for: .normal)
        button.addBorder(borderColor: .azul, widthBorder: 2)
        button.setTitleColor(UIColor.rosa, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
        button.tintColor = UIColor.rosa
        return button
    }()
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let seccion = secciones[indexPath.row]
        if seccion == "background_image" {
            return ScreenSize.screenWidth / 2
        }
        if seccion == "categoria" {
            return 150
        }
        if seccion == "comida" {
            return 70
        }
        if seccion == "horario" {
            return 100
        }
        if seccion == "detalles_evento" {
            return ScreenSize.screenHeight
        }
        if seccion == "fechas_evento" {
            return ScreenSize.screenWidth
        }
        if seccion == "producto_extra" {
            return ScreenSize.screenHeight + (ScreenSize.screenWidth/4)
        }
        if seccion == "total" {
            return 100
        }
        return UITableView.automaticDimension
    }
    
    
}

