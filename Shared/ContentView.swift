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
            Button("Refresh") {
                store.refreshCoinsInfoToBTC()
            }
            .padding([.horizontal, .top])

            coinsStatusView

            coinsListView
                .padding(.horizontal)
        }
        .frame(minWidth: 500, minHeight: 500)
        .onReceive(store.$coinToBTCInfoPublisher, perform: { coinsInfo in
            if var coinsInfo = try? coinsInfo.get() {
                coinsInfo.sortedByName()
                store.coinToBTCInfo = coinsInfo
            }
        })
    }

    private var coinsStatusView: some View {
        Group {
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
        .padding()
    }

    private var coinsListView: some View {
        ScrollView {
            ForEach(store.coinToBTCInfo?.data ?? [], id: \.id) { coin in
                HStack {
                    Text(coin.name)
                    
                    Spacer()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
