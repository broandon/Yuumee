//
//  SeleccionarTarjetaViewController.swift
//  Yuumee
//
//  Created by Luis Segoviano on 2/4/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire


class SeleccionarTarjetaViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var dataStorage = UserDefaults.standard
    
    let defaultReuseId = "cell"
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
    }()
    
    var tarjetas: [Tarjeta] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        self.title = "Reservar"
        let backButton = UIBarButtonItem()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|-[v0]-|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
        let headers: HTTPHeaders = ["Accept": "application/json",
                                    "Content-Type" : "application/x-www-form-urlencoded"]
        
        let parameters: Parameters = ["funcion"  : "getTokensUser",
                                      "id_user"  : dataStorage.getUserId()] as [String: Any]
        Alamofire.request(BaseURL.baseUrl(), method: .post, parameters: parameters, encoding: ParameterQueryEncoding(), headers: headers).responseJSON
            { (response: DataResponse) in
                switch(response.result) {
                case .success(let value):
                    if let result = value as? Dictionary<String, Any> {
                        
                        let statusMsg = result["status_msg"] as? String
                        let state = result["state"] as? String
                        if statusMsg == "OK" && state == "200" {
                            
                            if let tarjetas = result["data"] as? [Dictionary<String, AnyObject>] {
                                for tarjeta in tarjetas {
                                    let newTarjet = Tarjeta(tarjetasArray: tarjeta)
                                    self.tarjetas.append(newTarjet)
                                }
                                if self.tarjetas.count > 0 {
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
        
        
        //let nextButton = UIBarButtonItem(title: "root", style: .plain, target: self, action: #selector(reservarEvent))
        //self.navigationItem.rightBarButtonItem = nextButton
    }
    
    
    @objc func reservarEvent() {
        //self.navigationController?.popToRootViewController(animated: true)
        print("reservarEvent")
        let headers: HTTPHeaders = ["Accept": "application/json",
                                    "Content-Type" : "application/x-www-form-urlencoded"]
        
        let parameters: Parameters = ["funcion"  : "saveRerservation",
                                      "id_user"  : dataStorage.getUserId(),
                                      "cost"     : "",
                                      "persons"  : "",
                                      "allergies" : "",
                                      "allergies_description" : "",
                                      "id_token_method"       : "",
                                      "id_token_customer"     : "",
                                      "id_saucer" : "1",
                                      "extra_products" : ""] as [String: Any]
        print(" parameters ")
        print(parameters)
        Alamofire.request(BaseURL.baseUrl(), method: .post, parameters: parameters, encoding: ParameterQueryEncoding(), headers: headers).responseJSON
            { (response: DataResponse) in
                switch(response.result) {
                case .success(let value):
                    
                    print(" value ")
                    print(value)
                    
                    if let result = value as? Dictionary<String, Any> {
                        
                        print(" result ")
                        print(result)
                        
                        let statusMsg = result["status_msg"] as? String
                        let state = result["state"] as? String
                        if statusMsg == "OK" && state == "200" {
                            
                            Utils.showSimpleAlert(message: "Reservacion guardada",
                                                  context: self, success: nil)
                            
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
                    print(" error:  ")
                    print(error)
                    break
                }
        }
        print(" se pasa hasta aqui ")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tarjetas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        cell.releaseView()
        
        cell.selectionStyle = .none
        
        let nTarjeta = tarjetas[indexPath.row]
        
        let numTarjeta = UILabel()
        numTarjeta.text = " **** **** **** " + nTarjeta.digits
        numTarjeta.textColor = UIColor.darkGray
        numTarjeta.textAlignment = .center
        
        let tipoImgTarjeta = UIImageView()
        tipoImgTarjeta.contentMode = .scaleAspectFit
        if nTarjeta.type == TipoTarjeta.american_express.rawValue {
            tipoImgTarjeta.image = UIImage(named: "american_express")
        }
        if nTarjeta.type == TipoTarjeta.visa.rawValue {
            tipoImgTarjeta.image = UIImage(named: "visa")
        }
        if nTarjeta.type == TipoTarjeta.master_card.rawValue {
            tipoImgTarjeta.image = UIImage(named: "master_card")
        }
        
        
        cell.addSubview(tipoImgTarjeta)
        cell.addSubview(numTarjeta)
        
        cell.addConstraintsWithFormat(format: "H:|-[v0]-[v1(25)]-16-|",
                                      views: numTarjeta, tipoImgTarjeta)
        cell.addConstraintsWithFormat(format: "V:|-[v0]-|", views: numTarjeta)
        cell.addConstraintsWithFormat(format: "V:|-[v0(20)]", views: tipoImgTarjeta)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: mainView.frame.size.width, height: 50))
        footerView.isUserInteractionEnabled = true
        let addCard = UIButton(type: .system)
        addCard.setTitle("Reservar", for: .normal)
        addCard.setTitleColor(UIColor.rosa, for: .normal)
        addCard.layer.cornerRadius = 10
        addCard.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        addCard.imageView?.contentMode = .scaleAspectFit
        addCard.addBorder(borderColor: UIColor.azul , widthBorder: 2)
        addCard.addTarget(self, action: #selector(reservarEvent) , for: .touchUpInside)
        
        footerView.addSubview(addCard)
        footerView.addConstraintsWithFormat(format: "H:[v0(150)]-16-|", views: addCard)
        footerView.addConstraintsWithFormat(format: "V:|-[v0(40)]", views: addCard)
        
        return footerView
        
    }
    
    
    
}
