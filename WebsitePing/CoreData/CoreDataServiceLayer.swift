//
//  CoreDataServiceLayer.swift
//  WebsitePing
//
//  Created by Temirlan Dzodziev on 13.07.2020.
//  Copyright © 2020 Temirlan Dzodziev. All rights reserved.
//

import UIKit
import CoreData

class CoreDataService {
    
    static let shared = CoreDataService()
    
    func saveAnswer(_ link: String, _ status: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let answers = Answers(context: context)
        answers.link = link
        answers.status = status
        
        do {
            try context.save()
        } catch {
            print("Error:\(error)")
        }
    }
    
    func fetchAnswers(complition: @escaping([Answers]?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Answers> = Answers.fetchRequest()
        
        do {
            let result = try context.fetch(request)
            complition(result)
        } catch {
            complition(nil)
        }
    }
    
    func deleteTask(_ answer: Answers) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        context.delete(answer)
        do{
            try context.save()
        }catch{
            print("error with delete")
        }
    }
    
}
