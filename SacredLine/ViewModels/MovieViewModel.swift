//
//  MovieViewModel.swift
//  SacredLine
//
//  Created by Mentari Tika on 15/09/26.
//

import SwiftUI
import Observation

enum SortOption: String, CaseIterable {
    case chronological = "Chronological"
    case releaseDate = "Release Date"
    case alphabetical = "A-Z"
    case runtime = "Runtime"
}

@Observable
class MovieViewModel {
    private let saveKey = "SavedMarvelMoviesKey_v1"
    
    var movies: [MarvelMovie] {
        didSet {
            saveMovies()
        }
    }
    
    init() {
        // Coba muat data yang sudah pernah disimpan sebelumnya di UserDefaults
        if let savedData = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([MarvelMovie].self, from: savedData) {
            self.movies = decoded
        } else {
            // Data default pertama kali app diinstal
            self.movies = [
                MarvelMovie(title: "Eyes of Wakanda (Ep. 1)", year: "1260 BCE", duration: "30m", description: "Wakandan warriors who, throughout history, have traveled the world to retrieve dangerous vibranium artifacts."),
                MarvelMovie(title: "Eyes of Wakanda (Ep. 2)", year: "1200 BCE", duration: "30m", description: "Historical chronicle of Wakandan artifact retrieval missions across ancient eras."),
                MarvelMovie(title: "Eyes of Wakanda (Ep. 3)", year: "1400 BCE", duration: "30m", description: "Further historical missions uncovering hidden vibranium traces globally."),
                MarvelMovie(title: "Eyes of Wakanda (Ep. 4)", year: "1896", duration: "30m", description: "Late 19th-century operations involving Wakandan secret protectors."),
                MarvelMovie(title: "Captain America: The First Avenger", year: "1943", duration: "2h 4m", description: "Steve Rogers transforms into Super-Soldier Captain America to take down Hydra during World War II."),
                MarvelMovie(title: "Agent Carter (Season 1)", year: "1946", duration: "Series", description: "Peggy Carter navigates secretarial duties in the SSR while secretly helping Howard Stark clear his name."),
                MarvelMovie(title: "The Fantastic Four: First Steps", year: "1964", duration: "1h 55m", description: "The Fantastic Four balance family bonds while defending Earth from Galactus and the Silver Surfer.", statusOverride: .comingSoon),
                MarvelMovie(title: "Captain Marvel", year: "1995", duration: "2h 3m", description: "Carol Danvers becomes a powerful hero when Earth is caught in a galactic war between two alien races."),
                MarvelMovie(title: "Iron Man", year: "2010", duration: "2h 6m", description: "Billionaire engineer Tony Stark creates a unique weaponized suit of armor to fight evil after captivity."),
                MarvelMovie(title: "Iron Man 2", year: "2011", duration: "2h 4m", description: "Tony Stark contends with declining health and a vengeful madman with ties to his father's legacy."),
                MarvelMovie(title: "The Incredible Hulk", year: "2011", duration: "1h 52m", description: "Bruce Banner searches for a cure while evading the U.S. Government."),
                MarvelMovie(title: "Marvel One-Shot: A Funny Thing...", year: "2011", duration: "4m", description: "Agent Coulson deals with a coincidental convenience store robbery."),
                MarvelMovie(title: "Thor", year: "2011", duration: "1h 55m", description: "The arrogant god Thor is cast out of Asgard to live amongst humans on Earth."),
                MarvelMovie(title: "Marvel One-Shot: The Consultant", year: "2011", duration: "4m", description: "Agents Coulson and Sitwell plan to derail General Ross from interfering with S.H.I.E.L.D."),
                MarvelMovie(title: "The Avengers", year: "2012", duration: "2h 23m", description: "Earth's mightiest heroes assemble to stop Loki and his alien army."),
                MarvelMovie(title: "Marvel One-Shot: Item 47", year: "2012", duration: "12m", description: "Agent Sitwell recovers an abandoned Chitauri weapon used in a bank robbery."),
                MarvelMovie(title: "Thor: The Dark World", year: "2013", duration: "1h 52m", description: "Thor reunites with Jane Foster to stop Dark Elves from plunging the universe into darkness."),
                MarvelMovie(title: "Iron Man 3", year: "2013", duration: "2h 10m", description: "Tony Stark faces a formidable terrorist known as the Mandarin."),
                MarvelMovie(title: "Marvel One-Shot: All Hail the King", year: "2014", duration: "14m", description: "A documentary filmmaker interviews Trevor Slattery behind bars."),
                MarvelMovie(title: "Captain America: The Winter Soldier", year: "2014", duration: "2h 16m", description: "Steve Rogers teams up with Black Widow to uncover a deep conspiracy within S.H.I.E.L.D."),
                MarvelMovie(title: "Guardians of the Galaxy", year: "2014", duration: "2h 1m", description: "A group of intergalactic criminals pull together to stop a fanatical warrior."),
                MarvelMovie(title: "I Am Groot (Ep. 1)", year: "2014", duration: "5m", description: "Short adventures featuring the seedling Groot."),
                MarvelMovie(title: "Guardians of the Galaxy Vol. 2", year: "2014", duration: "2h 16m", description: "The Guardians deal with personal family issues and Star-Lord's celestial father Ego."),
                MarvelMovie(title: "I Am Groot (Ep. 2–10)", year: "2014", duration: "Shorts", description: "Further seedling adventures across the galaxy."),
                MarvelMovie(title: "Daredevil (Season 1)", year: "2015", duration: "Series", description: "Blind lawyer Matt Murdock fights crime in Hell's Kitchen by night."),
                MarvelMovie(title: "Jessica Jones (Season 1)", year: "2015", duration: "Series", description: "Private investigator Jessica Jones deals with remarkable abilities and her traumatic past."),
                MarvelMovie(title: "Avengers: Age of Ultron", year: "2015", duration: "2h 21m", description: "Tony Stark's peacekeeping program goes wrong, creating the rogue AI Ultron."),
                MarvelMovie(title: "Ant-Man", year: "2015", duration: "1h 57m", description: "Cat burglar Scott Lang uses a size-altering suit to help Dr. Hank Pym save the world."),
                MarvelMovie(title: "Daredevil (Season 2)", year: "2015", duration: "Series", description: "Matt Murdock crosses paths with The Punisher and Elektra."),
                MarvelMovie(title: "Luke Cage (Season 1)", year: "2015", duration: "Series", description: "A fugitive with super strength and unbreakable skin fights for Harlem."),
                MarvelMovie(title: "Iron Fist (Season 1)", year: "2016", duration: "Series", description: "Danny Rand returns with martial arts mastery and the mystical Iron Fist."),
                MarvelMovie(title: "The Defenders", year: "2016", duration: "Mini Series", description: "Daredevil, Jessica Jones, Luke Cage, and Iron Fist team up in New York City."),
                MarvelMovie(title: "Captain America: Civil War", year: "2016", duration: "2h 27m", description: "Political oversight splits the Avengers into opposing factions led by Cap and Iron Man."),
                MarvelMovie(title: "Your Friendly Neighborhood Spider-Man", year: "2016", duration: "Series", description: "Peter Parker's early origins as Spider-Man in the MCU."),
                MarvelMovie(title: "Black Widow", year: "2016", duration: "2h 14m", description: "Natasha Romanoff confronts dark conspiracies tied to her red-room past."),
                MarvelMovie(title: "Black Panther", year: "2016", duration: "2h 14m", description: "T'Challa steps up to rule Wakanda and faces a challenging outsider."),
                MarvelMovie(title: "Spider-Man: Homecoming", year: "2016", duration: "2h 13m", description: "Peter Parker balances high school life while stopping the Vulture."),
                MarvelMovie(title: "The Punisher (Season 1)", year: "2016", duration: "Series", description: "Frank Castle uncovers a military conspiracy while serving vigilante justice."),
                MarvelMovie(title: "Doctor Strange", year: "2016", duration: "1h 55m", description: "A brilliant neurosurgeon discovers the mystical arts after a career-ending accident."),
                MarvelMovie(title: "Jessica Jones (Season 2)", year: "2017", duration: "Series", description: "Jessica uncovers dark secrets regarding her mother and IGH."),
                MarvelMovie(title: "Luke Cage (Season 2)", year: "2017", duration: "Series", description: "Luke faces a new charismatic threat challenging his kingdom in Harlem."),
                MarvelMovie(title: "Iron Fist (Season 2)", year: "2017", duration: "Series", description: "Danny protects Chinatown amidst shifting criminal syndicates."),
                MarvelMovie(title: "Daredevil (Season 3)", year: "2017", duration: "Series", description: "A broken Matt Murdock faces the return of Wilson Fisk."),
                MarvelMovie(title: "Thor: Ragnarok", year: "2017", duration: "2h 10m", description: "Thor fights to save Asgard from Hela while imprisoned on Sakaar."),
                MarvelMovie(title: "The Punisher (Season 2)", year: "2018", duration: "Series", description: "Frank protects a young girl and confronts Billy Russo."),
                MarvelMovie(title: "Jessica Jones (Season 3)", year: "2018", duration: "Series", description: "Jessica clashes with a highly intelligent and lethal serial killer."),
                MarvelMovie(title: "Ant-Man and the Wasp", year: "2018", duration: "1h 58m", description: "Scott Lang teams up with Hope van Dyne on an urgent rescue mission into the Quantum Realm."),
                MarvelMovie(title: "Avengers: Infinity War", year: "2018", duration: "2h 29m", description: "The Avengers make ultimate sacrifices to stop Thanos from gathering all Infinity Stones."),
                MarvelMovie(title: "Avengers: Endgame", year: "2023", duration: "3h 1m", description: "The surviving heroes assemble for a time heist to reverse the Blip and defeat Thanos."),
                MarvelMovie(title: "Marvel Zombies (Season 1)", year: "2023", duration: "Series", description: "Survivors battle an apocalyptic zombie plague overtaking Earth's mightiest heroes."),
                MarvelMovie(title: "WandaVision", year: "2023", duration: "Mini Series", description: "Wanda Maximoff and Vision live ideal suburban sitcom lives concealing dark grief."),
                MarvelMovie(title: "Deadpool & Wolverine", year: "2024", duration: "2h 8m", description: "Deadpool recruits a variant of Wolverine to save his universe with TVA involvement."),
                MarvelMovie(title: "Shang-Chi and the Legend of the Ten Rings", year: "2024", duration: "2h 12m", description: "Shang-Chi confronts his father and the ancient Ten Rings organization."),
                MarvelMovie(title: "The Falcon and the Winter Soldier", year: "2024", duration: "Mini Series", description: "Sam and Bucky team up in a global adventure testing their limits and legacies."),
                MarvelMovie(title: "Spider-Man: Far From Home", year: "2024", duration: "2h 9m", description: "Peter Parker's European school trip is interrupted by elemental threats and Mysterio."),
                MarvelMovie(title: "Eternals", year: "2024", duration: "2h 36m", description: "Immortal beings emerge from the shadows to protect humanity from ancient predators."),
                MarvelMovie(title: "Spider-Man: No Way Home", year: "2024", duration: "2h 28m", description: "Multiverse spells fracture reality when Peter asks Doctor Strange for help."),
                MarvelMovie(title: "Doctor Strange in the Multiverse of Madness", year: "2024", duration: "2h 6m", description: "Strange traverses terrifying multiverse realities to protect America Chavez."),
                MarvelMovie(title: "Hawkeye", year: "2024", duration: "Mini Series", description: "Clint Barton teams up with Kate Bishop during Christmas in New York."),
                MarvelMovie(title: "Moon Knight", year: "2025", duration: "Series", description: "Steven Grant juggles DID and the powers of an Egyptian moon god."),
                MarvelMovie(title: "Black Panther: Wakanda Forever", year: "2025", duration: "2h 41m", description: "Wakanda protects their kingdom from Namor and Talokan following T'Challa's passing."),
                MarvelMovie(title: "Echo", year: "2025", duration: "Mini Series", description: "Maya Lopez reconnects with her Native American roots and faces Kingpin."),
                MarvelMovie(title: "She-Hulk: Attorney at Law", year: "2025", duration: "Series", description: "Jen Walters navigates life as a 6-foot-7 green lawyer superhero."),
                MarvelMovie(title: "Ms. Marvel", year: "2025", duration: "Series", description: "Kamala Khan discovers cosmic powers tied to her family heritage."),
                MarvelMovie(title: "Thor: Love and Thunder", year: "2025", duration: "1h 59m", description: "Thor teams up with Jane Foster to stop Gorr the God Butcher."),
                MarvelMovie(title: "Ironheart", year: "2025", duration: "Series", description: "Riri Williams crafts highly advanced armor rivalling Stark tech."),
                MarvelMovie(title: "The Guardians of the Galaxy Holiday Special", year: "2025", duration: "Special", description: "The Guardians head to Earth to kidnap Kevin Bacon for Christmas."),
                MarvelMovie(title: "Wonder Man", year: "2026", duration: "Series", description: "Simon Williams struggles as an actor while hiding his superpowers."),
                MarvelMovie(title: "Ant-Man and the Wasp: Quantumania", year: "2026", duration: "2h 4m", description: "The Ant-Man family encounters Kang the Conqueror in the Quantum Realm."),
                MarvelMovie(title: "Guardians of the Galaxy Vol. 3", year: "2026", duration: "2h 30m", description: "The Guardians embark on a final emotional mission to protect Rocket's past."),
                MarvelMovie(title: "Secret Invasion", year: "2026", duration: "Series", description: "Nick Fury uncovers a covert Skrull infiltration across global governments."),
                MarvelMovie(title: "The Marvels", year: "2026", duration: "1h 45m", description: "Carol, Kamala, and Monica swap places whenever they use their light powers."),
                MarvelMovie(title: "Agatha All Along", year: "2026", duration: "Series", description: "Agatha Harkness forms a coven to walk the perilous Witches' Road."),
                MarvelMovie(title: "Daredevil: Born Again (Season 1 - Ep. 1)", year: "2026", duration: "Series", description: "Matt Murdock and Wilson Fisk collide once more in New York politics."),
                MarvelMovie(title: "Daredevil: Born Again (Season 1 - Ep. 2–9)", year: "2027", duration: "Series", description: "The explosive continuation of Matt and Fisk's epic clash.", statusOverride: .comingSoon),
                MarvelMovie(title: "Captain America: Brave New World", year: "2027", duration: "1h 58m", description: "Sam Wilson faces an international global conspiracy as the new Captain America.", statusOverride: .comingSoon),
                MarvelMovie(title: "Thunderbolts*", year: "2027", duration: "2h 15m", description: "An unorthodox crew of antiheroes embark on a lethal black-ops mission.", statusOverride: .comingSoon),
                MarvelMovie(title: "Daredevil: Born Again (Season 2)", year: "2027", duration: "Series", description: "Further chapters of the Hell's Kitchen vigilante.", statusOverride: .comingSoon),
                MarvelMovie(title: "The Punisher: One Last Kill", year: "2027", duration: "Special", description: "Frank Castle confronts what remains of his brutal purpose.", statusOverride: .comingSoon),
                MarvelMovie(title: "Spider-Man: Brand New Day", year: "2028", duration: "2h 25m", description: "A forgotten Peter Parker navigates solo heroics under mounting pressure.", statusOverride: .comingSoon)
            ]
        }
    }
    
