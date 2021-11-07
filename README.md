# NutriScan

## Votre laboratoire de poche

### Présentation

NutriScan est une application qui affiche les analyses nutritionnelles d’un produit dont l’utilisateur renseigne son code EAN soit en scannant le code à barres du produit, soit en tapant ce code.

L’application consomme l’API Open Food Facts qui recense plus de 700 000 produits avec :

1. leur composition nutritionnnelle (lipides, glucides, protéines, etc.),
1. leur Nutri-Score qui informe sur les qualités nutritionnelles du produit,
1. leur Eco-score qui indique l’empreinte écologique du produit,
1. leur classification Nova pour connaître leur niveau de transformation.

Il existe plusieurs applications de ce type dont la plus connue est Yuka et NutriScan s’en différencie par un graphisme moins grand public et moins sage, des couleurs et des typographies qui s’adressent aux urbains de 35 à 50 ans amateurs de cyberpunk.

L’historique des trois dernières recherches est sauvegardée dans le téléphone mais une version payante de l’application propose :

1. de sauvegarder les dix dernières recherches de produits,
1. de conserver des produits favoris.

### Frameworks et dépendances

- SwiftUI 3 (compatible avec les iPhones à partir de l’iOS 15) et une architecture MVVM,
- le SPM CarBode pour scanner le code à barres avec l’appareil photo de l’iPhone,
- le SPM Kingfisher pour afficher les images de produits à partir de leur URL,
- CoreData pour persister l’historique de recherche et les favoris,
- StoreKit 2 (compatible avec les iPhones à partir de l’iOS 15) pour l’implémentation des achats _In-App_,
- XCTest pour tester la majorité de la logique du ViewModèle et du Modèle.
