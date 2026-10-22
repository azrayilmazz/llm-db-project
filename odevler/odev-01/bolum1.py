numbers = [4, 7, 2, 9, 5, 1, 8]
total = 0
result = []
for i in range(len(numbers)):
    if numbers[i] % 2 == 0:
        total = total + numbers[i]
    else:
        result.append(numbers[i])
print(total)
print(result)
#Tahminim tuttu , tablo şeklinde çözdüm ve çalıştırdığım kodla aynı cevabı buldum.
readings = [18, 21, 23, 25, 24, 26, 27, 19, 20, 22, 23, 24, 25, 26]
threshold = 22
#Soru 1.2 Sözde Kod:
#adım 1:rekor=0 ve sayac=0 gir.
#adım 2:listedeki sayıları gez.
#adım 3:eğer sayı 22'den büyükse rekoru güncelle ve sayacı bir artır.
#adım 4:eğer sayı 22'den küçük veya eşitse sayacı sıfırla.
#adım 5:en uzun seri uzunluğu ve sayacın sonucunu ekrana yazdır.(En uzun seri uzunluğu=5 seri=[23,24,25,26,27])
longest = 0
count = 0
for number in readings:
    if number > threshold:
        count = count + 1
        if count > longest:
          longest = count
    else:
          count = 0
print("Longest consecutive sequence:",longest)
print("Number of values greater than 22:",count)
#Soru 1.3 Sözde kod:
#adım 1:boş bir değişken oluştur.(student_counts={})
#adım 2:kayıt listesini gez.
#adım 3:her kayıt için öğrenci sayısını al , student_counts listesine ekle ve öğrenci sayısını artır.
#adım 4.student_counts listesinin sonucunu ekrana yazdır.("VTYS":3,"Yapay Zeka":2,"Robotik":1)
records = [
    {"student": "Ece", "course": "VTYS"},
    {"student": "Ali", "course": "Yapay Zeka"},
    {"student": "Ece", "course": "Yapay Zeka"},
    {"student": "Can", "course": "VTYS"},
    {"student": "Ali", "course": "VTYS"},
    {"student": "Ece", "course": "Robotik"},
]
student_counts = {}
for record in records:
    course = record["course"]
    if course in student_counts:
        student_counts[course] = student_counts[course] + 1
    else:
        student_counts[course] = 1
print("Number of students per course:",student_counts)
#Çıkarım/Benzerlik:Python'da bu kodları yazarken kurduğumuz for döngüsü ve birleştirme SQL'deki GROUP BY ifadesindeki veritabanında yapılan sayma ve gruplamayla benzerlik gösterir.
