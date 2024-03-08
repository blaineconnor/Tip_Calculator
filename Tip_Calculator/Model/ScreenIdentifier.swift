//
//  ScreenIdentifier.swift
//  Tip_Calculator
//
//  Created by Fatih Emre Sarman on 8.03.2024.
//

enum ScreenIdentifier {
  
  enum LogoView: String {
    case logoView
  }
  
  enum ResultView: String {
    case totalAmountPerPersonValueLabel
    case totalBillValueLabel
    case totalTipValueLabel
  }
  
  enum BillInputView: String {
    case textField
  }
  
  enum TipInputView: String {
    case tenPercentButton
    case fifteenPercentButton
    case twentyPercentButton
    case customTipButton
    case customTipAlertTextField
  }
  
  enum SplitInputView: String {
    case decrementButton
    case incrementButton
    case quantityValueLabel
  }
}
