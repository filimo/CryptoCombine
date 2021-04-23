//
//  ContentView.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 22.04.21.
//
import SwiftUI

struct ContentView: View {
    @StateObject var store = Store()

    var body: some View {
        VStack {
            HStack {
                Button("Refresh") {
                    store.refreshCoinsInfoToBTC()
                }

                coinsStatusView
                    .padding()

                Toggle("Favorite", isOn: $store.onlyFavoritedCoins)
                    .toggleStyle(SwitchToggleStyle(tint: .green))
            }
            .padding([.horizontal, .top])

            coinsListView
                .padding([.horizontal, .bottom])
        }
        .frame(minWidth: 500, minHeight: 500)
        .onReceive(store.$coinToBTCInfoPublisher, perform: { coinsInfo in
            if var coinsInfo = try? coinsInfo.get() {
                coinsInfo.sortedByName()
                store.coinToBTCInfo = coinsInfo
            }
        })
    }

    @ViewBuilder
    private var coinsStatusView: some View {
        switch store.coinToBTCInfoPublisher {
        case .success:
            Text("\(store.coinToBTCInfo?.status.total_count ?? 0)")
        case .failure(let error):
            if let error = error as? CustomError,
               error == .empty
            {
                Text("\(store.coinToBTCInfo?.status.total_count ?? 0)")
            } else {
                Text("\(error.localizedDescription)")
            }
        }
    }

    private var coinsListView: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
        ]

        return ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                coinsListHeaderView

                ForEach(store.coinToBTCInfo?.data ?? [], id: \.id) { coin in
                    if (store.onlyFavoritedCoins &&
                        coin.isFavorite == true) ||
                        store.onlyFavoritedCoins == false
                    {
                        HStack {
                            Image(systemName: coin.isFavorite == true ? "star.fill" : "star")
                                .onTapGesture {
                                    if let index = store.coinToBTCInfo?.data.firstIndex(where: { $0.symbol == coin.symbol }) {
                                        store.coinToBTCInfo?.data[index].isFavorite = !(store.coinToBTCInfo?.data[index].isFavorite ?? false)
                                    }
                                }

                            Text("\(coin.name) (\(coin.symbol))")

                            Spacer()
                        }

                        cellView(coin.quoteBTC.price)
                        cellView(coin.quoteBTC.percent_change_1h)
                        cellView(coin.quoteBTC.percent_change_24h)
                        cellView(coin.quoteBTC.percent_change_7d)
                        cellView(coin.quoteBTC.percent_change_30d)
                        cellView(coin.quoteBTC.percent_change_60d)
                        cellView(coin.quoteBTC.percent_change_90d)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var coinsListHeaderView: some View {
        Text("Name")
        Text("Price")
        Text("1h")
        Text("24h")
        Text("7d")
        Text("30d")
        Text("60d")
        Text("90d")
    }

    private func cellView(_ value: Double) -> some View {
        HStack {
            Spacer()
            Text("\(value)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
