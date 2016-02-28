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
    
    @IBOutlet weak var emailScrollView: UIScrollView!
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
        button.backgroundColor = UIColor.whiteColor()
        button.setTitle( "\(full_name)❌", forState: UIControlState.Normal)
        button.addTarget(self, action: "RemoveEmail:", forControlEvents: UIControlEvents.TouchUpInside)
        
        emailScrollView.addSubview( button)
        relayoutEmailButtons()
        
        email_list.append( contact)
    }
    
    func RemoveEmail( sender: UIButton!){
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
        emailScrollView.removeConstraints( sender.constraints)
        sender.removeFromSuperview()
        relayoutEmailButtons()
        recalculateEmailScrollViewContentSize()
    }
    
    func relayoutEmailButtons( ) {
        // scroll view has subviews we don't want
        var next_button_x = 0
        for i in 0..<emailScrollView.subviews.count {
            if let button = emailScrollView.subviews[i] as? UIButton {
                let bw = Int( (button.titleLabel?.intrinsicContentSize().width)!)
                button.frame = CGRect(x: next_button_x, y: 0, width: bw, height: Int( emailToButton.bounds.width))
                next_button_x += bw
            }
        }
    }
    
    func recalculateEmailScrollViewContentSize(){
        var scroll_width = emailScrollView.bounds.width
        var new_scroll_width:CGFloat = 0
        for v in emailScrollView.subviews {
            if let b = v as? UIButton {
                new_scroll_width += b.bounds.width
            }
        }
        if new_scroll_width > scroll_width {
            scroll_width = new_scroll_width
        }
        emailScrollView.contentSize = CGSize(width: scroll_width, height: emailScrollView.bounds.height)
    }
    
    override func viewDidLayoutSubviews() {
        recalculateEmailScrollViewContentSize()
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

