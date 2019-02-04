//
//  CostosViewController.swift
//  Yuumee
//
//  Created by Luis Segoviano on 2/4/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit


class CostosViewController: BaseViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var dataStorage = UserDefaults.standard
    
    private func getSimpleLabel(texto: String) -> UILabel {
        let label  = UILabel()
        label.text = texto
        label.textAlignment = .center
        return label
    }
    
    private func getSimpleTextField() -> UITextField {
        let textField = UITextField()
        textField.delegate = self
        textField.addBorder(borderColor: .gris, widthBorder: 1.0)
        return textField
    }
    
    lazy var continuar: UIButton = {
        let frame = CGRect(x: 0, y: 0, width: ScreenSize.screenWidth, height: 50)
        let continuar = UIButton(frame: frame)
        continuar.setTitle("CONTINUAR", for: .normal)
        continuar.setTitleColor( UIColor.rosa , for: .normal)
        continuar.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        return continuar
    }()
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let secciones = ["menu", "bebidas", "postres", "costo_total"]
    
    var menu: UILabel!
    var bebidas: UILabel!
    var postres: UILabel!
    var menuMx: UILabel!
    var bebidasMx: UILabel!
    var postresMx: UILabel!
    var menuInput: UITextField!
    var bebidasInput: UITextField!
    var postresInput: UITextField!
    var totalInput: UITextField!
    var costoTotal: UILabel!
    var costoTotalMx: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        self.title = "Costos"
        let backButton = UIBarButtonItem()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        menu       = getSimpleLabel(texto: "Menú: $")
        bebidas    = getSimpleLabel(texto: "Bebidas: $")
        postres    = getSimpleLabel(texto: "Postres: $")
        menuMx     = getSimpleLabel(texto: ".00 mxn")
        bebidasMx  = getSimpleLabel(texto: ".00 mxn")
        postresMx  = getSimpleLabel(texto: ".00 mxn")
        menuInput    = getSimpleTextField()
        bebidasInput = getSimpleTextField()
        postresInput = getSimpleTextField()
        totalInput   = getSimpleTextField()
        costoTotal   = getSimpleLabel(texto: "Costo total: $")
        costoTotalMx = getSimpleLabel(texto: ".00 mxn")
        
        let customFooter = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.screenWidth, height: 50))
        customFooter.backgroundColor = UIColor.white
        customFooter.addSubview(continuar)
        tableView.tableFooterView = customFooter
        
        let sep = UIView()
        sep.backgroundColor = .darkGray
        mainView.addSubview(tableView)
        mainView.addSubview(continuar)
        mainView.addSubview(sep)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: sep)
        mainView.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: continuar)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]-[v1(1)]-[v2(40)]-|",
                                          views: tableView, sep, continuar)
    }
    
    
    
    @objc func nextStep(){
        let vc = SeleccionarTarjetaViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        
        let seccion = secciones[indexPath.row]
        
        if seccion == "menu" {
            cell.addSubview(menu)
            cell.addSubview(menuInput)
            cell.addSubview(menuMx)
            cell.addConstraintsWithFormat(format: "H:|-[v0(90)]-[v1]-[v2(90)]-|",
                                          views: menu, menuInput, menuMx)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: menu)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: menuInput)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: menuMx)
            return cell
        }
        
        if seccion == "bebidas" {
            cell.addSubview(bebidas)
            cell.addSubview(bebidasInput)
            cell.addSubview(bebidasMx)
            cell.addConstraintsWithFormat(format: "H:|-[v0(90)]-[v1]-[v2(90)]-|",
                                          views: bebidas, bebidasInput, bebidasMx)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: bebidas)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: bebidasInput)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: bebidasMx)
            return cell
        }
        
        if seccion == "postres" {
            cell.addSubview(postres)
            cell.addSubview(postresInput)
            cell.addSubview(postresMx)
            cell.addConstraintsWithFormat(format: "H:|-[v0(90)]-[v1]-[v2(90)]-|",
                                          views: postres, postresInput, postresMx)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: postres)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: postresInput)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: postresMx)
            
            return cell
        }
        
        if seccion == "costo_total" {
            cell.addSubview(costoTotal); costoTotal.addBorder()
            cell.addSubview(totalInput)
            cell.addSubview(costoTotalMx); costoTotalMx.addBorder()
            cell.addConstraintsWithFormat(format: "H:[v0(110)]-[v1(90)]-[v2(70)]-|",
                                          views: costoTotal, totalInput, costoTotalMx)
            cell.addConstraintsWithFormat(format: "V:[v0(30)]-|", views: costoTotal)
            cell.addConstraintsWithFormat(format: "V:[v0(30)]-|", views: totalInput)
            cell.addConstraintsWithFormat(format: "V:[v0(30)]-|", views: costoTotalMx)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let seccion = secciones[indexPath.row]
        if seccion == "costo_total" {
            return 200.0
        }
        return 70.0
    }
    
    
} // CostosViewController

