/*  Fichier contenant la liste des ressources utilisées 
    ainsi que la méthode pour les précharger.
    Au final, toutes les images et sprites sont sockés dans 
    la variable de type array "ressources" */

var ressources = {};

var sources = {
    nesw: '/Images/Png/nesw.png',
   // e: '/Images/Png/e.png',
    es: '/Images/Png/es.png',
    esw: '/Images/Png/esw.png',
    ew: '/Images/Png/ew.png',
   // n: '/Images/Png/n.png',
    ne: '/Images/Png/ne.png',
    nes: '/Images/Png/nes.png',
    new: '/Images/Png/new.png',
    ns: '/Images/Png/ns.png',
    nsw: '/Images/Png/nsw.png',
  //  s: '/Images/Png/s.png',
    sw: '/Images/Png/sw.png',
  //  w: '/Images/Png/w.png',
    wn: '/Images/Png/wn.png',

    svg_nesw: '/Images/Svg/nesw.svg',
    svg_e: '/Images/Svg/e.svg',
    svg_es: '/Images/Svg/es.svg',
    svg_esw: '/Images/Svg/esw.svg',
    svg_ew: '/Images/Svg/ew.svg',
    svg_n: '/Images/Svg/n.svg',
    svg_ne: '/Images/Svg/ne.svg',
    svg_nes: '/Images/Svg/nes.svg',
    svg_new: '/Images/Svg/new.svg',
    svg_ns: '/Images/Svg/ns.svg',
    svg_nsw: '/Images/Svg/nsw.svg',
    svg_s: '/Images/Svg/s.svg',
    svg_sw: '/Images/Svg/sw.svg',
    svg_w: '/Images/Svg/w.svg',
    svg_wn: '/Images/Svg/wn.svg',
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