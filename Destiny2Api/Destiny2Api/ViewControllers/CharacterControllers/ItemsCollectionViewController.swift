//
//  ItemsCollectionViewController.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 13/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit

private let reuseIdentifier = "itemCell"

class ItemsCollectionViewController: UICollectionViewController {

    var characterSelected: Character!
    var currentCategory: ItemUICategory!
    var displayData = [(name: String, sectionItems: [Item]?)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentCategory = .weapon
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func reloadInventorieFor(character: Character) {
        self.characterSelected = character
        self.displayData = ItemWorker.orderBucketsFor(character: characterSelected, category: currentCategory)
        collectionView?.backgroundColor = character.emblemColor
        self.collectionView?.reloadData()
    }

    public func reloadInventorieFor(category: ItemUICategory) {
        self.currentCategory = category
        self.displayData = ItemWorker.orderBucketsFor(character: characterSelected, category: currentCategory)
        self.collectionView?.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.displayData.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let thisSection = displayData[section]
        return thisSection.sectionItems?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! ItemCollectionHeader
        header.lblTitle.text = displayData[indexPath.section].name
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemCollectionViewCell
    
        let thisSection = displayData[indexPath.section]
        if let thisItem = thisSection.sectionItems?[indexPath.row] {
            cell.setupWith(item: thisItem)
        }
        
        return cell
    }

}
