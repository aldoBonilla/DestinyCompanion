//
//  CharacterInventoryViewController.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 09/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit

class CharacterInventoryViewController: UIViewController {
    
    var character: Character!

    override func viewDidLoad() {
        super.viewDidLoad()
        getFullItemsDescription()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getFullItemsDescription() {
        
        if character.hasRetrievedAllHisItems == false {
            ItemWorker.getFullItems(character) { error in
                print(error)
            }
        } else {
            print("character has all his items already")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
