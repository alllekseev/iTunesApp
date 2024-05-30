//
//  Strings.swift
//  iTunesApp
//
//  Created by Олег Алексеев on 30/05/2024.
//

import Foundation

struct Strings {
  static let placeholder = String(localized: "Введите запрос", comment: "type a request")
  static let descriptionBlock = String(localized: "Описание", comment: "header for detail block of items")
  static let historyBlockHeader = String(localized: "Последние запросы", comment: "history elements")
  static let clearBittonTitle = String(localized: "Очистить")
}

struct ErrorMessageText {
  static let invalidData = String(localized: "Недействительные данные")
  static let jsonParsingFailure = String(localized: "Ошибка парсинга JSON")
  static let requestFailed = String(localized: "Ошибка при выполнении запроса")
  static let invalidStatusCode = String(localized: "Недействительный код статуса ответа")
  static let unknownError = String(localized: "Произошла неизвестная ошибка")
  static let itemsNotFound = String(localized: "Элементы не найдены")
  static let notValidURL = String(localized: "Недействительный URL-адрес")
}

/*

 */
