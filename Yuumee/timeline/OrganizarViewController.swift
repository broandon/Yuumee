//
//  OrganizarViewController.swift
//  Yuumee
//
//  Created by Luis Segoviano on 1/19/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

protocol ParamsForFiltersByOrganizar {
    func getParamsOrg(params: Dictionary<String, String>)
}

class OrganizarViewController: BaseViewController, UITextFieldDelegate {
    
    var delegate: ParamsForFiltersByOrganizar?
    
    let checkBoxDesayuno: UIView = {
        let view = UIView()
        view.addBorder(borderColor: UIColor.black, widthBorder: 2)
        view.isUserInteractionEnabled = true
        return view
    }()
    let checkBoxComida: UIView = {
        let view = UIView()
        view.addBorder(borderColor: UIColor.black, widthBorder: 2)
        view.isUserInteractionEnabled = true
        return view
    }()
    let checkBoxCena: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.addBorder(borderColor: UIColor.black, widthBorder: 2)
        return view
    }()
    
    let desayuno: ArchiaBoldLabel = {
        let label = ArchiaBoldLabel()
        label.text = "Desayuno"
        return label
    }()
    let comida: ArchiaBoldLabel = {
        let label = ArchiaBoldLabel()
        label.text = "Comida"
        return label
    }()
    let cena: ArchiaBoldLabel = {
        let label = ArchiaBoldLabel()
        label.text = "Cena"
        return label
    }()
    
    
    let noPersonas: ArchiaRegularLabel = {
        let label = ArchiaRegularLabel()
        label.text = "No. de personas"
        return label
    }()
    
    let noPersonasTxt: UITextField = {
        /*let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "down_arrow")
        imageView.image = image*/
        let textField = UITextField()
        textField.addBorder(borderColor: .gray, widthBorder: 1)
        textField.layer.cornerRadius = 10
        textField.keyboardType  = .numberPad
        textField.placeholder   = "1"
        textField.text = "1"
        textField.textAlignment = .center
        //textField.rightViewMode = UITextField.ViewMode.always
        //textField.rightView = imageView
        return textField
    }()
    
    let listo: UIButton = {
        let button: UIButton    = UIButton(type: .system)
        button.backgroundColor  = UIColor.gris
        button.tintColor        = UIColor.darkGray
        let sizeFont: CGFloat   = (button.titleLabel?.font.pointSize)!
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: sizeFont)
        button.setTitle("Listo", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        self.hideKeyboardWhenTappedAround()
        mainView.addSubview(desayuno)
        mainView.addSubview(comida)
        mainView.addSubview(cena)
        mainView.addSubview(checkBoxDesayuno)
        mainView.addSubview(checkBoxComida)
        mainView.addSubview(checkBoxCena)
        mainView.addSubview(noPersonas)
        mainView.addSubview(noPersonasTxt)
        noPersonasTxt.delegate = self
        mainView.addSubview(listo)
        
        let sizeCheck: CGFloat = 20.0
        
        mainView.addConstraintsWithFormat(format: "H:|-[v0(\(sizeCheck))]-[v1(v5)]-[v2(\(sizeCheck))]-[v3(v5)]-[v4(\(sizeCheck))]-[v5(v5)]-|",
                                 views: checkBoxDesayuno, desayuno, checkBoxComida, comida, checkBoxCena, cena)
        mainView.addConstraintsWithFormat(format: "H:|-[v0(130)]-[v1(100)]",
                                          views: noPersonas, noPersonasTxt)
        mainView.addConstraintsWithFormat(format: "H:|-[v0]-32-|", views: listo)
        mainView.addConstraintsWithFormat(format: "V:|-4-[v0(\(sizeCheck))]-32-[v1(30)]",
                                          views: checkBoxDesayuno, noPersonas)
        mainView.addConstraintsWithFormat(format: "V:|-4-[v0(\(sizeCheck))]-32-[v1(30)]",
                                        views: checkBoxComida, noPersonasTxt)
        mainView.addConstraintsWithFormat(format: "V:|-4-[v0(\(sizeCheck))]",
                                          views: checkBoxCena)
        mainView.addConstraintsWithFormat(format: "V:|-6-[v0]", views: comida)
        mainView.addConstraintsWithFormat(format: "V:|-6-[v0]", views: desayuno)
        mainView.addConstraintsWithFormat(format: "V:|-6-[v0]", views: cena)
        let sizeBtn = ScreenSize.screenWidth - 40
        mainView.addConstraintsWithFormat(format: "V:|-(\(sizeBtn))-[v0(40)]",
                                          views: listo)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let tapCheckDesayuno = UITapGestureRecognizer(target: self, action: #selector(checkDesayuno))
        tapCheckDesayuno.numberOfTapsRequired = 1
        checkBoxDesayuno.addGestureRecognizer(tapCheckDesayuno)
        let tapCheckComida = UITapGestureRecognizer(target: self, action: #selector(checkComida))
        tapCheckComida.numberOfTapsRequired = 1
        checkBoxComida.addGestureRecognizer(tapCheckComida)
        let tapCheckCena = UITapGestureRecognizer(target: self, action: #selector(checkCena))
        tapCheckCena.numberOfTapsRequired = 1
        checkBoxCena.addGestureRecognizer(tapCheckCena)
        noPersonasTxt.delegate = self
        listo.addTarget(self, action: #selector(listoEvent), for: .touchUpInside)
        checkBoxDesayuno.check()
    }
    
    /**
     * Eveto que devuelve los parametros para filtrar el listado de platillos
     *
     */
    @objc func listoEvent(ckeck: Any) {
        delegate?.getParamsOrg(params: filtrosDePlatillos)
    }
    
    
    @objc func checkDesayuno(ckeck: Any) {
        filtrosDePlatillos["tipo_comida"] = TipoComida.desayuno.rawValue
        self.checkBoxDesayuno.check()
        self.checkBoxComida.unCheck()
        self.checkBoxCena.unCheck()
    }
    @objc func checkComida(ckeck: Any) {
        filtrosDePlatillos["tipo_comida"] = TipoComida.comida.rawValue
        self.checkBoxDesayuno.unCheck()
        self.checkBoxComida.check()
        self.checkBoxCena.unCheck()
    }
    @objc func checkCena(ckeck: Any) {
        filtrosDePlatillos["tipo_comida"] = TipoComida.cena.rawValue
        self.checkBoxDesayuno.unCheck()
        self.checkBoxComida.unCheck()
        self.checkBoxCena.check()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == noPersonasTxt {
            noPersonasTxt.resignFirstResponder()
            let noPersonas: [String] = ["1","2","3","4","5","6","7","8","9","10"]
            let vc = NumeroInvitadosViewController()
            vc.delegate = self
            vc.secciones = noPersonas
            let popVC = UINavigationController(rootViewController: vc)
            popVC.modalPresentationStyle = .popover
            let popOverVC = popVC.popoverPresentationController
            popOverVC?.permittedArrowDirections = .any
            popOverVC?.delegate   = self
            popOverVC?.sourceView = noPersonasTxt
            let midX = self.noPersonasTxt.bounds.midX
            let minY = self.noPersonasTxt.bounds.minY
            popOverVC?.sourceRect = CGRect(x: midX, y: minY, width: 0, height: 0)
            let widthModal = (ScreenSize.screenWidth / 2) // - 16
            let heightModal = (ScreenSize.screenWidth / 2)
            popVC.preferredContentSize = CGSize(width: widthModal, height: heightModal)
            self.present(popVC, animated: true)
        }
    }
    
}


extension OrganizarViewController: NumeroInvitadosSelected{
    
    func getNumeroSelected(numero: String) {
        filtrosDePlatillos["numero_personas"] = numero
        noPersonasTxt.text = numero
    }
    
}

extension OrganizarViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

