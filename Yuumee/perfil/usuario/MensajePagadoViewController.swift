//
//  MensajePagadoViewController.swift
//  Yuumee
//
//  Created by Luis Segoviano on 2/5/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

protocol BackToList {
    func backToList()
}

class MensajePagadoViewController: BaseViewController {
    
    var delegate: BackToList?
    
    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor    = UIColor.rosa
        view.layer.cornerRadius = 20
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var cerrarBtn: UIButton = {
        let sizeImg   = CGSize(width: 24, height: 24)
        let imgClose  = UIImage(named: "close")?.imageResize(sizeChange: sizeImg)
        // image: imgClose, style: .plain, target: self, action: #selector(closeVC)
        let cerrarBtn = UIButton(type: .system)
        cerrarBtn.tintColor = .white
        cerrarBtn.setImage(imgClose, for: .normal)
        cerrarBtn.addTarget(self, action: #selector(closeVC) , for: .touchUpInside)
        return cerrarBtn
    }()
    
    lazy var enviar: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 15
        button.backgroundColor = .white
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitle("Aceptar", for: .normal)
        button.addTarget(self, action: #selector(enviarCalificacion) , for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.navigationController?.isNavigationBarHidden = true
        
        mainView.addSubview(container)
        mainView.centerInView(superView: mainView, container: container, sizeV: 250, sizeH: 250)
        
        let enviaComentario: ArchiaBoldLabel = ArchiaBoldLabel()
        enviaComentario.textColor = .white
        enviaComentario.text = "¡Pagado!"
        enviaComentario.textAlignment = .center
        
        let graciasPago: ArchiaBoldLabel = ArchiaBoldLabel()
        graciasPago.textColor = .white
        graciasPago.numberOfLines = 0
        graciasPago.text = "Gracias por tu pago, ahora puedes ver la reservación en tu perfil."
        graciasPago.textAlignment = .center
        
        
        container.addSubview(cerrarBtn)
        container.addSubview(enviaComentario)
        container.addSubview(graciasPago)
        container.addSubview(enviar)
        container.addConstraintsWithFormat(format: "H:[v0]-|", views: cerrarBtn)
        container.addConstraintsWithFormat(format: "H:|-[v0]-|", views: enviaComentario)
        container.addConstraintsWithFormat(format: "H:|-[v0]-|", views: graciasPago)
        container.addConstraintsWithFormat(format: "H:|-32-[v0]-32-|", views: enviar)
        container.addConstraintsWithFormat(format: "V:|-[v0]-[v1(25)][v2(80)]-[v3(35)]",
                                           views: cerrarBtn, enviaComentario, graciasPago, enviar)
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.backToList()
    }
    
    @objc func enviarCalificacion() {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.backToList()
    }
    

}
