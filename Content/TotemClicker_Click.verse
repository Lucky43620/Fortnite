# =========================================================================
# TotemClicker_Click.verse
# =========================================================================
# Rôle : Gestion du clic sur le totem
# Traite l'interaction du joueur avec le totem principal
# =========================================================================

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Gestionnaire des clics sur le totem
totem_click_handler := class:

    # Calcule le gain d'âmes pour un clic
    CalculateClickGain(SoulsPerClick : float, PrestigeMultiplier : float) : int =
        # Formule : soulsPerClick * (1.0 + prestigeMultiplier)
        TotalMultiplier := 1.0 + PrestigeMultiplier
        Gain := SoulsPerClick * TotalMultiplier

        # Arrondi au nombre entier le plus proche
        if (FloorGain := Floor[Gain]):
            return FloorGain

        return 1  # Au minimum 1 âme par clic

    # Traite un clic sur le totem
    # Retourne le nombre d'âmes gagnées
    ProcessClick(SoulsPerClick : float, PrestigeMultiplier : float) : int =
        Gain := CalculateClickGain(SoulsPerClick, PrestigeMultiplier)
        return Gain

    # Calcule le gain par clic avec tous les bonus
    GetEffectiveClickPower(BaseClickPower : float, PrestigeMultiplier : float) : float =
        TotalMultiplier := 1.0 + PrestigeMultiplier
        return BaseClickPower * TotalMultiplier

    # Formate le gain de clic pour l'affichage
    FormatClickGain(Gain : int) : string =
        if (Gain < 1000):
            return "+{Gain}"
        else if (Gain < 1000000):
            FloatGain := Gain * 1.0
            Thousands := FloatGain / 1000.0
            if (FloorValue := Floor[Thousands * 10.0]):
                FloatFloor := FloorValue * 1.0
                Rounded := FloatFloor / 10.0
                return "+{Rounded}K"
            return "+{Gain}"
        else:
            FloatGain := Gain * 1.0
            Millions := FloatGain / 1000000.0
            if (FloorValue := Floor[Millions * 10.0]):
                FloatFloor := FloorValue * 1.0
                Rounded := FloatFloor / 10.0
                return "+{Rounded}M"
            return "+{Gain}"
