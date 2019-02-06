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
    
    //  Params -----------------------------------------------------------------
    var alergia: Bool        = false
    var alergiaDesc: String  = ""
    var costoTotal: String   = ""
    var personas: String     = ""
    var idPlatillo: String   = ""
    var bebidasPostresParam: [Dictionary<String, AnyObject>] = []
    // -------------------------------------------------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        self.title = "Reservar"
        let backButton = UIBarButtonItem()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let save = UIButton(type: .system)
        save.setTitle("Reservar", for: .normal)
        save.setTitleColor(UIColor.rosa, for: .normal)
        save.layer.cornerRadius = 10
        save.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        save.imageView?.contentMode = .scaleAspectFit
        save.addBorder(borderColor: UIColor.azul , widthBorder: 2)
        save.addTarget(self, action: #selector(reservarEvent) , for: .touchUpInside)
        
        mainView.addSubview(tableView)
        mainView.addSubview(save)
        mainView.addConstraintsWithFormat(format: "H:|-[v0]-|", views: tableView)
        mainView.addConstraintsWithFormat(format: "H:[v0(150)]-16-|", views: save)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]-[v1(40)]-16-|", views: tableView, save)
        
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
    
    
    var cardIdToPay = ""
    var idStore = ""
    
    @objc func reservarEvent() {
        
        if idStore.isEmpty || cardIdToPay.isEmpty {
            Utils.showSimpleAlert(message: "Por favor seleccione una tarjeta.",
                                  context: self, success: nil)
            return;
        }
        
        let jsonData = try! JSONSerialization.data(withJSONObject: bebidasPostresParam, options: [])
        let decoded = String(data: jsonData, encoding: .utf8)!
        
        let headers: HTTPHeaders = ["Accept": "application/json",
                                    "Content-Type" : "application/x-www-form-urlencoded"]
        
        let parameters: Parameters = ["funcion"  : "saveRerservation",
                                      "id_user"  : dataStorage.getUserId(),
                                      "cost"     : costoTotal,
                                      "persons"  : personas,
                                      "allergies" : (alergia) ? 2 : 1 ,
                                      "allergies_description" : alergiaDesc,
                                      "id_token_method"       : cardIdToPay,
                                      "id_token_customer"     : idStore,
                                      "id_saucer" : idPlatillo,
                                      "extra_products" : decoded] as [String: Any]
        
        Alamofire.request(BaseURL.baseUrl(), method: .post, parameters: parameters, encoding: ParameterQueryEncoding(), headers: headers).responseJSON
            { (response: DataResponse) in
                switch(response.result) {
                case .success(let value):
                    
                    if let result = value as? Dictionary<String, Any> {
                        
                        let statusMsg = result["status_msg"] as? String
                        let state = result["state"] as? String
                        wasReservationSaved = true
                        if statusMsg == "OK" && state == "200" {
                            
                            let vc = MensajePagadoViewController()
                            vc.delegate = self
                            let popVC = UINavigationController(rootViewController: vc)
                            popVC.modalPresentationStyle = .overFullScreen
                            self.present(popVC, animated: true)
                            
                            /*Utils.showSimpleAlert(message: "Reservacion guardada", context: self,
                                                  success: {(alert: UIAlertAction!) in
                            self.navigationController?.popToRootViewController(animated: true)
                            })
                            */
                        }
                        else{
                            Utils.showSimpleAlert(message: "Ocurrió un error al realizar la petición.",
                                                  context: self,
                                                  success: {(alert: UIAlertAction!) in
                            self.navigationController?.popToRootViewController(animated: true)
                                                    
                            })
                            return;
                        }
                    }
                    //completionHandler(value as? NSDictionary, nil)
                    break
                case .failure(let error):
                    //print(" error:  ")
                    //print(error)
                    //print(error.localizedDescription)
                    
                    Utils.showSimpleAlert(message: error.localizedDescription,
                                          context: self,
                                          success: {(alert: UIAlertAction!) in
                        self.navigationController?.popToRootViewController(animated: true)
                                            
                    })
                    return;
                    
                    break
                }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tarjetas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        cell.releaseView()
        
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
        cell.addConstraintsWithFormat(format: "H:|-[v0]-[v1(25)]-16-|", views: numTarjeta, tipoImgTarjeta)
        cell.addConstraintsWithFormat(format: "V:|-[v0]-|", views: numTarjeta)
        cell.addConstraintsWithFormat(format: "V:|-[v0(20)]", views: tipoImgTarjeta)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        
        let nTarjeta = tarjetas[indexPath.row]
        cardIdToPay = nTarjeta.id
        idStore = nTarjeta.client
        
    }
    
    /*
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
    */
    
    
}


extension SeleccionarTarjetaViewController: BackToList {
    func backToList() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
