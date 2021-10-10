//
//  StorageManager.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 06/10/2021.
//

import Foundation
import CoreData

protocol StorageManagerProtocol {
    func create(product nuProduct: NUProduct)
    func getAllProducts() -> [NUProduct]
}

enum StorageType {
    case persistent, inMemory
}

class StorageManager: StorageManagerProtocol {
    static let shared = StorageManager()
    
    static var preview: StorageManager = {
        let result = StorageManager(.inMemory)
        let context = result.persistentContainer.viewContext
        for _ in 0..<10 {
            let cdNutriments = CDNutriments(context: context)
            cdNutriments.fiber_100g = 0.4
            cdNutriments.carbohydrates_100g = 9.8
            cdNutriments.proteins_100g = 3.57
            cdNutriments.fat_100g = 1.8
            cdNutriments.salt_100g = 0.00014
            cdNutriments.energy_kj_100g = 296
            cdNutriments.energy_kcal_100g = 70
            
            var cdNutriscore = CDNutriScore(context: context)
            cdNutriscore.score = 1
            cdNutriscore.negative_points = 3
            cdNutriscore.positive_points = 2
            cdNutriscore.grade = 2
            
            var cdAgribalyse = CDAgribalyse(context: context)
            cdAgribalyse.score = 52
            
            var cdOriginsOfIngredients = CDOriginsOfIngredients(context: context)
            cdOriginsOfIngredients.transportation_value_fr = 0
            cdOriginsOfIngredients.epi_value = -5
            
            var cdPackaging = CDPackaging(context: context)
            cdPackaging.value = -13
            
            var cdAdjustments = CDAdjustments(context: context)
            cdAdjustments.origins_of_ingredients = cdOriginsOfIngredients
            cdAdjustments.packaging = cdPackaging
            
            var cdEcoScore = CDEcoScore(context: context)
            cdEcoScore.score = 39
            cdEcoScore.score_fr = 34
            cdEcoScore.grade = 4
            cdEcoScore.grade_fr = 4
            cdEcoScore.agribalyse = cdAgribalyse

            let cdProduct = CDProduct(context: context)
            cdProduct.id = "7613035239562"
            cdProduct.name = "Nesquik"
            cdProduct.imageURL = "https://images.openfoodfacts.org/images/products/761/303/523/9562/front_fr.185.400.jpg"
            cdProduct.nutriments = cdNutriments
            cdProduct.nutriScore = cdNutriscore
            cdProduct.novaGroup = 4
        }
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let persistentContainer: NSPersistentContainer
    
    init(_ storageType: StorageType = .persistent) {
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
        
    func create(product nuProduct: NUProduct) {
        deleteProduct(with: nuProduct.id)
        
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
                cdNutriments.fiber_100g = fiber_100g
            }
            if let carbohydrates_100g = nutriments.carbohydrates_100g {
                cdNutriments.carbohydrates_100g = carbohydrates_100g
            }
            if let proteins_100g = nutriments.proteins_100g {
                cdNutriments.proteins_100g = proteins_100g
            }
            if let fat_100g = nutriments.fat_100g {
                cdNutriments.fat_100g = fat_100g
            }
            if let salt_100g = nutriments.salt_100g {
                cdNutriments.salt_100g = salt_100g
            }
            if let energy_kj_100g = nutriments.energy_kj_100g {
                cdNutriments.energy_kj_100g = Int16(energy_kj_100g)
            }
            if let energy_kcal_100g = nutriments.energy_kcal_100g {
                cdNutriments.energy_kcal_100g = Int16(energy_kcal_100g)
            }
            
            cdProduct.nutriments = cdNutriments
        }
        
        if let ecoScore = nuProduct.ecoScore {
            cdEcoScore = CDEcoScore(context: context)
            
            var cdAdjustments: CDAdjustments
            
            cdEcoScore.score = Int16(ecoScore.score)
            
            if let score_fr = ecoScore.score_fr {
                cdEcoScore.score_fr = Int16(score_fr)
            }
            
            switch ecoScore.grade {
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
            
            if let grade_fr = ecoScore.grade_fr {
                switch grade_fr {
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
            }
            
            let cdAgribalyse = CDAgribalyse(context: context)
            cdAgribalyse.score = Int16(ecoScore.agribalyse.score)
            cdEcoScore.agribalyse = cdAgribalyse
            
            if let adjustments = ecoScore.adjustments {
                cdAdjustments = CDAdjustments(context: context)
                
                var cdProductionSystem: CDProductionSystem
                var cdOriginsOfIngredients: CDOriginsOfIngredients
                var cdPackaging: CDPackaging
                var cdThreatenedSpecies: CDThreatnenedSpecies
                
                if let value = adjustments.production_system.value {
                    cdProductionSystem = CDProductionSystem(context: context)
                    cdProductionSystem.value = Int16(value)
                    
                    cdAdjustments.production_system = cdProductionSystem
                }
                
                if adjustments.origins_of_ingredients.transportation_value != nil
                    || adjustments.origins_of_ingredients.transportation_value_fr != nil
                    || adjustments.origins_of_ingredients.epi_value != nil {
                    cdOriginsOfIngredients = CDOriginsOfIngredients(context: context)
                    
                    let origins_of_ingredients = adjustments.origins_of_ingredients
                    
                    if let transportation_value = origins_of_ingredients.transportation_value {
                        cdOriginsOfIngredients.transportation_value = Int16(transportation_value)
                    }
                    
                    if let transportation_value_fr = origins_of_ingredients.transportation_value_fr {
                        cdOriginsOfIngredients.transportation_value_fr = Int16(transportation_value_fr)
                    }
                    
                    if let epi_value = origins_of_ingredients.epi_value {
                        cdOriginsOfIngredients.epi_value = Int16(epi_value)
                    }
                    
                    cdAdjustments.origins_of_ingredients = cdOriginsOfIngredients
                }
                
                if let value = adjustments.packaging.value {
                    cdPackaging = CDPackaging(context: context)
                    cdPackaging.value = Int16(value)
                    
                    cdAdjustments.packaging = cdPackaging
                }
                
                if let value = adjustments.threatened_species.value {
                    cdThreatenedSpecies = CDThreatnenedSpecies(context: context)
                    cdThreatenedSpecies.value = Int16(value)
                    
                    cdAdjustments.threatened_species = cdThreatenedSpecies
                }
                
                cdEcoScore.adjustments = cdAdjustments
            }
            
            cdProduct.ecoScore = cdEcoScore
        }
        
        if let nutriScore = nuProduct.nutriScore {
            cdNutriScore = CDNutriScore(context: context)
            
            cdNutriScore.score = Int16(nutriScore.score)
            cdNutriScore.negative_points = Int16(nutriScore.negative_points)
            cdNutriScore.positive_points = Int16(nutriScore.positive_points)
            
            switch nutriScore.grade {
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
        
        saveContext()
    }
    
    func getAllProducts() -> [NUProduct] {
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        
        guard let cdProducts = try? context.fetch(request),
              !cdProducts.isEmpty else {
                  return []
              }
        
        return cdProducts.compactMap { NUProduct(from: $0) }
    }
    
    private func deleteProduct(with id: String) {
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        
        guard let cdProducts = try? context.fetch(request),
              !cdProducts.isEmpty else {
                  return
              }
        
        cdProducts.forEach { cdProduct in
            context.delete(cdProduct)
        }
    }
    
//    func deleteCurrentGame() {
//        let request: NSFetchRequest<CDGame> = CDGame.fetchRequest()
//        guard let cdGames = try? context.fetch(request),
//              !cdGames.isEmpty else { return }
//        cdGames.forEach { (cdGame) in
//            context.delete(cdGame)
//        }
//        saveContext()
//    }
    
//    private func fetchCDTask(with taskId: UUID) -> CDTask? {
//        let fetchRequest: NSFetchRequest<CDTask> = CDTask.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "id == %@", taskId as CVarArg)
//        fetchRequest.fetchLimit = 1
//        guard let fetchResult = try? context.fetch(fetchRequest) else {
//            return nil
//        }
//        return fetchResult.first
//    }
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
            self.nutriments = Nutriments(
                fiber_100g: cdNutriments.fiber_100g,
                carbohydrates_100g: cdNutriments.carbohydrates_100g,
                proteins_100g: cdNutriments.proteins_100g,
                fat_100g: cdNutriments.fat_100g,
                salt_100g: cdNutriments.salt_100g,
                energy_kj_100g: Int(cdNutriments.energy_kj_100g),
                energy_kcal_100g: Int(cdNutriments.energy_kcal_100g)
            )
        } else {
            self.nutriments = nil
        }
        
        if let cdNutriScore = cdProduct.nutriScore {
            var grade: NutriScore.Grade
            
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
                grade = .e
            }
            
            self.nutriScore = NutriScore(
                score: Int(cdNutriScore.score),
                negative_points: Int(cdNutriScore.negative_points),
                positive_points: Int(cdNutriScore.positive_points),
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
            var grade: EcoScore.Grade
            var grade_fr: EcoScore.Grade?
            var adjustments: EcoScore.Adjustments?

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
                grade = .e
            }
            
            switch cdEcoScore.grade_fr {
            case 1:
                grade_fr = .a
            case 2:
                grade_fr = .b
            case 3:
                grade_fr = .c
            case 4:
                grade_fr = .d
            case 5:
                grade_fr = .e
            default:
                grade_fr = nil
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

                if let cdProductionSystem = cdAdjustments.production_system {
                    production_system = ProductionSystem(value: Int(cdProductionSystem.value))
                } else {
                    production_system = ProductionSystem(value: nil)
                }
                
                if let cdOriginOfIngedients = cdAdjustments.origins_of_ingredients {
                    origins_of_ingredients = OriginsOfIngredients(
                        transportation_value: Int(cdOriginOfIngedients.transportation_value),
                        transportation_value_fr: Int(cdOriginOfIngedients.transportation_value_fr),
                        epi_value: Int(cdOriginOfIngedients.epi_value)
                    )
                } else {
                    origins_of_ingredients = OriginsOfIngredients(
                        transportation_value: nil,
                        transportation_value_fr: nil,
                        epi_value: nil
                    )
                }
                
                if let cdPackaging = cdAdjustments.packaging {
                    packaging = Packaging(value: Int(cdPackaging.value))
                } else {
                    packaging = Packaging(value: nil)
                }
                
                if let cdThreatenedSpecies = cdAdjustments.threatened_species {
                    threatened_species = ThreatenedSpecies(value: Int(cdThreatenedSpecies.value))
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
                score: Int(bitPattern: cdEcoScore.id),
                score_fr: Int(cdEcoScore.score_fr),
                grade: grade,
                grade_fr: grade_fr,
                agribalyse: EcoScore.Agribalyse(
                    score: Int(cdEcoScore.agribalyse?.score ?? 0)
                ),
                adjustments: adjustments
            )
        } else {
            self.ecoScore = nil
        }
    }
}
