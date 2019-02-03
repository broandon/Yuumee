//
//  DetalleListadoCategoriaViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/27/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire

class DetalleListadoCategoriaViewController: BaseViewController {
    
    let defaultReuseId = "cell"
    
    let restaurantCell = "RestaurantCell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView() // frame: CGRect.zero, style: .grouped
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.register(RestaurantCell.self, forCellReuseIdentifier: restaurantCell)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    var subCategoriasPlatillos = [SubCategoria]()
    
    var restaurants = [Restaurant]()
    
    let dataStorage = UserDefaults.standard
    
    var idCategoria: String = ""
    
    var categoriaTitle: String = ""
    
    lazy var settings: UIButton = {
        let sizeStandarIcon: CGSize = CGSize(width: 24, height: 24)
        let image: UIImage = (UIImage(named: "settings")?.imageResize(sizeChange: sizeStandarIcon))!
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(settingsTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        mainView.backgroundColor = .white
        self.title = categoriaTitle
        // -------------------------------- Nav --------------------------------
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backItem?.title = "Regresar"
        let backButton = UIBarButtonItem(title: "Regresar", style: .plain, target: self, action: #selector(back))
        
        //
        // Settings
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settings)
        self.navigationItem.leftBarButtonItem = backButton
        
        //
        // ------------------------------- Datos -------------------------------
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
        
        //
        // ---------------------------------------------------------------------
        let headers: HTTPHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let parameters: Parameters = ["funcion"    : "getSaucersCategory",
                                      "id_user"    : dataStorage.getUserId(),
                                      "latitud"    : dataStorage.getLatitud(),
                                      "longitude"  : dataStorage.getLongitud(),
                                      "id_category": idCategoria] as [String: Any]
        
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
                                            self.restaurants = [Restaurant]()
                                            if let info = data["info"] as? [Dictionary<String, AnyObject>] {
                                                for r in info {
                                                    let newR = Restaurant(restaurant: r)
                                                    self.restaurants.append(newR)
                                                }
                                                if self.restaurants.count > 0 {
                                                    self.tableView.reloadData()
                                                }
                                                else{
                                                    Utils.showSimpleAlert(message: "No se encontraron platillos",
                                                                          context: self, success: nil)
                                                }
                                            }
                                            
                                            if let subCategories = data["subcategory"] as? [Dictionary<String, Any>] {
                                                for sc in subCategories {
                                                    let newC = SubCategoria(categoria: sc)
                                                    self.subCategoriasPlatillos.append(newC)
                                                }
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
    
    
    @objc func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func settingsTap(sender: UIButton) {
        let vc = SubCategoriasViewController()
        vc.delegate = self
        vc.subCategorias = self.subCategoriasPlatillos
        vc.idCategoria = self.idCategoria
        let popVC      = UINavigationController(rootViewController: vc)
        popVC.modalPresentationStyle = .popover
        let popOverVC  = popVC.popoverPresentationController
        popOverVC?.delegate   = self
        popOverVC?.sourceView = self.settings // self.button
        let midX: CGFloat = self.settings.bounds.midX
        let midY: CGFloat = self.settings.bounds.minY
        let sourceRect: CGRect = CGRect(x: midX, y: midY, width: 0, height: 0)
        popOverVC?.sourceRect = sourceRect
        let widthModal  = ScreenSize.screenWidth - 16
        let heightModal = ScreenSize.screenWidth
        popVC.preferredContentSize = CGSize(width: widthModal, height: heightModal)
        self.present(popVC, animated: true)
    }
    
}




extension DetalleListadoCategoriaViewController: SubCategorySelected {
    
    func getSubCategorySelected(subCategory: SubCategoria) {
        //
        // ---------------------------------------------------------------------
        let headers: HTTPHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let parameters: Parameters = ["funcion"    : "getSaucersSubCategory",
                                      "id_user"    : dataStorage.getUserId(),
                                      "latitud"    : dataStorage.getLatitud(),
                                      "longitude"  : dataStorage.getLongitud(),
                                      "id_category": idCategoria,
                                      "id_subcategory" : subCategory.id] as [String: Any]
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
                                            self.restaurants = [Restaurant]()
                                            print(" data ")
                                            print(data)
                                            
                                            if let info = data["info"] as? [Dictionary<String, AnyObject>] {
                                                for r in info {
                                                    let newR = Restaurant(restaurant: r)
                                                    self.restaurants.append(newR)
                                                }
                                                self.tableView.reloadData()
                                                if self.restaurants.count <= 0 {
                                                    Utils.showSimpleAlert(message: "No se encontraron platillos",
                                                                          context: self, success: nil)
                                                }
                                                
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
    
}



extension DetalleListadoCategoriaViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension DetalleListadoCategoriaViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: restaurantCell, for: indexPath) as! RestaurantCell
        cell.selectionStyle = .none
        let r = restaurants[indexPath.row]
        cell.setUpView(restaurant: r)
        cell.descripcion.textColor = UIColor.darkGray
        cell.kms.textColor = UIColor.darkGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentRow = indexPath.row
        let r = restaurants[currentRow]
        let vc = PerfilUsuarioViewController()
        vc.idAnfittrion = r.idAnfitrion
        vc.idSaucerSelected = r.id
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
} // DetalleListadoCategoriaViewController


struct SubCategoria {
    var id: String     = ""
    var imagen: String = ""
    var titulo: String = ""
    init(categoria: Dictionary<String, Any>) {
        if let id = categoria["Id"] as? String {
            self.id = id
        }
        if let imagen = categoria["imagen"] as? String {
            self.imagen = imagen
        }
        if let titulo = categoria["titulo"] as? String {
            self.titulo = titulo
        }
    }
}


/*
class DetalleSubCategoriaViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView() // frame: CGRect.zero, style: .grouped
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.separatorStyle  = .none
        tableView.backgroundColor = UIColor.white
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        return tableView
    }()
    
    var subCategoriasPlatillos = [SubCategoria]()
    
    let dataStorage = UserDefaults.standard
    
    var idCategoria: String    = ""
    var idSubCategoria: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
        
        //
        // ---------------------------------------------------------------------
        let headers: HTTPHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let parameters: Parameters = ["funcion"    : "getSaucersSubCategory",
                                      "id_user"    : dataStorage.getUserId(),
                                      "latitud"    : dataStorage.getLatitud(),
                                      "longitude"  : dataStorage.getLongitud(),
                                      "id_category" : idCategoria,
                                      "id_subcategory": idSubCategoria] as [String: Any]
        
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
                                            
                                            print(" data ")
                                            print(data)
                                            print(" \n\n ")
                                            
                                            /*if let info = data["info"] as? [Dictionary<String, AnyObject>] {
                                                for r in info {
                                                    let newR = Restaurant(restaurant: r)
                                                    self.restaurants.append(newR)
                                                }
                                                if self.restaurants.count > 0 {
                                                    self.tableView.reloadData()
                                                }
                                                else{
                                                    Utils.showSimpleAlert(message: "No se encontraron platillos",
                                                                          context: self, success: nil)
                                                }
                                            }
                                            if let subCategories = data["subcategory"] as? [Dictionary<String, Any>] {
                                                for sc in subCategories {
                                                    let newC = SubCategoria(categoria: sc)
                                                    self.subCategoriasPlatillos.append(newC)
                                                }
                                            }*/
                                            
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        cell.addBorder()
        return cell
    }
    
}

*/


