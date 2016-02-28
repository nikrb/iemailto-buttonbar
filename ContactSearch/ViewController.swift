//
//  ViewController.swift
//  ContactSearch
//
//  Created by Nick Scott on 27/02/2016.
//  Copyright © 2016 Nick Scott. All rights reserved.
//

import Foundation
import UIKit
import Contacts
import ContactsUI

class ViewController: UIViewController, CNContactPickerDelegate, CNContactViewControllerDelegate  {

    @IBAction func emailToButton(sender: UIButton) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys = [ CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey]
        let pred = NSPredicate( format: "emailAddresses.@count > 0")
        contactPicker.predicateForEnablingContact = pred
        self.presentViewController(contactPicker, animated: true, completion: nil)
    }
    
    func contactPickerDidCancel(picker: CNContactPickerViewController) {
        print( "@contact picker cancelled")
    }
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        print( "selected property:", contactProperty)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepare for segue [\(segue.identifier)]")
    }
}

