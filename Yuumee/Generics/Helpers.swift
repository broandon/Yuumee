//
//  Helpers.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/11/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ScreenSize {
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
}



enum TipoTarjeta: String {
    case american_express = "AMEX" // 3
    case visa             = "VISA" // 4
    case master_card      = "MASTER CARD" // 5
}


enum TipoUsuario: Int {
    case anfitrion = 2
    case cliente   = 3
}


enum TipoComida: String {
    case desayuno = "1"
    case comida   = "2"
    case cena     = "3"
}

class Utils {
    
    typealias callbackAlert = ((UIAlertAction) -> Void)?
    
    static func showSimpleAlert(message: String!, context: UIViewController, success: callbackAlert ) {
        let alertController = UIAlertController(title: "Yuumee",
                                                message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        let dismissAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: success)
        alertController.addAction(dismissAction)
        context.present(alertController, animated: true, completion: nil)
    }
    
}




struct ParameterQueryEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = parameters?
            .map { "\($0)=\($1)" }
            .joined(separator: "&")
            .data(using: .utf8)
        return request
    }
}

class BaseURL {
    private static let scheme = "http://"
    private static var host = "easycode.mx/"
    private static let path = "yuumee/webservice/controller_last.php"
    
    /**
     * Retorna la URL base para hacer el request
     *
     */
    class func baseUrl() -> String {
        return scheme + host + path
    }
}





class CategoriasComidaViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cerrarBtn: UIBarButtonItem = {
        let sizeImg   = CGSize(width: 24, height: 24)
        let imgClose  = UIImage(named: "close")?.imageResize(sizeChange: sizeImg)
        let cerrarBtn = UIBarButtonItem(image: imgClose, style: .plain,
                                        target: self, action: #selector(closeVC))
        cerrarBtn.tintColor = .white
        return cerrarBtn
    }()
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // let secciones = ["Regional", "Ocasional", "Mediterranea", "Chida", "Una mas"]
    var categorias = [Categoria]()
    
    var delegate: FoodSelected?
    
    var currentFood = ""
    
    let dataStorage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = UIColor.gris
        cerrarBtn.target = self
        self.navigationItem.leftBarButtonItem = cerrarBtn
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
        // ---------------------------------------------------------------------
        let headers: HTTPHeaders = [
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
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Data Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorias.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        // cell.releaseView()
        let seccion = categorias[indexPath.row]
        if seccion.titulo == currentFood {
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.text = seccion.titulo
        cell.textLabel?.textAlignment = .center
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seccion = categorias[indexPath.row]
        self.dismiss(animated: true, completion: {
            self.delegate?.getFoodSelected(food: seccion)
        })
    }
    
}
protocol FoodSelected {
    func getFoodSelected(food: Categoria)
}


/**
 *
 * SUB-Categorias
 *
 **/
class SubCategoriasComidaViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cerrarBtn: UIBarButtonItem = {
        let sizeImg = CGSize(width: 24, height: 24)
        let imgClose = UIImage(named: "close")?.imageResize(sizeChange: sizeImg)
        let cerrarBtn = UIBarButtonItem(image: imgClose, style: .plain, target: self, action: #selector(closeVC) )
        cerrarBtn.tintColor = .white
        return cerrarBtn
    }()
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // let secciones = ["Regional", "Ocasional", "Mediterranea", "Chida", "Una mas"]
    var categorias = [Categoria]()
    
    var delegate: SubCategoriaFoodSelected?
    
    var currentFood = ""
    
    let dataStorage = UserDefaults.standard
    
    var idSubCategoria: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = UIColor.gris
        cerrarBtn.target = self
        self.navigationItem.leftBarButtonItem = cerrarBtn
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
        // ---------------------------------------------------------------------
        if !idSubCategoria.isEmpty {
            let headers: HTTPHeaders = [
                "Accept" : "application/json",
                "Content-Type" : "application/x-www-form-urlencoded"
            ]
            let parameters: Parameters = ["funcion" : "getSubCategories",
                                          "id_cat" : idSubCategoria] as [String: Any]
            Alamofire.request(BaseURL.baseUrl() , method: .post, parameters: parameters,
                              encoding: ParameterQueryEncoding(), headers: headers).responseJSON{ (response: DataResponse) in
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
            
        }
        
        // ---------------------------------------------------------------------
        
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Data Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorias.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        // cell.releaseView()
        let seccion = categorias[indexPath.row]
        if seccion.titulo == currentFood {
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.text = seccion.titulo
        cell.textLabel?.textAlignment = .center
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seccion = categorias[indexPath.row]
        self.dismiss(animated: true, completion: {
            self.delegate?.getSubFoodSelected(food: seccion)
        })
    }
    
}
protocol SubCategoriaFoodSelected {
    func getSubFoodSelected(food: Categoria)
}




class WebViewController: UIViewController, UIWebViewDelegate {
    var mainView: UIView {
        return self.view
    }
    
