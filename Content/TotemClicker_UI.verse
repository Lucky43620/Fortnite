# =========================================================================
# TotemClicker_UI.verse
# =========================================================================
# Rôle : Gestion de l'interface utilisateur / HUD
# Affichage des ressources, statistiques, formatage des nombres
# =========================================================================

using { /Fortnite.com/Devices }
using { /Fortnite.com/UI }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }

# Gestionnaire de l'interface utilisateur
totem_ui_manager := class:

    # Formate un nombre en notation K/M/B/T
    FormatNumber(Value : float) : string =
        if (Value < 1000.0):
            if (FloorValue := Floor[Value]):
                return "{FloorValue}"
            return "0"
        else if (Value < 1000000.0):
            Thousands := Value / 1000.0
            if (FloorValue := Floor[Thousands * 10.0]):
                FloatFloor := FloorValue * 1.0
                Rounded := FloatFloor / 10.0
                return "{Rounded}K"
            return "0K"
        else if (Value < 1000000000.0):
            Millions := Value / 1000000.0
            if (FloorValue := Floor[Millions * 10.0]):
                FloatFloor := FloorValue * 1.0
                Rounded := FloatFloor / 10.0
                return "{Rounded}M"
            return "0M"
        else if (Value < 1000000000000.0):
            Billions := Value / 1000000000.0
            if (FloorValue := Floor[Billions * 10.0]):
                FloatFloor := FloorValue * 1.0
                Rounded := FloatFloor / 10.0
                return "{Rounded}B"
            return "0B"
        else:
            Trillions := Value / 1000000000000.0
            if (FloorValue := Floor[Trillions * 10.0]):
                FloatFloor := FloorValue * 1.0
                Rounded := FloatFloor / 10.0
                return "{Rounded}T"
            return "0T"

    # Formate un entier
    FormatInt(Value : int) : string =
        FloatValue := Value * 1.0
        return FormatNumber(FloatValue)

    # Génère le texte principal du HUD
    GenerateMainHUDText(Souls : int, SoulsPerSecond : float, PrestigeFragments : int) : string =
        SoulsText := FormatInt(Souls)
        SpsText := FormatNumber(SoulsPerSecond)

        if (PrestigeFragments > 0):
            return "Ames: {SoulsText}\nProduction: {SpsText}/s\nFragments: {PrestigeFragments}"
        else:
            return "Ames: {SoulsText}\nProduction: {SpsText}/s"

    # Génère le texte pour un bouton de générateur
    GenerateGeneratorButtonText(Name : string, Level : int, Cost : float, CanAfford : logic) : string =
        CostText := FormatNumber(Cost)

        if (CanAfford = true):
            return "[{Name}]\nNiveau: {Level}\nCout: {CostText}"
        else:
            return "[{Name}] (Verrouille)\nNiveau: {Level}\nCout: {CostText}"

    # Génère le texte pour un bouton d'upgrade
    GenerateUpgradeButtonText(Name : string, Cost : float, CanAfford : logic, IsPurchased : logic) : string =
        if (IsPurchased = true):
            return "[{Name}]\nACHETE"

        CostText := FormatNumber(Cost)

        if (CanAfford = true):
            return "[{Name}]\nCout: {CostText}"
        else:
            return "[{Name}] (Verrouille)\nCout: {CostText}"

    # Génère le texte pour le bouton de prestige
    GeneratePrestigeButtonText(CanPrestige : logic, FragmentsGained : int) : string =
        if (CanPrestige = true):
            if (FragmentsGained > 1):
                return "PRESTIGE\nGagner {FragmentsGained} fragments"
            else:
                return "PRESTIGE\nGagner {FragmentsGained} fragment"
        else:
            return "PRESTIGE\n(50M ames requis)"

    # Génère un texte de statistiques détaillées
    GenerateStatsText(Souls : int, SoulsPerClick : float, SoulsPerSecond : float, PrestigeFragments : int, PrestigeBonus : float) : string =
        SoulsText := FormatInt(Souls)
        SpcText := FormatNumber(SoulsPerClick)
        SpsText := FormatNumber(SoulsPerSecond)

        if (PrestigeFragments > 0):
            BonusPercent := PrestigeBonus * 100.0
            if (FloorBonus := Floor[BonusPercent]):
                return "=== STATISTIQUES ===\nAmes: {SoulsText}\nPar clic: {SpcText}\nPar seconde: {SpsText}\n\nFragments: {PrestigeFragments}\nBonus: +{FloorBonus}%"

        return "=== STATISTIQUES ===\nAmes: {SoulsText}\nPar clic: {SpcText}\nPar seconde: {SpsText}\n\nFragments: {PrestigeFragments}"

    # Affiche un message temporaire (helper pour feedback)
    GetClickFeedbackText(Gain : int) : string =
        GainText := FormatInt(Gain)
        return "+{GainText} ames!"

    # Génère le texte d'un message d'achat réussi
    GetPurchaseSuccessText(ItemName : string) : string =
        return "{ItemName} achete!"

    # Génère le texte d'un message d'achat échoué
    GetPurchaseFailedText(ItemName : string) : string =
        return "Pas assez d'ames pour {ItemName}"

    # Génère le texte du prestige
    GetPrestigeCompleteText(FragmentsGained : int, TotalFragments : int) : string =
        if (FragmentsGained > 1):
            return "PRESTIGE ACCOMPLI!\n+{FragmentsGained} fragments\nTotal: {TotalFragments}"
        else:
            return "PRESTIGE ACCOMPLI!\n+{FragmentsGained} fragment\nTotal: {TotalFragments}"
