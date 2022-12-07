//
//  ViewController.swift
//  NSFetchResultController
//
//  Created by Даша Волошина on 6.12.22.
//
//Разобраться с NSFetchResultController. Для этого создадим приложение, один раз положим в CoreData 10 User(name:String, surname: String, birthday: Date). Отобразим в TableView этих 10 юзеров (поля имя фамилия и день рождения) в ячейках используя NSfetchResultController. Также при смахивании ячейки в TableView удаляем соответствующего юзера из CoreData

import UIKit
import SnapKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
  
    let userObject = UserCoreData()
    var fetchVC:NSFetchedResultsController<User>!
    
    let users:[User] = []
    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(buttonTap))
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
        
        tableView.dataSource = self
        tableView.delegate = self
        createNSFetchVC()
    }
    
    
    func createNSFetchVC() {
        let request = NSFetchRequest<User>(entityName: "User")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \User.name, ascending: true)]
        fetchVC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: userObject.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchVC.delegate = self
        do{
            try fetchVC.performFetch()
            tableView.reloadData()
        }catch{
            print(error)
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    @objc func buttonTap (_ sender:UIButton){
        
        let vc = UIAlertController(title: "User", message: "create User", preferredStyle: .alert)

        let action = UIAlertAction(title: "Create", style: .default, handler: { action in
    
            self.userObject.createUser(name: (vc.textFields?[0].text)!, surName: (vc.textFields?[1].text)!)
                self.userObject.updateUser()
    })
        vc.addTextField{ _ in }
        vc.addTextField()
        
        vc.addAction(action)
        present(vc,animated:true)
        
}

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchVC?.sections else{
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as! TableViewCell
        
    
        cell.labelName.text = fetchVC.object(at: indexPath).name
        cell.labelSurName.text =  fetchVC.object(at: indexPath).surName
        cell.labelBirthday.text = String(describing: fetchVC.object(at: indexPath).birthday)
     
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            userObject.deleteUser(fetchVC.object(at: indexPath))
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type{
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
          
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .delete :
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        default : break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}

