# =========================================================================
# TotemClicker_Quests.verse
# =========================================================================
# Rôle : Système de quêtes et objectifs quotidiens
# Récompense les joueurs avec des bonus pour avoir complété des objectifs
# =========================================================================

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Type d'objectif
quest_type := enum:
    CLICK_COUNT        # Cliquer X fois
    EARN_SOULS         # Gagner X âmes
    BUY_GENERATORS     # Acheter X générateurs
    BUY_UPGRADES       # Acheter X upgrades
    REACH_PRODUCTION   # Atteindre X âmes/sec

# Définition d'une quête
quest_data := struct:
    ID : int
    Name : string
    Description : string
    Type : quest_type
    TargetValue : int  # Valeur cible à atteindre
    RewardSouls : int  # Récompense en âmes
    IsCompleted : logic

# Progression d'une quête pour un joueur
quest_progress := class:
    var QuestID : int = 0
    var CurrentValue : int = 0
    var IsCompleted : logic = false

# Gestionnaire des quêtes
totem_quests_manager := class():

    # Quêtes disponibles (définies au démarrage)
    var AvailableQuests : []quest_data = array{}

    # Progression des quêtes par joueur
    var PlayerQuestProgress : [player][]quest_progress = map{}

    # Initialise le système de quêtes
    Initialize<public>() : void =
        set AvailableQuests = array{
            # Quêtes de clics
            quest_data{ID := 0, Name := "Clicker Debutant", Description := "Cliquer 50 fois", Type := quest_type.CLICK_COUNT, TargetValue := 50, RewardSouls := 500, IsCompleted := false},
            quest_data{ID := 1, Name := "Clicker Intensif", Description := "Cliquer 200 fois", Type := quest_type.CLICK_COUNT, TargetValue := 200, RewardSouls := 2000, IsCompleted := false},
            quest_data{ID := 2, Name := "Marathon de Clics", Description := "Cliquer 1000 fois", Type := quest_type.CLICK_COUNT, TargetValue := 1000, RewardSouls := 15000, IsCompleted := false},

            # Quêtes d'âmes
            quest_data{ID := 3, Name := "Petit Tresor", Description := "Gagner 5,000 ames", Type := quest_type.EARN_SOULS, TargetValue := 5000, RewardSouls := 1000, IsCompleted := false},
            quest_data{ID := 4, Name := "Fortune Croissante", Description := "Gagner 100,000 ames", Type := quest_type.EARN_SOULS, TargetValue := 100000, RewardSouls := 20000, IsCompleted := false},
            quest_data{ID := 5, Name := "Richesse Infinie", Description := "Gagner 10,000,000 ames", Type := quest_type.EARN_SOULS, TargetValue := 10000000, RewardSouls := 500000, IsCompleted := false},

            # Quêtes de générateurs
            quest_data{ID := 6, Name := "Premier Achat", Description := "Acheter 1 generateur", Type := quest_type.BUY_GENERATORS, TargetValue := 1, RewardSouls := 100, IsCompleted := false},
            quest_data{ID := 7, Name := "Collection Modeste", Description := "Acheter 10 generateurs", Type := quest_type.BUY_GENERATORS, TargetValue := 10, RewardSouls := 5000, IsCompleted := false},
            quest_data{ID := 8, Name := "Empire Industriel", Description := "Acheter 50 generateurs", Type := quest_type.BUY_GENERATORS, TargetValue := 50, RewardSouls := 50000, IsCompleted := false},

            # Quêtes d'upgrades
            quest_data{ID := 9, Name := "Amelioration Basique", Description := "Acheter 5 upgrades", Type := quest_type.BUY_UPGRADES, TargetValue := 5, RewardSouls := 3000, IsCompleted := false},
            quest_data{ID := 10, Name := "Optimisation Avancee", Description := "Acheter 20 upgrades", Type := quest_type.BUY_UPGRADES, TargetValue := 20, RewardSouls := 25000, IsCompleted := false},
            quest_data{ID := 11, Name := "Perfectionniste", Description := "Acheter 50 upgrades", Type := quest_type.BUY_UPGRADES, TargetValue := 50, RewardSouls := 100000, IsCompleted := false},

            # Quêtes de production
            quest_data{ID := 12, Name := "Premiere Production", Description := "Atteindre 10 ames/sec", Type := quest_type.REACH_PRODUCTION, TargetValue := 10, RewardSouls := 500, IsCompleted := false},
            quest_data{ID := 13, Name := "Production Serieuse", Description := "Atteindre 1,000 ames/sec", Type := quest_type.REACH_PRODUCTION, TargetValue := 1000, RewardSouls := 10000, IsCompleted := false},
            quest_data{ID := 14, Name := "Production Massive", Description := "Atteindre 100,000 ames/sec", Type := quest_type.REACH_PRODUCTION, TargetValue := 100000, RewardSouls := 200000, IsCompleted := false}
        }

        Print("Quests initialized: {AvailableQuests.Length} total")

    # Initialise un joueur dans le système de quêtes
    InitializePlayer<public>(Player : player) : void =
        if (PlayerQuestProgress[Player]):
            Print("Player quests already initialized")
        else:
            # Crée la progression pour toutes les quêtes
            var NewProgress : []quest_progress = array{}

            for (Index := 0..AvailableQuests.Length):
                NewQuestProgress := quest_progress{QuestID := Index, CurrentValue := 0, IsCompleted := false}
                set NewProgress = NewProgress + array{NewQuestProgress}

            if (set PlayerQuestProgress[Player] = NewProgress) {}
            Print("Player quests initialized")

    # Restaure la progression des quêtes depuis la sauvegarde
    RestorePlayerQuests<public>(Player : player, SavedProgress : []logic, SavedValues : []int) : void =
        if (Progress := PlayerQuestProgress[Player]):
            var NewProgress : []quest_progress = array{}

            for (Index := 0..Progress.Length):
                if:
                    IsCompleted := SavedProgress[Index]
                    CurrentValue := SavedValues[Index]
                then:
                    NewQuestProgress := quest_progress{QuestID := Index, CurrentValue := CurrentValue, IsCompleted := IsCompleted}
                    set NewProgress = NewProgress + array{NewQuestProgress}

            if (set PlayerQuestProgress[Player] = NewProgress) {}
            Print("Player quests restored")

    # Met à jour la progression d'une quête
    UpdateQuestProgress<public>(Player : player, Type : quest_type, Value : int) : void =
        if (Progress := PlayerQuestProgress[Player]):
            var NewProgress : []quest_progress = array{}
            var QuestCompleted : logic = false

            for (QuestProg : Progress):
                if (Quest := AvailableQuests[QuestProg.QuestID]):
                    if:
                        Quest.Type = Type
                        QuestProg.IsCompleted = false
                    then:
                        # Met à jour la valeur
                        var NewValue : int = Value
                        var Completed : logic = false

                        if (NewValue >= Quest.TargetValue):
                            set Completed = true
                            set QuestCompleted = true

                        NewQuestProg := quest_progress{QuestID := QuestProg.QuestID, CurrentValue := NewValue, IsCompleted := Completed}
                        set NewProgress = NewProgress + array{NewQuestProg}

                        if (Completed = true):
                            Print("QUETE TERMINEE: {Quest.Name} - Recompense: {Quest.RewardSouls} ames!")
                    else:
                        set NewProgress = NewProgress + array{QuestProg}
                else:
                    set NewProgress = NewProgress + array{QuestProg}

            if (set PlayerQuestProgress[Player] = NewProgress) {}

    # Récupère la récompense d'une quête complétée
    ClaimQuestReward<public>(Player : player, QuestID : int) : int =
        if:
            Progress := PlayerQuestProgress[Player]
            QuestProg := Progress[QuestID]
            Quest := AvailableQuests[QuestID]
        then:
            if (QuestProg.IsCompleted = true):
                Print("Claiming reward for quest: {Quest.Name}")
                return Quest.RewardSouls

        return 0

    # Obtient toutes les récompenses non réclamées
    GetAllUnclaimedRewards<public>(Player : player) : int =
        var TotalReward : int = 0

        if (Progress := PlayerQuestProgress[Player]):
            for (QuestProg : Progress):
                if:
                    QuestProg.IsCompleted = true
                    Quest := AvailableQuests[QuestProg.QuestID]
                then:
                    set TotalReward += Quest.RewardSouls

        return TotalReward

    # Marque toutes les quêtes complétées comme réclamées
    ClaimAllRewards<public>(Player : player) : int =
        TotalReward := GetAllUnclaimedRewards(Player)

        if (TotalReward > 0):
            # Reset les quêtes complétées (pour permettre de les refaire)
            if (Progress := PlayerQuestProgress[Player]):
                var NewProgress : []quest_progress = array{}

                for (QuestProg : Progress):
                    if (QuestProg.IsCompleted = true):
                        # Reset la quête
                        ResetQuestProg := quest_progress{QuestID := QuestProg.QuestID, CurrentValue := 0, IsCompleted := false}
                        set NewProgress = NewProgress + array{ResetQuestProg}
                    else:
                        set NewProgress = NewProgress + array{QuestProg}

                if (set PlayerQuestProgress[Player] = NewProgress) {}

        return TotalReward

    # Génère le texte des quêtes actives
    GenerateQuestsText<public>(Player : player) : string =
        var Text : string = "=== QUETES ACTIVES ===\n\n"
        var CompletedCount : int = 0
        var TotalCount : int = AvailableQuests.Length

        if (Progress := PlayerQuestProgress[Player]):
            for (QuestProg : Progress):
                if (Quest := AvailableQuests[QuestProg.QuestID]):
                    if (QuestProg.IsCompleted = true):
                        set CompletedCount += 1
                        set Text = "{Text}[X] {Quest.Name}\n"
                        set Text = "{Text}    Recompense: {Quest.RewardSouls} ames (Terminee!)\n\n"
                    else:
                        set Text = "{Text}[ ] {Quest.Name}\n"
                        set Text = "{Text}    {Quest.Description}\n"
                        set Text = "{Text}    Progres: {QuestProg.CurrentValue}/{Quest.TargetValue}\n"
                        set Text = "{Text}    Recompense: {Quest.RewardSouls} ames\n\n"

        set Text = "{Text}Total: {CompletedCount}/{TotalCount} completees"

        return Text

    # Obtient les données de progression (completed) pour la sauvegarde
    GetCompletedData<public>(Player : player) : []logic =
        var CompletedArray : []logic = array{}

        if (Progress := PlayerQuestProgress[Player]):
            for (QuestProg : Progress):
                set CompletedArray = CompletedArray + array{QuestProg.IsCompleted}

        return CompletedArray

    # Obtient les données de progression (values) pour la sauvegarde
    GetValuesData<public>(Player : player) : []int =
        var ValuesArray : []int = array{}

        if (Progress := PlayerQuestProgress[Player]):
            for (QuestProg : Progress):
                set ValuesArray = ValuesArray + array{QuestProg.CurrentValue}

        return ValuesArray

# =========================================================================
# NOTES D'UTILISATION
# =========================================================================
#
# Ce système gère 15 quêtes réparties en catégories :
# - Clics (3 quêtes)
# - Âmes gagnées (3 quêtes)
# - Générateurs (3 quêtes)
# - Upgrades (3 quêtes)
# - Production (3 quêtes)
#
# Les quêtes donnent des récompenses en âmes quand elles sont complétées
# Les quêtes peuvent être répétées après avoir réclamé la récompense
#
# Pour afficher dans UEFN :
# 1. Créez un billboard_device pour afficher les quêtes
# 2. Créez un bouton pour réclamer les récompenses
# 3. Le système se met à jour automatiquement
#
# =========================================================================
