//
//  Data.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 24.3.23..
//

import Foundation

class Data {
    var items = [
        DataModel(
            category: "ПРИРОДА",
            categoryEng: "NATURE",
            categoryLat: "PRIRODA",
            subcategory: [
                " Аде",
                " Водопади",
                " Заштићена подручја",
                " Излетишта и видиковци",
                " Језера",
                " Клисуре",
                " Пећине",
                " Планине",
                " Реке",
                " Чесме",
                " Извори"
            ],
            subcategotyLat: [
                "ADE",
                "VODOPADI",
                "Zaštićena područja",
                "Izletišta i vidikovci",
                "Jezera",
                "Klisure",
                "Pećine",
                "Planine",
                "Reke",
                "Česme",
                "Izvori"
            ],
            subcategoryEng: [
                "Ade",
                "Waterfalls",
                "Protected areas",
                "Excursions and viewpoints",
                "Lakes",
                "Gorges",
                "Caves",
                "Mountains",
                "Rivers",
                "Fountains",
                "Wellsprings"
            ],
            expanded: false,
            categoryImageData: "nature",
            imageData: [
                "nature1",
                "nature2",
                "nature3",
                "nature4",
                "nature5",
                "nature6",
                "nature7",
                "nature8",
                "nature9",
                "fountains",
                "wellsprings"
            ]
        ),
        DataModel(
            category: "БАЊЕ",
            categoryEng: "Spa",
            categoryLat: "Banje",
            subcategory: [""],
            subcategotyLat: [""],
            subcategoryEng: [""],
            expanded :false,
            categoryImageData: "spa",
            imageData: [""]
        ),
        DataModel(
            category: "ГРАДОВИ",
            categoryEng: "Cities",
            categoryLat: "Gradovi",
            subcategory: [""],
            subcategotyLat: [""],
            subcategoryEng: [""],
            expanded :false,
            categoryImageData: "cities",
            imageData: [""]
        ),
        DataModel(
            category: "ГРАЂЕВИНЕ",
            categoryEng: "Buildings",
            categoryLat: "Građevine",
            subcategory: [
                " Бране и хидроелектране",
                " Дворци и виле",
                " Мостови",
                " Народно градитељство",
                " Здања",
                " Спомен-куће",
                " Тврђаве",
                " Торњеви",
                " Храмови"
            ],
            subcategotyLat: [
                "Brane i hidroelektrane",
                "Dvorci i vile",
                "Mostovi",
                "Narodno graditeljstvo",
                "Zdanja",
                "Spomen-kuće",
                "Tvrđave",
                "Tornjevi",
                "Hramovi"
            ],
            subcategoryEng: [
                "Dams and hydropower plants",
                "Castles and Villas",
                "Bridges",
                "National Construction",
                "Old Buildings",
                "Memorial House",
                "Fortresses",
                "Towers",
                "Temples"
            ],
            expanded :false,
            categoryImageData: "buildings",
            imageData: ["hydro","castle","bridges","peoplebuild","palaces","monumenthouses","old buildings","tower","temple"]
        ),
        DataModel(
            category: "КУЛТУРА",
            categoryEng: "Culture",
            categoryLat: "Kultura",
            subcategory: [
                " Библиотеке",
                " Биоскопи",
                " Галерије",
                " Истраживачки центри",
                " Културни центри",
                " Музеји и збирке",
                " Позоришта",
                " Споменици",
                " Сусрети ",
                " Целине "
            ],
            subcategotyLat: [
                "Biblioteke",
                "Bioskopi",
                "Galerije",
                "Istraživački centri",
                "Kulturni centri",
                "Muzeji i zbirke",
                "Pozorišta",
                "Spomenici",
                "Susreti",
                "Celine"],
            subcategoryEng: [
                "Libraries",
                "Cinemas",
                "Galleries",
                "Research Centers",
                "Cultural Centers",
                "Museums and collections",
                "Theatres",
                "Monuments",
                "Encounters",
                "Entireties"],
            expanded :false,
            categoryImageData: "culture",
            imageData: [
                "libraries",
                "cinemas",
                "galleries",
                "research",
                "culturecentres",
                "museums",
                "theater",
                "monuments",
                "meetings",
                "entirety"]
        ),
        DataModel(
            category: "ЗАНИМЉИВОСТИ",
            categoryEng: "Interesting",
            categoryLat: "Zanimljivosti",
            subcategory: [
                " Аква-паркови",
                " Гондоле",
                " Зоо-вртови",
                " Манифестације",
                " Природњачки центри",
                " Регате и крстарења",
                " Скеле"
            ],
            subcategotyLat: [
                "Akva-parkovi",
                "Gondole",
                "Zoo-vrtovi",
                "Manifestacije",
                "Prirodnjački centri",
                "Regate i krstarenja",
                "Skele"],
            subcategoryEng: [
                "Aqua parks",
                "Gondola",
                "Zoos",
                "Manifestations",
                "Nature Centers",
                "Regattas and Cruises",
                "Scaffolding"],
            expanded :false,
            categoryImageData: "interesting",
            imageData: [
                "aqua",
                "gondolas",
                "zoos",
                "manifestations",
                "naturecenters",
                "regattas",
                "scaffold"]
        ),
        DataModel(
            category: "СПОРТ, РЕКРЕАЦИЈА",
            categoryEng: "Sport",
            categoryLat: "Sport, Rekreacija",
            subcategory: [
                " Адреналински",
                " Базени",
                " Дворане",
                " Купалишта",
                " Ловишта",
                " Риболов",
                " Скијалишта",
                " Спортови на води",
                " Спортски центри",
                " Стадиони",
                " Стазе" ,
                " Хиподроми"
            ],
            subcategotyLat: [
                "Adrenalinski",
                "Bazeni",
                "Dvorane",
                "Kupališta",
                "Lovišta",
                "Ribolov",
                "Skijališta",
                "Sportovi na vodi",
                "Sportski centri",
                "Stadioni",
                "Staze" ,
                "Hipodromi"
            ],
            subcategoryEng: [
                "adrenaline",
                "Pools",
                "Halls",
                "Bathrooms",
                "Hunting",
                "Fishing",
                "Ski Resorts",
                "Water sports",
                "Sports Centers",
                "Stadiums",
                "Tracks",
                "hippodromes"
            ],
            expanded :false,
            categoryImageData: "sport",
            imageData: [
                "adrenalin",
                "pools",
                "halls",
                "baths",
                "huntinggrounds",
                "fishing",
                "skies",
                "watersports",
                "sportcenters",
                "stadiums",
                "tracks",
                "hipodromes"
            ]
        ),
        DataModel(
            category: "ТУРИСТ-ИНФО ЦЕНТРИ",
            categoryEng: "Tourist-info centers",
            categoryLat: "Turist-info Centri",
            subcategory: [""],
            subcategotyLat: [""],
            subcategoryEng: [""],
            expanded :false,
            categoryImageData: "tourist-info centers",
            imageData: [""]
        ),
        DataModel(
            category: "СМЕШТАЈ",
            categoryEng: "Accommodation",
            categoryLat: "Smeštaj",
            subcategory: [
                " Домаћинства и етно-села",
                " Кампови",
                " Планинарски домови и одмаралишта",
                " Собе и апартмани",
                " Хостели",
                " Хотели"
            ],
            subcategotyLat: [
                "Domaćinstva i etno-sela",
                "Kampovi",
                "Planinarski domovi i odmarališta",
                "Sobe i apartmani",
                "Hosteli",
                "Hoteli"
            ],
            subcategoryEng: [
                "Households and ethno-villages",
                "Camps",
                "Mountain homes and resorts",
                "Rooms and apartments",
                "Hostels",
                "hotels"
            ],
            expanded :false,
            categoryImageData: "Accommodation",
            imageData: [
                "etnovillage",
                "camps",
                "mountainhome",
                "rooms",
                "hostels",
                "hotels"
            ]
        ),
        DataModel(
            category: "УГОСТИТЕЉСТВО",
            categoryEng: "Catering",
            categoryLat: "Ugostiteljstvo",
            subcategory: [
                " Барови, пабови, клубови",
                " Винарије",
                " Кафеи и посластичарнице",
                " Ресторани (Општи, национални, пицерије, кафане)",
                " Салаши и етно-куће"
            ],
            subcategotyLat: [
                "Barovi pabovi klubovi",
                "Vinarije",
                "Kafei i poslastičarnice",
                "Restorani (Opšti, nacionalni, picerije, kafane)",
                "Salaši i etno-kuće"
            ],
            subcategoryEng: [
                "Bars, pubs, clubs",
                "Wineries",
                "Cafes and pastry shops",
                "Restaurants (General, national, pizzerias, cafes)",
                "Farmhouses and ethno-houses"
            ],
            expanded :false,
            categoryImageData: "catering",
            imageData: [
                "bars",
                "wines",
                "caffes",
                "restaurants",
                "farms",
            ]
        ),
        DataModel(
            category: "ШОПИНГ",
            categoryEng: "Shopping",
            categoryLat: "Šoping",
            subcategory: [
                " Пијаце",
                " Тржни центри",
                " Шопинг зоне"
            ],
            subcategotyLat: [
                "Pijace",
                "Tržni centri",
                "Šoping zone"
            ],
            subcategoryEng: [
                "Markets",
                "Shopping centers",
                "Shopping Zones"
            ],
            expanded :false,
            categoryImageData: "shopping",
            imageData: [
                "markets",
                "shoppingcenters",
                "shoppingzones"]
        ),
        DataModel(
            category: "КОРИСНЕ ИНФОРМАЦИЈЕ",
            categoryEng: "Useful information",
            categoryLat: "Korisne Informacije",
            subcategory: [
                " Апотеке",
                " Банке",
                " Визни режим",
                " Гориво",
                " Здравље",
                " Мењачнице",
                "Мобилна телефонија",
                " Осигурање",
                " Паркинг",
                " Полиција",
                " Помоћ на путу",
                " Празници и нерадни дани",
                " Путовања",
                " Такси"
            ],
            subcategotyLat: [
                "Apoteke",
                "Banke",
                "Vizni režim",
                "Gorivo",
                "Zdravlje",
                "Menjačnice",
                "Mobilna telefonija",
                "Osiguranje",
                "Parking",
                "Policija",
                "Pomoć na putu",
                "Praznici i neradni dani",
                "Putovanja",
                "Taksi"
            ],
            subcategoryEng: [
                "Pharmacy",
                "Banks",
                "Visa Regime",
                "Fuel",
                "Health",
                "Exchanges",
                "Mobile telephony",
                "Insurance",
                "Parking lot",
                "Police",
                "Help on the way",
                "Holidays and non-working days",
                "Travels",
                "Taxi"
            ],
            expanded :false,
            categoryImageData: "Useful information",
            imageData: [
                "pharmacy",
                "banks",
                "regime",
                "fuel",
                "health",
                "exchange",
                "mobilemtss",
                "insurance",
                "parking",
                "police",
                "roadhelp",
                "holidays",
                "travel",
                "taxi"
            ]
        )
    ]
}
