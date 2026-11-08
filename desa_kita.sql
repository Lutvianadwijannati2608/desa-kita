
-- =====================================================
-- DATABASE : DESA_KITA
-- PROJECT  : SISTEM INFORMASI KEGIATAN DAN PELAYANAN DESA
-- DBMS     : POSTGRESQL
-- =====================================================


-- =====================================================
-- 1. TABEL USERS
-- Menyimpan akun pengguna sistem
-- =====================================================

CREATE TABLE users (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'penduduk'
        CHECK (role IN ('admin', 'perangkat', 'penduduk')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- =====================================================
-- 2. TABEL PENDUDUK
-- Menyimpan data penduduk desa
-- Relasi One to One dengan tabel users
-- =====================================================

CREATE TABLE penduduk (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL UNIQUE,
    nik VARCHAR(16) NOT NULL UNIQUE,
    nama_lengkap VARCHAR(100) NOT NULL,
    jenis_kelamin VARCHAR(15) NOT NULL
        CHECK (jenis_kelamin IN ('Laki-laki', 'Perempuan')),
    tempat_lahir VARCHAR(50),
    tanggal_lahir DATE,
    alamat TEXT NOT NULL,
    no_telepon VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_penduduk_users
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
);


-- =====================================================
-- 3. TABEL PERANGKAT_DESA
-- Menyimpan data perangkat desa
-- Relasi One to One dengan tabel penduduk
-- =====================================================

CREATE TABLE perangkat_desa (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    penduduk_id BIGINT NOT NULL UNIQUE,
    jabatan VARCHAR(100) NOT NULL,
    masa_jabatan_mulai DATE,
    masa_jabatan_selesai DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_perangkat_penduduk
        FOREIGN KEY (penduduk_id)
        REFERENCES penduduk(id)
        ON DELETE CASCADE
);


-- =====================================================
-- 4. TABEL KATEGORI_KEGIATAN
-- Menyimpan kategori kegiatan desa
-- =====================================================

CREATE TABLE kategori_kegiatan (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL UNIQUE,
    deskripsi TEXT
);


-- =====================================================
-- 5. TABEL KEGIATAN
-- Menyimpan informasi kegiatan desa
-- Relasi One to Many dengan kategori_kegiatan
-- =====================================================

CREATE TABLE kegiatan (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    kategori_id BIGINT NOT NULL,
    created_by BIGINT NOT NULL,
    nama_kegiatan VARCHAR(150) NOT NULL,
    deskripsi TEXT,
    lokasi VARCHAR(150) NOT NULL,
    tanggal_kegiatan DATE NOT NULL,
    waktu_mulai TIME NOT NULL,
    waktu_selesai TIME,
    kuota_peserta INTEGER CHECK (kuota_peserta IS NULL OR kuota_peserta > 0),
    status VARCHAR(20) NOT NULL DEFAULT 'direncanakan'
        CHECK (status IN ('direncanakan', 'berlangsung', 'selesai', 'dibatalkan')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_kegiatan_kategori
        FOREIGN KEY (kategori_id)
        REFERENCES kategori_kegiatan(id),

    CONSTRAINT fk_kegiatan_penduduk
        FOREIGN KEY (created_by)
        REFERENCES penduduk(id),

    CONSTRAINT cek_waktu_kegiatan
        CHECK (waktu_selesai IS NULL OR waktu_selesai > waktu_mulai)
);


-- =====================================================
-- 6. TABEL PENDAFTARAN_KEGIATAN
-- Tabel penghubung penduduk dan kegiatan
-- Relasi Many to Many
-- =====================================================

CREATE TABLE pendaftaran_kegiatan (
    penduduk_id BIGINT NOT NULL,
    kegiatan_id BIGINT NOT NULL,
    tanggal_daftar TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_pendaftaran VARCHAR(20) NOT NULL DEFAULT 'terdaftar'
        CHECK (status_pendaftaran IN ('terdaftar', 'hadir', 'tidak_hadir', 'dibatalkan')),

    PRIMARY KEY (penduduk_id, kegiatan_id),

    CONSTRAINT fk_pendaftaran_penduduk
        FOREIGN KEY (penduduk_id)
        REFERENCES penduduk(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_pendaftaran_kegiatan
        FOREIGN KEY (kegiatan_id)
        REFERENCES kegiatan(id)
        ON DELETE CASCADE
);


-- =====================================================
-- 7. TABEL PENGUMUMAN
-- Menyimpan informasi dan pengumuman desa
-- Relasi One to Many dengan penduduk
-- =====================================================

CREATE TABLE pengumuman (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    penulis_id BIGINT NOT NULL,
    judul VARCHAR(150) NOT NULL,
    isi_pengumuman TEXT NOT NULL,
    tanggal_publikasi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tanggal_berakhir DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'aktif'
        CHECK (status IN ('aktif', 'tidak_aktif')),

    CONSTRAINT fk_pengumuman_penduduk
        FOREIGN KEY (penulis_id)
        REFERENCES penduduk(id),

    CONSTRAINT cek_tanggal_pengumuman
        CHECK (tanggal_berakhir IS NULL OR tanggal_berakhir >= tanggal_publikasi::DATE)
);


-- =====================================================
-- 8. TABEL JENIS_LAYANAN
-- Menyimpan jenis layanan administrasi desa
-- =====================================================

CREATE TABLE jenis_layanan (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nama_layanan VARCHAR(100) NOT NULL UNIQUE,
    deskripsi TEXT,
    persyaratan TEXT,
    estimasi_hari INTEGER CHECK (estimasi_hari IS NULL OR estimasi_hari >= 0)
);


-- =====================================================
-- 9. TABEL PENGAJUAN_LAYANAN
-- Menyimpan pengajuan layanan administrasi penduduk
-- Relasi One to Many dengan penduduk dan jenis_layanan
-- =====================================================

CREATE TABLE pengajuan_layanan (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    penduduk_id BIGINT NOT NULL,
    layanan_id BIGINT NOT NULL,
    nomor_pengajuan VARCHAR(50) NOT NULL UNIQUE,
    keperluan TEXT NOT NULL,
    tanggal_pengajuan TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'menunggu'
        CHECK (status IN ('menunggu', 'diproses', 'selesai', 'ditolak')),
    catatan_admin TEXT,

    CONSTRAINT fk_pengajuan_penduduk
        FOREIGN KEY (penduduk_id)
        REFERENCES penduduk(id),

    CONSTRAINT fk_pengajuan_jenis_layanan
        FOREIGN KEY (layanan_id)
        REFERENCES jenis_layanan(id)
);


-- =====================================================
-- INDEX UNTUK MEMPERCEPAT PENCARIAN DATA
-- =====================================================

CREATE INDEX idx_kegiatan_kategori
ON kegiatan(kategori_id);

CREATE INDEX idx_kegiatan_tanggal
ON kegiatan(tanggal_kegiatan);

CREATE INDEX idx_pengumuman_penulis
ON pengumuman(penulis_id);

CREATE INDEX idx_pengajuan_penduduk
ON pengajuan_layanan(penduduk_id);

CREATE INDEX idx_pengajuan_layanan
ON pengajuan_layanan(layanan_id);


-- =====================================================
-- SELESAI
-- DATABASE DESA_KITA BERHASIL DIRANCANG
-- =====================================================
