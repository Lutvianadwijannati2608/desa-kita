const express = require('express');
const router = express.Router();
const pool = require('../config/database');

// GET: Mendapatkan semua kegiatan
router.get('/', async (req, res) => {
    try {
        const result = await pool.query(
            'SELECT * FROM kegiatan ORDER BY id ASC'
        );
        res.json(result.rows);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// GET: Mendapatkan kegiatan berdasarkan ID
router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const result = await pool.query(
            'SELECT * FROM kegiatan WHERE id = $1',
            [id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: 'Kegiatan tidak ditemukan'
            });
        }

        res.json(result.rows[0]);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// POST: Menambahkan kegiatan
router.post('/', async (req, res) => {
    try {
        const {
            kategori_id,
            created_by,
            nama_kegiatan,
            deskripsi,
            lokasi,
            tanggal_kegiatan,
            waktu_mulai,
            waktu_selesai,
            kuota_peserta
        } = req.body;

        const result = await pool.query(
            `INSERT INTO kegiatan
            (kategori_id, created_by, nama_kegiatan, deskripsi,
            lokasi, tanggal_kegiatan, waktu_mulai,
            waktu_selesai, kuota_peserta)
            VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)
            RETURNING *`,
            [
                kategori_id,
                created_by,
                nama_kegiatan,
                deskripsi,
                lokasi,
                tanggal_kegiatan,
                waktu_mulai,
                waktu_selesai || null,
                kuota_peserta || null
            ]
        );

        res.status(201).json({
            message: 'Kegiatan berhasil ditambahkan',
            data: result.rows[0]
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// PUT: Memperbarui kegiatan
router.put('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const {
            kategori_id,
            created_by,
            nama_kegiatan,
            deskripsi,
            lokasi,
            tanggal_kegiatan,
            waktu_mulai,
            waktu_selesai,
            kuota_peserta,
            status
        } = req.body;

        const result = await pool.query(
            `UPDATE kegiatan SET
            kategori_id=$1, created_by=$2, nama_kegiatan=$3,
            deskripsi=$4, lokasi=$5, tanggal_kegiatan=$6,
            waktu_mulai=$7, waktu_selesai=$8,
            kuota_peserta=$9, status=$10
            WHERE id=$11 RETURNING *`,
            [
                kategori_id,
                created_by,
                nama_kegiatan,
                deskripsi,
                lokasi,
                tanggal_kegiatan,
                waktu_mulai,
                waktu_selesai || null,
                kuota_peserta || null,
                status,
                id
            ]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: 'Kegiatan tidak ditemukan'
            });
        }

        res.json({
            message: 'Kegiatan berhasil diperbarui',
            data: result.rows[0]
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// DELETE: Menghapus kegiatan
router.delete('/:id', async (req, res) => {
    try {
        const { id } = req.params;

        const result = await pool.query(
            'DELETE FROM kegiatan WHERE id = $1 RETURNING *',
            [id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: 'Kegiatan tidak ditemukan'
            });
        }

        res.json({
            message: 'Kegiatan berhasil dihapus',
            data: result.rows[0]
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

module.exports = router;