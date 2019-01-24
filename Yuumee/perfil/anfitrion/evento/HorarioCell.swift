//
//  HorarioCell.swift
//  Yuumee
//
//  Created by Easy Code on 1/4/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit

class HorarioCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    
    let comienza: ArchiaRegularLabel = {
        let label = ArchiaRegularLabel()
        label.text = "Comienza"
        label.textAlignment = .center
        return label
    }()
    
    let termina: ArchiaRegularLabel = {
        let label = ArchiaRegularLabel()
        label.text = "Termina"
        label.textAlignment = .center
        return label
    }()
    
    let hora: ArchiaRegularLabel = {
        let label = ArchiaRegularLabel()
        label.text = "Hora:"
        //label.textAlignment = .right
        return label
    }()
    
    let comienzaInput: UITextField = {
        let size = CGRect(x: 0, y: 0, width: 20, height: 20)
        let imageView = UIImageView(frame: size)
        let image = UIImage(named: "down_arrow")
        imageView.image = image
        let textField = UITextField()
        textField.backgroundColor = UIColor.gris
        textField.addBorder(borderColor: .black, widthBorder: 1)
        textField.layer.cornerRadius = 10
        textField.keyboardType = UIKeyboardType.alphabet
        textField.rightViewMode = .always
        textField.text = "00:00 PM"
        textField.textColor = UIColor.lightGray
        textField.textAlignment = .center
        textField.rightView = imageView
        let paddingRect = CGRect(x: 0, y: 0, width: 15, height: textField.frame.height)
        let paddingView = UIView(frame: paddingRect)
        textField.leftView = paddingView
        // textField.clearButtonMode = UITextField.ViewMode.whileEditing -> Muestra el auto.corrector
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    let terminaInput: UITextField = {
        let size = CGRect(x: 0, y: 0, width: 20, height: 20)
        let imageView = UIImageView(frame: size)
        let image = UIImage(named: "down_arrow")
        imageView.image = image
        let textField = UITextField()
        textField.backgroundColor = UIColor.gris
        textField.addBorder(borderColor: .black, widthBorder: 1)
        textField.layer.cornerRadius = 10
        textField.keyboardType = UIKeyboardType.alphabet
        textField.rightViewMode = .always
        textField.text = "00:00 PM"
        textField.textColor = UIColor.lightGray
        textField.textAlignment = .center
        textField.rightView = imageView
        let paddingRect = CGRect(x: 0, y: 0, width: 15, height: textField.frame.height)
        let paddingView = UIView(frame: paddingRect)
        textField.leftView = paddingView
        // textField.clearButtonMode = UITextField.ViewMode.whileEditing -> Muestra el auto.corrector
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return textField
    }()
    
    let auxPadding: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    
    let titulo: ArchiaRegularLabel = {
        let label = ArchiaRegularLabel()
        label.text = "Título"
        return label
    }()
    
    let tituloInput: UITextField = {
        let textField = UITextField()
        textField.addBorder(borderColor: .gris, widthBorder: 1)
        return textField
    }()
    
    func setUpView() {
        addSubview(auxPadding)
        addSubview(comienzaInput)
        addSubview(terminaInput)
        comienzaInput.delegate = self
        terminaInput.delegate  = self
        addSubview(comienza)
        addSubview(termina)
        addSubview(hora)
        addSubview(titulo)
        addSubview(tituloInput)
        
        addConstraintsWithFormat(format: "H:|-[v0(50)]-16-[v1(100)]-32-[v2(100)]", views: auxPadding, comienza, termina)
        addConstraintsWithFormat(format: "H:|-[v0(50)]-16-[v1(110)]-32-[v2(110)]", views: hora, comienzaInput, terminaInput)
        addConstraintsWithFormat(format: "H:|-[v0(50)]-[v1]-|", views: titulo, tituloInput)
        addConstraintsWithFormat(format: "V:|[v0(v1)]-[v1(v1)]-20-[v2(30)]", views: auxPadding, hora, titulo)
        addConstraintsWithFormat(format: "V:|[v0]-[v1(30)]-16-[v2(30)]", views: comienza, comienzaInput, tituloInput)
        addConstraintsWithFormat(format: "V:|[v0]-[v1(30)]", views: termina, terminaInput)
        //comienzaInput.addTarget(self, action: #selector(comienzoSeleccionado), for: .touchUpInside)
        comienzaInput.inputAccessoryView = toolbar_Picker
        comienzaInput.inputView = pickerView
        //terminaInput.addTarget(self, action: #selector(terminaSeleccionado), for: .touchUpInside)
        terminaInput.inputAccessoryView = toolbar_Picker
        terminaInput.inputView = pickerView
        
    }
    
    
    var pickerView: UIDatePicker = {
        let picker = UIDatePicker()
        //picker.minimumDate = Date()
        picker.datePickerMode = .time
        picker.setDate(Date(), animated: true)
        return picker
    }()
    
    private lazy var toolbar_Picker: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0,
                                              width: ScreenSize.screenWidth,
                                              height: 40) )
        self.embedButtons(toolbar)
        return toolbar
    }()
    private func embedButtons(_ toolbar: UIToolbar) {
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(cancelPressed) )
        let doneButton = UIBarButtonItem(title: "Ok", style: .done, target: self, action: #selector(donePressed))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbar.setItems([cancelButton, flexButton, doneButton], animated: true)
    }
    
    @objc func cancelPressed() {
        comienzaInput.resignFirstResponder()
        terminaInput.resignFirstResponder()
    }
    
    
    var comienzaIsSelected: Bool = false
    
    
    @objc func donePressed() {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "es_MX")
        timeFormatter.timeStyle = DateFormatter.Style.short
        let strDate = timeFormatter.string(from: pickerView.date)
        if comienzaIsSelected {
            comienzaInput.text = strDate
            comienzaInput.resignFirstResponder();
        }else{
            terminaInput.text = strDate
            terminaInput.resignFirstResponder();
        }
    }
    
    
    
} // HorarioCell


extension HorarioCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //textField.resignFirstResponder();
        
        if textField == comienzaInput {
            comienzaIsSelected = true
        }
        
        if textField == terminaInput {
            comienzaIsSelected = false
        }
        
    }
    
    /*func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
     //textField.resignFirstResponder();
     // ToDo
     return false
     }*/
}

/*
 extension HorarioCell: UIPickerViewDelegate,UIPickerViewDataSource {
 func numberOfComponents(in pickerView: UIPickerView) -> Int {
 return 3
 }
 func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
 switch component {
 case 0:
 return 25
 case 1,2:
 return 60
 
 default:
 return 0
 }
 }
 
 func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
 return pickerView.frame.size.width/3
 }
 
 func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
 switch component {
 case 0:
 return "\(row) Hour"
 case 1:
 return "\(row) Minute"
 case 2:
 return "\(row) Second"
 default:
 return ""
 }
 }
 func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
 switch component {
 case 0:
 // hour = row
 print(" row: \(row) ")
 case 1:
 // minutes = row
 print(" row: \(row) ")
 case 2:
 // seconds = row
 print(" row: \(row) ")
 default:
 break;
 }
 }
 }*/
