# Parkingapp_user

Mobilapp för att hantera parkeringar. 

## Beskrivning
Det första man måste göra är att skapa en ny användare eller logga in som befintlig användare. Om man skapar en ny användare så anger man email, namn och personnummer. Då skapas en ny Person i applikationen och avändaren loggas in.
Om man redan har registrerat sig så använder man email och lösenord för att logga in, endast email (ej lösenord) verifieras mot användardatabasen. Det är alltså en väldigt simpel autentisering.

Applikation har en view, main_view.dart, som innehåller NavigationBar och en Expanded-widget. 
När man navigerar mellan views i appen så ändrar jag view i Expanded-widgeten baserat på index i NavigationBar.

### Views
Login_View används för att logga in eller skapa ett konto.
Parkings_view innehåller alla funktioner för att starta och avsluta parkeringar, och man kan även se statisk om parkeringar. 
När man startar en ny parkering så väljer man sitt fordon och vilken parkeringsplats som ska användas, endast lediga parkeringsplatser kan väljas.
Vehicles_view innehåller alla fordon som man registrerat. Man kan se information om fordon och lägga till och ta bort fordon.
Account_view innehåller användares data: email, namn och personnr. Man kan redigera datan.

### Blocs
Alla anrop för att hämta data från servern sker via Blocs som i sin tur använder repos för att hämta data. Alla views tittar på AuthBloc för att få ut personen som är inloggad så att vi kan få ut fordon m.m. som tillhör användaren.

### Repos
Samma repos används som från tidigare inlämning, mindre uppdateringar för att harmonisera namn på metoder

### Bloctest
Det finns ett success och ett error-test för varje bloc

