--soru1= Kaç çağrı kaydedilmiş?
SELECT COUNT(*) FROM llm_calls;
--Sisteme 12 tane çağrı kaydedilmiş.
--soru2= Kaç çağrı 2 saniyeden yavaş?
SELECT COUNT(*) 
FROM llm_calls
WHERE latency_ms > 2000;
--Sistemde süresi 2000 milisaniyeden(2 saniyeden) uzun süren toplam 5 adet çağrı bulunuyor.
--soru3=Toplam maliyet ve toplam token sayısı.
SELECT
     SUM(cost_usd) AS toplam_maliyet,
	 SUM(prompt_tokens + completion_tokens) AS toplam_token
FROM llm_calls;
--Toplam LLM çağrıları için toplam maliyet 0.0631 dolar, harcanan toplam token sayısı ise 14340 ' dır.
--soru4=Ortalama gecikme.(1 ondalık basamağa yuvarlanmış)
SELECT ROUND(AVG(latency_ms),1) AS ortalama_gecikme
FROM llm_calls;
--LLM çağrılarının ortalama yanıt süresi 1848.3 milisaniyedir.
--soru5=En hızlı ve en yavaş çağrı.
SELECT 
    MIN(latency_ms) AS en_hizli,
	MAX(latency_ms) AS en_yavas
FROM llm_calls;
--Yapılan çağrılarda en hızlı yanıt süresi 380 milisaniye , en yavaş yanıt süresiyse 4100 milisaniyedir.
--soru6=Her iş türünde (task_type) kaç çağrı var?Kaç satır döndü? ______ Neden o kadar?
SELECT task_type, COUNT (*) AS cagri_sayisi
FROM llm_calls
GROUP BY task_type;
--5 satır döndü.Çünkü GROUP BY task_type demek aynı iş türlerini bir kümede toplamak yani kategorilendirme demekmiş.Yani 5 satırın sebebi verileri 5 farklı işte gruplandırmaktan dolayıymış.(Neden 5 satır döndüğünü anlamak için yapay zekaya sordum ve cevabını anladığım şekilde yorumladım.)
--soru7=Her model için çağrı sayısı ve toplam maliyet, pahalıdan ucuza.
SELECT 
    model_name ,
    COUNT(*) AS cagri_sayisi,
    SUM(cost_usd) AS toplam_maliyet
FROM llm_calls
GROUP BY model_name
ORDER BY toplam_maliyet DESC;
--Sistemdeki modellerin çağrı sayısı ve toplam maliyetlerine göre en yüksek maliyetliden en düşüğe doğru sıralanmıştır.(Çalıştırdığımda 7 satır döndü)
--soru8=Her kullanıcının her iş türünden kaç çağrısı var?Her kullanıcının her iş türünden kaç çağrısı var? Sonuçta beklemediğin bir satır var mı? Hangisi ve neden ?
--12 satır döndü.Her kullanıcının bulunduğu çağrı türünden birer tane çağrısı var.Sonuçta on ikinci satırda null karakter var kullanıcı adı belirsiz ama diğer bilgileri mevcut.Ve tabloda gördüğüm bir bilgi daha var o da bir kişinin iki farklı task_type'ı var.
--soru9=İkiden fazla çağrı almış modeller.İkiden fazla kaçtan büyük demek?
SELECT model_name, COUNT(*) AS cagri_sayisi
FROM llm_calls
GROUP BY model_name 
HAVING COUNT(*) > 2;
--Sadece 2' den fazla ( yani en az 3) çağrı alan model filtrelenmiş, gbt-40 modelinin 3 çağrı aldığını tabloda gördüm ve doğruladım.
--soru10=Sadece 500 ms'den yavaş çağrıları hesaba kat; en az 2 çağrısı olan modelleri ortalama gecikmesiyle göster.Bu sorguda WHERE neyi eledi,HAVİNG neyi eledi?
SELECT
    model_name,
	ROUND(AVG(latency_ms),1) AS ortalam_gecikme,
	COUNT(*) AS cagri_sayisi
