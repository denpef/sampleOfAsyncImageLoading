//
//  PlacesCatalogViewModelSpec.swift
//  EdaYandexTests
//
//  Created by Денис Ефимов on 24.09.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import Quick
import Nimble
import RxBlocking
import RxTest
import RxSwift
import RxCocoa
import Moya
@testable import EdaYandex

class PlacesCatalogViewModelSpec: QuickSpec {
    
    override func spec() {
        var sut: PlacesCatalogViewModel!
        var scheduler: TestScheduler!
        var disposeBag: DisposeBag!
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: "CatalogResponse", ofType: "json") else {
            fatalError("Invalid path for json file")
        }
        stubJsonPath = path
        
        beforeEach {
            PlacesCatalogProvider = MoyaProvider<PlacesCatalogNetworkService>(
                stubClosure: MoyaProvider.immediatelyStub,
                plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)]
            )
            
            scheduler = TestScheduler(initialClock: 0)
            SharingScheduler.mock(scheduler: scheduler) {
                sut = PlacesCatalogViewModel()
            }
            
            disposeBag = DisposeBag()
        }
        
        afterEach {
            scheduler = nil
            sut = nil
            disposeBag = nil
        }
        
        it("returns two places when created") {
            let observer = scheduler.createObserver([Place].self)
            
            scheduler.scheduleAt(100) {
                sut.outputs.places.asObservable()
                    .subscribe(observer)
                    .disposed(by: disposeBag)
            }
            
            scheduler.scheduleAt(200) {
                sut.inputs.reload.onNext(())
            }
            
            scheduler.start()
            
            let results = observer.events.last
                .map { event in
                    event.value.element!.count
            }
            
            expect(results) == 2
        }
        
        
        it("fetches places when triggered refresh") {
            let observer = scheduler.createObserver([Place].self)
            
            scheduler.scheduleAt(100) {
                sut.outputs.places.asObservable().subscribe(observer).disposed(by: disposeBag)
            }
            
            scheduler.scheduleAt(200) {
                sut.inputs.reload.onNext(())
            }
            
            scheduler.start()
            
            let numberOfCalls = observer.events
                .map { event in
                    event.value.element!.count
                }
                .reduce(0) { $0 + $1 }
            
            expect(numberOfCalls) == 2
        }
        
        
        
    }
}

