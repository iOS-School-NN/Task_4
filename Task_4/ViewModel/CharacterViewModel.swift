//
//  CharacterViewModel.swift
//  draft
//
//  Created by R S on 01.08.2021.
//

import Combine

class CharacterViewModel: ObservableObject {
    @Published private(set) var state = State()
    private var subscriptions = Set<AnyCancellable>()
    
    func fetchCharacter(characterId: Int) {
        API.fetchCharacter(characterId: characterId)
            .sink(receiveCompletion: onReceive,
                  receiveValue: onReceiveCharacter)
            .store(in: &subscriptions)
    }
    
    func fetchCharacterLocation(urlString: String) {
        API.fetchCharacterLocation(urlString: urlString)
            .sink(receiveCompletion: onReceive,
                  receiveValue: onReceiveCharacterLocation)
            .store(in: &subscriptions)
    }
    
    func fetchCharacterEpisodes(urlString: String) {
//        print(urlString)
        API.fetchCharacterEpisodes(urlString: urlString)
            .sink(receiveCompletion: onReceive,
                  receiveValue: onReceiveCharacterEpisode)
            .store(in: &subscriptions)
    }
    
    func fetchNextPageIfPossible() {
        API.fetchCharacters(query: "swift", page: state.page)
            .sink(receiveCompletion: onReceive,
                  receiveValue: onReceive)
            .store(in: &subscriptions)
    }
    
    private func onReceive(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure:
            break
        }
    }
    
    private func onReceiveCharacter(_ batch: Character) {
        state.characters[batch.id] = batch
    }
    
    private func onReceiveCharacterLocation(_ batch: LocationType) {
        state.locationTypes[batch.name] = batch
    }
    
    private func onReceiveCharacterEpisode(_ batch: Episode) {
        state.episodes[batch.url] = batch
//        print(state.episodes)
    }
    
    private func onReceive(_ batch: [Character]) {
        state.data += batch
        state.page += 1
    }
    
    struct State {
        var data: [Character] = []
        var characters: [Int: Character] = [:]
        var locationTypes: [String: LocationType] = [:]
        var episodes: [String: Episode] = [:]
        var page: Int = 1
    }
}
