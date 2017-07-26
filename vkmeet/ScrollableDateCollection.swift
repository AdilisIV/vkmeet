//
//  scrollDateCollection.swift
//  vkmeet
//
//  Created by user on 7/26/17.
//  Copyright © 2017 Ski. All rights reserved.
//

import UIKit


public protocol dateCollectionDelegate: class {
    func datepicker(_ datepicker: ScrollableDateCollection, didSelectDate date: Date)
}

//private let reuseIdentifier = "Cell"

open class ScrollableDateCollection: UICollectionViewController {
    
    public weak var delegate: dateCollectionDelegate? // delegate
    

    override open func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.reloadData()
        DispatchQueue.main.async {
            self.scrollToSelectedDate(animated: false)
        }

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: Configuration properties
    
    public var cellConfiguration: ((_ cell: DayCell, _ isWeekend: Bool, _ isSelected: Bool) -> Void)? {
        didSet {
            collectionView?.reloadData()
        }
    }
    var dates = [Date]() {
        didSet {
            collectionView?.reloadData()
        }
    }
    public var selectedDate: Date? {
        didSet {
            collectionView?.reloadData()
        }
    }
    public var configuration = Configuration() {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    
    
    
    
    // MARK: Methods
    
    public func scrollToSelectedDate(animated: Bool) {
        guard let selectedDate = self.selectedDate else {
            return
        }
        
        guard let index = dates.index(where: { Int($0.timeIntervalSince1970) == Int(selectedDate.timeIntervalSince1970) }) else {
            return
        }
        
        collectionView?.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: animated)
        collectionView?.reloadData()
    }
    
    
    
    

    // MARK: UICollectionViewDataSource

//    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 5
//    }


    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }

    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.ClassName, for: indexPath) as! DayCell
        
        let date = dates[indexPath.row]
        let isWeekendDate = isWeekday(date: date)
        let isSelectedDate = isSelected(date: date)
        
        cell.setup(date: date, style: configuration.calculateDayStyle(isWeekend: isWeekendDate, isSelected: isSelectedDate))
        
        if let configuration = cellConfiguration {
            configuration(cell, isWeekendDate, isSelectedDate)
        }
        
        return cell
    }
    
    
    private func isWeekday(date: Date) -> Bool {
        let day = NSCalendar.current.component(.weekday, from: date)
        return day == 1 || day == 7
    }
    
    private func isSelected(date: Date) -> Bool {
        guard let selectedDate = selectedDate else {
            return false
        }
        return Int(date.timeIntervalSince1970) == Int(selectedDate.timeIntervalSince1970)
    }

    
    
    
    
    // MARK: UICollectionViewDelegate
    
    override open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let date = dates[indexPath.row]
        selectedDate = date
        delegate?.datepicker(self, didSelectDate: date)
        scrollToSelectedDate(animated: true)
    }

    
    
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat
        switch configuration.daySizeCalculation {
        case .constantWidth(let width):
            itemWidth = width
            break
        case .numberOfVisibleItems(let count):
            itemWidth = collectionView.frame.width / CGFloat(count)
            break
        }
        return CGSize(width: itemWidth, height: collectionView.frame.height)
    }

}
