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
        var full_name = contactProperty.contact.givenName ?? ""
        let last_name = contactProperty.contact.familyName ?? ""
        if !last_name.isEmpty {
            full_name += " \(last_name)"
        }
        let contact = contactEmail( name: "\(full_name)",
                                    email: (contactProperty.value as! String),
                                    button_tag: email_list.count)
        
        let button   = UIButton( type: .System) as UIButton
        button.tag = contact.button_tag!
        // button.frame = getNextButtonRect()
        button.backgroundColor = UIColor.whiteColor()
        button.setTitle( "\(full_name)❌", forState: UIControlState.Normal)
        button.addTarget(self, action: "RemoveEmail:", forControlEvents: UIControlEvents.TouchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        emailView.addSubview( button)
        
        var x = NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: emailView, attribute: .Leading, multiplier: 1, constant: 0)
        if emailView.subviews.count > 1 {
            x = NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: emailView.subviews[emailView.subviews.count-2], attribute: .Trailing, multiplier: 1, constant: 0)
        }
        let y = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: emailView, attribute: .Top, multiplier: 1, constant: 0)
        emailView.addConstraints([x,y])
        
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
        emailView.removeConstraints( sender.constraints)
        sender.removeFromSuperview()
        relayoutEmailButtons()
        print( "email list:", email_list)
    }
    
    func relayoutEmailButtons( ) {
        // sender isn't in view anymore
        for c in emailView.constraints {
            c.active = false
        }
        for i in 0..<emailView.subviews.count {
            let button = emailView.subviews[i] as! UIButton
            
            var x:NSLayoutConstraint?
            if i>0 { // emailView.subviews.count > 1 {
                x = NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: emailView.subviews[i-1], attribute: .Trailing, multiplier: 1, constant: 0)
            } else {
                x = NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: emailView, attribute: .Leading, multiplier: 1, constant: 0)
            }
            let y = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: emailView, attribute: .Top, multiplier: 1, constant: 0)
            
            emailView.addConstraints([x!,y])
            
        }
        emailView.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

