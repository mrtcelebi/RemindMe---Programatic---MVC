//
//  ViewController.swift
//  RemindMe
//
//  Created by Catalina on 20.08.2020.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit
import NotificationCenter
import RealmSwift

class HomeViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(RemindMeTableViewCell.self, forCellReuseIdentifier: RemindMeTableViewCell.identifier)
        table.backgroundColor = .gray
        return table
    }()
    
    var remindMeModel: Results<Remind>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Remind Me"
        tableView.dataSource = self
        tableView.delegate = self
        setupBarBtns()
        loadItems()
        
        requestAuthorization()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
    
    private func requestAuthorization() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {[weak self] _, error in

            guard let self = self else { return }
            
            if error != nil {
                self.simpleAlertView(message: "Error")
            }
        })
    }
    
    private func setupBarBtns() {
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnPressed))
        navigationItem.rightBarButtonItem = addBtn
    }

    @objc private func addBtnPressed() {
        let vc = AddViewController()
        vc.title = "Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {title, body, date in
            DispatchQueue.main.async {
                
                self.navigationController?.popViewController(animated: true)

                let new = Remind()
                new.title = title
                new.date = date
                new.identifier = "id_\(title)"
                
                do {
                    try self.realm.write() {
                        self.realm.add(new)
                    }
                } catch {
                    self.simpleAlertView(message: "Item did not save.")
                }
                self.tableView.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                                                          from: targetDate), repeats: false)
                let request = UNNotificationRequest(identifier: "id_\(title)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        self.simpleAlertView(message: "NotificationCenter got error!")
                    }
                })
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func loadItems() {
        remindMeModel = realm.objects(Remind.self)
        tableView.reloadData()
    }
    
    private func deleteItems(indexPath: IndexPath) {
        
        if let item = remindMeModel?[indexPath.row]{
            do {
                try self.realm.write {
                    self.realm.delete(item)
                    self.tableView.reloadData()
                }
            } catch {
                self.simpleAlertView(message: "Could not delete the item.")
            }
        }
    }
    
    
    public func simpleAlertView(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
 
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}


extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remindMeModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RemindMeTableViewCell.identifier, for: indexPath) as! RemindMeTableViewCell
        cell.titleLabel.text = remindMeModel?[indexPath.row].title ?? "No data yet"
        
        let date = remindMeModel?[indexPath.row].date ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd, YYYY HH:mm a"
        cell.dateLabel.text = formatter.string(from: date)
        
        if let item = remindMeModel?[indexPath.row] {
            cell.accessoryType = item.done ? .none : .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            self.deleteItems(indexPath: indexPath)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if let item = remindMeModel?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}


