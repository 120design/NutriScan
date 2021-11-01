//
//  CoreDataPreview.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 01/11/2021.
//

import CoreData

extension StorageManager {
    static var preview: StorageManager = {
        let result = StorageManager(.inMemory, maxHistory: 10)
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
}
