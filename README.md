# Moteur de Recherche XML

Un système de recherche d'articles moderne utilisant XML/XSLT avec une interface web interactive. [lien du site web](https://sokhnadieye.github.io/MoteurDeRechercheXML)

## Table des matières

- [Aperçu du projet](#aperçu-du-projet)
- [Fonctionnalités](#fonctionnalités)
- [Structure du projet](#structure-du-projet)
- [Technologies utilisées](#technologies-utilisées)
- [Architecture technique](#architecture-technique)

## Aperçu du projet

Ce projet implémente un **moteur de recherche d'articles** avec deux approches complémentaires :

- **Transformation XSLT** : Génération de HTML à partir de données XML
- **Interface web interactive** : Recherche dynamique côté client avec JavaScript

Le système permet de filtrer une collection de 12 articles selon différents critères : mot-clé, auteur, date et catégorie.

## Fonctionnalités

### Recherche multi-critères

-  **Recherche par mot-clé** : Insensible à la casse dans titre, contenu et tags
-  **Recherche par auteur** : Filtrage par auteur exact
-  **Recherche par date** : Filtrage par date de publication
-  **Recherche par catégorie** : Filtrage par catégorie d'article

### Interface utilisateur

-  **Design responsive** : Compatible mobile avec Bootstrap 5
-  **Interface moderne** : Cards avec animations et effets hover
-  **Pagination** : 10 articles par page
-  **Tri automatique** : Articles triés par date décroissante
-  **Format de date** : Conversion YYYY-MM-DD vers DD/MM/YYYY

## Structure du projet

```
MoteurDeRechercheXML/
├── index.html              # Interface principale de recherche
├── README.md               # Documentation du projet
├── css/
│   └── custom.css         # Styles personnalisés
├── data/
│   └── articles.xml       # Base de données XML (12 articles)
├── js/
│   └── script.js          # Logique de recherche JavaScript
└── xsl/
    └── articles.xsl       # Templates XSLT pour transformation
```

## Technologies utilisées

### Frontend

- **HTML5** : Structure sémantique
- **CSS3** : Animations et transitions personnalisées
- **Bootstrap 5.3.0** : Framework CSS responsive
- **Font Awesome 6.4.0** : Icônes vectorielles
- **JavaScript ES6+** : Logique de recherche dynamique

### Données et transformation

- **XML 1.0** : Format de données structurées
- **XSLT 1.0** : Transformation XML vers HTML
- **XPath** : Requêtes pour filtrage des données

## Architecture technique

### Structure des données XML

Chaque article contient les champs suivants :

```xml
<article id="1">
    <title>Titre de l'article</title>
    <author>Nom de l'auteur</author>
    <date>2024-01-15</date>
    <category>Catégorie</category>
    <content>Contenu complet de l'article...</content>
    <tags>tag1, tag2, tag3</tags>
    <keywords>mot-clé1, mot-clé2</keywords>
</article>
```

### Templates XSLT spécialisés

- `match="/"` : Template principal générant la structure HTML
- `name="article-card"` : Template pour l'affichage d'une carte d'article
- `name="format-date"` : Template pour formater les dates DD/MM/YYYY
- `mode="search-keyword"` : Template de recherche par mot-clé
- `mode="search-author"` : Template de recherche par auteur
- `mode="search-date"` : Template de recherche par date
- `mode="search-category"` : Template de recherche par catégorie

### Logique JavaScript

- **Chargement XML** : Fetch API pour récupérer les données
- **Filtrage dynamique** : Fonctions de recherche avec RegExp
- **Manipulation DOM** : Génération dynamique des cartes d'articles
- **Pagination** : Gestion de l'affichage par pages

---

_Projet développé dans le cadre d'un examen XML - Août 2025_
