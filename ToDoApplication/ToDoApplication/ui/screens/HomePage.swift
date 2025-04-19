//
//  ViewController.swift
//  ToDoApplication
//
//  Created by Yakup Atici on 19.04.2025.
//

import UIKit

class Homepage: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    

    @IBOutlet weak var todoTableView: UITableView!
    
    var todoList = [Todos]()
       
       override func viewDidLoad() {
           super.viewDidLoad()
  
           searchBar.delegate = self
           todoTableView.delegate = self
           todoTableView.dataSource = self
           
           let t1 = Todos(todo_id: 1, todo_name: "Buy bread")
           let t2 = Todos(todo_id: 2, todo_name: "Study lessons")
           let t3 = Todos(todo_id: 3, todo_name: "Go to the market")
           let t4 = Todos(todo_id: 4, todo_name: "Do workout")
           let t5 = Todos(todo_id: 5, todo_name: "Read a book")
           let t6 = Todos(todo_id: 6, todo_name: "Call mom")
           let t7 = Todos(todo_id: 7, todo_name: "Finish homework")
           let t8 = Todos(todo_id: 8, todo_name: "Clean the room")
           let t9 = Todos(todo_id: 9, todo_name: "Pay bills")
           let t10 = Todos(todo_id: 10, todo_name: "Water the plants")
           
           todoList.append(contentsOf: [t1, t2, t3, t4, t5, t6, t7, t8, t9, t10])
       }

       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "toDetail" {
               if let todo = sender as? Todos {
                   let destinationVC = segue.destination as! TodoDetail
                   destinationVC.todo = todo
               }
           }
       }
   }

   // MARK: - SearchBar Delegate

   extension Homepage: UISearchBarDelegate {
       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           print("Ara: \(searchText)")
           // Arama işlemleri burada yapılabilir
       }
   }

   // MARK: - TableView Delegate & DataSource

   extension Homepage: UITableViewDelegate, UITableViewDataSource {
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return todoList.count
       }

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
            
                   self.todoList.remove(at: indexPath.row)
                   tableView.deleteRows(at: [indexPath], with: .fade)
               })
               
               self.present(alert, animated: true)
           }

           return UISwipeActionsConfiguration(actions: [silAction])
       }
   }
