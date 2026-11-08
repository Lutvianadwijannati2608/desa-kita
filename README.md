# DESA-KITA
## Sistem Informasi Kegiatan dan Pelayanan Desa

### Deskripsi
DESA-KITA merupakan proyek sistem informasi desa yang dirancang untuk membantu pengelolaan data penduduk, perangkat desa, kegiatan desa, pendaftaran kegiatan, pengumuman, serta pengajuan layanan desa.

Proyek ini menggunakan PostgreSQL sebagai database dan Express.js sebagai backend REST API.

### Tujuan
- Mengelola data penduduk dan perangkat desa.
- Mengelola kategori dan kegiatan desa.
- Mendukung pendaftaran kegiatan oleh penduduk.
- Menyediakan pengelolaan pengumuman desa.
- Mengelola jenis layanan dan pengajuan layanan desa.

### Teknologi yang Digunakan
- PostgreSQL 18
- Node.js
- Express.js
- JavaScript
- Postman
- dbdiagram.io

### Struktur Database
Database DESA-KITA terdiri dari 9 tabel:
1. users
2. penduduk
3. perangkat_desa
4. kategori_kegiatan
5. kegiatan
6. pendaftaran_kegiatan
7. pengumuman
8. jenis_layanan
9. pengajuan_layanan

Database memiliki relasi one-to-one, one-to-many, dan many-to-many.

### REST API
Backend menyediakan endpoint untuk pengelolaan data kegiatan desa:

| Method | Endpoint | Fungsi |
|---|---|---|
| GET | `/api/kegiatan` | Menampilkan semua kegiatan |
| GET | `/api/kegiatan/:id` | Menampilkan kegiatan berdasarkan ID |
| POST | `/api/kegiatan` | Menambahkan kegiatan |
| PUT | `/api/kegiatan/:id` | Mengubah kegiatan |
| DELETE | `/api/kegiatan/:id` | Menghapus kegiatan |

### Cara Menjalankan Backend
1. Clone repository ini.
2. Masuk ke folder backend:
   `cd express-api`
3. Install dependencies:
   `npm install`
4. Buat file `.env` berdasarkan konfigurasi berikut:

   ```env
   DB_USER=postgres
   DB_HOST=localhost
   DB_NAME=desa_kita
   DB_PASSWORD=password_postgresql
   DB_PORT=5432
   PORT=3000
   ```

5. Sesuaikan password PostgreSQL dengan konfigurasi lokal.
6. Import file `database/desa_kita.sql` ke PostgreSQL.
7. Jalankan server:

   `node server.js`

8. Akses API melalui:

   `http://localhost:3000/api/kegiatan`

### Database
File SQL tersedia pada folder `database` dengan nama `desa_kita.sql`.

### Pengembang
Proyek ini dibuat untuk memenuhi tugas pengembangan backend dan database menggunakan PostgreSQL dan Express.js.
