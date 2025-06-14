# MAK KRiT - Mobilna Aplikacja Konferencyjna 
**Autorzy:** [`Agnieszka Kulesz`](https://github.com/agatherat), [`Weronika Koterba`](https://github.com/weronikakoterba), [`Hania Gibus`](https://github.com/haniagibus)

**Projekt stworzony na potrzeby:** Konferencji Radiokomunikacji i Teleinformatyki 2025 [`KRiT 2025`](https://krit.com.pl/#/)

## Technologie
- [`Flutter`](https://flutter.dev/) 
- [`Dart`](https://dart.dev/)

## Opis projektu
**MAK KRiT** to aplikacja mobilna zaprojektowana z myślą o uczestnikach KRiT 2025. Ułatwia nawigację podczas wydarzenia oraz zapewnia dostęp do najważniejszych informacji, takich jak:
- Program konferencji
- Lista referatów
- Szczegóły sesji i wydarzeń
- Panel administracyjny (dla organizatorów)

Backend aplikacji dostępny [`tutaj`](https://github.com/akulesz/KRiT_2025_api)

## Wymagania wstępne
- Flutter SDK - ver. 3.27.1
- Dart SDK - ver. 3.6.1

[`Do uruchomienia w emulatorze`](#1.-uruchom-za-pomocą-emulatora)
- Android Studio

[`Do uruchomienia przez serwer lokalny`](###2.-uruchom-za-pomocą-serwera-lokalnego)
- Python _(serwer HTTP)_
- Ngrok _(tunelowanie HTTPS)_

## Instrukcja uruchomienia
### _1. Uruchom za pomocą emulatora_
1. Sklonuj repozytorium
```console
git clone https://github.com/haniagibus/KRiT_2025_app.git
```
3. Zainstaluj zależności
```console
flutter pub get
```
3. Uruchom emulator lub podłącz telefon
4. Uruchom aplikację
```console
flutter run
```

Po uruchomieniu aplikacja wyświetli się na wybranym emulatorze/urządzeniu.

### _2. Uruchom za pomocą serwera lokalnego_
_0.1. Zainstaluj ngrok_ ```choco install ngrok```

_0.2. Stwórz konto [`ngrok`](https://ngrok.com/) i dodaj swój token_ ```ngrok config add-authtoken $YOUR_AUTHTOKEN```

1. Sklonuj repozytorium
```console
git clone https://github.com/haniagibus/KRiT_2025_app.git
```
2. Zainstaluj zależności
```console
flutter pub get
```
3. Zbuduj aplikację webową
```console
flutter build web
```
4. Przejdź do katalogu wygenerowanej aplikacji webowej
```console
cd build/web
```
5. Uruchom serwer http
```console
python -m http.server 8081
```
6. W oddzielnej konsoli uruchom tunelowanie https
```console
ngrok http 8081
```
7. Sprawdź adres IP koputera w sieci lokalnej ```ipconfig```
8. Otwórz aplikację na dowolnym urządzeniu w sieci lokalnej, wpisując w przeglądarce
```console
http://$YOUR_IP_ADDR:8081
```

Na urządzeniach mobilnych po dodaniu aplikacji do ekranu głównego będzie się ona otwierać jak aplikacja natywna.
