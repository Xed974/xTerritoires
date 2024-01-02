cfg = cfg or {}

cfg = {
    MarkerColorR = 0, -- https://www.google.com/search?q=html+color+picker&rlz=1C1GCEA_enFR965FR965&oq=html+color+&aqs=chrome.2.69i59j0i131i433i512j0i512l5j69i60.3367j0j7&sourceid=chrome&ie=UTF-8
    MarkerColorG = 0, -- https://www.google.com/search?q=html+color+picker&rlz=1C1GCEA_enFR965FR965&oq=html+color+&aqs=chrome.2.69i59j0i131i433i512j0i512l5j69i60.3367j0j7&sourceid=chrome&ie=UTF-8
    MarkerColorB = 0, -- https://www.google.com/search?q=html+color+picker&rlz=1C1GCEA_enFR965FR965&oq=html+color+&aqs=chrome.2.69i59j0i131i433i512j0i512l5j69i60.3367j0j7&sourceid=chrome&ie=UTF-8
    MarkerOpacite = 200, 
    MarkerSaute = false, 
    MarkerTourne = false,
    TextureDictionary = "root_cause5",
    TextureName = "img_red", --Couleur de la banière : img_red, img_bleu, img_vert, img_jaune, img_violet, img_gris, img_grisf, img_orange
    CouleurMenu = "r", --"r" = rouge, "b" = bleu, "g" = vert, "y" = jaune, "p" = violet, "c" = gris, "m" = gris foncé, "u" = noir, "o" = orange
    cmdSell = "drugsell",

    refreshOwnerZone = 10000,
    randomPoucave = 3, -- 1 chance sur 3 que une poucave prévient de la vente  dans la zone
    percentageAdd = 1.05, -- +5% du prix de base pour les propriétaires des zones 
    JobPolice = {"police", "sherrif"},
    PoliceRequis = 0,
    Drugs = {
        { Label =  "Weed", Name = "weed", MinPrice = 10, MaxPrice = 20, countMin = 1, countMax = 3 },
        { Label =  "Cocaine", Name = "coke", MinPrice = 15, MaxPrice = 25, countMin = 2, countMax = 4 }
    },
    messageAccept = {
        "Bien vu, t'es un bon mec.",
        "Ca à intérêt d'être de la bonne !"
    },
    messageRefus = {
        "Je ne suis pas intéressé",
        "Casse toi avec ta came de merde"
    },
    messagePoucave = {
        "J'ai vu quelqu'un vendre sur notre zone",
    }
}
