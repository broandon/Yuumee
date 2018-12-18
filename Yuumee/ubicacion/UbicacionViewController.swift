//
//  UbicacionViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/13/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit
import GooglePlaces

class UbicacionViewController: BaseViewController, UITextFieldDelegate {
    
    var resultsView: TextField!

    let estados = ["Puebla", "Veracruz", "Oaxaca", "Tlaxcala", "Hidalgo", "CDMX"]
    
    let buscar: UIButton = {
        let button = UIButton()
        button.setTitle("Buscar", for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .rojo
        return button
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        let _ = UIBarButtonItem(image: UIImage(named: "close"),
                                        style: .plain, target: self,
                                        action: #selector(close))
        //self.navigationItem.leftBarButtonItem = closeIcon
        UINavigationBar.appearance().barTintColor = .rosa
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        resultsView = TextField()
        resultsView.textAlignment = .center
        resultsView.layer.cornerRadius = 15
        resultsView.placeholder = "Escribe tu dirección..."
        resultsView.delegate = self
        let imageView = UIImageView(image: UIImage(named: "search"))
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .gray
        resultsView.leftView = imageView
        resultsView.leftViewMode = UITextField.ViewMode.always
        resultsView.leftViewMode = .always
        // resultsView.addBorder(borderColor: .lightGray, widthBorder: 1)
        
        mainView.addSubview(resultsView)
        mainView.addSubview(buscar)
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|-[v0]-|", views: resultsView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "H:|-64-[v0]-64-|", views: buscar)
        mainView.addConstraintsWithFormat(format: "V:|-16-[v0(45)]-16-[v1(45)]-16-[v2]|",
                                          views: resultsView, buscar, tableView)
        buscar.addTarget(self, action: #selector(buscarLugares) , for: .touchUpInside)
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.present(acController, animated: true, completion: nil)
    }
    
    @objc func buscarLugares() {
        
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
        
    }
    
}




extension UbicacionViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place: \(place)")
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress ?? "null")")
        self.resultsView.text = place.formattedAddress
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        //        print("Error: \(error.description)")
        self.dismiss(animated: true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismiss(animated: true, completion: nil)
    }
    
}




extension UbicacionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return estados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
        let estado = estados[indexPath.row]
        cell.textLabel?.text = estado
        cell.textLabel?.textAlignment = .center
        let sep = UIView()
        sep.backgroundColor = .rosa
        cell.addSubview(sep)
        cell.addConstraintsWithFormat(format: "H:|[v0]|", views: sep)
        cell.addConstraintsWithFormat(format: "V:[v0(2)]|", views: sep)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
