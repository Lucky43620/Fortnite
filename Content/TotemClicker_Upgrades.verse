# =========================================================================
# TotemClicker_Upgrades.verse
# =========================================================================
# Rôle : Gestion des upgrades (clic et production globale)
# VERSION ÉTENDUE : Beaucoup plus d'upgrades pour une progression longue
# =========================================================================

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Structure pour une upgrade de clic
click_upgrade_data := struct:
    Level : int
    ClickPower : float
    Cost : float

# Structure pour une upgrade globale
global_upgrade_data := struct:
    Name : string
    Multiplier : float
    Cost : float
    Purchased : logic = false

# Gestionnaire des upgrades
totem_upgrades := class:

    # =====================================================
    # UPGRADES DE CLIC (30 niveaux - COOKIE CLICKER STYLE)
    # =====================================================
    var ClickUpgrades : []click_upgrade_data = array:
        click_upgrade_data{Level := 0, ClickPower := 1.0, Cost := 0.0}
        click_upgrade_data{Level := 1, ClickPower := 2.0, Cost := 50.0}
        click_upgrade_data{Level := 2, ClickPower := 5.0, Cost := 200.0}
        click_upgrade_data{Level := 3, ClickPower := 10.0, Cost := 800.0}
        click_upgrade_data{Level := 4, ClickPower := 20.0, Cost := 3000.0}
        click_upgrade_data{Level := 5, ClickPower := 40.0, Cost := 12000.0}
        click_upgrade_data{Level := 6, ClickPower := 80.0, Cost := 50000.0}
        click_upgrade_data{Level := 7, ClickPower := 160.0, Cost := 250000.0}
        click_upgrade_data{Level := 8, ClickPower := 350.0, Cost := 1000000.0}
        click_upgrade_data{Level := 9, ClickPower := 750.0, Cost := 5000000.0}
        click_upgrade_data{Level := 10, ClickPower := 1500.0, Cost := 25000000.0}
        click_upgrade_data{Level := 11, ClickPower := 3500.0, Cost := 100000000.0}
        click_upgrade_data{Level := 12, ClickPower := 8000.0, Cost := 500000000.0}
        click_upgrade_data{Level := 13, ClickPower := 18000.0, Cost := 2500000000.0}
        click_upgrade_data{Level := 14, ClickPower := 40000.0, Cost := 10000000000.0}
        click_upgrade_data{Level := 15, ClickPower := 100000.0, Cost := 50000000000.0}
        click_upgrade_data{Level := 16, ClickPower := 250000.0, Cost := 250000000000.0}
        click_upgrade_data{Level := 17, ClickPower := 650000.0, Cost := 1000000000000.0}
        click_upgrade_data{Level := 18, ClickPower := 1500000.0, Cost := 5000000000000.0}
        click_upgrade_data{Level := 19, ClickPower := 4000000.0, Cost := 25000000000000.0}
        # NOUVEAUX NIVEAUX 20-29 (10 nouveaux)
        click_upgrade_data{Level := 20, ClickPower := 10000000.0, Cost := 120000000000000.0}
        click_upgrade_data{Level := 21, ClickPower := 25000000.0, Cost := 600000000000000.0}
        click_upgrade_data{Level := 22, ClickPower := 65000000.0, Cost := 3000000000000000.0}
        click_upgrade_data{Level := 23, ClickPower := 170000000.0, Cost := 15000000000000000.0}
        click_upgrade_data{Level := 24, ClickPower := 450000000.0, Cost := 75000000000000000.0}
        click_upgrade_data{Level := 25, ClickPower := 1200000000.0, Cost := 380000000000000000.0}
        click_upgrade_data{Level := 26, ClickPower := 3200000000.0, Cost := 1900000000000000000.0}
        click_upgrade_data{Level := 27, ClickPower := 8500000000.0, Cost := 9500000000000000000.0}
        click_upgrade_data{Level := 28, ClickPower := 23000000000.0, Cost := 47000000000000000000.0}
        click_upgrade_data{Level := 29, ClickPower := 60000000000.0, Cost := 240000000000000000000.0}

    # =====================================================
    # UPGRADES GLOBALES (50 upgrades - COOKIE CLICKER STYLE)
    # =====================================================
    var GlobalUpgrades : []global_upgrade_data = array:
        # Tier 1 : Early game
        global_upgrade_data{Name := "Flux Totémique I", Multiplier := 1.1, Cost := 10000.0}
        global_upgrade_data{Name := "Flux Totémique II", Multiplier := 1.15, Cost := 100000.0}
        global_upgrade_data{Name := "Flux Totémique III", Multiplier := 1.2, Cost := 500000.0}

        # Tier 2 : Mid game
        global_upgrade_data{Name := "Ascension Totémique", Multiplier := 1.5, Cost := 1000000.0}
        global_upgrade_data{Name := "Transcendance Mineure", Multiplier := 1.5, Cost := 10000000.0}
        global_upgrade_data{Name := "Bénédiction des Anciens", Multiplier := 1.3, Cost := 50000000.0}

        # Tier 3 : Late pre-prestige
        global_upgrade_data{Name := "Puissance Cosmique", Multiplier := 2.0, Cost := 250000000.0}
        global_upgrade_data{Name := "Transcendance Majeure", Multiplier := 2.0, Cost := 1000000000.0}
        global_upgrade_data{Name := "Éveil Spirituel", Multiplier := 1.5, Cost := 5000000000.0}
        global_upgrade_data{Name := "Harmonie Universelle", Multiplier := 1.8, Cost := 25000000000.0}

        # Tier 4 : Post-prestige
        global_upgrade_data{Name := "Apothéose I", Multiplier := 3.0, Cost := 100000000000.0}
        global_upgrade_data{Name := "Apothéose II", Multiplier := 3.0, Cost := 500000000000.0}
        global_upgrade_data{Name := "Maîtrise Dimensionnelle", Multiplier := 2.5, Cost := 2000000000000.0}
        global_upgrade_data{Name := "Fusion Temporelle", Multiplier := 2.5, Cost := 10000000000000.0}
        global_upgrade_data{Name := "Omniscience", Multiplier := 4.0, Cost := 50000000000000.0}

        # Tier 5 : End-game
        global_upgrade_data{Name := "Singularité Spirituelle", Multiplier := 5.0, Cost := 250000000000000.0}
        global_upgrade_data{Name := "Conscience Infinie", Multiplier := 5.0, Cost := 1000000000000000.0}
        global_upgrade_data{Name := "Transcendance Ultime", Multiplier := 10.0, Cost := 5000000000000000.0}
        global_upgrade_data{Name := "Divinité Absolue", Multiplier := 10.0, Cost := 25000000000000000.0}
        global_upgrade_data{Name := "Au-Delà du Temps", Multiplier := 15.0, Cost := 100000000000000000.0}

        # Tier 6 : Post-end-game (pour les joueurs très avancés)
        global_upgrade_data{Name := "Omnipotence I", Multiplier := 20.0, Cost := 500000000000000000.0}
        global_upgrade_data{Name := "Omnipotence II", Multiplier := 25.0, Cost := 2000000000000000000.0}
        global_upgrade_data{Name := "Création Primordiale", Multiplier := 50.0, Cost := 10000000000000000000.0}
        global_upgrade_data{Name := "Infini Totémique", Multiplier := 100.0, Cost := 50000000000000000000.0}
        global_upgrade_data{Name := "Éternité Absolue", Multiplier := 500.0, Cost := 250000000000000000000.0}

        # Tier 7 : Ultra end-game (25 NOUVELLES UPGRADES 25-49)
        global_upgrade_data{Name := "Genèse Quantique", Multiplier := 2.0, Cost := 1000000000000000000000.0}
        global_upgrade_data{Name := "Résonance Universelle", Multiplier := 2.5, Cost := 5000000000000000000000.0}
        global_upgrade_data{Name := "Nexus Infini", Multiplier := 3.0, Cost := 25000000000000000000000.0}
        global_upgrade_data{Name := "Harmonie Cosmique", Multiplier := 3.5, Cost := 120000000000000000000000.0}
        global_upgrade_data{Name := "Éther Primordial", Multiplier := 4.0, Cost := 600000000000000000000000.0}

        # Tier 8 : Transcendance
        global_upgrade_data{Name := "Éveil Absolu", Multiplier := 5.0, Cost := 3000000000000000000000000.0}
        global_upgrade_data{Name := "Synergie Divine", Multiplier := 6.0, Cost := 15000000000000000000000000.0}
        global_upgrade_data{Name := "Matrice Infinie", Multiplier := 7.0, Cost := 75000000000000000000000000.0}
        global_upgrade_data{Name := "Conscience Ultime", Multiplier := 8.0, Cost := 380000000000000000000000000.0}
        global_upgrade_data{Name := "Singularité Parfaite", Multiplier := 10.0, Cost := 1900000000000000000000000000.0}

        # Tier 9 : Omnipotence
        global_upgrade_data{Name := "Pouvoir Illimité", Multiplier := 12.0, Cost := 9500000000000000000000000000.0}
        global_upgrade_data{Name := "Maîtrise Totale", Multiplier := 15.0, Cost := 47000000000000000000000000000.0}
        global_upgrade_data{Name := "Domination Absolue", Multiplier := 20.0, Cost := 240000000000000000000000000000.0}
        global_upgrade_data{Name := "Règne Éternel", Multiplier := 25.0, Cost := 1200000000000000000000000000000.0}
        global_upgrade_data{Name := "Empire Cosmique", Multiplier := 30.0, Cost := 6000000000000000000000000000000.0}

        # Tier 10 : Divinité (Les 10 dernières - multiplicateurs massifs)
        global_upgrade_data{Name := "Ascension Divine", Multiplier := 40.0, Cost := 30000000000000000000000000000000.0}
        global_upgrade_data{Name := "Panthéon Suprême", Multiplier := 50.0, Cost := 150000000000000000000000000000000.0}
        global_upgrade_data{Name := "Trône Céleste", Multiplier := 75.0, Cost := 750000000000000000000000000000000.0}
        global_upgrade_data{Name := "Couronne d'Éternité", Multiplier := 100.0, Cost := 3800000000000000000000000000000000.0}
        global_upgrade_data{Name := "Sceptre du Chaos", Multiplier := 150.0, Cost := 19000000000000000000000000000000000.0}
        global_upgrade_data{Name := "Essence Primordiale", Multiplier := 200.0, Cost := 95000000000000000000000000000000000.0}
        global_upgrade_data{Name := "Nexus Dimensional", Multiplier := 300.0, Cost := 480000000000000000000000000000000000.0}
        global_upgrade_data{Name := "Architecte d'Univers", Multiplier := 500.0, Cost := 2400000000000000000000000000000000000.0}
        global_upgrade_data{Name := "Source de Toute Vie", Multiplier := 750.0, Cost := 12000000000000000000000000000000000000.0}
        global_upgrade_data{Name := "Omniversel Suprême", Multiplier := 1000.0, Cost := 60000000000000000000000000000000000000.0}

    # =====================================================
    # UPGRADES SPÉCIFIQUES PAR GÉNÉRATEUR
    # (À implémenter : double la production d'un générateur spécifique)
    # =====================================================
    var GeneratorSpecificUpgrades : []global_upgrade_data = array:
        # Esprit Mineur
        global_upgrade_data{Name := "Mineurs Bénis", Multiplier := 2.0, Cost := 1000.0}
        global_upgrade_data{Name := "Mineurs Transcendés", Multiplier := 2.0, Cost := 100000.0}

        # Totem Secondaire
        global_upgrade_data{Name := "Totems Améliorés", Multiplier := 2.0, Cost := 10000.0}
        global_upgrade_data{Name := "Totems Divins", Multiplier := 2.0, Cost := 500000.0}

        # Gardien Ancien
        global_upgrade_data{Name := "Gardiens Renforcés", Multiplier := 2.0, Cost := 50000.0}
        global_upgrade_data{Name := "Gardiens Éternels", Multiplier := 2.0, Cost := 5000000.0}

        # Forge Spirituelle
        global_upgrade_data{Name := "Forges Optimisées", Multiplier := 2.0, Cost := 500000.0}
        global_upgrade_data{Name := "Forges Cosmiques", Multiplier := 2.0, Cost := 50000000.0}

        # Monolithe Obscur
        global_upgrade_data{Name := "Monolithes Synergiques", Multiplier := 2.0, Cost := 5000000.0}
        global_upgrade_data{Name := "Monolithes Infinis", Multiplier := 2.0, Cost := 500000000.0}

    # Statut des upgrades globales achetées (50 total)
    var GlobalUpgradesPurchased : []logic = array{
        false, false, false, false, false, false, false, false, false, false,
        false, false, false, false, false, false, false, false, false, false,
        false, false, false, false, false, false, false, false, false, false,
        false, false, false, false, false, false, false, false, false, false,
        false, false, false, false, false, false, false, false, false, false
    }

    # Statut des upgrades spécifiques de générateurs
    var GeneratorUpgradesPurchased : []logic = array{
        false, false, false, false, false, false, false, false, false, false
    }

    # =====================================================
    # FONCTIONS - UPGRADES DE CLIC
    # =====================================================

    # Obtient la puissance de clic pour un niveau donné
    GetClickPower(Level : int) : float =
        if (Level >= 0):
            if (Level < ClickUpgrades.Length):
                if (Upgrade := ClickUpgrades[Level]):
                    Upgrade.ClickPower
                else:
                    1.0
            else:
                # Si niveau hors limites, retourner la puissance max
                MaxIndex := ClickUpgrades.Length - 1
                if (LastUpgrade := ClickUpgrades[MaxIndex]):
                    LastUpgrade.ClickPower
                else:
                    1.0
        else:
            1.0

    # Obtient le coût de la prochaine upgrade de clic
    GetNextClickUpgradeCost(CurrentLevel : int) : float =
        NextLevel := CurrentLevel + 1
        if (NextLevel >= 0):
            if (NextLevel < ClickUpgrades.Length):
                if (Upgrade := ClickUpgrades[NextLevel]):
                    return Upgrade.Cost
        # Plus d'upgrade disponible
        return -1.0

    # Vérifie si une upgrade de clic est disponible
    HasNextClickUpgrade(CurrentLevel : int) : logic =
        NextLevel := CurrentLevel + 1
        if (NextLevel < ClickUpgrades.Length):
            return true
        return false

    # =====================================================
    # FONCTIONS - UPGRADES GLOBALES
    # =====================================================

    # Calcule le multiplicateur global total
    CalculateGlobalMultiplier()<transacts><decides> : float =
        var TotalMultiplier : float = 1.0

        MaxIndex := GlobalUpgrades.Length - 1
        for (Index := 0..MaxIndex):
            if (IsPurchased := GlobalUpgradesPurchased[Index]):
                if (IsPurchased = true):
                    if (Upgrade := GlobalUpgrades[Index]):
                        set TotalMultiplier = TotalMultiplier * Upgrade.Multiplier

        return TotalMultiplier

    # Achète une upgrade globale
    PurchaseGlobalUpgrade(Index : int) : logic =
        if (Index >= 0):
            if (Index < GlobalUpgrades.Length):
                if (IsPurchased := GlobalUpgradesPurchased[Index]):
                    if (IsPurchased = false):
                        if (set GlobalUpgradesPurchased[Index] = true) {}
                        return true
        false

    # Vérifie si une upgrade globale est déjà achetée
    IsGlobalUpgradePurchased(Index : int) : logic =
        if (IsPurchased := GlobalUpgradesPurchased[Index]):
            return IsPurchased
        return false

    # Obtient le coût d'une upgrade globale
    GetGlobalUpgradeCost(Index : int) : float =
        if (Upgrade := GlobalUpgrades[Index]):
            return Upgrade.Cost
        return -1.0

    # Obtient le nom d'une upgrade globale
    GetGlobalUpgradeName(Index : int) : string =
        if (Upgrade := GlobalUpgrades[Index]):
            Upgrade.Name
        else:
            "Inconnu"

    # Obtient le multiplicateur d'une upgrade globale
    GetGlobalUpgradeMultiplier(Index : int) : float =
        if (Upgrade := GlobalUpgrades[Index]):
            return Upgrade.Multiplier
        return 1.0

    # =====================================================
    # FONCTIONS - UPGRADES SPÉCIFIQUES DE GÉNÉRATEURS
    # =====================================================

    # Achète une upgrade spécifique de générateur
    PurchaseGeneratorUpgrade(Index : int)<transacts> : logic =
        if (Index >= 0):
            if (Index < GeneratorSpecificUpgrades.Length):
                if (IsPurchased := GeneratorUpgradesPurchased[Index]):
                    if (IsPurchased = false):
                        if (set GeneratorUpgradesPurchased[Index] = true) {}
                        return true
        return false

    # Vérifie si une upgrade de générateur est achetée
    IsGeneratorUpgradePurchased(Index : int) : logic =
        if (IsPurchased := GeneratorUpgradesPurchased[Index]):
            return IsPurchased
        return false

    # Obtient le coût d'une upgrade de générateur
    GetGeneratorUpgradeCost(Index : int) : float =
        if (Upgrade := GeneratorSpecificUpgrades[Index]):
            return Upgrade.Cost
        return -1.0

    # =====================================================
    # FONCTIONS - RESET (PRESTIGE)
    # =====================================================

    # Reset tout (prestige)
    ResetAll() : void =
        set GlobalUpgradesPurchased = array{
            false, false, false, false, false, false, false, false, false, false,
            false, false, false, false, false, false, false, false, false, false,
            false, false, false, false, false, false, false, false, false, false,
            false, false, false, false, false, false, false, false, false, false,
            false, false, false, false, false, false, false, false, false, false
        }
        set GeneratorUpgradesPurchased = array{
            false, false, false, false, false, false, false, false, false, false
        }

    # Obtient le multiplicateur (simple)
    GetGlobalMultiplier() : float =
        var Total : float = 1.0
        MaxIndex := GlobalUpgrades.Length - 1
        for (Index := 0..MaxIndex):
            if (IsPurchased := GlobalUpgradesPurchased[Index]):
                if (IsPurchased = true):
                    if (Upgrade := GlobalUpgrades[Index]):
                        set Total = Total * Upgrade.Multiplier
        Total

    # =====================================================
    # FONCTIONS - UTILITAIRES
    # =====================================================

    # Obtient le nombre total d'upgrades globales
    GetGlobalUpgradeCount() : int =
        return GlobalUpgrades.Length

    # Obtient le nombre total d'upgrades de générateurs
    GetGeneratorUpgradeCount() : int =
        return GeneratorSpecificUpgrades.Length

    # Obtient le nombre total d'upgrades de clic
    GetClickUpgradeCount() : int =
        return ClickUpgrades.Length

    # Obtient le tableau des upgrades globales achetées (pour la persistance)
    GetGlobalUpgradesPurchasedArray<public>() : []logic =
        return GlobalUpgradesPurchased

    # Restaure les upgrades globales achetées (depuis la persistance)
    RestoreGlobalUpgradesPurchased<public>(PurchasedArray : []logic) : void =
        set GlobalUpgradesPurchased = PurchasedArray
