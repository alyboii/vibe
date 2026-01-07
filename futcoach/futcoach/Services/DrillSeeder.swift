//
//  DrillSeeder.swift
//  futcoach
//
//  Created by Ali Ünal UZUNÇAYIR on 7.01.2026.
//

import Foundation

/// Provides seed data for 68 football training drills
struct DrillSeeder {
    
    func getAllDrills() -> [Drill] {
        var allDrills: [Drill] = []
        var order = 0
        
        // A) Isınma / Sakatlık Önleme (12 drills)
        allDrills.append(contentsOf: warmupDrills(startOrder: order))
        order += 12
        
        // B) Teknik - Pas & Kontrol (12 drills)
        allDrills.append(contentsOf: passingDrills(startOrder: order))
        order += 12
        
        // C) Teknik - Dribbling / 1v1 (10 drills)
        allDrills.append(contentsOf: dribblingDrills(startOrder: order))
        order += 10
        
        // D) Teknik - Şut / Bitiricilik (10 drills)
        allDrills.append(contentsOf: shootingDrills(startOrder: order))
        order += 10
        
        // E) Hız / Çeviklik / COD (8 drills)
        allDrills.append(contentsOf: speedAgilityDrills(startOrder: order))
        order += 8
        
        // F) Kuvvet / Plyo (8 drills)
        allDrills.append(contentsOf: strengthDrills(startOrder: order))
        order += 8
        
        // G) Kondisyon (8 drills)
        allDrills.append(contentsOf: conditioningDrills(startOrder: order))
        
        return allDrills
    }
    
    // MARK: - 1. Isınma / Sakatlık Önleme (12 drills)
    
