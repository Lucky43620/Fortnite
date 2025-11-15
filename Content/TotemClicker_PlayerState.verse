# =========================================================================
# TotemClicker_PlayerState.verse
# =========================================================================
# Rôle : Gestion de l'état et des données de chaque joueur
# Contient toutes les statistiques, niveaux, ressources d'un joueur
# =========================================================================

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Structure représentant l'état complet d'un joueur
player_state := class:
    # Ressources principales
    var Souls : int = 0
    var SoulsPerClick : float = 1.0
    var SoulsPerSecond : float = 0.0
    var SoulsFractionalAccumulator : float = 0.0  # Accumule les fractions pour la production

    # Générateurs
    var GeneratorLevels : []int = array{}
    var GeneratorCosts : []float = array{}

    # Upgrades
    var ClickUpgradeLevel : int = 0
    var GlobalMultiplier : float = 1.0

    # Prestige
    var PrestigeFragments : int = 0
    var PrestigeMultiplier : float = 0.0
    var TotalSoulsEarned : int = 0  # Pour calculer les fragments

    # Référence au joueur
    var Player : player

    # Constructeur
    Init(InPlayer : player) : void =
        set Player = InPlayer
        InitializeGenerators()

    # Initialise les tableaux de générateurs
    InitializeGenerators() : void =
        # 20 générateurs au total (indices 0-19)
        set GeneratorLevels = array{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
        set GeneratorCosts = array{
            15.0,                       # 0: Esprit Mineur
            100.0,                      # 1: Totem Secondaire
            1100.0,                     # 2: Gardien Ancien
            12000.0,                    # 3: Forge Spirituelle
            130000.0,                   # 4: Monolithe Obscur
            1400000.0,                  # 5: Temple Perdu
            20000000.0,                 # 6: Avatar Totémique
            330000000.0,                # 7: Portail des Ombres
            5100000000.0,               # 8: Citadelle Éternelle
            75000000000.0,              # 9: Nexus Cosmique
            1000000000000.0,            # 10: Dimension Sacrée
            14000000000000.0,           # 11: Trou Noir Ancestral
            170000000000000.0,          # 12: Multivers Totémique
            2100000000000000.0,         # 13: Paradoxe Temporel
            26000000000000000.0,        # 14: Singularité Divine
            310000000000000000.0,       # 15: Portail Quantique
            7100000000000000000.0,      # 16: Matrice Cosmique
            12000000000000000000.0,     # 17: Conscience Primordiale
            1900000000000000000000.0,   # 18: Infini Fractal
            330000000000000000000.0     # 19: Absolu Éternel
        }

    # Ajoute des âmes et met à jour le total cumulé
    AddSouls(Amount : int) : void =
        set Souls += Amount
        set TotalSoulsEarned += Amount
        if (Souls < 0):
            set Souls = 0

    # Dépense des âmes si possible
    SpendSouls(Cost : int) : logic =
        if (Souls >= Cost):
            set Souls -= Cost
            return true
        return false

    # Vérifie si le joueur peut se permettre un coût
    CanAfford(Cost : float) : logic =
        if (Souls >= Floor[Cost]):
            return true
        return false

    # Recalcule la production par seconde totale
    RecalculateProduction(BaseProductions : []float, GeneratorMultipliers : []float) : void =
        var Total : float = 0.0

        # 20 générateurs (indices 0-19), donc on utilise 0..20 (20 exclusif)
        for (Index := 0..20):
            if (Level := GeneratorLevels[Index]):
                if (BaseProduction := BaseProductions[Index]):
                    if (Multiplier := GeneratorMultipliers[Index]):
                        FloatLevel := Level * 1.0
                        set Total += BaseProduction * FloatLevel * Multiplier * GlobalMultiplier

        set SoulsPerSecond = Total
        Print("Production recalculated: {Total} souls/sec")

    # Reset la progression (prestige) mais garde les fragments
    ResetProgress() : void =
        # Reset ressources
        set Souls = 0
        set TotalSoulsEarned = 0
        set SoulsPerClick = 1.0
        set SoulsPerSecond = 0.0
        set SoulsFractionalAccumulator = 0.0

        # Reset générateurs (20 générateurs)
        set GeneratorLevels = array{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
        set GeneratorCosts = array{
            15.0, 100.0, 1100.0, 12000.0, 130000.0, 1400000.0, 20000000.0,
            330000000.0, 5100000000.0, 75000000000.0, 1000000000000.0,
            14000000000000.0, 170000000000000.0, 2100000000000000.0, 26000000000000000.0,
            310000000000000000.0, 7100000000000000000.0, 12000000000000000000.0,
            1900000000000000000000.0, 330000000000000000000.0
        }

        # Reset upgrades
        set ClickUpgradeLevel = 0
        set GlobalMultiplier = 1.0

        # GARDE les fragments et le multiplicateur de prestige
        # set PrestigeFragments = PrestigeFragments  (déjà fait)
        # set PrestigeMultiplier = PrestigeMultiplier  (déjà fait)

    # Applique le bonus de prestige
    ApplyPrestigeBonus() : void =
        set PrestigeMultiplier = PrestigeFragments * 0.05

    # Obtient le multiplicateur total de production
    GetTotalProductionMultiplier() : float =
        return (1.0 + PrestigeMultiplier)
