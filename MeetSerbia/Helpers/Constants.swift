//
//  LanguageConstants.swift
//  MeetSerbia
//
//  Created by Nemanja Ducic on 24.4.23..
//

import Foundation
import CoreLocation

class Constants {
    static let constants = Constants()
    static let CACHE_KEY = "CachedData"
    static let token = "pk.eyJ1IjoibWVldHNlcmJpYSIsImEiOiJjbGY4NHNqb3UxbzJsM3pudGV4eGxrdmw2In0.U7yh9XHMImXSU3CxkLRbDg"

    //Language
    let userDefLangugaeKey = UserDefaults.standard.string(forKey: "Language")
    let memoriesTabArray = ["УСПОМЕНЕ СА ПОСЕЋЕНИХ ЛОКАЦИЈА", "USPOMENE SA POSEĆENIH LOKACIJA", "MEMORIES FROM VISITED LOCATIONS"]
    let roomsArray = ["СМЕШТАЈ  И РЕЗЕРВАЦИЈЕ","SMEŠTAJ  I REZERVACIJE","ROOMS AND SERVICES"]
    let savedRoutesArray = ["САЧУВАНЕ РУТЕ","SAČUVANE RUTE","SAVED ROUTES"]
    let savedLocationsArray = ["САЧУВАНЕ ЛОКАЦИЈЕ","SAČUVANE LOKACIJE","SAVED LOCATIONS"]
    let postsArray = ["ОБЈАВЕ","OBJAVE","POSTS"]
    let membershipArray = ["ЧЛАНАРИНА И ПЛАЋАЊА","ČLANARINA I PLAĆANJA","MEMBERSHIP AND PAYMENT"]
    let enterEmailArray = ["Овде унесите своју електронску адресу","Ovde uniste svoju elektronsku adresu","Enter Your Email here"]
    let descriptionPassResetArray = ["Унесите вашy електронску адресу, затим пратите даље кораке на вашој апликацији за електронске поруке","Unesite vašu elektronsku adresu,   zatim pratite dalje korake na vašoj aplikaciji za elektronske poruke","Enter your e-mail address,than follow further steps on your e-mail app"]
    let changePassArray = ["Промените лозинку","Promenite lozinku","Change password"]
    let errMSGArray = ["Грешка при слању електронске поруке за обнову","Greška pri slanju elektronske poruke za obnovu","Failed to send password reset email"]
    let succMSGArray = ["Послата порука за обнову лозинке","Poslata poruka za obnovu lozinke","Password reset email sent"]
    let emptyMSGArray = ["Упишите своју електронску адресу","Upišite svoju elektronsku adresu","Enter your email address"]
    let allSubs = [" Аде", " Водопади", " Заштићена подручја"," Излетишта и видиковци"," Језера", " Клисуре"," Пећине", " Планине", " Реке"," Бране и хидроелектране", " Дворци и виле", " Мостови", " Народно градитељство", " Здања", " Спомен-куће", " Тврђаве", " Торњеви", " Храмови"," Библиотеке", " Биоскопи"," Галерије", " Истраживачки центри", " Културни центри", " Музеји и збирке", " Позоришта", " Споменици", " Сусрети ", " Целине "," Адреналински", " Базени", " Дворане", " Купалишта", " Ловишта", " Риболов", " Скијалишта", " Спортови на води", " Спортски центри", " Стадиони", " Стазе", " Хиподроми"," Аква-паркови", " Гондоле", " Зоо-вртови", " Манифестације", " Природњачки центри", " Регате и крстарења", " Скеле"," Домаћинства и етно-села", " Кампови", " Планинарски домови и одмаралишта", " Собе и апартмани", " Хостели", " Хотели"," Барови, пабови, клубови", " Винарије", " Кафеи и посластичарнице", " Ресторани (Сви. Општи, национални, пицерије, кафане", " Салаши и етно-куће"," Пијаце", " Тржни центри", " Шопинг зоне"," Апотеке", " Банке", " Визни режим", " Гориво", " Здравље", " Мењачнице", "Мобилна телефонија", " Осигурање", " Паркинг", " Полиција", " Помоћ на путу", " Празници и нерадни дани", " Путовања", " Такси","Apoteke", "Banke", "Vizni režim", "Gorivo", "Zdravlje", "Menjačnice", "Mobilna telefonija", "Osiguranje", "Parking", "Policija", "Pomoć na putu", "Praznici i neradni dani", "Putovanja", "Taksi","Pijace", "Tržni centri", "Šoping zone","Barovi pabovi klubovi", "Vinarije", "Kafei i poslastičarnice", "Restorani (Svi. Opšti, nacionalni, picerije, kafane", "Salaši i etno-kuće","Domaćinstva i etno-sela", "Kampovi", "Planinarski domovi i odmarališta", "Sobe i apartmani", "Hosteli", "Hoteli","Adrenalinski", "Bazeni", "Dvorane", "Kupališta", "Lovišta", "Ribolov", "Skijališta", "Sportovi na vodi", "Sportski centri", "Stadioni", "Staze", "Hipodromi","Akva-parkovi", "Gondole", "Zoo-vrtovi", "Manifestacije", "Prirodnjački centri", "Regate i krstarenja", "Skele","Biblioteke", "Bioskopi", "Galerije", "Istraživački centri", "Kulturni centri", "Muzeji i zbirke", "Pozorišta", "Spomenici", "Susreti", "Celine","Brane i hidroelektrane", "Dvorci i vile", "Mostovi", "Narodno graditeljstvo", "Zdanja", "Spomen-kuće", "Tvrđave", "Tornjevi", "Hramovi","ADE", "VODOPADI", "Zaštićena područja", "Izletišta i vidikovci", "Jezera", "Klisure", "Pećine", "Planine", "Reke","Pharmacy", "Banks", "Visa Regime", "Fuel", "Health", "Exchanges", "Mobile telephony", "Insurance", "Parking lot", "Police", "Help on the way", "Holidays and non-working days", "Travels", "Taxi","Markets", "Shopping centers", "Shopping Zones","Bars, pubs, clubs", "Wineries", "Cafes and pastry shops", "Restaurants (All. General, national, pizzerias, cafes)", "Farmhouses and ethno-houses","Households and ethno-villages", "Camps", "Mountain homes and resorts", "Rooms and apartments", "Hostels", "hotels","adrenaline", "Pools", "Halls", "Bathrooms", "Hunting", "Fishing", "Ski Resorts", "Water sports", "Sports Centers", "Stadiums", "Tracks", "hippodromes","Aqua parks", "Gondola", "Zoos", "Manifestations", "Nature Centers", "Regattas and Cruises", "Scaffolding","Libraries", "Cinemas", "Galleries", "Research Centers", "Cultural Centers", "Museums and collections", "Theatres", "Monuments", "Encounters", "Entireties","Dams and hydropower plants", "Castles and Villas", "Bridges", "National Construction", "Old Buildings", "Memorial House", "Fortresses", "Towers", "Temples","Ade", "Waterfalls", "Protected areas", "Excursions and viewpoints", "Lakes", "Gorges", "Caves", "Mountains", "Rivers","Izvori", "Извори", "Wellsprings","Česme", "Чесме", "Fountains"]
     let searchDataEng = ["NATURE","Spa","Cities","Buildings","Culture","Interesting","Sport","Tourist-info centers","Accommodation","Catering","Shopping","Useful information","Pharmacy", "Banks", "Visa Regime", "Fuel", "Health", "Exchanges", "Mobile telephony", "Insurance", "Parking lot", "Police", "Help on the way", "Holidays and non-working days", "Travels", "Taxi","Markets", "Shopping centers", "Shopping Zones","Bars, pubs, clubs", "Wineries", "Cafes and pastry shops", "Restaurants (All. General, national, pizzerias, cafes)", "Farmhouses and ethno-houses","Households and ethno-villages", "Camps", "Mountain homes and resorts", "Rooms and apartments", "Hostels", "hotels","adrenaline", "Pools", "Halls", "Bathrooms", "Hunting", "Fishing", "Ski Resorts", "Water sports", "Sports Centers", "Stadiums", "Tracks", "hippodromes","Aqua parks", "Gondola", "Zoos", "Manifestations", "Nature Centers", "Regattas and Cruises", "Scaffolding","Libraries", "Cinemas", "Galleries", "Research Centers", "Cultural Centers", "Museums and collections", "Theatres", "Monuments", "Encounters", "Entireties","Dams and hydropower plants", "Castles and Villas", "Bridges", "National Construction", "Old Buildings", "Memorial House", "Fortresses", "Towers", "Temples","Ade", "Waterfalls", "Protected areas", "Excursions and viewpoints", "Lakes", "Gorges", "Caves", "Mountains", "Rivers","Wellsprings","Fountains"]
    
    
     let searchData = ["ПРИРОДА","БАЊЕ","ГРАДОВИ","ГРАЂЕВИНЕ","КУЛТУРА","ЗАНИМЉИВОСТИ","СПОРТ, РЕКРЕАЦИЈА","ТУРИСТ-ИНФО ЦЕНТРИ","СМЕШТАЈ","УГОСТИТЕЉСТВО","ШОПИНГ","КОРИСНЕ ИНФОРМАЦИЈЕ","Апотеке", "Банке", "Визни режим", "Гориво", "Здравље", "Мењачнице", "Мобилна телефонија", "Осигурање", "Паркинг", "Полиција", "Помоћ на путу", "Празници и нерадни дани", "Путовања", "Такси","Пијаце", "Тржни центри", "Шопинг зоне","Барови, пабови, клубови", "Винарије","Кафеи и посластичарнице", "Ресторани (Сви. Општи, национални, пицерије, кафане", "Салаши и етно-куће","Домаћинства и етно-села", "Кампови", "Планинарски домови и одмаралишта", "Собе и апартмани", "Хостели", "Хотели"
    ,"Адреналински", "Базени", " Дворане", "Купалишта", "Ловишта", "Риболов", "Скијалишта", " Спортови на води", "Спортски центри", "Стадиони", "Стазе", "Хиподроми","Аква-паркови", "Гондоле", "Зоо-вртови", "Манифестације","Природњачки центри", "Регате и крстарења", "Скеле"," Библиотеке", "Биоскопи", "Галерије", "Истраживачки центри", "Културни центри", "Музеји и збирке", "Позоришта", "Споменици", "Сусрети", "Целине","Бране и хидроелектране","Дворци и виле", "Мостови", "Народно градитељство", "Здања", "Спомен-куће", "Тврђаве", "Торњеви", "Храмови","Аде", "Водопади", "Заштићена подручја", "Излетишта и видиковци", "Језера", "Клисуре", "Пећине", "Планине", "Реке","Извори","Чесме"]
    
