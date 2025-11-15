# =========================================================================
# TotemClicker_Generators.verse
# =========================================================================
# Rôle : Gestion des générateurs automatiques (auto-clickers)
# Définit les générateurs, leurs coûts, leur production
# VERSION ÉTENDUE : 15 générateurs pour une progression longue
# =========================================================================

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Structure définissant un type de générateur
generator_data := struct:
    Name : string
    BaseProduction : float  # Âmes par seconde
    BaseCost : float        # Coût initial
    CostMultiplier : float = 1.15  # Multiplicateur de coût à chaque achat

# Gestionnaire des générateurs
totem_generators := class:

    # Constantes
    GeneratorCount : int = 20
    CostMultiplier : float = 1.15

    # Données des générateurs (index 0-14)
    # Progression inspirée de Cookie Clicker : chaque palier est ~100x plus cher
    var GeneratorData : []generator_data = array:
        # Tier 1 : Début du jeu
        generator_data{
            Name := "Esprit Mineur"
            BaseProduction := 0.1
            BaseCost := 15.0
        }
        generator_data{
            Name := "Totem Secondaire"
            BaseProduction := 1.0
            BaseCost := 100.0
        }
        generator_data{
            Name := "Gardien Ancien"
            BaseProduction := 8.0
            BaseCost := 1100.0
        }
        # Tier 2 : Milieu de partie
        generator_data{
            Name := "Forge Spirituelle"
            BaseProduction := 47.0
            BaseCost := 12000.0
        }
        generator_data{
            Name := "Monolithe Obscur"
            BaseProduction := 260.0
            BaseCost := 130000.0
        }
        generator_data{
            Name := "Temple Perdu"
            BaseProduction := 1400.0
            BaseCost := 1400000.0
        }
        generator_data{
            Name := "Avatar Totémique"
            BaseProduction := 7800.0
            BaseCost := 20000000.0
        }
        # Tier 3 : Fin de partie pré-prestige
        generator_data{
            Name := "Portail des Ombres"
            BaseProduction := 44000.0
            BaseCost := 330000000.0
        }
        generator_data{
            Name := "Citadelle Éternelle"
            BaseProduction := 260000.0
            BaseCost := 5100000000.0
        }
        generator_data{
            Name := "Nexus Cosmique"
            BaseProduction := 1600000.0
            BaseCost := 75000000000.0
        }
        # Tier 4 : Post-prestige
        generator_data{
            Name := "Dimension Sacrée"
            BaseProduction := 10000000.0
            BaseCost := 1000000000000.0
        }
        generator_data{
            Name := "Trou Noir Ancestral"
            BaseProduction := 65000000.0
            BaseCost := 14000000000000.0
        }
        generator_data{
            Name := "Multivers Totémique"
            BaseProduction := 430000000.0
            BaseCost := 170000000000000.0
        }
        # Tier 5 : End-game
        generator_data{
            Name := "Paradoxe Temporel"
            BaseProduction := 2900000000.0
            BaseCost := 2100000000000000.0
        }
        generator_data{
            Name := "Singularité Divine"
            BaseProduction := 21000000000.0
            BaseCost := 26000000000000000.0
        }
        # Tier 6 : Ultra end-game (5 nouveaux générateurs)
        generator_data{
            Name := "Portail Quantique"
            BaseProduction := 150000000000.0
            BaseCost := 310000000000000000.0
        }
        generator_data{
            Name := "Matrice Cosmique"
            BaseProduction := 1100000000000.0
            BaseCost := 7100000000000000000.0
        }
        generator_data{
            Name := "Conscience Primordiale"
            BaseProduction := 8300000000000.0
            BaseCost := 12000000000000000000.0
        }
        generator_data{
            Name := "Infini Fractal"
            BaseProduction := 64000000000000.0
            BaseCost := 1900000000000000000000.0
        }
        generator_data{
            Name := "Absolu Éternel"
            BaseProduction := 510000000000000.0
            BaseCost := 330000000000000000000.0
        }

    # Multiplicateurs par générateur (pour les upgrades spécifiques)
    var GeneratorMultipliers : []float = array{
        1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 1.0
    }

    # Obtient les données de base d'un générateur
    GetGeneratorData(Index : int) : generator_data =
        if (Data := GeneratorData[Index]):
            Data
        else:
            # Fallback en cas d'index invalide
            generator_data{
                Name := "Inconnu"
                BaseProduction := 0.0
                BaseCost := 999999999999.0
            }

    # Obtient le multiplicateur d'un générateur
    GetGeneratorMultiplier(Index : int) : float =
        if (Mult := GeneratorMultipliers[Index]):
            Mult
        else:
            1.0

    # Applique un multiplicateur à un générateur spécifique
    ApplyGeneratorMultiplier(Index : int, Multiplier : float)<transacts> : void =
        if (Index >= 0):
            if (Index < GeneratorCount):
                if (set GeneratorMultipliers[Index] = Multiplier) {}

    # Calcule le coût actuel d'un générateur pour un joueur
    CalculateCurrentCost(Index : int, CurrentLevel : int) : float =
        if (Data := GeneratorData[Index]):
            if (CurrentLevel <= 0):
                return Data.BaseCost

            # Calcul : BaseCost * (1.15 ^ CurrentLevel)
            var Cost : float = Data.BaseCost
            for (I := 1..CurrentLevel):
                set Cost = Cost * CostMultiplier

            return Cost
        return 999999999999.0

    # Calcule la production totale d'un générateur
    CalculateProduction(Index : int, Level : int, GlobalMultiplier : float) : float =
        if (Data := GeneratorData[Index]):
            if (Level <= 0):
                return 0.0

            if (GenMult := GeneratorMultipliers[Index]):
                FloatLevel := Level * 1.0
                return Data.BaseProduction * FloatLevel * GenMult * GlobalMultiplier

        return 0.0

    # Obtient les productions de base de tous les générateurs
    GetBaseProductions() : []float =
        var Productions : []float = array{}
        for (Data : GeneratorData):
            set Productions = Productions + array{Data.BaseProduction}
        return Productions

    # Obtient tous les multiplicateurs
    GetAllMultipliers() : []float =
        return GeneratorMultipliers

    # Reset tous les multiplicateurs (prestige)
    ResetMultipliers() : void =
        set GeneratorMultipliers = array{
            1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 1.0, 1.0
        }

    # Obtient le nom d'un générateur
    GetGeneratorName(Index : int) : string =
        if (Data := GeneratorData[Index]):
            Data.Name
        else:
            "Inconnu"

    # Obtient le coût de base d'un générateur
    GetBaseCost(Index : int) : float =
        if (Data := GeneratorData[Index]):
            return Data.BaseCost
        return 0.0

    # Obtient la production de base d'un générateur
    GetBaseProduction(Index : int) : float =
        if (Data := GeneratorData[Index]):
            return Data.BaseProduction
        return 0.0
