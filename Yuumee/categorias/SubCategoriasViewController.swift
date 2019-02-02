//
//  SubCategoriasViewController.swift
//  Yuumee
//
//  Created by Luis Segoviano on 1/20/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit
import Alamofire

class SubCategoriasViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: SubCategorySelected?
    var idCategoria: String = ""
    
    let cerrarBtn: UIBarButtonItem = {
        let sizeImg   = CGSize(width: 24, height: 24)
        let imgClose  = UIImage(named: "close")?.imageResize(sizeChange: sizeImg)
        let cerrarBtn = UIBarButtonItem(image: imgClose, style: .plain,
                                        target: self, action: #selector(closeVC))
        cerrarBtn.tintColor = .white
        return cerrarBtn
    }()
    
    let reuseId = "RestaurantCell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView() // frame: CGRect.zero, style: .grouped
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.separatorStyle  = .none
        tableView.backgroundColor = UIColor.white
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseId)
        return tableView
    }()
    
    var subCategorias = [SubCategoria]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
        cerrarBtn.target = self
        self.navigationItem.rightBarButtonItem = cerrarBtn
        mainView.addSubview(tableView)
        mainView.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        mainView.addConstraintsWithFormat(format: "V:|-[v0]|", views: tableView)
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Delegate & Datasource - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategorias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        let subC = subCategorias[indexPath.row]
        let urlImg = URL(string: subC.imagen)
        let nombre: UILabel = UILabel()
        nombre.text = subC.titulo
        let imageView: UIImageView = UIImageView()
        cell.addSubview(nombre)
        cell.addSubview(imageView)
        cell.addConstraintsWithFormat(format: "H:|-[v0(24)]-16-[v1]-|", views: imageView, nombre)
        cell.addConstraintsWithFormat(format: "V:|-[v0]-|", views: imageView)
        cell.addConstraintsWithFormat(format: "V:|-[v0]-|", views: nombre)
        imageView.af_setImage(withURL: urlImg!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentRow = indexPath.row
        let subC = subCategorias[currentRow]
        delegate?.getSubCategorySelected(subCategory: subC)
        self.dismiss(animated: true, completion: nil)
    }

} // SubCategoriasViewController

protocol SubCategorySelected {
    func getSubCategorySelected(subCategory: SubCategoria)
}
