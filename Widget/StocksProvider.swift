//
//  StocksProvider.swift
//  Widget
//
//  Created by Saagar Jha on 11/24/22.
//

import WidgetKit

struct StocksProvider: TimelineProvider {
	typealias Entry = StockQuote
	
#if false
	struct Response: Codable {
		struct Quote: Codable {
			struct QuoteDetail: Codable {
				let price: Double
				let priceChange: Double
			}
			
			let symbol: String
			let quoteDetail: QuoteDetail
		}
		
		let quotes: [Quote]
	}
	
	static func endpoint(forAccessKey accessKey: String) -> URL {
		return URL(string: "https://stocks-data-service.apple.com/api/v1/quote?language=en&region=US&dataSet=quote&symbol=GOOG&accessKey=\(accessKey)")!
	}
#endif
	
	struct Response: Codable {
		struct Query: Codable {
			struct Results: Codable {
				struct Item: Codable {
					struct Response: Codable {
						struct Finance: Codable {
							struct QuoteService: Codable {
								struct Quotes: Codable {
									struct Quote: Codable {
										struct Price: Codable {
											let raw: String
										}
										
										struct Change: Codable {
											let raw: String
										}
										let price: Price
										let change: Change
										let symbol: String
									}
									let quote: Quote
								}
								let quotes: Quotes
							}
							let quoteService: QuoteService
						}
						let finance: Finance
					}
					let response: Response
				}
				let item: Item
			}
			let results: Results
		}
		let query: Query
		
		var stockQuote: StockQuote? {
			let quote = query.results.item.response.finance.quoteService.quotes.quote
			guard let price = Double(quote.price.raw),
				  let change = Double(quote.change.raw)
			else {
				return nil
			}
			return StockQuote(date: .now, symbol: quote.symbol, price: price, change: change / (price - change))
		}
	}
	
	static let endpoint = URL(string: "https://apple-finance.query.yahoo.com/v3/finance/apple/multiquote?tickers=GOOG")!
	
	func placeholder(in context: Context) -> Entry {
		.sample
	}

	func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
		completion(.sample)
	}

	func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
		if context.isPreview {
			completion(
				Timeline(
					entries: [
						.sample
					], policy: .atEnd))
		} else {
			Task {
				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				guard let (data, response) = try? await URLSession.shared.data(from: Self.endpoint),
					  (response as? HTTPURLResponse)?.statusCode == 200,
					  let response = try? decoder.decode(Response.self, from: data),
					  let quote = response.stockQuote else {
					completion(Timeline(entries: [], policy: .atEnd))
					return
				}
				completion(Timeline(entries: [quote], policy: .after(.now.addingTimeInterval(60 * 60))))
			}
		}
	}
}
