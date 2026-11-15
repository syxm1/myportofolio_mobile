# MyPortfolio Mobile

Aplikasi portofolio mobile untuk tugas mata kuliah Pemrograman Berbasis Platform (PBP). Proyek ini dibuat dengan Flutter dan saat ini menampilkan halaman beranda sederhana berisi identitas mahasiswa serta menu portofolio.

**Pengembang:** Hisyam Prasetyo · **NPM:** 2506614763 · **Kelas:** PBP D

## Persiapan dan menjalankan aplikasi

1. Pasang [Flutter SDK](https://docs.flutter.dev/get-started/install) yang mendukung Dart `^3.13.7`, lalu siapkan Android SDK dan emulator atau perangkat Android. Untuk menjalankan di iOS, diperlukan macOS dan Xcode.
2. Periksa instalasi dan perangkat yang tersedia:

   ```bash
   flutter doctor
   flutter devices
   ```

3. Masuk ke direktori proyek ini, ambil dependensi, lalu jalankan aplikasi:

   ```bash
   cd myportofolio_mobile
   flutter pub get
   flutter run
   ```

   Jika ada beberapa perangkat, pilih target dengan `flutter run -d <device-id>`; ID perangkat dapat dilihat dari `flutter devices`.

Proyek ini tidak memerlukan berkas `.env`, akun, atau layanan backend untuk menampilkan halaman beranda saat ini.

## AI disclosure

Proyek ini dibuat menggunakan **ChatGPT (GPT-6 Sol dan GPT-6 Luna)** sebagai alat bantu untuk memahami materi, menyusun rencana implementasi, mencari kemungkinan bug, dan memeriksa kode. Pada pekerjaan dokumentasi ini, AI juga membantu menyusun README berdasarkan isi berkas dan riwayat commit proyek. 

- [Chat log Tugas 8](https://chatgpt.com/s/cx_6af9e74eb0108191817d44d7fe3371a1)

## Pertanyaan reflektif

1. Widget tree adalah susunan bertingkat dari widget yang membentuk tampilan Flutter. Widget induk (parent) menempatkan widget anak (child) melalui properti seperti child atau children; misalnya, pada proyek ini Scaffold memuat AppBar dan isi halaman, lalu Row mengatur tiga InfoCard. Susunan induk-anak ini menentukan struktur tampilan dan konteks yang tersedia bagi setiap widget.
2. Widget yang digunakan dalam kode proyek ini adalah MyApp (membangun aplikasi), MaterialApp (mengatur aplikasi Material), MyHomePage (halaman beranda), Scaffold (kerangka halaman), AppBar (bilah judul), Text (teks), Padding (jarak di sekitar anak), Column (susunan vertikal), Row (susunan horizontal), InfoCard (kartu identitas buatan proyek), Card (permukaan kartu), Container (wadah untuk ukuran dan jarak), SizedBox (jarak kosong), Center (memusatkan anak), GridView.count (kisi tiga kolom), ItemCard (tombol menu buatan proyek), Material (permukaan tombol), InkWell (mendeteksi ketukan dan memberi efek sentuh), Icon (ikon menu), serta SnackBar (pesan singkat setelah tombol ditekan). ThemeData dan ColorScheme adalah objek konfigurasi tema, bukan widget.
3. MaterialApp menyiapkan kebutuhan umum aplikasi bergaya Material Design, termasuk tema dan pengaturan halaman atau rute. Widget ini biasanya diletakkan dekat akar widget tree agar halaman di bawahnya dapat memakai pengaturan yang sama. Dalam proyek ini, MyApp adalah widget yang diberikan ke runApp(), sedangkan metode build miliknya mengembalikan MaterialApp dengan tema indigo dan MyHomePage sebagai halaman awal.
4. StatelessWidget tidak menyimpan state yang berubah di dalam dirinya, sehingga cocok untuk tampilan yang ditentukan oleh data masukan dan konteks, seperti InfoCard dalam proyek ini. StatefulWidget memiliki objek State yang dapat menyimpan nilai yang berubah; pemanggilan setState() meminta Flutter membangun ulang tampilannya. Gunakan StatefulWidget ketika widget perlu mengelola perubahan lokal, misalnya pilihan tab atau isi formulir. StatelessWidget tetap dapat dibangun ulang ketika induk atau data konteksnya berubah.
5. BuildContext adalah penunjuk lokasi sebuah widget dalam widget tree. Parameter context pada metode build memungkinkan widget mencari data atau layanan dari bagian pohon di atasnya; proyek ini, misalnya, memakai Theme.of(context) untuk warna tema dan MediaQuery.of(context) untuk lebar layar. ScaffoldMessenger.of(context) juga memakai konteks untuk menampilkan SnackBar. Karena konteks terkait dengan lokasi widget, konteks yang dipakai harus berasal dari bagian pohon yang tepat.
6. Hot reload memasukkan perubahan kode Dart ke aplikasi yang sedang berjalan dan membangun ulang tampilan sambil mempertahankan state; proses ini biasanya cocok untuk mencoba perubahan UI. Hot restart menjalankan ulang aplikasi Flutter dari main() dan menghapus state yang sedang tersimpan, sehingga diperlukan ketika perubahan pada main(), initState(), atau nilai awal tertentu tidak terlihat setelah hot reload. Full restart menghentikan dan menjalankan ulang aplikasi, termasuk membangun ulang kode platform bila diperlukan, misalnya setelah perubahan pada kode Android atau iOS.