FROM llm_calls
WHERE latency_ms > 500
GROUP BY model_name
HAVING COUNT(*) >= 2;
--3 satır döndü.WHERE 500 ms ve altındakş hızlı çağrıları gruplamadan önce elemiş, Having ise gruplama sonrasında en az 2 yavaş çağrısı olan modelleri filtrelemiştir.(Yapay zekadan yardımla çıkarım yaptım.)
--soru11=llm_calls tablosunda hangi sütunda kaç eksik veri var?
SELECT 
    'user_name' AS sutun_adi,
	COUNT(user_name) AS dolu,
	COUNT(*) - COUNT(user_name) AS eksik
FROM llm_calls
UNION ALL
SELECT
    'cost_usd',
	COUNT(cost_usd),
	COUNT(*) - COUNT(cost_usd)
FROM llm_calls
UNION ALL
SELECT 
     'task_type',
	 COUNT(task_type),
	 COUNT(*) - COUNT(task_type)
FROM llm_calls;
--user_name'de 11 dolu 1 eksik,cost_usd'de 11 dolu 1 eksik,task_type'da 12 dolu 0 eksik veri var.Tablo toplam 3 satırdan oluşuyor.
--soru12=Faturası gelmemiş çağrıları listele. NULL ile dene. Kaç satır geldi? Sonra IS NULL ile dene. Kaç satır geldi? 
--NULL ile deniyorum:
SELECT *
FROM llm_calls
WHERE cost_usd = NULL;
--Sonuç çıkmadı.
--IS NULL ile deniyorum:
SELECT *
FROM llm_calls
WHERE cost_usd IS NULL;
--1 satır döndü ve faturası girilmemiş model adı gpt-40 olan kullanıcı denizin çağrı kaydının bilgi tablosu karşıma çıktı.
--soru13:İki ortalama. Ortalamayı iki şekilde hesapla ve yan yana göster: boşları atlayarak ve boşları sıfır sayarak (COALESCE).Hangisi bu veri için daha dürüst bir rapor olur? Neden?
SELECT 
    ROUND(AVG(cost_usd)::numeric,2) AS boslari_atlayarak,
	ROUND(AVG(COALESCE(cost_usd,0))::numeric,2) AS boslari_sifir_sayarak
FROM llm_calls;
--Boşları atlayarak ve boşları sıfır sayark aynı sonucu yani 0.01 bulduk.Boşları atlamak daha dürüst bir yaklaşım olacaktır çünkü eksik veriyi sıfır kabul edersek ortalamayı düşürür ve yanıltıcı belge sunabiliriz.
--soru14=Günlük kullanım raporu: gün, çağrı sayısı, toplam maliyet.YZ için ek soru: En çok çağrı alan gün hangisi? O günün maliyeti neden beklediğinden düşük?
SELECT
    created_at::date AS gun,
	COUNT(*) AS cagri_sayisi,
	ROUND(SUM(cost_usd)::numeric,4) AS toplam_maliyet
FROM llm_calls
GROUP BY created_at::date
ORDER BY gun;
--En çok çağrı alan gün 6. satırdaki gün ve 5 tane çağrı almış.O güne ait maliyeti sisteme girilmemiş çağrı olabilir o yüzden beklenilenden düşük olabilir.
--soru15=Gecikmeye göre: Hızlı (1000 ms altı), Orta (1000-2499), Yavaş (2500 ve üstü). Her kategoride kaç çağrı var ve ortalama gecikme ne?
SELECT
    CASE 
	   WHEN latency_ms < 1000 THEN 'Hızlı'
	   WHEN latency_ms BETWEEN 1000 AND 2499 THEN 'Orta'
	   WHEN latency_ms >= 2500 THEN 'Yavaş'
       ELSE 'Bilinmiyor'
  END AS gecikme_kategorisi,
  COUNT(*) AS cagri_sayisi,
  ROUND(AVG(latency_ms)::numeric,1) AS ortalama_gecikme
  FROM llm_calls
  GROUP BY gecikme_kategorisi
  ORDER BY ortalama_gecikme;
  -- hızlı,orta ve yaşta her birinde dörder çağrı sayısı bulunmaktadır.Hızlıda 607.5 ms , ortada 1775.0 ms ve yavaşta 3162.5 ms ortalma gecikme bulunuyor.







