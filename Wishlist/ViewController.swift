//
//  ViewController.swift
//  Wishlist
//
//  Created by Vanessa on 13/10/16.
//  Copyright © 2016 Telstock. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tblProductos: UITableView!
    var controller: NSFetchedResultsController<Item>!
    
    @IBOutlet weak var segmented: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tblProductos.delegate = self
        tblProductos.dataSource = self
        
        //generateTestData()
        attemptFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func attemptFetch() {
        let fetchRequest: NSFetchRequest = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        if segmented.selectedSegmentIndex == 0{
            fetchRequest.sortDescriptors = [dateSort]
        } else if segmented.selectedSegmentIndex == 1 {
            fetchRequest.sortDescriptors = [priceSort]
        } else if segmented.selectedSegmentIndex == 2 {
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        
        self.controller = controller
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print(error.debugDescription)
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblProductos.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tblProductos.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case.insert:
            if let indexPath = newIndexPath {
                tblProductos.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.delete:
            if let indexPath = indexPath {
                tblProductos.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case.move:
            if let indexPath = indexPath {
                tblProductos.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tblProductos.insertRows(at: [indexPath], with: .fade)
            }
            break
        case.update:
            if let indexPath = indexPath {
                let cell = tblProductos.cellForRow(at: indexPath) as! ProductoCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductoCell") as! ProductoCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects, objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "toItemDetail", sender: item)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toItemDetail" {
            if let destination = segue.destination as? ItemDetailsVCViewController {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func configureCell(cell: ProductoCell, indexPath: NSIndexPath) {
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }
    
    func generateTestData() {
        let item1 = Item(context: context)
        item1.title = "MacBook Pro"
        item1.price = 25000
        item1.detail = "Quiero una"
        
        let item2 = Item(context: context)
        item2.title = "PS4"
        item2.price = 7000
        item2.detail = "Pro"
        
        let item3 = Item(context: context)
        item3.title = "Xbox One"
        item3.price = 7500
        item3.detail = "Slim"
        
        let item4 = Item(context: context)
        item4.title = "Wii U"
        item4.price = 6000
        item4.detail = "Incluye Mario Kart"
        
        let item5 = Item(context: context)
        item5.title = "Nintendo 3DS"
        item5.price = 3500
        item5.detail = "Incluye Pokemon Sun"
        
        //Se guardan los datos en CoreData
        appDelegate.saveContext()
    }
   

    @IBAction func segmentChanged(_ sender: AnyObject) {
        attemptFetch()
        tblProductos.reloadData()
    }
    
}

