//
//  OrganizarViewController.swift
//  Yuumee
//
//  Created by Luis Segoviano on 1/19/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

class OrganizarViewController: BaseViewController, UITextFieldDelegate {
    
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
        textField.placeholder   = "0"
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
        mainView.addSubview(listo)
        mainView.addConstraintsWithFormat(format: "H:|-[v0(14)]-[v1(v5)]-[v2(14)]-[v3(v5)]-[v4(14)]-[v5(v5)]-|",
                                 views: checkBoxDesayuno, desayuno, checkBoxComida, comida, checkBoxCena, cena)
        
        mainView.addConstraintsWithFormat(format: "H:|-[v0(130)]-[v1(100)]", views: noPersonas, noPersonasTxt)
        mainView.addConstraintsWithFormat(format: "H:|-[v0]-32-|", views: listo)
        
        mainView.addConstraintsWithFormat(format: "V:|-4-[v0(14)]-32-[v1(30)]", views: checkBoxDesayuno, noPersonas)
        mainView.addConstraintsWithFormat(format: "V:|[v0]", views: desayuno)
        mainView.addConstraintsWithFormat(format: "V:|-4-[v0(14)]-32-[v1(30)]-32-[v2(40)]",
                                          views: checkBoxComida, noPersonasTxt, listo)
        mainView.addConstraintsWithFormat(format: "V:|[v0]", views: comida)
        mainView.addConstraintsWithFormat(format: "V:|-4-[v0(14)]", views: checkBoxCena)
        mainView.addConstraintsWithFormat(format: "V:|[v0]", views: cena)
        
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
    }
    
    @objc func listoEvent(ckeck: Any) {
        print(" listo ")
    }
    
    @objc func checkDesayuno(ckeck: Any) {
        self.checkBoxDesayuno.check()
        self.checkBoxComida.unCheck()
        self.checkBoxCena.unCheck()
    }
    @objc func checkComida(ckeck: Any) {
        self.checkBoxDesayuno.unCheck()
        self.checkBoxComida.check()
        self.checkBoxCena.unCheck()
    }
    @objc func checkCena(ckeck: Any) {
        self.checkBoxDesayuno.unCheck()
        self.checkBoxComida.unCheck()
        self.checkBoxCena.check()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == noPersonasTxt {
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 3
        }
        
        return true
    }
    
}
