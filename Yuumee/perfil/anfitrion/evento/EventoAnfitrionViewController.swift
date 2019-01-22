//
//  EventoAnfitrionViewController.swift
//  Yuumee
//
//  Created by Easy Code on 1/4/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

class EventoAnfitrionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        tableView.separatorStyle  = .none
        tableView.backgroundColor = UIColor.gris
        return tableView
    }()
    
    let secciones = ["categoria", "comida", "horario", "detalles_evento", "fechas_evento", "producto_extra"]
    
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
        
        /*if seccion == "detalles_evento" {
            let cell = tableView.dequeueReusableCell(withIdentifier: detallesEventoCell, for: indexPath)
            if let cell = cell as? DetallesEventoCell {
                cell.selectionStyle = .none
                cell.setUpView()
                return cell
            }
        }*/
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        cell.addBorder()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let seccion = secciones[indexPath.row]
        if seccion == "categoria" || seccion == "comida" {
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
            return ScreenSize.screenWidth
        }
        
        return UITableView.automaticDimension
    }
    
    
}










class ProductoExtraCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    let productoExtra: UILabel = {
        let label = UILabel()
        label.text = "Producto extra"
        label.borders(for: [.top, .bottom], width: 1.0, color: UIColor.verde)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    let contentBebidas: UIView = {
        let view = UIView()
        return view
    }()
    
    let sep: UIView = {
        let view = UIView()
        view.backgroundColor = .verde
        return view
    }()
    
    let contentPostres: UIView = {
        let view = UIView()
        return view
    }()
    
    
    let bebidas: ArchiaBoldLabel = {
        let label  = ArchiaBoldLabel()
        label.text = "Bebidas"
        label.textAlignment = .center
        label.textColor     = .rosa
        return label
    }()
    
    let postres: ArchiaBoldLabel = {
        let label  = ArchiaBoldLabel()
        label.text = "Postres"
        label.textAlignment = .center
        label.textColor     = .rosa
        return label
    }()
    
    
    let width = (ScreenSize.screenWidth - 50) / 2
    
    
    
    private func getOpcionLabel(text: String) -> UILabel {
        let label  = UILabel()
        label.text = text
        return label
    }
    private func getCostoLabel() -> UILabel {
        let label  = UILabel()
        label.text = "Costo:"
        return label
    }
    private func getOpcionTextField() -> UITextField {
        let textField  = UITextField()
        return textField
    }
    private func getCostoTextField() -> UITextField {
        let textField  = UITextField()
        return textField
    }
    
    var opcion1Label: UILabel!
    var costo1Label: UILabel!
    var opcion1Input: UITextField!
    var costo1Input: UITextField!
    
    var opcion2Label: UILabel!
    var costo2Label: UILabel!
    var opcion2Input: UITextField!
    var costo2Input: UITextField!
    
    var opcion3Label: UILabel!
    var costo3Label: UILabel!
    var opcion3Input: UITextField!
    var costo3Input: UITextField!
    
    var opcion4Label: UILabel!
    var costo4Label: UILabel!
    var opcion4Input: UITextField!
    var costo4Input: UITextField!
    
    var opcion5Label: UILabel!
    var costo5Label: UILabel!
    var opcion5Input: UITextField!
    var costo5Input: UITextField!
    
    
    
    func setUpView() {
        addSubview(productoExtra)
        addSubview(contentBebidas)
        addSubview(sep)
        addSubview(contentPostres)
        
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: productoExtra)
        addConstraintsWithFormat(format: "H:|-[v0(\(width))]-[v1(2)]-[v2(\(width))]", views: contentBebidas, sep, contentPostres)
        addConstraintsWithFormat(format: "V:|-[v0(30)]-[v1]-|", views: productoExtra, contentBebidas)
        addConstraintsWithFormat(format: "V:|-[v0(30)]-[v1]-|", views: productoExtra, sep)
        addConstraintsWithFormat(format: "V:|-[v0(30)]-[v1]-|", views: productoExtra, contentPostres)
        
        
        
        // -------------------------- Bebidas ----------------------------------
        contentBebidas.addSubview(bebidas)
        contentBebidas.addConstraintsWithFormat(format: "H:|-[v0]",     views: bebidas)
        contentBebidas.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: bebidas)
        
        opcion1Label = getOpcionLabel(text: "Opción 1")
        costo1Label  = getCostoLabel()
        opcion1Input = getOpcionTextField()
        costo1Input  = getCostoTextField()
        opcion2Label = getOpcionLabel(text: "Opción 2")
        costo2Label  = getCostoLabel()
        opcion2Input = getOpcionTextField()
        costo2Input  = getCostoTextField()
        opcion3Label = getOpcionLabel(text: "Opción 3")
        costo3Label  = getCostoLabel()
        opcion3Input = getOpcionTextField()
        costo3Input  = getCostoTextField()
        opcion4Label = getOpcionLabel(text: "Opción 4")
        costo4Label  = getCostoLabel()
        opcion4Input = getOpcionTextField()
        costo4Input  = getCostoTextField()
        opcion5Label = getOpcionLabel(text: "Opción 5")
        costo5Label  = getCostoLabel()
        opcion5Input = getOpcionTextField()
        costo5Input  = getCostoTextField()
        
        contentBebidas.addSubview( opcion1Label )
        
        
        // -------------------------- Postres ----------------------------------
        contentPostres.addSubview(postres)
        contentPostres.addConstraintsWithFormat(format: "H:|-[v0]", views: postres)
        contentPostres.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: postres)
        
    }
    
    
}



class BebidasView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}



