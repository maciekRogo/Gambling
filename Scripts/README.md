# Dokumentacja folderu `Scripts`

Folder zawiera skrypty używane w projekcie gry. Poniżej znajduje się opis każdego pliku.

## Spis treści
1. [HUD.gd](#hudgd)
2. [Reel.gd](#reelgd)
3. [ScriptsSignalBank.gd](#scriptssignalbankgd)
4. [SignalBank.gd](#signalbankgd)
5. [blackjack_gra.gd](#blackjack_gragd)
6. [cala_gra.gd](#cala_gragd)
7. [npc.gd](#npcgd)
8. [postac_1.gd](#postac_1gd)
9. [slot_machine_ui.gd](#slot_machine_uigd)
10. [ui_area_automaty.gd](#ui_area_automatygd)

---

## HUD.gd
Skrypt odpowiedzialny za wyświetlanie aktualnego stanu pieniędzy gracza.
- **Typ**: `CanvasLayer`
- **Funkcje kluczowe**:
  - `_process`: Aktualizuje tekst etykiety z ilością pieniędzy.

[Źródło skryptu](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scripts/HUD.gd)

---

## Reel.gd
Obsługuje logikę bębnów w automacie do gry.
- **Typ**: `Node2D`
- **Zmienne**:
  - `slot_item_count`, `sprite_size`, `reelID`
- **Funkcje kluczowe**:
  - `_startRoll`: Rozpoczyna obrót bębna.
  - `_move_reels`: Przewija bębny.

[Źródło skryptu](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scripts/Reel.gd)

---

## ScriptsSignalBank.gd
Pusty szablon skryptu. Dodaj logikę w metodach `_ready` i `_process`.

[Źródło skryptu](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scripts/ScriptsSignalBank.gd)

---

## SignalBank.gd
Obsługuje sygnały i zarządza stanem pieniędzy gracza.
- **Typ**: `Node`
- **Sygnaly**:
  - `startRoll(slotID, duration)`
  - `rollFinished(slotID, result)`

[Źródło skryptu](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scripts/SignalBank.gd)

---

## blackjack_gra.gd
Skrypt obsługujący interfejs gry w blackjacka.
- **Typ**: `Control`
- **Funkcje kluczowe**:
  - `_on_start_button_pressed`: Zmienia scenę na blackjacka.
  - `_on_close_game_pressed`: Wraca do głównej mapy.

[Źródło skryptu](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scripts/blackjack_gra.gd)

---

## cala_gra.gd
Zawiera pełną logikę gry w blackjacka, w tym zarządzanie kartami, punktami i zakładami.
- **Typ**: `Control`
- **Funkcje kluczowe**:
  - `start_game`, `generate_card`, `playerWin`, `playerLose`

[Źródło skryptu](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scripts/cala_gra.gd)

---

## npc.gd
Obsługuje zachowanie NPC, w tym ruch i interakcję z graczem.
- **Typ**: `CharacterBody2D`
- **Funkcje kluczowe**:
  - `start_dialogue`: Rozpoczyna dialog z NPC.
  - `move`: Umożliwia NPC poruszanie się po mapie.

[Źródło skryptu](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scripts/npc.gd)

---

## postac_1.gd
Zarządza ruchem głównej postaci gracza.
- **Typ**: `CharacterBody2D`
- **Funkcje kluczowe**:
  - `get_input`: Obsługuje sterowanie graczem.
  - `update_animation`: Aktualizuje animację w zależności od ruchu.

[Źródło skryptu](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scripts/postac_1.gd)

---

## slot_machine_ui.gd
Zarządza interfejsem automatu do gry.
- **Typ**: `Control`
- **Funkcje kluczowe**:
  - `_calculateWinning`: Oblicza wygrane.
  - `_on_spin_button_button_up`: Rozpoczyna obrót bębnów.

[Źródło skryptu](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scripts/slot_machine_ui.gd)

---

## ui_area_automaty.gd
Obsługuje obszar interakcji z automatem.
- **Typ**: `Area2D`
- **Funkcje kluczowe**:
  - `_on_body_entered`: Pokazuje prompt po wejściu gracza.
  - `_process`: Zmienia scenę na automat po kliknięciu.

[Źródło skryptu](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scripts/ui_area_automaty.gd)

---
