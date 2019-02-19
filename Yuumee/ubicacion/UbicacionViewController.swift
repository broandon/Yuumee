//
//  UbicacionViewController.swift
//  Como en casa
//
//  Created by Luis Segoviano on 11/13/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit
import GooglePlaces
import MapKit
import Alamofire

class UbicacionViewController: BaseViewController, UITextFieldDelegate {
    
    var resultsView: TextField!
    
    let buscar: UIButton = {
        let button = UIButton()
        button.setTitle("Buscar", for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .rojo
        return button
    }()
    
    /*
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
    */
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsCompass = true
        return mapView
    }()
    
    var locationManager: CLLocationManager!
    
    var lastLocation: CLLocationCoordinate2D!
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        UINavigationBar.appearance().barTintColor = .rosa
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        /*
        let _ = UIBarButtonItem(image: UIImage(named: "close"),
                                        style: .plain, target: self,
                                        action: #selector(close))*/
        //self.navigationItem.leftBarButtonItem = closeIcon
        
        let imageView = UIImageView(image: UIImage(named: "search"))
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .gray
        resultsView = TextField()
        resultsView.textAlignment = .center
        resultsView.layer.cornerRadius = 15
        resultsView.placeholder = "Escribe tu dirección..."
        resultsView.delegate = self
        resultsView.leftView = imageView
        resultsView.leftViewMode = UITextField.ViewMode.always
        resultsView.leftViewMode = .always
        // resultsView.addBorder(borderColor: .lightGray, widthBorder: 1)
        
        mapView.delegate = self
        if (CLLocationManager.locationServicesEnabled()) {
            // print(" CLLocationManager.locationServicesEnabled ")
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
        
        mainView.addSubview(resultsView)
        mainView.addSubview(buscar)
        mainView.addSubview(mapView)
        mainView.addConstraintsWithFormat(format: "H:|-[v0]-|", views: resultsView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: mapView)
        mainView.addConstraintsWithFormat(format: "H:|-64-[v0]-64-|", views: buscar)
        mainView.addConstraintsWithFormat(format: "V:|-16-[v0(45)]-16-[v1(45)]-16-[v2]|",
                                          views: resultsView, buscar, mapView)
        buscar.addTarget(self, action: #selector(buscarLugares) , for: .touchUpInside)
        // ---------------------------------------------------------------------
        if !dataStorage.getUserId().isEmpty && !dataStorage.getTokenSabedInDB()! {
            let headers: HTTPHeaders = ["Accept"       : "application/json",
                                        "Content-Type" : "application/x-www-form-urlencoded"]
            let parameters: Parameters = ["funcion"     : "sendToken",
                                          "id_user"     : dataStorage.getUserId(),
                                          "token"       : dataStorage.getToken()!,
                                          "type_device" : "1"] as [String: Any]
            Alamofire.request(BaseURL.baseUrl() , method: .post,
                              parameters: parameters, encoding: ParameterQueryEncoding(),
                              headers: headers).responseJSON{ (response: DataResponse) in
                                switch(response.result) {
                                case .success(let value):
                                    if let result = value as? Dictionary<String, Any> {
                                        self.dataStorage.tokenSavedInDB(save: true)
                                        let statusMsg = result["status_msg"] as? String
                                        let state     = result["state"] as? String
                                        if statusMsg == "OK" && state == "200" {
                                            if let _ = result["data"] as? Dictionary<String, AnyObject> {
                                            }
                                        }
                                    }
                                    break
                                case .failure(let error):
                                    print(error)
                                    print(error.localizedDescription)
                                    break
                                }
            }
        }
        // ---------------------------------------------------------------------
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !dataStorage.getTutorialFollowed()! {
            let vc = TutorialViewController()
            let popVC = UINavigationController(rootViewController: vc)
            popVC.modalPresentationStyle = .overFullScreen
            self.present(popVC, animated: true)
        }
    }
    
    
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.present(acController, animated: true, completion: nil)
    }
    
