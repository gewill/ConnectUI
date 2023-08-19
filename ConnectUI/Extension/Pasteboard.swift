//
//  Pasteboard.swift
//  ConnectUI
//
//  Created by will on 2023/2/19.
//

import Foundation

#if os(iOS)
import UIKit

func setPaste(string: String) {
  UIPasteboard.general.string = string
}

#elseif os(macOS)

import AppKit

func setPaste(string: String) {
  let pasteboard = NSPasteboard.general
  pasteboard.clearContents()
  pasteboard.setString(string, forType: .string)
}

#endif
