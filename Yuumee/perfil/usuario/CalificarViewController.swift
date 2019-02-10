//
//  CalificarViewController.swift
//  Yuumee
//
//  Created by Luis Segoviano on 2/5/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire


class CalificarViewController: BaseViewController {
    
    
    var idAnfitrion: String = ""
    var idPlatillo: String  = ""

    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.azul
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
    
    
    // Calificacion
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    let comentarios = UITextView()
    
    lazy var enviar: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 15
        button.backgroundColor = .white
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitle("Enviar", for: .normal)
        button.addTarget(self, action: #selector(enviarCalificacion) , for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.navigationController?.isNavigationBarHidden = true
        //self.hideKeyboardWhenTappedAround()
        
        let notifier = NotificationCenter.default
        notifier.addObserver(self, selector: #selector(keyboardWillAppear),
                             name: UIWindow.keyboardWillShowNotification,
                             object: nil)
        notifier.addObserver(self, selector: #selector(keyboardWillDisappear),
                             name: UIWindow.keyboardWillHideNotification,
                             object: nil)
        
        mainView.addSubview(container)
        mainView.centerInView(superView: mainView, container: container, sizeV: 250, sizeH: 250)
        
        let enviaComentario: ArchiaBoldLabel = ArchiaBoldLabel()
        enviaComentario.textColor = .white
        enviaComentario.text = "Envía tus comentarios"
        enviaComentario.textAlignment = .center
        
        container.addSubview(cerrarBtn)
        container.addSubview(enviaComentario)
        container.addSubview(collectionView)
        container.addSubview(comentarios)
        comentarios.backgroundColor = .white
        container.addSubview(enviar)
        
        container.addConstraintsWithFormat(format: "H:[v0]-|", views: cerrarBtn)
        container.addConstraintsWithFormat(format: "H:|-[v0]-|", views: enviaComentario)
        container.addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        container.addConstraintsWithFormat(format: "H:|-[v0]-|", views: comentarios)
        container.addConstraintsWithFormat(format: "H:|-64-[v0]-64-|", views: enviar)
        container.addConstraintsWithFormat(format: "V:|-[v0]-[v1(25)]-[v2(50)]-[v3(50)]-16-[v4(35)]",
                                           views: cerrarBtn, enviaComentario, collectionView, comentarios, enviar)
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        mainView.addGestureRecognizer(tap)
        
        // DESPLAZAMIENTO QUE SE LE HACE AL TABLEVIEW AL MOSTRARSE EL KEYBOARD
        self.view.frame.origin.y -= 170
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification){
        view.endEditing(true)
        mainView.gestureRecognizers?.removeAll()
        
        // REGRESA EL TABLEVIEW A LA NORMALIDAD CUANDO DESAPARECE EL KEYBOARD
        self.view.frame.origin.y += 170
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    let dataStorage = UserDefaults.standard
    
    @objc func enviarCalificacion() {
        if numberRank == 0 || (comentarios.text!).isEmpty {
            Utils.showSimpleAlert(message: "Por favor ingrese una calificación y un comentario",
                                  context: self, success: nil)
            return;
        }
        
        let parameters: Parameters=["funcion"    : "sendValoration",
                                    "id_user"    : dataStorage.getUserId(),
                                    "valoration" : numberRank,
                                    "comments"   : comentarios.text!,
                                    "id_anfitrion" : idAnfitrion,
                                    "id_saucer"  : idPlatillo] as [String: Any]
        
        let headers: HTTPHeaders = ["Accept": "application/json",
                                    "Content-Type" : "application/x-www-form-urlencoded"]
        Alamofire.request(BaseURL.baseUrl(), method: .post, parameters: parameters, encoding: ParameterQueryEncoding(), headers: headers).responseJSON
            { (response: DataResponse) in
                switch(response.result) {
                case .success(let value):
                    if let result = value as? Dictionary<String, Any> {
                        let statusMsg = result["status_msg"] as? String
                        let state     = result["state"] as? String
                        
                        print(result)
                        
                        if statusMsg == "OK" && state == "200" {
                            
                            Utils.showSimpleAlert(message: "Calificación enviada!",
                                                  context: self, success: {(alert: UIAlertAction!) in
                                                    self.closeVC()
                            })
                            
                            return;
                        }
                        else{
                            let alert = UIAlertController(title: "Ocurrió un error al realizar la petición.", message: "\(statusMsg!)", preferredStyle: UIAlertController.Style.alert)
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
    
    let numberOfStars = 5
    
    var numberRank = 0
}



extension CalificarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfStars
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.releaseView()
        
        let image = UIImage(named: "star")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        if numberRank <= indexPath.row  {
            imageView.image = imageView.changeImageColor(color: UIColor.white)
        }else{
            imageView.image = imageView.changeImageColor(color: UIColor.rosa)
        }
        
        cell.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cell.centerInView(superView: cell, container: imageView, sizeV: 25, sizeH: 25)
        //cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: imageView)
        //cell.addConstraintsWithFormat(format: "V:|-[v0]-|", views: imageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (self.container.frame.width / 5)
        return CGSize(width: w, height: w)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        numberRank = indexPath.row + 1
        self.collectionView.reloadData()
    }
    
    
}
