//
//  DogDetail.swift
//  WoofAmI_Capstone
//
//  Created by Selina Cheah on 12/02/2024.
//
// MVVM model code is adapted from https://www.youtube.com/watch?v=b1oC7sLIgpI&t=19844s

import SwiftUI
import CoreData

struct DogDetailView: View {
    
    var classificationResult: ClassificationResult?
    var userImage: UIImage?
    var dogScanResult: DogScanResult?
    
    init(dogScanResult: DogScanResult? = nil, classificationResult: ClassificationResult? = nil, userImage: UIImage? = nil, breedURL: String){
        if let dogScanResult = dogScanResult {
            self.dogScanResult = dogScanResult
            self.classificationResult = nil
            self.userImage = UIImage(data: dogScanResult.userImage ?? Data())
        } else {
            self.dogScanResult = nil
            self.classificationResult = classificationResult
            self.userImage = userImage
        }
        self.breedURL = breedURL
    }
    
    var breedURL: String
    let linkLabel: String = "here"
    
    private var dogNameInput: String = ""
    
    @ObservedObject var viewModel = DogDetailViewModel()
    
    // Use @AppStorage to persistently save the dog's name
    @State private var dogName: String = "Click here to enter dog's name"
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Environment(\.presentationMode) var presentationMode
    
    var breedName: String {
        if let breedData = viewModel.dogBreedData {
            return breedData.breedName
        } else if let classificationResult = classificationResult{
            let components = classificationResult.breed.split(separator: "-")
            return components.last.map(String.init) ?? classificationResult.breed
        } else {
            return "Unknown Breed"
        }
    }
    
    var displayConfidence: Double{
        if let classificationResult = classificationResult{
            return Double(classificationResult.confidence)
        } else if let dogScanResult = dogScanResult {
            return dogScanResult.confidence
        } else {
            return 0.0
        }
    }
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    if let userImage = userImage{
                        Image(uiImage: userImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 300)
                            .cornerRadius(15)
                            .clipped()
                            .padding(10)
                            .shadow(color: Color.black.opacity(0.3), radius: 4, x:0, y:4)
                    }
                    
                    //display dog's name from before or allow to enter a new one
                    if let dogName = dogScanResult?.dogName{
                        Text(dogName)
                            .font(Font.custom("Caveat-VariableFont_wght", size:24))
                            .padding()
                    } else {
                        TextField("Enter dog's name", text: $viewModel.dogName)
                            .onSubmit {
                                //save the input to dogName when user presses Return
                                saveDogDetails()
                            }
                            .font(Font.custom("Caveat-VariableFont_wght", size:24))
                            .padding()
                            .foregroundColor(.black)
                    }
                }
                    
                    .onAppear(){
                        //reset text field
                        //only get dogName if coming from history
                        if let dogScan = dogScanResult{
                            //populate with historical data
                            viewModel.dogName = dogScan.dogName ?? ""
                            
                        } 
                        
                        //load breed data based on whether we have a historial dog scan or new classification
                        if let dogScan = dogScanResult{
                            viewModel.loadMatchingBreedData(from: dogScan)
                        } else if let breedIdentifier = classificationResult?.breed {
                            viewModel.loadMatchingBreedData(from: nil, breedIdentifier: breedIdentifier)
                        }
                    
                }
                .background(
                    ZStack{
                        Color("orange-m").opacity(0.7)
                        
                        Rectangle()
                            .fill(Material.ultraThinMaterial)
                    })
                .cornerRadius(15)
                .padding()
                
                HStack{
                    Text("Dog Breed Details")
                        .font(.title).bold()
                        .padding(.horizontal)
                    
                    Spacer()
                }
                
                .onAppear{
                    if let breedIdentifer = classificationResult?.breed{
                        viewModel.loadMatchingBreedData(from: dogScanResult)
                        print("Loading breed data for: \(breedIdentifer)")
                    } else{
                        print("Classification result is nil")
                    }
                }
                
                HStack{
                    if let breedData = viewModel.dogBreedData{
                        
                        AsyncImage(url: URL(string: breedData.imageURL)){ phase in
                            switch phase{
                            case .success(let image):
                                image.resizable().aspectRatio(contentMode: .fill)
                            case .failure(_):
                                Image(systemName: "exclamationmark.triangle")
                            case .empty:
                                ProgressView()
                            @unknown default:
                                EmptyView()
                            }
                            
                        }
                        .frame(width:120, height: 90)
                        .clipped()
                    }else {
                        Image("poodle-test")
                            .resizable()
                            .frame(width:120, height: 90)
                    }

                    VStack(alignment: .leading, spacing: 5){
                        Text(breedName)
                            .font(.title)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        
                        Text("Confidence: \(String(format: "%.2f%%", displayConfidence * 100))")
                            .font(.title3)
                            .fontWeight(.medium)
                    }
                    Spacer()
                }
                .background(
                    ZStack{
                        Color("orange-light").opacity(0.7)
                        
                        Rectangle()
                            .fill(Material.ultraThinMaterial)
                
                    })
                .cornerRadius(15)
                .padding(.horizontal, 10)
                .padding(.bottom, 12.0)
                
                if let breedData = viewModel.dogBreedData{
                    DogAttributesView(characteristics: breedData.characteristics)
                }
                
                if let breedData = viewModel.dogBreedData{
                    HStack{
                        Spacer()
                        Text("For more details, visit")
                        Link(linkLabel, destination: URL(string: breedData.breedURL) ?? URL (string: "https://www.thekennelclub.org.uk/search/breeds-a-to-z/")!)
                        Spacer()
                    }
                }
                
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    
                }
            }
            
        }
    }
    
    func saveDogDetails(){
        let newDogScanResult = DogScanResult(context: viewContext)
        
        newDogScanResult.originalBreedIdentifier = classificationResult?.breed 
        newDogScanResult.id = UUID()
        newDogScanResult.dogName = viewModel.dogName.isEmpty ? nil : viewModel.dogName
        newDogScanResult.breedName = breedName
        newDogScanResult.timestamp = Date()
        
        if let classificationResult = classificationResult {
            newDogScanResult.confidence = Double(classificationResult.confidence)
            print("Saving confidence: \(classificationResult.confidence)")
        } else {
            newDogScanResult.confidence = 0
            print("Unknown Confidence")
        }
        
        guard let newDogId = newDogScanResult.id else {
                print("New DogScanResult ID is nil.")
                return
            }
        
        //debugging
        let fetchRequest: NSFetchRequest<DogScanResult> = DogScanResult.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", newDogId as CVarArg)
        
        do{
            let fetchedResults = try viewContext.fetch(fetchRequest)
            if let result = fetchedResults.first{
                print("Fetched dogScanResult with confidence: \(result.confidence)")
            }
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
        
        print("Saving dog scan result with timestamp: \(newDogScanResult.timestamp!)")
        
        if let imageData = userImage?.jpegData(compressionQuality: 1.0){
            newDogScanResult.userImage = imageData
            print("Attempting to save image data of size: \(imageData.count) bytes")
        } else {
            print("Could not convert UIImage to Data")
        }
        
        do {
            try viewContext.save()
            print("Dog details saved successfully")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    DogDetailView(classificationResult: ClassificationResult(breed: "Poodle", confidence: 0.95),
                  userImage: UIImage(named: "poodle-test") ?? UIImage(),
    breedURL: "https://www.thekennelclub.org.uk/search/breeds-a-to-z/")
}
