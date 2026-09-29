# SmartInterestX — Loan & Interest Management

A beginner-friendly Flutter project based directly on the supplied project specification PDF.

## What is included

- Loan/transaction entry
- Given / Taken transaction type
- Borrower / Lender contacts
- Simple interest: monthly and yearly rates
- Interest till today
- Interest till due date
- Partial and full payments
- Payment history
- Payment mode: UPI / Bank Transfer / Cash / Other
- Receipt/screenshot picker
- Due-date reminders
- Dashboard cards
- Given vs Taken chart
- Monthly interest chart
- Month/year/contact filters
- CSV export
- Local database backup
- Simple app PIN
- Beginner-friendly Provider architecture

## Interface language

The supplied PDF does not specify a required interface language. This implementation uses **English** for the user interface.

## Important scope note

The PDF says Firebase/Google Drive cloud backup is optional/recommended. This student version uses a local SQLite database and local CSV backup so it can be easier for a beginner to understand and run. Firebase can be added later.

## Run

1. Install Flutter.
2. Open this folder in Android Studio or VS Code.
3. Run:

   flutter pub get
   flutter run

## Android notes

The project uses:
- SQLite for local data
- image_picker for receipt/screenshot selection
- flutter_local_notifications for local reminders
- shared_preferences for the simple PIN

For a real release build, Android notification permissions and other platform settings should be checked for the installed Flutter/plugin versions.

## Interest formula

Simple interest:

Interest = Principal × Rate × Time / 100

For a yearly rate:
Time = number of days / 365

For a monthly rate:
Time = number of days / 30

The app treats the rate as a percentage per year or per month according to the selected rate type.

## PDF requirements covered

The supplied document asks for:
1. Complete Flutter source code
2. APK build
3. Database schema / ER diagram
4. Feature screenshots
5. User flow diagram
6. Technical documentation
7. Demo video

This ZIP contains the source project plus `docs/` with the database schema, user flow and technical notes. APK and demo video are not generated here because they require building/running the project on an Android/Flutter environment.
