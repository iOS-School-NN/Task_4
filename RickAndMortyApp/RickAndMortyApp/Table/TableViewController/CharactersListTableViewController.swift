//
//  CharactersListTableViewController.swift
//  RickAndMortyApp
//
//  Created by Grifus on 10.07.2021.
//

import UIKit
import CoreData

class CharactersListTableViewController: UITableViewController {
    
    enum StatusCases {
        case downloading
        case downloaded
    }
    
    var status: StatusCases {
        if navigationController?.tabBarItem.title == "Characters" {
            return .downloading
        } else if navigationController?.tabBarItem.title == "Downloaded" {
            return .downloaded
        }
        return .downloading
    }
    
    let dataSourse = CharacterCardBusinessModel()
    let lock = NSLock()
    let databaseLogic = DatabaseBussinessModel()
    
    var charactersArr = [Character]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var characterImages = [Int: Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch status {
        case .downloading:
            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
            dataSourse.delegate = self
            dataSourse.download()
        case .downloaded:
            databaseLogic.delegateForTable = self
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch status {
        case .downloading:
            lock.lock()
            let characterDetail = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
            characterDetail.status = .downloading
            characterDetail.databaseLogic = databaseLogic
            if databaseLogic.isInCoreData(characterFilterId: String(indexPath.row + 1)) {
                characterDetail.buttonStatus = .downloaded
            } else {
                characterDetail.buttonStatus = .downloading
            }
            
            characterDetail.title = charactersArr[0].results[indexPath.row].name
            characterDetail.id = charactersArr[0].results[indexPath.row].id
            navigationController?.pushViewController(characterDetail, animated: true)
            lock.unlock()
        case .downloaded:
            let characterDetail = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
            characterDetail.databaseLogic = databaseLogic
            characterDetail.status = .downloaded
            characterDetail.buttonStatus = .downloaded
            characterDetail.detailData = databaseLogic.detailDataForTableFromDataBase(indexPath: indexPath)
            characterDetail.episodesFromNetwork = databaseLogic.episodeDataForTableFromDataBase(indexPath: indexPath)
            characterDetail.locationData = databaseLogic.locationDataForTableFromDataBase(indexPath: indexPath)
            navigationController?.pushViewController(characterDetail, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch status {
        case .downloading:
            if charactersArr.count == 0 {return 0}
            return charactersArr[0].results.count
        case .downloaded:
            return databaseLogic.numberOfRows(section: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterTableViewCell
        
        switch status {
        case .downloading:
            if charactersArr.count == 0 { return cell }
            lock.lock()
            cell.setupName(string: charactersArr[0].results[indexPath.row].name)
            cell.id = charactersArr[0].results[indexPath.row].id
            lock.unlock()
            cell.characterImage.image = nil
            lock.lock()
            dataSourse.downloadPhotos(indexPath: indexPath, id: cell.id ?? 0, photoString: charactersArr[0].results[indexPath.row].image)
            lock.unlock()
            lock.lock()
            cell.setupImage(imageData: self.characterImages[cell.id ?? 0])
            lock.unlock()
            return cell
        case .downloaded:
            cell.setupName(string: databaseLogic.setupNameForCell(indexPath: indexPath))
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as? CharacterTableViewCell
        switch status {
        case .downloading:
            lock.lock()
            if characterImages[cell?.id ?? 0] != nil {
                lock.unlock()
                return }
            lock.unlock()
            dataSourse.cancelDownloadPhoto(id: cell?.id ?? 0)
        case .downloaded:
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if status == .downloading {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch status {
        case .downloading:
            return
        case .downloaded:
            if editingStyle == .delete {
                databaseLogic.deleteObject(indexPath: indexPath)
            }
        }
    }
}
// MARK: - Business logic

extension CharactersListTableViewController: CharacterCardBusinessModelDelegate {
    
    func receivePhoto(indexPath: IndexPath, id: Int, photoData: Data) {
        lock.lock()
        characterImages[id] = photoData
        lock.unlock()
        DispatchQueue.main.async {
            guard let cell = self.tableView.cellForRow(at: indexPath) as? CharacterTableViewCell else { return }
            self.lock.lock()
            cell.setupImage(imageData: self.characterImages[id])
            self.lock.unlock()
        }
    }
    
    func createCharacterArray(characterArray: Character) {
        charactersArr.append(characterArray)
    }
    
    func updateCharacterArray(character: [Result]) {
        charactersArr[0].results.append(contentsOf: character)
    }
    
    func sortArray() {
        DispatchQueue.global().async {
            self.lock.lock()
            if self.charactersArr.isEmpty { return }
            self.charactersArr[0].results.sort { (one, two) -> Bool in
                one.id < two.id
            }
            self.lock.unlock()
        }
    }
}

extension CharactersListTableViewController: DatabaseBussinessModelTableDelegate {
    func reloadTable() {
        tableView.reloadData()
    }
}

