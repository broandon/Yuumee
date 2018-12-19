//
//  PerfilUsuarioViewController.swift
//  Como en casa
//
//  Created by Easy Code on 11/28/18.
//  Copyright © 2018 lsegoviano. All rights reserved.
//

import UIKit

class PerfilUsuarioViewController: BaseViewController {
    
    let locationCell = "LocationCell"
    
    let comentariosCell = "ComentariosCell"
    
    let otrosCell = "OtrosCell"
    
    let postresCell = "PostresCell"
    
    let bebidasCell = "BebidasCell"
    
    let defaultReuseId = "cell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView() // frame: CGRect.zero, style: .grouped
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: defaultReuseId)
        tableView.register(BebidasCell.self, forCellReuseIdentifier: bebidasCell)
        tableView.register(PostresCell.self, forCellReuseIdentifier: postresCell)
        tableView.register(OtrosCell.self, forCellReuseIdentifier: otrosCell)
        tableView.register(ComentariosCell.self, forCellReuseIdentifier: comentariosCell)
        tableView.register(LocationCell.self, forCellReuseIdentifier: locationCell)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
    
    override func viewDidLoad() {
        mainView.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
        
        let customFooter = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.screenWidth, height: 50))
        customFooter.backgroundColor = UIColor.white
        
        let reservar = UIButton(frame: CGRect(x: 0, y: 0, width: customFooter.frame.width, height: 50))
        reservar.setTitle("Reservar", for: .normal)
        reservar.setTitleColor( UIColor.rosa , for: .normal)
        reservar.addTarget(self, action: #selector(reservarEvent), for: .touchUpInside)
        reservar.addBorder(borderColor: .gray, widthBorder: 1)
        reservar.layer.cornerRadius = 10
        reservar.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        customFooter.addSubview(reservar)
        
        tableView.tableFooterView = customFooter
        
        
    }
    
    
    @objc func reservarEvent() {
        print(" reservarEvent ")
    }
    
}


