			Projet Profusion of chaos





	Petit détail sur les dossiers :

Les différentes parties du projet sont rangées dans leur dossier respectifs :
- Static : est rangé dedans le code static, donc utilisable depuis 
n'importe où (sans devoir importer le code) dans le projet ;
- Ressource : est rangé dedans les différentes données que le jeu 
utilise (les données des attaques, celles des objets ou des PNJs) ;
- Autoload : est rangé dedans le code utilisé pour le fonctionnement 
du jeu (la conservation des objets dans l'inventaire, la gestion des 
poings de vie), ça permet aussi d'empêcher les dépendances entre deux scènes ;
- Scene : est rangé dedans les scènes du jeu (et leurs codes liés), on y trouve
 les acteurs (PNJ, Ennemy et Character), les niveaux (HUB, salles de donjon, 
donjon lui-même, etc), les objets interactifs (pots cassables, coffres, etc), 
les comportements de certains systèmes et l'UI (le menu principal, 
l'interface de commerce des PNJs) ;
- StateMachine : est rangé les différentes machines d'états (elles permettent 
de déterminer l'état d'une scène) ;


	Petit détail sur certains fonctionnement :

Les StateMachines : Elle permettent de déterminé dans quel état est une 
entité (un objet intéractif comme un acteur), cette chose ne pouvant avoir 
deux états d'une même state machine en même temps. ça permet d'empêcher la 
superpostion des états quand on fait faire des actions à notre entité (par exemple pour l'empêcher de se déplacer pendant qu'elle attaque).



