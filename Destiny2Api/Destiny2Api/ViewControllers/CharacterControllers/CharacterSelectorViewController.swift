//
//  CharacterSelectorViewController.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 13/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit
import Kingfisher

protocol CharacterSelectorDelegate {
    
    func changedTo(character: Character)
}

class CharacterSelectorViewController: UIViewController {

    @IBOutlet weak var scrollCharacters: UIScrollView!
    
    private var leftSwipe: UISwipeGestureRecognizer?
    private var rightSwipe: UISwipeGestureRecognizer?
    var characters = [Character]()
    var currentCharacter: (character: Character, index: Int)?
    var delegate: CharacterSelectorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe!.direction = .left
        rightSwipe!.direction = .right
        
        if characters.count == 1 {
            leftSwipe?.isEnabled = false
            rightSwipe?.isEnabled = false
        } else {
            if currentCharacter!.index == 0 {
                rightSwipe!.isEnabled = false
            } else if currentCharacter!.index == characters.count - 1 {
                leftSwipe!.isEnabled = false
            }
        }
        
        view.addGestureRecognizer(leftSwipe!)
        view.addGestureRecognizer(rightSwipe!)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCharacterSelector()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupCharacterSelector() {
        
        for (index, character) in characters.enumerated() {
            
            let mainCharacterViewX: CGFloat = CGFloat(index) * self.scrollCharacters.frame.width
            
            let characterView = UIView(frame: CGRect(x: mainCharacterViewX, y: 0, width: self.scrollCharacters.frame.width, height: self.scrollCharacters.frame.height))
            
            let imageBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: characterView.frame.width, height: characterView.frame.height))
            imageBackground.contentMode = .scaleToFill
            let blurView = UIVisualEffectView(frame: imageBackground.frame)
            blurView.effect = UIBlurEffect(style: .light)
            let bannerImage = UIImageView(frame: CGRect(x: 0, y: 0, width: characterView.frame.width, height: characterView.frame.height))
            bannerImage.contentMode = .scaleAspectFit
            
            if let urlBanner = character.urlBannerBackground {
                imageBackground.kf.setImage(with: urlBanner)
                bannerImage.kf.setImage(with: urlBanner)
            }
            
            characterView.addSubview(imageBackground)
            characterView.addSubview(blurView)
            characterView.addSubview(bannerImage)
            
            self.scrollCharacters.addSubview(characterView)
        }
        
        scrollCharacters.contentSize = CGSize(width: scrollCharacters.frame.width * CGFloat(characters.count), height: scrollCharacters.frame.height)
        showCharacterSeleceted(animated: false)
    }
    
    @objc func handleSwipes(_ sender: UISwipeGestureRecognizer) {
        
        var currentIndex = currentCharacter!.index
        if (sender.direction == .left) {
            currentIndex += 1
            rightSwipe?.isEnabled = true
            if currentIndex == characters.count - 1 {
                leftSwipe?.isEnabled = false
            }
            
        } else if (sender.direction == .right) {
            currentIndex -= 1
            leftSwipe?.isEnabled = true
            if currentIndex == 0 {
                rightSwipe?.isEnabled = false
            }
        }
        
        currentCharacter = (character: characters[currentIndex], index: currentIndex)
        showCharacterSeleceted(animated: true)
        delegate?.changedTo(character: currentCharacter!.character)
    }
    
    func showCharacterSeleceted(animated: Bool) {
        scrollCharacters.setContentOffset( CGPoint(x:CGFloat(currentCharacter!.index) * (scrollCharacters.frame.width) , y: 0), animated: animated)
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
