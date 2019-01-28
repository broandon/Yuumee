//
//  TimeLineViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/13/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TimeLineViewController: BaseViewController {
    
    let headerContent: UIView = {
        let view = UIView()
        return view
    }()
    
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
    
    
    static private let insetsPadding: UIEdgeInsets = UIEdgeInsets(top: -44, left: -44, bottom: -44, right: -44)
    
    static private let sizeStandarIcon: CGSize = CGSize(width: 24, height: 24)
    
    static private let standarCornerRadius: CGFloat = 15.0
    
    let settings: UIButton = {
        let imageResized = UIImage(named: "settings")?.imageResize(sizeChange: sizeStandarIcon)
        let settingsImage = UIImageView(image: imageResized)
        settingsImage.contentMode = .scaleAspectFit
        let settings = UIButton(type: .custom)
        settings.setImage( settingsImage.image , for: .normal)
        settings.backgroundColor = .rosa
        settings.layer.cornerRadius = standarCornerRadius
        settings.imageEdgeInsets = insetsPadding
        settings.addTarget(self, action: #selector(settingsEvent), for: .touchUpInside)
        return settings
    }()
    
    let filters: UIButton = {
        let image = UIImage(named: "ubicacion")?.imageResize(sizeChange: sizeStandarIcon)
        let randomImage = UIImageView(image: image)
        randomImage.contentMode = .scaleAspectFit
        let random = UIButton(type: .custom)
        random.setImage(randomImage.image, for: .normal)
        random.tintColor = UIColor.rojo
        random.layer.cornerRadius = standarCornerRadius
        random.imageEdgeInsets = insetsPadding
        random.addTarget(self, action: #selector(filtersEvent), for: .touchUpInside)
        return random
    }()
    
    let currentDate: UILabel = {
        let date = UILabel()
        date.textAlignment = .center
        date.text = FormattedCurrentDate.getFormattedCurrentDate(date: Date(), format: "E, d MMM yyyy")
        date.font = UIFont.boldSystemFont(ofSize: date.font.pointSize)
        return date
    }()
    
    let dataStorage = UserDefaults.standard
    
    var restaurants = [Restaurant]()
    
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
        
        headerContent.addSubview(settings)
        headerContent.addSubview(currentDate)
        headerContent.addSubview(filters)
        
        headerContent.addConstraintsWithFormat(format: "H:|-[v0(30)]-[v1]-[v2(30)]-|",
                                               views: filters, currentDate, settings)
        headerContent.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: filters)
        headerContent.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: currentDate)
        headerContent.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: settings)
        
        // ---------------------------------------------------------------------
        let headers: HTTPHeaders = [
            "Accept" : "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let parameters: Parameters = ["funcion" : "getSaucers",
                                      "id_user" : dataStorage.getUserId(),
                                      "latitud" : dataStorage.getLatitud(),
                                      "longitude" : dataStorage.getLongitud()] as [String: Any]
        
        Alamofire.request(BaseURL.baseUrl() , method: .post,
                           parameters: parameters,
                           encoding: ParameterQueryEncoding(),
                           headers: headers).responseJSON{ (response: DataResponse) in
                            switch(response.result) {
                            case .success(let value):
                                
                                if let result = value as? Dictionary<String, Any> {
                                    let statusMsg = result["status_msg"] as? String
                                    let state     = result["state"] as? String
                                    if statusMsg == "OK" && state == "200" {
                                        if let data = result["data"] as? [Dictionary<String, AnyObject>] {
                                            for r in data {
                                                let newR = Restaurant(restaurant: r)
                                                self.restaurants.append(newR)
                                            }
                                            if self.restaurants.count > 0 {
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
            if (self.tabBarController?.selectedIndex)! < 3 { // set here  your total tabs
                self.tabBarController?.selectedIndex += 1
            }
        }
        else if gesture.direction == .right {
            if (self.tabBarController?.selectedIndex)! > 0 {
                self.tabBarController?.selectedIndex -= 1
            }
        }
    }
    
    
    
    @objc func filtersEvent(sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    /**
     * Abre el modal con el calendario y la vista de organizar.
     *
     */
    @objc func settingsEvent(sender: UIButton) {
        let vc = ModalFiltersViewController()
        let popVC = UINavigationController(rootViewController: vc)
        popVC.modalPresentationStyle = .popover
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate   = self
        popOverVC?.sourceView = sender // self.button
        let midX: CGFloat = self.filters.bounds.midX
        let midY: CGFloat = self.filters.bounds.minY
        let sourceRect: CGRect = CGRect(x: midX, y: midY, width: 0, height: 0)
        popOverVC?.sourceRect  = sourceRect
        let widthModal  = ScreenSize.screenWidth - 16
        let heightModal = ScreenSize.screenHeight - (ScreenSize.screenWidth * 0.6)
        popVC.preferredContentSize = CGSize(width: widthModal, height: heightModal)
        self.present(popVC, animated: true)
    }
    
    
}


extension TimeLineViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


extension TimeLineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let r = restaurants[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: restaurantCell, for: indexPath) as! RestaurantCell
        cell.setUpView(restaurant: r)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //let currentSection = indexPath.section
        //let currentRow = indexPath.row
        return 300.0 // UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //let currentSection = indexPath.section
        //let currentRow = indexPath.row
        // let r = restaurants[currentRow]
        let vc = PerfilUsuarioViewController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentSection = indexPath.section
        let currentRow = indexPath.row
        return 550.0 // UITableViewAutomaticDimension
    }
    */
}



class RestaurantCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    
    let restaurantImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let nombreRestaurant: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont(name: label.font.fontName, size: 24)
        return label
    }()
    
    let descripcion: UILabel = {
        let label = UILabel()
        label.textColor = .rosa
        return label
    }()
    
    
    let distanciaAprox: UIImageView = {
        let size: CGSize   = CGSize(width: 24.0, height: 24.0)
        let image: UIImage = (UIImage(named: "ubicacion")?.imageResize(sizeChange: size))!
        let imageView   = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let costo: UILabel = {
        let label = UILabel()
        label.textColor = .rosa
        return label
    }()
    
    let kms: UILabel = {
        let label = UILabel()
        label.textColor = .rosa
        return label
    }()
    
    
    func setUpView(restaurant: Restaurant) {
        addSubview(restaurantImage)
        addSubview(nombreRestaurant)
        addSubview(descripcion)
        addSubview(distanciaAprox)
        addSubview(costo)
        addSubview(kms)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: restaurantImage)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: nombreRestaurant)
        addConstraintsWithFormat(format: "H:|-[v0]", views: descripcion)
        addConstraintsWithFormat(format: "H:[v0]-|", views: distanciaAprox)
        addConstraintsWithFormat(format: "H:|-[v0]", views: costo)
        addConstraintsWithFormat(format: "H:[v0]-|", views: kms)
        addConstraintsWithFormat(format: "V:|[v0(200)]-[v1]-[v2]-[v3]",
                                 views: restaurantImage, nombreRestaurant, descripcion, costo)
        addConstraintsWithFormat(format: "V:|[v0(200)]-[v1]-[v2]-[v3]",
                                 views: restaurantImage, nombreRestaurant, distanciaAprox, kms)
        nombreRestaurant.text = restaurant.titulo
        descripcion.text      = restaurant.anfitrion
        costo.text            = restaurant.costo
        kms.text              = restaurant.distancia
        
        
        if !restaurant.imagen.isEmpty {
            let urlImage = URL(string: restaurant.imagen)
            restaurantImage.af_setImage(withURL: urlImage!,
                                        placeholderImage: UIImage(named: "placeholder"),
                                        filter: nil,
                                        progress: nil,
                                        progressQueue: DispatchQueue.main,
                                        imageTransition: .noTransition,
                                        runImageTransitionIfCached: false) { (response) in }
        }
    }
    
    
}







struct Restaurant {
    var id:        String = ""
    var imagen:    String = ""
    var distancia: String = ""
    var titulo:    String = ""
    var anfitrion: String = ""
    var costo:     String = ""
    var dictionaryRestaurant: [String:Any]?
    init(restaurant: Dictionary<String, Any>) {
        dictionaryRestaurant = restaurant
        if let id = restaurant["Id"] as? String {
            self.id = id
        }
        if let imagen = restaurant["imagen"] as? String {
            self.imagen = imagen
        }
        if let distancia = restaurant["distancia"] as? String {
            self.distancia = distancia
        }
        if let titulo = restaurant["titulo"] as? String {
            self.titulo = titulo
        }
        if let anfitrion = restaurant["anfitrion"] as? String {
            self.anfitrion = anfitrion
        }
        if let costo = restaurant["costo"] as? String {
            self.costo = costo
        }
    }
    func toDictionary() -> [String:Any]? {
        return self.dictionaryRestaurant
    }
}



