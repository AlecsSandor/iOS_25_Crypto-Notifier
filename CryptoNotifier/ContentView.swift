//
//  ContentView.swift
//  CryptoNotifier
//
//  Created by Alex on 2/22/24.

import SwiftUI

struct ContentView: View {
    @State var data: [Double] = [0.8, 1.0, 0.34, 0.8, 1.0, 0.34, 0.8, 1.0, 0.34, 0.34]
    @State var difference = 0.0
    @ObservedObject var bitcoinPriceViewModel = BitcoinPriceViewModel()
    @State var touchLocation: CGFloat = -1
    @State var value = 0.7
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack() {
                    Text(String(format: "%.2f", bitcoinPriceViewModel.latestPrice))
                        .foregroundColor(.white)
                        .font(Font.custom("System", size: 40))
                        .animation(.timingCurve(0.2, 0.3, 0.8, 0.7))
                
                Image(systemName: difference < 0 ? "arrow.down" : "arrow.up")
                    .font(.system(size: 23))
                    .foregroundColor( difference < 0 ? Color.red : Color.green)
                    .padding(.leading,5)
                    .animation(.timingCurve(0.2, 0.3, 0.8, 0.7))
            }
            
            Text("BTC-USD")
                .foregroundColor(.yellow)
                .padding(5)
                .font(.caption)
            
            Spacer()
            
            HStack {
                Cell(value: $data[0], width: 400, numberOfDataPoints: 10, accentColor: .blue, touchLocation: $touchLocation)
                Cell(value: $data[1], width: 400, numberOfDataPoints: 10, accentColor: .blue, touchLocation: $touchLocation)
                Cell(value: $data[2], width: 400, numberOfDataPoints: 10, accentColor: .blue, touchLocation: $touchLocation)
                Cell(value: $data[3], width: 400, numberOfDataPoints: 10, accentColor: .blue, touchLocation: $touchLocation)
                Cell(value: $data[4], width: 400, numberOfDataPoints: 10, accentColor: .blue, touchLocation: $touchLocation)
                Cell(value: $data[5], width: 400, numberOfDataPoints: 10, accentColor: .blue, touchLocation: $touchLocation)
                Cell(value: $data[6], width: 400, numberOfDataPoints: 10, accentColor: .blue, touchLocation: $touchLocation)
                Cell(value: $data[7], width: 400, numberOfDataPoints: 10, accentColor: .blue, touchLocation: $touchLocation)
                Cell(value: $data[8], width: 400, numberOfDataPoints: 10, accentColor: .blue, touchLocation: $touchLocation)
                Cell(value: $data[9], width: 400, numberOfDataPoints: 10, accentColor: .blue, touchLocation: $touchLocation)

            }
            .frame(height: 260)
            .frame(width: 360)
        }
        .frame(maxWidth: .infinity)
        .background(Color(red: 24.0 / 255.0, green: 24.0 / 255.0, blue: 24.0 / 255.0))
        .onAppear {
            bitcoinPriceViewModel.startUpdatingBitcoinPrices()
        }
        .onChange(of: bitcoinPriceViewModel.bitcoinPrices) {
            difference = data[8] - data[9]
            data = minMaxNormalization(data: bitcoinPriceViewModel.bitcoinPrices)
            print(data)
        }
    }

}

#Preview {
    ContentView()
}

// Create a ViewModel to handle data fetching and updating
class BitcoinPriceViewModel: ObservableObject {
    @Published var bitcoinPrices: [Double] = [0.8, 1.0, 0.34, 0.8, 1.0, 0.34, 0.8, 1.0, 0.34, 0.34]
    @Published var latestPrice: Double = 0.0
    
    // Function to fetch Bitcoin price
    func fetchBitcoinPrice() {
        guard let url = URL(string: "https://api.pro.coinbase.com/products/BTC-USD/ticker") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let bitcoinPrice = try JSONDecoder().decode(BitcoinPrice.self, from: data)
                DispatchQueue.main.async {

                    self.bitcoinPrices.append(Double(bitcoinPrice.price) ?? 0.0)
                    self.bitcoinPrices.removeFirst()
                    self.latestPrice = Double(bitcoinPrice.price) ?? 0.0
                    
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // Function to start fetching Bitcoin prices periodically
    func startUpdatingBitcoinPrices() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.fetchBitcoinPrice()
        }
    }
}


func minMaxNormalization(data: [Double]) -> [Double] {
    let minVal = data.min() ?? 0.0
    let maxVal = data.max() ?? 1.0 // Avoid division by zero

    let normalizedData = data.map { (value) -> Double in
        return (value - minVal) / (maxVal - minVal)
    }

    return normalizedData
}
