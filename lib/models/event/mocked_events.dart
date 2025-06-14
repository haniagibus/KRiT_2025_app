import 'package:krit_app/models/event/event.dart';
import 'package:krit_app/models/event/event_type.dart';

class MockedEvents {
  static List<Event> getMockedEvents() {
    return [
      // Day 1: 11 September
      Event(

        title: "Referat plenarny nr 1",
        subtitle: "Fale milimetrowe i subterahercowe w systemach komórkowych: Planowane wykorzystanie, modelowanie propagacji i wpływ na architekturę sieci",
        type: EventType.PlenarySession,
        dateTimeStart: DateTime(2024, 9, 11, 9, 45),
        dateTimeEnd: DateTime(2024, 9, 11, 10, 30),
        //description: "Fale milimetrowe i subterahercowe w systemach komórkowych: Planowane wykorzystanie, modelowanie propagacji i wpływ na architekturę sieci",
        building: "Budynek A WETI",
        room: "Sala CW-1",
        reports: [],
        isFavourite: false
      ),
      Event(
        title: "Sesja techniczna nr 1",
        subtitle: "Sztuczna inteligencja w systemach radiowych – I",
        type: EventType.TechnicalSession,
        dateTimeStart: DateTime(2024, 9, 11, 11, 0),
        dateTimeEnd: DateTime(2024, 9, 11, 12, 30),
        //description: "Prezentacje dotyczące sztucznej inteligencji w systemach radiowych (część I)",
        building: "Centrum Wykładowo-Konferencyjne",
        room: "Sala CW-1",
        reports: [],
        isFavourite: false
      ),
      Event(
        title: "Sesja techniczna nr 2",
        subtitle: "Bezpieczeństwo sieci i systemów teleinformatycznych",
        type: EventType.TechnicalSession,
        dateTimeStart: DateTime(2024, 9, 11, 11, 0),
        dateTimeEnd: DateTime(2024, 9, 11, 12, 30),
        //description: "Prezentacje dotyczące bezpieczeństwa sieci i systemów teleinformatycznych",
        building: "Centrum Wykładowo-Konferencyjne",
        room: "Sala 022",
        reports: [],
        isFavourite: false
      ),
      Event(
        title: "Sesja techniczna nr 3",
        subtitle: "Systemy radionawigacyjne i radiolokalizacyjne – I",
        type: EventType.TechnicalSession,
        dateTimeStart: DateTime(2024, 9, 11, 11, 0),
        dateTimeEnd: DateTime(2024, 9, 11, 12, 30),
        //description: "Prezentacje dotyczące systemów radionawigacyjnych i radiolokalizacyjnych (część I)",
        building: "Centrum Wykładowo-Konferencyjne",
        room: "Sala 023",
        reports: [],
        isFavourite: false
      ),
      Event(
        title: "Sesja techniczna nr 4",
        subtitle: "Aspekty sieci rdzeniowych 5G i 6G – I",
        type: EventType.TechnicalSession,
        dateTimeStart: DateTime(2024, 9, 11, 11, 0),
        dateTimeEnd: DateTime(2024, 9, 11, 12, 30),
        //description: "Prezentacje dotyczące aspektów sieci rdzeniowych 5G i 6G (część I)",
        building: "Centrum Wykładowo-Konferencyjne",
        room: "Sala 027",
        reports: [],
        isFavourite: false
      ),
      Event(
        title: "Referat plenarny nr 2",
        subtitle: "Krzysztof Walkowiak",
        type: EventType.PlenarySession,
        dateTimeStart: DateTime(2024, 9, 11, 13, 45),
        dateTimeEnd: DateTime(2024, 9, 11, 14, 30),
        //description: "Zastosowanie metod uczenia maszynowego w sieciach teleinformatycznych",
        building: "Centrum Wykładowo-Konferencyjne",
        room: "Sala CW-1",
        reports: [],
        isFavourite: false
      ),
      Event(
        title: "Sesja firmowa",
        subtitle: "",
        type: EventType.Other,
        dateTimeStart: DateTime(2024, 9, 11, 14, 30),
        dateTimeEnd: DateTime(2024, 9, 11, 15, 30),
        //description: "",
        building: "Centrum Wykładowo-Konferencyjne",
        room: "CW-1",
        reports: [],
        isFavourite: false
      ),
      // Event(
      //   title: "Sesja techniczna nr 5",
      //   subtitle: "Sztuczna inteligencja w systemach radiowych – II",
      //   type: EventType.TechnicalSession,
      //   dateTimeStart: DateTime(2024, 9, 11, 16, 0),
      //   dateTimeEnd: DateTime(2024, 9, 11, 17, 30),
      //   description: "Prezentacje dotyczące sztucznej inteligencji w systemach radiowych (część I)",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala CW-1",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Sesja techniczna nr 6",
      //   subtitle: "Kryptografia i mechanizmy cyberbezpieczeństwa",
      //   type: EventType.TechnicalSession,
      //   dateTimeStart: DateTime(2024, 9, 11, 16, 0),
      //   dateTimeEnd: DateTime(2024, 9, 11, 17, 30),
      //   description: "Prezentacje dotyczące kryptografii i mechanizmów cyberbezpieczeństwa",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala 022",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Sesja techniczna nr 7",
      //   subtitle: "Systemy radionawigacyjne i radiolokalizacyjne – II",
      //   type: EventType.TechnicalSession,
      //   dateTimeStart: DateTime(2024, 9, 11, 16, 0),
      //   dateTimeEnd: DateTime(2024, 9, 11, 17, 30),
      //   description: "Prezentacje dotyczące systemów radionawigacyjnych i radiolokalizacyjnych (część I)",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala 023",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Sesja techniczna nr 8",
      //   subtitle: "Aspekty sieciowe Internetu Rzeczy",
      //   type: EventType.TechnicalSession,
      //   dateTimeStart: DateTime(2024, 9, 11, 16, 0),
      //   dateTimeEnd: DateTime(2024, 9, 11, 17, 30),
      //   description: "Prezentacje dotyczące aspektów sieciowych Internetu Reczy",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala 027",
      //   reports: [],
      //   isFavourite: false
      // ),
      //
      // // Day 2: 12 September
      // Event(
      //   title: "Sesja techniczna nr 9",
      //   subtitle: "Zastosowanie metod sztucznej inteligencji w przetwarzaniu danych multimedialnych",
      //   type: EventType.TechnicalSession,
      //   dateTimeStart: DateTime(2024, 9, 12, 9, 0),
      //   dateTimeEnd: DateTime(2024, 9, 12, 10, 30),
      //   description: "Sesja techniczna dotycząca sztucznej inteligencji w przetwarzaniu danych multimedialnych",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala CW-1",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Sesja techniczna nr 10",
      //   subtitle: "Aspekty radiowe sieci 5G i 6G – I",
      //   type: EventType.TechnicalSession,
      //   dateTimeStart: DateTime(2024, 9, 12, 9, 0),
      //   dateTimeEnd: DateTime(2024, 9, 12, 10, 30),
      //   description: "Prezentacje dotyczące aspektów sieci rdzeniowych 5G i 6G (część I)",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala 022",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Sesja techniczna nr 11",
      //   subtitle: "Bezprzewodowe sieci lokalne, sensorowe i ad-hoc",
      //   type: EventType.TechnicalSession,
      //   dateTimeStart: DateTime(2024, 9, 12, 9, 0),
      //   dateTimeEnd: DateTime(2024, 9, 12, 10, 30),
      //   description: "Sesja techniczna dotycząca bezprzewodowych sieci lokalnych, sensorowych i ad-hoc",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala 023",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Sesja techniczna nr 12",
      //   subtitle: "Jakość usług i niezawodność sieci teleinformatycznych",
      //   type: EventType.TechnicalSession,
      //   dateTimeStart: DateTime(2024, 9, 12, 9, 0),
      //   dateTimeEnd: DateTime(2024, 9, 12, 10, 30),
      //   description: "Sesja techniczna dotycząca jakości usług i niezawodności sieci teleinformatycznych",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala 027",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Referat plenarny nr 3",
      //   subtitle: "Grzegorz Borowik, Anna Felkner, Adam Kozakiewicz",
      //   type: EventType.PlenarySession,
      //   dateTimeStart: DateTime(2024, 9, 12, 11, 0),
      //   dateTimeEnd: DateTime(2024, 9, 12, 11, 45),
      //   description: "Cyberbezpieczeństwo - jasne i ciemne strony współczesnych technologii",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala CW-1",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Referat plenarny nr 4",
      //   subtitle: "Andrzej Bęben",
      //   type: EventType.PlenarySession,
      //   dateTimeStart: DateTime(2024, 9, 12, 11, 45),
      //   dateTimeEnd: DateTime(2024, 9, 12, 12, 30),
      //   description: "Krajowe laboratorium sieci i usług PL5G: kierunki badań i perspektywy rozwoju techniki 5G/6G",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala CW-1",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Panel satelitarny",
      //   subtitle: "",
      //   type: EventType.Other,
      //   dateTimeStart: DateTime(2024, 9, 12, 13, 45),
      //   dateTimeEnd: DateTime(2024, 9, 12, 14, 30),
      //   description: "",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala CW-1",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Sesja firmowa",
      //   subtitle: "",
      //   type: EventType.Other,
      //   dateTimeStart: DateTime(2024, 9, 12, 14, 30),
      //   dateTimeEnd: DateTime(2024, 9, 12, 15, 30),
      //   description: "",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala CW-1",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Sekcja telekomunikacji",
      //   subtitle: "",
      //   type: EventType.Other,
      //   dateTimeStart: DateTime(2024, 9, 12, 14, 30),
      //   dateTimeEnd: DateTime(2024, 9, 12, 16, 0),
      //   description: "",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala 056",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Sesja techniczna nr 13",
      //   subtitle: "Technika antenowa i mikrofalowa",
      //   type: EventType.TechnicalSession,
      //   dateTimeStart: DateTime(2024, 9, 12, 16, 0),
      //   dateTimeEnd: DateTime(2024, 9, 12, 17, 30),
      //   description: "Sesja techniczna dotycząca techniki antenowej i mikrofalowej",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala CW-1",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Sesja techniczna nr 14",
      //   subtitle: "Aspekty radiowe sieci 5G i 6G – II",
      //   type: EventType.TechnicalSession,
      //   dateTimeStart: DateTime(2024, 9, 12, 16, 0),
      //   dateTimeEnd: DateTime(2024, 9, 12, 17, 30),
      //   description: "Prezentacje dotyczące aspektów sieci rdzeniowych 5G i 6G (część II)",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala 022",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Sesja techniczna nr 15",
      //   subtitle: "Propagacja fal radiowych",
      //   type: EventType.TechnicalSession,
      //   dateTimeStart: DateTime(2024, 9, 12, 16, 0),
      //   dateTimeEnd: DateTime(2024, 9, 12, 17, 30),
      //   description: "Sesja techniczna dotycząca propagacji fal radiowych",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala 023",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Sesja techniczna nr 16",
      //   subtitle: "Badanie jakości treści multimedialnych",
      //   type: EventType.TechnicalSession,
      //   dateTimeStart: DateTime(2024, 9, 12, 16, 0),
      //   dateTimeEnd: DateTime(2024, 9, 12, 17, 30),
      //   description: "Sesja techniczna dotycząca badania jakości treści multimedialnych",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala 027",
      //   reports: [],
      //   isFavourite: false
      // ),
      //
      // // Day 3: 13 September
      // Event(
      //   title: "Sesja techniczna nr 17",
      //   subtitle: "Systemy i sieci komórkowe",
      //   type: EventType.TechnicalSession,
      //   dateTimeStart: DateTime(2024, 9, 13, 9, 0),
      //   dateTimeEnd: DateTime(2024, 9, 13, 10, 30),
      //   description: "Prezentacje dotyczące systemów i sieci komórkowych.",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala CW-1",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Sesja techniczna nr 18",
      //   subtitle: "Systemy i sieci radiokomunikacyjne dla zastosowań specjalnych",
      //   type: EventType.TechnicalSession,
      //   dateTimeStart: DateTime(2024, 9, 13, 9, 0),
      //   dateTimeEnd: DateTime(2024, 9, 13, 10, 30),
      //   description: "Prezentacje dotyczące systemów i sieci radiokomunikacyjnych dla zastosowań specjalnych",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala 022",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Sesja techniczna nr 19",
      //   subtitle: "Systemy i sieci radiofoniczne, telewizyjne i satelitarne",
      //   type: EventType.TechnicalSession,
      //   dateTimeStart: DateTime(2024, 9, 13, 9, 0),
      //   dateTimeEnd: DateTime(2024, 9, 13, 10, 30),
      //   description: "Prezentacje dotyczące systemów i sieci radiofonicznych, telewizyjnych i satelitarnych",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala 023",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Sesja techniczna nr 20",
      //   subtitle: "Kompresja wizji",
      //   type: EventType.TechnicalSession,
      //   dateTimeStart: DateTime(2024, 9, 13, 9, 0),
      //   dateTimeEnd: DateTime(2024, 9, 13, 10, 30),
      //   description: "Prezentacje dotyczące kompresji wizji",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala 027",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Sesja techniczna nr 21",
      //   subtitle: "Rozwiązania dla systemów i sieci chmurowych",
      //   type: EventType.TechnicalSession,
      //   dateTimeStart: DateTime(2024, 9, 13, 9, 0),
      //   dateTimeEnd: DateTime(2024, 9, 13, 10, 30),
      //   description: "Prezentacje dotyczące rozwiązań dla systemów i sieci chmurowych",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala 029",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Referat plenarny nr 5",
      //   subtitle: "Marcin Dryjański",
      //   type: EventType.PlenarySession,
      //   dateTimeStart: DateTime(2024, 9, 13, 11, 0),
      //   dateTimeEnd: DateTime(2024, 9, 13, 11, 45),
      //   description: "Aktualny stan standaryzacji otwartych radiowych sieci dostępowych (O-RAN).",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala CW-1",
      //   reports: [],
      //   isFavourite: false
      // ),
      // Event(
      //   title: "Referat plenarny nr 6",
      //   subtitle: "Paweł Kryszkiewicz",
      //   type: EventType.PlenarySession,
      //   dateTimeStart: DateTime(2024, 9, 13, 11, 45),
      //   dateTimeEnd: DateTime(2024, 9, 13, 12, 30),
      //   description: "Efektywne energetycznie wielodostępowe przetwarzanie brzegowe w sieci 5G",
      //   building: "Centrum Wykładowo-Konferencyjne",
      //   room: "Sala CW-1",
      //   reports: [],
      //   isFavourite: false
      // ),
    ];
  }
}
