//
//  InicioViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/13/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit

class InicioViewController: BaseViewController {

    let facebook: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage( UIImage(named: "focebook_login") , for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    let registrate: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Registrate", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor.rojo
        button.layer.cornerRadius = 15
        return button
    }()
    
    let iniciaSesionAqui: UILabel = {
        let label = UILabel()
        //                                     Sangria necesaria para el underline
        label.text = "Ya tienes un cuenta, inicia sesión    "
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor.rosa
        label.adjustsFontForContentSizeCategory = true
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        label.underline()
        return label
    }()
    
    
    
    // -------------------------------------------------------------------------
    let omitir: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Omitir", for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.rosa
        return button
    }()
    let imageArrow: UIImageView = {
        let image = UIImage(named: "right_arrow")
        let imageView = UIImageView(image: image)
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
        return imageView
    }()
    let containerBottom: UIView = {
        let view = UIView()
        view.backgroundColor = .rosa
        return view
    }()
    // -------------------------------------------------------------------------
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        mainView.addSubview(facebook)
        mainView.addSubview(registrate)
        mainView.addSubview(iniciaSesionAqui)
        
        mainView.addSubview(containerBottom)
        
        mainView.addConstraintsWithFormat(format: "H:|-64-[v0]-64-|", views: facebook)
        mainView.addConstraintsWithFormat(format: "H:|-64-[v0]-64-|", views: registrate)
        mainView.addConstraintsWithFormat(format: "H:|-[v0]-|", views: iniciaSesionAqui)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: containerBottom)
        let topMargin = mainView.bounds.height/4
        mainView.addConstraintsWithFormat(format: "V:|-\(topMargin)-[v0(80)]-[v1(40)]-20-[v2]-(>=8)-[v3(45)]|",
            views: facebook, registrate, iniciaSesionAqui, containerBottom)
        
        containerBottom.addSubview(omitir)
        containerBottom.addSubview(imageArrow)
        containerBottom.addConstraintsWithFormat(format: "H:[v0][v1(10)]-|", views: omitir, imageArrow)
        containerBottom.addConstraintsWithFormat(format: "V:|[v0]", views: omitir)
        containerBottom.addConstraintsWithFormat(format: "V:|-[v0(15)]", views: imageArrow)
        
        
        registrate.addTarget(self, action: #selector(registro) , for: .touchUpInside)
        
        let inicioSesion = UITapGestureRecognizer(target: self, action: #selector(login))
        inicioSesion.numberOfTapsRequired = 1
        iniciaSesionAqui.addGestureRecognizer(inicioSesion)
        
        omitir.addTarget(self, action: #selector(omitirEvent) , for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    
    @objc func registro() {
        let vc = RegistroViewController()
        //self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func login() {
        let vc = LoginViewController()
        //self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func omitirEvent() {
        
        let vc = UbicacionViewController()
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
        
        /*
        let timeLineVC = TimeLineViewController()
        timeLineVC.title = "TIMELINE"
        let navTimeLine = UINavigationController(rootViewController: timeLineVC)
        let categoriasVC = CategoriasViewController()
        categoriasVC.title = "CATEGORIAS"
        let navCategorias = UINavigationController(rootViewController: categoriasVC)
        let mensajesVC = MensajesViewController()
        mensajesVC.title = "MENSAJES"
        let navMensajes = UINavigationController(rootViewController: mensajesVC)
        let perfilVC = PerfilViewController()
        perfilVC.title = "PERFIL"
        let navPerfil = UINavigationController(rootViewController: perfilVC)
        let tabBar = UITabBarController()
        tabBar.viewControllers = [navTimeLine, navCategorias, navMensajes, navPerfil]
        let timeLine = tabBar.tabBar.items![0]
        timeLine.image = UIImage(named: "timeline")?.withRenderingMode(.alwaysTemplate)
        let categorias = tabBar.tabBar.items![1]
        categorias.image = UIImage(named: "categorias")?.withRenderingMode(.alwaysTemplate)
        let mensajes = tabBar.tabBar.items![2]
        mensajes.image = UIImage(named: "mensajes")?.withRenderingMode(.alwaysTemplate)
        let perfil = tabBar.tabBar.items![3]
        perfil.image = UIImage(named: "perfil")?.withRenderingMode(.alwaysTemplate)
        UITabBar.appearance().tintColor = UIColor.rosa
        UITabBar.appearance().unselectedItemTintColor = UIColor.azul
        self.present(tabBar, animated: true, completion: nil)
        return
        */
    }

}
