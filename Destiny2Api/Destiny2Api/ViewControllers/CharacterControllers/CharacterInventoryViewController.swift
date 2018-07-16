//
//  CharacterInventoryViewController.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 09/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit

class CharacterInventoryViewController: UIViewController {
    
    @IBOutlet weak var vContainerCategory: UIView!
    @IBOutlet weak var categorySControl: UISegmentedControl!
    
    var characters: [Character]!
    var characterSelected: Character!
    var itemCVC: ItemsCollectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCharacterData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadCharacterData() {
        self.title = characterSelected.classType.name
        self.navigationController?.navigationBar.tintColor = characterSelected.emblemColor ?? .white
        self.vContainerCategory.backgroundColor = characterSelected.emblemColor
        getFullItemsDescription()
    }
    
    private func getFullItemsDescription() {
        
        ItemWorker.getCharacterFullItemDescriptions(self.characterSelected) {
            DispatchQueue.main.async {
                self.itemCVC?.reloadInventorieFor(character: self.characterSelected)
            }
        }
    }
    
    @IBAction func categoryChanged(_ sender: UISegmentedControl) {
        guard let categorySelected = ItemUICategory(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        self.itemCVC?.reloadInventorieFor(category: categorySelected)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let characterSelectorVC = segue.destination as? CharacterSelectorViewController {
            characterSelectorVC.characters = self.characters
            let indexSelected = characters.index(of: characterSelected) ?? 0
            characterSelectorVC.currentCharacter = (character: characterSelected, index: indexSelected)
            characterSelectorVC.delegate = self
        }
        
        if let characterItemCVC = segue.destination as? ItemsCollectionViewController {
            self.itemCVC = characterItemCVC
            self.itemCVC?.characterSelected = characterSelected
        }
    }
}

extension CharacterInventoryViewController: CharacterSelectorDelegate {
    
    func changedTo(character: Character) {
        self.characterSelected = character
        loadCharacterData()
    }
}
