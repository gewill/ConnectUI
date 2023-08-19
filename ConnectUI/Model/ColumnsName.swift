//
//  ColumnsName.swift
//  ConnectUI
//
//  Created by will on Constant.padding23/2/19.
//

import Foundation
import SwiftUI

enum ColumnsName: String, CaseIterable, Identifiable {
  case fixed, flexible, adaptive
  var id: ColumnsName { self }

  var columms: [GridItem] {
    switch self {
    case .fixed:
      /// 有几个GridItem，row就有几个
      /// 超出父视图，不会压缩，会截断
      return [
        GridItem(.fixed(300), spacing: Constant.padding),
        GridItem(.fixed(300), spacing: Constant.padding),
        GridItem(.fixed(300), spacing: Constant.padding),
      ]
    case .flexible:
      /// 有几个GridItem，row就有几个
      /// 超出父视图，会压缩
      return [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
      ]
    case .adaptive:
      /// minimum在父视图过小时，会失效，不会阻止父视图变小
      /// 只要一个GridItem就行，row自动匹配最大容量
      /// 如它的名字一样：自适应，是最方便的布局方式
      return [
        GridItem(.adaptive(minimum: 300, maximum: 400), spacing: Constant.padding),
      ]
    }
  }
}
