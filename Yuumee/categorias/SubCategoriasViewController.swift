//
//  SubCategoriasViewController.swift
//  Yuumee
//
//  Created by Luis Segoviano on 1/20/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire

class SubCategoriasViewController: BaseViewController {
    
    var idCategoria: String = ""
    
    let cerrarBtn: UIBarButtonItem = {
        let sizeImg   = CGSize(width: 24, height: 24)
        let imgClose  = UIImage(named: "close")?.imageResize(sizeChange: sizeImg)
        let cerrarBtn = UIBarButtonItem(image: imgClose, style: .plain,
                                        target: self, action: #selector(closeVC))
        cerrarBtn.tintColor = .white
        return cerrarBtn
    }()
    
    
    let reuseId = "RestaurantCell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView() // frame: CGRect.zero, style: .grouped
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.separatorStyle  = .none
        tableView.backgroundColor = UIColor.white
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        return tableView
    }()
    
    var subCategorias = [SubCategoria]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        cerrarBtn.target = self
        self.navigationItem.rightBarButtonItem = cerrarBtn
        
        
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
        // ---------------------------------------------------------------------
        if !idCategoria.isEmpty {
            let headers: HTTPHeaders = [
                // "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
                "Accept" : "application/json",
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
            let parameters: Parameters = ["funcion" : "getSubCategories",
                                          "id_cat" : idCategoria] as [String: Any]
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
                                                
                                                for c in data {
                                                    let newC = SubCategoria(categoria: c)
                                                    self.subCategorias.append(newC)
                                                }
                                                
                                                if self.subCategorias.count > 0 {
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
        }
        // ---------------------------------------------------------------------
        
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    

} // SubCategoriasViewController


extension SubCategoriasViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategorias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        cell.selectionStyle = .none
        
        let subC = subCategorias[indexPath.row]
        print(" subC ")
        print(subC)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = indexPath.section
        let currentRow = indexPath.row
        return 300.0 // UITableViewAutomaticDimension
    }
    
    /*
     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
     let currentSection = indexPath.section
     let currentRow = indexPath.row
     return 550.0 // UITableViewAutomaticDimension
     }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     tableView.deselectRow(at: indexPath, animated: true)
     let currentSection = indexPath.section
     let currentRow = indexPath.row
     //print(" currentRow ", currentRow)
     }
     */
    
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


