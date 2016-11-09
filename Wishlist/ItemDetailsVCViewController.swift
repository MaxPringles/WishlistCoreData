//
//  ItemDetailsVCViewController.swift
//  Wishlist
//
//  Created by movil4 on 14/10/16.
//  Copyright © 2016 Telstock. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVCViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtDetails: UITextField!
    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var btnGuardar: UIButton!
    
    var stores = [Store]()
    
    var itemTypes = [ItemType]()
    
    var imagePicker: UIImagePickerController!
    
    var itemToEdit: Item?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
            
            self.navigationController?.navigationBar.tintColor = UIColor.white
        }
        
        imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        storePicker.dataSource = self
        storePicker.delegate = self
        txtTitle.delegate = self
        txtPrice.delegate = self
        txtDetails.delegate = self
        
        /*let store1 = Store(context: context)
        store1.name = "Best buy"
        
        let store2 = Store(context: context)
        store2.name = "Palacio de hierro"
        
        let store3 = Store(context: context)
        store3.name = "Liverpool"
        
        let store4 = Store(context: context)
        store4.name = "Sears"
        
        let store5 = Store(context: context)
        store5.name = "Mixup"
        
        let store6 = Store(context: context)
        store6.name = "Sanborns"
        
        let store7 = Store(context: context)
        store7.name = "Amazon"
        
        appDelegate.saveContext()
        
        let tipo1 = ItemType(context: context)
        tipo1.type = "Electrónica"
        
        let tipo2 = ItemType(context: context)
        tipo2.type = "Automotriz"
        
        let tipo3 = ItemType(context: context)
        tipo3.type = "Libros"
        
        appDelegate.saveContext()*/
        
        getStores()
        
        //getTypes()
        
        if let _ = itemToEdit {
            loadItemData()
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let store = stores[row]
            return store.name
        } else {
            let type = itemTypes[row]
            return type.type
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return stores.count
        }
        return itemTypes.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    @IBAction func guardarItem(_ sender: AnyObject) {
        
        var esValido = true
        var item: Item!
        
        if (txtTitle.text?.isEmpty)! {
            let alert = UIAlertController(title: "Faltan campos", message: "Falta título", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            esValido = false
            return
        }
        
        if (txtPrice.text?.isEmpty)! {
            let alert = UIAlertController(title: "Faltan campos", message: "Falta precio", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            esValido = false
            return
        }
        
        
        if (txtDetails.text?.isEmpty)! {
            let alert = UIAlertController(title: "Faltan campos", message: "Falta detalle", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            esValido = false
            return
        }
        
        if esValido {
            //item = Item(context: context)
            
            let picture = Image(context: context)
            
            picture.image = imgItem.image
            
            if itemToEdit == nil {
                item = Item(context:context)
            } else {
                item = itemToEdit!
            }
            
            if let title = txtTitle.text {
                item.title = title
            }
            
            if let price = txtPrice.text {
                item.price = (price as NSString).doubleValue
            }
            
            if let details = txtDetails.text {
                item.detail = details
            }
            
            item.toImage = picture
            item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
            item.toItemType = itemTypes[storePicker.selectedRow(inComponent: 1)]
            
            appDelegate.saveContext()
            
            _ = navigationController?.popViewController(animated: true)
        }
        
    }

    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        let fetchRequestItemType: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.itemTypes = try context.fetch(fetchRequestItemType)
            
            storePicker.reloadAllComponents()
        } catch {
            let error = error as NSError
            print(error)
        }
    }
    
    func getTypes() {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            self.itemTypes = try context.fetch(fetchRequest)
            storePicker.reloadAllComponents()
        } catch {
            let error = error as NSError
            print(error)
        }
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            txtTitle.text = item.title
            txtPrice.text = "$\(item.price)"
            txtDetails.text = item.detail
            imgItem.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                
                var index = 0
                
                repeat {
                    
                    let s = stores[index]
                    
                    if s.name == store.name {
                        
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                        
                    }
                    
                    index+=1
                    
                } while index < stores.count
            }
            
            if let type = item.toItemType {
                var index1 = 0
                
                repeat {
                    let t = itemTypes[index1]
                    if t.type == type.type {
                        storePicker.selectRow(index1, inComponent: 1, animated: false)
                        break
                    }
                    
                    index1+=1
                } while index1 < itemTypes.count
            }
        }
    }
    
    @IBAction func deletePressed(_ sender: AnyObject) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            appDelegate.saveContext()
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgItem.image = img
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
