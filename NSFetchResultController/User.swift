//
//  User.swift
//  NSFetchResultController
//
//  Created by Даша Волошина on 6.12.22.
//
 
import CoreData

class UserCoreData {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NSFetchResultController")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
   
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createUser(name: String, surName:String) {
        let user = User(context: persistentContainer.viewContext)
        user.name = name
        user.birthday = Date()
        user.surName = surName
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("viewContext didn't save")
        }
    }
    
    
    func readUser() -> [User]{
        let fetchRequest = User.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        }catch {
            persistentContainer.viewContext.rollback()
            print("view context didn't read")
        }
        return []
    }
    
    func updateUser(){
        do {
            try persistentContainer.viewContext.save()
            
        }catch{
            persistentContainer.viewContext.rollback()
            print("view context didn't update ")
        }
        
    }
    func deleteUser(_ user:User) {
        
        persistentContainer.viewContext.delete(user)
        
        do {
            try persistentContainer.viewContext.save()
            
        }catch{
            
            persistentContainer.viewContext.rollback()
            print("view context didn't update ")
        }
    }
    
//    func getUser(numbers:Int = 10)  -> [User] {
//
//        let fetchRequest = User.fetchRequest()
//        fetchRequest.fetchLimit = numbers
//        fetchRequest.fetchOffset = 0
//        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \User.name, ascending: true)]
//        return  try! persistentContainer.viewContext.fetch(fetchRequest)
//    }
    
  
//    func getSelected() -> [User] {
//        
//        let predicate = NSPredicate(format: "%K == YES", #keyPath(User.name))
//        let fetchRequest = User.fetchRequest()
//        fetchRequest.predicate  = predicate
//        return  try! persistentContainer.viewContext.fetch(fetchRequest)
//    }
    
}
