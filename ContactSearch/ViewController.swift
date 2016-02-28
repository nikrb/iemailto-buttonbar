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

    var email_list = [contactEmail]()
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailToButton: UIButton!
    
    struct contactEmail {
        var name:String?
        var email:String?
        var button_tag:Int?
    }
    
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
        let contact = contactEmail( name: "\(contactProperty.contact.givenName) \(contactProperty.contact.familyName)",
                                    email: (contactProperty.value as! String),
                                    button_tag: email_list.count)
        print( "contact:", contact)
        
        let button   = UIButton( type: .System) as UIButton
        button.tag = contact.button_tag!
        button.frame = getNextButtonRect()
        // button.backgroundColor = UIColor.greenColor()
        button.setTitle( "\(contact.name!)❌", forState: UIControlState.Normal)
        button.addTarget(self, action: "RemoveEmail:", forControlEvents: UIControlEvents.TouchUpInside)
        emailView!.addSubview( button)
        
        email_list.append( contact)
    }
    func RemoveEmail( sender: UIButton!){
        print( "remove email")
        var found_ndx = -1
        for i in 0..<email_list.count {
            if email_list[i].button_tag == sender.tag {
                found_ndx = i
                break
            }
        }
        if found_ndx >= 0 {
            email_list.removeAtIndex(found_ndx)
        }
        sender.removeFromSuperview()
        relayoutEmailButtons()
        print( "email list:", email_list)
    }
    func getNextButtonRect() -> CGRect {
        let n = emailView.subviews.count
        let spacing = 5
        let height = emailToButton.bounds.height - CGFloat( spacing*2)
        let width = 100
        
        return CGRectMake( CGFloat( n * (width + spacing) + spacing), CGFloat( spacing), CGFloat( width), height)
    }
    func relayoutEmailButtons() {
        // FIXME: this doens't work
        for i in 0..<emailView.subviews.count {
            let button = emailView.subviews[i] as! UIButton
            button.frame = getNextButtonRect()
        }
        emailView.layoutSubviews()
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