extension PerfilUsuarioViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 2
        }
        
        if section == 1 {
            return 1
        }
        
        if section == 2 {
            return 5
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentSection = indexPath.section
        
        if currentSection == 0 { // DATOS PERSONALES
            
            let currentRow = indexPath.row
            
            if currentRow == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
                cell.selectionStyle = .none
                let header = HeaderPerfilUsuario()
                cell.addSubview(header)
                header.setUpView()
                cell.addConstraintsWithFormat(format: "H:|[v0]|", views: header)
                cell.addConstraintsWithFormat(format: "V:|[v0]|", views: header)
                return cell
            }
            
            if currentRow == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
                cell.selectionStyle = .none
                
                let descripcionLabel = UILabel()
                descripcionLabel.text = "Descripción"
                descripcionLabel.sizeToFit()
                descripcionLabel.numberOfLines = 0
                descripcionLabel.font = UIFont.systemFont(ofSize: 14)
                
                let descripcion = UILabel()
                descripcion.sizeToFit()
                descripcion.numberOfLines = 0
                descripcion.textColor = UIColor.darkGray
                descripcion.font = UIFont.init(name: descripcion.font.familyName, size: 12)
                descripcion.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam porta malesuada mi, ut laoreet augue condimentum ut. Donec tincidunt ultricies mi ac consequat."
                
                cell.addSubview(descripcionLabel)
                cell.addSubview(descripcion)
                cell.addConstraintsWithFormat(format: "H:|-[v0]", views: descripcionLabel)
                cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: descripcion)
                cell.addConstraintsWithFormat(format: "V:|-[v0(21)]-[v1]-|", views: descripcionLabel, descripcion)
                
                cell.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
                return cell
            }
            
        }
        
        if currentSection == 1 { // DESCRIPCION DEL MENU
            
            let currentRow = indexPath.row
            
            if currentRow == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: defaultReuseId, for: indexPath)
                cell.selectionStyle = .none
                
                let nombrePlatillo = UILabel()
                nombrePlatillo.textColor = UIColor.rosa
                nombrePlatillo.font = UIFont.boldSystemFont(ofSize: 20)
                nombrePlatillo.sizeToFit()
                nombrePlatillo.numberOfLines = 0
                nombrePlatillo.text = "Comida Istmeña"
                
                let descripcion = UILabel()
                descripcion.sizeToFit()
                descripcion.numberOfLines = 0
                descripcion.textColor = UIColor.darkGray
                descripcion.font = UIFont.init(name: descripcion.font.familyName, size: 12)
                descripcion.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam porta malesuada mi, ut laoreet augue condimentum ut. Donec tincidunt ultricies mi ac consequat."
                
                let menu = UILabel()
                menu.sizeToFit()
                menu.numberOfLines = 0
                menu.textColor = UIColor.verde
                menu.font = UIFont.boldSystemFont(ofSize: 13)
                menu.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam porta malesuada mi, ut laoreet augue condimentum ut. Donec tincidunt ultricies mi ac consequat."
                
                
                let fecha = UILabel()
                fecha.sizeToFit()
                fecha.numberOfLines = 0
                fecha.font = UIFont.boldSystemFont(ofSize: 15)
                fecha.text = "Fecha: Domingo 12 de Agosto"
                
                let horario = UILabel()
                horario.sizeToFit()
                horario.numberOfLines = 0
                horario.font = UIFont.boldSystemFont(ofSize: 15)
                horario.text = "Fecha: 2:00 p.m. - 06-00 p.m."
                
                let tipoHorario = UILabel()
                tipoHorario.sizeToFit()
                tipoHorario.numberOfLines = 0
                tipoHorario.font = UIFont.boldSystemFont(ofSize: 15)
                tipoHorario.text = "Tipo de horario: Comida"
                
                let capacidad = UILabel()
                capacidad.sizeToFit()
                capacidad.numberOfLines = 0
                capacidad.font = UIFont.boldSystemFont(ofSize: 15)
                capacidad.text = "Capacidad: 7 personas max."
                
                let costo = UILabel()
                costo.sizeToFit()
                costo.numberOfLines = 0
                costo.font = UIFont.boldSystemFont(ofSize: 15)
                costo.text = "Costo: $300"
                
                cell.addSubview(nombrePlatillo)
                cell.addSubview(descripcion)
                cell.addSubview(menu)
                cell.addSubview(fecha)
                cell.addSubview(horario)
                cell.addSubview(tipoHorario)
                cell.addSubview(capacidad)
                cell.addSubview(costo)
                
                cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: nombrePlatillo)
                cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: descripcion)
                cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: menu)
                cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: fecha)
                cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: horario)
                cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: tipoHorario)
                cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: capacidad)
                cell.addConstraintsWithFormat(format: "H:|-[v0]-|", views: costo)
                cell.addConstraintsWithFormat(format: "V:|[v0]-[v1]-[v2]-[v3]-[v4]-[v5]-[v6]-[v7]-|",
                                              views: nombrePlatillo, descripcion, menu, fecha, horario, tipoHorario, capacidad, costo)
                
                return cell
            }
            
        }
        
        if currentSection == 2 { // ...
            
            let currentRow = indexPath.row
            
            if currentRow == 0 { // Bebidas
                let cell = tableView.dequeueReusableCell(withIdentifier: bebidasCell, for: indexPath)
                if let cell = cell as? BebidasCell {
                    cell.selectionStyle = .none
                    cell.setUpView()
                    return cell
                }
            }
            
            if currentRow == 1 { // Postres
                let cell = tableView.dequeueReusableCell(withIdentifier: postresCell, for: indexPath)
                if let cell = cell as? PostresCell {
                    cell.selectionStyle = .none
                    cell.setUpView()
                    return cell
                }
            }
            
            if currentRow == 2 { // Otros Platillos
                let cell = tableView.dequeueReusableCell(withIdentifier: otrosCell, for: indexPath)
                if let cell = cell as? OtrosCell {
                    cell.selectionStyle = .none
                    cell.setUpView()
                    let topSep = UIView()
                    topSep.backgroundColor = .black
                    let botSep = UIView()
                    botSep.backgroundColor = .black
                    
                    cell.addSubview(topSep)
                    cell.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: topSep)
                    cell.addConstraintsWithFormat(format: "V:|[v0(3)]", views: topSep)
                    
                    cell.addSubview(botSep)
                    cell.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: botSep)
                    cell.addConstraintsWithFormat(format: "V:[v0(3)]|", views: botSep)
                    
                    return cell
                }
            }
            
            if currentRow == 3 { // Mapa
                
                let cell = tableView.dequeueReusableCell(withIdentifier: locationCell, for: indexPath)
                if let cell = cell as? LocationCell {
                    cell.setUpView()
                    return cell
                }
                
            }
            
            if currentRow == 4 { // Comentarios
                let cell = tableView.dequeueReusableCell(withIdentifier: comentariosCell, for: indexPath)
                if let cell = cell as? ComentariosCell {
                    cell.setUpView()
                    return cell
                }
            }
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let currentSection = indexPath.section
        
        if currentSection == 0 {
            let currentRow = indexPath.row
            if currentRow == 0 {
                return ScreenSize.screenHeight - 350 // 70.0
            }
            
            if currentRow == 1 {
                return UITableView.automaticDimension
            }
            
        }
        
        if currentSection == 1 {
            let currentRow = indexPath.row
            if currentRow == 0 {
                return UITableView.automaticDimension
            }
        }
        
        if currentSection == 2 {
            let currentRow = indexPath.row
            if currentRow == 0 || currentRow == 1 { // Bebidas y Postres
                return 150
            }
            
            if currentRow == 2 { // Otros Platillos
                return 250
            }
            
            if currentRow == 3 { // Mapas
                return 250
            }
            
            if currentRow == 4 { // Comentarios
                return 250
            }
            
        }
        
        
        return UITableView.automaticDimension
    }
    
    
    // Header View Section
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let titulo = UILabel()
            titulo.translatesAutoresizingMaskIntoConstraints = false
            titulo.textColor = UIColor.white
            titulo.font = UIFont.boldSystemFont(ofSize: 18) //UIFont.init(name: label.font.familyName, size: 24)
            titulo.sizeToFit()
            titulo.numberOfLines = 0
            titulo.text = "Proponer fecha"
            titulo.textAlignment = .center
            titulo.backgroundColor = UIColor.rosa
            let view = UIView()
            view.addSubview(titulo)
            view.backgroundColor = .white
            view.addConstraintsWithFormat(format: "H:|[v0]|", views: titulo)
            view.addConstraintsWithFormat(format: "V:|-[v0]-|", views: titulo)
            return view
        }
        
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 40
        }
        
        return 0
    }
    
    
    
}





