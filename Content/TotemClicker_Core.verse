using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

totem_clicker_core := class(creative_device):

    # =========================================================================
    # SYSTÈMES
    # =========================================================================

    # Instances des systèmes de jeu
    var Generators : totem_generators = totem_generators{}
    var Upgrades : totem_upgrades = totem_upgrades{}
    var Prestige : totem_prestige = totem_prestige{}
    var UI : totem_ui_manager = totem_ui_manager{}
    var ClickHandler : totem_click_handler = totem_click_handler{}
    var PersistenceManager : totem_persistence_manager = totem_persistence_manager{}

    # Map des états des joueurs (état en mémoire, non persisté)
    var PlayerStates : [player]player_state = map{}

    # =========================================================================
    # INITIALISATION
    # =========================================================================

    OnBegin<override>()<suspends> : void =
        Print("=================================")
        Print("TOTEM CLICKER - Starting...")
        Print("20 generators, 30 click upgrades, 50 global upgrades")
        Print("=================================")

    # Initialise le core (appelé par le device)
    Initialize<public>()<suspends> : void =
        Print("Totem Clicker Core initialized")
        Print("Using UEFN Persistence API for automatic saves")

        # Écoute les joueurs qui rejoignent
        AllPlayers := GetPlayspace().GetPlayers()
        for (Player : AllPlayers):
            spawn { InitPlayer(Player) }

    # Initialise un joueur
    InitPlayer<public>(Player : player)<suspends> : void =
        if (PlayerStates[Player]):
            Print("Player already initialized")
        else:
            # Initialise le joueur dans le système de persistance
            PersistenceManager.InitializePlayer(Player)

            # Charge les données sauvegardées
            SavedData := PersistenceManager.GetPlayerData(Player)

            # Crée le state du joueur avec les données sauvegardées
            NewState := player_state{Player := Player}
            NewState.Init(Player)

            # Restaure les données sauvegardées
            set NewState.Souls = SavedData.Souls
            set NewState.SoulsPerClick = SavedData.SoulsPerClick
            set NewState.SoulsPerSecond = SavedData.SoulsPerSecond
            set NewState.SoulsFractionalAccumulator = SavedData.SoulsFractionalAccumulator
            set NewState.GeneratorLevels = SavedData.GeneratorLevels
            set NewState.ClickUpgradeLevel = SavedData.ClickUpgradeLevel
            set NewState.GlobalMultiplier = SavedData.GlobalMultiplier
            set NewState.PrestigeFragments = SavedData.PrestigeFragments
            set NewState.PrestigeMultiplier = SavedData.PrestigeMultiplier
            set NewState.TotalSoulsEarned = SavedData.TotalSoulsEarned

            # Restaure les upgrades globales achetées
            Upgrades.RestoreGlobalUpgradesPurchased(SavedData.GlobalUpgradesPurchased)

            # Enregistre le state en mémoire
            if (set PlayerStates[Player] = NewState) {}

            Print("Player initialized - Souls: {NewState.Souls}")

    # =========================================================================
    # BOUCLE DE PRODUCTION
    # =========================================================================

    # Boucle de production (appelée depuis le device)
    StartProductionLoop<public>()<suspends> : void =
        Print("Production loop started")

        loop:
            Sleep(1.0)  # 1 tick par seconde

            # Pour chaque joueur, ajoute la production
            AllPlayers := GetPlayspace().GetPlayers()
            for (Player : AllPlayers):
                if (State := PlayerStates[Player]):
                    if (State.SoulsPerSecond > 0.0):
                        # Accumule les fractions (ex: 0.1 + 0.1 + ... = 1.0)
                        set State.SoulsFractionalAccumulator += State.SoulsPerSecond

                        # Quand on atteint 1.0 ou plus, on ajoute les souls entières
                        if (State.SoulsFractionalAccumulator >= 1.0):
                            if (SoulsToAdd := Floor[State.SoulsFractionalAccumulator]):
                                State.AddSouls(SoulsToAdd)
                                # Garde la fraction restante
                                FloatSoulsToAdd := SoulsToAdd * 1.0
                                set State.SoulsFractionalAccumulator -= FloatSoulsToAdd

                                # Sauvegarde automatique (toutes les secondes quand il y a production)
                                PersistenceManager.UpdateSouls(Player, State.Souls)
                                PersistenceManager.UpdateFractionalAccumulator(Player, State.SoulsFractionalAccumulator)
                                PersistenceManager.UpdateTotalSoulsEarned(Player, State.TotalSoulsEarned)

    # =========================================================================
    # GESTION DES CLICS
    # =========================================================================

    # Traite un clic sur le totem
    HandleTotemClick<public>(Player : player)<suspends> : void =
        if (State := PlayerStates[Player]):
            # Calcule le gain du clic
            Gain := ClickHandler.ProcessClick(State.SoulsPerClick, State.PrestigeMultiplier)

            # Ajoute les âmes
            State.AddSouls(Gain)

            # Sauvegarde automatique via persistence
            PersistenceManager.UpdateSouls(Player, State.Souls)
            PersistenceManager.UpdateTotalSoulsEarned(Player, State.TotalSoulsEarned)

            Print("Player clicked - Gained {Gain} souls (Total: {State.Souls})")
        else:
            Print("Player not initialized - initializing now...")
            InitPlayer(Player)

    # =========================================================================
    # GÉNÉRATEURS
    # =========================================================================

    # Achète un générateur
    BuyGenerator<public>(Player : player, GeneratorIndex : int)<suspends> : void =
        if (State := PlayerStates[Player]):
            # Récupère les données du générateur
            GeneratorData := Generators.GetGeneratorData(GeneratorIndex)

            # Récupère le niveau actuel
            if (CurrentLevel := State.GeneratorLevels[GeneratorIndex]):
                # Calcule le coût
                Cost := Generators.CalculateCurrentCost(GeneratorIndex, CurrentLevel)

                # Convertit en int (extraire Floor avant if pour éviter decides effect)
                var CostInt : int = 0
                if (FloorResult := Floor[Cost]):
                    set CostInt = FloorResult

                # Vérifie si le joueur peut se le permettre
                if (State.Souls >= CostInt):
                    # Dépense les âmes (extraire SpendSouls avant if)
                    CanSpend := State.SpendSouls(CostInt)
                    if (CanSpend = true):
                        # Augmente le niveau du générateur
                        NewLevel := CurrentLevel + 1
                        if (set State.GeneratorLevels[GeneratorIndex] = NewLevel) {}

                        # Recalcule la production
                        BaseProductions := Generators.GetBaseProductions()
                        GeneratorMults := Generators.GetAllMultipliers()
                        State.RecalculateProduction(BaseProductions, GeneratorMults)

                        # Sauvegarde automatique
                        PersistenceManager.UpdateSouls(Player, State.Souls)
                        PersistenceManager.UpdateGeneratorLevels(Player, State.GeneratorLevels)
                        PersistenceManager.UpdateSoulsPerSecond(Player, State.SoulsPerSecond)

                        Print("Player bought {GeneratorData.Name} lvl {NewLevel} - SPS: {State.SoulsPerSecond}")
                    else:
                        Print("Failed to spend souls")
                else:
                    Print("Player cannot afford {GeneratorData.Name} (Cost: {Cost}, Souls: {State.Souls})")

    # =========================================================================
    # UPGRADES
    # =========================================================================

    # Achète une upgrade de clic
    BuyClickUpgrade<public>(Player : player)<suspends> : void =
        if (State := PlayerStates[Player]):
            CurrentLevel := State.ClickUpgradeLevel

            # Vérifie s'il y a une upgrade suivante (extraire no_rollback)
            HasNext := Upgrades.HasNextClickUpgrade(CurrentLevel)
            if (HasNext = true):
                # Obtient le coût
                Cost := Upgrades.GetNextClickUpgradeCost(CurrentLevel)

                # Convertit en int
                var CostInt : int = 0
                if (FloorResult := Floor[Cost]):
                    set CostInt = FloorResult

                # Vérifie si le joueur peut se le permettre
                if (State.Souls >= CostInt):
                    # Dépense les âmes
                    CanSpend := State.SpendSouls(CostInt)
                    if (CanSpend = true):
                        # Augmente le niveau
                        NewLevel := CurrentLevel + 1
                        set State.ClickUpgradeLevel = NewLevel

                        # Met à jour la puissance de clic
                        NewClickPower := Upgrades.GetClickPower(NewLevel)
                        set State.SoulsPerClick = NewClickPower

                        # Sauvegarde automatique
                        PersistenceManager.UpdateSouls(Player, State.Souls)
                        PersistenceManager.UpdateClickUpgradeLevel(Player, State.ClickUpgradeLevel)
                        PersistenceManager.UpdateSoulsPerClick(Player, State.SoulsPerClick)

                        Print("Player upgraded click to lvl {NewLevel} - Power: {NewClickPower}")
                else:
                    Print("Player cannot afford click upgrade (Cost: {Cost})")
            else:
                Print("Player reached max click upgrade level")

    # Achète une upgrade globale
    BuyGlobalUpgrade<public>(Player : player, UpgradeIndex : int)<suspends> : void =
        if (State := PlayerStates[Player]):
            # Vérifie si déjà acheté
            IsPurchased := Upgrades.IsGlobalUpgradePurchased(UpgradeIndex)

            if (IsPurchased = false):
                # Obtient le coût
                Cost := Upgrades.GetGlobalUpgradeCost(UpgradeIndex)
                UpgradeName := Upgrades.GetGlobalUpgradeName(UpgradeIndex)

                # Convertit en int
                var CostInt : int = 0
                if (FloorResult := Floor[Cost]):
                    set CostInt = FloorResult

                # Vérifie si le joueur peut se le permettre
                if (State.Souls >= CostInt):
                    # Dépense les âmes
                    CanSpend := State.SpendSouls(CostInt)
                    if (CanSpend = true):
                        # Marque l'upgrade comme achetée
                        Upgrades.PurchaseGlobalUpgrade(UpgradeIndex)

                        # Recalcule le multiplicateur global
                        NewMultiplier := Upgrades.GetGlobalMultiplier()
                        set State.GlobalMultiplier = NewMultiplier

                        # Recalcule la production
                        BaseProductions := Generators.GetBaseProductions()
                        GeneratorMults := Generators.GetAllMultipliers()
                        State.RecalculateProduction(BaseProductions, GeneratorMults)

                        # Sauvegarde automatique (extraire appel no_rollback)
                        GlobalUpgradesPurchasedArray := Upgrades.GetGlobalUpgradesPurchasedArray()
                        PersistenceManager.UpdateSouls(Player, State.Souls)
                        PersistenceManager.UpdateGlobalMultiplier(Player, State.GlobalMultiplier)
                        PersistenceManager.UpdateGlobalUpgradesPurchased(Player, GlobalUpgradesPurchasedArray)
                        PersistenceManager.UpdateSoulsPerSecond(Player, State.SoulsPerSecond)

                        Print("Player bought {UpgradeName} - Global mult: {NewMultiplier}")
                else:
                    Print("Player cannot afford {UpgradeName} (Cost: {Cost})")
            else:
                Print("Upgrade already purchased")

    # =========================================================================
    # PRESTIGE
    # =========================================================================

    # Active le prestige pour un joueur
    ActivatePrestige<public>(Player : player)<suspends> : void =
        if (State := PlayerStates[Player]):
            # Vérifie si le prestige est disponible (extraire no_rollback)
            CanDoPrestige := Prestige.CanPrestige(State.TotalSoulsEarned)

            if (CanDoPrestige = true):
                # Calcule les fragments gagnés
                FragmentsGained := Prestige.CalculateFragmentsGained(State.TotalSoulsEarned)

                if (FragmentsGained > 0):
                    # Ajoute les fragments
                    set State.PrestigeFragments += FragmentsGained

                    # Applique le bonus de prestige
                    State.ApplyPrestigeBonus()

                    # Reset la progression
                    State.ResetProgress()
                    Upgrades.ResetAll()

                    # Sauvegarde complète après prestige (extraire appel no_rollback)
                    GlobalUpgradesPurchasedArray := Upgrades.GetGlobalUpgradesPurchasedArray()
                    PersistenceManager.SaveAllPlayerData(Player, State)
                    PersistenceManager.UpdateGlobalUpgradesPurchased(Player, GlobalUpgradesPurchasedArray)

                    Print("=================================")
                    Print("PRESTIGE!")
                    Print("Fragments gained: {FragmentsGained}")
                    Print("Total fragments: {State.PrestigeFragments}")
                    Print("Prestige bonus: +{State.PrestigeMultiplier * 100.0}%")
                    Print("=================================")
                else:
                    Print("Not enough souls for fragments (need 1M minimum)")
            else:
                Print("Cannot prestige yet (need {Prestige.PrestigeUnlockThreshold} souls)")

    # =========================================================================
    # UTILITAIRES
    # =========================================================================

    # Ajoute des souls (pour test/debug)
    AddSouls<public>(Player : player, Amount : int)<suspends> : void =
        if (State := PlayerStates[Player]):
            State.AddSouls(Amount)
            Print("Added {Amount} souls - Total: {State.Souls}")

    # Obtient les infos d'un joueur
    GetInfo<public>(Player : player) : string =
        if (State := PlayerStates[Player]):
            "Souls: {State.Souls} | SPS: {State.SoulsPerSecond} | Click: {State.SoulsPerClick} | Prestige: {State.PrestigeFragments}"
        else:
            "Player not initialized"

    # Obtient le state d'un joueur (pour le device)
    GetPlayerState<public>(Player : player) : ?player_state =
        if (State := PlayerStates[Player]):
            option{State}
        else:
            false

    # =========================================================================
    # UTILITAIRES - SAUVEGARDE MANUELLE (optionnel)
    # =========================================================================

    # Sauvegarde manuelle de tous les joueurs (optionnel - la persistance est automatique)
    SaveAllPlayers<public>()<suspends> : void =
        # Extraire l'appel no_rollback avant la boucle
        GlobalUpgradesPurchasedArray := Upgrades.GetGlobalUpgradesPurchasedArray()

        AllPlayers := GetPlayspace().GetPlayers()
        for (Player : AllPlayers):
            if (State := PlayerStates[Player]):
                PersistenceManager.SaveAllPlayerData(Player, State)
                PersistenceManager.UpdateGlobalUpgradesPurchased(Player, GlobalUpgradesPurchasedArray)
        Print("Manual save completed for all players")
