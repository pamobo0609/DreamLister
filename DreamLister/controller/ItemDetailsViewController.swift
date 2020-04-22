//
//  ItemDetailsViewController.swift
//  DreamLister
//
//  Created by Jose Monge on 4/20/20.
//  Copyright © 2020 Jose Monge. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumbImg: UIImageView!
    
    var itemToEdit: Item?
    private var stores = [Store]()
    private var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        //generateDummyStores()
        fetchStores()
        
        if itemToEdit != nil {
            loadItemData()
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stores[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            thumbImg.image = image
            imagePicker.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func onAddImageClick(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onDeleteItemClick(_ sender: Any) {
        if nil != itemToEdit {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSaveItemClick(_ sender: UIButton) {

        var item: Item!
        let picture = Image(context: context)
        picture.image = thumbImg.image
        
        if nil == itemToEdit {
            item = Item(context: context)
        } else {
            item = itemToEdit
        }
        
        item.toImage = picture
        
        if let title = titleField.text {
            item.title = title
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        
        if let description = detailsField.text {
            item.details = description
        }
        
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        
        ad.saveContext()
        navigationController?.popViewController(animated: true)
        
    }
    
    private func loadItemData() {
        if let item = itemToEdit {
            thumbImg.image = item.toImage?.image as? UIImage
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: true)
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
            
        }
    }
    
    private func fetchStores() {
        let fetchRequest: NSFetchRequest = Store.fetchRequest()
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            print("\(error)")
        }
    }
    
    private func generateDummyStores() {
        let aStore = Store(context: context)
        aStore.name = "Amazon"
        
        let aStore1 = Store(context: context)
        aStore1.name = "eBay"
        
        let aStore2 = Store(context: context)
        aStore2.name = "BestBuy"
        
        let aStore3 = Store(context: context)
        aStore3.name = "Fry's Electronics"
        
        let aStore4 = Store(context: context)
        aStore4.name = "Target"
        
        let aStore5 = Store(context: context)
        aStore5.name = "Kwik-E-Mart"
        
        ad.saveContext()
        
    }
    
}
