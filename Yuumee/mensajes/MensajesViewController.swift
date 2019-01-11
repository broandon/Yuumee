//
//  MensajesViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/13/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MensajesViewController: BaseViewController {
    
    let defaultReuseId = "cell"
    
    let headerContent: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var mensajes = [Mensaje]()
    
    let dataStorage = UserDefaults.standard
    
    override func viewDidLoad() {
        mainView.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        //below code write in view did appear()
        let swipeRight = UISwipeGestureRecognizer(target: self, action:  #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        // below code create swipe gestures function
        
        
        mainView.addSubview(headerContent)
        mainView.addSubview(tableView)
        
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: headerContent)
        mainView.addConstraintsWithFormat(format: "V:|-[v0(44)][v1]|", views: headerContent, tableView)
        /*
        let settingsImage = UIImageView(image: UIImage(named: "settings"))
        settingsImage.contentMode = .scaleAspectFit
        settingsImage.image = settingsImage.image?.withRenderingMode(.alwaysTemplate)
        settingsImage.tintColor = .white
        let settings = UIButton(type: .custom)
        settings.setImage( settingsImage.image , for: .normal)
        settings.backgroundColor = .rojo
        settings.tintColor = .white
        settings.layer.cornerRadius = 15
        let randomImage = UIImageView(image: UIImage(named: "random"))
        randomImage.contentMode = .scaleAspectFit
        randomImage.image = randomImage.image?.withRenderingMode(.alwaysTemplate)
        randomImage.tintColor = .white
        let random = UIButton(type: .custom)
        random.setImage( randomImage.image, for: .normal)
        random.backgroundColor = .rojo
        random.tintColor = .white
        random.layer.cornerRadius = 15
        */
        let date = UILabel()
        date.textAlignment = .center
        date.text = FormattedCurrentDate.getFormattedCurrentDate(date: Date(), format: "E, d MMM yyyy")
        date.font = UIFont.boldSystemFont(ofSize: date.font.pointSize)
        
        /*headerContent.addSubview(settings)
        headerContent.addSubview(random)*/
        headerContent.addSubview(date)
        headerContent.addConstraintsWithFormat(format: "H:|-[v0]-|", views: date)
        //headerContent.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: random)
        headerContent.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: date)
        //headerContent.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: settings)
        
        
        
        // ---------------------------------------------------------------------
        let headers: HTTPHeaders = [
            // "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        var funcion = "getChat"
        if dataStorage.getTipo() == String(TipoUsuario.anfitrion.rawValue) {
            funcion = "getChatAmphitryon"
        }
        let parameters: Parameters = ["funcion" : funcion,
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
                                        if let data = result["data"] as? [Dictionary<String, AnyObject>] {
                                            for m in data {
                                                let newM = Mensaje(mensaje: m)
                                                self.mensajes.append(newM)
                                            }
                                            if self.mensajes.count > 0 {
                                                self.tableView.reloadData()
                                            }
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
    
    // MARK: - swiped
    @objc  func swiped(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if (self.tabBarController?.selectedIndex)! < 3
            { // set here  your total tabs
                self.tabBarController?.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
            }
        }
    }
    
}





// MARK: Delegate & DataSource

extension MensajesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if mensajes.count == 0 {
            tableView.setEmptyMessage(message: "Por el momento no hay mensajes.")
            return 0
        }
        tableView.restore()
        return mensajes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = indexPath.section
        //let currentRow = indexPath.row
        
        /*if currentSection == 0 {
         let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
         cell.addSubview(nuevoCaso)
         cell.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: nuevoCaso)
         cell.addConstraintsWithFormat(format: "V:|-[v0]-|", views: nuevoCaso)
         return cell
         }*/
        
        let mensaje = mensajes[currentSection]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        //UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: defaultReuseId)
        
        let nombreRestaurant = UILabel()
        nombreRestaurant.text = mensaje.titulo
        //nombreRestaurant.font = UIFont(name: "MyriadPro-Bold", size: 16)
        nombreRestaurant.textColor = UIColor.verde
        nombreRestaurant.numberOfLines = 0
        
        let dueñoRest = UILabel()
        dueñoRest.text = mensaje.persona
        dueñoRest.textColor = UIColor.azul
        //dueñoRest.font = UIFont(name: "MyriadPro-Regular", size: 14)
        dueñoRest.numberOfLines = 0
        
        let mensajeLbl = UILabel()
        mensajeLbl.text = mensaje.mensaje
        mensajeLbl.textColor = UIColor.verde
        //dueñoRest.font = UIFont(name: "MyriadPro-Regular", size: 14)
        mensajeLbl.numberOfLines = 2
        
        cell.addSubview(nombreRestaurant)
        cell.addSubview(dueñoRest)
        cell.addSubview(mensajeLbl)
        
        cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: nombreRestaurant)
        cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: dueñoRest)
        cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: mensajeLbl)
        cell.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-[v2]-|", views: nombreRestaurant, dueñoRest, mensajeLbl)
        
        cell.backgroundColor = UIColor.gris
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        /*let currentSection = indexPath.section
        let currentRow = indexPath.row*/
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*let currentSection = indexPath.section
        let currentRow = indexPath.row*/
        return UITableView.automaticDimension // UITableViewAutomaticDimension
    }
    
    
    
    /**
     * Detalle
     *
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentSection = indexPath.section
        let mensaje = mensajes[currentSection]
        
        let viewController = DetalleConversacionViewController()
        viewController.idChat = mensaje.id
        viewController.titulo = mensaje.titulo
        let nav = UINavigationController(rootViewController: viewController)
        self.present(nav, animated: true, completion: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        /*if section == 0 {
            let view = UIView()
            view.backgroundColor = UIColor.clear
            view.addSubview(nuevoCaso)
            view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: nuevoCaso)
            view.addConstraintsWithFormat(format: "V:|-[v0]-|", views: nuevoCaso)
            return view
        }*/
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0 // 55
        }
        return 0
    }
    // Footer View Section
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    
    
}









struct Mensaje {
    
    var id: String = ""
    var ultimaFecha: String = ""
    var titulo: String = ""
    var mensaje: String = ""
    var persona: String = ""
    
    init(mensaje: Dictionary<String, Any>) {
        
        if let id = mensaje["Id"] as? String {
            self.id = id
        }
        
        if let ultimaFecha = mensaje["ultima_fecha"] as? String {
            self.ultimaFecha = ultimaFecha
        }
        
        if let titulo = mensaje["titulo"] as? String {
            self.titulo = titulo
        }
        
        if let mensaje = mensaje["mensaje"] as? String {
            self.mensaje = mensaje
        }
        
        if let persona = mensaje["persona"] as? String {
            self.persona = persona
        }
        
    }
    
    
}




