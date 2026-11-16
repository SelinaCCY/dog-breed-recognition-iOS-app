//
//  DogDetailViewModel.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 26/02/2024.
//

import Foundation
import SwiftUI

class DogDetailViewModel: ObservableObject {
    
    @Published var dogBreedData: DogBreedData?
    
    @Published var dogName: String = ""
    
    private var breedLoader = BreedLoader()
    
    // map breed name from model to breed name in json
    private let breedNameMap: [String: String] = [
        "n02097658-silky_terrier": "Australian Silky Terrier",
        "n02092002-Scottish_deerhound" : "Deerhound",
        "n02099849-Chesapeake_Bay_retriever": "Retriever (Chesapeake Bay)",
        "n02091244-Ibizan_hound" : "Ibizan Hound",
        "n02095314-wire-haired_fox_terrier" : "Fox Terrier (Wire)",
        "n02091831-Saluki" : "Saluki",
        "n02102318-cocker_spaniel" : "Spaniel (Cocker)",
        "n02104365-schipperke" : "Schipperke",
        "n02090622-borzoi" : "Borzoi",
        "n02113023-Pembroke" : "Welsh Corgi (Pembroke)",
        "n02105505-komondor" : "Komondor",
        "n02093256-Staffordshire_bullterrier" : "Staffordshire Bull Terrier",
        "n02113799-standard_poodle" : "Poodle (Standard)",
        "n02109961-Eskimo_dog" : "Canadian Eskimo Dog",
        "n02089973-English_foxhound" : "Foxhound",
        "n02099601-golden_retriever" : "Retriever (Golden)",
        "n02095889-Sealyham_terrier" : "Sealyham Terrier",
        "n02085782-Japanese_spaniel" : "Japanese Chin",
        "n02097047-miniature_schnauzer" : "Miniature Schnauzer",
        "n02110063-malamute" : "Alaskan Malamute",
        "n02105162-malinois" : "Belgian Shepherd Dog (Malinois)",
        "n02086079-Pekinese" : "Pekingese",
        "n02097130-giant_schnauzer" : "Giant Schnauzer",
        "n02113978-Mexican_hairless" : "Xoloitzcuintle (Mex Hairless) Int (Imp)",
        "n02107142-Doberman" : "Dobermann",
        "n02097209-standard_schnauzer" : "Schnauzer",
        "n02115913-dhole" : "Cirneco Dell'Etna",
        "n02106662-German_shepherd" : "German Shepherd Dog",
        "n02106382-Bouvier_des_Flandres" : "Bouvier Des Flandres",
        "n02110185-Siberian_husky" : "Siberian Husky",
        "n02094258-Norwich_terrier" : "Norwich Terrier",
        "n02093991-Irish_terrier" : "Irish Terrier",
        "n02094114-Norfolk_terrier" : "Norfolk Terrier",
        "n02109525-Saint_Bernard" : "St. Bernard",
        "n02093754-Border_terrier" : "Border Terrier",
        "n02105251-briard" : "Briard",
        "n02108551-Tibetan_mastiff" : "Tibetan Mastiff",
        "n02108422-bull_mastiff" : "Bullmastiff",
        "n02085936-Maltese_dog" : "Maltese",
        "n02093859-Kerry_blue_terrier" : "Kerry Blue Terrier",
        "n02104029-kuvasz" : "Hungarian Kuvasz (Imp)",
        "n02107574-Greater_Swiss_Mountain_dog" : "Great Swiss Mountain Dog",
        "n02095570-Lakeland_terrier" : "Lakeland Terrier",
        "n02086646-Blenheim_spaniel" : "King Charles Spaniel",
        "n02088238-basset" : "Basset Hound",
        "n02098286-West_Highland_white_terrier" : "West Highland White Terrier",
        "n02085620-Chihuahua" : "Chihuahua (Smooth Coat)",
        "n02106166-Border_collie" : "Border Collie",
        "n02090379-redbone" : "Black & Tan Coonhound (Imp)",
        "n02090721-Irish_wolfhound" : "Irish Wolfhound",
        "n02088632-bluetick" : "Black & Tan Coonhound (Imp)",
        "n02113712-miniature_poodle" : "Poodle (Miniature)",
        "n02113186-Cardigan" : "Welsh Corgi (Cardigan)",
        "n02108000-EntleBucher" : "Entlebucher Mountain Dog (Imp)",
        "n02091467-Norwegian_elkhound" : "Norwegian Elkhound",
        "n02100236-German_short-haired_pointer" : "German Shorthaired Pointer",
        "n02107683-Bernese_mountain_dog" : "Bernese Mountain Dog",
        "n02086910-papillon" : "Papillon",
        "n02097474-Tibetan_terrier" : "Tibetan Terrier",
        "n02101006-Gordon_setter" : "Gordon Setter",
        "n02093428-American_Staffordshire_terrier" : "Staffordshire Bull Terrier",
        "n02100583-vizsla" : "Hungarian Vizsla",
        "n02105412-kelpie" : "Australian Cattle Dog",
        "n02092339-Weimaraner" : "Weimaraner",
        "n02107312-miniature_pinscher" : "Miniature Pinscher",
        "n02108089-boxer" : "Boxer",
        "n02112137-chow" : "Chow Chow",
        "n02105641-Old_English_sheepdog" : "Old English Sheepdog",
        "n02110958-pug" : "Pug",
        "n02087394-Rhodesian_ridgeback" : "Rhodesian Ridgeback",
        "n02097298-Scotch_terrier" : "Scottish Terrier",
        "n02086240-Shih-Tzu" : "Shih Tzu",
        "n02110627-affenpinscher" : "Affenpinscher",
        "n02091134-whippet" : "Whippet",
        "n02102480-Sussex_spaniel" : "Spaniel (Sussex)",
        "n02091635-otterhound" : "Otterhound",      
        "n02099267-flat-coated_retriever" : "Retriever (Flat Coated)",
        "n02100735-English_setter" : "English Setter",
        "n02091032-Italian_greyhound" : "Italian Greyhound",
        "n02099712-Labrador_retriever" : "Retriever (Labrador)",
        "n02106030-collie" : "Border Collie",
        "n02096177-cairn" : "Cairn Terrier",
        "n02106550-Rottweiler" : "Rottweiler",
        "n02096294-Australian_terrier" : "Australian Terrier",
        "n02087046-toy_terrier" : "English Toy Terrier (Black & Tan)",
        "n02105855-Shetland_sheepdog" : "Shetland Sheepdog",
        "n02116738-African_hunting_dog" : "Sloughi",
        "n02111277-Newfoundland" : "Newfoundland",
        "n02089867-Walker_hound" : "Black & Tan Coonhound (Imp)",
        "n02098413-Lhasa" : "Lhasa Apso",
        "n02088364-beagle" : "Beagle",
        "n02111889-Samoyed" : "Samoyed",
        "n02109047-Great_Dane" : "Great Dane",
        "n02096051-Airedale" : "Airedale Terrier",
        "n02088466-bloodhound" : "Bloodhound",
        "n02100877-Irish_setter" : "Irish Setter",
        "n02112350-keeshond" : "Keeshond",
        "n02096437-Dandie_Dinmont" : "Dandie Dinmont Terrier",
        "n02110806-basenji" : "Basenji",
        "n02093647-Bedlington_terrier" : "Bedlington Terrier",
        "n02107908-Appenzeller" : "Entlebucher Mountain Dog (Imp)",
        "n02101556-clumber" : "Spaniel (Clumber)",
        "n02113624-toy_poodle" : "Poodle (Toy)",
        "n02111500-Great_Pyrenees" : "Pyrenean Mountain Dog",
        "n02102040-English_springer" : "Spaniel (English Springer)",
        "n02088094-Afghan_hound" : "Afghan Hound",
        "n02101388-Brittany_spaniel" : "Brittany",
        "n02102177-Welsh_springer_spaniel" : "Spaniel (Welsh Springer)",
        "n02096585-Boston_bull" : "Boston Terrier",
        "n02115641-dingo" : "Australian Cattle Dog",
        "n02098105-soft-coated_wheaten_terrier" : "Soft Coated Wheaten Terrier",
        "n02099429-curly-coated_retriever" : "Retriever (Curly Coated)",
        "n02108915-French_bulldog" : "French Bulldog",
        "n02102973-Irish_water_spaniel" : "Spaniel (Irish Water)",
        "n02112018-Pomeranian" : "Pomeranian",
        "n02112706-Brabancon_griffon" : "Griffon Bruxellois",
        "n02094433-Yorkshire_terrier" : "Yorkshire Terrier",
        "n02105056-groenendael" : "Belgian Shepherd Dog (Groenendael)",
        "n02111129-Leonberg" : "Leonberger",
        "n02089078-black-and-tan_coonhound" : "Black & Tan Coonhound (Imp)"
        
    ]
    
    func loadMatchingBreedData(from dogScanResult: DogScanResult? = nil, breedIdentifier: String? = nil){
        
        let identifier = dogScanResult?.originalBreedIdentifier ?? breedIdentifier ?? ""
        print ("loading breed data for identifier: \(identifier)")
        let mappedBreedName = breedNameMap[identifier] ?? identifier //use identifier as a fallback
        
        guard let breeds = breedLoader.loadBreedData() else {return}
        
        if let matchingBreed = breeds.first(where: { $0.breedName.contains(mappedBreedName) }) {
            DispatchQueue.main.async{
                self.dogBreedData = matchingBreed
                print("Found matching breed data for : \(matchingBreed.breedName)")
            }
        } else {
            print("No matching breed found for \(mappedBreedName)")
        }
    }
    
}
