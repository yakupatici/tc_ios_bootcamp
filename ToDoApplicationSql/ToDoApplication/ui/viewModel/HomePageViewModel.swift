//
//  HomePageViewModel.swift
//  ToDoApplication
//
//  Created by Yakup Atici on 25.04.2025.
//

//
//  AnasayfaViewModel.swift
//  KisilerUygulamasi
//
//  Created by Kasım on 20.04.2025.
//

import Foundation
import RxSwift

class HomePageViewModel {
    var todosRepository = TodosRepository()
    var todosList = BehaviorSubject<[Todos]>(value: [Todos]())
    
    init(){
        veritabaniKopyala()
        todosList = todosRepository.todosList//Bağlantı
    }
    
    func ara(aramaKelimesi:String){
        todosRepository.ara(aramaKelimesi: aramaKelimesi)
    }
    
    func sil(todo_id:Int){
        todosRepository.sil(todo_id: todo_id)
        todosYukle()
    }
    
    func todosYukle(){
        todosRepository.todosYukle()
    }
    
    func veritabaniKopyala(){
            let bundleYolu = Bundle.main.path(forResource: "todo_app", ofType: ".sqlite")
            let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let kopyalanacakYer = URL(fileURLWithPath: hedefYol).appendingPathComponent("todo_app.sqlite")
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: kopyalanacakYer.path){
                print("Veritabanı zaten var")
            }else{
                do{
                    try fileManager.copyItem(atPath: bundleYolu!, toPath: kopyalanacakYer.path)
                }catch{}
            }
    }
}
