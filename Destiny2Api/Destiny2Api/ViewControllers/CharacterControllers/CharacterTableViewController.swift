//
//  CharacterTableViewController.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 04/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit

class CharacterTableViewController: UITableViewController {

    private var characters = [Character]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.getCharacters()
        self.refreshControl?.addTarget(self, action: #selector(getCharacters), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc private func getCharacters() {
        UserWorker.getUserCharacters() { characters, error in
            
            if characters != nil && error == nil {
                
                self.characters = characters!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
                
            } else {
                DispatchQueue.main.async {
                    showSimpleAlertWithTitle(title: "Error", message: error!.description, viewController: self)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == characters.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "vaultCell", for: indexPath)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as! CharacterTableViewCell
            cell.setup(character: characters[indexPath.row])
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        performSegue(withIdentifier: "CharacterInventory", sender: character)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let characterVC = segue.destination as? CharacterInventoryViewController, let character = sender as? Character else { return }
        characterVC.character = character
        
    }
}