class HeaderPerfilUsuario: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imagenBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "hamburger")
        return imageView
    }()
    
    let avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar")
        return imageView
    }()
    
    func getLabelForPersonalDataUser(text: String = "") -> UILabel {
        let label = UILabel()
        label.textColor = UIColor.verde
        label.text = text
        label.sizeToFit()
        label.numberOfLines = 0
        label.font = UIFont.init(name: label.font.familyName, size: 12)
        return label
    }
    
    var nombreUsuario: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rosa
        label.font = UIFont.boldSystemFont(ofSize: 22) //UIFont.init(name: label.font.familyName, size: 24)
        label.sizeToFit()
        label.numberOfLines = 0
        return label
    }()
    var edad: UILabel!
    var profesion: UILabel!
    var idiomas: UILabel!
    var espacioDegustar: UILabel!
    var serviciosExtra: UILabel!
    let contLabelsDataUser: UIView = {
        let view = UIView()
        return view
    }()
    
   
    func setUpView() {
        nombreUsuario.text = "Juan Rodriguez Garcia"
        edad = getLabelForPersonalDataUser(text: "Edad: 26 años")
        profesion = getLabelForPersonalDataUser(text: "Profesión: Ingeniero Électrico")
        idiomas = getLabelForPersonalDataUser(text: "Idiomas: Español, Ingles")
        espacioDegustar = getLabelForPersonalDataUser(text: "Espacio para degustar: Terraza y Jardin")
        serviciosExtra = getLabelForPersonalDataUser(text: "Servicios extras: Wifi, baño, estacionamiento")
        
        addSubview(imagenBackground)
        addSubview(avatar)
        addSubview(contLabelsDataUser)
        
        let heightBackgroundImage = ScreenSize.screenWidth / 2
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: imagenBackground)
        addConstraintsWithFormat(format: "H:|-[v0(70)]-[v1]-|", views: avatar, contLabelsDataUser)
        addConstraintsWithFormat(format: "V:|[v0(\(heightBackgroundImage))]-[v1(70)]", views: imagenBackground, avatar)
        addConstraintsWithFormat(format: "V:|[v0(\(heightBackgroundImage))]-[v1]-|", views: imagenBackground, contLabelsDataUser)
        
        contLabelsDataUser.addSubview(nombreUsuario)
        contLabelsDataUser.addSubview(edad)
        contLabelsDataUser.addSubview(profesion)
        contLabelsDataUser.addSubview(idiomas)
        contLabelsDataUser.addSubview(espacioDegustar)
        contLabelsDataUser.addSubview(serviciosExtra)
        
        contLabelsDataUser.addConstraintsWithFormat(format: "H:|[v0]|", views: nombreUsuario)
        contLabelsDataUser.addConstraintsWithFormat(format: "H:|[v0]|", views: edad)
        contLabelsDataUser.addConstraintsWithFormat(format: "H:|[v0]|", views: profesion)
        contLabelsDataUser.addConstraintsWithFormat(format: "H:|[v0]|", views: idiomas)
        contLabelsDataUser.addConstraintsWithFormat(format: "H:|[v0]|", views: espacioDegustar)
        contLabelsDataUser.addConstraintsWithFormat(format: "H:|[v0]|", views: serviciosExtra)
        contLabelsDataUser.addConstraintsWithFormat(format: "V:|-[v0]-[v1][v2][v3][v4][v5]",
                                                    views: nombreUsuario, edad, profesion, idiomas, espacioDegustar, serviciosExtra)
        
    }
    
}








class BebidasCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let bebidasLbl: UILabel = {
        let nombrePlatillo = UILabel()
        nombrePlatillo.textColor = UIColor.rosa
        nombrePlatillo.font = UIFont.boldSystemFont(ofSize: 20)
        nombrePlatillo.sizeToFit()
        nombrePlatillo.numberOfLines = 0
        nombrePlatillo.text = "Bebidas"
        return nombrePlatillo
    }()
    
    let reuseId = "cell"
    
    lazy var collectionViewBebidas: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()
    
    var bebidas = ["Tisana", "Té helado", "Smoothie de mango", "Tejate"]
    
    func setUpView() {
        collectionViewBebidas.delegate = self
        collectionViewBebidas.dataSource = self
        
        addSubview(bebidasLbl)
        addSubview(collectionViewBebidas)
        
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: bebidasLbl)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: collectionViewBebidas)
        addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1]|", views: bebidasLbl, collectionViewBebidas)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bebidas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentRow = indexPath.row
        let bebida = bebidas[currentRow]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)
        cell.releaseView()
        
        let butllet = UIImageView()
        butllet.image = UIImage(named: "red_bullet")
        
        let nombre = UILabel()
        nombre.sizeToFit()
        nombre.numberOfLines = 0
        nombre.textColor = UIColor.darkGray
        nombre.font = UIFont.init(name: nombre.font.familyName, size: 12)
        nombre.text = bebida
        
        let costo = UILabel()
        costo.sizeToFit()
        costo.numberOfLines = 0
        costo.textColor = UIColor.darkGray
        costo.font = UIFont.init(name: nombre.font.familyName, size: 12)
        costo.text = "$35"
        
        cell.addSubview(butllet)
        cell.addSubview(nombre)
        cell.addSubview(costo)
        
        cell.addConstraintsWithFormat(format: "H:|-16-[v0(15)][v1]-(>=8)-[v2]-16-|", views: butllet, nombre, costo)
        cell.addConstraintsWithFormat(format: "V:|-[v0(15)]", views: butllet)
        cell.addConstraintsWithFormat(format: "V:|-[v0]", views: nombre)
        cell.addConstraintsWithFormat(format: "V:|-[v0]", views: costo)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.screenWidth, height: 30)
    }
    
}








class PostresCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let postresLbl: UILabel = {
        let nombrePlatillo = UILabel()
        nombrePlatillo.textColor = UIColor.rosa
        nombrePlatillo.font = UIFont.boldSystemFont(ofSize: 20)
        nombrePlatillo.sizeToFit()
        nombrePlatillo.numberOfLines = 0
        nombrePlatillo.text = "Postres"
        return nombrePlatillo
    }()
    
    let reuseId = "cell"
    
    lazy var collectionViewPostres: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()
    
    
    var postres = ["Carlotta", "Nicuatole", "Cheesecake", "Gelatina"]
    
    func setUpView() {
        collectionViewPostres.delegate = self
        collectionViewPostres.dataSource = self
        
        addSubview(postresLbl)
        addSubview(collectionViewPostres)
        
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: postresLbl)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: collectionViewPostres)
        addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1]|", views: postresLbl, collectionViewPostres)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentRow = indexPath.row
        let bebida = postres[currentRow]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)
        cell.releaseView()
        
        let butllet = UIImageView()
        butllet.image = UIImage(named: "red_bullet")
        
        let nombre = UILabel()
        nombre.sizeToFit()
        nombre.numberOfLines = 0
        nombre.textColor = UIColor.darkGray
        nombre.font = UIFont.init(name: nombre.font.familyName, size: 12)
        nombre.text = bebida
        
        let costo = UILabel()
        costo.sizeToFit()
        costo.numberOfLines = 0
        costo.textColor = UIColor.darkGray
        costo.font = UIFont.init(name: nombre.font.familyName, size: 12)
        costo.text = "$35"
        
        cell.addSubview(butllet)
        cell.addSubview(nombre)
        cell.addSubview(costo)
        
        cell.addConstraintsWithFormat(format: "H:|-16-[v0(15)][v1]-(>=8)-[v2]-16-|", views: butllet, nombre, costo)
        cell.addConstraintsWithFormat(format: "V:|-[v0(15)]", views: butllet)
        cell.addConstraintsWithFormat(format: "V:|-[v0]", views: nombre)
        cell.addConstraintsWithFormat(format: "V:|-[v0]", views: costo)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.screenWidth, height: 30)
    }
    
}








class OtrosCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let platillosLbl: UILabel = {
        let nombrePlatillo = UILabel()
        nombrePlatillo.textColor = UIColor.rosa
        nombrePlatillo.font = UIFont.boldSystemFont(ofSize: 20)
        nombrePlatillo.sizeToFit()
        nombrePlatillo.numberOfLines = 0
        nombrePlatillo.text = "Otros platillos"
        return nombrePlatillo
    }()
    
    let reuseId = "cell"
    
    lazy var collectionViewPlatilos: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()
    
    
    var platilos = ["", "", "", ""]
    
    func setUpView() {
        collectionViewPlatilos.delegate = self
        collectionViewPlatilos.dataSource = self
        
        addSubview(platillosLbl)
        addSubview(collectionViewPlatilos)
        
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: platillosLbl)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: collectionViewPlatilos)
        addConstraintsWithFormat(format: "V:|-[v0(25)]-[v1]|", views: platillosLbl, collectionViewPlatilos)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return platilos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentRow = indexPath.row
        let _ = platilos[currentRow]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)
        cell.releaseView()
        
        let nombre = UILabel()
        nombre.sizeToFit()
        nombre.numberOfLines = 0
        nombre.textColor = UIColor.verde
        //nombre.font = UIFont.init(name: nombre.font.familyName, size: 12)
        nombre.font = UIFont.boldSystemFont(ofSize: 12)
        nombre.text = "Comida corrida"
        
        let descripcion = UILabel()
        descripcion.sizeToFit()
        descripcion.numberOfLines = 3
        descripcion.textColor = UIColor.darkGray
        descripcion.font = UIFont.init(name: descripcion.font.familyName, size: 12)
        descripcion.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam porta malesuada mi, ut laoreet augue condimentum ut. Donec tincidunt ultricies mi ac consequat."
        
        let costo = UILabel()
        costo.sizeToFit()
        costo.numberOfLines = 0
        costo.textColor = UIColor.black
        costo.font = UIFont.boldSystemFont(ofSize: 12)
        costo.text = "$35"
        costo.textAlignment = .left
        
        cell.addSubview(nombre)
        cell.addSubview(descripcion)
        cell.addSubview(costo)
        
        cell.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: nombre)
        cell.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: descripcion)
        cell.addConstraintsWithFormat(format: "H:[v0]-16-|", views: costo)
        cell.addConstraintsWithFormat(format: "V:|-[v0]-[v1]-[v2(25)]-|", views: nombre, descripcion, costo)
        
        let botSep = UIView()
        botSep.backgroundColor = .lightGray
        cell.addSubview(botSep)
        cell.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: botSep)
        cell.addConstraintsWithFormat(format: "V:[v0(1)]|", views: botSep)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.screenWidth, height: 110)
    }
    
}








