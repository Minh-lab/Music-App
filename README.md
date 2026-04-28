# SpotifyMe

SpotifyMe is a cross-platform music streaming application built with Flutter. It implements a modern, responsive user interface and follows Clean Architecture principles to ensure scalability, maintainability, and testability.

## Screenshots

<table border="0" cellpadding="10" cellspacing="10">
  <tr>
    <td align="center">
      <b>Sign In</b><br><br>
      <img src="screenshots/sign_in.png" width="250">
    </td>
    <td align="center">
      <b>Register</b><br><br>
      <img src="screenshots/register.png" width="250">
    </td>
    <td align="center">
      <b>Forgot Password</b><br><br>
      <img src="screenshots/forgot_password.png" width="250">
    </td>
  </tr>
  <tr>
    <td align="center">
      <b>Home</b><br><br>
      <img src="screenshots/home.jpg" width="250">
    </td>
    <td align="center">
      <b>Explore</b><br><br>
      <img src="screenshots/explore.png" width="250">
    </td>
    <td align="center">
      <b>Now Playing</b><br><br>
      <img src="screenshots/now_playing.jpg" width="250">
    </td>
  </tr>
</table>

## Architecture

This project strictly adheres to **Clean Architecture** patterns, separating concerns into three main layers:

- **Presentation**: UI components, pages, and state management using BLoC/Cubit.
- **Domain**: Business logic, use cases, and repository interfaces.
- **Data**: Data sources (remote/local), models, and repository implementations.

State management is handled via `flutter_bloc` and dependency injection is provided by `get_it`.

## Technologies Used

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: flutter_bloc, hydrated_bloc
- **Backend & Authentication**: Supabase (supabase_flutter)
- **Audio Playback**: just_audio, audio_service
- **Dependency Injection**: get_it
- **Functional Programming**: dartz (for Either monads in error handling)

## Features

- User Authentication (Sign up, Sign in, Password Recovery via OTP).
- Music streaming and audio playback controls.
- Dynamic lyric synchronization.
- Favorite tracks management.
- Responsive and modern UI design.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.10.7 or higher)
- [Dart SDK](https://dart.dev/get-dart)
- A Supabase project for the backend.

### Installation

1. Clone the repository:
   ```bash
   git clone [https://github.com/yourusername/spotify_me.git](https://github.com/yourusername/spotify_me.git)
   cd spotify_me