import SwiftUI

struct ContentView: View {
    @State private var stockArray = [Stock]()
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            List(stockArray) { stockObj in
                NavigationLink(
                    destination: VStack {
                        Text("Stock: \(stockObj.symbol)")
                            .padding()
                            
                        Text("Price: \(stockObj.price)")
                            .padding()
                            .foregroundColor(.green)
                        
                        Text("Change: \(stockObj.change)")
                            .padding()
                            .foregroundColor(.green)
                    },
                    label: {
                        HStack {
                            Text(stockObj.symbol)
                            
                        }
                    })
            }
            .navigationTitle("STOCK CHECKER")
           
        }
        
        .onAppear(perform: {
            queryAPI()
        })
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the data"), dismissButton: .default(Text("OK")))
        })
    }
    
    func queryAPI() {
        let stocks = ["TSLA", "NCLH", "MGM", "WYNN", "DAL"]//due to the rate limit of the API, I can only request 5 stocks in the loading time
        for stock in stocks {
            let apiKey = "&rapidapi-key=04aa279cc6msh6fa1482a7f55108p1db78ejsn6da14b11bf11"
            let query = "https://alpha-vantage.p.rapidapi.com/query?function=GLOBAL_QUOTE&symbol=\(stock)\(apiKey)"
            if let url = URL(string: query) {
                if let data = try? Data(contentsOf: url) {
                    let json = try! JSON(data: data)
                    let price = json["Global Quote"]["05. price"].stringValue
                    let symbol = json["Global Quote"]["01. symbol"].stringValue
                    let change = json["Global Quote"]["10. change percent"].stringValue
                    let stockObj = Stock(symbol: symbol, price: price, change: change)
                    stockArray.append(stockObj)
                }
            }
        }
        return
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Stock: Identifiable {
    let id = UUID()
    let symbol: String
    let price: String
    let change: String
}
