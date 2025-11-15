# =========================================================================
# TotemClicker_Statistics.verse
# =========================================================================
# Rôle : Système de statistiques détaillées pour tracker la progression
# Affiche et sauvegarde toutes les stats des joueurs
# =========================================================================

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Structure pour stocker les statistiques d'un joueur
player_statistics := class:
    # Statistiques de clics
    var TotalClicks : int = 0
    var SoulsFromClicks : int = 0

    # Statistiques de production
    var SoulsFromProduction : int = 0
    var TotalPlayTime : float = 0.0  # En secondes

    # Statistiques de générateurs
    var TotalGeneratorsPurchased : int = 0
    var MostExpensiveGeneratorOwned : int = 0

    # Statistiques d'upgrades
    var TotalUpgradesPurchased : int = 0
    var ClickUpgradesPurchased : int = 0
    var GlobalUpgradesPurchased : int = 0

    # Statistiques de prestige
    var TotalPrestiges : int = 0
    var TotalFragmentsEarned : int = 0

    # Records personnels
    var HighestSoulsReached : int = 0
    var HighestProductionReached : float = 0.0
    var FastestMillionSeconds : float = 0.0  # Temps pour atteindre 1M (0 = jamais atteint)

    # Référence au joueur
    var Player : player

    # Initialise les statistiques
    Init(InPlayer : player) : void =
        set Player = InPlayer

    # Enregistre un clic
    RecordClick<public>(SoulsGained : int) : void =
        set TotalClicks += 1
        set SoulsFromClicks += SoulsGained

    # Enregistre la production
    RecordProduction<public>(SoulsGained : int) : void =
        set SoulsFromProduction += SoulsGained

    # Met à jour le temps de jeu
    UpdatePlayTime<public>(DeltaTime : float) : void =
        set TotalPlayTime += DeltaTime

    # Enregistre l'achat d'un générateur
    RecordGeneratorPurchase<public>(GeneratorIndex : int) : void =
        set TotalGeneratorsPurchased += 1

        if (GeneratorIndex > MostExpensiveGeneratorOwned):
            set MostExpensiveGeneratorOwned = GeneratorIndex

    # Enregistre l'achat d'un upgrade de clic
    RecordClickUpgrade<public>() : void =
        set TotalUpgradesPurchased += 1
        set ClickUpgradesPurchased += 1

    # Enregistre l'achat d'un upgrade global
    RecordGlobalUpgrade<public>() : void =
        set TotalUpgradesPurchased += 1
        set GlobalUpgradesPurchased += 1

    # Enregistre un prestige
    RecordPrestige<public>(FragmentsGained : int) : void =
        set TotalPrestiges += 1
        set TotalFragmentsEarned += FragmentsGained

    # Met à jour les records personnels
    UpdateRecords<public>(CurrentSouls : int, CurrentProduction : float, PlayTime : float) : void =
        # Record d'âmes
        if (CurrentSouls > HighestSoulsReached):
            set HighestSoulsReached = CurrentSouls

        # Record de production
        if (CurrentProduction > HighestProductionReached):
            set HighestProductionReached = CurrentProduction

        # Record du million le plus rapide
        if (CurrentSouls >= 1000000):
            if (FastestMillionSeconds = 0.0):
                # Première fois qu'on atteint 1M
                set FastestMillionSeconds = PlayTime
            else if (PlayTime < FastestMillionSeconds):
                # Nouveau record
                set FastestMillionSeconds = PlayTime

    # Reset les statistiques (pour prestige)
    ResetSessionStats<public>() : void =
        # Ne reset PAS les stats globales (TotalClicks, TotalPlayTime, etc.)
        # Juste le temps pour le nouveau run
        # Les autres stats sont cumulatives
        false

