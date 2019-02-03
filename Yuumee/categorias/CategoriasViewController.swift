//
//  CategoriasViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/13/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CategoriasViewController: BaseViewController {
    
    let headerContent: UIView = {
        let view = UIView()
        return view
    }()
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.separatorStyle  = .none
        tableView.backgroundColor = UIColor.white
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        return tableView
    }()
    
    var categorias = [Categoria]()
    
    let dataStorage = UserDefaults.standard
    
    let ubicacion: UIButton = {
        let edgeInsets = UIEdgeInsets(top: -44, left: -44, bottom: -44, right: -44)
        let size = CGSize(width: 24, height: 24)
        let image = UIImage(named: "ubicacion")?.imageResize(sizeChange: size)
        let randomImage = UIImageView(image: image)
        randomImage.contentMode = .scaleAspectFit
        let random = UIButton(type: .custom)
        random.setImage( randomImage.image, for: .normal)
        random.tintColor = UIColor.rojo
        random.layer.cornerRadius = 15.0
        random.imageEdgeInsets = edgeInsets
        random.addTarget(self, action: #selector(filtersEvent), for: .touchUpInside)
        return random
    }()
    
    @objc func filtersEvent(sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    let date: UILabel = {
        let date  = UILabel()
        date.text = FormattedCurrentDate.getFormattedCurrentDate(date: Date(), format: "E, d MMM yyyy")
        date.font = UIFont.boldSystemFont(ofSize: date.font.pointSize)
        date.textAlignment = .center
        return date
    }()
    
    override func viewDidLoad() {
        
        mainView.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        // below code write in view did appear() -------------------------------
        let swipeRight = UISwipeGestureRecognizer(target: self, action:  #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        // below code create swipe gestures function ---------------------------
        
        // ---------------------------------------------------------------------
        mainView.addSubview(headerContent)
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: headerContent)
        mainView.addConstraintsWithFormat(format: "V:|-[v0(44)][v1]|", views: headerContent, tableView)
        
        
        //headerContent.addSubview(settings)
        //
        headerContent.addSubview(date)
        headerContent.addSubview(ubicacion)
        headerContent.addConstraintsWithFormat(format: "H:|-[v0(30)]-[v1]-|", views: ubicacion, date)
        headerContent.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: ubicacion)
        headerContent.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: date)
        
        // ---------------------------------------------------------------------
        let headers: HTTPHeaders = [
            // "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        let parameters: Parameters = ["funcion" : "getCategories",
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
                                            for c in data {
                                                let newC = Categoria(categoria: c)
                                                self.categorias.append(newC)
                                            }
                                            if self.categorias.count > 0 {
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
    
    /*
    @objc func showFiltersCategories(sender: UIButton) {
        let popVC = UINavigationController(rootViewController: ModalFiltersViewController())
        popVC.modalPresentationStyle = .popover
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = sender // self.button
        popOverVC?.sourceRect = CGRect(x: self.settings.bounds.midX,
                                       y: self.settings.bounds.minY,
                                       width: 0, height: 0)
        let widthModal = ScreenSize.screenWidth - 16
        let heightModal = ScreenSize.screenWidth
        popVC.preferredContentSize = CGSize(width: widthModal, height: heightModal)
        self.present(popVC, animated: true)
    }*/
    
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



extension CategoriasViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


extension CategoriasViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categorias.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        cell.releaseView()
        cell.selectionStyle = .none
        
        let categoria = categorias[indexPath.section]
        
        let backgroundImage = UIImageView(image: UIImage())
        //backgroundImage.contentMode = .scaleAspectFill
        
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.5) //change to your liking
        tintView.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        backgroundImage.addSubview(tintView)
        cell.backgroundView = backgroundImage
        
        let categoriaNameLabel = UILabel()
        categoriaNameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoriaNameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        categoriaNameLabel.text = categoria.titulo
        categoriaNameLabel.textColor = .white
        categoriaNameLabel.textAlignment = .center
        
        cell.addSubview(categoriaNameLabel)
        cell.centerView(superView: cell, container: categoriaNameLabel)
        
        if !categoria.imagen.isEmpty {
            let urlImage = URL(string: categoria.imagen)
            backgroundImage.af_setImage(withURL: urlImage!,
                                        placeholderImage: UIImage(named: "placeholder"),
                                        filter: nil,
                                        progress: nil,
                                        progressQueue: DispatchQueue.main,
                                        imageTransition: .noTransition,
                                        runImageTransitionIfCached: false) { (response) in }
        }
        
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // let currentSection = indexPath.section
        // let currentRow = indexPath.row
        return 200.0 // UITableViewAutomaticDimension
    }
    
    
    // Footer View Section
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        let sep = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 3) )
        sep.backgroundColor = UIColor.black//.withAlphaComponent(0.7)
        sep.layer.cornerRadius = 2
        view.addSubview(sep)
        view.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: sep)
        view.addConstraintsWithFormat(format: "V:|-[v0]-|", views: sep)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    
    /**
     * Abre el detalle de la categoria
     *
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let categoria = categorias[indexPath.section]
        let vc = DetalleListadoCategoriaViewController()
        vc.idCategoria = categoria.id
        vc.categoriaTitle = categoria.titulo
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
        
    }
    
    
}




struct Categoria {
    
    var id: String     = ""
    var imagen: String = ""
    var titulo: String = ""
    
    var dictionaryCategoria: [String:Any]?
    
    init(categoria: Dictionary<String, Any>) {
        dictionaryCategoria = categoria
        
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
    
    func toDictionary() -> [String:Any]? {
        return self.dictionaryCategoria
    }
    
}





