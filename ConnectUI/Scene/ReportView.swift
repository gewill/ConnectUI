//
//  ReportView.swift
//  ConnectUI
//
//  Created by will on Constant.padding23/2/19.
//

import AlertToast
import RealmSwift
import SwiftUI

struct ReportView: View {
  @EnvironmentObject var pathManager: PathManager
  @EnvironmentObject var store: Store
  @Environment(\.realm) var realm: Realm
  @ObservedObject var viewModel = ReportViewModel()

  @AppStorage("ReportViewColumnsName") var columnsName: ColumnsName = .adaptive

  var body: some View {
    ZStack {
      Color.clear.ignoresSafeArea()
        .background(Material.ultraThickMaterial)
        .background(Image.background4)
      ScrollView(.vertical, showsIndicators: true) {
        menuView
          .padding(Constant.padding)

        Divider().padding(.horizontal)
        loadingView

        ScrollView(.vertical, showsIndicators: true) {
          reportList
            .padding(Constant.padding)
        }
      }
    }
    .refreshable {
      viewModel.loadApps()
    }
    .onAppear {
      viewModel.loadApps()
    }
    .toast(isPresenting: $viewModel.showToast, duration: 3, tapToDismiss: true, alert: {
      AlertToast(displayMode: .alert, type: .regular, title: viewModel.errorMessage)
    })
    .toolbar {
      ToolbarItem(placement: .principal) { titleView }
      ToolbarItem(placement: .navigation) {
        Button {
          pathManager.path.append(PathManager.Target.settingsView)
        } label: {
          Image(systemName: "gear")
        }
      }
    }
  }

  var titleView: some View {
    Text("Apps Sales Reports")
      .font(.title)
      .foregroundStyle(
        LinearGradient(
          colors: [Color(hex: "FF6E7F"), Color(hex: "614385")],
          startPoint: .leading,
          endPoint: .trailing
        )
      )
  }

  var menuView: some View {
    LazyVGrid(columns: ColumnsName.adaptive.columms, spacing: Constant.padding) {
      Picker("Range", selection: $viewModel.reportRange) {
        ForEach(ReportRange.allCases) { name in
          Text(name.rawValue.localizedStringKey)
        }
      }
      .pickerStyle(.segmented)
      .onChange(of: viewModel.reportRange) { _ in
        viewModel.loadApps()
      }

      HStack(alignment: .center, spacing: 0.0) {
        DatePicker("Select date", selection: $viewModel.selectedDate, displayedComponents: .date)
          .onChange(of: viewModel.selectedDate) { _ in
            viewModel.loadApps()
          }

        Button {
          if viewModel.reportRange == .thisMonth {
            viewModel.selectedDate = viewModel.selectedDate.previousMonth
          } else {
            viewModel.selectedDate = viewModel.selectedDate.yesterday
          }
        } label: {
          Image.chevronLeft
            .font(.headline)
        }
        .frame(width: 44, height: 44)
        Button {
          if viewModel.reportRange == .thisMonth {
            viewModel.selectedDate = viewModel.selectedDate.nextMonth
          } else {
            viewModel.selectedDate = viewModel.selectedDate.tomorrow
          }
        } label: {
          Image.chevronRight
            .font(.headline)
        }
        .frame(width: 44, height: 44)
      }
      #if os(macOS)
        Button {
          viewModel.loadApps()
        } label: {
          Label("Refresh", systemImage: "arrow.clockwise")
        }
        .disabled(viewModel.isLoadingPage)
      #endif
      if store.connectKeyModel.isValid == false {
        Button {
          pathManager.path.append(PathManager.Target.connectKeyView)
        } label: {
          HStack {
            Image(systemName: "questionmark.key.filled")
            Text("Missing `Connect API Key` or invalid")
          }
        }
        .tint(.pink)
        .buttonStyle(.borderedProminent)
      }
    }
  }

  var loadingView: some View {
    VStack {
      if viewModel.isLoadingPage {
        HStack(spacing: 8.0) {
          ProgressView().progressViewStyle(.circular)
          Text("Loading sales reports")
          Button {
            viewModel.cancelTask()
          } label: {
            Label("Stop", systemImage: "stop.circle")
          }
          .disabled(!viewModel.isLoadingPage)
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(Constant.cornerRadius)
        .shadow(radius: 3)
        .padding(8)
      }
    }
  }

  var reportList: some View {
    LazyVGrid(columns: ColumnsName.adaptive.columms, spacing: Constant.padding) {
      totalView

      ForEach(viewModel.dailySaleModels) { model in
        VStack(alignment: .leading, spacing: Constant.padding) {
          HStack {
            if model.productType == .iap {
              Text("IAP")
            } else {
              Text("App")
            }
            Divider()
            Text(model.title)
              .font(.title3)
          }
          Text(model.showDateRange)

          Divider()
          HStack {
            VStack {
              Text(model.revenue.currencyString())
                .bold()
              Text("Revenue")
            }
            Spacer()
            VStack {
              Text(model.units.description)
                .bold()
              Text("Units")
            }

            Spacer()
            VStack {
              Text(model.productType != .iap ? model.update.description : .noValueSymbol)
                .bold()
              Text("Updates")
            }
          }
        }
        .padding()
        .background(Material.regular)
        .background(
          LinearGradient(
            colors: Color.Gradient.kashmir,
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .cornerRadius(Constant.cornerRadius)
        .shadow(radius: 3)
      }
    }
  }

  var totalView: some View {
    VStack {
      if let model = viewModel.totalSaleModel {
        VStack(alignment: .leading, spacing: Constant.padding) {
          Text("Total")
            .font(.title3)
          Text(model.showDateRange)
          Divider()
          HStack {
            VStack {
              Text(model.revenue.currencyString())
                .bold()
              Text("Revenue")
            }
            Spacer()
            VStack {
              Text(model.units.description)
                .bold()
              Text("Units")
            }

            Spacer()
            VStack {
              Text(model.update.description)
                .bold()
              Text("Updates")
            }
          }
        }
        .padding()
        .background(Material.regular)
        .background(
          LinearGradient(
            colors: Color.Gradient.noonToDusk,
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .cornerRadius(Constant.cornerRadius)
        .shadow(radius: 3)
      }
    }
  }
}

struct ReportView_Previews: PreviewProvider {
  static let store = Store.shared
  static var previews: some View {
    ReportView()
      .environmentObject(store)
  }
}
