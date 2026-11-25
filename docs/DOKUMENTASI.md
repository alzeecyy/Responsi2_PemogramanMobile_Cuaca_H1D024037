# Dokumentasi Singkat Aplikasi Cuaca Kita

## 1. Struktur Aplikasi

Kode aplikasi berada di dalam folder `lib/` dan dibagi menjadi lima bagian. Folder `models` berisi kelas data `LocationModel`, `CurrentWeather`, `DailyForecast`, dan `WeatherModel`. Folder `services` berisi `WeatherService` yang bertanggung jawab atas komunikasi jaringan serta `LocalStorageService` yang bertanggung jawab atas penyimpanan lokal. Folder `viewmodels` berisi `WeatherViewModel` untuk layar cuaca dan `LocationViewModel` untuk layar pencarian. Folder `views` berisi dua layar utama, yaitu `HomeScreen` dan `SearchScreen`, beserta widget pendukung pada `views/widgets`. Folder `core` berisi pengaturan Theme Material 3 dan pemetaan kode cuaca WMO ke deskripsi berbahasa Indonesia dan ikon.

Aplikasi menggunakan `StatelessWidget` untuk tampilan yang hanya bergantung pada data dari ViewModel, dan `StatefulWidget` pada `SearchScreen` karena layar tersebut perlu mengelola `TextEditingController`. Antarmuka mengikuti Material Design 3 dengan `ColorScheme.fromSeed`, mendukung mode terang dan gelap, serta dibatasi lebar maksimum 640 dp agar tetap nyaman pada layar lebar.

## 2. Implementasi API

Aplikasi menggunakan dua endpoint Open-Meteo melalui paket `http` dengan metode GET. Pencarian kota memakai Geocoding API pada `https://geocoding-api.open-meteo.com/v1/search` dengan parameter `name`, `count`, `language`, dan `format`. Data cuaca memakai Weather Forecast API pada `https://api.open-meteo.com/v1/forecast` dengan parameter `latitude`, `longitude`, `timezone=auto`, `current` (`temperature_2m`, `relative_humidity_2m`, `apparent_temperature`, `precipitation`, `weather_code`, `wind_speed_10m`), dan `daily` (`weather_code`, `temperature_2m_max`, `temperature_2m_min`, `precipitation_probability_max`).

Respons JSON diubah menjadi model Dart melalui factory `fromJson`. Seluruh data yang tampil berasal dari respons API dan tidak ada data statis. Setiap permintaan pencarian benar-benar mengirim request ke Geocoding API, dengan jeda debounce 500 ms agar tidak mengirim request pada setiap ketukan tombol. Kegagalan jaringan, timeout, kode status selain 200, format respons yang tidak valid, dan data kosong dikonversi menjadi `ApiException` atau `EmptyDataException` sehingga ViewModel dapat menampilkan pesan yang sesuai. Permintaan lama yang selesai setelah permintaan baru diabaikan menggunakan penghitung `_requestId`.

## 3. Penerapan MVVM

Pola MVVM memisahkan aplikasi menjadi tiga lapisan. Lapisan Model terdiri atas kelas data dan service yang mengakses API maupun penyimpanan lokal. Lapisan ViewModel merupakan turunan `ChangeNotifier` yang menyimpan state (`ViewState` atau `SearchStatus`, data, dan pesan error), menjalankan logika bisnis, dan memanggil service. Lapisan View hanya menampilkan state dari ViewModel melalui `context.watch` dan meneruskan aksi pengguna ke ViewModel melalui `context.read`, tanpa memanggil API secara langsung.

`WeatherViewModel` mengelola lokasi yang dipilih, data cuaca, dan status pemuatan pada layar utama. Ketika aplikasi dibuka, ViewModel ini memuat lokasi terakhir dari penyimpanan lokal, atau Jakarta apabila belum ada. `LocationViewModel` mengelola hasil pencarian, daftar favorit, dan riwayat pencarian. Ketika pengguna memilih lokasi pada `SearchScreen`, lokasi tersebut ditambahkan ke riwayat, diteruskan ke `WeatherViewModel.selectLocation`, dan layar kembali ke `HomeScreen` yang otomatis diperbarui. Dependensi disediakan di `main.dart` melalui `MultiProvider`.

## 4. Penyimpanan Lokal

`LocalStorageService` menggunakan SharedPreferences untuk menyimpan tiga data: daftar lokasi favorit, riwayat pencarian (maksimal 10 lokasi), dan lokasi terakhir yang dipilih. Setiap lokasi disimpan sebagai string JSON. Data dimuat ulang oleh ViewModel pada saat `init()` sehingga tampil kembali setiap aplikasi dibuka.
