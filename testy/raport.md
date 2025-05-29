# Raport z testów automatycznych projektu Godot

---

## Podsumowanie ogólne

| Liczba skryptów testowych | Liczba testów | Liczba asercji | Czas wykonania  |
|---------------------------|---------------|----------------|-----------------|
| 6                         | 87            | 160            | 9.676 s         |

**Wszystkie testy przeszły pomyślnie (87/87).**

---

## Szczegóły testów według skryptów

### 1. `res://testy/test_cala_gra.gd`

- Liczba testów: 22
- Status: wszystkie przeszły
- Testowane funkcjonalności: obsługa zakładów, reakcje na błędne wejścia, mechanika gry (wygrana, przegrana, remis), generowanie kart, obsługa asów, zakończenie gry.

---

### 2. `res://testy/test_npc.gd`

- Liczba testów: 5
- Status: wszystkie przeszły
- Uwagi:  
  - 1 nowy obiekt sierota ("orphan") pojawił się podczas testu.  
  - Test skryptu zawierał 6 niezwolnionych dzieci (unfreed children).  
  - Pojawiły się ostrzeżenia o "orphans".

---

### 3. `res://testy/test_postac1.gd`

- Liczba testów: 12
- Status: wszystkie przeszły
- Uwagi:  
  - 13 niezwolnionych dzieci.  
  - Testy dotyczyły ruchu i animacji postaci.

---

### 4. `res://testy/test_reel.gd`

- Liczba testów: 17
- Status: wszystkie przeszły
- Uwagi:  
  - W trakcie testów pojawiło się łącznie kilkanaście obiektów sierot (orphanów).  
  - Testy obejmowały logikę bębna maszyny slotowej: ruch, zatrzymanie, cykle, sygnały.

---

### 5. `res://testy/test_roulette.gd`

- Liczba testów: 13
- Status: wszystkie przeszły
- Uwagi:  
  - 4 niezwolnione dzieci podczas testu.  
  - Pojawiło się ostrzeżenie dotyczące porównania floatów z intami.  
  - Testowano zakłady, walidację, start i zatrzymanie obrotu, wygrane/przegrane.

---

### 6. `res://testy/test_slot_machine_ui.gd`

- Liczba testów: 18
- Status: wszystkie przeszły
- Testy dotyczyły UI i logiki wygranych w maszynie slotowej, reagowania na brak środków, resetowania stanu, wielokrotnych spinów.

---

## Ostrzeżenia i uwagi

- W trakcie testów pojawiło się łącznie **4 ostrzeżenia**.
- Obserwowany łączny liczba niezwolnionych dzieci (orphans): około **7** (nie licząc globalnych obiektów i GUT).
- Zaleca się przejrzenie testów dotyczących NPC, postaci oraz bębna slotu pod kątem zarządzania pamięcią, aby zmniejszyć liczbę pozostających obiektów.

---

## Podsumowanie

- Testy objęły szeroki zakres funkcjonalności od logiki gry blackjacka, NPC, ruchów postaci, maszyn slotowych, aż po ruletkę.
- Wszystkie testy zakończyły się sukcesem, co świadczy o stabilności i dobrej jakości kodu.
- Zalecane jest zwrócenie uwagi na ostrzeżenia o obiektach sierot i zarządzaniu pamięcią w skryptach testowych.

---

**Raport wygenerowany automatycznie na podstawie wyników testów GUT w Godot.**