class FooterClass: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Customize here
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ComentariosCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let footerReuseIdentifier = "FooterClass"
    
    let reuseId = "cell"
    
    lazy var collectionViewComentarios: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.register(FooterClass.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerReuseIdentifier)
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()
    
    
    var coemnatrios = ["", "", "", ""]
    
    func setUpView() {
        collectionViewComentarios.delegate = self
        collectionViewComentarios.dataSource = self
        addSubview(collectionViewComentarios)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionViewComentarios)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionViewComentarios)
    }
    
    
    @objc func mostrarMasComentarios() {
        print(" mostrarMasComentarios ")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coemnatrios.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let currentRow = indexPath.row
        let _ = coemnatrios[currentRow]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath)
        cell.releaseView()
        
        let nombre = UILabel()
        nombre.sizeToFit()
        nombre.numberOfLines = 0
        nombre.textColor = UIColor.verde
        //nombre.font = UIFont.init(name: nombre.font.familyName, size: 12)
        nombre.font = UIFont.boldSystemFont(ofSize: 13)
        nombre.text = "John Doe"
        
        let descripcion = UILabel()
        descripcion.sizeToFit()
        descripcion.numberOfLines = 2
        descripcion.textColor = UIColor.verde
        descripcion.font = UIFont.italicSystemFont(ofSize: 12)
        descripcion.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam porta malesuada mi, ut laoreet augue condimentum ut. Donec tincidunt ultricies mi ac consequat."
        
        cell.addSubview(nombre)
        cell.addSubview(descripcion)
        
        cell.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: nombre)
        cell.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: descripcion)
        cell.addConstraintsWithFormat(format: "V:|-[v0(30)][v1]-|", views: nombre, descripcion)
        
        cell.backgroundColor = .gris
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ScreenSize.screenWidth, height: 110)
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 100.0, height: 50.0)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        /*case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerReuseIdentifier, for: indexPath as IndexPath)
            headerView.backgroundColor = UIColor.blue
            return headerView
            */
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerReuseIdentifier, for: indexPath as IndexPath)
            
            
            let reservar = UIButton(type: .system)
            reservar.setTitle("Mostrar más", for: .normal)
            reservar.setTitleColor( UIColor.rosa , for: .normal)
            reservar.addTarget(self, action: #selector(mostrarMasComentarios), for: .touchUpInside)
            reservar.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            
            footerView.addSubview(reservar)
            footerView.addConstraintsWithFormat(format: "H:|-[v0]-|", views: reservar)
            footerView.addConstraintsWithFormat(format: "V:|[v0]", views: reservar)
            
            return footerView
            
            
        default:
            assert(false, "Unexpected element kind")
        }
        
        return UICollectionReusableView()
    }
    
    
    
    
    
}






import MapKit
import CoreLocation


class LocationCell: UITableViewCell, MKMapViewDelegate, CLLocationManagerDelegate {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    var mapView: MKMapView = {
        let mapview = MKMapView()
        mapview.translatesAutoresizingMaskIntoConstraints = false
        mapview.mapType = .standard
        //mapview.isZoomEnabled = true
        //mapview.isScrollEnabled = true
        return mapview
    }()
    
    var locationManager: CLLocationManager!
    
    var latitude: CLLocationDegrees = 0.0
    var longitude: CLLocationDegrees = 0.0
    
    func setUpView() {
        addSubview(mapView)
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : mapView]) )
        addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : mapView]) )
        
        // Obtener localizacion
        if (CLLocationManager.locationServicesEnabled()) {
            print(" CLLocationManager.locationServicesEnabled ")
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
        
    }
    
    
    /**
     * Obtiene la localizacion del Usuario
     *
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(" manager.location?.coordinate: \(String(describing: manager.location?.coordinate)) ")
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if manager.location?.coordinate != nil {
                lastLocation = manager.location?.coordinate
                latitude = (manager.location?.coordinate.latitude)!
                longitude = (manager.location?.coordinate.longitude)!
            }
        }
        else{
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(" location: \(locations.last) ")
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
    
    var lastLocation: CLLocationCoordinate2D!
    
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



