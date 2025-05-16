# Dokumentacja folderu `testy`

## Cel folderu
Folder `testy` zawiera pliki testowe używane do walidacji funkcjonalności różnych modułów projektu `Gambling`.

## Struktura folderu
Pliki w folderze `testy` to:
- `test_cala_gra.gd`: Testuje całą logikę gry.
- `test_npc.gd`: Testy związane z NPC (Non-Player Character).
- `test_postac1.gd`: Testy dotyczące postaci gracza.
- `test_reel.gd`: Testy dla mechanizmu bębnów (reel) w grze.
- `test_slot_machine_ui.gd`: Testy interfejsu użytkownika automatu do gry.

Każdy plik posiada również powiązany plik `.uid`, który prawdopodobnie przechowuje metadane lub unikalne identyfikatory.

## Jak uruchomić testy
1. Upewnij się, że środowisko uruchomieniowe (np. Godot) jest poprawnie skonfigurowane.
2. W Godot otwórz wtyczkę GUT z menu narzędzi.
3. Wybierz testy z folderu `testy` i uruchom je za pomocą interfejsu GUT.

## Znane problemy
- **Problem z brakującymi plikami `.uid`:** Jeśli pliki `.uid` zostaną usunięte lub uszkodzone, testy mogą nie działać poprawnie.
- **Konflikty w wersjach Godot:** Upewnij się, że korzystasz z wersji silnika Godot zgodnej z wymogami projektu.

## Struktura testów
Testy w folderze `testy` są podzielone na:
- **Testy jednostkowe:** Testują specyficzne funkcjonalności, np. mechanizmy bębnów.
- **Testy integracyjne:** Sprawdzają, jak różne moduły współpracują ze sobą, np. interakcje z NPC w grze.

## Wersja projektu i zależności
- **Wersja silnika:** Godot 4.0 lub nowsza.
- **Wtyczka testowa:** GUT w wersji 7.0 lub nowszej.

## Uwagi
- Testy zostały napisane w języku GDScript, który jest używany w silniku Godot.
- W przypadku problemów z plikami `.uid`, sprawdź integralność plików projektu.
- Aby uzyskać więcej informacji o wtyczce GUT, odwiedź [oficjalne repozytorium GUT](https://github.com/bitwes/Gut).
