# =========================================================================
# TotemClicker_Devices.verse
# =========================================================================
# Rôle : Liaison avec les devices UEFN
# Connecte les devices (boutons, triggers, etc.) aux fonctions Verse
# =========================================================================

using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /UnrealEngine.com/Temporary/UI }

# Device principal du jeu Totem Clicker
totem_clicker_device := class(creative_device):

    # Référence au système core
    var Core : totem_clicker_core = totem_clicker_core{}

    # ============================================
    # DEVICES A CONFIGURER DANS L'EDITEUR UEFN
    # ============================================

    # Totem principal (device interactif)
    @editable
    TotemInteractable : button_device = button_device{}

    # Boutons pour acheter les générateurs (7 boutons, un par générateur)
    @editable
    GeneratorButton0 : button_device = button_device{}

    @editable
    GeneratorButton1 : button_device = button_device{}

    @editable
    GeneratorButton2 : button_device = button_device{}

    @editable
    GeneratorButton3 : button_device = button_device{}

    @editable
    GeneratorButton4 : button_device = button_device{}

    @editable
    GeneratorButton5 : button_device = button_device{}

    @editable
    GeneratorButton6 : button_device = button_device{}

    @editable
    GeneratorButton7 : button_device = button_device{}

    @editable
    GeneratorButton8 : button_device = button_device{}

    @editable
    GeneratorButton9 : button_device = button_device{}

    @editable
    GeneratorButton10 : button_device = button_device{}

    @editable
    GeneratorButton11 : button_device = button_device{}

    @editable
    GeneratorButton12 : button_device = button_device{}

    @editable
    GeneratorButton13 : button_device = button_device{}

    @editable
    GeneratorButton14 : button_device = button_device{}

    @editable
    GeneratorButton15 : button_device = button_device{}

    @editable
    GeneratorButton16 : button_device = button_device{}

    @editable
    GeneratorButton17 : button_device = button_device{}

    @editable
    GeneratorButton18 : button_device = button_device{}

    @editable
    GeneratorButton19 : button_device = button_device{}

    # Bouton pour upgrade de clic
    @editable
    ClickUpgradeButton : button_device = button_device{}

    # Boutons pour upgrades globales
    @editable
    GlobalUpgradeButton0 : button_device = button_device{}

    @editable
    GlobalUpgradeButton1 : button_device = button_device{}

    @editable
    GlobalUpgradeButton2 : button_device = button_device{}

    @editable
    GlobalUpgradeButton3 : button_device = button_device{}

    @editable
    GlobalUpgradeButton4 : button_device = button_device{}

    @editable
    GlobalUpgradeButton5 : button_device = button_device{}

    @editable
    GlobalUpgradeButton6 : button_device = button_device{}

    @editable
    GlobalUpgradeButton7 : button_device = button_device{}

    @editable
    GlobalUpgradeButton8 : button_device = button_device{}

    @editable
    GlobalUpgradeButton9 : button_device = button_device{}

    @editable
    GlobalUpgradeButton10 : button_device = button_device{}

    @editable
    GlobalUpgradeButton11 : button_device = button_device{}

    @editable
    GlobalUpgradeButton12 : button_device = button_device{}

    @editable
    GlobalUpgradeButton13 : button_device = button_device{}

    @editable
    GlobalUpgradeButton14 : button_device = button_device{}

    @editable
    GlobalUpgradeButton15 : button_device = button_device{}

    @editable
    GlobalUpgradeButton16 : button_device = button_device{}

    @editable
    GlobalUpgradeButton17 : button_device = button_device{}

    @editable
    GlobalUpgradeButton18 : button_device = button_device{}

    @editable
    GlobalUpgradeButton19 : button_device = button_device{}

    @editable
    GlobalUpgradeButton20 : button_device = button_device{}

    @editable
    GlobalUpgradeButton21 : button_device = button_device{}

    @editable
    GlobalUpgradeButton22 : button_device = button_device{}

    @editable
    GlobalUpgradeButton23 : button_device = button_device{}

    @editable
    GlobalUpgradeButton24 : button_device = button_device{}

    @editable
    GlobalUpgradeButton25 : button_device = button_device{}

    @editable
    GlobalUpgradeButton26 : button_device = button_device{}

    @editable
    GlobalUpgradeButton27 : button_device = button_device{}

    @editable
    GlobalUpgradeButton28 : button_device = button_device{}

    @editable
    GlobalUpgradeButton29 : button_device = button_device{}

    @editable
    GlobalUpgradeButton30 : button_device = button_device{}

    @editable
    GlobalUpgradeButton31 : button_device = button_device{}

    @editable
    GlobalUpgradeButton32 : button_device = button_device{}

    @editable
    GlobalUpgradeButton33 : button_device = button_device{}

    @editable
    GlobalUpgradeButton34 : button_device = button_device{}

    @editable
    GlobalUpgradeButton35 : button_device = button_device{}

    @editable
    GlobalUpgradeButton36 : button_device = button_device{}

    @editable
    GlobalUpgradeButton37 : button_device = button_device{}

    @editable
    GlobalUpgradeButton38 : button_device = button_device{}

    @editable
    GlobalUpgradeButton39 : button_device = button_device{}

    @editable
    GlobalUpgradeButton40 : button_device = button_device{}

    @editable
    GlobalUpgradeButton41 : button_device = button_device{}

    @editable
    GlobalUpgradeButton42 : button_device = button_device{}

    @editable
    GlobalUpgradeButton43 : button_device = button_device{}

    @editable
    GlobalUpgradeButton44 : button_device = button_device{}

    @editable
    GlobalUpgradeButton45 : button_device = button_device{}

    @editable
    GlobalUpgradeButton46 : button_device = button_device{}

    @editable
    GlobalUpgradeButton47 : button_device = button_device{}

    @editable
    GlobalUpgradeButton48 : button_device = button_device{}

    @editable
    GlobalUpgradeButton49 : button_device = button_device{}

    # Bouton pour activer le prestige
    @editable
    PrestigeButton : button_device = button_device{}

    # ============================================
    # NOUVEAUX DEVICES POUR LES SYSTÈMES
    # ============================================

    # Billboards pour afficher les informations
    @editable
    LeaderboardSoulsBillboard : billboard_device = billboard_device{}

    @editable
    LeaderboardProductionBillboard : billboard_device = billboard_device{}

    @editable
    LeaderboardPrestigeBillboard : billboard_device = billboard_device{}

    @editable
    AchievementsBillboard : billboard_device = billboard_device{}

    @editable
    StatisticsBillboard : billboard_device = billboard_device{}

    @editable
    QuestsBillboard : billboard_device = billboard_device{}

    @editable
    EventBillboard : billboard_device = billboard_device{}

    @editable
    ComboBillboard : billboard_device = billboard_device{}

    # Bouton pour réclamer les récompenses de quêtes
    @editable
    ClaimQuestsButton : button_device = button_device{}

    # ============================================
    # FONCTIONS LOCALISÉES POUR BILLBOARDS
    # ============================================

    # Messages simples pour les billboards (seuls les int/float sont supportés comme paramètres)
    <localizes>
    ComboMessage<private>(Count : int) : message = "COMBO x{Count}"
    <localizes>
    NoComboMessage<private>() : message = "Cliquez vite!"
    <localizes>
    EventActiveMessage<private>() : message = "EVENT ACTIF"
    <localizes>
    NoEventMessage<private>() : message = "Aucun event"
    <localizes>
    StatsMessage<private>() : message = "STATS (console)"
    <localizes>
    QuestsMessage<private>() : message = "QUETES (console)"
    <localizes>
    AchievementsMessage<private>() : message = "ACHIEVEMENTS"
    <localizes>
    LeaderboardMessage<private>() : message = "LEADERBOARD"

    # ============================================
    # FONCTIONS D'INITIALISATION
    # ============================================

    # Appelé quand le device démarre
    OnBegin<override>()<suspends> : void =
        Print("=================================")
        Print("Totem Clicker Device started!")
        Print("=================================")

        # Initialise le core
        Core.Initialize()

        # Connecte les événements des devices
        ConnectDeviceEvents()

        # Démarre la boucle de production
        spawn:
            Core.StartProductionLoop()

        # Démarre la boucle d'affichage des billboards
        spawn:
            UpdateBillboardsLoop()

        Print("All systems ready!")

    # Connecte tous les events des devices
    ConnectDeviceEvents() : void =
        # Totem principal
        TotemInteractable.InteractedWithEvent.Subscribe(OnTotemClicked)

        # Générateurs (20 au total)
        GeneratorButton0.InteractedWithEvent.Subscribe(OnGenerator0Clicked)
        GeneratorButton1.InteractedWithEvent.Subscribe(OnGenerator1Clicked)
        GeneratorButton2.InteractedWithEvent.Subscribe(OnGenerator2Clicked)
        GeneratorButton3.InteractedWithEvent.Subscribe(OnGenerator3Clicked)
        GeneratorButton4.InteractedWithEvent.Subscribe(OnGenerator4Clicked)
        GeneratorButton5.InteractedWithEvent.Subscribe(OnGenerator5Clicked)
        GeneratorButton6.InteractedWithEvent.Subscribe(OnGenerator6Clicked)
        GeneratorButton7.InteractedWithEvent.Subscribe(OnGenerator7Clicked)
        GeneratorButton8.InteractedWithEvent.Subscribe(OnGenerator8Clicked)
        GeneratorButton9.InteractedWithEvent.Subscribe(OnGenerator9Clicked)
        GeneratorButton10.InteractedWithEvent.Subscribe(OnGenerator10Clicked)
        GeneratorButton11.InteractedWithEvent.Subscribe(OnGenerator11Clicked)
        GeneratorButton12.InteractedWithEvent.Subscribe(OnGenerator12Clicked)
        GeneratorButton13.InteractedWithEvent.Subscribe(OnGenerator13Clicked)
        GeneratorButton14.InteractedWithEvent.Subscribe(OnGenerator14Clicked)
        GeneratorButton15.InteractedWithEvent.Subscribe(OnGenerator15Clicked)
        GeneratorButton16.InteractedWithEvent.Subscribe(OnGenerator16Clicked)
        GeneratorButton17.InteractedWithEvent.Subscribe(OnGenerator17Clicked)
        GeneratorButton18.InteractedWithEvent.Subscribe(OnGenerator18Clicked)
        GeneratorButton19.InteractedWithEvent.Subscribe(OnGenerator19Clicked)

        # Upgrade de clic
        ClickUpgradeButton.InteractedWithEvent.Subscribe(OnClickUpgradeClicked)

        # Upgrades globales (50 au total)
        GlobalUpgradeButton0.InteractedWithEvent.Subscribe(OnGlobalUpgrade0Clicked)
        GlobalUpgradeButton1.InteractedWithEvent.Subscribe(OnGlobalUpgrade1Clicked)
        GlobalUpgradeButton2.InteractedWithEvent.Subscribe(OnGlobalUpgrade2Clicked)
        GlobalUpgradeButton3.InteractedWithEvent.Subscribe(OnGlobalUpgrade3Clicked)
        GlobalUpgradeButton4.InteractedWithEvent.Subscribe(OnGlobalUpgrade4Clicked)
        GlobalUpgradeButton5.InteractedWithEvent.Subscribe(OnGlobalUpgrade5Clicked)
        GlobalUpgradeButton6.InteractedWithEvent.Subscribe(OnGlobalUpgrade6Clicked)
        GlobalUpgradeButton7.InteractedWithEvent.Subscribe(OnGlobalUpgrade7Clicked)
        GlobalUpgradeButton8.InteractedWithEvent.Subscribe(OnGlobalUpgrade8Clicked)
        GlobalUpgradeButton9.InteractedWithEvent.Subscribe(OnGlobalUpgrade9Clicked)
        GlobalUpgradeButton10.InteractedWithEvent.Subscribe(OnGlobalUpgrade10Clicked)
        GlobalUpgradeButton11.InteractedWithEvent.Subscribe(OnGlobalUpgrade11Clicked)
        GlobalUpgradeButton12.InteractedWithEvent.Subscribe(OnGlobalUpgrade12Clicked)
        GlobalUpgradeButton13.InteractedWithEvent.Subscribe(OnGlobalUpgrade13Clicked)
        GlobalUpgradeButton14.InteractedWithEvent.Subscribe(OnGlobalUpgrade14Clicked)
        GlobalUpgradeButton15.InteractedWithEvent.Subscribe(OnGlobalUpgrade15Clicked)
        GlobalUpgradeButton16.InteractedWithEvent.Subscribe(OnGlobalUpgrade16Clicked)
        GlobalUpgradeButton17.InteractedWithEvent.Subscribe(OnGlobalUpgrade17Clicked)
        GlobalUpgradeButton18.InteractedWithEvent.Subscribe(OnGlobalUpgrade18Clicked)
        GlobalUpgradeButton19.InteractedWithEvent.Subscribe(OnGlobalUpgrade19Clicked)
        GlobalUpgradeButton20.InteractedWithEvent.Subscribe(OnGlobalUpgrade20Clicked)
        GlobalUpgradeButton21.InteractedWithEvent.Subscribe(OnGlobalUpgrade21Clicked)
        GlobalUpgradeButton22.InteractedWithEvent.Subscribe(OnGlobalUpgrade22Clicked)
        GlobalUpgradeButton23.InteractedWithEvent.Subscribe(OnGlobalUpgrade23Clicked)
        GlobalUpgradeButton24.InteractedWithEvent.Subscribe(OnGlobalUpgrade24Clicked)
        GlobalUpgradeButton25.InteractedWithEvent.Subscribe(OnGlobalUpgrade25Clicked)
        GlobalUpgradeButton26.InteractedWithEvent.Subscribe(OnGlobalUpgrade26Clicked)
        GlobalUpgradeButton27.InteractedWithEvent.Subscribe(OnGlobalUpgrade27Clicked)
        GlobalUpgradeButton28.InteractedWithEvent.Subscribe(OnGlobalUpgrade28Clicked)
        GlobalUpgradeButton29.InteractedWithEvent.Subscribe(OnGlobalUpgrade29Clicked)
        GlobalUpgradeButton30.InteractedWithEvent.Subscribe(OnGlobalUpgrade30Clicked)
        GlobalUpgradeButton31.InteractedWithEvent.Subscribe(OnGlobalUpgrade31Clicked)
        GlobalUpgradeButton32.InteractedWithEvent.Subscribe(OnGlobalUpgrade32Clicked)
        GlobalUpgradeButton33.InteractedWithEvent.Subscribe(OnGlobalUpgrade33Clicked)
        GlobalUpgradeButton34.InteractedWithEvent.Subscribe(OnGlobalUpgrade34Clicked)
        GlobalUpgradeButton35.InteractedWithEvent.Subscribe(OnGlobalUpgrade35Clicked)
        GlobalUpgradeButton36.InteractedWithEvent.Subscribe(OnGlobalUpgrade36Clicked)
        GlobalUpgradeButton37.InteractedWithEvent.Subscribe(OnGlobalUpgrade37Clicked)
        GlobalUpgradeButton38.InteractedWithEvent.Subscribe(OnGlobalUpgrade38Clicked)
        GlobalUpgradeButton39.InteractedWithEvent.Subscribe(OnGlobalUpgrade39Clicked)
        GlobalUpgradeButton40.InteractedWithEvent.Subscribe(OnGlobalUpgrade40Clicked)
        GlobalUpgradeButton41.InteractedWithEvent.Subscribe(OnGlobalUpgrade41Clicked)
        GlobalUpgradeButton42.InteractedWithEvent.Subscribe(OnGlobalUpgrade42Clicked)
        GlobalUpgradeButton43.InteractedWithEvent.Subscribe(OnGlobalUpgrade43Clicked)
        GlobalUpgradeButton44.InteractedWithEvent.Subscribe(OnGlobalUpgrade44Clicked)
        GlobalUpgradeButton45.InteractedWithEvent.Subscribe(OnGlobalUpgrade45Clicked)
        GlobalUpgradeButton46.InteractedWithEvent.Subscribe(OnGlobalUpgrade46Clicked)
        GlobalUpgradeButton47.InteractedWithEvent.Subscribe(OnGlobalUpgrade47Clicked)
        GlobalUpgradeButton48.InteractedWithEvent.Subscribe(OnGlobalUpgrade48Clicked)
        GlobalUpgradeButton49.InteractedWithEvent.Subscribe(OnGlobalUpgrade49Clicked)

        # Prestige
        PrestigeButton.InteractedWithEvent.Subscribe(OnPrestigeClicked)

        # Bouton pour réclamer les quêtes
        ClaimQuestsButton.InteractedWithEvent.Subscribe(OnClaimQuestsClicked)

        Print("All device events connected!")

    # ============================================
    # EVENT HANDLERS - TOTEM PRINCIPAL
    # ============================================

    # Appelé quand le joueur clique sur le totem
    OnTotemClicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.HandleTotemClick(Player) }

    # ============================================
    # EVENT HANDLERS - GÉNÉRATEURS
    # ============================================

    OnGenerator0Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 0) }

    OnGenerator1Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 1) }

    OnGenerator2Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 2) }

    OnGenerator3Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 3) }

    OnGenerator4Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 4) }

    OnGenerator5Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 5) }

    OnGenerator6Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 6) }

    OnGenerator7Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 7) }

    OnGenerator8Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 8) }

    OnGenerator9Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 9) }

    OnGenerator10Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 10) }

    OnGenerator11Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 11) }

    OnGenerator12Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 12) }

    OnGenerator13Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 13) }

    OnGenerator14Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 14) }

    OnGenerator15Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 15) }

    OnGenerator16Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 16) }

    OnGenerator17Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 17) }

    OnGenerator18Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 18) }

    OnGenerator19Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGenerator(Player, 19) }

    # ============================================
    # EVENT HANDLERS - UPGRADES
    # ============================================

    # Upgrade de clic
    OnClickUpgradeClicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyClickUpgrade(Player) }

    # Upgrades globales
    OnGlobalUpgrade0Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 0) }

    OnGlobalUpgrade1Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 1) }

    OnGlobalUpgrade2Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 2) }

    OnGlobalUpgrade3Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 3) }

    OnGlobalUpgrade4Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 4) }

    OnGlobalUpgrade5Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 5) }

    OnGlobalUpgrade6Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 6) }

    OnGlobalUpgrade7Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 7) }

    OnGlobalUpgrade8Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 8) }

    OnGlobalUpgrade9Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 9) }

    OnGlobalUpgrade10Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 10) }

    OnGlobalUpgrade11Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 11) }

    OnGlobalUpgrade12Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 12) }

    OnGlobalUpgrade13Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 13) }

    OnGlobalUpgrade14Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 14) }

    OnGlobalUpgrade15Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 15) }

    OnGlobalUpgrade16Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 16) }

    OnGlobalUpgrade17Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 17) }

    OnGlobalUpgrade18Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 18) }

    OnGlobalUpgrade19Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 19) }

    OnGlobalUpgrade20Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 20) }

    OnGlobalUpgrade21Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 21) }

    OnGlobalUpgrade22Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 22) }

    OnGlobalUpgrade23Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 23) }

    OnGlobalUpgrade24Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 24) }

    OnGlobalUpgrade25Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 25) }

    OnGlobalUpgrade26Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 26) }

    OnGlobalUpgrade27Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 27) }

    OnGlobalUpgrade28Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 28) }

    OnGlobalUpgrade29Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 29) }

    OnGlobalUpgrade30Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 30) }

    OnGlobalUpgrade31Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 31) }

    OnGlobalUpgrade32Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 32) }

    OnGlobalUpgrade33Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 33) }

    OnGlobalUpgrade34Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 34) }

    OnGlobalUpgrade35Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 35) }

    OnGlobalUpgrade36Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 36) }

    OnGlobalUpgrade37Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 37) }

    OnGlobalUpgrade38Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 38) }

    OnGlobalUpgrade39Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 39) }

    OnGlobalUpgrade40Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 40) }

    OnGlobalUpgrade41Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 41) }

    OnGlobalUpgrade42Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 42) }

    OnGlobalUpgrade43Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 43) }

    OnGlobalUpgrade44Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 44) }

    OnGlobalUpgrade45Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 45) }

    OnGlobalUpgrade46Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 46) }

    OnGlobalUpgrade47Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 47) }

    OnGlobalUpgrade48Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 48) }

    OnGlobalUpgrade49Clicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.BuyGlobalUpgrade(Player, 49) }

    # ============================================
    # EVENT HANDLERS - PRESTIGE
    # ============================================

    # Prestige
    OnPrestigeClicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { Core.ActivatePrestige(Player) }

    # ============================================
    # EVENT HANDLERS - QUÊTES
    # ============================================

    # Réclamer les récompenses de quêtes
    OnClaimQuestsClicked(Agent : agent) : void =
        if (Player := player[Agent]):
            spawn { ClaimQuestsRewards(Player) }

    # Fonction pour réclamer toutes les récompenses de quêtes complétées
    ClaimQuestsRewards(Player : player)<suspends> : void =
        Quests := Core.GetQuests()

        MaybeState := Core.GetPlayerState(Player)
        if:
            State := MaybeState?
        then:
            var TotalReward : int = 0

            # Récupère toutes les récompenses
            RewardAmount := Quests.ClaimAllRewards(Player)
            set TotalReward = RewardAmount

            if (TotalReward > 0):
                # Ajoute les âmes au joueur
                Core.AddSouls(Player, TotalReward)
                Print("Player claimed souls from quests!")
            else:
                Print("No quest rewards to claim")

    # ============================================
    # BOUCLE D'AFFICHAGE DES BILLBOARDS
    # ============================================

    # Met à jour tous les billboards périodiquement
    UpdateBillboardsLoop()<suspends> : void =
        loop:
            Sleep(2.0)  # Met à jour toutes les 2 secondes

            # Récupère les managers
            Leaderboard := Core.GetLeaderboard()
            Achievements := Core.GetAchievements()
            Statistics := Core.GetStatistics()
            Quests := Core.GetQuests()
            Events := Core.GetEvents()
            Combo := Core.GetCombo()
            UI := Core.GetUI()

            # Pour chaque joueur, met à jour ses billboards personnels
            AllPlayers := GetPlayspace().GetPlayers()
            for (Player : AllPlayers):
                MaybeState := Core.GetPlayerState(Player)
                if:
                    State := MaybeState?
                then:
                    # Leaderboards (affichage global - seulement une fois, pas par joueur)
                    false

            # Met à jour les leaderboards (affichage global)
            LeaderboardSoulsText := Leaderboard.GenerateTopSoulsText(UI)
            Print("LEADERBOARD SOULS:")
            Print(LeaderboardSoulsText)
            LeaderboardSoulsBillboard.SetText(LeaderboardMessage())

            LeaderboardProductionText := Leaderboard.GenerateTopProductionText(UI)
            Print("LEADERBOARD PRODUCTION:")
            Print(LeaderboardProductionText)
            LeaderboardProductionBillboard.SetText(LeaderboardMessage())

            LeaderboardPrestigeText := Leaderboard.GenerateTopPrestigeText(UI)
            Print("LEADERBOARD PRESTIGE:")
            Print(LeaderboardPrestigeText)
            LeaderboardPrestigeBillboard.SetText(LeaderboardMessage())

            # Met à jour les billboards personnels pour chaque joueur
            # Note: Pour un vrai système multi-joueur, vous devriez avoir des billboards séparés par joueur
            # Pour l'instant, on affiche juste pour le premier joueur actif
            if (AllPlayers.Length > 0):
                if (FirstPlayer := AllPlayers[0]):
                    # Achievements (par joueur)
                    AchievementsText := Achievements.GenerateAchievementsText(FirstPlayer)
                    Print("ACHIEVEMENTS:")
                    Print(AchievementsText)
                    AchievementsBillboard.SetText(AchievementsMessage())

                    # Statistiques (par joueur)
                    StatsText := Statistics.GenerateStatsText(FirstPlayer, UI)
                    Print("STATISTICS:")
                    Print(StatsText)
                    StatisticsBillboard.SetText(StatsMessage())

                    # Quêtes (par joueur)
                    QuestsText := Quests.GenerateQuestsText(FirstPlayer)
                    Print("QUESTS:")
                    Print(QuestsText)
                    QuestsBillboard.SetText(QuestsMessage())

                    # Event actif (par joueur)
                    EventText := Events.GenerateEventText(FirstPlayer)
                    Print("EVENT:")
                    Print(EventText)
                    if (Events.HasActiveEvent(FirstPlayer)):
                        EventBillboard.SetText(EventActiveMessage())
                    else:
                        EventBillboard.SetText(NoEventMessage())

                    # Combo (par joueur)
                    ComboCount := Combo.GetPlayerComboCount(FirstPlayer)
                    ComboText := Combo.GenerateComboText(FirstPlayer)
                    Print("COMBO:")
                    Print(ComboText)
                    if (ComboCount > 0):
                        ComboBillboard.SetText(ComboMessage(ComboCount))
                    else:
                        ComboBillboard.SetText(NoComboMessage())

# =========================================================================
# NOTES D'UTILISATION
# =========================================================================
#
# Pour utiliser ce device dans UEFN :
#
# 1. Placez ce device dans votre île (totem_clicker_device)
# 2. Configurez tous les devices @editable dans l'éditeur :
#    - TotemInteractable : Le device que le joueur clique (prop, bouton, etc.)
#    - GeneratorButton0 à 19 : 20 boutons pour acheter les générateurs
#    - ClickUpgradeButton : Bouton pour améliorer les clics
#    - GlobalUpgradeButton0 à 49 : 50 boutons pour les upgrades globales
#    - PrestigeButton : Bouton pour activer le prestige
#
# 3. Tous les boutons doivent être des button_device ou des devices interactifs
#
# 4. Le système démarre automatiquement quand le jeu commence
#
# 5. Les actions sont maintenant fonctionnelles :
#    - Clic sur le totem : ajoute des âmes selon SoulsPerClick
#    - Clic sur générateurs : achète le générateur si assez d'âmes
#    - Clic sur upgrades : achète l'upgrade si assez d'âmes
#    - Clic sur prestige : reset avec bonus permanent
#
# =========================================================================
