//
//  ViewController.swift
//  DynamicIslandProject
//
//  Created by Anas Sharif on 06/10/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var linkTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.linkTextField.text = "5"
    }

    @IBAction func actionDynamisList(_ sender: UIButton) {
        if let text = linkTextField.text, let links = Int(text) {
            
            var list: [String] = []
            for index in 1...links {
                list.append("Title \(index)")
            }
            let dynamicView = DynamicIslandView(items: list)
            self.view.addSubview(dynamicView)
            dynamicView.show()
        }
        self.linkTextField.endEditing(true)
    }
    
    @IBAction func actionDynamicIslandBtn(_ sender: UIButton) {
        let dynamicView = DynamicIslandView(items: ["Shake To Undo"])
        self.view.addSubview(dynamicView)
        dynamicView.show()
    }
}

