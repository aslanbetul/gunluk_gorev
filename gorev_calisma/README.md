**Proje Özeti**
Bu Flutter uygulaması, kullanıcılara görev yönetimi işlemleri sunar. Uygulama, uzaktan (API üzerinden) görev bilgilerini alır ve yerel depolama (Hive) kullanarak görevlerin yönetimini sağlar.

**Kullanılan Teknolojiler ve Kütüphaneler**
Flutter: Uygulama geliştirme çerçevesi
GetX: State management kütüphanesi
Dio: API entegrasyonu için HTTP istemcisi
Hive: Yerel depolama yönetimi
Connectivity_plus: İnternet bağlantı durumu takibi
Flutter Material UI: Kullanıcı arayüzü için Material Design bileşenleri

**Proje Yapısı**
GetX Controller: Görevlerin yönetimi ve API ile etkileşim için GetX controller'ları kullanılmıştır.
Hive Database: Görevler, yerel olarak Hive veritabanına kaydedilir ve alınır.
API Entegrasyonu: API üzerinden görev listeleri çekilir ve CRUD işlemleri yapılır.
Kullanıcı Arayüzü: Material Design bileşenleri ile tasarlanmış bir kullanıcı arayüzü sunulmuştur.


**CRUD İşlemleri**
Create (Ekleme): Kullanıcı yeni bir görev ekleyebilir.
Read (Okuma): Kullanıcı görev listesini görebilir.
Update (Güncelleme): Kullanıcı mevcut görevlerin başlıklarını ve açıklamalarını güncelleyebilir.
Delete (Silme): Kullanıcı görevleri silebilir.


Kullanıcı Arayüzü
Uygulama, aşağıdaki özelliklere sahip bir kullanıcı arayüzü sunar:

**Görevlerin listelenmesi.
**Görev ekleme, düzenleme ve silme.
**Görev durumunun (tamamlanmış veya tamamlanmamış) değiştirilmesi.
**API'den veri çekme ve gösterme.
**İnternet bağlantısı durumuna göre hata yönetimi.

**Özellikler**
Görev Listesi: API'den görev verilerini çekerek bir liste halinde gösterir.
Durum Değişikliği: Görevlerin durumunu (tamamlanmış veya tamamlanmamış) değiştirme işlevselliği sunar.
Görev Ekleme: Kullanıcılar yeni görevler ekleyebilir.
Görev Güncelleme: Var olan görevlerin başlıkları ve açıklamaları güncellenebilir.
Görev Silme: Kullanıcılar görevleri silebilir.


**Kullanıcı Arayüzü Örnekleri**
**Görev Listesi**
**Görev Detayları**
**API Entegrasyonu**
Uygulama, görevleri bir API üzerinden alır. API'ye yapılan HTTP istekleri için Dio kütüphanesi kullanılmıştır. Aşağıda, API'den görev verilerini çekmek için kullanılan yöntemler bulunmaktadır:

GET: Tüm görevlerin alınması.
POST: Yeni bir görev eklenmesi.
PUT: Mevcut bir görev güncellenmesi.
DELETE: Bir görev silinmesi.

**Bağlantı Durumu**
Uygulama, Connectivity kütüphanesini kullanarak internet bağlantı durumunu takip eder. İnternet bağlantısı yoksa, API istekleri başarısız olacak ve kullanıcıya uygun bir mesaj gösterilecektir