//
//  CoinRowView.swift
//  CryptoCombine
//
//  Created by Viktor Kushnerov on 23.04.21.
//

import SwiftUI

struct CoinRowView: View {
    var coin: CoinInfo

    @ObservedObject var store = Store.shared

    private var _count: Binding<String> {
        Binding<String>(
            get: {
                "\(store.extraCoinInfoList[coin.id]?.count ?? 0)"
            },
            set: {
                ExtraCoinInfoList.setCount(coin: coin, count: Double($0) ?? 0)
            }
        )
    }

    static let priceFormat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        return formatter
    }()

    var count: Double {
        store.extraCoinInfoList[coin.id]?.count ?? 0
    }

    var usdCoinInfo: CoinInfo.Quote? {
        return store.coinToUSDInfo?.data.first { $0.id == coin.id }?.quote["USD"]
    }

    var priceUSD: Double {
        return usdCoinInfo?.price ?? 0
    }

    var totalBTC: Double {
        coin.quoteBTC.price * count
    }

    var totalUSD: Double {
        priceUSD * count
    }

    init(coin: CoinInfo) {
        self.coin = coin
    }

    var body: some View {
        if filterByFavorite, filterByName {
            HStack {
                Image(systemName: store.extraCoinInfoList[coin.id]?.isFavorite == true ? "star.fill" : "star")
                    .onTapGesture {
                        ExtraCoinInfoList.toggleFavorite(coin: coin)
                    }

                Text("\(coin.name) (\(coin.symbol))")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        let url = "https://coinmarketcap.com/currencies/\(coin.slug)/"

                        Application.openBrowser(url: url)
                    }

                Spacer()
            }

            HStack {
                TextField("Count",
                          text: _count)
                    .frame(maxWidth: 100)

                Button(action: {
                    _count.wrappedValue = Pasteboard.string
                    ExtraCoinInfoList.setFavorite(coin: coin)
                }, label: {
                    Image(systemName: "square.and.arrow.down.fill")
                })
            }

            VStack {
                priceCellView(coin.quoteBTC.price)
                priceCellView(totalBTC)
                    .foregroundColor(.orange)
                priceCellView(priceUSD)
                priceCellView(totalUSD)
                    .foregroundColor(.green)
                Text("")
            }

            percentCellView(btcPercent: coin.quoteBTC.percent_change_1h, usdPercent: usdCoinInfo?.percent_change_1h)
            percentCellView(btcPercent: coin.quoteBTC.percent_change_24h, usdPercent: usdCoinInfo?.percent_change_24h)
            percentCellView(btcPercent: coin.quoteBTC.percent_change_7d, usdPercent: usdCoinInfo?.percent_change_7d)
            percentCellView(btcPercent: coin.quoteBTC.percent_change_30d, usdPercent: usdCoinInfo?.percent_change_30d)
            percentCellView(btcPercent: coin.quoteBTC.percent_change_60d, usdPercent: usdCoinInfo?.percent_change_60d)
            percentCellView(btcPercent: coin.quoteBTC.percent_change_90d, usdPercent: usdCoinInfo?.percent_change_90d)
        }
    }

    var filterByFavorite: Bool {
        (store.onlyFavoritedCoins &&
            store.extraCoinInfoList[coin.id]?.isFavorite == true) ||
            store.onlyFavoritedCoins == false
    }

    var filterByName: Bool {
        store.coinNameFilter.isEmpty
            || (store.coinNameFilter.isEmpty == false
                && coin.symbol == store.coinNameFilter.uppercased())
    }

    private func priceCellView(_ value: Double) -> some View {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.minimumFractionDigits = 10
        numberFormatter.maximumFractionDigits = 10

        return HStack {
            Spacer()
            Text(numberFormatter.string(from: NSNumber(value: value)) ?? "")
        }
    }

    private func percentCellView(btcPercent: Double, usdPercent: Double?) -> some View {
        let btcNumberFormatter = NumberFormatter()
        btcNumberFormatter.minimumIntegerDigits = 1
        btcNumberFormatter.minimumFractionDigits = 2
        btcNumberFormatter.maximumFractionDigits = 2

        let percentNumberFormatter = NumberFormatter()
        percentNumberFormatter.minimumIntegerDigits = 1
        percentNumberFormatter.minimumFractionDigits = 10
        percentNumberFormatter.maximumFractionDigits = 10

        let usdPercent = usdPercent ?? 0

        let priceBTC = coin.quoteBTC.price + coin.quoteBTC.price * btcPercent / 100
        let priceUSD = usdPercent > 0 ?
            (usdCoinInfo?.price ?? 0) / (usdPercent / 100)
            : 1
        let totalUSD = priceUSD * count

        return
            VStack {
                HStack {
                    Spacer()
                    Text(percentNumberFormatter.string(from: NSNumber(value: priceBTC)) ?? "")
                }

                HStack {
                    Spacer()
                    Text(btcNumberFormatter.string(from: NSNumber(value: btcPercent)) ?? "")
                        .foregroundColor(.orange)
                }

                HStack {
                    Spacer()
                    Text(percentNumberFormatter.string(from: NSNumber(value: priceUSD)) ?? "")
                }

                HStack {
                    Spacer()
                    Text(btcNumberFormatter.string(from: NSNumber(value: usdPercent)) ?? "")
                        .foregroundColor(.green)
                }

                HStack {
                    Spacer()
                    Text(btcNumberFormatter.string(from: NSNumber(value: totalUSD)) ?? "")
                }
            }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinsListView()
    }
}
