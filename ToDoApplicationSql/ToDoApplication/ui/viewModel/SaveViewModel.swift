//
//  SaveViewModel.swift
//  ToDoApplication
//
//  Created by Yakup Atici on 25.04.2025.
//


import Foundation

class SaveViewModel {
    var todoRepository = TodosRepository()
    
    func kaydet(todo_id:Int,todo_name:String){
        todoRepository.kaydet(todo_id: todo_id, todo_name: todo_name)
    }
}
