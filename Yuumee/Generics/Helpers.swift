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







class HeaderClass: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Customize here
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}



class ReservarViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, UIPopoverPresentationControllerDelegate, NumeroPersonasSeleccionadas {
    
    
    
    var dataStorage = UserDefaults.standard
    
    let bebidaPostreCell = "bebidaPostreCell"
    let headerReuseId    = "header"
    let reuseId          = "cell"
    
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
    
    // Elementos para seccion de numero depersonas
    
    let numeroPersonas: UILabel = {
        let label = UILabel()
        label.text = "No. de personas"
        return label
    }()
    lazy var numPersonas: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.rightViewMode = .always
        let frame: CGRect = CGRect(x: 0, y: 0, width: 20, height: 20)
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "down_arrow")
        imageView.image = image
        textField.rightView = imageView
        textField.textAlignment = .center
        textField.text = "1"
        return textField
    }()
    let contenedorNumPersonas: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    // Elementos para el Switch de de Alergia
    let alergia: UILabel = {
        let label = UILabel()
        label.text = "¿Eres alérgico?"
        return label
    }()
    lazy var switchAlergias: CustomSwitch = {
        let switchP  = CustomSwitch(frame: CGRect.zero)
        switchP.isOn = false
        switchP.padding = 0
        switchP.onTintColor  = UIColor.rosa
        switchP.offTintColor = UIColor.darkGray
        switchP.cornerRadius = 0.5
        switchP.thumbCornerRadius = 0.5
        switchP.thumbSize = CGSize(width: 30, height: 30)
        switchP.thumbTintColor = UIColor.white
        switchP.animationDuration = 0.25
        switchP.addTarget(self, action: #selector(alergiaEvent), for: .valueChanged)
        return switchP
    }()
    let contenedorAlergias: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    // Elementos para descripcion de alergias
    let especifica: UILabel = {
        let label = UILabel()
        label.text = "Especifica a qué"
        return label
    }()
    let descEspecifica: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .gris
        return textField
    }()
    let contenedorEspecifica: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        self.title = "Reservar"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem()
        self.hideKeyboardWhenTappedAround()
        mainView.addSubview(collectionBebidas)
        mainView.addSubview(collectionPostres)
        mainView.addSubview(continuar)
        mainView.addSubview(sep)
        mainView.addSubview(contenedorNumPersonas)
        mainView.addSubview(contenedorAlergias)
        mainView.addSubview(contenedorEspecifica)
        
        let height = (ScreenSize.screenWidth/2) - 10
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionBebidas)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionPostres)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: sep)
        mainView.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: continuar)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: contenedorNumPersonas)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: contenedorAlergias)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: contenedorEspecifica)
        
        mainView.addConstraintsWithFormat(format: "V:|[v0(\(height))][v1(\(height))]-[v2(40)]-[v3(40)]-[v4(70)]-[v5(1)]-[v6(50)]",
                                        views: collectionBebidas, collectionPostres, contenedorNumPersonas, contenedorAlergias, contenedorEspecifica, sep, continuar)
        contenedorNumPersonas.addSubview(numeroPersonas)
        contenedorNumPersonas.addSubview(numPersonas)
        contenedorNumPersonas.addConstraintsWithFormat(format: "H:|-[v0(150)]", views: numeroPersonas)
        contenedorNumPersonas.addConstraintsWithFormat(format: "H:[v0(150)]-|", views: numPersonas)
        contenedorNumPersonas.addConstraintsWithFormat(format: "V:|-[v0]", views: numeroPersonas)
        contenedorNumPersonas.addConstraintsWithFormat(format: "V:|-[v0]", views: numPersonas)
        
        contenedorAlergias.addSubview(alergia)
        contenedorAlergias.addSubview(switchAlergias)
        contenedorAlergias.addConstraintsWithFormat(format: "H:|-[v0(150)]", views: alergia)
        contenedorAlergias.addConstraintsWithFormat(format: "H:[v0(70)]-|", views: switchAlergias)
        contenedorAlergias.addConstraintsWithFormat(format: "V:|-[v0]", views: alergia)
        contenedorAlergias.addConstraintsWithFormat(format: "V:|-[v0(35)]", views: switchAlergias)
        
        contenedorEspecifica.addSubview(especifica)
        contenedorEspecifica.addSubview(descEspecifica)
        contenedorEspecifica.addConstraintsWithFormat(format: "H:|-[v0(150)]", views: especifica)
        contenedorEspecifica.addConstraintsWithFormat(format: "H:[v0(200)]-|", views: descEspecifica)
        contenedorEspecifica.addConstraintsWithFormat(format: "V:|-[v0]", views: especifica)
        contenedorEspecifica.addConstraintsWithFormat(format: "V:|-[v0(60)]", views: descEspecifica)
        
        
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
        let vc = CostosViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func alergiaEvent() {
        print(" alergiaEvent ")
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        numPersonas.resignFirstResponder()
        // Modal
        let vc = NumeroPersonasViewController()
        vc.delegate = self
        vc.currentPerson = numPersonas.text!
        let popVC = UINavigationController(rootViewController: vc)
        popVC.modalPresentationStyle = .popover
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.permittedArrowDirections = .any
        popOverVC?.delegate = self
        popOverVC?.sourceView = numPersonas // self.button
        let midX: CGFloat = self.numPersonas.bounds.midX
        let midY: CGFloat = self.numPersonas.bounds.minY
        let frame = CGRect(x: midX, y: midY, width: 0, height: 0)
        popOverVC?.sourceRect = frame
        let widthModal = ScreenSize.screenWidth - 16
        let heightModal = (ScreenSize.screenWidth / 2)
        popVC.preferredContentSize = CGSize(width: widthModal, height: heightModal)
        self.present(popVC, animated: true)
        return false
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func getNumeroPersonas(numero: String) {
        numPersonas.text = numero
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


/**
 *  VENTANA - MODAL
 *
 */
class NumeroPersonasViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cerrarBtn: UIBarButtonItem = {
        let sizeImg = CGSize(width: 24, height: 24)
        let imgClose = UIImage(named: "close")?.imageResize(sizeChange: sizeImg)
        let cerrarBtn = UIBarButtonItem(image: imgClose, style: .plain,
                                        target: self, action: #selector(closeVC) )
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
    
    let personas = ["1", "2", "3", "4", "5"]
    var delegate: NumeroPersonasSeleccionadas?
    var currentPerson = ""
    
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
        return personas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        // cell.releaseView()
        let num = personas[indexPath.row]
        if num == currentPerson {
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.text = num
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentIndex: Int = indexPath.row
        let persona = personas[currentIndex]
        self.dismiss(animated: true, completion: {
            self.delegate?.getNumeroPersonas(numero: persona)
        })
    }
    
}
protocol NumeroPersonasSeleccionadas {
    func getNumeroPersonas(numero: String)
}











class CostosViewController: BaseViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var dataStorage = UserDefaults.standard
    
    private func getSimpleLabel(texto: String) -> UILabel {
        let label  = UILabel()
        label.text = texto
        label.textAlignment = .center
        return label
    }
    
    private func getSimpleTextField() -> UITextField {
        let textField = UITextField()
        textField.delegate = self
        textField.addBorder(borderColor: .gris, widthBorder: 1.0)
        return textField
    }
    
    lazy var continuar: UIButton = {
        let frame = CGRect(x: 0, y: 0, width: ScreenSize.screenWidth, height: 50)
        let continuar = UIButton(frame: frame)
        continuar.setTitle("CONTINUAR", for: .normal)
        continuar.setTitleColor( UIColor.rosa , for: .normal)
        continuar.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        return continuar
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
    
    let secciones = ["menu", "bebidas", "postres", "costo_total"]
    
    var menu: UILabel!
    var bebidas: UILabel!
    var postres: UILabel!
    var menuMx: UILabel!
    var bebidasMx: UILabel!
    var postresMx: UILabel!
    var menuInput: UITextField!
    var bebidasInput: UITextField!
    var postresInput: UITextField!
    var totalInput: UITextField!
    var costoTotal: UILabel!
    var costoTotalMx: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        self.title = "Costos"
        let backButton = UIBarButtonItem()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        menu       = getSimpleLabel(texto: "Menú: $")
        bebidas    = getSimpleLabel(texto: "Bebidas: $")
        postres    = getSimpleLabel(texto: "Postres: $")
        menuMx     = getSimpleLabel(texto: ".00 mxn")
        bebidasMx  = getSimpleLabel(texto: ".00 mxn")
        postresMx  = getSimpleLabel(texto: ".00 mxn")
        menuInput    = getSimpleTextField()
        bebidasInput = getSimpleTextField()
        postresInput = getSimpleTextField()
        totalInput   = getSimpleTextField()
        costoTotal   = getSimpleLabel(texto: "Costo total: $")
        costoTotalMx = getSimpleLabel(texto: ".00 mxn")
        
        
        let customFooter = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.screenWidth, height: 50))
        customFooter.backgroundColor = UIColor.white
        customFooter.addSubview(continuar)
        tableView.tableFooterView = customFooter
        
        let sep = UIView()
        sep.backgroundColor = .darkGray
        mainView.addSubview(tableView)
        mainView.addSubview(continuar)
        mainView.addSubview(sep)
        
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: sep)
        mainView.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: continuar)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]-[v1(1)]-[v2(40)]-|",
                                          views: tableView, sep, continuar)
        
    }
    
    
    
    @objc func nextStep(){
        let vc = SeleccionarTarjetaViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return secciones.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        
        let seccion = secciones[indexPath.row]
        
        if seccion == "menu" {
            cell.addSubview(menu)
            cell.addSubview(menuInput)
            cell.addSubview(menuMx)
            cell.addConstraintsWithFormat(format: "H:|-[v0(90)]-[v1]-[v2(90)]-|",
                                          views: menu, menuInput, menuMx)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: menu)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: menuInput)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: menuMx)
            return cell
        }
        
        if seccion == "bebidas" {
            cell.addSubview(bebidas)
            cell.addSubview(bebidasInput)
            cell.addSubview(bebidasMx)
            cell.addConstraintsWithFormat(format: "H:|-[v0(90)]-[v1]-[v2(90)]-|",
                                          views: bebidas, bebidasInput, bebidasMx)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: bebidas)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: bebidasInput)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: bebidasMx)
            return cell
        }
        
        if seccion == "postres" {
            cell.addSubview(postres)
            cell.addSubview(postresInput)
            cell.addSubview(postresMx)
            cell.addConstraintsWithFormat(format: "H:|-[v0(90)]-[v1]-[v2(90)]-|",
                                          views: postres, postresInput, postresMx)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: postres)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: postresInput)
            cell.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: postresMx)
            
            return cell
        }
        
        if seccion == "costo_total" {
            cell.addSubview(costoTotal); costoTotal.addBorder()
            cell.addSubview(totalInput)
            cell.addSubview(costoTotalMx); costoTotalMx.addBorder()
            cell.addConstraintsWithFormat(format: "H:[v0(110)]-[v1(90)]-[v2(70)]-|",
                                          views: costoTotal, totalInput, costoTotalMx)
            cell.addConstraintsWithFormat(format: "V:[v0(30)]-|", views: costoTotal)
            cell.addConstraintsWithFormat(format: "V:[v0(30)]-|", views: totalInput)
            cell.addConstraintsWithFormat(format: "V:[v0(30)]-|", views: costoTotalMx)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let seccion = secciones[indexPath.row]
        if seccion == "costo_total" {
            return 200.0
        }
        return 70.0
    }
    
    
} // CostosViewController







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




