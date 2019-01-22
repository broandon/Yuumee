//
//  FechasCell.swift
//  Yuumee
//
//  Created by Easy Code on 1/22/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import Foundation

import JTAppleCalendar

class FechasCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Error to init ")
    }
    
    let containerDate: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    let fecha: ArchiaBoldLabel = {
        let label  = ArchiaBoldLabel()
        label.text = "Fecha:"
        return label
    }()
    lazy var fechaTextView: UITextField = {
        let frameRectImg = CGRect(x: 0, y: 0, width: 20, height: 20)
        let imageView   = UIImageView(frame: frameRectImg)
        let image       = UIImage(named: "down_arrow")
        imageView.image = image
        let textField   = UITextField()
        textField.textColor = UIColor.darkGray
        textField.font      = UIFont(name: "ArchiaRegular", size: 14.0)
        textField.textAlignment = .center
        textField.keyboardType  = UIKeyboardType.alphabet
        textField.rightViewMode = .always
        textField.rightView     = imageView
        let rectPaddView = CGRect(x: 0, y: 0, width: 15,
                                  height: textField.frame.height)
        let paddingView = UIView(frame: rectPaddView)
        textField.leftView = paddingView
        textField.delegate = self
        textField.layer.cornerRadius = 10
        textField.text = FormattedCurrentDate.getFormattedCurrentDate(date: Date(), format: "d/MMM/yyyy")
        return textField
    }()
    
    let containerRepetir: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        return view
    }()
    let repetir: ArchiaBoldLabel = {
        let label = ArchiaBoldLabel()
        label.text = "Repetir:"
        return label
    }()
    lazy var repetirTextView: UITextField = {
        let textField = UITextField()
        textField.text = "0"
        textField.delegate = self
        textField.keyboardType = UIKeyboardType.numberPad
        textField.textColor = UIColor.darkGray
        textField.textAlignment = .center
        textField.layer.cornerRadius = 10
        textField.font = UIFont(name: "ArchiaRegular", size: 14.0)
        textField.addBorder(borderColor: .black, widthBorder: 1)
        return textField
    }()
    
    
    // -------------------------------------------------------------------------
    var calendarView: JTAppleCalendarView = {
        let cellSize        = ScreenSize.screenWidth / 7
        let reuseIdentifier = "CustomCell"
        let calendarView    = JTAppleCalendarView(frame: CGRect.zero)
        calendarView.scrollDirection = UICollectionView.ScrollDirection.horizontal
        calendarView.backgroundColor = UIColor.white
        calendarView.isPagingEnabled = true
        calendarView.cellSize        = cellSize
        calendarView.minimumLineSpacing      = 0.0
        calendarView.minimumInteritemSpacing = 0.0
        calendarView.showsHorizontalScrollIndicator = false
        calendarView.register(CustomCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return calendarView
    }()
    let nextMonth: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
        button.setImage(UIImage(named: "right_arrow"), for: .normal)
        button.tintColor = .black
        return button
    }()
    let prevMont: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(previous(_:)), for: .touchUpInside)
        button.setImage(UIImage(named: "left_arrow"), for: .normal)
        button.tintColor = .black
        return button
    }()
    func getDayOfWeek(day: String) -> ArchiaRegularLabel {
        let fontSize: CGFloat = 12.0
        let label = ArchiaRegularLabel()
        label.text = day
        label.font = UIFont.init(name: "ArchiaRegular", size: fontSize)
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.textAlignment = .center
        return label
    }
    let formatter = DateFormatter()
    var currentCalendar = Calendar.current
    
    var currentMonthAndDate: ArchiaBoldLabel = {
        let label = ArchiaBoldLabel()
        //label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    var dateStringSelected: String!
    var dateSelected: Date? = nil
    // -------------------------------------------------------------------------
    
    
    @objc func next(_ sender: UIButton) {
        self.calendarView.scrollToSegment(.next)
    }
    @objc func previous(_ sender: UIButton) {
        self.calendarView.scrollToSegment(.previous)
    }
    
    func getCurrentTimeZone() -> String? {
        return TimeZone.current.abbreviation() //  .identifier
    }
    let contHeaderMap: UIView = {
        let view = UIView()
        return view
    }()
    
    private static func getDayOfWeek(day: String) -> ArchiaRegularLabel {
        let fontSize: CGFloat = 12.0
        let label  = ArchiaRegularLabel()
        label.text = day
        label.font = UIFont.init(name: "ArchiaRegular", size: fontSize)
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.textAlignment = .center
        return label
    }
    let stackView: UIStackView = {
        let dom = getDayOfWeek(day: "Do")
        let lun = getDayOfWeek(day: "Lu")
        let mar = getDayOfWeek(day: "Ma")
        let mie = getDayOfWeek(day: "Mi")
        let jue = getDayOfWeek(day: "Ju")
        let vie = getDayOfWeek(day: "Vi")
        let sab = getDayOfWeek(day: "Sa")
        let stackView          = UIStackView()
        stackView.axis         = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment    = UIStackView.Alignment.center
        stackView.addArrangedSubview(dom)
        stackView.addArrangedSubview(lun)
        stackView.addArrangedSubview(mar)
        stackView.addArrangedSubview(mie)
        stackView.addArrangedSubview(jue)
        stackView.addArrangedSubview(vie)
        stackView.addArrangedSubview(sab)
        //stackView.spacing   = 12.0
        return stackView
    }()
    
    func setUpView() {
        // Fecha
        containerDate.addSubview(fecha)
        containerDate.addSubview(fechaTextView)
        containerDate.addConstraintsWithFormat(format: "H:|-[v0(70)]-[v1(150)]",
                                               views: fecha, fechaTextView)
        containerDate.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: fecha)
        containerDate.addConstraintsWithFormat(format: "V:|-[v0(35)]", views: fechaTextView)
        // Repetir
        containerRepetir.addSubview(repetir)
        containerRepetir.addSubview(repetirTextView)
        containerRepetir.addConstraintsWithFormat(format: "H:|-[v0(70)]-[v1(80)]", views: repetir, repetirTextView)
        containerRepetir.addConstraintsWithFormat(format: "V:|-[v0(30)]", views: repetir)
        containerRepetir.addConstraintsWithFormat(format: "V:|-[v0(35)]", views: repetirTextView)
        containerDate.isHidden = true
        containerRepetir.isHidden = true
        //----------------------------------------------------------------------
        //                           JTAppleCalendarView
        calendarView.calendarDataSource = self
        calendarView.calendarDelegate   = self
        calendarView.minimumLineSpacing = 0.0
        calendarView.minimumInteritemSpacing = 0.0
        calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        addSubview(stackView)
        addSubview(calendarView)
        addSubview(contHeaderMap)
        contHeaderMap.addSubview(nextMonth)
        contHeaderMap.addSubview(prevMont)
        contHeaderMap.addSubview(currentMonthAndDate)
        contHeaderMap.addConstraintsWithFormat(format: "H:|[v0(25)]-[v1]-[v2(25)]|",
                                               views: prevMont, currentMonthAndDate, nextMonth)
        contHeaderMap.addConstraintsWithFormat(format: "V:|-[v0(25)]", views: nextMonth)
        contHeaderMap.addConstraintsWithFormat(format: "V:|-[v0(25)]", views: prevMont)
        contHeaderMap.addConstraintsWithFormat(format: "V:|-[v0]", views: currentMonthAndDate)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: contHeaderMap)
        addConstraintsWithFormat(format: "H:|-[v0]-|", views: stackView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: calendarView)
        addSubview(containerDate)
        addSubview(containerRepetir)
        addConstraintsWithFormat(format: "H:|[v0]|", views: containerDate)
        addConstraintsWithFormat(format: "H:|[v0]|", views: containerRepetir)
        addConstraintsWithFormat(format: "V:|[v0(0)]-[v1(0)][v2(40)][v3(30)][v4(260)]",
                                 views: containerDate, containerRepetir, contHeaderMap, stackView, calendarView)
        dateSelected = Date()
        nextMonth.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
        prevMont.addTarget(self, action: #selector(previous(_:)), for: .touchUpInside)
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        let todaysDate = FormattedCurrentDate.getFormattedCurrentDate(date: startDate,
                                                                      format: "MMMM, yyyy")
        self.currentMonthAndDate.text = todaysDate
    }
    
    
    let outsideMonthColor  = UIColor.clear//UIColor.init(rgb:0x584a66)
    let monthColor         = UIColor.gray
    let selectedMonthColor = UIColor.white //.withAlphaComponent(0.9) //UIColor.init(rgb:0x3a294b)
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else {
            return
        }
        let todaysDate = Date()
        formatter.dateFormat = "yyyy MM dd"
        let todayDateString = formatter.string(from: todaysDate)
        let monthsDateString = formatter.string(from: cellState.date)
        if todayDateString == monthsDateString && cellState.dateBelongsTo == .thisMonth {
            // Current Day
            validCell.dateLabel.font = UIFont.boldSystemFont(ofSize: validCell.dateLabel.font.pointSize)
            validCell.dateLabel.textColor = UIColor.rosa
            
        } else if cellState.date < todaysDate && cellState.dateBelongsTo == .thisMonth {
            validCell.dateLabel.textColor = UIColor.lightGray
        } else {
            if cellState.isSelected {
                if cellState.dateBelongsTo == .thisMonth {
                    validCell.dateLabel.textColor = self.selectedMonthColor
                }
            } else {
                if cellState.dateBelongsTo == .thisMonth {
                    validCell.dateLabel.textColor = self.monthColor
                } else {
                    validCell.dateLabel.textColor = self.outsideMonthColor
                }
            }
        }
    }
    
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else { return }
        if cellState.isSelected && cellState.dateBelongsTo == .thisMonth {
            //-validCell.selectedView.isHidden = false
            let todaysDate = Date()
            formatter.dateFormat = "yyyy MM dd"
            let day = currentCalendar.component(.day, from: todaysDate)
            if validCell.dateLabel.text! == "\(day)" {
                validCell.selectedView.layer.cornerRadius = 0
                validCell.selectedView.layer.borderColor = UIColor.clear.cgColor
                validCell.selectedView.layer.borderWidth = 1
                validCell.selectedView.backgroundColor = UIColor.clear
            }
            else {
                /*validCell.selectedView.layer.cornerRadius = (validCell.selectedView.bounds.width / 2) - 1 // 19
                 validCell.selectedView.layer.borderColor = UIColor.rosa.cgColor
                 validCell.selectedView.layer.borderWidth = 1
                 validCell.selectedView.backgroundColor = UIColor.rosa*/
                validCell.selectedView.layer.cornerRadius = 17
                validCell.selectedView.layer.borderColor = UIColor.rosa.cgColor
                validCell.selectedView.layer.borderWidth = 1
                validCell.selectedView.backgroundColor = UIColor.rosa
            }
        }
        else {
            validCell.selectedView.layer.cornerRadius = 0
            validCell.selectedView.layer.borderColor = UIColor.clear.cgColor
            validCell.selectedView.layer.borderWidth = 1
            validCell.selectedView.backgroundColor = UIColor.clear
        }
    }
    
}