    var url: String?
    var titleVC: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
        let imageBtn = UIImage(named: "back")?.imageResize(sizeChange: CGSize(width: 30.0, height: 30.0))
        let back = UIButton(type: .system)
        back.setImage(imageBtn, for: .normal)
        //back.setTitle(titleVC, for: .normal)
        back.titleLabel?.textColor = .white
        back.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        back.imageEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 0)
        back.addTarget(self, action: #selector(regresar), for: .touchUpInside)
        back.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: back)
        let webView = UIWebView()
        mainView.addSubview(webView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: webView)
        mainView.addConstraintsWithFormat(format: "V:|[v0]|", views: webView)
        if !(url?.isEmpty)! {
            let url = NSURL(string: self.url!)
            let requestObj = NSURLRequest(url: url! as URL)
            webView.delegate = self
            webView.loadRequest(requestObj as URLRequest)
        }
    }
    
    @objc func regresar() {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}


let TAG_DESCRIPCION_EVENT: Int  = 121212

let TAG_MENU_EVENT: Int         = 213141
let TAG_BEBIDAS_EVENT: Int      = 146777
let TAG_POSTRES_EVENT: Int      = 324566

let TAG_COSTO_MENU_EVENT: Int   = 214532
let TAG_COSTO_BEBIDAS_EVENT:Int = 121980
let TAG_COSTO_POSTRES_EVENT:Int = 232167

let TAG_TITULO_EVENT: Int       = 989876
let TAG_COMIENZA_EVENT: Int     = 565678
let TAG_TERMINA_EVENT: Int      = 324564




struct BebidaPostre {
    
    var id: String     = ""
    var costo: String  = ""
    var tipo: String   = ""
    var nombre: String = ""
    
    init(bebidapostre: Dictionary<String, Any>) {
        if let id = bebidapostre["Id"] as? String {
            self.id = id
        }
        if let costo = bebidapostre["costo"] as? String {
            self.costo = costo
        }
        if let tipo = bebidapostre["tipo"] as? String {
            self.tipo = tipo
        }
        if let nombre = bebidapostre["nombre"] as? String {
            self.nombre = nombre
        }
    }
    
}



struct PlatilloEvento {
    
    var id: String          = ""
    var costo: String       = ""
    var titulo: String      = ""
    var descripcion: String = ""
    var menu: String        = ""
    var fecha: String       = ""
    var horario: String     = ""
    var capacidad: String   = ""
    
    init(platillo: Dictionary<String, Any>) {
        if let id = platillo["id"] as? String {
            self.id = id
        }
        if let costo = platillo["costo"] as? String {
            self.costo = costo
        }
        if let titulo = platillo["titulo"] as? String {
            self.titulo = titulo
        }
        if let descripcion = platillo["descripcion"] as? String {
            self.descripcion = descripcion
        }
        if let menu = platillo["menu"] as? String {
            self.menu = menu
        }
        if let fecha = platillo["fecha"] as? String {
            self.fecha = fecha
        }
        if let horario = platillo["horario"] as? String {
            self.horario = horario
        }
        if let capacidad = platillo["capacidad"] as? String {
            self.capacidad = capacidad
        }
    }
    
}






struct CommentPlatillo {
    
    var id_calificacion_anfitrion: String = ""
    var valoracion: String  = ""
    var comentarios: String = ""
    var cliente: String     = ""
    
    init(comment: Dictionary<String, Any>) {
        if let id_calificacion_anfitrion = comment["id_calificacion_anfitrion"] as? String {
            self.id_calificacion_anfitrion = id_calificacion_anfitrion
        }
        if let valoracion = comment["valoracion"] as? String {
            self.valoracion = valoracion
        }
        if let comentarios = comment["comentarios"] as? String {
            self.comentarios = comentarios
        }
        if let cliente = comment["cliente"] as? String {
            self.cliente = cliente
        }
    }
    
}




class CollectionRank: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    let numberOfStars = 5
    