# Gestionnaire des statistiques
totem_statistics_manager := class():

    # Map des statistiques par joueur
    var PlayerStats : [player]player_statistics = map{}

    # Initialise un joueur
    InitializePlayer<public>(Player : player) : void =
        if (PlayerStats[Player]):
            Print("Player statistics already initialized")
        else:
            NewStats := player_statistics{Player := Player}
            NewStats.Init(Player)
            if (set PlayerStats[Player] = NewStats):
                Print("Player statistics initialized")

    # Restaure les statistiques depuis la sauvegarde
    RestorePlayerStats<public>(Player : player,
                                TotalClicks : int,
                                SoulsFromClicks : int,
                                SoulsFromProduction : int,
                                TotalPlayTime : float,
                                TotalGeneratorsPurchased : int,
                                MostExpensiveGeneratorOwned : int,
                                TotalUpgradesPurchased : int,
                                ClickUpgradesPurchased : int,
                                GlobalUpgradesPurchased : int,
                                TotalPrestiges : int,
                                TotalFragmentsEarned : int,
                                HighestSoulsReached : int,
                                HighestProductionReached : float,
                                FastestMillionSeconds : float) : void =
    {
        if (Stats := PlayerStats[Player]):
            set Stats.TotalClicks = TotalClicks
            set Stats.SoulsFromClicks = SoulsFromClicks
            set Stats.SoulsFromProduction = SoulsFromProduction
            set Stats.TotalPlayTime = TotalPlayTime
            set Stats.TotalGeneratorsPurchased = TotalGeneratorsPurchased
            set Stats.MostExpensiveGeneratorOwned = MostExpensiveGeneratorOwned
            set Stats.TotalUpgradesPurchased = TotalUpgradesPurchased
            set Stats.ClickUpgradesPurchased = ClickUpgradesPurchased
            set Stats.GlobalUpgradesPurchased = GlobalUpgradesPurchased
            set Stats.TotalPrestiges = TotalPrestiges
            set Stats.TotalFragmentsEarned = TotalFragmentsEarned
            set Stats.HighestSoulsReached = HighestSoulsReached
            set Stats.HighestProductionReached = HighestProductionReached
            set Stats.FastestMillionSeconds = FastestMillionSeconds
        else:
            Print("Player statistics not initialized, cannot restore")
    }

    # Obtient les stats d'un joueur
    GetPlayerStats<public>(Player : player) : ?player_statistics =
        if (Stats := PlayerStats[Player]):
            return option{Stats}
        return false

    # Génère le texte formaté des statistiques
    GenerateStatsText<public>(Player : player, UIManager : totem_ui_manager) : string =
        if (Stats := PlayerStats[Player]):
            var Text : string = "=== STATISTIQUES ===\n\n"

            # Temps de jeu
            if (Hours := Floor[Stats.TotalPlayTime / 3600.0]):
                HoursFloat := Hours * 3600.0
                if (Minutes := Floor[(Stats.TotalPlayTime - HoursFloat) / 60.0]):
                    set Text = "{Text}Temps de jeu: {Hours}h {Minutes}m\n\n"

            # Statistiques de clics
            set Text = "{Text}--- CLICS ---\n"
            set Text = "{Text}Total clics: {Stats.TotalClicks}\n"
            ClickSoulsText := UIManager.FormatInt(Stats.SoulsFromClicks)
            set Text = "{Text}Ames de clics: {ClickSoulsText}\n\n"

            # Statistiques de production
            set Text = "{Text}--- PRODUCTION ---\n"
            ProdSoulsText := UIManager.FormatInt(Stats.SoulsFromProduction)
            set Text = "{Text}Ames de production: {ProdSoulsText}\n"

            # Calcul du pourcentage clics vs production
            TotalSouls := Stats.SoulsFromClicks + Stats.SoulsFromProduction
            if (TotalSouls > 0):
                if (ClickPercent := Floor[(Stats.SoulsFromClicks * 100.0) / (TotalSouls * 1.0)]):
                    set Text = "{Text}Clics: {ClickPercent}% | Production: {100 - ClickPercent}%\n\n"

            # Statistiques de générateurs
            set Text = "{Text}--- GENERATEURS ---\n"
            set Text = "{Text}Total achetes: {Stats.TotalGeneratorsPurchased}\n"
            set Text = "{Text}Plus cher possede: Niveau {Stats.MostExpensiveGeneratorOwned}\n\n"

            # Statistiques d'upgrades
            set Text = "{Text}--- UPGRADES ---\n"
            set Text = "{Text}Total upgrades: {Stats.TotalUpgradesPurchased}\n"
            set Text = "{Text}Click upgrades: {Stats.ClickUpgradesPurchased}\n"
            set Text = "{Text}Global upgrades: {Stats.GlobalUpgradesPurchased}\n\n"

            # Statistiques de prestige
            set Text = "{Text}--- PRESTIGE ---\n"
            set Text = "{Text}Total prestiges: {Stats.TotalPrestiges}\n"
            set Text = "{Text}Fragments gagnes: {Stats.TotalFragmentsEarned}\n\n"

            # Records personnels
            set Text = "{Text}--- RECORDS ---\n"
            HighestSoulsText := UIManager.FormatInt(Stats.HighestSoulsReached)
            set Text = "{Text}Max ames: {HighestSoulsText}\n"
            HighestProdText := UIManager.FormatNumber(Stats.HighestProductionReached)
            set Text = "{Text}Max production: {HighestProdText}/s\n"

            if (Stats.FastestMillionSeconds > 0.0):
                if (FastMinutes := Floor[Stats.FastestMillionSeconds / 60.0]):
                    FastMinutesFloat := FastMinutes * 60.0
                    if (FastSeconds := Floor[Stats.FastestMillionSeconds - FastMinutesFloat]):
                        set Text = "{Text}1M le plus rapide: {FastMinutes}m {FastSeconds}s\n"

            return Text

        return "Aucune statistique disponible"

    # Boucle de mise à jour (appelée périodiquement)
    UpdateLoop<public>(Player : player, CurrentSouls : int, CurrentProduction : float, DeltaTime : float) : void =
        if (Stats := PlayerStats[Player]):
            Stats.UpdatePlayTime(DeltaTime)
            Stats.UpdateRecords(CurrentSouls, CurrentProduction, Stats.TotalPlayTime)

# =========================================================================
# NOTES D'UTILISATION
# =========================================================================
#
# Ce système track les statistiques suivantes :
# - Clics totaux et âmes de clics
# - Âmes de production
# - Temps de jeu total
# - Générateurs et upgrades achetés
# - Prestiges effectués
# - Records personnels
#
# Les statistiques sont cumulatives et persistent entre sessions
# Elles ne sont pas affectées par le prestige (sauf pour les records)
#
# =========================================================================
