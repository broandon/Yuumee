//
//  ReservasViewController.swift
//  Yuumee
//
//  Created by Easy Code on 1/23/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire

class ReservasViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaultReuseId = "cell"
    
    var reservas = [Reserva]()
    
    let dataStorage = UserDefaults.standard
    
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
        
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let headers: HTTPHeaders = ["Accept": "application/json",
                                    "Content-Type" : "application/x-www-form-urlencoded"]
        let userId = dataStorage.getUserId()
        let parameters: Parameters = ["funcion"  : "getOrdersAmphitryon",
                                      "id_user"  : userId] as [String: Any]
        
        Alamofire.request(BaseURL.baseUrl(), method: .post, parameters: parameters, encoding: ParameterQueryEncoding(), headers: headers).responseJSON
            { (response: DataResponse) in
                switch(response.result) {
                case .success(let value):
                    if let result = value as? Dictionary<String, Any> {
                        let statusMsg = result["status_msg"] as? String
                        let state = result["state"] as? String
                        
                        if statusMsg == "OK" && state == "200" {
                            if let reservas = result["data"] as? [Dictionary<String, AnyObject>] {
                                
                                for r in reservas {
                                    let newE = Reserva(reservaArray: r)
                                    self.reservas.append(newE)
                                }
                                if self.reservas.count > 0 {
                                    self.tableView.reloadData()
                                }
                            }
                        }
                        else{
                            let alert = UIAlertController(title: "Ocurrió un error al realizar la petición.",
                                                          message: "\(statusMsg!)",
                                preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return;
                        }
                    }
                    //completionHandler(value as? NSDictionary, nil)
                    break
                case .failure(let error):
                    //completionHandler(nil, error as NSError?)
                    //print(" error:  ")
                    //print(error)
                    break
                }
        }
        
    }
    
    
    // MARK: Delegate & Datasource - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentrow = indexPath.row
        let reserva    = self.reservas[currentrow]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        cell.releaseView()
        cell.selectionStyle  = .none
        cell.backgroundColor = UIColor.azul
        cell.addBorder(borderColor: .white, widthBorder: 1)
        
        let platillo  = UILabel()
        platillo.text = reserva.nombre
        platillo.textColor     = .white
        platillo.numberOfLines = 0
        
        let cliente  = UILabel()
        cliente.text = reserva.cliente
        cliente.textColor     = .white
        cliente.numberOfLines = 0
        
        let noPersonas  = UILabel()
        noPersonas.text = "No. de personas: \(reserva.noPersonas)"
        noPersonas.textColor     = .white
        noPersonas.numberOfLines = 0
        
        let fecha  = UILabel()
        fecha.text = reserva.fecha
        fecha.textColor     = .white
        fecha.numberOfLines = 0
        
        let costoLbl  = UILabel()
        costoLbl.text = "Costo:"
        costoLbl.textColor     = .white
        costoLbl.numberOfLines = 0
        
        let costo  = UILabel()
        costo.text = reserva.costo
        costo.textColor     = .white
        costo.numberOfLines = 0
        
        cell.addSubview(platillo)
        cell.addSubview(fecha)
        cell.addSubview(costoLbl)
        cell.addSubview(costo)
        cell.addSubview(noPersonas)
        cell.addSubview(cliente)
        
        
        cell.addConstraintsWithFormat(format: "H:|-[v0]|", views: platillo)
        cell.addConstraintsWithFormat(format: "H:|-[v0]|", views: fecha)
        cell.addConstraintsWithFormat(format: "H:|-[v0]|", views: cliente)
        cell.addConstraintsWithFormat(format: "H:|-[v0]|", views: noPersonas)
        cell.addConstraintsWithFormat(format: "H:[v0(70)]-[v1]-|", views: costoLbl, costo)
        //cell.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-[v2]", views: platillo, fecha, costoLbl)
        //cell.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-[v2]", views: platillo, fecha, costo)
        cell.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-[v2]-[v3]", views: platillo, cliente, noPersonas, fecha)
        
        cell.addConstraintsWithFormat(format: "V:[v0(25)]-|", views: costoLbl)
        cell.addConstraintsWithFormat(format: "V:[v0(25)]-|", views: costo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}




struct Reserva {
    
    var id: String
    var nombre: String
    var fecha: String
    var costo: String
    var noPersonas: String
    var cliente: String
    
    init(reservaArray: Dictionary<String, AnyObject>) {
        self.id     = reservaArray["Id"] as! String
        self.nombre = reservaArray["nombre_platillo"] as! String
        self.fecha  = reservaArray["fecha_platillo"] as! String
        self.costo  = reservaArray["costo"] as! String
        self.noPersonas  = reservaArray["num_personas"] as! String
        self.cliente  = reservaArray["cliente"] as! String
    }
    
}