     let searchDataLat = ["PRIRODA","Banje","Gradovi","Građevine","Kultura","Zanimljivosti","Sport,Rekreacija","Turist-info Centri","Smeštaj","Ugostiteljstvo","Šoping","Korisne Informacije","Apoteke", "Banke", "Vizni režim", "Gorivo", "Zdravlje", "Menjačnice", "Mobilna telefonija", "Osiguranje", "Parking", "Policija", "Pomoć na putu", "Praznici i neradni dani", "Putovanja", "Taksi","Pijace", "Tržni centri", "Šoping zone","Barovi pabovi klubovi", "Vinarije", "Kafei i poslastičarnice", "Restorani (Svi. Opšti, nacionalni, picerije, kafane", "Salaši i etno-kuće","Domaćinstva i etno-sela", "Kampovi", "Planinarski domovi i odmarališta", "Sobe i apartmani", "Hosteli", "Hoteli","Adrenalinski", "Bazeni", "Dvorane", "Kupališta", "Lovišta", "Ribolov", "Skijališta", "Sportovi na vodi", "Sportski centri", "Stadioni", "Staze", "Hipodromi","Akva-parkovi", "Gondole", "Zoo-vrtovi", "Manifestacije", "Prirodnjački centri", "Regate i krstarenja", "Skele","Biblioteke", "Bioskopi", "Galerije", "Istraživački centri", "Kulturni centri", "Muzeji i zbirke", "Pozorišta", "Spomenici", "Susreti", "Celine","Brane i hidroelektrane","Dvorci i vile", "Mostovi", "Narodno graditeljstvo", "Zdanja", "Spomen-kuće", "Tvrđave", "Tornjevi", "Hramovi","ADE", "VODOPADI", "Zaštićena područja", "Izletišta i vidikovci", "Jezera", "Klisure", "Pećine", "Planine", "Reke","Izvori","Česme"]
    
