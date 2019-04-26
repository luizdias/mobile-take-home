//
//  AutocompleteTextField.swift
//  GuestlogixChallenge
//
//  Created by Luiz Fernando Aquino Dias on 23/04/19.
//  Copyright © 2019 Luiz Fernando Aquino Dias. All rights reserved.
//

import UIKit
import CoreData

class AutocompleteTextField: UITextField  {
    
    var dataList : [Airport] = [Airport]()
    var resultsList : [SearchItem] = [SearchItem]()
    var tableView: UITableView?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Connecting the new element to the parent view
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView?.removeFromSuperview()
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.addTarget(self, action: #selector(AutocompleteTextField.textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(AutocompleteTextField.textFieldDidBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(AutocompleteTextField.textFieldDidEndEditing), for: .editingDidEnd)
        self.addTarget(self, action: #selector(AutocompleteTextField.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)
    }
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        buildSearchTableView()
    }
    
    // MARK: TextField methods
    @objc open func textFieldDidChange(){
        filter()
        updateSearchTableView()
        tableView?.isHidden = false
    }
    
    @objc open func textFieldDidBeginEditing() {
        
    }
    
    @objc open func textFieldDidEndEditing() {
        
    }
    
    @objc open func textFieldDidEndEditingOnExit() {
        
    }
    
    // MARK: CoreData manipulation methods
    func loadItems(withRequest request : NSFetchRequest<Airport>) {
        do {
            dataList = try context.fetch(request)
        } catch {
            print("Error while fetching data: \(error)")
        }
    }
    
    
    // MARK: Filtering methods
    fileprivate func filter() {
        let predicate = NSPredicate(format: "iata3 CONTAINS[cd] %@", self.text!)
        let request : NSFetchRequest<Airport> = Airport.fetchRequest()
        request.predicate = predicate
        
        loadItems(withRequest : request)
        
        resultsList = []
        
        for i in 0 ..< dataList.count {
            
            let item = SearchItem(iata3Code: dataList[i].iata3!)
            
            let iata3FilterRange = (item.iata3Code as NSString).range(of: text!, options: .caseInsensitive)
            
            if iata3FilterRange.location != NSNotFound {
                item.attributedIATA3Code = NSMutableAttributedString(string: item.iata3Code)
                
                item.attributedIATA3Code!.setAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: iata3FilterRange)
                
                resultsList.append(item)
            }
            
        }
        
        tableView?.reloadData()
    }
    
    
}

// MARK: TableView creation and updating
extension AutocompleteTextField: UITableViewDelegate, UITableViewDataSource {
    func buildSearchTableView() {
        
        if let tableView = tableView {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AutocompleteTextFieldCell")
            tableView.delegate = self
            tableView.dataSource = self
            self.window?.addSubview(tableView)
            
        } else {
            tableView = UITableView(frame: CGRect.zero)
        }
        
        updateSearchTableView()
    }
    
    func updateSearchTableView() {
        
        if let tableView = tableView {
            superview?.bringSubviewToFront(tableView)
            var tableHeight: CGFloat = 0
            tableHeight = tableView.contentSize.height
            
            // Set a bottom margin of 10p
            if tableHeight < tableView.contentSize.height {
                tableHeight -= 10
            }
            
            // Set tableView frame
            var tableViewFrame = CGRect(x: 0, y: 0, width: frame.size.width - 4, height: tableHeight)
            tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
            tableViewFrame.origin.x += 2
            tableViewFrame.origin.y += frame.size.height + 2
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.tableView?.frame = tableViewFrame
            })
            
            //Setting tableView style
            tableView.layer.masksToBounds = true
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.layer.cornerRadius = 5.0
            tableView.separatorColor = UIColor.lightGray
            tableView.backgroundColor = UIColor.white.withAlphaComponent(1.0)
            
            if self.isFirstResponder {
                superview?.bringSubviewToFront(self)
            }
            
            DispatchQueue.main.async(execute: {
                tableView.reloadData()
            })
        }
    }
    
    // MARK: TableViewDataSource methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsList.count
    }
    
    // MARK: TableViewDelegate methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutocompleteTextFieldCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.attributedText = resultsList[indexPath.row].getFormatedText()
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.text = resultsList[indexPath.row].getStringText()
        tableView.isHidden = true
        self.endEditing(true)
    }
    
}
