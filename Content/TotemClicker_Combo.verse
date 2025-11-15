# =========================================================================
# TotemClicker_Combo.verse
# =========================================================================
# Rôle : Système de combo pour récompenser les clics rapides
# Plus le joueur clique rapidement, plus le multiplicateur augmente
# =========================================================================

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# État du combo d'un joueur
player_combo := class:
    var ComboCount : int = 0
    var ComboMultiplier : float = 1.0
    var LastClickTime : float = 0.0

    # Ajoute un clic au combo
    AddClick<public>(CurrentTime : float) : float =
        TimeDiff := CurrentTime - LastClickTime

        # Si moins de 0.5 secondes depuis le dernier clic, continue le combo
        if (TimeDiff < 0.5):
            set ComboCount += 1

            # Calcule le multiplicateur (max x2.5) - RÉDUIT POUR ÉQUILIBRAGE
            # Formule : 1 + (ComboCount * 0.05), max 2.5
            NewMultiplier := 1.0 + (ComboCount * 0.05)
            if (NewMultiplier > 2.5):
                set ComboMultiplier = 2.5
            else:
                set ComboMultiplier = NewMultiplier

        else if (TimeDiff >= 2.0):
            # Reset le combo si trop de temps s'est écoulé
            set ComboCount = 0
            set ComboMultiplier = 1.0

        set LastClickTime = CurrentTime

        return ComboMultiplier

    # Met à jour le temps (appelé chaque frame/seconde)
    Update<public>(CurrentTime : float) : void =
        TimeDiff := CurrentTime - LastClickTime

        # Reset le combo si plus de 2 secondes sans clic
        if (TimeDiff >= 2.0):
            if (ComboCount > 0):
                set ComboCount = 0
                set ComboMultiplier = 1.0
                Print("Combo reset pour le joueur")

    # Obtient le multiplicateur actuel
    GetMultiplier<public>() : float =
        return ComboMultiplier

    # Obtient le compteur de combo
    GetComboCount<public>() : int =
        return ComboCount

    # Reset le combo (utilisé pour prestige)
    Reset<public>() : void =
        set ComboCount = 0
        set ComboMultiplier = 1.0
        set LastClickTime = 0.0

# Gestionnaire des combos
totem_combo_manager := class():

    # Map des combos par joueur
    var PlayerCombos : [player]player_combo = map{}

    # Temps de jeu global (pour tracking)
    var GlobalTime : float = 0.0

    # Initialise le système de combos
    Initialize<public>() : void =
        Print("Combo system initialized")

    # Initialise un joueur
    InitializePlayer<public>(Player : player) : void =
        if (PlayerCombos[Player]):
            Print("Player combo already initialized")
        else:
            NewCombo := player_combo{}
            if (set PlayerCombos[Player] = NewCombo) {}
            Print("Player combo initialized")

    # Enregistre un clic et obtient le multiplicateur
    RecordClick<public>(Player : player) : float =
        if (Combo := PlayerCombos[Player]):
            Multiplier := Combo.AddClick(GlobalTime)

            # Affiche le combo si > 1
            if (Combo.ComboCount > 0):
                ComboCount := Combo.ComboCount
                if (MultInt := Floor[Multiplier * 10.0]):
                    MultDisplay := MultInt * 1.0 / 10.0
                    Print("COMBO x{ComboCount}! Multiplicateur: x{MultDisplay}")

            return Multiplier

        return 1.0

    # Met à jour les combos (appelé chaque seconde)
    UpdateCombos<public>(DeltaTime : float) : void =
        set GlobalTime += DeltaTime

        # Met à jour tous les combos actifs (pas de boucle sur map)
        # Les combos se reset automatiquement quand nécessaire

    # Reset le combo d'un joueur (pour prestige)
    ResetPlayerCombo<public>(Player : player) : void =
        if (Combo := PlayerCombos[Player]):
            Combo.Reset()

    # Obtient le multiplicateur actuel d'un joueur
    GetPlayerMultiplier<public>(Player : player) : float =
        if (Combo := PlayerCombos[Player]):
            return Combo.GetMultiplier()
        return 1.0

    # Obtient le compteur de combo d'un joueur
    GetPlayerComboCount<public>(Player : player) : int =
        if (Combo := PlayerCombos[Player]):
            return Combo.GetComboCount()
        return 0

    # Génère le texte d'affichage du combo
    GenerateComboText<public>(Player : player) : string =
        if (Combo := PlayerCombos[Player]):
            if (Combo.ComboCount > 0):
                if (MultInt := Floor[Combo.ComboMultiplier * 10.0]):
                    MultDisplay := MultInt * 1.0 / 10.0
                    return "COMBO x{Combo.ComboCount}\nMultiplicateur: x{MultDisplay}"

        return "Cliquez rapidement\npour faire un combo!"

# =========================================================================
# NOTES D'UTILISATION
# =========================================================================
#
# Ce système récompense les clics rapides :
# - Cliquer dans les 0.5 secondes augmente le combo
# - Le combo donne un multiplicateur (max x5.0)
# - Formule : 1 + (ComboCount * 0.1)
# - Le combo se reset après 2 secondes sans clic
#
# Exemples :
# - 10 clics rapides = x2.0
# - 20 clics rapides = x3.0
# - 40+ clics rapides = x5.0 (maximum)
#
# Pour afficher dans UEFN :
# 1. Créez un billboard_device pour afficher le combo actuel
# 2. Le système se met à jour automatiquement
#
# =========================================================================
