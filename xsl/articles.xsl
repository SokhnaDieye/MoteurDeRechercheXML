<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" doctype-public="-//W3C//DTD HTML 4.01//EN" 
                doctype-system="http://www.w3.org/TR/html4/strict.dtd"/>

    <!-- Template principal -->
    <xsl:template match="/">
        <html lang="fr">
        <head>
            <meta charset="UTF-8"/>
            <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
            <title>Articles - Résultats de recherche</title>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet"/>
            <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet"/>
            <style>
                .article-card { 
                    transition: all 0.3s ease; 
                    border: none; 
                    border-radius: 15px; 
                    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1); 
                    margin-bottom: 20px; 
                }
                .article-card:hover { 
                    transform: translateY(-5px); 
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2); 
                }
                .badge-custom { 
                    background: linear-gradient(45deg, #667eea, #764ba2); 
                }
                .search-highlight {
                    background-color: #fff3cd;
                    padding: 2px 4px;
                    border-radius: 3px;
                }
            </style>
        </head>
        <body>
            <div class="container my-5">
                <div class="row">
                    <div class="col-12">
                        <h1 class="display-4 text-center mb-4">
                            <i class="fas fa-newspaper me-3"></i>Articles Trouvés
                        </h1>
                        <p class="text-center text-muted mb-5">
                            <xsl:value-of select="count(articles/article)"/> article(s) dans la collection
                        </p>
                    </div>
                </div>
                
                <div class="row">
                    <xsl:for-each select="articles/article">
                        <xsl:sort select="date" order="descending"/>
                        <div class="col-lg-6 col-xl-4">
                            <xsl:call-template name="article-card"/>
                        </div>
                    </xsl:for-each>
                </div>
            </div>
        </body>
        </html>
    </xsl:template>

    <!-- Template pour une carte d'article -->
    <xsl:template name="article-card">
        <div class="article-card card h-100">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <h5 class="card-title text-primary">
                        <xsl:value-of select="title"/>
                    </h5>
                    <span class="badge badge-custom text-white">
                        <xsl:value-of select="category"/>
                    </span>
                </div>
                
                <div class="row mb-3">
                    <div class="col-sm-6">
                        <small class="text-muted">
                            <i class="fas fa-user me-1"></i>
                            <xsl:value-of select="author"/>
                        </small>
                    </div>
                    <div class="col-sm-6 text-sm-end">
                        <small class="text-muted">
                            <i class="fas fa-calendar me-1"></i>
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="date" select="date"/>
                            </xsl:call-template>
                        </small>
                    </div>
                </div>
                
                <p class="card-text">
                    <xsl:choose>
                        <xsl:when test="string-length(content) > 150">
                            <xsl:value-of select="substring(content, 1, 150)"/>...
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="content"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </p>
                
                <div class="mt-3">
                    <small class="text-muted">
                        <i class="fas fa-tags me-1"></i>
                        <xsl:value-of select="tags"/>
                    </small>
                </div>
                
                <div class="mt-2">
                    <small class="text-info">
                        <i class="fas fa-key me-1"></i>
                        <xsl:value-of select="keywords"/>
                    </small>
                </div>
            </div>
        </div>
    </xsl:template>

    <!-- Template pour formater les dates -->
    <xsl:template name="format-date">
        <xsl:param name="date"/>
        <xsl:variable name="year" select="substring($date, 1, 4)"/>
        <xsl:variable name="month" select="substring($date, 6, 2)"/>
        <xsl:variable name="day" select="substring($date, 9, 2)"/>
        
        <xsl:value-of select="$day"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$month"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$year"/>
    </xsl:template>

    <!-- Template pour recherche par mot-clé -->
    <xsl:template match="articles" mode="search-keyword">
        <xsl:param name="keyword"/>
        <xsl:for-each select="article[contains(translate(title, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), translate($keyword, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')) or 
                                     contains(translate(content, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), translate($keyword, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')) or 
                                     contains(translate(tags, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), translate($keyword, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))]">
            <xsl:call-template name="article-card"/>
        </xsl:for-each>
    </xsl:template>

    <!-- Template pour recherche par auteur -->
    <xsl:template match="articles" mode="search-author">
        <xsl:param name="author-name"/>
        <xsl:for-each select="article[author=$author-name]">
            <xsl:call-template name="article-card"/>
        </xsl:for-each>
    </xsl:template>

    <!-- Template pour recherche par date -->
    <xsl:template match="articles" mode="search-date">
        <xsl:param name="search-date"/>
        <xsl:for-each select="article[date=$search-date]">
            <xsl:call-template name="article-card"/>    
        </xsl:for-each>
    </xsl:template>
    <!-- Template pour recherche par catégorie -->
    <xsl:template match="articles" mode="search-category">  
        <xsl:param name="category-name"/>
        <xsl:for-each select="article[category=$category-name]">
            <xsl:call-template name="article-card"/>
        </xsl:for-each>
    </xsl:template>
    <!-- Template pour recherche par mot-clé -->
    <xsl:template match="articles" mode="search-keyword">
        <xsl:param name="keyword"/>
        <xsl:for-each select="article[contains(translate(title, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), translate($keyword, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')) or 
                                     contains(translate(content, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), translate($keyword, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')) or 
                                     contains(translate(tags, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), translate($keyword, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'))]">
            <xsl:call-template name="article-card"/>
        </xsl:for-each>
    </xsl:template>
    <!-- Template pour recherche par auteur -->
    <xsl:template match="articles" mode="search-author">
        <xsl:param name="author-name"/>
        <xsl:for-each select="article[author=$author-name]">
            <xsl:call-template name="article-card"/>
        </xsl:for-each>
    </xsl:template>
    <!-- Template pour recherche par date -->
    <xsl:template match="articles" mode="search-date">
        <xsl:param name="search-date"/>
        <xsl:for-each select="article[date=$search-date]">
            <xsl:call-template name="article-card"/>    
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>