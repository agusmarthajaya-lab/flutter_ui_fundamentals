# Course Explorer v2 - Architecture Audit

**Nama:** I Putu Agus Martha Jaya  
**NIM:** 2415051097  

## Dependency Direction
Screen/Widget -> Provider -> Repository -> Service/Data Source

## Tanggung Jawab Tiap Folder:
- **models/**: Mendefinisikan struktur data/entitas aplikasi (misal: `Course`).
- **services/**: Mengambil data mentah (JSON/API/rootBundle) dan melakukan decoding data.
- **repositories/**: Menjadi perantara/pembungkus logika bisnis antara Service dan Provider.
- **providers/**: Mengelola state aplikasi (loading, error, favorites) dan memberi tahu UI jika terjadi perubahan (`notifyListeners`).
- **widgets/**: Komponen UI reusalbe/terpisah (misal: `CourseCard`).
- **screens/**: Halaman UI aplikasi yang menampilkan state dari Provider ke pengguna.

## REST API Endpoint
- **URL:** https://jsonplaceholder.typicode.com/courses
- **Method:** GET
- **Fields:** id, code, title, credits, status