    var numberRank = 0
    
    func setUpView(numberofStars: Int = 0) {
        backgroundColor = .clear
        self.numberRank = numberofStars
        collectionView.delegate   = self
        collectionView.dataSource = self
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfStars
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.releaseView()
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        if indexPath.row < numberRank {
            imageView.image = UIImage(named: "star")
        }
        else {
            imageView.image = UIImage()
        }
        imageView.image = imageView.changeImageColor(color: .rosa)
        cell.addSubview(imageView)
        cell.centerInView(superView: cell, container: imageView, sizeV: 16, sizeH: 16)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
    
}












class NumeroInvitadosViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cerrarBtn: UIBarButtonItem = {
        let sizeImg = CGSize(width: 24, height: 24)
        let imgClose = UIImage(named: "close")?.imageResize(sizeChange: sizeImg)
        let cerrarBtn = UIBarButtonItem(image: imgClose, style: .plain, target: self, action: #selector(closeVC) )
        cerrarBtn.tintColor = .white
        return cerrarBtn
    }()
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // Se declara como VAR, pues varia el listado que se listará. Se usa en otros lugares
    var secciones = ["1", "2", "3", "4", "5"]
    
    
    var delegate: NumeroInvitadosSelected?
    
    let dataStorage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = UIColor.gris
        cerrarBtn.target = self
        self.navigationItem.leftBarButtonItem = cerrarBtn
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Data Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        // cell.releaseView()
        let seccion = secciones[indexPath.row]
        /*if seccion.titulo == currentFood {
            cell.accessoryType = .checkmark
        }*/
        cell.textLabel?.text = seccion
        cell.textLabel?.textAlignment = .center
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seccion = secciones[indexPath.row]
        self.dismiss(animated: true, completion: {
            self.delegate?.getNumeroSelected(numero: seccion)
        })
    }
    
}
protocol NumeroInvitadosSelected {
    func getNumeroSelected(numero: String)
}




class SeparatorOr: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func getView() -> UIView {
        let view = UIView()
        view.backgroundColor = .rosa
        return view
    }
    let or: UILabel = {
        let label = UILabel()
        label.text = "Ó"
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .rosa
        return label
    }()
    func setUpView(){
        let sep1 = getView()
        let sep2 = getView()
        addSubview(sep1)
        addSubview(or)
        addSubview(sep2)
        addConstraintsWithFormat(format: "H:|[v0(v1)][v1(v1)][v2(v1)]|", views: sep1, or, sep2)
        addConstraintsWithFormat(format: "V:|-[v0(1)]", views: sep1)
        addConstraintsWithFormat(format: "V:|[v0(14)]|", views: or)
        addConstraintsWithFormat(format: "V:|-[v0(1)]", views: sep2)
    }
}




