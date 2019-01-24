//
//  PerfilAnfitrionViewController.swift
//  Yuumee
//
//  Created by Easy Code on 1/2/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire

class PerfilAnfitrionViewController: BaseViewController {
    
    let informacionAnfitrionCell = "InformacionAnfitrionCell"
    let backgroundImageId        = "backgroundImageId"
    let defaultReuseId           = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView() // frame: CGRect.zero, style: .grouped
        tableView.delegate        = self
        tableView.dataSource      = self
        tableView.separatorStyle  = .none
        tableView.backgroundColor = UIColor.gris
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.register(BackgroundImageHeader.self, forCellReuseIdentifier: backgroundImageId)
        tableView.register(InformacionAnfitrionCell.self, forCellReuseIdentifier: informacionAnfitrionCell)
        return tableView
    }()
    
    
    let secciones = ["background_image", "info"]
    
    var eventos = [EventoAnfitrion]()
    
    let dataStorage = UserDefaults.standard
    
    var infoAnfitrion: Dictionary<String, AnyObject> = [:]
    var imagenPortada: String = ""
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // ---------------------------------------------------------------------
        let headers: HTTPHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let parameters: Parameters = ["funcion" : "getUserInfoAmphitryon",
                                      "id_user" : dataStorage.getUserId()] as [String: Any]
        Alamofire.request(BaseURL.baseUrl() , method: .post, parameters: parameters,
                          encoding: ParameterQueryEncoding(),
                          headers: headers).responseJSON{ (response: DataResponse) in
                            switch(response.result) {
                            case .success(let value):
                                
                                
                                if let result = value as? Dictionary<String, Any> {
                                    let statusMsg = result["status_msg"] as? String
                                    let state     = result["state"] as? String
                                    
                                    if statusMsg == "OK" && state == "200" {
                                        if let data = result["data"] as? Dictionary<String, AnyObject> {
                                            
                                            if let info = data["info"] as? Dictionary<String, AnyObject> {
                                                self.imagenPortada = (info["imagen_portada"] as? String)!
                                                self.infoAnfitrion = info
                                            }
                                            
                                            if let eventos = data["events"] as? [Dictionary<String, AnyObject>] {
                                                for e in eventos {
                                                    let newE = EventoAnfitrion(eventoArray: e)
                                                    self.eventos.append(newE)
                                                }
                                            }
                                            
                                            self.tableView.reloadData()
                                        }
                                    }
                                }
                                
                                //completionHandler(value as? NSDictionary, nil)
                                break
                            case .failure(let error):
                                //completionHandler(nil, error as NSError?)
                                print(error)
                                print(error.localizedDescription)
                                break
                            }
        }
        // ---------------------------------------------------------------------
        
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
                    cell.setUpView(urlImage: self.imagenPortada)
                    return cell
                }
            }
            if section == "info" {
                let cell = tableView.dequeueReusableCell(withIdentifier: informacionAnfitrionCell, for: indexPath)
                if let cell = cell as? InformacionAnfitrionCell {
                    cell.selectionStyle = .none
                    cell.reference = self
                    cell.setUpView(info: infoAnfitrion)
                    return cell
                }
            }
        }
        
        if currentSection == 1 {
            
            let evento = self.eventos[currentRow]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
            cell.releaseView()
            let titulo = ArchiaBoldLabel()
            titulo.textColor = .rosa
            titulo.text = evento.titulo
            let descripcion = ArchiaRegularLabel()
            descripcion.text = evento.descripcion
            let tipoMenu = ArchiaRegularLabel()
            tipoMenu.textColor = .verde
            tipoMenu.text = "Menu: \(evento.menu)"
            let fecha = ArchiaRegularLabel()
            fecha.text = evento.fecha
            let horario = ArchiaRegularLabel()
            horario.text = "Horario: \(evento.horario)"
            let capacidad = ArchiaRegularLabel()
            capacidad.text = "Capacidad: \(evento.capacidad)"
            let costo = ArchiaRegularLabel()
            costo.text = evento.costo
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




struct EventoAnfitrion {
    
    var id: String
    var costo: String
    var fecha: String
    var titulo: String
    var horario: String
    var capacidad: String
    var menu: String
    var descripcion: String
    
    init(eventoArray: Dictionary<String, AnyObject>) {
        self.id = eventoArray["id"] as! String
        self.costo = eventoArray["costo"] as! String
        self.fecha = eventoArray["fecha"] as! String
        self.titulo = eventoArray["titulo"] as! String
        self.horario = eventoArray["horario"] as! String
        self.capacidad = eventoArray["capacidad"] as! String
        self.menu = eventoArray["menu"] as! String
        self.descripcion = eventoArray["descripcion"] as! String
    }
    
}



