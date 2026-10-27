# dimension-keeper-mobile

A Flutter app to explore characters from the public Rick and Morty API, save favorites, and create, edit and delete your own custom characters through a companion serverless API (dimension-keeper-backend).

## Context

Built from 29 November to 2 December 2024, together with its back end.

## What it shows

- Provider for state management. A `CharacterProvider` handles paging, search, saving, and errors through a dedicated error handler.
- A repository layer over `http`, with the base URL in a `.env` file via flutter_dotenv and a template file committed instead of real values.
- Infinite scroll with a scroll listener, pull to refresh, and a search bar.
- Small single-purpose widgets (card, grid, image header, detail sections, edit and delete dialogs) and a status enum with extensions.
- Unit tests for the provider with Mockito-generated mocks, and flutter_lints.

## Stack

Dart 3.5, Flutter, Provider, http, cached_network_image, flutter_dotenv, Mockito, build_runner.

## Run it

Copy `.env.template` to `.env` and set `BASE_URL`. Then run `flutter pub get`, `dart run build_runner build` and `flutter run`.

## Looking back (2026)

The widget test is still the default one. Today I would add widget and integration tests for the main flows, and probably use Riverpod for state.
