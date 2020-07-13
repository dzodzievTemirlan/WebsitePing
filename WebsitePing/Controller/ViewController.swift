//
//  ViewController.swift
//  WebsitePing
//
//  Created by Temirlan Dzodziev on 13.07.2020.
//  Copyright © 2020 Temirlan Dzodziev. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var answers = [Answers]()
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataService.shared.fetchAnswers { (result) in
            self.answers = result!
        }
        
        tableViewService()
    }
    
    @IBAction func testButtonPressed(_ sender: UIButton) {
        testPing()
    }
    
    fileprivate func tableViewService() {
        tableViewOutlet.dataSource = self
        tableViewOutlet.delegate = self
        tableViewOutlet.layer.cornerRadius = 20
        testButton.layer.cornerRadius = 5
        tableViewOutlet.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    fileprivate func testPing() {
        if let url = URL(string: textField.text!) {
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"
            URLSession(configuration: .default)
                .dataTask(with: request) { (_, response, error) -> Void in
                    guard error == nil else {
                        DispatchQueue.main.async {
                            self.showAlert()
                        }
                        return
                    }
                    guard let answer = (response as? HTTPURLResponse)?.statusCode else {return}
                    DispatchQueue.main.async {
                        guard let link = self.textField.text else {return}
                        CoreDataService.shared.saveAnswer(link, String(answer))
                        CoreDataService.shared.fetchAnswers { (result) in
                            guard let result = result else {return}
                            self.answers = result
                            self.tableViewOutlet.reloadData()
                        }
                        
                    }
            }
            .resume()
        }
    }
    
    fileprivate func showAlert() {
        let alert = UIAlertController(title: "Error with link or server", message: "try again :)", preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let unwrappedCell = cell as? TableViewCell else {return cell}
        unwrappedCell.link.text  = answers[indexPath.row].link
        unwrappedCell.status.text = answers[indexPath.row].status
        return unwrappedCell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { (_, _, bool) in
            DispatchQueue.main.async {
                self.answers.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.tableViewOutlet.reloadData()
                bool(true)
            }
        }
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        CoreDataService.shared.deleteTask(self.answers[indexPath.row])
        return swipe
    }
}
