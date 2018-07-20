//
//  ItemDetailTableViewController.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit

class ItemDetailTableViewController: UITableViewController {

    var itemSelected: ItemUI!
    var perks = [PerkUI]()
    var stats = [StatUI]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getItemDetailInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getItemDetailInfo() {
        
        self.view.lock()
        
        guard let instanceId = itemSelected.inventory.instance else {
            return
        }
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        ItemWorker.getPerksUIFor(instanceId) { perks in
            self.perks = perks
            dispatchGroup.leave()
        }
        
        if let groupHash = itemSelected.manifest.statsGroupHash {
            dispatchGroup.enter()
            StatsWorker.getDetailStats(instanceId, group: groupHash) { stats in
                self.stats = stats
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.view.unlock()
            self.tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 1
        case 1: return self.stats.count
        case 2: return self.perks.count
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        switch indexPath.section {
        case 0:
            cell = setupInfoCell(tableView, cellForRowAt: indexPath)
        case 1:
            let thisStat = stats[indexPath.row]
            if thisStat.isNumeric == false {
                cell = setupStatBarCell(tableView, cellForRowAt: indexPath, stat: thisStat)
            } else {
                cell = setupStatCell(tableView, cellForRowAt: indexPath, stat: thisStat)
            }
        case 2:
            let thisPerk = perks[indexPath.row]
            cell = setupPerkCell(tableView, cellForRowAt: indexPath, perk: thisPerk)
        default:
            print("Why are you here!")
        }

        return cell
    }

    func setupInfoCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ItemInfoTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemInfo", for: indexPath) as! ItemInfoTableViewCell
        cell.setupWith(item: itemSelected)
        return cell
    }
    
    func setupStatBarCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, stat: StatUI) -> ItemStatBarTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemStatBar", for: indexPath) as! ItemStatBarTableViewCell
        cell.setupWith(stat: stat)
        return cell
    }
    
    func setupStatCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, stat: StatUI) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemStat", for: indexPath)
        cell.textLabel?.text = stat.name
        cell.detailTextLabel?.text = "\(stat.value)"
        return cell
    }
    
    func setupPerkCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, perk: PerkUI) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemPerk", for: indexPath)
        cell.textLabel?.text = perk.name
        cell.detailTextLabel?.text = perk.about
        cell.imageView?.kf.setImage(with: perk.perkIcon)
        return cell
    }
}
