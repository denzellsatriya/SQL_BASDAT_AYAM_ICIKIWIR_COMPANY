-- =========================
-- DDL (CREATE TABLE)
-- =========================

CREATE TABLE staff (
    id_staff NUMBER(7) PRIMARY KEY,
    username VARCHAR2(15) NOT NULL,
    password VARCHAR2(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pemilik_toko (
    id_pemilik NUMBER(7) PRIMARY KEY,
    username VARCHAR2(15) NOT NULL,
    password VARCHAR2(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE meja (
    id_meja NUMBER(7) PRIMARY KEY,
    nomor_meja NUMBER(3) NOT NULL,
    qr_code CLOB,
    status VARCHAR2(30),
    CONSTRAINT chk_status_meja CHECK (status IN ('kosong', 'terisi'))
);

CREATE TABLE pelanggan (
    id_pelanggan NUMBER(7) PRIMARY KEY,
    nama VARCHAR2(30) NOT NULL,
    id_meja NUMBER(7),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pelanggan_meja FOREIGN KEY (id_meja) REFERENCES meja(id_meja)
);

CREATE TABLE menu (
    id_menu NUMBER(7) PRIMARY KEY,
    id_pemilik NUMBER(7) NOT NULL,
    nama_menu VARCHAR2(20) NOT NULL,
    nama_kategori VARCHAR2(20),
    harga NUMBER(8) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_menu_pemilik FOREIGN KEY (id_pemilik) REFERENCES pemilik_toko(id_pemilik)
);

CREATE TABLE pemesanan (
    id_pemesanan NUMBER(7) PRIMARY KEY,
    id_meja NUMBER(7) NOT NULL,
    id_pelanggan NUMBER(7) NOT NULL,
    status VARCHAR2(30) DEFAULT 'menunggu',
    total_harga NUMBER(10) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pemesanan_meja FOREIGN KEY (id_meja) REFERENCES meja(id_meja),
    CONSTRAINT fk_pemesanan_pelanggan FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan),
    CONSTRAINT chk_status_pemesanan CHECK (status IN ('menunggu', 'diproses', 'selesai', 'dibatalkan'))
);

CREATE TABLE detail_pemesanan (
    id_dp NUMBER(7) PRIMARY KEY,
    id_pemesanan NUMBER(7) NOT NULL,
    id_menu NUMBER(7) NOT NULL,
    qty NUMBER(6) NOT NULL,
    harga_saat_pesan NUMBER(8) NOT NULL,
    catatan CLOB,
    CONSTRAINT fk_detail_pemesanan FOREIGN KEY (id_pemesanan) REFERENCES pemesanan(id_pemesanan),
    CONSTRAINT fk_detail_menu FOREIGN KEY (id_menu) REFERENCES menu(id_menu)
);

CREATE TABLE pembayaran (
    id_bayar NUMBER(7) PRIMARY KEY,
    id_pemesanan NUMBER(7) NOT NULL,
    status VARCHAR2(30),
    waktu_bayar TIMESTAMP NULL,
    CONSTRAINT fk_pembayaran_pemesanan FOREIGN KEY (id_pemesanan) REFERENCES pemesanan(id_pemesanan),
    CONSTRAINT chk_status_pembayaran CHECK (status IN ('belum bayar', 'menunggu verifikasi', 'lunas'))
);

CREATE TABLE konfirmasi_pemesanan (
    id_konfirmasi NUMBER(7) PRIMARY KEY,
    id_pemesanan NUMBER(7) NOT NULL,
    id_staff NUMBER(7) NOT NULL,
    status_konfirmasi VARCHAR2(50),
    waktu_konfirmasi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_konfirmasi_pemesanan FOREIGN KEY (id_pemesanan) REFERENCES pemesanan(id_pemesanan),
    CONSTRAINT fk_konfirmasi_staff FOREIGN KEY (id_staff) REFERENCES staff(id_staff),
    CONSTRAINT chk_status_konfirmasi CHECK (status_konfirmasi IN ('menunggu pembayaran', 'siap diproduksi', 'dibatalkan'))
);

CREATE TABLE perhitungan_margin (
    id_margin NUMBER(7) PRIMARY KEY,
    id_pemilik NUMBER(7) NOT NULL,
    id_menu NUMBER(7) NOT NULL,
    harga_modal NUMBER(8) NOT NULL,
    harga_jual NUMBER(8) NOT NULL,
    margin_nominal NUMBER(10) NOT NULL,
    margin_persen NUMBER(5,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_margin_pemilik FOREIGN KEY (id_pemilik) REFERENCES pemilik_toko(id_pemilik),
    CONSTRAINT fk_margin_menu FOREIGN KEY (id_menu) REFERENCES menu(id_menu)
);


-- =========================
-- DML (INSERT DATA)
-- =========================

INSERT INTO staff VALUES (1, 'denzell_satriya', 'denzell123', CURRENT_TIMESTAMP);
INSERT INTO staff VALUES (2, 'ayub_destama', 'ayub123', CURRENT_TIMESTAMP);
INSERT INTO staff VALUES (3, 'naufal_ariq', 'naufal123', CURRENT_TIMESTAMP);
INSERT INTO staff VALUES (4, 'sheva_ibrahim', 'sheva123', CURRENT_TIMESTAMP);

INSERT INTO pemilik_toko VALUES (1, 'mbak_dira', 'dira123', CURRENT_TIMESTAMP);

INSERT INTO meja VALUES (1, 1, 'https://cafepakcek.com/table/1', 'terisi');
INSERT INTO meja VALUES (2, 2, 'https://cafepakcek.com/table/2', 'terisi');
INSERT INTO meja VALUES (3, 3, 'https://cafepakcek.com/table/3', 'terisi');
INSERT INTO meja VALUES (4, 4, 'https://cafepakcek.com/table/4', 'terisi');
INSERT INTO meja VALUES (5, 5, 'https://cafepakcek.com/table/5', 'kosong');

INSERT INTO pelanggan VALUES (1, 'Lacey Junelly', 1, CURRENT_TIMESTAMP);
INSERT INTO pelanggan VALUES (2, 'Karen Romay', 2, CURRENT_TIMESTAMP);
INSERT INTO pelanggan VALUES (3, 'Citra Kasih', 3, CURRENT_TIMESTAMP);
INSERT INTO pelanggan VALUES (4, 'Tuan Putri', 4, CURRENT_TIMESTAMP);

INSERT INTO menu VALUES (1, 1, 'Nasi Goreng', 'Makanan', 25000, CURRENT_TIMESTAMP);
INSERT INTO menu VALUES (2, 1, 'Bakmi Goreng', 'Makanan', 22000, CURRENT_TIMESTAMP);
INSERT INTO menu VALUES (3, 1, 'Nasi Campur', 'Makanan', 27000, CURRENT_TIMESTAMP);
INSERT INTO menu VALUES (4, 1, 'Es Pisang Ijo', 'Camilan', 15000, CURRENT_TIMESTAMP);
INSERT INTO menu VALUES (5, 1, 'Ramen', 'Makanan', 35000, CURRENT_TIMESTAMP);
INSERT INTO menu VALUES (6, 1, 'Gorengan', 'Camilan', 5000, CURRENT_TIMESTAMP);
INSERT INTO menu VALUES (7, 1, 'Es Teh Manis', 'Minuman', 5000, CURRENT_TIMESTAMP);

INSERT INTO perhitungan_margin VALUES (1, 1, 1, 15000, 25000, 10000, 40.00, CURRENT_TIMESTAMP);
INSERT INTO perhitungan_margin VALUES (2, 1, 2, 13000, 22000, 9000, 40.91, CURRENT_TIMESTAMP);
INSERT INTO perhitungan_margin VALUES (3, 1, 3, 17000, 27000, 10000, 37.04, CURRENT_TIMESTAMP);
INSERT INTO perhitungan_margin VALUES (4, 1, 4, 9000, 15000, 6000, 40.00, CURRENT_TIMESTAMP);
INSERT INTO perhitungan_margin VALUES (5, 1, 5, 20000, 35000, 15000, 42.86, CURRENT_TIMESTAMP);
INSERT INTO perhitungan_margin VALUES (6, 1, 6, 2000, 5000, 3000, 60.00, CURRENT_TIMESTAMP);
INSERT INTO perhitungan_margin VALUES (7, 1, 7, 2000, 5000, 3000, 60.00, CURRENT_TIMESTAMP);

INSERT INTO pemesanan VALUES (1, 1, 1, 'diproses', 40000, CURRENT_TIMESTAMP);

INSERT INTO detail_pemesanan VALUES (1, 1, 5, 1, 35000, 'Kuah pedas level 5');
INSERT INTO detail_pemesanan VALUES (2, 1, 7, 1, 5000, 'Manis murni');

INSERT INTO pembayaran VALUES (1, 1, 'lunas', CURRENT_TIMESTAMP);

INSERT INTO konfirmasi_pemesanan VALUES (1, 1, 1, 'siap diproduksi', CURRENT_TIMESTAMP);


-- =========================
-- VIEW
-- =========================

CREATE OR REPLACE VIEW view_laporan_margin AS
SELECT 
    m.id_menu,
    m.nama_menu,
    m.nama_kategori,
    pm.harga_modal,
    pm.harga_jual,
    pm.margin_nominal,
    pm.margin_persen
FROM menu m
JOIN perhitungan_margin pm ON m.id_menu = pm.id_menu;

CREATE OR REPLACE VIEW view_antrean_dapur AS
SELECT 
    p.id_pemesanan,
    p.id_meja,
    pl.nama AS nama_pelanggan,
    kp.status_konfirmasi,
    p.created_at AS waktu_pesan
FROM pemesanan p
JOIN pelanggan pl ON p.id_pelanggan = pl.id_pelanggan
JOIN konfirmasi_pemesanan kp ON p.id_pemesanan = kp.id_pemesanan
WHERE kp.status_konfirmasi = 'siap diproduksi'
  AND p.status IN ('menunggu', 'diproses');

CREATE OR REPLACE VIEW view_riwayat_transaksi AS
SELECT 
    p.id_pemesanan AS nota,
    pl.nama AS nama_pelanggan,
    m.nomor_meja,
    p.total_harga AS total_bayar,
    pb.status AS status_bayar,
    kp.status_konfirmasi AS status_antrean,
    p.status AS status_pesanan
FROM pemesanan p
JOIN pelanggan pl ON p.id_pelanggan = pl.id_pelanggan
JOIN meja m ON p.id_meja = m.id_meja
JOIN pembayaran pb ON p.id_pemesanan = pb.id_pemesanan
JOIN konfirmasi_pemesanan kp ON p.id_pemesanan = kp.id_pemesanan;

CREATE OR REPLACE VIEW view_pesanan_per_meja AS
SELECT 
    mj.nomor_meja,
    COUNT(p.id_pemesanan) AS jumlah_pesanan,
    NVL(SUM(p.total_harga), 0) AS total_transaksi
FROM meja mj
LEFT JOIN pemesanan p ON mj.id_meja = p.id_meja
GROUP BY mj.nomor_meja;

CREATE OR REPLACE VIEW view_pembayaran_belum_lunas AS
SELECT 
    p.id_pemesanan,
    pl.nama AS nama_pelanggan,
    mj.nomor_meja,
    p.total_harga,
    pb.status AS status_pembayaran
FROM pemesanan p
JOIN pelanggan pl ON p.id_pelanggan = pl.id_pelanggan
JOIN meja mj ON p.id_meja = mj.id_meja
JOIN pembayaran pb ON p.id_pemesanan = pb.id_pemesanan
WHERE pb.status <> 'lunas';

CREATE OR REPLACE VIEW view_detail_nota_pelanggan AS
SELECT 
    p.id_pemesanan AS nota,
    pl.nama AS nama_pelanggan,
    mj.nomor_meja,
    m.nama_menu,
    dp.qty,
    dp.harga_saat_pesan,
    dp.qty * dp.harga_saat_pesan AS subtotal,
    dp.catatan
FROM pemesanan p
JOIN pelanggan pl ON p.id_pelanggan = pl.id_pelanggan
JOIN meja mj ON p.id_meja = mj.id_meja
JOIN detail_pemesanan dp ON p.id_pemesanan = dp.id_pemesanan
JOIN menu m ON dp.id_menu = m.id_menu;


-- =========================
-- PROCEDURE
-- =========================

CREATE OR REPLACE PROCEDURE pr_batalkan_pesanan(p_id_pemesanan NUMBER)
IS
BEGIN
    UPDATE pembayaran
    SET status = 'belum bayar'
    WHERE id_pemesanan = p_id_pemesanan;

    UPDATE pemesanan
    SET status = 'dibatalkan'
    WHERE id_pemesanan = p_id_pemesanan;

    UPDATE konfirmasi_pemesanan
    SET status_konfirmasi = 'dibatalkan'
    WHERE id_pemesanan = p_id_pemesanan;
END;
/

CREATE OR REPLACE PROCEDURE pr_selesaikan_pesanan(p_id_pemesanan NUMBER)
IS
BEGIN
    UPDATE pemesanan
    SET status = 'selesai'
    WHERE id_pemesanan = p_id_pemesanan;

    UPDATE meja
    SET status = 'kosong'
    WHERE id_meja = (
        SELECT id_meja
        FROM pemesanan
        WHERE id_pemesanan = p_id_pemesanan
    );
END;
/


-- =========================
-- FUNCTION
-- =========================

CREATE OR REPLACE FUNCTION fn_total_omzet
RETURN NUMBER
IS
    total_omzet NUMBER;
BEGIN
    SELECT NVL(SUM(p.total_harga), 0)
    INTO total_omzet
    FROM pemesanan p
    JOIN pembayaran pb ON p.id_pemesanan = pb.id_pemesanan
    WHERE pb.status = 'lunas'
      AND p.status = 'selesai';

    RETURN total_omzet;
END;
/

CREATE OR REPLACE FUNCTION fn_rata_margin_kategori(p_kategori VARCHAR2)
RETURN NUMBER
IS
    rata_margin NUMBER;
BEGIN
    SELECT NVL(AVG(pm.margin_persen), 0)
    INTO rata_margin
    FROM menu m
    JOIN perhitungan_margin pm ON m.id_menu = pm.id_menu
    WHERE m.nama_kategori = p_kategori;

    RETURN rata_margin;
END;
/


-- =========================
-- SELECT DATA TABEL
-- =========================

SELECT * FROM staff;
SELECT * FROM pemilik_toko;
SELECT * FROM meja;
SELECT * FROM pelanggan;
SELECT * FROM menu;
SELECT * FROM pemesanan;
SELECT * FROM detail_pemesanan;
SELECT * FROM pembayaran;
SELECT * FROM konfirmasi_pemesanan;
SELECT * FROM perhitungan_margin;


-- =========================
-- SELECT VIEW
-- =========================

SELECT * FROM view_laporan_margin;
SELECT * FROM view_antrean_dapur;
SELECT * FROM view_riwayat_transaksi;
SELECT * FROM view_pesanan_per_meja;
SELECT * FROM view_pembayaran_belum_lunas;
SELECT * FROM view_detail_nota_pelanggan;


-- =========================
-- TEST FUNCTION DAN PROCEDURE
-- =========================

-- Cek omzet awal
SELECT fn_total_omzet() AS total_omzet_kafe FROM dual;

-- Ubah pesanan menjadi selesai
EXEC pr_selesaikan_pesanan(1);

-- Cek omzet setelah pesanan selesai, hasil 40000
SELECT fn_total_omzet() AS total_omzet_kafe FROM dual;

-- Cek rata-rata margin kategori makanan
SELECT fn_rata_margin_kategori('Makanan') AS rata_margin_makanan FROM dual;

-- Simulasi pesanan dibatalkan/refund
EXEC pr_batalkan_pesanan(1);

-- Cek omzet setelah dibatalkan
SELECT fn_total_omzet() AS total_omzet_kafe FROM dual;