class TutorialViewController: BaseViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let imageNames: [String] = ["tutorial1", "tutorial2", "tutorial3", "tutorial4", "tutorial5"]
    
    let dataStorage = UserDefaults.standard
    
    private let reuseId = "cell"
    
    lazy var collectionView: UICollectionView = {
        let frame: CGRect = CGRect.zero
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection         = .horizontal
        layout.minimumLineSpacing      = 1
        layout.minimumInteritemSpacing = 1
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        //pageControl.numberOfPages = 5 // PagerViewController.views.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.red
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .rosa
        pageControl.layer.zPosition = 5
        pageControl.transform = CGAffineTransform(scaleX: 1, y: 1)
        pageControl.isUserInteractionEnabled = false
        //pageControl.layer.zPosition = 10
        return pageControl
    }()
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    lazy var closeVC: UIButton = {
        let size = CGSize(width: 10, height: 15)
        let image = UIImage(named: "cerrar") //?.imageResize(sizeChange: size)
        let close = UIButton(type: .system)
        //close.setTitle("Volver", for: .normal)
        close.setImage(image, for: .normal)
        //close.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        close.addTarget(self, action: #selector(closeEvent), for: .touchUpInside)
        close.tintColor = .white
        return close
    }()
    
    
    lazy var regresar: UIButton = {
        let size = CGSize(width: 25, height: 25)
        let image = UIImage(named: "atras")//?.imageResize(sizeChange: size)
        let close = UIButton(type: .system)
        //close.setTitle(StringConstants.volver, for: .normal)
        close.setImage(image, for: .normal)
        close.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        close.tintColor = UIColor.white
        close.addTarget(self, action: #selector(regresarEvent), for: .touchUpInside)
        close.titleLabel!.font = UIFont.boldSystemFont(ofSize: (close.titleLabel?.font.pointSize)!)
        //close.backgroundColor = UIColor.grisClaro
        close.layer.cornerRadius = 15
        return close
    }()
    
    
    lazy var continuar: UIButton = {
        let size = CGSize(width: 25, height: 25)
        let image = UIImage(named: "adelante")//?.imageResize(sizeChange: size)
        let close = UIButton(type: .system)
        //close.setTitle(StringConstants.continuar, for: .normal)
        close.setImage(image, for: .normal)
        close.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        close.tintColor = UIColor.white
        close.addTarget(self, action: #selector(continuarEvent), for: .touchUpInside)
        close.semanticContentAttribute = .forceRightToLeft
        close.titleLabel!.font = UIFont.boldSystemFont(ofSize: (close.titleLabel?.font.pointSize)!)
        //close.backgroundColor = UIColor.grisClaro
        close.layer.cornerRadius = 15
        return close
    }()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        mainView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.navigationController?.isNavigationBarHidden = true
        
        mainView.addSubview(collectionView)
        mainView.addSubview(closeVC)
        
        mainView.addConstraintsWithFormat(format: "H:|-[v0]-|", views: collectionView)
        mainView.addConstraintsWithFormat(format: "H:[v0(25)]-|", views: closeVC)
        mainView.addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1]-|", views: closeVC, collectionView)
        
        mainView.addSubview(regresar)
        mainView.addSubview(continuar)
        
        mainView.addConstraintsWithFormat(format: "H:|-[v0(40)]", views: regresar)
        mainView.addConstraintsWithFormat(format: "H:[v0(40)]-|", views: continuar)
        let topMarginYCenter = mainView.center.y
        mainView.addConstraintsWithFormat(format: "V:|-(\(topMarginYCenter))-[v0(40)]", views: regresar)
        mainView.addConstraintsWithFormat(format: "V:|-(\(topMarginYCenter))-[v0(40)]", views: continuar)
        
        
        //pageControl.numberOfPages = imageNames.count // PagerViewController.views.count
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let imageName = imageNames[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)
        
        cell.backgroundColor = .rosa
        
        let image: UIImage = UIImage(named: imageName)!
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        cell.addSubview(imageView)
        cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: imageView)
        cell.addConstraintsWithFormat(format: "V:|-[v0]-|", views: imageView)
        cell.layer.cornerRadius = 15
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.section
    }
    
    // Cerrar vista
    @objc func closeEvent() {
        dataStorage.wasTutorialFollowed(saved: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func regresarEvent() {
        // pageViewController.goToPreviousPage(animated: true, pages: self.pages, pageControl: self.pageControl)
        self.collectionView.scrollToPreviousItem()
    }
    
    @objc func continuarEvent() {
        // pageViewController.goToNextPage(animated: true, pages: self.pages, pageControl: self.pageControl)
        self.collectionView.scrollToNextItem()
    }
    
    
}







/*
class ComidasCategoriasPaisesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cerrarBtn: UIBarButtonItem = {
        let sizeImg = CGSize(width: 24, height: 24)
        let imgClose = UIImage(named: "close")?.imageResize(sizeChange: sizeImg)
        let cerrarBtn = UIBarButtonItem(image: imgClose, style: .plain, target: self, action: #selector(closeVC) )
        cerrarBtn.tintColor = .white
        return cerrarBtn
    }()
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let secciones = ["Italiana", "Francesa", "Americana", "Asiática", "Otros"]
    
    var delegate: FoodCategorySelectedCountry?
    
    var currentFood = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = UIColor.gris
        cerrarBtn.target = self
        self.navigationItem.leftBarButtonItem = cerrarBtn
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Data Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        // cell.releaseView()
        let seccion = secciones[indexPath.row]
        if seccion == currentFood {
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.text = seccion
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seccion = secciones[indexPath.row]
        self.dismiss(animated: true, completion: {
            self.delegate?.getFoodSelected(food: seccion)
        })
    }
    
}

protocol FoodCategorySelectedCountry {
    func getFoodSelected(food: String)
}
*/




