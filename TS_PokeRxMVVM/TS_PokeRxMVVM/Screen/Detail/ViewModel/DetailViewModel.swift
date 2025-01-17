//
//  DetailViewModel.swift
//  TS_PokeRxMVVM
//
//  Created by t2023-m0019 on 1/3/25.
//

import Foundation
import RxSwift
import RxRelay

final class DetailViewModel {
    private let repository: PokeRepositoryProtocol
    private let disposeBag = DisposeBag()
    private let pokemonID: Int
    
    // Outputs
    let pokeDetail = PublishRelay<PokeDetail?>()
    
    init(repository: PokeRepositoryProtocol, pokemonID: Int) {
        self.repository = repository
        self.pokemonID = pokemonID
    }
    
    func loadPokeDetail() {
        // 네트워크 상태 확인
        guard NetworkMonitor.shared.isNetworkAvailable() else {
            // 네트워크가 없으면 에러처리
            self.pokeDetail.accept(nil)
            return
        }
        
        repository.fetchPokeDetail(id: pokemonID)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] detail in
                print("Fetched Detail: \(detail)") // 데이터 출력
                self?.pokeDetail.accept(detail)
            }, onFailure: { error in
                print("Error loading poke detail: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}
