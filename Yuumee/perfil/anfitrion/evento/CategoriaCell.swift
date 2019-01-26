//
//  CategoriaCell.swift
//  Yuumee
//
//  Created by Easy Code on 1/4/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

class CategoriaCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    let dataStorage = UserDefaults.standard
    
    var reference: UIViewController!
    
    let categoriaLbl: ArchiaRegularLabel = {
        let label  = ArchiaRegularLabel()
        label.text = "Categoría de comida:"
        return label
    }()
    
    let subCategoriaLbl: ArchiaRegularLabel = {
        let label  = ArchiaRegularLabel()
        label.text = "Sub categoría de comida:"
        label.numberOfLines = 0
        return label
    }()
    
    let categoria: UITextField = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "down_arrow")
        imageView.image = image
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.addBorder(borderColor: .black, widthBorder: 1)
        textField.layer.cornerRadius = 10
        textField.keyboardType = UIKeyboardType.alphabet
        textField.rightViewMode = .always
        textField.text = ""
        textField.textColor = UIColor.lightGray
        textField.textAlignment = .center
        textField.rightView = imageView
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height) )
        textField.leftView = paddingView
        // textField.clearButtonMode = UITextField.ViewMode.whileEditing -> Muestra el auto.corrector
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    let subCategoria: UITextField = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "down_arrow")
        imageView.image = image
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.addBorder(borderColor: .black, widthBorder: 1)
        textField.layer.cornerRadius = 10
        textField.keyboardType = UIKeyboardType.alphabet
        textField.rightViewMode = .always
        textField.text = ""
        textField.textColor = UIColor.lightGray
        textField.textAlignment = .center
        textField.rightView = imageView
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height) )
        textField.leftView = paddingView
        // textField.clearButtonMode = UITextField.ViewMode.whileEditing -> Muestra el auto.corrector
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    
    func setUpView() {
        addSubview(categoria)
        addSubview(subCategoria)
        categoria.delegate = self
        subCategoria.delegate = self
        addSubview(categoriaLbl)
        addSubview(subCategoriaLbl)
        addConstraintsWithFormat(format: "H:|-[v0(170)]-[v1]-|", views: categoriaLbl, categoria)
        addConstraintsWithFormat(format: "H:|-[v0(170)]-[v1]-|", views: subCategoriaLbl, subCategoria)
        addConstraintsWithFormat(format: "V:|-[v0(30)]-32-[v1(30)]", views: categoria, subCategoria)
        addConstraintsWithFormat(format: "V:|-[v0(30)]-16-[v1(60)]", views: categoriaLbl, subCategoriaLbl)
    }
    
    var idCategoriaSelected: String = ""
    
}


extension CategoriaCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == categoria {
            categoria.resignFirstResponder();
            // ToDo
            let vc = CategoriasComidaViewController()
            vc.delegate = self
            vc.currentFood = self.categoria.text!
            let popVC = UINavigationController(rootViewController: vc)
            popVC.modalPresentationStyle = .popover
            let popOverVC = popVC.popoverPresentationController
            popOverVC?.permittedArrowDirections = .up
            popOverVC?.delegate = self
            popOverVC?.sourceView = categoria // self.button
            popOverVC?.sourceRect = CGRect(x: self.categoria.bounds.midX,
                                           y: self.categoria.bounds.minY,
                                           width: 0, height: 0)
            let widthModal = ScreenSize.screenWidth - 16
            let heightModal = ScreenSize.screenWidth
            popVC.preferredContentSize = CGSize(width: widthModal, height: heightModal)
            reference.present(popVC, animated: true)
            return false
        }
        
        if textField == subCategoria {
            subCategoria.resignFirstResponder();
            // ToDo
            let vc = SubCategoriasComidaViewController()
            vc.delegate = self
            vc.idSubCategoria = idCategoriaSelected
            vc.currentFood = subCategoria.text!
            let popVC = UINavigationController(rootViewController: vc)
            popVC.modalPresentationStyle = .popover
            let popOverVC = popVC.popoverPresentationController
            popOverVC?.permittedArrowDirections = .up
            popOverVC?.delegate = self
            popOverVC?.sourceView = subCategoria // self.button
            popOverVC?.sourceRect = CGRect(x: self.subCategoria.bounds.midX,
                                           y: self.subCategoria.bounds.minY,
                                           width: 0, height: 0)
            let widthModal = ScreenSize.screenWidth - 16
            let heightModal = ScreenSize.screenWidth
            popVC.preferredContentSize = CGSize(width: widthModal, height: heightModal)
            reference.present(popVC, animated: true)
            return false
        }
        
        
        return true
    }
    
}

extension CategoriaCell: FoodSelected {
    func getFoodSelected(food: Categoria) {
        self.categoria.text = food.titulo
        idCategoriaSelected = food.id
        dataStorage.setLastCategorySelectedEvent(tipo: food.id)
    }
}

extension CategoriaCell : SubCategoriaFoodSelected {
    
    func getSubFoodSelected(food: Categoria) {
        self.subCategoria.text = food.titulo
        
        dataStorage.setLastSubCategorySelectedEvent(tipo: food.id)
    }
    
    
}


extension CategoriaCell: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


