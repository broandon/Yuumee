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
    var valoracion: String = ""
    var comentarios: String = ""
    var cliente: String = ""
    
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







class HeaderClass: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Customize here
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}



class ReservarViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var dataStorage = UserDefaults.standard
    
    let bebidaPostreCell = "bebidaPostreCell"
    let headerReuseId = "header"
    let reuseId = "cell"
    
    lazy var collectionBebidas: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate  = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.register(HeaderClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseId)
        collectionView.register(BebidaPostreCell.self, forCellWithReuseIdentifier: bebidaPostreCell)
        
        return collectionView
    }()
    
    lazy var collectionPostres: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate  = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.register(HeaderClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseId)
        collectionView.register(BebidaPostreCell.self, forCellWithReuseIdentifier: bebidaPostreCell)
        return collectionView
    }()
    
    let sep: UIView = {
        let sep = UIView()
        sep.backgroundColor = .darkGray
        return sep
    }()
    
    lazy var continuar: UIButton = {
        let frame = CGRect(x: 0, y: 0, width: ScreenSize.screenWidth, height: 50)
        let continuar = UIButton(frame: frame)
        continuar.setTitle("CONTINUAR", for: .normal)
        continuar.setTitleColor( UIColor.rosa , for: .normal)
        continuar.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        return continuar
    }()
    
    var bebidas: [BebidaPostre] = [BebidaPostre]()
    
    var postres: [BebidaPostre] = [BebidaPostre]()
    
    let numeroPersonas: UILabel = {
        let label = UILabel()
        label.text = "No. de personas"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        self.title = "Reservar"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem()
        mainView.addSubview(collectionBebidas)
        mainView.addSubview(collectionPostres)
        mainView.addSubview(continuar)
        mainView.addSubview(sep)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionBebidas)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionPostres)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: sep)
        mainView.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: continuar)
        let height = ScreenSize.screenWidth/2
        mainView.addConstraintsWithFormat(format: "V:|[v0(\(height))][v1(\(height))]-(>=8)-[v2(1)]-16-[v3(50)]-16-|",
                                        views: collectionBebidas, collectionPostres, sep, continuar)
        if let bebidasPostres = infoUsuario["extra_saucer"] as? [Dictionary<String, AnyObject>] {
            for bp in bebidasPostres {
                let tipo = bp["tipo"] as! String
                if tipo == "1" {
                    let newbp = BebidaPostre(bebidapostre: bp)
                    self.bebidas.append(newbp)
                }
                if self.bebidas.count > 0 {
                    self.collectionBebidas.reloadData()
                }
                if tipo == "2" {
                    let newbp = BebidaPostre(bebidapostre: bp)
                    self.postres.append(newbp)
                }
                if self.postres.count > 0 {
                    self.collectionPostres.reloadData()
                }
            }
        }
    }
    
    var infoUsuario: Dictionary<String, AnyObject> = [:]
    
    @objc func nextStep() {
        let vc = ReservarStep2ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: UICollectionView - Delegate & DataSource
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: ScreenSize.screenWidth, height: 50.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseId, for: indexPath as IndexPath)
                headerView.backgroundColor = .white
                let bebidas = ArchiaBoldLabel()
                bebidas.text = collectionView == collectionBebidas ? "Bebidas" : "Postres"
                bebidas.textColor = .rosa
                bebidas.textAlignment = .center
                bebidas.translatesAutoresizingMaskIntoConstraints = false
                headerView.addSubview(bebidas)
                headerView.centerInView(superView: headerView, container: bebidas, sizeV: 40.0, sizeH: 200.0)
                
                return headerView
            
        case UICollectionView.elementKindSectionFooter:
            return UICollectionReusableView()
            
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionBebidas {
            return bebidas.count
        }
        if collectionView == collectionPostres {
            return postres.count
        }
        return 0
    }
    
    let sizeForButtonAdd: CGFloat = 40.0
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionBebidas {
            let bebida = bebidas[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bebidaPostreCell, for: indexPath)
            if let cell = cell as? BebidaPostreCell {
                cell.setUpView(bp: bebida)
                return cell
            }
        }
        if collectionView == collectionPostres {
            let postre = postres[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bebidaPostreCell, for: indexPath)
            if let cell = cell as? BebidaPostreCell {
                cell.setUpView(bp: postre)
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.screenWidth, height: 50)
    }
    
    
}



class BebidaPostreCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let sizeForButtonAdd: CGFloat = 40.0
    
    lazy var add: UIButton = {
        let add: UIButton  = UIButton(type: .system)
        add.tintColor      = .rosa
        add.setTitle("+", for: .normal)
        add.addTarget(self, action: #selector(increment) , for: .touchUpInside)
        return add
    }()
    
    let numberSelected: UILabel = {
        let numberSelected: UILabel  = UILabel()
        numberSelected.textAlignment = .center
        numberSelected.text = "0"
        numberSelected.font = UIFont.init(name: numberSelected.font.familyName, size: 12)
        return numberSelected
    }()
    
    lazy var less: UIButton = {
        let less: UIButton = UIButton(type: .system)
        less.tintColor     = .rosa
        less.setTitle("-", for: .normal)
        less.addTarget(self, action: #selector(decrement) , for: .touchUpInside)
        return less
    }()
    
    let bebidaLbl: UILabel = {
        let bebidaLbl  = UILabel()
        bebidaLbl.font = UIFont.init(name: bebidaLbl.font.familyName, size: 12)
        return bebidaLbl
    }()
    
    let costoBebida: UILabel = {
        let costoBebida  = UILabel()
        costoBebida.font = UIFont.init(name: costoBebida.font.familyName, size: 12)
        return costoBebida
    }()
    
    var bebidaPostre: BebidaPostre!
    
    func setUpView(bp: BebidaPostre) {
        self.bebidaPostre = bp
        addSubview(add)
        addSubview(numberSelected)
        addSubview(less)
        addSubview(bebidaLbl)
        addSubview(costoBebida)
        bebidaLbl.text   = bp.nombre
        costoBebida.text = bp.costo
        addConstraintsWithFormat(format: "H:|-[v0(\(sizeForButtonAdd))]-[v1(50)]-[v2(\(sizeForButtonAdd))]-[v3(90)]-[v4(90)]",
            views: less, numberSelected, add, bebidaLbl, costoBebida)
        addConstraintsWithFormat(format: "V:|[v0(\(sizeForButtonAdd))]", views: add)
        addConstraintsWithFormat(format: "V:|[v0(\(sizeForButtonAdd))]", views: less)
        addConstraintsWithFormat(format: "V:|-[v0(30)]", views: numberSelected)
        addConstraintsWithFormat(format: "V:|-[v0(30)]", views: bebidaLbl)
        addConstraintsWithFormat(format: "V:|-[v0(30)]", views: costoBebida)
        borders(for: [.bottom], width: 1, color: .darkGray)
    }
    
    @objc func increment(sender: Any) {
        let toIncrement = Int(self.numberSelected.text!)!
        let n = toIncrement + 1
        self.numberSelected.text = "\(n)"
    }
    
    @objc func decrement(sender: Any) {
        let toIncrement = Int(self.numberSelected.text!)!
        if toIncrement == 0 {
            return
        }
        let n = toIncrement - 1
        self.numberSelected.text = "\(n)"
    }
    
}







class ReservarStep2ViewController: BaseViewController {
    
    var dataStorage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        self.title = "Reservar"
        let backButton = UIBarButtonItem()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextStep))
        self.navigationItem.rightBarButtonItem = nextButton
        
    }
    
    @objc func nextStep(){
        let vc = CostosViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}






class CostosViewController: BaseViewController {
    
    var dataStorage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        self.title = "Costos"
        let backButton = UIBarButtonItem()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextStep))
        self.navigationItem.rightBarButtonItem = nextButton
        
    }
    
    
    
    @objc func nextStep(){
        let vc = SeleccionarTarjetaViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}







class SeleccionarTarjetaViewController: BaseViewController {
    
    var dataStorage = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        self.title = "Selecciona tarjeta"
        let backButton = UIBarButtonItem()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let nextButton = UIBarButtonItem(title: "root", style: .plain, target: self, action: #selector(reservarEvent))
        self.navigationItem.rightBarButtonItem = nextButton
        
    }
    
    
    @objc func reservarEvent() {
        self.navigationController?.popToRootViewController(animated: true)
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




