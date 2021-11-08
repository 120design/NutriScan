//
//  StorageManager.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 06/10/2021.
//

import Foundation
import CoreData

protocol StorageManagerProtocol {
    var maxHistory: Int { get set }
    
    func create(product nuProduct: NUProduct)
    func getHistoryProducts() -> [NUProduct]
    func getFavoritesProducts() -> [NUProduct]
    func productIsAFavorite(_ product: NUProduct) -> Bool
    func saveInFavorites(product nuProduct: NUProduct)
    func removeProductFromFavorites(_ nuProduct: NUProduct)
    func moveFavoritesProduct(from: IndexSet, to: Int)
}

enum StorageType {
    case persistent, inMemory
}

struct StorageManager: StorageManagerProtocol {
    var maxHistory: Int
    
    static let shared = StorageManager()
    
    let persistentContainer: NSPersistentContainer
    
    init(
        _ storageType: StorageType = .persistent,
        maxHistory: Int = HistoryViewModel.MaxHistory.low.int
    ) {
        self.persistentContainer = NSPersistentContainer(name: "NutriScan")
        
        if storageType == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            self.persistentContainer.persistentStoreDescriptions = [description]
        }
        
        self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        self.maxHistory = maxHistory
    }
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("CoreDataStore ~> saveContext ~> Error ~>", error.localizedDescription)
            }
        } else {
            print("CoreDataStore ~> saveContext ~> No change to save")
        }
    }
    
    // MARK: Create operations
    
    func create(product nuProduct: NUProduct) {
        let productIsAFavorite = getFavoritesProducts().contains{ $0.id == nuProduct.id }
        
        deleteProduct(withID: nuProduct.id)
        
        let cdProduct = CDProduct(context: context)
        
        var cdNutriments: CDNutriments
        var cdEcoScore: CDEcoScore
        var cdNutriScore: CDNutriScore
        
        cdProduct.id = nuProduct.id
        
        cdProduct.name = nuProduct.name
        
        if let imageURL = nuProduct.imageURL {
            cdProduct.imageURL = imageURL
        }
        
        if let novaGroup = nuProduct.novaGroup {
            switch novaGroup {
            case .one:
                cdProduct.novaGroup = 1
            case .two:
                cdProduct.novaGroup = 2
            case .three:
                cdProduct.novaGroup = 3
            case .four:
                cdProduct.novaGroup = 4
            }
        }
        
        if let nutriments = nuProduct.nutriments {
            cdNutriments = CDNutriments(context: context)
            
            if let fiber_100g = nutriments.fiber_100g {
                cdNutriments.fiber_100g = NSNumber(value: fiber_100g)
            }
            if let carbohydrates_100g = nutriments.carbohydrates_100g {
                cdNutriments.carbohydrates_100g = NSNumber(value: carbohydrates_100g)
            }
            if let proteins_100g = nutriments.proteins_100g {
                cdNutriments.proteins_100g = NSNumber(value: proteins_100g)
            }
            if let fat_100g = nutriments.fat_100g {
                cdNutriments.fat_100g = NSNumber(value: fat_100g)
            }
            if let salt_100g = nutriments.salt_100g {
                cdNutriments.salt_100g = NSNumber(value: salt_100g)
            }
            if let energy_kj_100g = nutriments.energy_kj_100g {
                cdNutriments.energy_kj_100g = Int16(energy_kj_100g) as NSNumber?
            }
            if let energy_kcal_100g = nutriments.energy_kcal_100g {
                cdNutriments.energy_kcal_100g = Int16(energy_kcal_100g) as NSNumber?
            }
            
            cdProduct.nutriments = cdNutriments
        }
        
        if let ecoScore = nuProduct.ecoScore,
           let score = ecoScore.score,
           let grade = ecoScore.grade,
           let agribalyse = ecoScore.agribalyse,
           let agribalyseScore = agribalyse.score,
           let adjustments = ecoScore.adjustments
        {
            cdEcoScore = CDEcoScore(context: context)
            
            var cdAdjustments: CDAdjustments
            
            cdEcoScore.score = Int16(score) as NSNumber?
            
            if let score_fr = ecoScore.scores?.fr {
                cdEcoScore.score_fr = Int16(score_fr) as NSNumber?
            }
            
            switch grade {
            case .a:
                cdEcoScore.grade = 1
            case .b:
                cdEcoScore.grade = 2
            case .c:
                cdEcoScore.grade = 3
            case .d:
                cdEcoScore.grade = 4
            case .e:
                cdEcoScore.grade = 5
            }
            
            if let grade_fr = ecoScore.grades?.fr {
                switch grade_fr {
                case .a:
                    cdEcoScore.grade_fr = 1
                case .b:
                    cdEcoScore.grade_fr = 2
                case .c:
                    cdEcoScore.grade_fr = 3
                case .d:
                    cdEcoScore.grade_fr = 4
                case .e:
                    cdEcoScore.grade_fr = 5
                }
            }
            
            let cdAgribalyse = CDAgribalyse(context: context)
            cdAgribalyse.score = Int16(agribalyseScore) as NSNumber?
            cdEcoScore.agribalyse = cdAgribalyse
            
            cdAdjustments = CDAdjustments(context: context)
            
            var cdProductionSystem: CDProductionSystem
            var cdOriginsOfIngredients: CDOriginsOfIngredients
            var cdPackaging: CDPackaging
            var cdThreatenedSpecies: CDThreatnenedSpecies
            
            if let value = adjustments.production_system?.value {
                cdProductionSystem = CDProductionSystem(context: context)
                cdProductionSystem.value = Int16(value) as NSNumber?
                
                cdAdjustments.production_system = cdProductionSystem
            }
            
            if adjustments.origins_of_ingredients?.transportation_value != nil
                || adjustments.origins_of_ingredients?.transportation_values?.fr != nil
                || adjustments.origins_of_ingredients?.epi_value != nil
            {
                cdOriginsOfIngredients = CDOriginsOfIngredients(context: context)
                
                let origins_of_ingredients = adjustments.origins_of_ingredients
                
                if let transportation_value = origins_of_ingredients?.transportation_value {
                    cdOriginsOfIngredients.transportation_value = Int16(transportation_value) as NSNumber?
                }
                
                if let transportation_value_fr = origins_of_ingredients?.transportation_values?.fr {
                    cdOriginsOfIngredients.transportation_value_fr = Int16(transportation_value_fr) as NSNumber?
                }
                
                if let epi_value = origins_of_ingredients?.epi_value {
                    cdOriginsOfIngredients.epi_value = Int16(epi_value) as NSNumber?
                }
                
                cdAdjustments.origins_of_ingredients = cdOriginsOfIngredients
                
                if let value = adjustments.packaging?.value {
                    cdPackaging = CDPackaging(context: context)
                    cdPackaging.value = Int16(value) as NSNumber?
                    
                    cdAdjustments.packaging = cdPackaging
                }
                
                if let value = adjustments.threatened_species?.value {
                    cdThreatenedSpecies = CDThreatnenedSpecies(context: context)
                    cdThreatenedSpecies.value = Int16(value) as NSNumber?
                    
                    cdAdjustments.threatened_species = cdThreatenedSpecies
                }
                
                cdEcoScore.adjustments = cdAdjustments
            }
            
            cdProduct.ecoScore = cdEcoScore
        }
        
        if let nutriScore = nuProduct.nutriScore,
           let score = nutriScore.score,
           let negative_points = nutriScore.negative_points,
           let positive_points = nutriScore.positive_points,
           let grade = nutriScore.grade
        {
            cdNutriScore = CDNutriScore(context: context)
            
            cdNutriScore.score = Int16(score) as NSNumber?
            cdNutriScore.negative_points = Int16(negative_points) as NSNumber?
            cdNutriScore.positive_points = Int16(positive_points) as NSNumber?
            
            switch grade {
            case .a:
                cdNutriScore.grade = 1
            case .b:
                cdNutriScore.grade = 2
            case .c:
                cdNutriScore.grade = 3
            case .d:
                cdNutriScore.grade = 4
            case .e:
                cdNutriScore.grade = 5
            }
            
            cdProduct.nutriScore = cdNutriScore
        }
        
        saveInHistory(cdProduct: cdProduct, productIsAFavorite: productIsAFavorite)
    }
    
    private func saveInHistory(cdProduct: CDProduct, productIsAFavorite: Bool) {
        let cdHistory: CDHistory

        let request: NSFetchRequest<CDHistory> = CDHistory.fetchRequest()

        if let cdHistories = try? context.fetch(request),
           !cdHistories.isEmpty  {
            cdHistory = cdHistories[0]
        } else {
            cdHistory = CDHistory(context: context)
        }

        guard let cdHistoryProducts = cdHistory.products,
              let productsArray = Array(cdHistoryProducts) as? [CDProduct],
              !productsArray.isEmpty  else {
                  cdHistory.products = [cdProduct]

                  saveContext()

                  return
              }
        
        let maxRangeToAdd = productsArray.count < maxHistory - 1
        ? productsArray.count - 1
        : maxHistory - 2
        cdHistory.products = NSOrderedSet(array: [cdProduct] + productsArray[0...maxRangeToAdd])
        
        let minRangeToDelete = productsArray.count < maxHistory - 1
        ? productsArray.count
        : maxHistory - 1
        let productsToDelete = productsArray[minRangeToDelete...]
        
        let favoritesProducts = getFavoritesProducts()
        let newCDHistoryProducts = cdHistory.mutableOrderedSetValue(forKey: "products")
                
        productsToDelete.forEach { cdProduct in
            guard let id = cdProduct.id else { return }
            
            guard favoritesProducts.contains(where: { $0.id == id })
            else {
                deleteProduct(withID: id)
                return
            }
            
            newCDHistoryProducts.remove(cdProduct)
        }
        cdHistory.products = newCDHistoryProducts
        
        let cdFavorites = getCDFavorites() ?? CDFavorites(context: context)
        
        if productIsAFavorite {
            guard let cdFavoritesProducts = cdFavorites.products,
                  let productsArray = Array(cdFavoritesProducts) as? [CDProduct],
                  !productsArray.isEmpty
            else {
                cdFavorites.products = [cdProduct]
                saveContext()
                return
            }

            cdFavorites.products = NSOrderedSet(array: [cdProduct] + productsArray)
        }
        
        saveContext()
    }
    
    func saveInFavorites(product nuProduct: NUProduct) {
        guard let cdProduct = getProduct(withID: nuProduct.id) else {
            return
        }
        
        let cdFavorites = getCDFavorites() ?? CDFavorites(context: context)
        
        guard let cdFavoritesProducts = cdFavorites.products,
              let productsArray = Array(cdFavoritesProducts) as? [CDProduct],
              !productsArray.isEmpty
        else {
            cdFavorites.products = [cdProduct]
            saveContext()
            return
        }

        cdFavorites.products = NSOrderedSet(array: [cdProduct] + productsArray)
        saveContext()
    }
    
    // MARK: Read operations
    
    private func getProduct(withID id: String) -> CDProduct? {
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        
        guard let cdProducts = try? context.fetch(request),
              let cdProduct = cdProducts.first
        else {
            return nil
        }
        
        return cdProduct
    }
    
    func getHistoryProducts() -> [NUProduct] {
        let request: NSFetchRequest<CDHistory> = CDHistory.fetchRequest()
        request.fetchLimit = maxHistory
        
        guard let cdHistory = try? context.fetch(request),
              !cdHistory.isEmpty,
              let cdProducts = cdHistory[0].products
        else { return [] }
        
        return cdProducts.compactMap { cdProduct -> NUProduct?  in
            guard let nuProduct = NUProduct(from: cdProduct as! CDProduct) else {
                return nil
            }
            return nuProduct
        }
    }
    
    func getFavoritesProducts() -> [NUProduct] {
        let request: NSFetchRequest<CDFavorites> = CDFavorites.fetchRequest()
        
        guard let cdFavorites = try? context.fetch(request),
              !cdFavorites.isEmpty,
              let cdProducts = cdFavorites[0].products
        else { return [] }
        
        return cdProducts.compactMap { cdProduct -> NUProduct?  in
            guard let nuProduct = NUProduct(from: cdProduct as! CDProduct)
            else {
                return nil
            }
//
            return nuProduct
        }
    }
    
    func productIsAFavorite(_ product: NUProduct) -> Bool {
        getFavoritesProducts().contains { $0.id == product.id }
    }
    
    private func getCDFavorites() -> CDFavorites? {
        let request: NSFetchRequest<CDFavorites> = CDFavorites.fetchRequest()
        
        if let cdFavorites = try? context.fetch(request),
           !cdFavorites.isEmpty
        { return cdFavorites[0] }
        else { return nil }
    }
    
    private func getCDHistoryProducts() -> [CDProduct]? {
        let request: NSFetchRequest<CDHistory> = CDHistory.fetchRequest()
        
        if let cdHistories = try? context.fetch(request),
           !cdHistories.isEmpty,
           let cdProducts = cdHistories[0].products,
           let cdProductsArray = Array(cdProducts) as? [CDProduct]
        { return cdProductsArray }
        else { return nil }
    }
    
    // MARK: Update operations
    
    func moveFavoritesProduct(from: IndexSet, to: Int) {
        guard let cdFavorites = getCDFavorites()
        else { return }

        let cdFavoritesProducts = cdFavorites.mutableOrderedSetValue(forKey: "products")
        let fromInt = from[from.startIndex]
        
        fromInt >= to
        ? cdFavoritesProducts.moveObjects(at: from, to: to)
        : cdFavoritesProducts.moveObjects(at: from, to: to - 1)
        
        cdFavorites.products = cdFavoritesProducts
        
        saveContext()
    }
    
    
    // MARK: Delete operations
    
    private func deleteProduct(withID id: String) {
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        guard let cdProducts = try? context.fetch(request),
              !cdProducts.isEmpty
        else { return }
        
        cdProducts.forEach { cdProduct in
            context.delete(cdProduct)
        }
    }
    
    func removeProductFromFavorites(_ nuProduct: NUProduct) {
        let productID = nuProduct.id
        
        guard let cdProduct = getProduct(withID: productID)
        else { return }
        
        guard let cdFavorites = getCDFavorites(),
              let cdFavoritesProducts = cdFavorites.products,
              let cdFavoritesProductsArray = Array(cdFavoritesProducts) as? [CDProduct],
              !cdFavoritesProductsArray.isEmpty
        else { return }
        
        if let cdHistoryProducts = getCDHistoryProducts(),
           cdHistoryProducts.contains(where: { $0 == cdProduct})
        {
            cdFavorites.products = NSOrderedSet(array: cdFavoritesProductsArray.filter { $0 != cdProduct })
        } else {
            deleteProduct(withID: productID)
        }
        
        saveContext()
    }
}

