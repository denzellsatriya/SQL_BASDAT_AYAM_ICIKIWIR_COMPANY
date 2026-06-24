--DDL (CREATE TABLE)

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
    Nomor_meja NUMBER(3) NOT NULL,
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


--DML (INSERT TABLE)

INSERT INTO staff (id_staff, username, password) VALUES (1, 'denzell_satriya', 'denzell123');
INSERT INTO staff (id_staff, username, password) VALUES (2, 'ayub_destama', 'ayub123');
INSERT INTO staff (id_staff, username, password) VALUES (3, 'naufal_ariq', 'naufal123');
INSERT INTO staff (id_staff, username, password) VALUES (4, 'sheva_ibrahim', 'sheva123');

INSERT INTO pemilik_toko (id_pemilik, username, password) VALUES (1, 'mbak_dira', 'dira123');

INSERT INTO meja (id_meja, Nomor_meja, qr_code, status) VALUES (1, 1, 'https://cafepakcek.com/table/1', 'terisi');
INSERT INTO meja (id_meja, Nomor_meja, qr_code, status) VALUES (2, 2, 'https://cafepakcek.com/table/2', 'terisi');
INSERT INTO meja (id_meja, Nomor_meja, qr_code, status) VALUES (3, 3, 'https://cafepakcek.com/table/3', 'terisi');
INSERT INTO meja (id_meja, Nomor_meja, qr_code, status) VALUES (4, 4, 'https://cafepakcek.com/table/4', 'terisi');
INSERT INTO meja (id_meja, Nomor_meja, qr_code, status) VALUES (5, 5, 'https://cafepakcek.com/table/5', 'kosong');

INSERT INTO pelanggan (id_pelanggan, nama, id_meja) VALUES (1, 'Lacey Junelly', 1);
INSERT INTO pelanggan (id_pelanggan, nama, id_meja) VALUES (2, 'Karen Romay', 2);
INSERT INTO pelanggan (id_pelanggan, nama, id_meja) VALUES (3, 'Citra Kasih', 3);
INSERT INTO pelanggan (id_pelanggan, nama, id_meja) VALUES (4, 'Tuan Putri', 4);

INSERT INTO menu (id_menu, id_pemilik, nama_menu, nama_kategori, harga) VALUES (1, 1, 'Nasi Goreng', 'Makanan', 25000);
INSERT INTO menu (id_menu, id_pemilik, nama_menu, nama_kategori, harga) VALUES (2, 1, 'Bakmi Goreng', 'Makanan', 22000);
INSERT INTO menu (id_menu, id_pemilik, nama_menu, nama_kategori, harga) VALUES (3, 1, 'Nasi Campur', 'Makanan', 27000);
INSERT INTO menu (id_menu, id_pemilik, nama_menu, nama_kategori, harga) VALUES (4, 1, 'Es Pisang Ijo', 'Camilan', 15000);
INSERT INTO menu (id_menu, id_pemilik, nama_menu, nama_kategori, harga) VALUES (5, 1, 'Ramen', 'Makanan', 35000);
INSERT INTO menu (id_menu, id_pemilik, nama_menu, nama_kategori, harga) VALUES (6, 1, 'Gorengan', 'Camilan', 5000);
INSERT INTO menu (id_menu, id_pemilik, nama_menu, nama_kategori, harga) VALUES (7, 1, 'Es Teh Manis', 'Minuman', 5000);

INSERT INTO perhitungan_margin (id_margin, id_pemilik, id_menu, harga_modal, harga_jual, margin_nominal, margin_persen) VALUES (1, 1, 1, 15000, 25000, 10000, 40.00);
INSERT INTO perhitungan_margin (id_margin, id_pemilik, id_menu, harga_modal, harga_jual, margin_nominal, margin_persen) VALUES (2, 1, 2, 13000, 22000, 9000, 40.91);
INSERT INTO perhitungan_margin (id_margin, id_pemilik, id_menu, harga_modal, harga_jual, margin_nominal, margin_persen) VALUES (3, 1, 3, 17000, 27000, 10000, 37.04);
INSERT INTO perhitungan_margin (id_margin, id_pemilik, id_menu, harga_modal, harga_jual, margin_nominal, margin_persen) VALUES (4, 1, 4, 9000, 15000, 6000, 40.00);
INSERT INTO perhitungan_margin (id_margin, id_pemilik, id_menu, harga_modal, harga_jual, margin_nominal, margin_persen) VALUES (5, 1, 5, 20000, 35000, 15000, 42.86);
INSERT INTO perhitungan_margin (id_margin, id_pemilik, id_menu, harga_modal, harga_jual, margin_nominal, margin_persen) VALUES (6, 1, 6, 2000, 5000, 3000, 60.00);
INSERT INTO perhitungan_margin (id_margin, id_pemilik, id_menu, harga_modal, harga_jual, margin_nominal, margin_persen) VALUES (7, 1, 7, 2000, 5000, 3000, 60.00);

INSERT INTO pemesanan (id_pemesanan, id_meja, id_pelanggan, status, total_harga) VALUES (1, 1, 1, 'diproses', 40000); --memesan ramen (35k dan es teh manis 5k), total=40k

INSERT INTO detail_pemesanan (id_dp, id_pemesanan, id_menu, qty, harga_saat_pesan, catatan) VALUES (1, 1, 5, 1, 35000, 'Kuah pedas level 5');
INSERT INTO detail_pemesanan (id_dp, id_pemesanan, id_menu, qty, harga_saat_pesan, catatan) VALUES (2, 1, 7, 1, 5000, 'Manis murni');

INSERT INTO pembayaran (id_bayar, id_pemesanan, status, waktu_bayar) VALUES (1, 1, 'lunas', CURRENT_TIMESTAMP);

INSERT INTO konfirmasi_pemesanan (id_konfirmasi, id_pemesanan, id_staff, status_konfirmasi) VALUES (1, 1, 1, 'siap diproduksi');


--VIEW laporan keuntungan menu
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


--VIEW antrean dapur aktif
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
  AND p.status = 'menunggu';


--VIEW riwayat transaksi
CREATE OR REPLACE VIEW view_riwayat_transaksi AS
SELECT 
    p.id_pemesanan AS nota,
    pl.nama AS nama_pelanggan,
    m.Nomor_meja AS nomor_meja,
    p.total_harga AS total_bayar,
    pemb.status AS status_bayar,
    kp.status_konfirmasi AS status_antrean,
    p.status AS status_pesanan
FROM pemesanan p
JOIN pelanggan pl ON p.id_pelanggan = pl.id_pelanggan
JOIN meja m ON p.id_meja = m.id_meja
JOIN pembayaran pemb ON p.id_pemesanan = pemb.id_pemesanan
JOIN konfirmasi_pemesanan kp ON p.id_pemesanan = kp.id_pemesanan;


--MENAMPILKAN TABEL (SELECT)

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

SELECT * FROM view_laporan_margin;
SELECT * FROM view_antrean_dapur;
SELECT * FROM view_riwayat_transaksi;

--omset pendapatan cafe
SELECT SUM(total_harga) AS total_omzet_kafe 
FROM pemesanan 
WHERE status = 'selesai';

--rata2 persentase keuntungan per kategori menu
SELECT 
    m.nama_kategori AS kategori,
    AVG(pm.margin_persen) AS rata_rata_persen_untung
FROM menu m
JOIN perhitungan_margin pm ON m.id_menu = pm.id_menu
GROUP BY m.nama_kategori;