//
//  HistorialEventosViewController.swift
//  Yuumee
//
//  Created by Easy Code on 1/10/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire

class HistorialEventosViewController: BaseViewController {
    
    let reuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let dataStorage = UserDefaults.standard
    
    var eventos = [Evento]()

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
        
        let headers: HTTPHeaders = ["Accept": "application/json",
                                    "Content-Type" : "application/x-www-form-urlencoded"]
        let userId = dataStorage.getUserId()
        let parameters: Parameters = ["funcion"  : "getOrders",
                                      "id_user"  : userId] as [String: Any]
        Alamofire.request(BaseURL.baseUrl(), method: .post, parameters: parameters, encoding: ParameterQueryEncoding(), headers: headers).responseJSON
            { (response: DataResponse) in
                switch(response.result) {
                case .success(let value):
                    if let result = value as? Dictionary<String, Any> {
                        
                        let statusMsg = result["status_msg"] as? String
                        let state = result["state"] as? String
                        if statusMsg == "OK" && state == "200" {
                            
                            if let orders = result["data"] as? [Dictionary<String, AnyObject>] {
                                for e in orders {
                                    let newEvent = Evento(eventoArray: e)
                                    self.eventos.append(newEvent)
                                }
                                if self.eventos.count > 0 {
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
    
}


extension HistorialEventosViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let evento = eventos[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        cell.releaseView()
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.azul
        cell.addBorder(borderColor: .white, widthBorder: 1)
        let platillo = UILabel()
        platillo.text = evento.platillo
        platillo.textColor = .white
        platillo.numberOfLines = 0
        
        let fecha = UILabel()
        fecha.text = evento.fechaReservacion
        fecha.textColor = .white
        fecha.numberOfLines = 0
        
        let costoLbl = UILabel()
        costoLbl.text = "Costo:"
        costoLbl.textColor = .white
        costoLbl.numberOfLines = 0
        
        let costo = UILabel()
        costo.text = evento.costo
        costo.textColor = .white
        costo.numberOfLines = 0
        
        cell.addSubview(platillo)
        cell.addSubview(fecha)
        cell.addSubview(costoLbl)
        cell.addSubview(costo)
        
        cell.addConstraintsWithFormat(format: "H:|-[v0]|", views: platillo)
        cell.addConstraintsWithFormat(format: "H:|-[v0]|", views: fecha)
        cell.addConstraintsWithFormat(format: "H:[v0(70)]-[v1]-|", views: costoLbl, costo)
        
        cell.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-[v2]", views: platillo, fecha, costoLbl)
        cell.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-[v2]", views: platillo, fecha, costo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}







struct Evento {
    
    var id: String
    var costo: String
    var fechaReservacion: String
    var platillo: String
    
    init(eventoArray: Dictionary<String, AnyObject>) {
        self.id = eventoArray["Id"] as! String
        self.costo = eventoArray["costo"] as! String
        self.fechaReservacion = eventoArray["fecha_reservacion"] as! String
        self.platillo = eventoArray["platillo"] as! String
    }
    
}