    let standarSize: CGSize = CGSize(width: 24, height: 24)
    
    
    let tabBar = UITabBarController()
    
    
    @objc func buscarLugares() {
        let timeLineVC = TimeLineViewController()
        timeLineVC.title = "TIMELINE"
        let navTimeLine = UINavigationController(rootViewController: timeLineVC)
        let categoriasVC = CategoriasViewController()
        categoriasVC.title = "CATEGORIAS"
        let navCategorias = UINavigationController(rootViewController: categoriasVC)
        // Mensajes
        var mensajesVC: BaseViewController!
        if dataStorage.getTipo() == "" {
            mensajesVC = InicioViewController()
        }else{
            mensajesVC = MensajesViewController()
        }
        mensajesVC.title = "MENSAJES"
        let navMensajes = UINavigationController(rootViewController: mensajesVC)
        
        
        // Perfil
        var perfilVC: UIViewController = UIViewController()
        // Usuario Invitado
        if dataStorage.getTipo() == "" {
            perfilVC = InicioViewController()
            perfilVC.title = "PERFIL"
        }
        // Anfitrion
        if dataStorage.getTipo() == String(TipoUsuario.anfitrion.rawValue) {
            perfilVC = PerfilViewController() // PerfilAnfitrionViewController()
            perfilVC.title = "PERFIL"
        }
        // Cliente
        if dataStorage.getTipo() == String(TipoUsuario.cliente.rawValue) {
            perfilVC = PerfilClienteViewController()
            perfilVC.title = "PERFIL"
        }
        let navPerfil = UINavigationController(rootViewController: perfilVC)
        
        
        tabBar.viewControllers = [navTimeLine, navCategorias, navMensajes, navPerfil]
        let timeLine = tabBar.tabBar.items![0]
        timeLine.image = UIImage(named: "timeline")?.withRenderingMode(.alwaysTemplate)
        let categorias = tabBar.tabBar.items![1]
        categorias.image = UIImage(named: "categorias")?.withRenderingMode(.alwaysTemplate)
        let mensajes = tabBar.tabBar.items![2]
        mensajes.image = UIImage(named: "mensajes")?.withRenderingMode(.alwaysTemplate)
        let perfil = tabBar.tabBar.items![3]
        
        
        var imagePerfil: UIImage?
        // Usuario invitado
        if dataStorage.getTipo() == "" {
            imagePerfil = UIImage(named: "perfil")?.withRenderingMode(.alwaysTemplate)
        }
        // Anfitrion
        if dataStorage.getTipo() == String(TipoUsuario.anfitrion.rawValue) {
            imagePerfil = UIImage(named: "chef_rosa")?.withRenderingMode(.alwaysTemplate)
        }
        // Cliente
        if dataStorage.getTipo() == String(TipoUsuario.cliente.rawValue) {
            imagePerfil = UIImage(named: "perfil")?.withRenderingMode(.alwaysTemplate)
        }
        
        
        perfil.image = imagePerfil?.imageResize(sizeChange: standarSize)
        UITabBar.appearance().tintColor = UIColor.rosa
        UITabBar.appearance().unselectedItemTintColor = UIColor.azul
        
        self.present(tabBar, animated: true, completion: nil)
        return
    }
    
    let dataStorage = UserDefaults.standard
    
}


extension UbicacionViewController : MKMapViewDelegate, CLLocationManagerDelegate {
    
    /**
     * Obtiene la localizacion del Usuario
     *
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // print(" manager.location?.coordinate: \(String(describing: manager.location?.coordinate)) ")
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if manager.location?.coordinate != nil {
                lastLocation = manager.location?.coordinate
                latitude = (manager.location?.coordinate.latitude)!
                longitude = (manager.location?.coordinate.longitude)!
                
                dataStorage.setLatitud(tipo: "\(latitude)")
                dataStorage.setLongitud(tipo: "\(longitude)")
            }
        }
        else{
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print(" location: \(locations.last) ")
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
            let region = MKCoordinateRegion(center: center, span: span)
            self.mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
    
    /**
     * Metodo que genera el Pin(Draggable) en el mapa
     *
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        /*if annotation is MKUserLocation {
         return nil
         }*/
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.isDraggable = true
            pinView?.animatesDrop = true
            pinView?.canShowCallout = true
            pinView?.image = nil
            pinView?.image = UIImage(named: "pin")
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView?.annotation = annotation
        }
        pinView?.animatesDrop = true
        return pinView
    }
    
    
    
    /**
     * Evento para obtener la ultima ubicacion del Pin en el mapa
     *
     */
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        /*switch newState {
         case .ending:
         //lastLocation = (view.annotation?.coordinate)!
         print(" (view.annotation?.coordinate)!: \((view.annotation?.coordinate)!) ")
         default: break
         }*/
        /*switch newState {
         case .starting:
         print("starting")
         view.dragState = .dragging
         case .ending:
         print(" ending: ")
         view.dragState = .none
         case .canceling: break
         default: break
         }*/
        switch (newState) {
        case .ending, .canceling:
            view.dragState = .none
        default: break
        }
    }
    
}

extension UbicacionViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        /* print("Place: \(place)")
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress ?? "null")")
        print("Place: \(place.coordinate)") */
        
        self.resultsView.text = place.formattedAddress
        
        latitude  = place.coordinate.latitude
        longitude = place.coordinate.longitude
        
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: center, span: span)
        self.mapView.setRegion(region, animated: true)
        
        let CLLCoordType = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let anno = MKPointAnnotation();
        anno.coordinate = CLLCoordType;
        mapView.addAnnotation(anno);
        
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



/*
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
*/
