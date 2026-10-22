--soru1:Bütün çağrıların id'sini ve model adını listele.
SELECT id,model_name 
FROM llm_calls;
--12 satır döndü.
--soru2:toplam token sayısını (prompt + completion) total_tokens başlığıyla göster.
SELECT model_name AS model, (promt_tokens + completion_tokens) AS total_tokens
FROM llm_calls;
--12 satır döndü.
--soru3:Gecikmesi 2 saniyeyi aşan çağrılar. (Dikkat: sütun milisaniye cinsinden.)
SELECT *
FROM llm_calls
WHERE latency_ms > 2000;
-- 5 satır döndü.
--soru4:Ece'nin yaptığı çağrılar.
SELECT *
FROM llm_calls
WHERE user_name = 'Ece';
--3 satır döndü.
--soru5:Sohbet (chat) dışındaki çağrılar.
SELECT *
FROM llm_calls
WHERE task_type != 'chat';
--9 satır döndü.
--soru6:Adı claude ile başlayan modellere yapılan, 1 saniyeden yavaş çağrılar.
SELECT *
FROM llm_calls
WHERE model_name LIKE 'claude%'
  AND latency_ms > 1000; 
 --2 satır döndü.
--soru7:Kod veya çeviri işi olan, maliyeti 0.01 doları aşan çağrılar.
SELECT*
FROM llm_calls
WHERE (task_type = 'code' OR task_type = 'translate')
  AND cost_usd > 0.01;
--3 satır döndü.
--Parantez koymadan da dene. Kaç satır fark etti? ______ Neden?
--Anladığım kadarıyla parantez koymadan da aynı sonucu alırız çünkü AND ve OR 'un öncelik sırası vardır.AND,OR'dan önce gelir.Bu yüzden parantez koymadan aynı sonucu alırız.(Çıkarımı yaparken internetteki işlem önceliği bilgilerinden yardım aldım.)
--soru8:Gecikmesi 500 ile 1500 ms arasındaki çağrılar.
SELECT *
FROM llm_calls
WHERE latency_ms BETWEEN 500 AND 1500;
--3 satır döndü.
--soru9:gpt ailesine (gpt-4o, gpt-4o-mini) yapılan çağrılar.
SELECT *
FROM llm_calls
WHERE model_name IN ('gpt-4o', 'gpt-4o-mini');
--4 satır döndü.
--soru10:Model adında "mini" geçen çağrılar.
--Kaç satır bekliyordun? ______ Kaç geldi? ______ Fark varsa neden?
--9.sorudaki sorgudan dolayı 2 satır gelir diye düşünüyordum,neden böyle olduğunu anlamak için model adlarını kontrol ettim , yapay zekaya teyit ettirdim ve sonucunda sorgudaki mini komutuyla sadece gbt modelleri değil mini modelleri de sorgulamaya dahil ettiğimiz için bir satır fazla olduğunu öğrendim.
SELECT *
FROM llm_calls
WHERE model_name LIKE '%mini%'
--soru11:Önce kullanıcıya, kullanıcı içinde maliyete (pahalıdan ucuza) göre sırala.
SELECT *
FROM llm_calls 
ORDER BY task_type ASC, latency_ms
--12 satır döndü.
--soru12:En pahalı 3 çağrı.(sıralama ve sınırlama)
SELECT *
FROM llm_calls
ORDER BY cost_usd DESC
LIMIT 3;
--3 satır döndü.
--soru13:Hangi iş türleri (task_type) var?(Tekrarsız listele)
SELECT DISTINCT task_type
FROM llm_calls;
--5 satır döndü.
--soru14:Kullanıcı adlarını doğru Türkçe alfabe sırasıyla, tekrarsız listele.
--COLLATE kullanmadan denedim:
SELECT DISTINCT user_name
FROM llm_calls
ORDER BY user_name;
--6 satır döndü.
--COLLATE "tr-TR-x-icu" kullanarak denedim:
SELECT DISTINCT user_name COLLATE "tr-TR-x-icu"
FROM llm_calls
ORDER BY user_name COLLATE "tr-TR-x-icu";
--6 satır döndü.(Sorguyu yaparken hata aldım, yaptığım hata SELECT satırında user_name yanına COLLATE "tr-TR-x-icu" yazmayı unutmuşum yapay zekadan yardım alarak sorunu öğrendim ve anladım.)
--soru15:"14 Ekim'den sonra yapılan, 1 saniyeden yavaş çağrıların id'sini, modelini ve gecikmesini, en yavaştan başlayarak listele."(Soruyu sorguya çevir. Dört adımı uygula: tablo, sütunlar, koşul, sıra.)
SELECT id, model_name,latency_ms
FROM llm_calls
WHERE created_at > '2026-10-14' 
  AND latency_ms > 1000
ORDER BY latency_ms DESC;
--6 satır döndü.
