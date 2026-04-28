# SpotifyMe

SpotifyMe là ứng dụng nghe nhạc đa nền tảng được xây dựng bằng Flutter.  
Dự án sử dụng Clean Architecture để đảm bảo khả năng mở rộng, dễ bảo trì và dễ kiểm thử.

---

## Screenshots

### Authentication
- **Sign In**  
  ![](screenshots/sign_in.png)

- **Register**  
  ![](screenshots/register.png)

- **Forgot Password**  
  ![](screenshots/forgot_password.png)

### Main Features
- **Home**  
  ![](screenshots/home.jpg)

- **Explore**  
  ![](screenshots/explore.png)

- **Favourite**  
  ![](screenshots/favourite.png)

- **Profile**  
  ![](screenshots/profile.png)

- **Now Playing**  
  ![](screenshots/now_playing.jpg)

---

## Architecture

Dự án tuân theo mô hình Clean Architecture với 3 layer chính:

- **Presentation**  
  UI, màn hình, và quản lý state (BLoC/Cubit)

- **Domain**  
  Business logic, use cases, repository interface

- **Data**  
  Data source (remote/local), model, repository implementation

State management sử dụng `flutter_bloc`  
Dependency injection sử dụng `get_it`

---

## Technologies

- Flutter
- Dart
- flutter_bloc, hydrated_bloc
- supabase_flutter
- just_audio, audio_service
- get_it
- dartz

---

## Features

- Xác thực người dùng (đăng ký, đăng nhập, quên mật khẩu qua OTP)
- Phát nhạc và điều khiển playback
- Đồng bộ lời bài hát theo thời gian
- Quản lý bài hát yêu thích
- Giao diện responsive, hiện đại

---

## Getting Started

### Prerequisites

- Flutter SDK (>= 3.10.7)
- Dart SDK
- Supabase project

---

### Installation

```bash
git clone https://github.com/yourusername/spotify_me.git
cd spotify_me