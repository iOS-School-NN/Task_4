//
//  DetailViewController.swift
//  RickAndMortyApp
//
//  Created by Grifus on 13.07.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var characterImage: UIImageView!
    
    @IBOutlet weak var characterName: UILabel!
    
    @IBOutlet weak var characterGender: UILabel!
    
    @IBOutlet weak var characterStatus: UILabel!
    
    @IBOutlet weak var characterSpecies: UILabel!
    
    ///Location
    
    @IBOutlet weak var locationTitle: UILabel!
    
    @IBOutlet weak var locationName: UILabel!
    
    @IBOutlet weak var locationType: UILabel!
    
    ///Episodes
    
    @IBOutlet weak var episodes: UITextView!
    
    var detailData: CharacterDetailModel? {
        didSet {
            switch status {
            case .downloading:
                guard let detailData = detailData else { return }
                dataSourse.downloadByGroups(data: detailData)
            case .downloaded:
                return
            case .none:
                return
            }
        }
    }
    
    var id = 1
    var imageData: Data?
    var locationData: LocationStruct?
    var episodesFromNetwork = [Episode]()
    var databaseLogic: DatabaseBussinessModel!
    
    enum statusCases {
        case downloading
        case downloaded
    }
    
    var status: statusCases?
    var buttonStatus: statusCases! {
        didSet {
            switch buttonStatus {
            case .downloading:
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(download))
                navigationItem.rightBarButtonItem?.isEnabled = false
            case .downloaded:
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove", style: .plain, target: self, action: #selector(remove))
            case .none:
                return
            }
        }
    }
    
    var dataSourse = DetailBusinessModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cleanUI()
        dataSourse.delegate = self
        databaseLogic.delegateForDetail = self
        
        switch status {
        case .downloading:
            indicator.startAnimating()
            dataSourse.downloadCharacretDetail(characterIndex: id)
        case .downloaded:
            guard let data = detailData else { return }
            dataSourse.downloadPhoto(data: data)
            setupUI()
        default:
            return
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        characterImage.layer.cornerRadius = characterImage.bounds.height / 2
    }
    
    func cleanUI() {
        let nothing = ""
        characterName.text = nothing
        characterGender.text = nothing
        characterStatus.text = nothing
        characterSpecies.text = nothing
        locationTitle.text = nothing
        locationName.text = nothing
        locationType.text = nothing
        episodes.text = nothing
    }
    
    func setupUI() {
        guard let data = detailData else { return }
        let location = locationData
        characterName.text = data.name
        characterGender.text = data.gender
        characterStatus.text = data.status
        characterSpecies.text = data.species
        
        if imageData != nil {
            characterImage.image = UIImage(data: imageData!)
        }
        
        locationName.text = location?.name
        locationType.text = location?.type
        if locationName.text != nil {locationTitle.text = "Location:"}
        for episode in episodesFromNetwork {
            episodes.text += "Name: \(episode.name), date: \(episode.air_date), episode: \(episode.episode) \n"
        }
        navigationItem.rightBarButtonItem?.isEnabled = true
        indicator.stopAnimating()
    }
    
    @objc func download() {
        if databaseLogic.download(detailData: detailData, episodesFromNetwork: episodesFromNetwork, locationData: locationData) {
            buttonStatus = .downloaded
        } else {
            return
        }
    }
    
    @objc func remove() {
        navigationController?.popToRootViewController(animated: true)
        guard let id = detailData?.id else { return }
        databaseLogic.deleteObject(id: id)
    }
}

extension DetailViewController: DetailBusinessModelDelegate {
    
    func allDataIsReady() {
        setupUI()
    }
    
    func sendPhoto(photo: Data) {
        imageData = photo
    }
    
    func sendLocation(location: LocationStruct) {
        locationData = location
    }
    
    func sendEpisodes(episode: Episode) {
        episodesFromNetwork.append(episode)
    }
    
    func receiveData(characterData: CharacterDetailModel) {
        detailData = characterData
    }
}

extension DetailViewController: DatabaseBussinessModelDetailDelegate {
    func showAlert() {
        
        let alert = UIAlertController(title: "Alert", message: "Чтобы загрузить этого персонажа, необходимо дать разрешение в настройках", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}

