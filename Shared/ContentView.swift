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
            .padding()

            coinsView
        }
        .onReceive(store.$coinToBTCInfoPublisher, perform: { coinsInfo in
            if let coinsInfo = try? coinsInfo.get() {
                store.coinToBTCInfo = coinsInfo
            }
        })
    }

    private var coinsView: some View {
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
