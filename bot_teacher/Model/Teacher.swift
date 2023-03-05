//
//  Teacher.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/4.
//

import Foundation
import UIKit


struct Teacher {
    let name: String
    let info: String
    let color: UIColor
    
}


let teachers: [Teacher] = [
    Teacher(name: "Kim Kardashian", info: "Kardashian has developed a significant presence online and across numerous social media platforms, including hundreds of millions of followers on Twitter and Instagram.[2][3][4] With sisters Kourtney and Khloé, she launched the fashion boutique chain Dash, which operated from 2006 to 2018.[5] Kardashian founded KKW Beauty and KKW Fragrance in 2017,[6] and the shaping underwear or foundation garment company Skims in 2019.[7] She has released a variety of products tied to her name, including the 2014 mobile game Kim Kardashian: Hollywood and the 2015 photo book Selfish. As an actress, she has appeared in the films Disaster Movie (2008), Deep in the Valley (2009), and Temptation: Confessions of a Marriage Counselor (2013), and provided her voice for PAW Patrol: The Movie (2021).", color: .systemBlue),
    Teacher(name: "Steve Jobs", info: "Steven Paul Jobs (February 24, 1955 – October 5, 2011) was an American entrepreneur, business magnate, industrial designer, media proprietor, and investor. He was the co-founder, chairman, and CEO of Apple; the chairman and majority shareholder of Pixar; a member of The Walt Disney Company's board of directors following its acquisition of Pixar; and the founder, chairman, and CEO of NeXT. He is widely recognized as a pioneer of the personal computer revolution of the 1970s and 1980s, along with his early business partner and fellow Apple co-founder Steve Wozniak.", color: .systemMint),
    Teacher(name: "Donald Trump", info: "Trump graduated from the Wharton School of the University of Pennsylvania with a bachelor's degree in 1968. He became president of his father's real estate business in 1971 and renamed it The Trump Organization. He expanded the company's operations to building and renovating skyscrapers, hotels, casinos, and golf courses and later started side ventures, mostly by licensing his name. From 2004 to 2015, he co-produced and hosted the reality television series The Apprentice. Trump and his businesses have been involved in more than 4,000 state and federal legal actions, including six bankruptcies.", color: .systemPink)
]