extension FechasCell: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale   = Calendar.current.locale
        let startDate = formatter.date(from: formatter.string(from: Date()))!
        let endDate = formatter.date(from: "2100 02 01")!
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: currentCalendar,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }
}

extension FechasCell:JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        //cell.layer.borderColor = UIColor.red.cgColor
        //cell.layer.borderWidth = 1
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        //handleDateRangeSelection(view: cell, cellState: cellState)
        cell.layoutIfNeeded()
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        cell.layoutIfNeeded()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        // Fecha Seleccionada
        formatter.dateFormat = "yyyy-MM-dd"
        let todaysDate = formatter.string(from: date)
        dateStringSelected = todaysDate
        dateSelected = date
        cell?.bounce()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        formatter.dateFormat = "yyyy MM dd"
        let todayDateString = formatter.string(from: Date())
        let monthsDateString = formatter.string(from: cellState.date)
        if cellState.dateBelongsTo != .thisMonth || (cellState.date < Date() && todayDateString != monthsDateString){
            return false
        } else {
            return true
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if cellState.dateBelongsTo == .thisMonth {
            return true
        } else {
            return false
        }
    }
    
}



extension FechasCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == fechaTextView {
            fechaTextView.resignFirstResponder();
            print(" se llama el modal de fecha ")
            // ToDo
            /*let vc = CategoriasComidaViewController()
             vc.delegate = self
             vc.currentFood = self.categoria.text!
             let popVC = UINavigationController(rootViewController: vc)
             popVC.modalPresentationStyle = .popover
             let popOverVC = popVC.popoverPresentationController
             popOverVC?.delegate = self
             popOverVC?.sourceView = categoria // self.button
             popOverVC?.sourceRect = CGRect(x: self.categoria.bounds.midX,
             y: self.categoria.bounds.minY,
             width: 0, height: 0)
             let widthModal = ScreenSize.screenWidth - 16
             let heightModal = ScreenSize.screenWidth
             popVC.preferredContentSize = CGSize(width: widthModal, height: heightModal)
             reference.present(popVC, animated: true)
             */
            return false
        }
        if textField == repetirTextView {
            return true
        }
        return false
    }
}



class CustomCell: JTAppleCell {
    var dateLabel:    UILabel!
    var selectedView: UIView!
    var rightView:    UIView!
    var leftView:     UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        selectedView = UIView(frame: CGRect.zero)
        addSubview(selectedView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: selectedView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: selectedView)
        selectedView.backgroundColor = UIColor.rosa
        dateLabel = UILabel(frame: CGRect.zero)
        dateLabel.textAlignment = .center
        selectedView.addSubview(dateLabel)
        selectedView.addConstraintsWithFormat(format: "H:|[v0]|", views: dateLabel)
        selectedView.addConstraintsWithFormat(format: "V:|[v0]|", views: dateLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}


extension UIView {
    func bounce() {
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.1,
                       options: UIView.AnimationOptions.beginFromCurrentState,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
}
