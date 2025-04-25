//
//  ViewController.swift
//  ToDoApplication
//
//  Created by Yakup Atici on 19.04.2025.
//

import UIKit
import RxSwift
class Homepage: UIViewController {

 
    
    @IBOutlet weak var searchBar: UISearchBar!
    

    @IBOutlet weak var todoTableView: UITableView!
    
    var todoList = [Todos]()
    var homepageViewModel = HomePageViewModel()
       
    override func viewDidLoad() {
        super.viewDidLoad()
        //Yaşam döngüsü metodu
        //Sayfa açıldığında bir kere çalışır.
        print("viewDidLoad() metodu çalıştı.")
        searchBar.delegate = self
        
        todoTableView.delegate = self
        todoTableView.dataSource = self
        
        _ = homepageViewModel.todosList.subscribe(onNext: { liste in//Dinleme
            self.todoList = liste
            self.todoTableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Sayfa her göründüğünde çalışır.
        //Sayfaya geri dönüldüğünü anlayabiliriz.
        print("viewWillAppear çalıştı.")
        homepageViewModel.todosYukle()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //Sayfa her görünmez olduğunda çalışır.
        print("viewDidDisappear çalıştı.")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Geçiş yapıldı")
        if segue.identifier == "toDetay" {
            print("toDetay çalıştı")
            //Any : bütün sınıfların üstündedir.Java Object
            if let todo = sender as? Todos {//as? downcasting : Super class > Sub class dönüştürmektir.
                print("Veri : \(todo.todo_id!)")
                let gidilecekVC = segue.destination as! TodoDetail
                //as? : downcasting,hata olma ihtimali yüksekse bunu kullanıyoruz.
                //as! : downcasting,hata olma ihtimali düşükse bunu kullanıyoruz.
                gidilecekVC.todo = todo
            }
        }
    }
    
    
}

extension Homepage : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        homepageViewModel.ara(aramaKelimesi: searchText)
    }
}

extension Homepage : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }//Kaç tane satır oluşturucak
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               let todo = todoList[indexPath.row]

               let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! tableviewtodoTableViewCell

               cell.todoName.text = todo.todo_name
               cell.todoId.text = "ID: \(todo.todo_id ?? 0)"  // Güvenli unwrap

               return cell
           }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
              let todo = todoList[indexPath.row]
              performSegue(withIdentifier: "toDetail", sender: todo)
              tableView.deselectRow(at: indexPath, animated: true)
          }

          // Silme işlemi
          func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

              let silAction = UIContextualAction(style: .destructive, title: "Sil") { _, _, _ in
                  let todo = self.todoList[indexPath.row]

                  let alert = UIAlertController(title: "Sil", message: "\(todo.todo_name ?? "") silinsin mi?", preferredStyle: .alert)
                  
                  alert.addAction(UIAlertAction(title: "İptal", style: .cancel))
                  alert.addAction(UIAlertAction(title: "Evet", style: .destructive) { _ in
                      print("Silinen Todo ID: \(todo.todo_id!)")

                      // Call ViewModel to delete from database
                      self.homepageViewModel.sil(todo_id: todo.todo_id!)

                      // Remove from local list and table view (ViewModel's todosYukle will update the list anyway,
                      // but immediate UI update is better UX)
                      // Optional: Remove these two lines if you rely solely on todosYukle() refresh
                      // self.todoList.remove(at: indexPath.row)
                      // tableView.deleteRows(at: [indexPath], with: .fade)
                  })
                  
                  self.present(alert, animated: true)
              }

              return UISwipeActionsConfiguration(actions: [silAction])
          }
      }

