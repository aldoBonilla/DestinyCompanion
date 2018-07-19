//
//  ItemsCollectionViewController.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 13/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit

protocol ItemsCVCDelegate {
    func showDetailOf(item: ItemUI)
}


private let reuseIdentifier = "itemCell"

class ItemsCollectionViewController: UICollectionViewController {

    var characterSelected: Character!
    var displayData = [(name: String, sectionItems: [ItemUI])]()
    var delegate: ItemsCVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = characterSelected.emblemColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func reloadInventorieWithDisplayData(displayData: [(name: String, sectionItems: [ItemUI])]) {
        self.displayData = displayData
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
        return thisSection.sectionItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! ItemCollectionHeader
        header.lblTitle.text = displayData[indexPath.section].name
        return header
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemCollectionViewCell
    
        let thisSection = displayData[indexPath.section]
        let thisItem = thisSection.sectionItems[indexPath.row]
        cell.setupWith(item: thisItem)
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let thisSection = displayData[indexPath.section]
        let thisItem = thisSection.sectionItems[indexPath.row]
        delegate?.showDetailOf(item: thisItem)
    }
}
