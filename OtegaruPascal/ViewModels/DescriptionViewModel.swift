//
//  DescriptionViewModel.swift
//  OtegaruPascal
//
//  Created by cmStudent on 2023/01/11.
//

import Foundation

final class DescriptionViewModel: ObservableObject {
    // 解説の種類
    enum DescriptionText {
    case appUsage // このアプリの使い方
    case weatherAndPressure // 天気と気圧の関係性について
    case aboutPressure // 気圧とその計算方法について
    case aboutLocation // 位置情報について
    }
    
    // 10個まで入る。それ以上はViewの方をScrollViewにしなければならない
    @Published var descriptionArray: [(title: String, text: DescriptionText)] = [
        ("このアプリの使い方", .appUsage),
        ("天気と気圧の関係性について", .weatherAndPressure),
        ("気圧とその計算方法", .aboutPressure),
        ("位置情報について", .aboutLocation)
    ]
    
    // MARK: - getDescription
    // 選択された解説タイトルの解説を返す
    func getDescription(type: DescriptionText) -> String {
        // テキスト
        let text: String
        
        switch type {
        case .appUsage:
            text = "このアプリは現在の気圧から今後の体調を予測するアプリです。\n\nこのアプリをバックグラウンドで起動し続けて頂くと、今後の体調を予測し、もし体調が悪くなるようなら通知を出し、悪くなる前にお薬等で対策して頂くアプリになります。\n\n気圧の変化がどの程度体調に変化を及ぼすかは、人によって違いが出てきてしまいます。あくまで予測なので、絶対に当たるとは限りませんが、体調不良の予防の助けになると思います。\n\n体調の予測は、ホーム画面の下部に表示しています。\nこれは、過去の気圧と現在の気圧の変化から、今後の気圧を予測しています。\n\nまた、前述の通り人によって受ける気圧の影響が違うので、記録画面にて現在の体調の良し悪しの記録を付けて頂くことで、利用者に合わせて体調の予測が調整されます。\n\n気圧の対策は、継続して続けることが重要です。\nこのアプリも継続して使用し、日々の体調の記録を付けて頂くことで、体調の予測の精度が上がりますので、このアプリを継続して使用することを推奨します。"
            
        case .weatherAndPressure:
            text = "天気と気圧には密接な関係があります。\n\n一般的に気圧が下がると雨が降りやすくなり、気圧が上がると晴れやすくなります。\n\nこれらは気圧によって風の向きが変わることで気流が発生し、天気に影響を与えているからです。\n\n北半球では\n気圧が下がれば、風が中心に向かって反時計回りに吹き出すので上昇気流が発生し、雲が出来て雨が降ります。\n\n反対に、高気圧であれば、中心から外側に向かって時計回りに風が吹き出し、下降気流が発生することで雲が出来にくく晴れになりやすいです。\n\nこれらの事象を利用して、気圧から天気予報を行うこともできます。\n\n気圧情報だけでなく、天気予報も体調不良の対策の一環として取り入れることができれば、より効果的な対策ができると思います。\n\n是非、取り入れてみてください。"
            
        case .aboutPressure:
            text = "ホーム画面で表示されている気圧は、海面更正気圧と言われるものです。\n\n海面更正気圧とは海抜0mで測定したと仮定する値です。\n計算式は、\n\n p0 = p(1 - (0.0065 × 標高(m)) ÷ (気温 + 0.0065 × 標高 + 273.15)) ^-5.257 \n\nとなります。\n\nこの場合、「p」が測定気圧、「p0」が海面更正気圧になります。\n\nこの計算をすることのメリットは、\nエレベーター等の高度の上昇による気圧の変化の影響を小さくし、より精確な気圧を測定ができることです。"
            
        case .aboutLocation:
            text = "このアプリでは位置情報を利用しています。\n\n位置情報は、天気予報や正確な気圧を測るために使用されています。\n\n具体的には、位置情報から取得できる高度を気圧の計算に利用しています。\n\n位置情報の使用を拒否することもできますが、その場合、天気予報や現在の気圧及び体調の予報の精度が落ちてしまいます。\n\n予報の精度を高めるため、位置情報の使用を推奨します。"
            
        }
        
        return text
    }
}
