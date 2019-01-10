//
//  TarjetasViewController.swift
//  Yuumee
//
//  Created by Easy Code on 1/10/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire

class TarjetasViewController: BaseViewController {

    let reuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let dataStorage = UserDefaults.standard
    
    var tarjetas: [Tarjeta] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        
        let back = UIBarButtonItem(image: UIImage(named: "close"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(close))
        
        self.navigationItem.leftBarButtonItem = back
        
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|-[v0]-|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
        
        let headers: HTTPHeaders = ["Accept": "application/json",
                                    "Content-Type" : "application/x-www-form-urlencoded"]
        
        let userId = dataStorage.getUserId()
        let parameters: Parameters = ["funcion"  : "getTokensUser",
                                      "id_user"  : userId] as [String: Any]
        
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
        
        
    }
    
    class TapForDeleteCard: UITapGestureRecognizer {
        var indexPathSelected: IndexPath!
        var idTarjeta: String!
    }
    
    @objc func eliminarTarjeta(sender: TapForDeleteCard) {
        let vc = AlertEliminarTarjeta()
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        vc.indexPathSelected = sender.indexPathSelected
        vc.idTarjeta = sender.idTarjeta
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func close() {
        navigationController?.popViewController(animated: true)
    }
    
}


extension TarjetasViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tarjetas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        cell.releaseView()
        
        cell.selectionStyle = .none
        
        let nTarjeta = tarjetas[indexPath.row]
        
        let numTarjeta = UILabel()
        numTarjeta.text = " **** **** **** " + nTarjeta.digits
        numTarjeta.textColor = UIColor.darkGray
        numTarjeta.textAlignment = .center
        
        let tapDelete = TapForDeleteCard(target: self, action: #selector(eliminarTarjeta))
        tapDelete.numberOfTouchesRequired = 1
        tapDelete.indexPathSelected = indexPath
        tapDelete.idTarjeta = nTarjeta.id
        
        let eliminar = UIImageView(image: UIImage(named: "trash") )
        eliminar.isUserInteractionEnabled = true
        eliminar.addGestureRecognizer(tapDelete)
        
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
        
        cell.addSubview(eliminar)
        cell.addSubview(tipoImgTarjeta)
        cell.addSubview(numTarjeta)
        
        cell.addConstraintsWithFormat(format: "H:|-[v0]-[v1(25)]-16-[v2(15)]-|", views: numTarjeta, tipoImgTarjeta, eliminar)
        cell.addConstraintsWithFormat(format: "V:|-[v0]-|", views: numTarjeta)
        cell.addConstraintsWithFormat(format: "V:|-[v0(20)]", views: tipoImgTarjeta)
        cell.addConstraintsWithFormat(format: "V:|-[v0(15)]", views: eliminar)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: mainView.frame.size.width, height: 50))
        /*
        let cardImage = UIImage(named: "add")?.imageResize(sizeChange: CGSize(width: 21, height: 21))
        cardImage?.withRenderingMode(.alwaysTemplate)
        let addCard = UIButton(type: .system)
        addCard.setTitle("Agregar tarjeta", for: .normal)
        addCard.setImage(cardImage, for: .normal)
        addCard.imageView?.tintColor = .white
        addCard.backgroundColor = UIColor.verde
        addCard.tintColor = .white
        addCard.layer.cornerRadius = 5
        addCard.semanticContentAttribute = .forceRightToLeft
        addCard.titleEdgeInsets = UIEdgeInsets(top: 5, left: -15, bottom: 5, right: 5)
        addCard.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 15)
        addCard.addTarget(self, action: #selector(openFormAddCard) , for: .touchUpInside)
        addCard.titleLabel?.font = UIFont.boldSystemFont(ofSize: (addCard.titleLabel?.font.pointSize)!)
        */
        
        let addCard = UIButton(type: .system)
        addCard.setTitle("Agregar tarjeta", for: .normal)
        addCard.setTitleColor(UIColor.rosa, for: .normal)
        addCard.layer.cornerRadius = 10
        addCard.contentEdgeInsets = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        addCard.imageView?.contentMode = .scaleAspectFit
        addCard.addBorder(borderColor: UIColor.azul , widthBorder: 2)
        addCard.addTarget(self, action: #selector(openFormAddCard) , for: .touchUpInside)
        
        footerView.addSubview(addCard)
        footerView.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: addCard)
        footerView.addConstraintsWithFormat(format: "V:|-[v0(40)]", views: addCard)
        
        return footerView
        
    }
    
    @objc func openFormAddCard() {
        print(" openFormAddCard ")
        /*
        let vc = AgregarTarjetaViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        */
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    
}





struct Tarjeta {
    
