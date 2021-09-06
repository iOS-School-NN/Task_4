//
//  MainViewModel.swift
//  Task_3
//
//  Created by KirRealDev on 16.07.2021.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
    func updateTableViewBy(item: [Result])
}

private struct MainViewModelConstants {
    static let countOfPagesToDownload = 3
    static let countOfCharactersOnPage = 20
}

final class MainViewModel {
    weak var delegate: MainViewModelDelegate?
    private var baseURL: String = ""
    private var pageId: Int = 1
    private var additionalPagesArray = [Result]()
    
    init() {
        self.baseURL = NetworkConstants.urlForLoadingListOfCharacters
    }
    
    func loadInformation() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadTheFirstSetOfInformation(urlString: NetworkConstants.urlForLoadingListOfCharacters, id: self.pageId)
        }
    }
    
    func loadTheFirstSetOfInformation(urlString: String, id: Int) {
        NetworkService.performGetRequestForLoadingPages(url: urlString, pageId: id,
            onComplete: { [weak self] (data, id) in
                self?.delegate?.updateTableViewBy(item: data.results)
                self?.asyncDownloadCharactersInfoByPage(count: data.info.pages, with: MainViewModelConstants.countOfPagesToDownload)
            },
            onError: { (error, id) in NSLog(error.localizedDescription, id)
            }
        )
    }
    
    func asyncDownloadCharactersInfoByPage(count: Int, with pageSize: Int) {
        let queue = DispatchQueue(label: "com.task_3.semaphore", attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: pageSize)
    
        for i in 2...count {
            queue.async {
                semaphore.wait()
                self.pageId = i
                NetworkService.performGetRequestForLoadingPages(url: NetworkConstants.urlForLoadingListOfCharacters + "?page=\(i)", pageId: self.pageId,
                    onComplete: { [weak self] (data, id) in
                        self?.additionalPagesArray = self!.additionalPagesArray + data.results
                        semaphore.signal()
                        
                        if (i == count) {
                            self?.delegate?.updateTableViewBy(item: (self!.additionalPagesArray.sorted { $0.id < $1.id }))
                        }
                        if (self?.additionalPagesArray.count == MainViewModelConstants.countOfPagesToDownload * MainViewModelConstants.countOfCharactersOnPage) {
                                self!.delegate?.updateTableViewBy(item: (self!.additionalPagesArray.sorted { $0.id < $1.id }))
                                self?.additionalPagesArray.removeAll()
                        }
                    },
                    onError: { (error, id) in
                        NSLog(error.localizedDescription, id)
                        semaphore.signal()
                    }
                )
            }
        }
    }
    
    }
