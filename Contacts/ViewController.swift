//
//  ViewController.swift
//  Contacts
//
//  Created by Vu Thanh Tu Trang on 4/24/19.
//  Copyright © 2019 Vu Thanh Tu Trang. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UITableViewController {
    
    let cellId = "cellId"
	
	func someMethodIWantToCall(cell: UITableViewCell) {
        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }
        
        let contact = twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row]
        print(contact)
        
        let hasFavorited = contact.hasFavorited
			twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row].hasFavorited = !hasFavorited
        
//        tableView.reloadRows(at: [indexPathTapped], with: .fade)
        
        cell.accessoryView?.tintColor = hasFavorited ? UIColor.lightGray : .red
	}
	
    let twoDimensionalArray = [
        ExpandableNames(isExpanded:true, names:["An", "Anh"]),
        ExpandableNames(isExpanded:true, names:["Bảo", "Bắc", "Bình"]),
        ExpandableNames(isExpanded:true, names:["Mẫn", "Minh"]),
        ExpandableNames(isExpanded:true, names:["Pháp", "Phương"])
	]
	
	private func fetchContacts() {
        print("Attempting to fetch contacts today..")
        
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Failed to request access:", err)
                return
			}
            
            if granted {
                print("Access granted")
                
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    
                    var favoritableContacts = [FavoritableContact]()
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        
                        print(contact.givenName)
                        print(contact.familyName)
                        print(contact.phoneNumbers.first?.value.stringValue ?? "")
                        
                        favoritableContacts.append(FavoritableContact(contact: contact, hasFavorited: false))
                        
					})
                    
                    let names = ExpandableNames(isExpanded: true, names: favoritableContacts)
                    self.twoDimensionalArray = [names]
                    
					} catch let err {
                    print("Failed to enumerate contacts:", err)
				}
                
			} 
		}
	}
    
    var isLeft = true
    @objc func handleReload(){
        var indexPathToReload = [IndexPath]()
		
        for section in twoDimensionalArray.indices{
            for row in twoDimensionalArray[section].names.indices{
                let indexPath = IndexPath(row: row, section: section)
                indexPathToReload.append(indexPath)
			}
		}
        
        isLeft = !isLeft
		
        let animationStyle = isLeft ? UITableView.RowAnimation.left : .right
		
        tableView.reloadRows(at: indexPathToReload, with: animationStyle)
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		
		fetchContacts()
		
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(handleReload))
        
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
	}
	
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .yellow
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.tag = section
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
		return button
    }
	
	@objc func handleExpandClose(button: UIButton){
		let section = button.tag
		
		var indexPaths = [IndexPath]()
		for row in twoDimensionalArray[section].names.indices{
			let indexPath = IndexPath(row: row, section: section)
			indexPaths.append(indexPath)
		}
		
		let isExpanded = twoDimensionalArray[section].isExpanded
		twoDimensionalArray[section].isExpanded = !isExpanded
		
		button.setTitle(isExpanded ? "Open" : "Close", for: .normal)
		
		if(isExpanded){
			tableView.deleteRows(at: indexPaths, with: .fade)
            } else {
			tableView.insertRows(at: indexPaths, with: .fade)
		}
	}
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section:Int) -> CGFloat {
		return 36
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
        return names.count
	}
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twoDimensionalArray[section].names.count
	}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell {
	
        let cell = ContactCell(style: .subtitle, reuseIdentifier: cellId)
        
        cell.link = self
        
        let favoritableContact = twoDimensionalArray[indexPath.section].names[indexPath.row]
        
        cell.textLabel?.text = favoritableContact.contact.givenName + " " + favoritableContact.contact.familyName
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        cell.detailTextLabel?.text = favoritableContact.contact.phoneNumbers.first?.value.stringValue
        
        cell.accessoryView?.tintColor = favoritableContact.hasFavorited ? UIColor.red : .lightGray

        return cell
	}
   
}



