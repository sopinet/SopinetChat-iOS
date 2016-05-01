//
//  SChatViewController.swift
//  Pods
//
//  Created by David Moreno Lora on 28/4/16.
//
//

import UIKit
import Foundation

public class SChatViewController: UIViewController, SChatInputToolbarDelegate {
    
    // MARK: Outlets
    
    @IBOutlet public var schatview: UIView!
    @IBOutlet weak public var sChatCollectionView: UICollectionView!
    @IBOutlet weak public var schatInputToolbar: SChatInputToolbar!
    
    // MARK: Class methods
    
    public class func nib() -> UINib!
    {
        return UINib.init(nibName:"SChatViewController", bundle: NSBundle(forClass: self))
    }
    
    public class func sChatViewController() -> SChatViewController {
        return SChatViewController.init(nibName: "SChatViewController", bundle: NSBundle(forClass: self))
    }
    
    // MARK: Life-Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        SChatViewController.nib().instantiateWithOwner(self, options:nil)
    }
    
    // MARK: Helpers
    
    func setDelegates()
    {
        
    }
    
    // MARK: SChatInputToolbarDelegate
    
    func attachButtonTapped(sender: AnyObject) {
        
    }
    
    func sendButtonTapped(sender: AnyObject) {
        
    }
}
