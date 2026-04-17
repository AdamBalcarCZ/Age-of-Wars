**Dokumentace k RTS Hře (Godot 4)**
Tento dokument popisuje základní strukturu, mechaniky a skripty jednoduché RTS (Real-Time Strategy) hry postavené v enginu Godot 4. Hra obsahuje těžbu surovin, pohyb a výběr jednotek, stavění na mřížce a uživatelské rozhraní pro produkci.

**Základní Mechaniky**
Ekonomika: Hráč těží dvě základní suroviny: Dřevo (Wood) a Zlato (Gold).

Grid System (Mřížka): Mapa je matematicky rozdělena do mřížky (výchozí velikost dlaždice je 32x32 nebo 16x16 pixelů). Stromy se generují přesně na těchto bodech a budovy (Barracks) se při stavění "přichytávají" k této mřížce.

Výběr jednotek (Selection): Hráč může kliknout na jednotlivou entitu nebo táhnout myší obdélník (drag-select) pro hromadný výběr.

Pohyb: Vybrané jednotky se pohybují pomocí pravého kliknutí myši s možností fronty příkazů (Shift-click).

**Struktura Hlavních Skriptů**
Systém se skládá z několika nezávislých skriptů, které spolu komunikují primárně přes Globální Autoload nebo signály.

**1. Game.gd (Globální Autoload / Singleton)**
Funkce: Funguje jako mozek hry. Udržuje stav surovin (Dřevo, Zlato), aby k nim měl přístup jakýkoliv jiný skript.

Metody: * open_spawn_menu(position): Najde vrstvu UI ve světě a vygeneruje do ní instanci menu pro trénování jednotky.

**2. world.gd (Správce Mapy)**
Funkce: Řídí generování objektů a interakci se světem.

Generování: Při startu hry (_ready) vytvoří prázdné 2D pole (grid) a náhodně do něj rozmístí stromy tak, aby se nepřekrývaly.

Stavění: Čte vstup od hráče (_unhandled_input). Při levém kliknutí přepočítá pozici myši na nejbližší souřadnice mřížky a pokud je políčko prázdné, postaví tam Barracks (budovu).

**3. camera.gd (Kamera a RTS Výběr)**
Funkce: Zajišťuje plynulý pohyb po mapě, zoomování a vykreslování zeleného obdélníku pro výběr jednotek.

Logika: * Pohyb pomocí přednastavených kláves (WASD / Šipky).

Kolečko myši upravuje proměnnou target_zoom pro plynulé přiblížení/oddálení.

Při tažení myší počítá velikost obdélníku a vykresluje ho pomocí UI Panel uzlu. Po puštění myši odešle signál se souřadnicemi do world.gd, který vybere jednotky uvnitř.

**4. unit.gd (Základní Jednotka - Worker/Soldier)**
Funkce: Fyzický pohyb jednotky (CharacterBody2D).

Logika:

Musí patřit do skupin units, selectables a player_owned.

Obsahuje pole waypoints. Pravé kliknutí přidá cíl do pole, pohyb řeší funkce move_and_slide() s plynulým přesunem pomocí direction_to.

**5. barracks.gd / BarbHouse.gd (Produkční Budova)**
Funkce: Statická budova (StaticBody2D), která reaguje na kliknutí.

Logika: Po označení levým tlačítkem vyvolá skrze Game.gd uživatelské rozhraní (spawn_unit.tscn) pro nákup jednotek.

**6. spawn_unit.gd (UI Menu)**
Funkce: Dialogové okno (Ano/Ne).

Logika: Pokud hráč klikne na "Ano", skript zkontroluje, zda je dostatek surovin, odečte je a instancuje Unit.tscn poblíž budovy. Poté se menu samo smaže (queue_free()).

**7. Suroviny (tree.gd & coin_house.gd)**
Tree (Stromy): Využívají uzel Timer a ProgressBar. Počet jednotek uvnitř Area2D zrychluje odpočet. K plynulé animaci lišty využívá get_tree().create_tween().

Coin House (Důl): Podobný princip. Jednotky uvnitř oblasti automaticky generují zlato každé tiknutí časovače.