    private func saveMovies() {
        if let encoded = try? JSONEncoder().encode(movies) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    func filteredAndSortedMovies(filter: WatchStatus, sort: SortOption, ascending: Bool) -> [MarvelMovie] {
        let filtered = (filter == .all) ? movies : movies.filter { $0.status == filter }
        
        let sorted: [MarvelMovie]
        switch sort {
        case .chronological:
            sorted = filtered
        case .releaseDate:
            sorted = filtered.sorted { $0.year < $1.year }
        case .alphabetical:
            sorted = filtered.sorted { $0.title < $1.title }
        case .runtime:
            sorted = filtered.sorted { parseRuntime($0.duration) > parseRuntime($1.duration) }
        }
        
        return ascending ? sorted : sorted.reversed()
    }
    
    private func parseRuntime(_ duration: String) -> Int {
        var totalMinutes = 0
        let components = duration.split(separator: " ")
        for comp in components {
            if comp.hasSuffix("h") {
                let hours = Int(comp.dropLast()) ?? 0
                totalMinutes += hours * 60
            } else if comp.hasSuffix("m") {
                let minutes = Int(comp.dropLast()) ?? 0
                totalMinutes += minutes
            }
        }
        return totalMinutes
    }
    
    var completedCount: Int {
        movies.filter { $0.status == .completed }.count
    }
    
    var completionPercentage: Int {
        guard !movies.isEmpty else { return 0 }
        return Int((Double(completedCount) / Double(movies.count)) * 100)
    }
    
    var rankedCount: Int {
        movies.filter { $0.tier != .unranked }.count
    }
    
    var rewatchableCount: Int {
        movies.filter { $0.wouldRewatch }.count
    }
    
    func updateMovie(_ updatedMovie: MarvelMovie) {
        if let index = movies.firstIndex(where: { $0.id == updatedMovie.id }) {
            movies[index] = updatedMovie
        }
    }
}
