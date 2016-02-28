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
        // button.frame = getNextButtonRect()
        button.backgroundColor = UIColor.whiteColor()
        button.setTitle( "\(contact.name!)❌", forState: UIControlState.Normal)
        button.addTarget(self, action: "RemoveEmail:", forControlEvents: UIControlEvents.TouchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        emailView.addSubview( button)
        
        /*
        NSLayoutConstraint.activateConstraints([
            button.leadingAnchor.constraintEqualToAnchor(emailView.leadingAnchor),
            button.topAnchor.constraintEqualToAnchor(emailView.topAnchor),
            button.widthAnchor.constraintEqualToConstant(100),
            button.heightAnchor.constraintEqualToConstant( emailView.bounds.size.height)
        ])
*/
            /*
            button.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 30),
            button.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 390),
            button.widthAnchor.constraintEqualToConstant( 75),
            button.heightAnchor.constraintEqualToConstant(75)
*/
        // button.addConstraints(cons)
        /*
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let previous_button :NSLayoutAnchor?
        if emailView.subviews.count > 0 {
            previous_button =
        }
        NSLayoutConstraint.activateConstraints([
            button.leadingAnchor.constraintEqualToAnchor(previous_button),
            
            button.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor, constant: 30),
            button.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: 390),
            button.widthAnchor.constraintEqualToConstant( 75),
            button.heightAnchor.constraintEqualToConstant(75)
            ])
        */
        /*
        var x:NSLayoutConstraint?
        if emailView.subviews.count > 0 {
            x = NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: emailView.subviews.last, attribute: .TrailingMargin, multiplier: 1, constant: 0)
        } else {
            x = NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: emailView, attribute: .LeadingMargin, multiplier: 1, constant: 0)
        }
*/
        
        var x = NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: emailView, attribute: .Leading, multiplier: 1, constant: 0)
        if emailView.subviews.count > 1 {
            x = NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: emailView.subviews[emailView.subviews.count-2], attribute: .Trailing, multiplier: 1, constant: 0)
        }
        let y = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: emailView, attribute: .Top, multiplier: 1, constant: 0)
        // button.addConstraints([x,y])
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
        sender.removeFromSuperview()
        relayoutEmailButtons()
        print( "email list:", email_list)
    }
    
    func relayoutEmailButtons() {
        /*
        for(NSLayoutConstraint *constraint in self.view.constraints)
        {
            if(constraint.firstAttribute == NSLayoutAttributeBottom && constraint.secondAttribute == NSLayoutAttributeBottom &&
                constraint.firstItem == self.view && constraint.secondItem == self.scrollView)
            {
                constraint.constant = 0.0;
            }
        }
*/
        
        for c in emailView.constraints {
            c.active = false
        }
        for i in 0..<emailView.subviews.count {
            let button = emailView.subviews[i] as! UIButton
            
            var x = NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: emailView, attribute: .Leading, multiplier: 1, constant: 0)
            if emailView.subviews.count > 1 {
                x = NSLayoutConstraint(item: button, attribute: .Leading, relatedBy: .Equal, toItem: emailView.subviews[emailView.subviews.count-2], attribute: .Trailing, multiplier: 1, constant: 0)
            }
            let y = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: emailView, attribute: .Top, multiplier: 1, constant: 0)
            
            emailView.addConstraints([x,y])
            
        }
        emailView.layoutIfNeeded()
        // emailView.layoutSubviews()
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

