//
//  ContentView.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 22.04.21.
//
import Combine
import Foundation
import SwiftUI

struct ContentView: View {
    @ObservedObject var store = Store.shared

//    private var responsePublisher:
//        AnyPublisher<(CoinsToBtcInfoResult, CoinsToBtcInfoResult), Never> {
//        Publishers.CombineLatest(
//            store.$coinToBTCInfoPublisher,
//            store.$coinToUSDInfoPublisher)
//            .eraseToAnyPublisher()
//    }
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Coins_Data_Quote.data?.id, ascending: true)], animation: .default)
    private var items: FetchedResults<Coins_Data_Quote>

    init() {
//        store.coinsInfo?.data = [] //for tests
        print("Documents Directory: ", FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last ?? "Not Found!")
    }

    var body: some View {
        VStack {
            HStack {
                SecureField("CMC_PRO_API_KEY", text: $store.CMC_PRO_API_KEY)
                    .frame(maxWidth: 200)

                Button("Refresh") {
//                    store.refreshCoinsInfo(convert: "BTC")
//                    store.refreshCoinsInfo(convert: "USD")
                    store.requestToCoinMarketCap()
                }

                coinsStatusView
                    .padding()

                Toggle("Favorite", isOn: $store.onlyFavoritedCoins)
                    .toggleStyle(SwitchToggleStyle(tint: .green))

                TextField("Input coin name", text: $store.coinNameFilter)
                    .frame(maxWidth: 100)

                Button(action: {
                    store.coinNameFilter = Pasteboard.string
                }, label: {
                    Image(systemName: "square.and.arrow.down.fill")
                })
            }
            .padding([.horizontal, .top])

            CoinsListView()
                .padding([.horizontal, .bottom])
        }
        .frame(minWidth: 500, minHeight: 500)
//        .onReceive(responsePublisher, perform: { coinsBTCInfo, coinUSDInfo in
//            if case var .success(coinsBTCInfo) = coinsBTCInfo,
//               case let .success(coinUSDInfo) = coinUSDInfo
//            {
//                for coin in coinUSDInfo.data {
//                    if let btcIndex = coinsBTCInfo.data.firstIndex(where: { $0.id == coin.id }),
//                       let usdIndex = coinUSDInfo.data.firstIndex(where: { $0.id == coin.id })
//                    {
//                        coinsBTCInfo.data[btcIndex].quote["USD"] = coinUSDInfo.data[usdIndex].quoteUSD
//                    }
//                }
//                store.coinsInfo = coinsBTCInfo
//            }
//        })
    }

    @ViewBuilder
    private var coinsStatusView: some View {
        switch store.coinToBTCInfoPublisher {
        case .success:
            Text("\(store.coinsInfo?.status.total_count ?? 0)")
        case let .failure(error):
            if let error = error as? CustomError,
               error == .empty
            {
                Text("\(store.coinsInfo?.status.total_count ?? 0)")
            } else {
                Text("\(error.localizedDescription)")
            }
        }
    }  
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
