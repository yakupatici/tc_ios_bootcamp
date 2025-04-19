//
//  TodoSave.swift
//  ToDoApplication
//
//  Created by Yakup Atici on 19.04.2025.
//

import UIKit

class TodoSave: UIViewController {
    
    
    @IBOutlet weak var todoId: UITextField!
    
    
    
    @IBOutlet weak var todoName: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        

        if let todoNameText = todoName.text,
                  let todoIdText = todoId.text {
                   kaydet(todoName1: todoNameText, todoId1: todoIdText)
               }
    }
    func kaydet(todoName1: String, todoId1: String) {
           print("Todo adı: \(todoName1), ID: \(todoId1)")
         
       }
}
   
