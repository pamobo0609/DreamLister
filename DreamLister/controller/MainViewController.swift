//
//  MainViewController.swift
//  DreamLister
//
//  Created by Jose Monge on 4/20/20.
//  Copyright © 2020 Jose Monge. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    private var controller: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // generateTestData()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        attemptFetch()
        
    }
    
    @IBAction func onSortChange(_ sender: UISegmentedControl) {
        attemptFetch()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfSections = 0
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            numberOfSections = sectionInfo.numberOfObjects
        }
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        bind(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func bind(cell: ItemCell, indexPath: NSIndexPath) {
        cell.bind(item: controller.object(at: indexPath as IndexPath))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 0
        if let sections = controller.sections {
            numberOfSections = sections.count
        }
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects, objs.count > 0 {
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsViewController", sender: item)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
            
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
            
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                bind(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
            
        @unknown default:
            break
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsViewController" {
            if let destination = segue.destination as? ItemDetailsViewController {
                if let item = sender as? Item {
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    private func attemptFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        switch segment.selectedSegmentIndex {
        case 0:
            fetchRequest.sortDescriptors = [dateSort]
            break
            
        case 1:
            fetchRequest.sortDescriptors = [priceSort]
            break
            
        case 2:
            fetchRequest.sortDescriptors = [titleSort]
            break
            
        default:
            break
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        
        self.controller = controller
        self.controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
        
    }
    
    private func generateTestData() {
        let item = Item(context: context)
        item.title = "David Bowie - Hunky Dory"
        item.price = 35
        item.details = "Great album."
        
        let item2 = Item(context: context)
        item2.title = "Turntable"
        item2.price = 200
        item2.details = "For my LP disks. Nice to have."
        
        let item3 = Item(context: context)
        item3.title = "Ibanez acoustic guitar"
        item3.price = 500
        item3.details = "I don't own an acoustic guitar so, why not?"
        
        ad.saveContext()

    }

}

