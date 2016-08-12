/*  Fichier contenant la liste des ressources utilisées 
    ainsi que la méthode pour les précharger.
    Au final, toutes les images et sprites sont sockés dans 
    la variable de type array "ressources" */

var ressources = {};

var sources = {
    nesw: '/Images/nesw.svg',
    e: '/Images/e.svg',
    es: '/Images/es.svg',
    esw: '/Images/esw.svg',
    ew: '/Images/ew.svg',
    n: '/Images/n.svg',
    ne: '/Images/ne.svg',
    nes: '/Images/nes.svg',
    new: '/Images/new.svg',
    ns: '/Images/ns.svg',
    nsw: '/Images/nsw.svg',
    s: '/Images/s.svg',
    sw: '/Images/sw.svg',
    w: '/Images/w.svg',
    wn: '/Images/wn.svg',
}

function loadRessources(sources, callback) {
    var loadedRessource = 0;
    var num = 0;

    for (var s in sources) {
        num++;
    }
    for (var src in sources) {
        ressources[src] = new Image();
        ressources[src].onload = function () {
            if (++loadedRessource >= num) {
                callback(ressources);
            }
        };
        ressources[src].src = sources[src];
    }
}