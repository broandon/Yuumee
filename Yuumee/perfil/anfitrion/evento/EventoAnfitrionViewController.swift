//
//  EventoAnfitrionViewController.swift
//  Yuumee
//
//  Created by Easy Code on 1/4/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

class EventoAnfitrionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
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
            personasRecibirInput.inputAccessoryView = toolbarPicker
            personasRecibirInput.inputView = picker
            return cell
        }
        
        return UITableViewCell()
    }
    
    // # de personas a recibir...
    let personasRecibir: ArchiaBoldLabel = {
        let label  = ArchiaBoldLabel()
        label.text = "Personas a recibir:"
        label.textColor = .darkGray
        return label
    }()
    let personasRecibirInput: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.addBorder(borderColor: .gris, widthBorder: 1)
        return textField
    }()
    let guardar: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font   = UIFont(name: "ArchiaRegular", size: (button.titleLabel?.font.pointSize)!)
        button.titleLabel?.font   = UIFont.boldSystemFont(ofSize: (button.titleLabel?.font.pointSize)!)
        button.backgroundColor    = UIColor.white
        button.layer.cornerRadius = 5
        button.tintColor          = UIColor.rosa
        button.setTitle("Guardar", for: .normal)
        button.addBorder(borderColor: .azul, widthBorder: 2)
        button.setTitleColor(UIColor.rosa, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
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
            return 120
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
    
    // MARK: UIPicker
    
    lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        return picker
    }()
    var pickerData: [String] = ["1", "2", "3", "4", "5"]
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
   
    
    private lazy var toolbarPicker: UIToolbar = {
        let rect    = CGRect(x: 0, y: 0, width: ScreenSize.screenWidth, height: 40)
        let toolbar = UIToolbar(frame: rect)
        self.embedButtons(toolbar)
        return toolbar
    }()
    private func embedButtons(_ toolbar: UIToolbar) {
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelPressed) )
        let doneButton = UIBarButtonItem(title: "Ok", style: .done, target: self, action: #selector(donePressed))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([cancelButton, flexButton, doneButton], animated: true)
    }
    
    @objc func cancelPressed() {
        personasRecibirInput.resignFirstResponder()
    }
    
    
    @objc func donePressed() {
        let selectedValue = pickerData[picker.selectedRow(inComponent: 0)]
        personasRecibirInput.text = "\(selectedValue)"
        personasRecibirInput.resignFirstResponder()
        /*
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "es_MX")
        timeFormatter.timeStyle = DateFormatter.Style.short
        let strDate = timeFormatter.string(from: pickerView.date)
        if comienzaIsSelected {
            comienzaInput.text = strDate
            comienzaInput.resignFirstResponder();
        }else{
            terminaInput.text = strDate
            terminaInput.resignFirstResponder();
        }
        */
    }
    
    
    
}

