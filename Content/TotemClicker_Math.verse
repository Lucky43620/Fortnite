# =========================================================================
# TotemClicker_Math.verse
# =========================================================================
# Rôle : Fonctions utilitaires mathématiques
# Formatage des nombres, conversions, calculs divers
# VERSION ÉTENDUE : Support jusqu'aux Quintillions et au-delà
# =========================================================================

using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Classe utilitaire pour les fonctions mathématiques
totem_math := class:

    # Formate un nombre en notation K/M/B/T/Qa/Qi/Sx...
    # Support jusqu'aux très grands nombres (comme Cookie Clicker)
    FormatNumber(Value : float) : string =
        if (Value < 1000.0):
            # Moins de 1K : afficher normalement
            if (FloorValue := Floor[Value]):
                return "{FloorValue}"
            return "0"

        else if (Value < 1000000.0):
            # K (milliers / Thousands)
            Thousands := Value / 1000.0
            if (FloorValue := Floor[Thousands * 10.0]):
                FloatFloor := FloorValue * 1.0
                RoundedValue := FloatFloor / 10.0
                return "{RoundedValue}K"
            return "0K"

        else if (Value < 1000000000.0):
            # M (millions / Millions)
            Millions := Value / 1000000.0
            if (FloorValue := Floor[Millions * 10.0]):
                FloatFloor := FloorValue * 1.0
                RoundedValue := FloatFloor / 10.0
                return "{RoundedValue}M"
            return "0M"

        else if (Value < 1000000000000.0):
            # B (milliards / Billions)
            Billions := Value / 1000000000.0
            if (FloorValue := Floor[Billions * 10.0]):
                FloatFloor := FloorValue * 1.0
                RoundedValue := FloatFloor / 10.0
                return "{RoundedValue}B"
            return "0B"

        else if (Value < 1000000000000000.0):
            # T (trillions / Trillions)
            Trillions := Value / 1000000000000.0
            if (FloorValue := Floor[Trillions * 10.0]):
                FloatFloor := FloorValue * 1.0
                RoundedValue := FloatFloor / 10.0
                return "{RoundedValue}T"
            return "0T"

        else if (Value < 1000000000000000000.0):
            # Qa (quadrillions / Quadrillions)
            Quadrillions := Value / 1000000000000000.0
            if (FloorValue := Floor[Quadrillions * 10.0]):
                FloatFloor := FloorValue * 1.0
                RoundedValue := FloatFloor / 10.0
                return "{RoundedValue}Qa"
            return "0Qa"

        else if (Value < 1000000000000000000000.0):
            # Qi (quintillions / Quintillions)
            Quintillions := Value / 1000000000000000000.0
            if (FloorValue := Floor[Quintillions * 10.0]):
                FloatFloor := FloorValue * 1.0
                RoundedValue := FloatFloor / 10.0
                return "{RoundedValue}Qi"
            return "0Qi"

        else if (Value < 1000000000000000000000000.0):
            # Sx (sextillions / Sextillions)
            Sextillions := Value / 1000000000000000000000.0
            if (FloorValue := Floor[Sextillions * 10.0]):
                FloatFloor := FloorValue * 1.0
                RoundedValue := FloatFloor / 10.0
                return "{RoundedValue}Sx"
            return "0Sx"

        else if (Value < 1000000000000000000000000000.0):
            # Sp (septillions / Septillions)
            Septillions := Value / 1000000000000000000000000.0
            if (FloorValue := Floor[Septillions * 10.0]):
                FloatFloor := FloorValue * 1.0
                RoundedValue := FloatFloor / 10.0
                return "{RoundedValue}Sp"
            return "0Sp"

        else:
            # Oc (octillions / Octillions) et au-delà
            Octillions := Value / 1000000000000000000000000000.0
            if (FloorValue := Floor[Octillions * 10.0]):
                FloatFloor := FloorValue * 1.0
                RoundedValue := FloatFloor / 10.0
                return "{RoundedValue}Oc"
            return "0Oc"

    # Formate un nombre entier
    FormatInt(Value : int) : string =
        FloatValue := Value * 1.0
        FormatNumber(FloatValue)

    # Formate avec plus de précision (2 décimales)
    FormatNumberPrecise(Value : float) : string =
        if (Value < 1000.0):
            if (FloorValue := Floor[Value * 100.0]):
                FloatFloor := FloorValue * 1.0
                RoundedValue := FloatFloor / 100.0
                return "{RoundedValue}"
            return "0.00"

        else if (Value < 1000000.0):
            Thousands := Value / 1000.0
            if (FloorValue := Floor[Thousands * 100.0]):
                FloatFloor := FloorValue * 1.0
                RoundedValue := FloatFloor / 100.0
                return "{RoundedValue}K"
            return "0.00K"

        else if (Value < 1000000000.0):
            Millions := Value / 1000000.0
            if (FloorValue := Floor[Millions * 100.0]):
                FloatFloor := FloorValue * 1.0
                RoundedValue := FloatFloor / 100.0
                return "{RoundedValue}M"
            return "0.00M"

        else:
            # Pour les très grands nombres, utiliser la fonction normale
            return FormatNumber(Value)

    # Calcule le logarithme base 10 (approximation)
    # Utilisé pour le calcul des fragments de prestige
    Log10(Value : float) : float =
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

        # Approximation de log10(X) pour X entre 1 et 10
        # Utilisation d'une approximation polynomiale simple
        Normalized := (X - 1.0) / X
        set Result += Normalized * 0.4342944819  # ln(x) * log10(e)

        return Result

    # Calcule le nombre de fragments de prestige selon la formule
    # fragmentsEarned = floor(log10(souls / 1000000))
    CalculatePrestigeFragments(TotalSouls : int) : int =
        if (TotalSouls < 1000000):
            return 0

        FloatSouls := TotalSouls * 1.0
        Ratio := FloatSouls / 1000000.0
        LogValue := Log10(Ratio)

        if (LogValue > 0.0):
            if (FloorValue := Floor[LogValue]):
                return FloorValue

        return 0

    # Calcule le coût d'un générateur après N achats
    # newCost = baseCost * (multiplier ^ level)
    CalculateGeneratorCost(BaseCost : float, Level : int, Multiplier : float) : float =
        if (Level <= 0):
            return BaseCost

        # Calcul de BaseCost * Multiplier^Level
        var Result : float = BaseCost
        for (I := 1..Level):
            set Result = Result * Multiplier

        return Result

    # Arrondit à 1 décimale
    RoundToOneDecimal(Value : float) : float =
        Multiplied := Value * 10.0
        if (FloorValue := Floor[Multiplied]):
            FloatFloor := FloorValue * 1.0
            return FloatFloor / 10.0
        return Value

    # Arrondit à 2 décimales
    RoundToTwoDecimals(Value : float) : float =
        Multiplied := Value * 100.0
        if (FloorValue := Floor[Multiplied]):
            FloatFloor := FloorValue * 1.0
            return FloatFloor / 100.0
        return Value

    # Puissance entière (helper pour les calculs)
    Power(Base : float, Exponent : int) : float =
        if (Exponent <= 0):
            return 1.0

        var Result : float = 1.0
        for (I := 1..Exponent):
            set Result = Result * Base

        return Result

    # Convertit une string formatée en nombre approximatif (utile pour le debug)
    # Par exemple : "1.5M" -> 1500000
    ParseFormattedNumber(FormattedStr : string) : float =
        # NOTE: Cette fonction est un placeholder
        # L'implémentation complète nécessiterait le parsing de string en Verse
        # Pour l'instant, retourne 0.0
        return 0.0

    # Calcule le pourcentage de progression entre deux valeurs
    CalculateProgress(Current : float, Target : float) : float =
        if (Target <= 0.0):
            return 0.0

        Progress := (Current / Target) * 100.0

        if (Progress > 100.0):
            return 100.0

        return Progress

    # Formate un pourcentage
    FormatPercentage(Value : float) : string =
        if (FloorValue := Floor[Value * 10.0]):
            FloatFloor := FloorValue * 1.0
            RoundedValue := FloatFloor / 10.0
            return "{RoundedValue}%"
        return "0%"
