# =========================================================================
# TotemClicker_Prestige.verse
# =========================================================================
# Rôle : Gestion du système de prestige
# Calcul des fragments, reset de progression, bonus permanents
# =========================================================================

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Gestionnaire du prestige
totem_prestige := class:

    # Constantes du prestige
    PrestigeUnlockThreshold : int = 50000000  # 50 millions de souls pour débloquer
    FragmentBonusPerFragment : float = 0.05   # 5% de bonus par fragment

    # Vérifie si le prestige est disponible
    CanPrestige(TotalSouls : int) : logic =
        if (TotalSouls >= PrestigeUnlockThreshold):
            return true
        return false

    # Calcule le nombre de fragments gagnés
    # Formule : floor(log10(souls / 1000000))
    CalculateFragmentsGained(TotalSouls : int) : int =
        if (TotalSouls < 1000000):
            return 0

        # Conversion en float pour le calcul
        FloatSouls := TotalSouls * 1.0
        Ratio := FloatSouls / 1000000.0

        # Calcul approximatif de log10
        LogValue := ApproximateLog10(Ratio)

        if (LogValue > 0.0):
            if (FloorValue := Floor[LogValue]):
                return FloorValue

        return 0

    # Approximation du logarithme base 10
    ApproximateLog10(Value : float) : float =
        if (Value <= 0.0):
            return 0.0

        var Result : float = 0.0
        var X : float = Value

        # Normalisation pour X entre 1 et 10
        loop:
            if (X >= 10.0):
                set X = X / 10.0
                set Result += 1.0
            else if (X < 1.0):
                set X = X * 10.0
                set Result -= 1.0
            else:
                break

        # Approximation pour X entre 1 et 10
        Normalized := (X - 1.0) / X
        set Result += Normalized * 0.4342944819

        return Result

    # Calcule le bonus de production basé sur les fragments
    CalculatePrestigeBonus(Fragments : int) : float =
        FloatFragments := Fragments * 1.0
        return FloatFragments * FragmentBonusPerFragment

    # Obtient le multiplicateur total de prestige
    # Retourne 1.0 + bonus (ex: 3 fragments = 1.15)
    GetPrestigeMultiplier(Fragments : int) : float =
        Bonus := CalculatePrestigeBonus(Fragments)
        return 1.0 + Bonus

    # Estime les fragments pour un nombre d'âmes donné
    EstimateFragments(Souls : int) : int =
        return CalculateFragmentsGained(Souls)

    # Calcule le nombre d'âmes nécessaires pour le prochain fragment
    GetSoulsForNextFragment(CurrentFragments : int) : int =
        # Pour obtenir N fragments, il faut : souls = 1000000 * 10^N
        NextFragments := CurrentFragments + 1

        # Calcul de 10^NextFragments
        var Power10 : float = 1.0
        for (I := 1..NextFragments):
            set Power10 = Power10 * 10.0

        Result := Power10 * 1000000.0
        if (FloorResult := Floor[Result]):
            return FloorResult

        return 999999999

    # Obtient un texte descriptif du prestige
    GetPrestigeDescription(CurrentFragments : int) : string =
        if (CurrentFragments = 0):
            return "Aucun fragment. Le prestige donne +5% de production par fragment."
        else:
            Bonus := CalculatePrestigeBonus(CurrentFragments)
            BonusPercent := Bonus * 100.0
            if (FloorBonus := Floor[BonusPercent]):
                return "{CurrentFragments} fragments (+{FloorBonus}% production)"

        return "{CurrentFragments} fragments"
