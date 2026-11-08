const express = require('express');
require('dotenv').config();

const app = express();
const kegiatanRoutes = require('./routes/kegiatan');

app.use(express.json());

app.get('/', (req, res) => {
    res.json({
        message: 'API DESA-KITA berhasil dijalankan'
    });
});

app.use('/api/kegiatan', kegiatanRoutes);

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Server berjalan di http://localhost:${PORT}`);
});