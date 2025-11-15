# =========================================================================
# TotemClicker_Persistence.verse
# =========================================================================
# Rôle : Système de persistance utilisant l'API UEFN Persistence
# Sauvegarde automatique des données des joueurs entre les sessions
# =========================================================================

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Structure persistable pour sauvegarder les données d'un joueur
# La directive <persistable> permet à UEFN de sauvegarder automatiquement ces données
totem_player_data := class<final><persistable>:
    # Ressources principales
    Souls : int = 0
    SoulsPerClick : float = 1.0
    SoulsPerSecond : float = 0.0
    SoulsFractionalAccumulator : float = 0.0

    # Générateurs (20 générateurs)
    GeneratorLevels : []int = array{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

    # Upgrades
    ClickUpgradeLevel : int = 0
    GlobalMultiplier : float = 1.0
    GlobalUpgradesPurchased : []logic = array{
        false, false, false, false, false, false, false, false, false, false,
        false, false, false, false, false, false, false, false, false, false,
        false, false, false, false, false, false, false, false, false, false,
        false, false, false, false, false, false, false, false, false, false,
        false, false, false, false, false, false, false, false, false, false
    }

    # Prestige
    PrestigeFragments : int = 0
    PrestigeMultiplier : float = 0.0
    TotalSoulsEarned : int = 0

# Map faible pour stocker les données persistables des joueurs
var TotemPlayerDataMap : weak_map(player, totem_player_data) = map{}

# Constructeur pour créer une copie des données d'un joueur (sans appel récursif)
MakeTotemPlayerData<constructor>(OldData : totem_player_data)<transacts> := totem_player_data:
    Souls := OldData.Souls
    SoulsPerClick := OldData.SoulsPerClick
    SoulsPerSecond := OldData.SoulsPerSecond
    SoulsFractionalAccumulator := OldData.SoulsFractionalAccumulator
    GeneratorLevels := OldData.GeneratorLevels
    ClickUpgradeLevel := OldData.ClickUpgradeLevel
    GlobalMultiplier := OldData.GlobalMultiplier
    GlobalUpgradesPurchased := OldData.GlobalUpgradesPurchased
    PrestigeFragments := OldData.PrestigeFragments
    PrestigeMultiplier := OldData.PrestigeMultiplier
    TotalSoulsEarned := OldData.TotalSoulsEarned

# Gestionnaire de persistance pour TotemClicker
totem_persistence_manager := class():

    # Initialise un joueur dans le système de persistance
    InitializePlayer<public>(Player : player) : void =
        if:
            Player.IsActive[]
            not TotemPlayerDataMap[Player]
            set TotemPlayerDataMap[Player] = totem_player_data{}
            Print("Persistence: Player initialized with default data")

    # Récupère les données persistables d'un joueur
    GetPlayerData<public>(Player : player) : totem_player_data =
        var NewPlayerData : totem_player_data = totem_player_data{}
        if:
            PlayerData := TotemPlayerDataMap[Player]
            set NewPlayerData = PlayerData
        return NewPlayerData

    # Met à jour les âmes du joueur
    UpdateSouls<public>(Player : player, Amount : int)<transacts> : void =
        if:
            Player.IsActive[]
            PlayerData := TotemPlayerDataMap[Player]
            set TotemPlayerDataMap[Player] = totem_player_data:
                Souls := Amount
                SoulsPerClick := PlayerData.SoulsPerClick
                SoulsPerSecond := PlayerData.SoulsPerSecond
                SoulsFractionalAccumulator := PlayerData.SoulsFractionalAccumulator
                GeneratorLevels := PlayerData.GeneratorLevels
                ClickUpgradeLevel := PlayerData.ClickUpgradeLevel
                GlobalMultiplier := PlayerData.GlobalMultiplier
                GlobalUpgradesPurchased := PlayerData.GlobalUpgradesPurchased
                PrestigeFragments := PlayerData.PrestigeFragments
                PrestigeMultiplier := PlayerData.PrestigeMultiplier
                TotalSoulsEarned := PlayerData.TotalSoulsEarned

    # Met à jour les âmes par clic
    UpdateSoulsPerClick<public>(Player : player, Amount : float)<transacts> : void =
        if:
            Player.IsActive[]
            PlayerData := TotemPlayerDataMap[Player]
            set TotemPlayerDataMap[Player] = totem_player_data:
                Souls := PlayerData.Souls
                SoulsPerClick := Amount
                SoulsPerSecond := PlayerData.SoulsPerSecond
                SoulsFractionalAccumulator := PlayerData.SoulsFractionalAccumulator
                GeneratorLevels := PlayerData.GeneratorLevels
                ClickUpgradeLevel := PlayerData.ClickUpgradeLevel
                GlobalMultiplier := PlayerData.GlobalMultiplier
                GlobalUpgradesPurchased := PlayerData.GlobalUpgradesPurchased
                PrestigeFragments := PlayerData.PrestigeFragments
                PrestigeMultiplier := PlayerData.PrestigeMultiplier
                TotalSoulsEarned := PlayerData.TotalSoulsEarned

    # Met à jour les âmes par seconde
    UpdateSoulsPerSecond<public>(Player : player, Amount : float)<transacts> : void =
        if:
            Player.IsActive[]
            PlayerData := TotemPlayerDataMap[Player]
            set TotemPlayerDataMap[Player] = totem_player_data:
                Souls := PlayerData.Souls
                SoulsPerClick := PlayerData.SoulsPerClick
                SoulsPerSecond := Amount
                SoulsFractionalAccumulator := PlayerData.SoulsFractionalAccumulator
                GeneratorLevels := PlayerData.GeneratorLevels
                ClickUpgradeLevel := PlayerData.ClickUpgradeLevel
                GlobalMultiplier := PlayerData.GlobalMultiplier
                GlobalUpgradesPurchased := PlayerData.GlobalUpgradesPurchased
                PrestigeFragments := PlayerData.PrestigeFragments
                PrestigeMultiplier := PlayerData.PrestigeMultiplier
                TotalSoulsEarned := PlayerData.TotalSoulsEarned

    # Met à jour l'accumulateur de fractions
    UpdateFractionalAccumulator<public>(Player : player, Amount : float)<transacts> : void =
        if:
            Player.IsActive[]
            PlayerData := TotemPlayerDataMap[Player]
            set TotemPlayerDataMap[Player] = totem_player_data:
                Souls := PlayerData.Souls
                SoulsPerClick := PlayerData.SoulsPerClick
                SoulsPerSecond := PlayerData.SoulsPerSecond
                SoulsFractionalAccumulator := Amount
                GeneratorLevels := PlayerData.GeneratorLevels
                ClickUpgradeLevel := PlayerData.ClickUpgradeLevel
                GlobalMultiplier := PlayerData.GlobalMultiplier
                GlobalUpgradesPurchased := PlayerData.GlobalUpgradesPurchased
                PrestigeFragments := PlayerData.PrestigeFragments
                PrestigeMultiplier := PlayerData.PrestigeMultiplier
                TotalSoulsEarned := PlayerData.TotalSoulsEarned

    # Met à jour les niveaux des générateurs
    UpdateGeneratorLevels<public>(Player : player, Levels : []int)<transacts> : void =
        if:
            Player.IsActive[]
            PlayerData := TotemPlayerDataMap[Player]
            set TotemPlayerDataMap[Player] = totem_player_data:
                Souls := PlayerData.Souls
                SoulsPerClick := PlayerData.SoulsPerClick
                SoulsPerSecond := PlayerData.SoulsPerSecond
                SoulsFractionalAccumulator := PlayerData.SoulsFractionalAccumulator
                GeneratorLevels := Levels
                ClickUpgradeLevel := PlayerData.ClickUpgradeLevel
                GlobalMultiplier := PlayerData.GlobalMultiplier
                GlobalUpgradesPurchased := PlayerData.GlobalUpgradesPurchased
                PrestigeFragments := PlayerData.PrestigeFragments
                PrestigeMultiplier := PlayerData.PrestigeMultiplier
                TotalSoulsEarned := PlayerData.TotalSoulsEarned

    # Met à jour le niveau d'upgrade de clic
    UpdateClickUpgradeLevel<public>(Player : player, Level : int)<transacts> : void =
        if:
            Player.IsActive[]
            PlayerData := TotemPlayerDataMap[Player]
            set TotemPlayerDataMap[Player] = totem_player_data:
                Souls := PlayerData.Souls
                SoulsPerClick := PlayerData.SoulsPerClick
                SoulsPerSecond := PlayerData.SoulsPerSecond
                SoulsFractionalAccumulator := PlayerData.SoulsFractionalAccumulator
                GeneratorLevels := PlayerData.GeneratorLevels
                ClickUpgradeLevel := Level
                GlobalMultiplier := PlayerData.GlobalMultiplier
                GlobalUpgradesPurchased := PlayerData.GlobalUpgradesPurchased
                PrestigeFragments := PlayerData.PrestigeFragments
                PrestigeMultiplier := PlayerData.PrestigeMultiplier
                TotalSoulsEarned := PlayerData.TotalSoulsEarned

    # Met à jour le multiplicateur global
    UpdateGlobalMultiplier<public>(Player : player, Multiplier : float)<transacts> : void =
        if:
            Player.IsActive[]
            PlayerData := TotemPlayerDataMap[Player]
            set TotemPlayerDataMap[Player] = totem_player_data:
                Souls := PlayerData.Souls
                SoulsPerClick := PlayerData.SoulsPerClick
                SoulsPerSecond := PlayerData.SoulsPerSecond
                SoulsFractionalAccumulator := PlayerData.SoulsFractionalAccumulator
                GeneratorLevels := PlayerData.GeneratorLevels
                ClickUpgradeLevel := PlayerData.ClickUpgradeLevel
                GlobalMultiplier := Multiplier
                GlobalUpgradesPurchased := PlayerData.GlobalUpgradesPurchased
                PrestigeFragments := PlayerData.PrestigeFragments
                PrestigeMultiplier := PlayerData.PrestigeMultiplier
                TotalSoulsEarned := PlayerData.TotalSoulsEarned

    # Met à jour les upgrades globales achetées
    UpdateGlobalUpgradesPurchased<public>(Player : player, Purchased : []logic)<transacts> : void =
        if:
            Player.IsActive[]
            PlayerData := TotemPlayerDataMap[Player]
            set TotemPlayerDataMap[Player] = totem_player_data:
                Souls := PlayerData.Souls
                SoulsPerClick := PlayerData.SoulsPerClick
                SoulsPerSecond := PlayerData.SoulsPerSecond
                SoulsFractionalAccumulator := PlayerData.SoulsFractionalAccumulator
                GeneratorLevels := PlayerData.GeneratorLevels
                ClickUpgradeLevel := PlayerData.ClickUpgradeLevel
                GlobalMultiplier := PlayerData.GlobalMultiplier
                GlobalUpgradesPurchased := Purchased
                PrestigeFragments := PlayerData.PrestigeFragments
                PrestigeMultiplier := PlayerData.PrestigeMultiplier
                TotalSoulsEarned := PlayerData.TotalSoulsEarned

    # Met à jour les fragments de prestige
    UpdatePrestigeFragments<public>(Player : player, Fragments : int)<transacts> : void =
        if:
            Player.IsActive[]
            PlayerData := TotemPlayerDataMap[Player]
            set TotemPlayerDataMap[Player] = totem_player_data:
                Souls := PlayerData.Souls
                SoulsPerClick := PlayerData.SoulsPerClick
                SoulsPerSecond := PlayerData.SoulsPerSecond
                SoulsFractionalAccumulator := PlayerData.SoulsFractionalAccumulator
                GeneratorLevels := PlayerData.GeneratorLevels
                ClickUpgradeLevel := PlayerData.ClickUpgradeLevel
                GlobalMultiplier := PlayerData.GlobalMultiplier
                GlobalUpgradesPurchased := PlayerData.GlobalUpgradesPurchased
                PrestigeFragments := Fragments
                PrestigeMultiplier := PlayerData.PrestigeMultiplier
                TotalSoulsEarned := PlayerData.TotalSoulsEarned

    # Met à jour le multiplicateur de prestige
    UpdatePrestigeMultiplier<public>(Player : player, Multiplier : float)<transacts> : void =
        if:
            Player.IsActive[]
            PlayerData := TotemPlayerDataMap[Player]
            set TotemPlayerDataMap[Player] = totem_player_data:
                Souls := PlayerData.Souls
                SoulsPerClick := PlayerData.SoulsPerClick
                SoulsPerSecond := PlayerData.SoulsPerSecond
                SoulsFractionalAccumulator := PlayerData.SoulsFractionalAccumulator
                GeneratorLevels := PlayerData.GeneratorLevels
                ClickUpgradeLevel := PlayerData.ClickUpgradeLevel
                GlobalMultiplier := PlayerData.GlobalMultiplier
                GlobalUpgradesPurchased := PlayerData.GlobalUpgradesPurchased
                PrestigeFragments := PlayerData.PrestigeFragments
                PrestigeMultiplier := Multiplier
                TotalSoulsEarned := PlayerData.TotalSoulsEarned

    # Met à jour le total d'âmes gagnées
    UpdateTotalSoulsEarned<public>(Player : player, Total : int)<transacts> : void =
        if:
            Player.IsActive[]
            PlayerData := TotemPlayerDataMap[Player]
            set TotemPlayerDataMap[Player] = totem_player_data:
                Souls := PlayerData.Souls
                SoulsPerClick := PlayerData.SoulsPerClick
                SoulsPerSecond := PlayerData.SoulsPerSecond
                SoulsFractionalAccumulator := PlayerData.SoulsFractionalAccumulator
                GeneratorLevels := PlayerData.GeneratorLevels
                ClickUpgradeLevel := PlayerData.ClickUpgradeLevel
                GlobalMultiplier := PlayerData.GlobalMultiplier
                GlobalUpgradesPurchased := PlayerData.GlobalUpgradesPurchased
                PrestigeFragments := PlayerData.PrestigeFragments
                PrestigeMultiplier := PlayerData.PrestigeMultiplier
                TotalSoulsEarned := Total

    # Sauvegarde complète de toutes les données d'un joueur
    SaveAllPlayerData<public>(Player : player, State : player_state)<transacts> : void =
        if:
            Player.IsActive[]
            PlayerData := TotemPlayerDataMap[Player]
            set TotemPlayerDataMap[Player] = totem_player_data:
                Souls := State.Souls
                SoulsPerClick := State.SoulsPerClick
                SoulsPerSecond := State.SoulsPerSecond
                SoulsFractionalAccumulator := State.SoulsFractionalAccumulator
                GeneratorLevels := State.GeneratorLevels
                ClickUpgradeLevel := State.ClickUpgradeLevel
                GlobalMultiplier := State.GlobalMultiplier
                GlobalUpgradesPurchased := PlayerData.GlobalUpgradesPurchased
                PrestigeFragments := State.PrestigeFragments
                PrestigeMultiplier := State.PrestigeMultiplier
                TotalSoulsEarned := State.TotalSoulsEarned

# =========================================================================
# NOTES D'UTILISATION
# =========================================================================
#
# Ce système utilise l'API UEFN Persistence pour sauvegarder automatiquement
# les données des joueurs entre les sessions de jeu.
#
# Fonctionnement :
# 1. La classe totem_player_data est marquée <persistable>
# 2. UEFN sauvegarde automatiquement le weak_map TotemPlayerDataMap
# 3. Quand un joueur rejoint, ses données sont chargées automatiquement
# 4. Quand des données changent, utilisez les fonctions Update pour sauvegarder
#
# Important :
# - Toutes les fonctions Update sont <transacts> (créent une nouvelle transaction)
# - Le weak_map est automatiquement sauvegardé par UEFN
# - Pas besoin de bouton "Save" manuel - tout est automatique!
#
# =========================================================================