    private func warmupDrills(startOrder: Int) -> [Drill] {
        var order = startOrder
        return [
            Drill(name: "Jog + Dinamik Mobilite", nameEN: "Jog + Dynamic Mobility", category: .warmupPrevention, targetType: .prevention, equipment: [], level: .beginner, durationMinutes: 5, description: "Hafif tempo koşu ile kalça, ayak bileği ve omuz mobilite hareketleri", coachingTips: ["Kontrollü tempo", "Nefes ritmine dikkat", "Eklem hareket açıklığını zorlamayın"], safetyNotes: "Ani hareketlerden kaçının", logFormat: .completionOnly, order: order).also { order += 1 },
            
            Drill(name: "Yan Koşu / Carioca", nameEN: "Lateral Run / Carioca", category: .warmupPrevention, targetType: .prevention, equipment: ["Koni"], level: .beginner, sets: 3, reps: 20, description: "Yan adımlar ve carioca hareketi ile kalça açıcı ısınma", coachingTips: ["Düşük kalça pozisyonu", "Ayaklar yerden az kalkmalı", "Kol koordinasyonu"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "Tek Ayak Denge (Sağ/Sol)", nameEN: "Single Leg Balance", category: .warmupPrevention, targetType: .prevention, equipment: [], level: .beginner, sets: 3, reps: 30, description: "Her ayakta 30sn denge, gözler açık/kapalı varyasyonları", coachingTips: ["Core aktivasyonu", "Diz hafif bükük", "Sabit bir noktaya bakın"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "Walking Lunge + Twist", nameEN: "Walking Lunge with Twist", category: .warmupPrevention, targetType: .prevention, equipment: [], level: .beginner, sets: 2, reps: 10, description: "Yürüyerek lunge ve gövde rotasyonu", coachingTips: ["Arka diz yere değmemeli", "Gövde dik", "Rotasyon ön bacak tarafına"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "Nordic Hamstring", nameEN: "Nordic Hamstring Curl", category: .warmupPrevention, targetType: .prevention, equipment: ["Partner"], level: .intermediate, sets: 3, reps: 6, description: "Partner destekli eksantrik hamstring kuvvetlendirme", coachingTips: ["Yavaş iniş (3-4sn)", "Kalça düz kalmalı", "Ellerle yakalayın, itin ve tekrar"], safetyNotes: "Hamstring geçmişi varsa dikkatli başlayın", logFormat: .loadBased, order: order).also { order += 1 },
            
            Drill(name: "Plank + Side Plank", nameEN: "Plank Series", category: .warmupPrevention, targetType: .prevention, equipment: [], level: .beginner, sets: 3, reps: 30, description: "Ön plank ve her iki tarafa yan plank", coachingTips: ["Kalça düşmemeli", "Nefes tutmayın", "Omuzlar dirseklerin üstünde"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "Jump & Stick (İniş Kontrol)", nameEN: "Jump and Stick Landing", category: .warmupPrevention, targetType: .prevention, equipment: [], level: .beginner, sets: 3, reps: 8, description: "Sıçra ve kontrollü iniş, diz valgusuna dikkat", coachingTips: ["Yumuşak iniş", "Dizler ayak parmakları hizasında", "2 saniye pozisyonu koru"], safetyNotes: "Diz ağrısında durdurun", logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "Bounding (Sıçramalı Koşu)", nameEN: "Bounding", category: .warmupPrevention, targetType: .prevention, equipment: [], level: .intermediate, sets: 3, reps: 15, description: "15m mesafede uzun sıçramalarla koşu", coachingTips: ["Diz yüksek", "Havada süzülme hissi", "Güçlü kol çalışması"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "Plant & Cut (Yön Değişimi)", nameEN: "Plant and Cut", category: .warmupPrevention, targetType: .prevention, equipment: ["Koni"], level: .intermediate, sets: 3, reps: 6, description: "Kontrollü yön değişimi hareketi, decel + accel", coachingTips: ["Dış ayakla basış", "Vücut ağırlık merkezi düşük", "Hızlanmadan önce tamamen dur"], safetyNotes: "ACL riski için teknik önemli", logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "Hip Circle Mobilite", nameEN: "Hip Circles", category: .warmupPrevention, targetType: .prevention, equipment: [], level: .beginner, sets: 2, reps: 10, description: "Ayakta kalça çemberleri, içe ve dışa rotasyon", coachingTips: ["Geniş hareket açıklığı", "Kontrollü tempo", "Destek bacağı sabit"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "A-Skip / B-Skip", nameEN: "A-Skip / B-Skip Drill", category: .warmupPrevention, targetType: .prevention, equipment: [], level: .beginner, sets: 3, reps: 20, description: "Koşu mekaniği geliştirme drilleri", coachingTips: ["Diz yüksek çekme", "Ayak bileği sert", "Dikey sıçrama hissi"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "Glute Bridge March", nameEN: "Glute Bridge March", category: .warmupPrevention, targetType: .prevention, equipment: [], level: .beginner, sets: 3, reps: 10, description: "Köprü pozisyonunda sırayla diz kaldırma", coachingTips: ["Kalça düşmemeli", "Core sıkı", "Kontrollü tempo"], logFormat: .countBased, order: order).also { order += 1 }
        ]
    }
    
    // MARK: - 2. Teknik - Pas & Kontrol (12 drills)
    
    private func passingDrills(startOrder: Int) -> [Drill] {
        var order = startOrder
        return [
            Drill(name: "Duvar Pası (2 Ayak)", nameEN: "Wall Pass Both Feet", category: .technicalPassing, targetType: .technical, equipment: ["Top", "Duvar"], level: .beginner, reps: 100, description: "Duvara karşı her iki ayakla 100 pas", coachingTips: ["Ayak içi kullanın", "İlk dokunuş yere yakın", "Pas sonrası hazır pozisyon"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "Kontrol-Pas: Yarım Dönüş", nameEN: "Half Turn Control and Pass", category: .technicalPassing, targetType: .technical, equipment: ["Top", "Partner/Duvar"], level: .intermediate, sets: 3, reps: 10, description: "Topu al, yarım dön, pas ver", coachingTips: ["Vücut açık pozisyonda", "İlk dokunuşta dönüş yönüne aç", "Baş yukarıda"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "First Touch + Yön Değişimi", nameEN: "First Touch Direction Change", category: .technicalPassing, targetType: .technical, equipment: ["Top", "Koni"], level: .intermediate, sets: 3, reps: 8, description: "İlk dokunuşla yön değiştirme", coachingTips: ["Kontrol ayağı yumuşak", "Gözler sahada", "Hızlı çıkış"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "Scan Before Receive", nameEN: "Scanning Before Receiving", category: .technicalPassing, targetType: .tactical, equipment: ["Top"], level: .intermediate, reps: 20, description: "Top gelmeden omuz üzerinden bakış alışkanlığı", coachingTips: ["Toptan önce çevre kontrolü", "Kısa göz teması", "Vücut pozisyonunu ayarla"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "4v4+3 Possession", nameEN: "4v4+3 Possession Game", category: .technicalPassing, targetType: .tactical, equipment: ["Top", "Yelek"], level: .intermediate, durationMinutes: 16, description: "4 dakikalık periyotlarla 4'e 4 + 3 joker pas oyunu", coachingTips: ["Destek açıları", "Tek dokunuş teşvik", "Jokerler hep topa sahip takımda"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "Give-and-Go (1-2 Pas)", nameEN: "Give and Go / Wall Pass", category: .technicalPassing, targetType: .technical, equipment: ["Top", "Partner"], level: .beginner, sets: 3, reps: 10, description: "Ver-kaç hareketi, duvar pası + koşu", coachingTips: ["Pas sonrası hemen koşu", "Aldığın yere değil, boşluğa koş", "Zamanlama kritik"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "Uzun Pas İsabeti (30m)", nameEN: "Long Pass Accuracy", category: .technicalPassing, targetType: .technical, equipment: ["Top", "Koni"], level: .advanced, reps: 10, description: "30 metre mesafeye hedefli uzun pas", coachingTips: ["Destek ayağı hedefe dönük", "Topu ortasından biraz altına vur", "Follow through"], logFormat: .accuracyBased, order: order).also { order += 1 },
            
            Drill(name: "Kontrol + İleri Pas", nameEN: "Control and Forward Pass", category: .technicalPassing, targetType: .technical, equipment: ["Top", "Partner"], level: .beginner, sets: 3, reps: 10, description: "Topu durdur ve hemen ileri pas", coachingTips: ["İlk dokunuş pas yönüne", "Minimum dokunuş", "Pas sertliği önemli"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "Rondo (4v2)", nameEN: "Rondo 4v2", category: .technicalPassing, targetType: .tactical, equipment: ["Top"], level: .intermediate, durationMinutes: 9, description: "4'e 2 top kapma oyunu, 3 dakikalık periyotlar", coachingTips: ["Top kaybeden ortaya", "Destek açıları", "Tek dokunuş teşvik"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "Hava Topu Kontrolü", nameEN: "Aerial Ball Control", category: .technicalPassing, targetType: .technical, equipment: ["Top"], level: .intermediate, reps: 20, description: "Havadan gelen topu göğüs/uyluk/ayak ile kontrol", coachingTips: ["Topun altına gir", "Vuruş anında geri çekil", "Yumuşak yüzey oluştur"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "Tek Dokunuş Pas (One-Touch)", nameEN: "One Touch Passing", category: .technicalPassing, targetType: .technical, equipment: ["Top", "Duvar"], level: .intermediate, reps: 50, description: "Tek dokunuşla duvara pas, her iki ayak", coachingTips: ["Vücut dengeli", "Pas ayağı sabitlenmiş", "Ritim koruyun"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "Çapraz Pas + Koşu", nameEN: "Diagonal Pass and Run", category: .technicalPassing, targetType: .technical, equipment: ["Top", "Partner", "Koni"], level: .intermediate, sets: 3, reps: 8, description: "Çapraz pas ver, pasın arkasından koş", coachingTips: ["Pas netliği", "Koşu zamanlaması", "İletişim önemli"], logFormat: .countBased, order: order).also { order += 1 }
        ]
    }
    
    // MARK: - 3. Teknik - Dribbling / 1v1 (10 drills)
    
    private func dribblingDrills(startOrder: Int) -> [Drill] {
        var order = startOrder
        return [
            Drill(name: "Slalom Dribbling (Yavaş)", nameEN: "Slow Slalom Dribbling", category: .technicalDribbling, targetType: .technical, equipment: ["Top", "6 Koni"], level: .beginner, sets: 3, description: "Koniler arasında kontrollü yavaş dribbling", coachingTips: ["Top ayağa yakın", "Baş yukarıda", "Her iki ayağı kullan"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "Slalom Dribbling (Hızlı)", nameEN: "Fast Slalom Dribbling", category: .technicalDribbling, targetType: .technical, equipment: ["Top", "6 Koni"], level: .intermediate, sets: 3, description: "Koniler arasında maksimum hızda dribbling", coachingTips: ["Dışarı çıkışlarda hızlan", "Koni geçişinde yavaşla", "Agresif tempo"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "Inside/Outside Cut", nameEN: "Inside Outside Cuts", category: .technicalDribbling, targetType: .technical, equipment: ["Top", "Koni"], level: .beginner, sets: 3, reps: 10, description: "Ayak içi ve dışı ile yön değişimi", coachingTips: ["Keskin açı değişimi", "Vücut aldatması ekle", "Hızlanarak çık"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "1v1 Gate Dribbling", nameEN: "1v1 Through Gates", category: .technicalDribbling, targetType: .technical, equipment: ["Top", "Koni"], level: .intermediate, reps: 10, description: "2 koni arasından rakip geçme hareketi", coachingTips: ["Rakibe yaklaş", "Son anda hareket", "Patlayıcı çıkış"], logFormat: .accuracyBased, order: order).also { order += 1 },
            
            Drill(name: "Shielding (Top Saklama)", nameEN: "Ball Shielding", category: .technicalDribbling, targetType: .technical, equipment: ["Top", "Partner"], level: .intermediate, sets: 3, reps: 30, description: "Baskı altında topu koruma, vücut kullanımı", coachingTips: ["Vücut rakip ile top arasında", "Ağırlık merkezi düşük", "Kollar denge için"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "Stepover + Çıkış", nameEN: "Stepover and Accelerate", category: .technicalDribbling, targetType: .technical, equipment: ["Top"], level: .intermediate, sets: 3, reps: 10, description: "Makas hareketi ve hızlı çıkış", coachingTips: ["Geniş makas", "Omuz hareketi ekle", "Çıkışta sprint"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "La Croqueta", nameEN: "La Croqueta", category: .technicalDribbling, targetType: .technical, equipment: ["Top"], level: .intermediate, sets: 3, reps: 10, description: "İç ayaklar arası hızlı top aktarımı", coachingTips: ["Ayaklar dar duruşta", "Hızlı transfer", "Vücut hafif yana"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "Elastico", nameEN: "Elastico / Flip Flap", category: .technicalDribbling, targetType: .technical, equipment: ["Top"], level: .advanced, sets: 3, reps: 10, description: "Dış-iç ayak ardışık dokunuş aldatması", coachingTips: ["Tek hareket hissi", "Ayak bileği esnekliği", "Patlayıcı çıkış"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "Körük (Feint) + Hız", nameEN: "Body Feint and Sprint", category: .technicalDribbling, targetType: .technical, equipment: ["Top", "Koni"], level: .intermediate, sets: 3, reps: 8, description: "Vücut aldatması ve patlayıcı sprint", coachingTips: ["Omuz ve kalça hareketi", "Göz teması rakibe", "Patlayıcı çıkış"], logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "Ball Mastery Serisi", nameEN: "Ball Mastery Series", category: .technicalDribbling, targetType: .technical, equipment: ["Top"], level: .beginner, durationMinutes: 5, description: "Top hakimiyeti kombinasyonları: rolls, taps, V-cuts", coachingTips: ["Ritim koruyun", "Her iki ayak eşit", "Gözler toptan kaldırın"], logFormat: .timeBased, order: order).also { order += 1 }
        ]
    }
    
    // MARK: - 4. Teknik - Şut / Bitiricilik (10 drills)
    
    private func shootingDrills(startOrder: Int) -> [Drill] {
        var order = startOrder
        return [
            Drill(name: "Spot Shooting (5 Nokta)", nameEN: "5 Spot Shooting", category: .technicalShooting, targetType: .technical, equipment: ["Top", "Kale"], level: .beginner, reps: 50, description: "Ceza sahası içi 5 farklı noktadan şut", coachingTips: ["Kaleciyi izle", "Köşeler hedef", "Destek ayağı hedefe"], logFormat: .accuracyBased, order: order).also { order += 1 },
            
            Drill(name: "First Touch + Şut", nameEN: "First Touch and Shoot", category: .technicalShooting, targetType: .technical, equipment: ["Top", "Kale", "Partner"], level: .intermediate, reps: 15, description: "Pas al, ilk dokunuşla pozisyon al, şut", coachingTips: ["İlk dokunuş şut açısına", "Hızlı karar", "Kaleci pozisyonuna göre şut"], logFormat: .accuracyBased, order: order).also { order += 1 },
            
            Drill(name: "Volley Bitiricilik", nameEN: "Volley Finishing", category: .technicalShooting, targetType: .technical, equipment: ["Top", "Kale"], level: .advanced, reps: 10, description: "Havadan gelen topa vole şut", coachingTips: ["Topun altına in", "Vücut üstte", "Zamanlamaya odaklan"], logFormat: .accuracyBased, order: order).also { order += 1 },
            
            Drill(name: "Ceza Sahası Dışı Şut", nameEN: "Long Range Shooting", category: .technicalShooting, targetType: .technical, equipment: ["Top", "Kale"], level: .intermediate, reps: 15, description: "20-25 metre mesafeden şut çalışması", coachingTips: ["Temiz vuruş", "Alt köşeler", "Destek ayağı güçlü"], logFormat: .accuracyBased, order: order).also { order += 1 },
            
            Drill(name: "1v1 Kaleci Karşısı", nameEN: "1v1 vs Goalkeeper", category: .technicalShooting, targetType: .technical, equipment: ["Top", "Kale", "Kaleci"], level: .intermediate, reps: 10, description: "Kaleci ile 1'e 1 bitiricilik", coachingTips: ["Kaleciye yaklaş", "Kaleci yere düşene kadar bekle", "Sakin ol"], logFormat: .accuracyBased, order: order).also { order += 1 },
            
            Drill(name: "Serbest Vuruş Rutini", nameEN: "Free Kick Routine", category: .technicalShooting, targetType: .technical, equipment: ["Top", "Kale"], level: .intermediate, reps: 10, description: "Farklı mesafelerden serbest vuruş", coachingTips: ["Tutarlı rutin", "Hedef noktayı belirle", "Sakin yaklaşım"], logFormat: .accuracyBased, order: order).also { order += 1 },
            
            Drill(name: "Orta + Bitiriş (Kafa)", nameEN: "Cross and Header Finish", category: .technicalShooting, targetType: .technical, equipment: ["Top", "Kale", "Partner"], level: .intermediate, reps: 10, description: "Yan ortadan kafa vuruşu", coachingTips: ["Zamanlama önemli", "Alna ile vur", "Aşağı yönlendir"], logFormat: .accuracyBased, order: order).also { order += 1 },
            
            Drill(name: "Chip Şut", nameEN: "Chip Shot / Lob", category: .technicalShooting, targetType: .technical, equipment: ["Top", "Kale"], level: .advanced, reps: 10, description: "Kaleciyi aşırtan chip şut çalışması", coachingTips: ["Topun altını kes", "Yükseliş hızlı, iniş yavaş", "Kaleci pozisyonunu oku"], logFormat: .accuracyBased, order: order).also { order += 1 },
            
            Drill(name: "Dönüş + Şut", nameEN: "Turn and Shoot", category: .technicalShooting, targetType: .technical, equipment: ["Top", "Kale"], level: .intermediate, reps: 10, description: "Sırtı dönük topu al, dön, şut at", coachingTips: ["Hızlı dönüş", "Savunmayı hisset", "Şut öncesi bakış"], logFormat: .accuracyBased, order: order).also { order += 1 },
            
            Drill(name: "Finishing Under Pressure", nameEN: "Finishing Under Pressure", category: .technicalShooting, targetType: .technical, equipment: ["Top", "Kale", "Defans"], level: .advanced, reps: 10, description: "Defans baskısı altında bitiricilik", coachingTips: ["Çabuk karar", "Vuruş alanı yarat", "Sakin kal"], logFormat: .accuracyBased, order: order).also { order += 1 }
        ]
    }
    
    // MARK: - 5. Hız / Çeviklik / COD (8 drills)
    
    private func speedAgilityDrills(startOrder: Int) -> [Drill] {
        var order = startOrder
        return [
            Drill(name: "10m Acceleration Sprint", nameEN: "10m Acceleration Sprint", category: .speedAgility, targetType: .physical, equipment: ["Koni"], level: .beginner, sets: 6, reps: 10, description: "10 metre patlayıcı çıkış sprintleri", coachingTips: ["Düşük başlangıç", "İlk adım güçlü", "Kol çalışması agresif"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "20m Sprint", nameEN: "20m Sprint", category: .speedAgility, targetType: .physical, equipment: ["Koni"], level: .beginner, sets: 4, reps: 20, description: "20 metre maksimum hız sprintleri", coachingTips: ["Tam dinlenme (90sn+)", "Dik vücut pozisyonu", "Gevşek omuzlar"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "30m Max Speed", nameEN: "30m Maximum Speed", category: .speedAgility, targetType: .physical, equipment: ["Koni"], level: .intermediate, sets: 3, reps: 30, description: "30 metre maksimum hız testi", coachingTips: ["İlk 10m ivmelenme", "20-30m arası maks hız", "Rahat koşu mekaniği"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "Pro Agility (5-10-5)", nameEN: "Pro Agility 5-10-5", category: .speedAgility, targetType: .physical, equipment: ["Koni"], level: .intermediate, sets: 4, description: "5 metre git, 10 metre dön, 5 metre bitir", coachingTips: ["Düşük kalça", "El yere değsin", "Patlayıcı yön değişimi"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "T-Drill", nameEN: "T-Drill Agility", category: .speedAgility, targetType: .physical, equipment: ["Koni"], level: .intermediate, sets: 4, description: "T şeklinde çeviklik parkuru", coachingTips: ["Kalça dönüşü", "Ayak değiştirme", "Baş yukarıda"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "Deceleration Drill", nameEN: "Deceleration Control", category: .speedAgility, targetType: .physical, equipment: ["Koni"], level: .intermediate, sets: 4, reps: 15, description: "15m sprint ve kontrollü durma", coachingTips: ["Son 3m'de frenle", "Ağırlık merkezi düşük", "Küçük adımlar"], safetyNotes: "Diz üzerine dikkat", logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "Repeated Sprint (RSA)", nameEN: "Repeated Sprint Ability", category: .speedAgility, targetType: .conditioning, equipment: ["Koni"], level: .advanced, sets: 6, reps: 20, description: "6x20m sprint, 30sn dinlenme aralıklı", coachingTips: ["Her sprint maksimum", "Dinlenmede yürü", "Son sprintlerde form koru"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "Reactive Agility", nameEN: "Reactive Agility Drill", category: .speedAgility, targetType: .physical, equipment: ["Partner"], level: .advanced, sets: 3, reps: 8, description: "Partner işaretine göre reaktif yön değişimi", coachingTips: ["Gözler partnerde", "Hazır pozisyon", "Hızlı reaksiyon"], logFormat: .countBased, order: order).also { order += 1 }
        ]
    }
    
    // MARK: - 6. Kuvvet / Plyo (8 drills)
    
    private func strengthDrills(startOrder: Int) -> [Drill] {
        var order = startOrder
        return [
            Drill(name: "Goblet Squat", nameEN: "Goblet Squat", category: .strengthPlyometrics, targetType: .physical, equipment: ["Dumbbell"], level: .beginner, sets: 3, reps: 12, description: "Dumbbell ile derin squat", coachingTips: ["Dirsekler dizlerin içinde", "Göğüs dik", "Topuklarla it"], safetyNotes: "Diz ağrısında derinliği azalt", logFormat: .loadBased, order: order).also { order += 1 },
            
            Drill(name: "Romanian Deadlift", nameEN: "Romanian Deadlift", category: .strengthPlyometrics, targetType: .physical, equipment: ["Barbell/Dumbbell"], level: .intermediate, sets: 3, reps: 10, description: "Hamstring odaklı kalça menteşe hareketi", coachingTips: ["Sırt düz", "Kalça geriye", "Diz hafif bükük"], safetyNotes: "Bel yuvarlamamalı", logFormat: .loadBased, order: order).also { order += 1 },
            
            Drill(name: "Split Squat", nameEN: "Split Squat", category: .strengthPlyometrics, targetType: .physical, equipment: [], level: .beginner, sets: 3, reps: 10, description: "Her bacak için ayrı squat", coachingTips: ["Arka diz yere yakın", "Gövde dik", "Ön topukla it"], logFormat: .loadBased, order: order).also { order += 1 },
            
            Drill(name: "Calf Raises", nameEN: "Calf Raises", category: .strengthPlyometrics, targetType: .physical, equipment: [], level: .beginner, sets: 3, reps: 15, description: "Baldır kaldırma, tek veya çift ayak", coachingTips: ["Tam hareket açıklığı", "Üstte 1sn bekle", "Kontrollü iniş"], logFormat: .loadBased, order: order).also { order += 1 },
            
            Drill(name: "Copenhagen Plank", nameEN: "Copenhagen Plank", category: .strengthPlyometrics, targetType: .prevention, equipment: ["Bank"], level: .intermediate, sets: 3, reps: 30, description: "İç bacak kuvvetlendirme için yan plank", coachingTips: ["Kalça düşmemeli", "Üst bacak bankta", "Her iki taraf eşit"], safetyNotes: "Kasık ağrısında durdurun", logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "Box Jump", nameEN: "Box Jump", category: .strengthPlyometrics, targetType: .physical, equipment: ["Kutu"], level: .intermediate, sets: 3, reps: 8, description: "Kutuya patlayıcı sıçrama", coachingTips: ["Yumuşak iniş", "Dizler dışarı", "Geri yürüyerek in"], safetyNotes: "Yüksekliği kademeli artır", logFormat: .countBased, order: order).also { order += 1 },
            
            Drill(name: "Single Leg RDL", nameEN: "Single Leg Romanian Deadlift", category: .strengthPlyometrics, targetType: .physical, equipment: [], level: .intermediate, sets: 3, reps: 8, description: "Tek ayak Romanian deadlift", coachingTips: ["Denge için karşı kola uzat", "Kalça menteşe", "Yavaş kontrollü"], logFormat: .loadBased, order: order).also { order += 1 },
            
            Drill(name: "Core Circuit", nameEN: "Core Circuit", category: .strengthPlyometrics, targetType: .physical, equipment: [], level: .beginner, sets: 3, description: "Plank + Crunch + Leg Raise kombinasyonu", coachingTips: ["Her hareket 30sn", "Dinlenme minimum", "Kalite önemli"], logFormat: .countBased, order: order).also { order += 1 }
        ]
    }
    
    // MARK: - 7. Kondisyon (8 drills)
    
    private func conditioningDrills(startOrder: Int) -> [Drill] {
        var order = startOrder
        return [
            Drill(name: "HIIT 15/15 (Koşu)", nameEN: "HIIT 15/15 Running", category: .conditioning, targetType: .conditioning, equipment: [], level: .intermediate, durationMinutes: 10, description: "15sn sprint, 15sn dinlenme protokolü", coachingTips: ["Sprint maksimum efor", "Dinlenmede yürü", "10 dk toplam"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "HIIT 30/30 (Koşu)", nameEN: "HIIT 30/30 Running", category: .conditioning, targetType: .conditioning, equipment: [], level: .advanced, durationMinutes: 10, description: "30sn sprint, 30sn dinlenme protokolü", coachingTips: ["Yüksek yoğunluk", "Form bozulursa dur", "Progresif artış"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "Repeated Sprint Protocol", nameEN: "Repeated Sprint Protocol", category: .conditioning, targetType: .conditioning, equipment: ["Koni"], level: .advanced, sets: 6, description: "10sn sprint / 50sn dinlenme, 6 set", coachingTips: ["Her sprint %100", "Aktif dinlenme", "Kalp atış hızını izle"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "Small-Sided Game 3v3", nameEN: "3v3 Small Sided Game", category: .conditioning, targetType: .conditioning, equipment: ["Top", "Kale"], level: .intermediate, durationMinutes: 15, description: "3'e 3 küçük alan maçı, 5 dk periyotlar", coachingTips: ["Yüksek tempo", "Çabuk geçiş", "Herkes atağa/savunmaya"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "Small-Sided Game 4v4", nameEN: "4v4 Small Sided Game", category: .conditioning, targetType: .conditioning, equipment: ["Top", "Kale"], level: .intermediate, durationMinutes: 18, description: "4'e 4 küçük alan maçı, 6 dk periyotlar", coachingTips: ["Kompakt oyna", "Geçişlerde sprint", "Taktik disiplin"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "Small-Sided Game 5v5", nameEN: "5v5 Small Sided Game", category: .conditioning, targetType: .conditioning, equipment: ["Top", "Kale"], level: .intermediate, durationMinutes: 16, description: "5'e 5 küçük alan maçı, 8 dk periyotlar", coachingTips: ["Pozisyonel oyun", "Destek açıları", "Yüksek tempo"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "Tempo Run (%70)", nameEN: "Tempo Run 70%", category: .conditioning, targetType: .conditioning, equipment: [], level: .beginner, sets: 4, reps: 400, description: "400m x 4 set, %70 tempo koşu", coachingTips: ["Sabit tempo", "Nefes ritmi", "Aktif dinlenme arası"], logFormat: .timeBased, order: order).also { order += 1 },
            
            Drill(name: "Interval Shuttle", nameEN: "Interval Shuttle Run", category: .conditioning, targetType: .conditioning, equipment: ["Koni"], level: .intermediate, sets: 6, description: "Mekik koşu formatında interval antrenman", coachingTips: ["Yön değişimlerinde düşük kal", "Tempo kademeli artsın", "Son setlerde form koru"], logFormat: .timeBased, order: order).also { order += 1 }
        ]
    }
}

// MARK: - Helper Extension

private extension Drill {
    func also(_ block: () -> Void) -> Drill {
        block()
        return self
    }
}
