# =========================================================================
# TotemClicker_Leaderboard.verse
# =========================================================================
# Rôle : Système de leaderboard pour afficher le classement des joueurs
# Affiche le Top 5 par Souls, Production et Prestige
# =========================================================================

using { /Fortnite.com/Devices }
using { /Fortnite.com/Game }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Structure pour stocker les données d'un joueur dans le leaderboard
leaderboard_entry := struct:
    Player : player
    DisplayName : string
    Souls : int
    SoulsPerSecond : float
    PrestigeFragments : int

# Gestionnaire du leaderboard
totem_leaderboard_manager := class():

    # Liste des entrées du leaderboard (mise à jour dynamiquement)
    var LeaderboardEntries : []leaderboard_entry = array{}

    # Ajoute ou met à jour un joueur dans le leaderboard
    UpdatePlayerEntry<public>(Player : player, Souls : int, SoulsPerSecond : float, PrestigeFragments : int) : void =
        PlayerName := GetPlayerName(Player)

        # Crée une nouvelle entrée
        NewEntry := leaderboard_entry:
            Player := Player
            DisplayName := PlayerName
            Souls := Souls
            SoulsPerSecond := SoulsPerSecond
            PrestigeFragments := PrestigeFragments

        # Cherche si le joueur existe déjà
        var Updated : logic = false
        var NewEntries : []leaderboard_entry = array{}

        for (Entry : LeaderboardEntries):
            if (Entry.Player = Player):
                # Remplace l'entrée existante
                set NewEntries = NewEntries + array{NewEntry}
                set Updated = true
            else:
                set NewEntries = NewEntries + array{Entry}

        # Si pas trouvé, ajoute à la fin
        if (Updated = false):
            set NewEntries = NewEntries + array{NewEntry}

        set LeaderboardEntries = NewEntries

    # Retire un joueur du leaderboard (quand il quitte)
    RemovePlayerEntry<public>(Player : player) : void =
        var NewEntries : []leaderboard_entry = array{}

        for (Entry : LeaderboardEntries):
            if (Entry.Player <> Player):
                set NewEntries = NewEntries + array{Entry}

        set LeaderboardEntries = NewEntries

    # Obtient le Top N joueurs triés par Souls
    GetTopBySouls<public>(Count : int) : []leaderboard_entry =
        SortedEntries := SortEntriesBySouls(LeaderboardEntries)
        return TakeFirst(SortedEntries, Count)

    # Obtient le Top N joueurs triés par Production
    GetTopByProduction<public>(Count : int) : []leaderboard_entry =
        SortedEntries := SortEntriesByProduction(LeaderboardEntries)
        return TakeFirst(SortedEntries, Count)

    # Obtient le Top N joueurs triés par Prestige
    GetTopByPrestige<public>(Count : int) : []leaderboard_entry =
        SortedEntries := SortEntriesByPrestige(LeaderboardEntries)
        return TakeFirst(SortedEntries, Count)

    # Trie les entrées par Souls (décroissant)
    SortEntriesBySouls(Entries : []leaderboard_entry) : []leaderboard_entry =
        if (Entries.Length <= 1):
            return Entries

        # Tri à bulles simple (suffisant pour petit nombre de joueurs)
        var Sorted : []leaderboard_entry = Entries
        var Changed : logic = true

        loop:
            if (Changed = false):
                break

            set Changed = false

            for (Index := 0..Sorted.Length - 1):
                if:
                    Current := Sorted[Index]
                    Next := Sorted[Index + 1]
                then:
                    if (Current.Souls < Next.Souls):
                        # Échange
                        var NewSorted : []leaderboard_entry = array{}

                        for (I := 0..Sorted.Length):
                            if (I = Index):
                                set NewSorted = NewSorted + array{Next}
                            else if (I = Index + 1):
                                set NewSorted = NewSorted + array{Current}
                            else if (Item := Sorted[I]):
                                set NewSorted = NewSorted + array{Item}

                        set Sorted = NewSorted
                        set Changed = true

        return Sorted

    # Trie les entrées par Production (décroissant)
    SortEntriesByProduction(Entries : []leaderboard_entry) : []leaderboard_entry =
        if (Entries.Length <= 1):
            return Entries

        var Sorted : []leaderboard_entry = Entries
        var Changed : logic = true

        loop:
            if (Changed = false):
                break

            set Changed = false

            for (Index := 0..Sorted.Length - 1):
                if:
                    Current := Sorted[Index]
                    Next := Sorted[Index + 1]
                then:
                    if (Current.SoulsPerSecond < Next.SoulsPerSecond):
                        var NewSorted : []leaderboard_entry = array{}

                        for (I := 0..Sorted.Length):
                            if (I = Index):
                                set NewSorted = NewSorted + array{Next}
                            else if (I = Index + 1):
                                set NewSorted = NewSorted + array{Current}
                            else if (Item := Sorted[I]):
                                set NewSorted = NewSorted + array{Item}

                        set Sorted = NewSorted
                        set Changed = true

        return Sorted

    # Trie les entrées par Prestige (décroissant)
    SortEntriesByPrestige(Entries : []leaderboard_entry) : []leaderboard_entry =
        if (Entries.Length <= 1):
            return Entries

        var Sorted : []leaderboard_entry = Entries
        var Changed : logic = true

        loop:
            if (Changed = false):
                break

            set Changed = false

            for (Index := 0..Sorted.Length - 1):
                if:
                    Current := Sorted[Index]
                    Next := Sorted[Index + 1]
                then:
                    if (Current.PrestigeFragments < Next.PrestigeFragments):
                        var NewSorted : []leaderboard_entry = array{}

                        for (I := 0..Sorted.Length):
                            if (I = Index):
                                set NewSorted = NewSorted + array{Next}
                            else if (I = Index + 1):
                                set NewSorted = NewSorted + array{Current}
                            else if (Item := Sorted[I]):
                                set NewSorted = NewSorted + array{Item}

                        set Sorted = NewSorted
                        set Changed = true

        return Sorted

    # Prend les N premiers éléments d'un tableau
    TakeFirst(Entries : []leaderboard_entry, Count : int) : []leaderboard_entry =
        var Result : []leaderboard_entry = array{}
        var Taken : int = 0

        for (Entry : Entries):
            if (Taken < Count):
                set Result = Result + array{Entry}
                set Taken += 1

        return Result

    # Obtient le nom d'un joueur
    GetPlayerName(Player : player) : string =
        # Pour l'instant, retourne un nom générique
        # En production, vous pouvez utiliser un système de noms personnalisés
        return "Joueur"

    # Génère le texte formaté pour le billboard du Top Souls
    GenerateTopSoulsText<public>(UIManager : totem_ui_manager) : string =
        TopEntries := GetTopBySouls(5)

        var Text : string = "=== TOP SOULS ===\n"
        var Rank : int = 1

        for (Entry : TopEntries):
            SoulsText := UIManager.FormatInt(Entry.Souls)
            set Text = "{Text}{Rank}. {Entry.DisplayName}: {SoulsText}\n"
            set Rank += 1

        if (TopEntries.Length = 0):
            set Text = "{Text}Aucun joueur"

        return Text

    # Génère le texte formaté pour le billboard du Top Production
    GenerateTopProductionText<public>(UIManager : totem_ui_manager) : string =
        TopEntries := GetTopByProduction(5)

        var Text : string = "=== TOP PRODUCTION ===\n"
        var Rank : int = 1

        for (Entry : TopEntries):
            ProductionText := UIManager.FormatNumber(Entry.SoulsPerSecond)
            set Text = "{Text}{Rank}. {Entry.DisplayName}: {ProductionText}/s\n"
            set Rank += 1

        if (TopEntries.Length = 0):
            set Text = "{Text}Aucun joueur"

        return Text

    # Génère le texte formaté pour le billboard du Top Prestige
    GenerateTopPrestigeText<public>(UIManager : totem_ui_manager) : string =
        TopEntries := GetTopByPrestige(5)

        var Text : string = "=== TOP PRESTIGE ===\n"
        var Rank : int = 1

        for (Entry : TopEntries):
            set Text = "{Text}{Rank}. {Entry.DisplayName}: {Entry.PrestigeFragments} fragments\n"
            set Rank += 1

        if (TopEntries.Length = 0):
            set Text = "{Text}Aucun joueur"

        return Text

# =========================================================================
# NOTES D'UTILISATION
# =========================================================================
#
# Ce système gère 3 types de classements :
# 1. Top Souls : Joueurs avec le plus d'âmes
# 2. Top Production : Joueurs avec la meilleure production/sec
# 3. Top Prestige : Joueurs avec le plus de fragments
#
# Pour afficher dans UEFN :
# 1. Créez 3 billboard_device dans votre île
# 2. Configurez-les dans TotemClicker_Devices.verse
# 3. Le leaderboard se met à jour automatiquement
#
# =========================================================================
