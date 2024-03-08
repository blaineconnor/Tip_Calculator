//
//  Tip_CalculatorTests.swift
//  Tip_CalculatorTests
//
//  Created by Fatih Emre Sarman on 4.03.2024.
//

import XCTest
import Combine
@testable import Tip_Calculator

final class Tip_CalculatorTests: XCTestCase {
    
    //sut -> System Under Test
    private var sut: CalculatorVM!
    private var cancellable: Set<AnyCancellable>!
    private var logoViewTapSub: PassthroughSubject<Void,Never>!
    private var audioPlayerService: MockAudioPlayerService!
    
    override func setUp() {
        audioPlayerService = .init()
        sut = .init(audioPlayerService: audioPlayerService)
        logoViewTapSub = .init()
        cancellable = .init()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancellable = nil
        audioPlayerService = nil
        logoViewTapSub = nil
    }
    
    //EN: One person without tip --- TR: Bahşiş vermeden tek kişilik hesap
    func testResultWithoutTipFor1Person() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 1
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amounPerPerson, 100)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellable)
    }
    
    // - $100 bill
    // - no tip
    // - 1 person
    
    //EN: Two people without tip --- TR: Bahşiş vermeden iki kişilik hesap
    func testResultWithoutTipFor2People() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 2
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amounPerPerson, 50)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellable)
    }
    
    //EN: Two people %10 tip --- TR: %10 bahşişle iki kişilik hesap
    func testResultWith10PercentTipFor2People() {
        // given
        let bill: Double = 100.0
        let tip: Tip = .tenPercent
        let split: Int = 2
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amounPerPerson, 55)
            XCTAssertEqual(result.totalBill, 110)
            XCTAssertEqual(result.totalTip, 10)
        }.store(in: &cancellable)
    }
    
    //EN: Four people custom tip --- TR: Özel bahşiş dört kişilik hesap
    func testResultWithCustomtipFor4People() {
        // given
        let bill: Double = 200.0
        let tip: Tip = .custom(value: 201)
        let split: Int = 4
        let input = buildInput(bill: bill, tip: tip, split: split)
        //when
        let output = sut.transform(input: input)
        //then
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amounPerPerson, 100.25)
            XCTAssertEqual(result.totalBill, 401)
            XCTAssertEqual(result.totalTip, 201)
        }.store(in: &cancellable)
    }
    
    //EN: Calculator reset and sound test when logo tapped--- TR: Logoya tıklandığında hesap sıfırlama ve ses çıkışı
    func testSoundPlayedAndCalculatorResetOnLogoViewTap() {
        //given
        let input = buildInput(bill: 100, tip: .tenPercent, split: 2)
        let output = sut.transform(input: input)
        let expectation1 = XCTestExpectation(description: "reset calculator called")
        let expectation2 = audioPlayerService.expectation
        //then
        output.resetCalculatorPublisher.sink { _ in
            expectation1.fulfill()
        }.store(in: &cancellable)
        
        //when
        logoViewTapSub.send()
        wait(for: [expectation1, expectation2], timeout: 1.0)
    }
    
    private func buildInput(bill: Double, tip: Tip, split: Int) -> CalculatorVM.Input {
        return .init(billPublisher: Just(bill).eraseToAnyPublisher(), tipPublisher: Just(tip).eraseToAnyPublisher(), splitPublisher: Just(split).eraseToAnyPublisher(), logoViewTapPublisher: logoViewTapSub.eraseToAnyPublisher())
    }
}

class MockAudioPlayerService: AudioPlayerService {
    var expectation = XCTestExpectation(description: "playSound is called")
    func playSound() {
        expectation.fulfill()
    }
}
