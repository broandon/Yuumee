//
//  EventoAnfitrionViewController.swift
//  Yuumee
//
//  Created by Easy Code on 1/4/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

class EventoAnfitrionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let detallesEventoCell = "DetallesEventoCell"
    
    let horarioCell = "HorarioCell"
    
    let comidaCell = "ComidaCell"
    
    let categoriaCell = "CategoriaCell"
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.register(CategoriaCell.self, forCellReuseIdentifier: categoriaCell)
        tableView.register(ComidaCell.self, forCellReuseIdentifier: comidaCell)
        tableView.register(HorarioCell.self, forCellReuseIdentifier: horarioCell)
        tableView.register(DetallesEventoCell.self, forCellReuseIdentifier: detallesEventoCell)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.gris
        return tableView
    }()
    
    let secciones = ["categoria", "comida", "horario", "detalles_evento", "fechas", "total"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Reemplaza el titulo del back qu eviene por Default
        self.navigationController?.navigationBar.topItem?.title = "Evento"
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
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
        
        return UITableView.automaticDimension
        
    }
    
    
}




class DetallesEventoCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    
    func getBoldLabel(text: String) -> ArchiaBoldLabel {
        let label = ArchiaBoldLabel()
        label.text = text
        return label
    }
    
    func getRegularLabel(text: String) -> ArchiaRegularLabel {
        let label = ArchiaRegularLabel()
        label.text = text
        return label
    }
    
    func getTextView() -> UITextView {
        let textView = UITextView()
        textView.addBorder(borderColor: .black, widthBorder: 1)
        textView.textColor = UIColor.darkGray
        textView.font = UIFont(name: "ArchiaRegular", size: 14.0)
        return textView
    }
    
    func getView() -> UIView {
        let view = UIView()
        return view
    }
    
    var dscripcion: ArchiaBoldLabel!
    var menu: ArchiaBoldLabel!
    var bebidas: ArchiaBoldLabel!
    var postres: ArchiaBoldLabel!
    
    var descTextView: UITextView!
    var menuTextView: UITextView!
    var bebidasTextView: UITextView!
    var postresTextView: UITextView!
    var contCostoMenu: UIView!
    var contCostoBebidas: UIView!
    var contCostoPostres: UIView!
    
    
    var costoMenu: ArchiaBoldLabel!
    var costoBebidas: ArchiaBoldLabel!
    var costoPostres: ArchiaBoldLabel!
    
    var pesosMenu: ArchiaRegularLabel!
    var pesosBebidas: ArchiaRegularLabel!
    var pesosPostres: ArchiaRegularLabel!
    
    var costoMenuTextView: UITextView!
    var costoBebidasTextView: UITextView!
    var costoPostreTextView: UITextView!
    
    var mxMenu: ArchiaRegularLabel!
    var mxBebidas: ArchiaRegularLabel!
    var mxPostres: ArchiaRegularLabel!
    
    
    
    func setUpView() {
        dscripcion = getBoldLabel(text: "Descripción:")
        menu = getBoldLabel(text: "Menú:")
        bebidas = getBoldLabel(text: "Bebidas:")
        postres = getBoldLabel(text: "Postres:")
        
        descTextView = getTextView()
        menuTextView = getTextView()
        bebidasTextView = getTextView()
        postresTextView = getTextView()
        
        contCostoMenu = getView()
        contCostoBebidas = getView()
        contCostoPostres = getView()
        // Labels
        addSubview(dscripcion)
        addSubview(menu)
        addSubview(bebidas)
        addSubview(postres)
        // Texts Views
        addSubview(descTextView)
        addSubview(menuTextView)
        addSubview(bebidasTextView)
        addSubview(postresTextView)
        // Cont Costos
        addSubview(contCostoMenu)
        addSubview(contCostoBebidas)
        addSubview(contCostoPostres)
        
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: dscripcion)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: descTextView)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: menu)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: menuTextView)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: bebidas)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: bebidasTextView)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: postres)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: postresTextView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: contCostoMenu)
        addConstraintsWithFormat(format: "H:|[v0]|", views: contCostoBebidas)
        addConstraintsWithFormat(format: "H:|[v0]|", views: contCostoPostres)
        addConstraintsWithFormat(format: "V:|-[v0]-[v1(80)]-[v2]-[v3(80)]-[v4(50)]-[v5]-[v6(80)]-[v7(50)]-[v8]-[v9(80)]-[v10(50)]",
                                 views: dscripcion, descTextView, menu, menuTextView, contCostoMenu, bebidas, bebidasTextView, contCostoBebidas, postres, postresTextView, contCostoPostres)
        
        costoMenu = getBoldLabel(text: "Costo:")
        costoBebidas = getBoldLabel(text: "Costo:")
        costoPostres = getBoldLabel(text: "Costo:")
        
        costoMenuTextView = getTextView()
        costoMenuTextView.font = UIFont.boldSystemFont(ofSize: 14)
        costoMenuTextView.addBorder(borderColor: .black, widthBorder: 1)
        
        costoBebidasTextView = getTextView()
        costoBebidasTextView.font = UIFont.boldSystemFont(ofSize: 14)
        costoBebidasTextView.addBorder(borderColor: .black, widthBorder: 1)
        
        costoPostreTextView = getTextView()
        costoPostreTextView.font = UIFont.boldSystemFont(ofSize: 14)
        costoPostreTextView.addBorder(borderColor: .black, widthBorder: 1)
        
        pesosMenu = getRegularLabel(text: "$")
        pesosMenu.textColor = UIColor.lightGray
        //pesosBebidas
        //pesosPostres
        mxMenu = getRegularLabel(text: ".00 mx")
        mxMenu.textColor = UIColor.lightGray
        //mxBebidas
        //mxPostres
        
        contCostoMenu.addSubview(costoMenu)
        contCostoMenu.addSubview(costoMenuTextView)
        contCostoMenu.addSubview(pesosMenu)
        contCostoMenu.addSubview(mxMenu)
        contCostoMenu.addConstraintsWithFormat(format: "H:[v0]-[v1]-[v2(70)]-[v3]-|",
                                               views: costoMenu, pesosMenu, costoMenuTextView, mxMenu)
        contCostoMenu.addConstraintsWithFormat(format: "V:|-[v0]", views: costoMenu)
        contCostoMenu.addConstraintsWithFormat(format: "V:|[v0(30)]", views: costoMenuTextView)
        contCostoMenu.addConstraintsWithFormat(format: "V:|-[v0]", views: pesosMenu)
        contCostoMenu.addConstraintsWithFormat(format: "V:|-[v0]", views: mxMenu)
        /*addSubview(costoBebidas)
        addSubview(costoPostres)*/
        
        
    }
    
    
}
