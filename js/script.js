let currentPage = 1;
const articlesPerPage = 10;
let allArticles = [];
let filteredArticles = [];

// Initialisation
document.addEventListener('DOMContentLoaded', async function() {
    await loadArticles();
    populateAuthors();
    displayArticles();
});

// Fonction pour charger les données XML depuis le fichier externe
async function loadArticles() {
    try {
        const response = await fetch('./data/articles.xml');
        if (!response.ok) {
            throw new Error('Erreur de chargement du fichier XML');
        }
        const xmlString = await response.text();
        const parser = new DOMParser();
        const xmlDoc = parser.parseFromString(xmlString, "text/xml");
        const articles = xmlDoc.getElementsByTagName("article");
        
        allArticles = Array.from(articles).map(article => ({
            id: article.getAttribute('id'),
            title: article.getElementsByTagName('title')[0].textContent,
            author: article.getElementsByTagName('author')[0].textContent,
            date: article.getElementsByTagName('date')[0].textContent,
            category: article.getElementsByTagName('category')[0].textContent,
            content: article.getElementsByTagName('content')[0].textContent,
            tags: article.getElementsByTagName('tags')[0].textContent,
            keywords: article.getElementsByTagName('keywords')[0]?.textContent || ''
        }));
        
        filteredArticles = [...allArticles];
    } catch (error) {
        console.error('Erreur lors du chargement des articles:', error);
        // Afficher un message d'erreur à l'utilisateur
        document.getElementById('results-container').innerHTML = `
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle me-2"></i>
                Impossible de charger les articles. Veuillez réessayer plus tard.
            </div>`;
    }
}

function populateAuthors() {
    const authors = [...new Set(allArticles.map(article => article.author))];
    const authorSelect = document.getElementById('author');
    
    // Vider les options existantes
    authorSelect.innerHTML = '<option value="">Tous les auteurs</option>';
    
    // Ajouter les nouvelles options
    authors.forEach(author => {
        const option = document.createElement('option');
        option.value = author;
        option.textContent = author;
        authorSelect.appendChild(option);
    });
}

function searchArticles() {
    const keyword = document.getElementById('keyword').value.toLowerCase();
    const author = document.getElementById('author').value;
    const date = document.getElementById('date').value;

    filteredArticles = allArticles.filter(article => {
        const matchKeyword = !keyword || 
            article.title.toLowerCase().includes(keyword) ||
            article.content.toLowerCase().includes(keyword) ||
            article.tags.toLowerCase().includes(keyword) ||
            article.keywords.toLowerCase().includes(keyword);
        
        const matchAuthor = !author || article.author === author;
        const matchDate = !date || article.date === date;

        return matchKeyword && matchAuthor && matchDate;
    });

    currentPage = 1;
    displayArticles();
}

function resetSearch() {
    document.getElementById('keyword').value = '';
    document.getElementById('author').value = '';
    document.getElementById('date').value = '';
    filteredArticles = [...allArticles];
    currentPage = 1;
    displayArticles();
}

function displayArticles() {
    const startIndex = (currentPage - 1) * articlesPerPage;
    const endIndex = startIndex + articlesPerPage;
    const pageArticles = filteredArticles.slice(startIndex, endIndex);

    const container = document.getElementById('results-container');
    
    if (pageArticles.length === 0) {
        container.innerHTML = `
            <div class="no-results">
                <i class="fas fa-search fa-3x mb-3 text-muted"></i>
                <h4>Aucun article trouvé</h4>
                <p>Essayez de modifier vos critères de recherche</p>
            </div>`;
        document.getElementById('resultCount').textContent = '0 articles trouvés';
        document.getElementById('pagination').innerHTML = '';
        return;
    }

    container.innerHTML = pageArticles.map(article => `
        <div class="article-card card h-100">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <h5 class="card-title text-primary">${article.title}</h5>
                    <span class="badge badge-custom text-white">${article.category}</span>
                </div>
                <div class="row mb-3">
                    <div class="col-sm-6">
                        <small class="text-muted">
                            <i class="fas fa-user me-1"></i>${article.author}
                        </small>
                    </div>
                    <div class="col-sm-6 text-sm-end">
                        <small class="text-muted">
                            <i class="fas fa-calendar me-1"></i>${formatDate(article.date)}
                        </small>
                    </div>
                </div>
                <p class="card-text">${article.content.substring(0, 150)}...</p>
                <div class="mt-3">
                    <small class="text-muted">
                        <i class="fas fa-tags me-1"></i>${article.tags}
                    </small>
                </div>
            </div>
        </div>
    `).join('');

    document.getElementById('resultCount').textContent = 
        `${filteredArticles.length} article${filteredArticles.length > 1 ? 's' : ''} trouvé${filteredArticles.length > 1 ? 's' : ''}`;
    
    updatePagination();
}

function updatePagination() {
    const totalPages = Math.ceil(filteredArticles.length / articlesPerPage);
    const pagination = document.getElementById('pagination');
    
    if (totalPages <= 1) {
        pagination.innerHTML = '';
        return;
    }

    let paginationHTML = '';
    
    // Bouton précédent
    if (currentPage > 1) {
        paginationHTML += `
            <li class="page-item">
                <a class="page-link" href="#" onclick="changePage(${currentPage - 1})">
                    <i class="fas fa-chevron-left"></i>
                </a>
            </li>`;
    }

    // Numéros de pages
    for (let i = 1; i <= totalPages; i++) {
        if (i === currentPage || i === 1 || i === totalPages || 
            (i >= currentPage - 1 && i <= currentPage + 1)) {
            paginationHTML += `
                <li class="page-item ${i === currentPage ? 'active' : ''}">
                    <a class="page-link" href="#" onclick="changePage(${i})">${i}</a>
                </li>`;
        } else if (i === currentPage - 2 || i === currentPage + 2) {
            paginationHTML += '<li class="page-item disabled"><span class="page-link">...</span></li>';
        }
    }

    // Bouton suivant
    if (currentPage < totalPages) {
        paginationHTML += `
            <li class="page-item">
                <a class="page-link" href="#" onclick="changePage(${currentPage + 1})">
                    <i class="fas fa-chevron-right"></i>
                </a>
            </li>`;
    }

    pagination.innerHTML = paginationHTML;
}

function changePage(page) {
    currentPage = page;
    displayArticles();
    // Scroll vers le haut des résultats
    document.getElementById('results-container').scrollIntoView({ behavior: 'smooth' });
}

function formatDate(dateString) {
    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    return new Date(dateString).toLocaleDateString('fr-FR', options);
}

// Recherche en temps réel sur le mot-clé
document.getElementById('keyword').addEventListener('input', function() {
    setTimeout(searchArticles, 300); // Délai de 300ms pour éviter trop de requêtes
});