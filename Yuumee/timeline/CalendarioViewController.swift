//
//  CalendarioViewController.swift
//  Yuumee
//
//  Created by Luis Segoviano on 1/19/19.
//  Copyright © 2019 lsegoviano. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarioViewController: BaseViewController {
    
    var calendarView: JTAppleCalendarView = {
        let cellSize        = ScreenSize.screenWidth / 8
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
    
    lazy var nextMonth: UIButton = {
        let imageNext    = UIImage(named: "right_arrow")
        let button       = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(imageNext, for: .normal)
        return button
    }()
    
    lazy var prevMont: UIButton = {
        let imagePrev    = UIImage(named: "left_arrow")
        let button       = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(imagePrev, for: .normal)
        return button
    }()
    
    
    private static func getDayOfWeek(day: String) -> ArchiaRegularLabel {
        let fontSize: CGFloat = 12.0
        let label = ArchiaRegularLabel()
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
        return stackView
    }()
    
    
    var currentMonthAndDate: ArchiaBoldLabel = {
        let label = ArchiaBoldLabel()
        label.textAlignment = .center
        return label
    }()
    
    /**
     * Funcion para mover la vista del calendario, hacia el siguiente mes
     *
     */
    @objc func next(_ sender: UIButton) {
        print(" NEXT ")
        self.calendarView.scrollToSegment(.next)
    }
    
    /**
     * Funcion para mover la vista del calendario, al mes anterior
     *
     */
    @objc func previous(_ sender: UIButton) {
        print(" previous ")
        self.calendarView.scrollToSegment(.previous)
    }
    
    var dateSelected: Date?        = nil
    let formatter: DateFormatter   = DateFormatter()
    var dateStringSelected: String = ""
    var currentCalendar: Calendar  = Calendar.current
    
    let contHeaderCalendar: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.borders(for: [.top, .bottom])
        return view
    }()
    
    let listo: UIButton = {
        let button: UIButton    = UIButton(type: .system)
        button.backgroundColor  = UIColor.gris
        button.tintColor        = UIColor.darkGray
        let sizeFont: CGFloat   = (button.titleLabel?.font.pointSize)!
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: sizeFont)
        button.setTitle("Listo", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .white
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //----------------------------------------------------------------------
        //                           JTAppleCalendarView
        calendarView.minimumLineSpacing      = 0.0
        calendarView.minimumInteritemSpacing = 0.0
        calendarView.calendarDataSource      = self
        calendarView.calendarDelegate        = self
        calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        mainView.addSubview(stackView)
        mainView.addSubview(calendarView)
        mainView.addSubview(contHeaderCalendar)
        mainView.addSubview(listo)
        contHeaderCalendar.addSubview(nextMonth)
        contHeaderCalendar.addSubview(prevMont)
        contHeaderCalendar.addSubview(currentMonthAndDate)
        contHeaderCalendar.addConstraintsWithFormat(format: "H:|[v0(20)]-[v1]-[v2(20)]|",
                                                    views: prevMont, currentMonthAndDate, nextMonth)
        contHeaderCalendar.addConstraintsWithFormat(format: "V:|-[v0(20)]", views: nextMonth)
        contHeaderCalendar.addConstraintsWithFormat(format: "V:|-[v0(20)]", views: prevMont)
        contHeaderCalendar.addConstraintsWithFormat(format: "V:|-[v0]-|", views: currentMonthAndDate)
        mainView.addConstraintsWithFormat(format: "H:|-[v0]-32-|", views: contHeaderCalendar)
        mainView.addConstraintsWithFormat(format: "H:|-16-[v0]-48-|", views: stackView)
        mainView.addConstraintsWithFormat(format: "H:|-[v0]-32-|", views: calendarView)
        mainView.addConstraintsWithFormat(format: "H:|-16-[v0]-32-|", views: listo)
        mainView.addConstraintsWithFormat(format: "V:|-16-[v0(40)][v1(30)][v2(250)]-[v3(40)]",
                                          views: contHeaderCalendar, stackView, calendarView, listo)
        nextMonth.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
        prevMont.addTarget(self, action: #selector(previous(_:)), for: .touchUpInside)
        
        listo.addTarget(self, action: #selector(listoEvent), for: .touchUpInside)
    
    }
    
    @objc func listoEvent(ckeck: Any) {
        print(" listo ")
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            print(" a poco se queda aqui?? ")
            return
        }
        print(" startDate: \(startDate) ")
        let todaysDate = FormattedCurrentDate.getFormattedCurrentDate(date: startDate, format: "MMMM, yyyy")
        
        /*let month = Calendar.current.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        let year = Calendar.current.component(.year, from: startDate)*/
        
        self.currentMonthAndDate.text = todaysDate // monthName + " " + String(year)
    }
    
    let outsideMonthColor  = UIColor.gray
    let monthColor         = UIColor.gray
    let selectedMonthColor = UIColor.gray
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CustomCell else {
            return
        }
        let todaysDate = Date()
        formatter.dateFormat = "yyyy MM dd"
        let todayDateString  = formatter.string(from: todaysDate)
        let monthsDateString = formatter.string(from: cellState.date)
        if todayDateString == monthsDateString && cellState.dateBelongsTo == .thisMonth {
            // Current Day
            validCell.dateLabel.font      = UIFont.boldSystemFont(ofSize: validCell.dateLabel.font.pointSize)
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
                validCell.selectedView.layer.cornerRadius = 20
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

extension CalendarioViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone   = Calendar.current.timeZone
        formatter.locale     = Calendar.current.locale
        let startDate  = formatter.date(from: formatter.string(from: Date()))!
        let endDate    = formatter.date(from: "2100 02 01")!
        let parameters = ConfigurationParameters(startDate:    startDate,
                                                 endDate:      endDate,
                                                 numberOfRows: 6,
                                                 calendar:     currentCalendar,
                                                 generateInDates:  .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek:   .sunday)
        return parameters
    }
}


extension CalendarioViewController:JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
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
        let todaysDate       = formatter.string(from: date)
        dateStringSelected   = todaysDate
        dateSelected         = date
        cell?.bounce()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        print(" setupViewsOfCalendar ")
        self.setupViewsOfCalendar(from: visibleDates)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        formatter.dateFormat = "yyyy MM dd"
        let todayDateString  = formatter.string(from: Date())
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


