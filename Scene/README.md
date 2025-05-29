# Dokumentacja folderu `Scene`

Folder zawiera sceny używane w projekcie gry. Poniżej znajduje się opis każdego pliku.

## Spis treści
1. [npc.tscn](#npctscn)
2. [HUD.tscn](#hudtscn)
3. [reel.tscn](#reeltscn)
4. [signal_bank.tscn](#signal_banktscn)
5. [slot_machine.tscn](#slot_machinetscn)
6. [blackjack_gra.tscn](#blackjack_gratscn)
7. [mapatemplate_version2.tscn](#mapatemplate_version2tscn)
8. [Press_E_to_play.tscn](#press_e_to_playtscn)
9. [blackjack_game.tscn](#blackjack_gametscn)
10. [Press_E_to_play_blackjack.tscn](#press_e_to_play_blackjacktscn)
11. [postac1.tscn](#postac1tscn)
12. [UI_area_automaty.tscn](#ui_area_automatyt)
13. [roulette.tscn](#roulettetscn)
14. [TestyWydajnosciowe.tscn](#TestyWydajnosciowetscn)

---

## npc.tscn
Plik definiuje scenę zawierającą postać (`npc`). Zawartość:
- **Skrypt**: `Scripts/npc.gd`.
- **Tekstura**: `Assets/Human-Worker-Red.png`.
- **Animacje**:
  - `idle`
  - `walk_e`
  - `walk_n`
  - `walk_s`
  - `walk_w`
- **Timer** i **SelfTalkTimer**: Zarządzają czasowymi zdarzeniami.
- **Obszar detekcji**: `chat_detection_area`.
- **Połączenia sygnałów**:
  - `body_entered`
  - `timeout`

[Zobacz plik w repozytorium](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scene/npc.tscn)

---

## HUD.tscn
Plik opisuje interfejs użytkownika:
- **Skrypt**: `Scripts/HUD.gd`.
- **Elementy**:
  - `Label` wyświetlający saldo gracza: `Money: 1000`.

[Zobacz plik w repozytorium](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scene/HUD.tscn)

---

## reel.tscn
Scena przedstawiająca `Reel` (bęben automatu):
- **Skrypt**: `Scripts/Reel.gd`.
- **Tekstury**:
  - `symbole.png`
  - `reelFrame.png`
  - `reelMask.png`.

[Zobacz plik w repozytorium](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scene/reel.tscn)

---

## signal_bank.tscn
Scena zarządzająca sygnałami:
- **Skrypt**: `Scripts/SignalBank.gd`.

[Zobacz plik w repozytorium](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scene/signal_bank.tscn)

---

## slot_machine.tscn
Scena dla automatu do gry:
- **Skrypt**: `Scripts/slot_machine_ui.gd`.
- **Tekstury automatu**:
  - `slot-machine1.png`
  - `slot-machine2.png`
- **Bębny**:
  - 3 instancje `Reel`, każdy z unikalnym ID.
- **Elementy interfejsu**:
  - `Button`
  - `SpinBox` do stawiania zakładów.
- **Połączenia sygnałów**:
  - `button_up`
  - `pressed`.

[Zobacz plik w repozytorium](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scene/slot_machine.tscn)

---

## blackjack_gra.tscn
Scena dla gry Blackjack:
- **Skrypt**: `Scripts/blackjack_gra.gd`.
- **Elementy**:
  - Przycisk `StartButton` do rozpoczęcia gry.
  - Przycisk `CloseGame` do zakończenia gry.
- **Połączenia sygnałów**:
  - `pressed` dla różnych interakcji.

[Zobacz plik w repozytorium](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scene/blackjack_gra.tscn)

---

## mapatemplate_version2.tscn
Scena szablonu mapy:
- **Tekstura**: `2D_TopDown_Tileset_Casino_640x512.png`.
- **Wykorzystanie innych scen**:
  - `npc.tscn`
  - `UI_area_automaty.tscn`.

[Zobacz plik w repozytorium](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scene/mapatemplate_version2.tscn)

---

## Press_E_to_play.tscn
Scena informacyjna:
- Wyświetla komunikat: „press [e] to play”.

[Zobacz plik w repozytorium](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scene/Press_E_to_play.tscn)

---

## blackjack_game.tscn
Scena główna gry Blackjack:
- **Skrypt**: `Scripts/cala_gra.gd`.
- **Elementy**:
  - `Dobierz` (przycisk)
  - `Zostaw` (przycisk)
  - `Start` (przycisk)
- **Połączenia sygnałów**:
  - `start_game`

[Zobacz plik w repozytorium](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scene/blackjack_game.tscn)

---

## Press_E_to_play_blackjack.tscn
Scena informacyjna dla Blackjacka:
- Wyświetla komunikat: „Press [E] to play”.

[Zobacz plik w repozytorium](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scene/Press_E_to_play_blackjack.tscn)

---

## postac1.tscn
Plik definiuje postać (`postac`) w grze. Zawartość:
- **Skrypt**: `Scripts/postac_1.gd`.
- **Tekstura**: `16x16-RPG-characters/preview.png`.
- **Animacje**:
  - `idle_down`, `idle_left`, `idle_right`, `idle_up`.
  - `walk_down`, `walk_left`, `walk_right`, `walk_up`.
- **Node'y**:
  - `CollisionShape2D`: Prostokąt.
  - `AnimatedSprite2D`: Animowane sprite'y dla postaci.
  - `Camera2D`: Kamera dla postaci.

[Zobacz plik w repozytorium](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scene/postac1.tscn)

---

## UI_area_automaty.tscn
Plik definiuje obszar interakcji dla automatów do gry. Zawartość:
- **Skrypt**: `Scripts/ui_area_automaty.gd`.
- **Node'y**:
  - `Area2D`: Zarządza interakcjami w obszarze.
  - `CollisionShape2D`: Okrąg definiujący obszar kolizji.
- **Połączenia sygnałów**:
  - `body_entered`
  - `body_exited`

[Zobacz plik w repozytorium](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scene/UI_area_automaty.tscn)

---

## roulette.tscn
Plik definiuje scenę gry w ruletkę. Zawartość:

- **Skrypt:** `Scripts/wheel.gd` (przypisany do node’a `wheel`)
- **Tekstury:**
  - Koło ruletki: `Assets/roulette/wheel_to_convert.png`
  - Wskaźnik: `Assets/roulette/arrow_down.png`
- **Node'y:**
  - `wheel` (Sprite2D): Prezentuje i animuje koło ruletki, obsługuje logikę losowania.
  - `Button`: Przycisk „Start” do uruchomienia zakręcenia koła.
  - `BetInput` (LineEdit): Pole do wpisania kwoty zakładu.
  - `GridContainer` oraz przyciski: Umożliwiają wybór numerów oraz zakładów specjalnych ("EVEN", "ODD", "RED", "BLACK", "1st 12" itd.).
  - `Button2`: Przycisk „Wyjdź” do opuszczenia sceny.
- **Połączenia sygnałów:**
  - `pressed` z przycisku „Wyjdź” do metody `_on_button_2_pressed` w node `wheel`.

[Zobacz plik w repozytorium](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scene/roulette.tscn)

---

## TestyWydajnosciowe.tscn
Plik definiuje scenę testów wydajności gry. Zawartość:

- **Skrypt:** `testy/TestyWydajnosciowe.gd` (przypisany do node’a `reel`)
- **Node'y:**
  - `TestyWydajnosciowe` (Node2D): Główny node sceny.
  - `cala_gra` (Node2D): Node potomny, prawdopodobnie do testowania pełnej gry.
  - `reel` (Node2D): Node z przypisanym skryptem testowym.

[Zobacz plik w repozytorium](https://github.com/maciekRogo/Gambling/blob/victor-dev/Scene/TestyWydajnosciowe.tscn)

---