    let loginStringConstant = [""]
    let registerStringConstant = [""]
    let nextButtonConstant = [""]
    
    //BoundingBox
    static let serbiaSouthWest = CLLocationCoordinate2D(latitude: 42.245826, longitude: 18.829444)
    static let serbiaNorthEast = CLLocationCoordinate2D(latitude: 46.193056, longitude: 23.013334)
    
    let userDefLoginKey = UserDefaults.standard.bool(forKey: "logedIn")
    let MAIN_CATEGORIES = ["priroda","banje","gradovi","građevine","kultura","zanimljivosti","sport, rekreacija","turist-info centri","smeštaj","ugostiteljstvo","šoping","korisne informacije",]
    let MAIN_CATEGORIES_ENG = ["nature","spa","cities","buildings","culture","interesting","sport","tourist-info centers","accommodation","catering","shopping","useful information"]
    let MAIN_CATEGORIES_CIR = ["природа","бање","градови","грађевине","култура","занимљивости","спорт, рекреација","турист-инфо центри","смештај","угоститељство","шопинг","корисне информације"]
    
    func getMyPath() -> String {
         if userDefLangugaeKey == "eng"{
          return  "Start Navigation"
         } else if userDefLangugaeKey == "lat" {
             return "Započni Navigaciju"
         } else {
             return "Започни Навигацију"
         }
    }
    func getShowLocalities() -> String {
         if userDefLangugaeKey == "eng"{
          return  "Show Localities!"
         } else if userDefLangugaeKey == "lat" {
             return "Prikaži lokalitete!"
         } else {
             return "Прикажи локалитете!"
         }
    }
    func getAddToRoute() -> String {
         if userDefLangugaeKey == "eng"{
          return  "Add To Route"
         } else if userDefLangugaeKey == "lat" {
             return "Dodaj u rutu"
         } else {
             return "Додај у руту"
         }
    }
    func getSaveRoute() -> String {
         if userDefLangugaeKey == "eng"{
          return  "Save Route"
         } else if userDefLangugaeKey == "lat" {
             return "Sačuvaj rutu"
         } else {
             return "Сачувај руту"
         }
    }
    func getSaved() -> String {
         if userDefLangugaeKey == "eng"{
          return  "Route Saved"
         } else if userDefLangugaeKey == "lat" {
             return "Ruta Sačuvana "
         } else {
             return "Рута сачувана"
         }
    }
    func getSaveFailed() -> String {
         if userDefLangugaeKey == "eng"{
          return  "Route not Saved"
         } else if userDefLangugaeKey == "lat" {
             return "Ruta nije sačuvana"
         } else {
             return "Рута није сачувана"
         }
    }
    func getMapLanguage() -> String{
        if userDefLangugaeKey == "eng"{
         return  "en"
        } else if userDefLangugaeKey == "lat" {
            return "sr-latn"
        } else {
            return "sr"
        }
    }
    //Sponsor Pins
    
    static let VRNJACKA_BANJA  = "Vrnjačka Banja "
    static let RUMA = "Ruma"
}