extension NUProduct {
    init?(from cdProduct: CDProduct) {
        guard let cdID = cdProduct.id,
              let cdName = cdProduct.name else {
                  return nil
              }
        
        self.id = cdID
        self.name = cdName
        
        self.imageURL = cdProduct.imageURL
        
        if let cdNutriments = cdProduct.nutriments {
            var cdFiber_100g: Float?
            var cdCarbohydrates_100g: Float?
            var cdProteins_100g: Float?
            var cdFat_100g: Float?
            var cdSalt_100g: Float?
            var cdEnergy_kj_100g: Int? = nil
            var cdEnergy_kcal_100g: Int? = nil
            
            if let fiber_100g = cdNutriments.fiber_100g {
                cdFiber_100g = Float(truncating: fiber_100g)
            }
            if let carbohydrates_100g = cdNutriments.carbohydrates_100g {
                cdCarbohydrates_100g = Float(truncating: carbohydrates_100g)
            }
            if let proteins_100g = cdNutriments.proteins_100g {
                cdProteins_100g = Float(truncating: proteins_100g)
            }
            if let fat_100g = cdNutriments.fat_100g {
                cdFat_100g = Float(truncating: fat_100g)
            }
            if let salt_100g = cdNutriments.salt_100g {
                cdSalt_100g = Float(truncating: salt_100g)
            }
            if let energy_kj_100g = cdNutriments.energy_kj_100g {
                cdEnergy_kj_100g = Int(truncating: energy_kj_100g)
            }
            if let energy_kcal_100g = cdNutriments.energy_kcal_100g {
                cdEnergy_kcal_100g = Int(truncating: energy_kcal_100g)
            }

            self.nutriments = Nutriments(
                fiber_100g: cdFiber_100g,
                carbohydrates_100g: cdCarbohydrates_100g,
                proteins_100g: cdProteins_100g,
                fat_100g: cdFat_100g,
                salt_100g: cdSalt_100g,
                energy_kj_100g: cdEnergy_kj_100g,
                energy_kcal_100g: cdEnergy_kcal_100g
            )
        } else {
            self.nutriments = nil
        }
        
        if let cdNutriScore = cdProduct.nutriScore {
            var grade: NutriScore.Grade?
            
            switch cdNutriScore.grade {
            case 1:
                grade = .a
            case 2:
                grade = .b
            case 3:
                grade = .c
            case 4:
                grade = .d
            case 5:
                grade = .e
            default:
                grade = nil
            }
            
            var cdScore: Int?
            var cdNegative_points: Int?
            var cdPositive_points: Int?
            
            if let score = cdNutriScore.score {
                cdScore = Int(truncating: score)
            }
            if let negative_points = cdNutriScore.negative_points {
                cdNegative_points = Int(truncating: negative_points)
            }
            if let positive_points = cdNutriScore.positive_points {
                cdPositive_points = Int(truncating: positive_points)
            }

            self.nutriScore = NutriScore(
                score: cdScore,
                negative_points: cdNegative_points,
                positive_points: cdPositive_points,
                grade: grade
            )
        } else {
            self.nutriScore = nil
        }
        
        switch cdProduct.novaGroup {
        case 1:
            self.novaGroup = .one
        case 2:
            self.novaGroup = .two
        case 3:
            self.novaGroup = .three
        case 4:
            self.novaGroup = .four
        default:
            self.novaGroup = nil
        }
        
        if let cdEcoScore = cdProduct.ecoScore {
            var score: Int?
            var scores: EcoScore.Scores?
            var grade: EcoScore.Grade?
            var grades: EcoScore.Grades?
            var agribalyse: EcoScore.Agribalyse?
            var adjustments: EcoScore.Adjustments?
            
            if let cdScore = cdEcoScore.score {
                score = Int(truncating: cdScore)
            }
            if let cdScore_fr = cdEcoScore.score_fr {
                scores = EcoScore.Scores(fr: Int(truncating: cdScore_fr))
            }

            switch cdEcoScore.grade {
            case 1:
                grade = .a
            case 2:
                grade = .b
            case 3:
                grade = .c
            case 4:
                grade = .d
            case 5:
                grade = .e
            default:
                grade = nil
            }
            
            switch cdEcoScore.grade_fr {
            case 1:
                grades = EcoScore.Grades(fr: .a)
            case 2:
                grades = EcoScore.Grades(fr: .b)
            case 3:
                grades = EcoScore.Grades(fr: .c)
            case 4:
                grades = EcoScore.Grades(fr: .d)
            case 5:
                grades = EcoScore.Grades(fr: .e)
            default:
                grades = nil
            }
            
            if let score = cdEcoScore.agribalyse?.score {
                agribalyse = EcoScore.Agribalyse(score: Int(truncating: score))
            }
            
            if let cdAdjustments = cdEcoScore.adjustments {
                typealias ProductionSystem = EcoScore.Adjustments.ProductionSystem
                typealias OriginsOfIngredients = EcoScore.Adjustments.OriginsOfIngredients
                typealias Packaging = EcoScore.Adjustments.Packaging
                typealias ThreatenedSpecies = EcoScore.Adjustments.ThreatenedSpecies
                
                var production_system: ProductionSystem
                var origins_of_ingredients: OriginsOfIngredients
                var packaging: Packaging
                var threatened_species: ThreatenedSpecies
                
                if let cdProductionSystem = cdAdjustments.production_system,
                   let cdValue = cdProductionSystem.value
                {
                    production_system = ProductionSystem(value: Int(truncating: cdValue))
                } else {
                    production_system = ProductionSystem(value: nil)
                }
                
                if let cdOriginOfIngedients = cdAdjustments.origins_of_ingredients {
                    typealias TransportationValues = EcoScore.Adjustments.OriginsOfIngredients.TransportationValues
                    
                    var transportation_value: Int?
                    var transportation_values: TransportationValues?
                    var epi_value: Int?
                    
                    if let cdTransportation_value = cdOriginOfIngedients.transportation_value {
                        transportation_value = Int(truncating: cdTransportation_value)
                    }
                    if let cdTransportation_value_fr = cdOriginOfIngedients.transportation_value_fr {
                        transportation_values = TransportationValues(fr: Int(truncating: cdTransportation_value_fr))
                    }
                    if let cdEpi_value = cdOriginOfIngedients.epi_value {
                        epi_value = Int(truncating: cdEpi_value)
                    }

                    origins_of_ingredients = OriginsOfIngredients(
                        transportation_value: transportation_value,
                        transportation_values: transportation_values,
                        epi_value: epi_value
                    )
                } else {
                    origins_of_ingredients = OriginsOfIngredients(
                        transportation_value: nil,
                        transportation_values: nil,
                        epi_value: nil
                    )
                }
                
                if let cdPackaging = cdAdjustments.packaging {
                    var cdValue: Int?
                    
                    if let value = cdPackaging.value {
                        cdValue = Int(truncating: value)
                    }
                    
                    packaging = Packaging(value: cdValue)
                } else {
                    packaging = Packaging(value: nil)
                }
                
                if let cdThreatenedSpecies = cdAdjustments.threatened_species {
                    var cdValue: Int?
                    
                    if let value = cdThreatenedSpecies.value {
                        cdValue = Int(truncating: value)
                    }

                    threatened_species = ThreatenedSpecies(value: cdValue)
                } else {
                    threatened_species = ThreatenedSpecies(value: nil)
                }
                
                adjustments = EcoScore.Adjustments(
                    production_system: production_system,
                    origins_of_ingredients: origins_of_ingredients,
                    packaging: packaging,
                    threatened_species: threatened_species
                )
            } else {
                adjustments = nil
            }

            self.ecoScore = EcoScore(
                score: score,
                scores: scores,
                grade: grade,
                grades: grades,
                agribalyse: agribalyse,
                adjustments: adjustments
            )
        } else {
            self.ecoScore = nil
        }
    }
}
