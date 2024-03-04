//
//  NetworkManager.swift
//  CryptoNotifier
//
//  Created by Alex on 2/22/24.
//

import Foundation

// Define a struct to represent a Bitcoin price
struct BitcoinPrice: Codable {
    let price: String
    // You can add more properties if needed
}

class NetworkManager {
    // Function to fetch Bitcoin price
    func fetchBitcoinPrice(completion: @escaping (BitcoinPrice?) -> Void) {
        guard let url = URL(string: "https://api.pro.coinbase.com/products/BTC-USD/ticker") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            do {
                let bitcoinPrice = try JSONDecoder().decode(BitcoinPrice.self, from: data)
                completion(bitcoinPrice)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }

    // Array to store Bitcoin prices
    var bitcoinPrices: [BitcoinPrice] = []

    // Function to update the array with Bitcoin prices every 5 seconds
    func updateBitcoinPrices() {
        fetchBitcoinPrice { price in
            if let price = price {
                self.bitcoinPrices.append(price)
                print("Bitcoin price updated: \(price.price)")
            } else {
                print("Failed to fetch Bitcoin price")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.updateBitcoinPrices()
            }
        }
    }
}



// Start updating Bitcoin prices
//updateBitcoinPrices()

// Keep the main thread running
//RunLoop.main.run()


