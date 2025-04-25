//
//  DetailViewModel.swift
//  ToDoApplication
//
//  Created by Yakup Atici on 25.04.2025.
//

import Foundation

class DetailViewModel {
    var todoRepository = TodosRepository()
    
    func guncelle(todo_id:Int ,todo_name:String){
        todoRepository.guncelle(todo_id: todo_id, todo_name: todo_name)
    }
}
