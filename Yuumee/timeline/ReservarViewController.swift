//
//  ReservarViewController.swift
//  Yuumee
//
//  Created by Luis Segoviano on 2/4/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

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
        textField.font = UIFont.init(name: "ArchiaRegular", size: 10)
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
        
        let notifier = NotificationCenter.default
        notifier.addObserver(self, selector: #selector(keyboardWillAppear),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        notifier.addObserver(self, selector: #selector(keyboardWillDisappear),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)
        
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
        
        
        if let platillo = infoUsuario["saucer"] as? Dictionary<String, AnyObject> {
            self.idPlatillo = (platillo["id_platillo"] as? String)!
        }
        
        
        if let bebidasPostres = infoUsuario["extra_saucer"] as? [Dictionary<String, AnyObject>] {
            for bp in bebidasPostres {
                let tipo = bp["tipo"] as! String
                var newArray = bp
                if tipo == "1" {
                    let id = bp["Id"] as! String
                    newArray["total_seleccionado"] = "" as AnyObject
                    newArray["total_por_cada_bebida"] = "" as AnyObject
                    self.bebidasParams[id] = [newArray] as [AnyObject] //append( [id: newArray as AnyObject] )
                    
                    let newbp = BebidaPostre(bebidapostre: bp)
                    self.bebidas.append(newbp)
                }
                if self.bebidas.count > 0 {
                    self.collectionBebidas.reloadData()
                }
                
                if tipo == "2" {
                    let id = bp["Id"] as! String
                    newArray["total_seleccionado"] = "" as AnyObject
                    newArray["total_por_cada_postre"] = "" as AnyObject
                    self.postresParams[id] = [newArray as AnyObject] // append( [id: newArray as AnyObject] )
                    
                    let newbp = BebidaPostre(bebidapostre: bp)
                    self.postres.append(newbp)
                }
                if self.postres.count > 0 {
                    self.collectionPostres.reloadData()
                }
            } // For
        } // If
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        // DESPLAZAMIENTO QUE SE LE HACE AL TABLEVIEW AL MOSTRARSE EL KEYBOARD
        self.view.frame.origin.y -= 170
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification){
        // REGRESA EL TABLEVIEW A LA NORMALIDAD CUANDO DESAPARECE EL KEYBOARD
        self.view.frame.origin.y += 170
    }
    
    
    var idPlatillo: String = ""
    
    var infoUsuario: Dictionary<String, AnyObject> = [:]
    
    var bebidasParams = Dictionary<String, Array<AnyObject>>()
    var postresParams = Dictionary<String, Array<AnyObject>>()
    var bebidasPostresParam: [Dictionary<String, AnyObject>] = []
    
    
    /**
     * Evento para enviar los parametros y tealizar la reservacion.
     *
     */
    @objc func nextStep() {
        var costoTempBebidas: Float = 0.0
        for k in self.bebidasParams.keys {
            if let array = self.bebidasParams[k] as? [Dictionary<String, AnyObject>] {
                let bebida = array.first as! Dictionary<String, AnyObject>
                bebidasPostresParam.append( ["id" : bebida["Id"]!,
                                             "cantidad" : bebida["total_seleccionado"]!,
                                             "precio" : bebida["costo_calculo"]!
                    ]
                )
                if let totalPorCadaBebida = bebida["total_por_cada_bebida"] as? Float {
                    costoTempBebidas = costoTempBebidas + totalPorCadaBebida
                }
                
            }
        }
        
        var costoTempPostre: Float = 0.0
        for k in self.postresParams.keys {
            if let array = self.postresParams[k] as? [Dictionary<String, AnyObject>] {
                let postre = array.first as! Dictionary<String, AnyObject>
                bebidasPostresParam.append( ["id" : postre["Id"]!,
                                             "cantidad" : postre["total_seleccionado"]!,
                                             "precio" : postre["costo_calculo"]!
                    ]
                )
                if let totalPorCadaPostre = postre["total_por_cada_postre"] as? Float{
                    costoTempPostre = costoTempPostre + totalPorCadaPostre
                }
                
            }
        }
        
        let info          = infoUsuario["saucer"]
        let costoMenu     = info!["costo_calculo"] as! String
        let tieneAlergias = switchAlergias.isOn
        
        let vc = CostosViewController()
        vc.alergia = tieneAlergias
        vc.alergiaDesc = descEspecifica.text!
        vc.costoMenu = costoMenu
        vc.costoBebidas = costoTempBebidas
        vc.costoPostres = costoTempPostre
        vc.bebidasPostresParam = self.bebidasPostresParam
        vc.idPlatillo = self.idPlatillo
        vc.personasRecibir = numPersonas.text!
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
                cell.delegate = self
                cell.setUpView(bp: bebida)
                return cell
            }
        }
        if collectionView == collectionPostres {
            let postre = postres[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bebidaPostreCell, for: indexPath)
            if let cell = cell as? BebidaPostreCell {
                cell.delegate = self
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


class HeaderClass: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Customize here
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}




extension ReservarViewController: UpdatePriceForBebidaPostre {
    
    func getNewPrice(id: String, newTotal: String, tipo: String) {
        /*
         print(" id: \(id) ")
         print(" newPrice: \(newTotal) ")
         print(" tipo: \(tipo) ")
        */
        
        if tipo == "1" {
            if let array = self.bebidasParams[id] as? [Dictionary<String, AnyObject>] {
                var bebidaPostre = array.first
                let costoBebida = Float((bebidaPostre!["costo_calculo"] as! String))!
                let costoCalculo = costoBebida * Float(newTotal)!
                bebidaPostre!["total_seleccionado"] = newTotal as AnyObject
                bebidaPostre!["total_por_cada_bebida"] = costoCalculo as AnyObject
                self.bebidasParams[id] = [bebidaPostre] as [AnyObject]
            }
        }
        
        if tipo == "2" {
            if let array = self.postresParams[id] as? [Dictionary<String, AnyObject>] {
                var bebidaPostre = array.first
                let costoPostre = Float((bebidaPostre!["costo_calculo"] as! String))!
                let costoCalculo = costoPostre * Float(newTotal)!
                bebidaPostre!["total_por_cada_postre"] = costoCalculo as AnyObject
                bebidaPostre!["total_seleccionado"] = newTotal as AnyObject
                self.postresParams[id] = [bebidaPostre] as [AnyObject]
            }
        }
        
    }
    
    
}