    var id: String
    var digits: String
    var type: String
    var client: String
    
    init(tarjetasArray: Dictionary<String, AnyObject>) {
        self.id = tarjetasArray["id"] as! String
        self.digits = tarjetasArray["digits"] as! String
        self.type = tarjetasArray["type"] as! String
        self.client = tarjetasArray["client"] as! String
    }
    
}



extension TarjetasViewController: DeletCard {
    func eliminarTarjetaProtocol(indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            
            //let indexPath = IndexPath(item: indexPath.row, section: 0)
            self.tarjetas.remove(at: indexPath.row)
            self.tableView.reloadData()
            /*
             self.tableView.beginUpdates()
             self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
             self.tableView.endUpdates()
             */
        }
    }
}




protocol DeletCard {
    func eliminarTarjetaProtocol(indexPath: IndexPath)
}

class AlertEliminarTarjeta: UIViewController {
    
    var delegate: DeletCard?
    
    var indexPathSelected: IndexPath!
    
    var mainView: UIView {
        return self.view
    }
    
    let contentAlert: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.verde
        view.layer.cornerRadius = 10
        return view
    }()
    
    let aviso: UILabel = {
        let label = UILabel()
        label.text = "¿Deseas eliminar esta tarjeta de tu perfil?"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let siButton: UIButton = {
        let button = UIButton()
        button.setTitle("Si", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: (button.titleLabel?.font.pointSize)!)
        return button
    }()
    
    let noButton: UIButton = {
        let button = UIButton()
        button.setTitle("No", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: (button.titleLabel?.font.pointSize)!)
        return button
    }()
    
    var idTarjeta: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        
        let imageClose = UIImage(named: "close")
        let closeImage = UIImageView(image: imageClose)
        closeImage.image?.withRenderingMode(.alwaysTemplate)
        closeImage.tintColor = UIColor.white
        let cerrar = UIButton(type: .system)
        cerrar.setImage(imageClose, for: .normal)
        cerrar.tintColor = .white
        cerrar.addTarget(self, action: #selector(cerrarModal) , for: .touchUpInside)
        
        let height = ScreenSize.screenWidth / 2
        
        contentAlert.addSubview(cerrar)
        contentAlert.addSubview(aviso)
        contentAlert.addSubview(siButton)
        siButton.addTarget(self, action: #selector(eliminarTarjeta) , for: .touchUpInside)
        contentAlert.addSubview(noButton)
        noButton.addTarget(self, action: #selector(close) , for: .touchUpInside)
        contentAlert.addConstraintsWithFormat(format: "H:[v0(25)]-|", views: cerrar)
        contentAlert.addConstraintsWithFormat(format: "H:|-[v0]-|", views: aviso)
        let widthBtn = (ScreenSize.screenWidth / 2) - 32
        contentAlert.addConstraintsWithFormat(format: "H:|-[v0(\(widthBtn))]-(>=8)-[v1(\(widthBtn))]-|", views: siButton, noButton)
        contentAlert.addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1]-16-[v2]", views: cerrar, aviso, siButton)
        contentAlert.addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1]-16-[v2]", views: cerrar, aviso, noButton)
        mainView.addSubview(contentAlert)
        mainView.addConstraintsWithFormat(format: "H:|-[v0]-|", views: contentAlert)
        mainView.addConstraintsWithFormat(format: "V:|-\((mainView.center.y/2))-[v0(\(height))]", views: contentAlert)
        
    }
    
    let dataStorage = UserDefaults.standard
    
    @objc func eliminarTarjeta(sender: AnyObject) {
        // ---------------------------------------------------------------------
        let headers: HTTPHeaders = [
            // "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Accept": "application/json",
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let parameters: Parameters = ["funcion" : "quitTokensUser",
                                      "id_user" : dataStorage.getUserId(),
                                      "id_token" : idTarjeta]
        
        let urlFlorerias = URL(string: BaseURL.baseUrl())!
        Alamofire.request(urlFlorerias, method: .post, parameters: parameters, encoding: ParameterQueryEncoding(), headers: headers).responseJSON
            { (response: DataResponse) in
                
                switch(response.result) {
                    
                case .success(let value):
                    if let result = value as? Dictionary<String, Any> {
                        let statusMsg = result["status_msg"] as? String
                        let state = result["state"] as? String
                        if statusMsg == "OK" && state == "200" {
                            if let data = result["data"] as? [Dictionary<String, AnyObject>] {
                                self.delegate?.eliminarTarjetaProtocol(indexPath: self.indexPathSelected)
                                self.cerrarModal()
                            }
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
        // ---------------------------------------------------------------------
        
    }
    
    @objc func cerrarModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
}




