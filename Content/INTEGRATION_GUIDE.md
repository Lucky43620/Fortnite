# 🔧 GUIDE D'INTÉGRATION - TOTEM CLICKER

## 📋 Vue d'ensemble

Ce guide explique comment intégrer les 6 nouveaux systèmes dans votre code existant.

---

## 🗂️ FICHIERS CRÉÉS

Nouveaux fichiers ajoutés à votre projet :

```
Content/
├── TotemClicker_Leaderboard.verse       ✅ Nouveau
├── TotemClicker_Achievements.verse      ✅ Nouveau
├── TotemClicker_Statistics.verse        ✅ Nouveau
├── TotemClicker_Quests.verse            ✅ Nouveau
├── TotemClicker_Events.verse            ✅ Nouveau
├── TotemClicker_Combo.verse             ✅ Nouveau
├── TotemClicker_Persistence.verse       🔄 Modifié
├── TotemClicker_Core.verse              🔄 À modifier
├── TotemClicker_Devices.verse           🔄 À modifier
└── (autres fichiers existants...)
```

---

## 🔨 MODIFICATIONS NÉCESSAIRES

### 1. TotemClicker_Core.verse

#### A. Ajouter les instances des nouveaux systèmes

**Localisation :** Dans la classe `totem_clicker_core`, section SYSTÈMES

**Ajouter après la ligne avec `var ClickHandler`:**

```verse
var Leaderboard : totem_leaderboard_manager = totem_leaderboard_manager{}
var Achievements : totem_achievements_manager = totem_achievements_manager{}
var Statistics : totem_statistics_manager = totem_statistics_manager{}
var Quests : totem_quests_manager = totem_quests_manager{}
var Events : totem_events_manager = totem_events_manager{}
var Combo : totem_combo_manager = totem_combo_manager{}
```

#### B. Initialiser les systèmes

**Localisation :** Dans la fonction `Initialize<public>()`

**Ajouter après `Print("Using UEFN Persistence API for automatic saves")`:**

```verse
# Initialise les nouveaux systèmes
Leaderboard.Initialize()
Achievements.Initialize()
Statistics.Initialize()
Quests.Initialize()
Events.Initialize()
Combo.Initialize()

# Démarre les events automatiques
spawn:
    Events.StartAutoEvents()
```

#### C. Initialiser les joueurs dans les nouveaux systèmes

**Localisation :** Dans la fonction `InitPlayer<public>(Player : player)`

**Ajouter après `if (set PlayerStates[Player] = NewState) {}`:**

```verse
# Initialise les nouveaux systèmes pour ce joueur
Achievements.InitializePlayer(Player)
Statistics.InitializePlayer(Player)
Quests.InitializePlayer(Player)
Events.InitializePlayer(Player)
Combo.InitializePlayer(Player)

# Restaure les achievements
Achievements.RestorePlayerAchievements(Player, SavedData.AchievementsUnlocked)

# Restaure les statistiques
Statistics.RestorePlayerStats(
    Player,
    SavedData.StatTotalClicks,
    SavedData.StatSoulsFromClicks,
    SavedData.StatSoulsFromProduction,
    SavedData.StatTotalPlayTime,
    SavedData.StatTotalGeneratorsPurchased,
    SavedData.StatMostExpensiveGeneratorOwned,
    SavedData.StatTotalUpgradesPurchased,
    SavedData.StatClickUpgradesPurchased,
    SavedData.StatGlobalUpgradesPurchased,
    SavedData.StatTotalPrestiges,
    SavedData.StatTotalFragmentsEarned,
    SavedData.StatHighestSoulsReached,
    SavedData.StatHighestProductionReached,
    SavedData.StatFastestMillionSeconds
)

# Restaure les quêtes
Quests.RestorePlayerQuests(Player, SavedData.QuestsCompleted, SavedData.QuestsProgress)

# Met à jour le leaderboard initial
Leaderboard.UpdatePlayerEntry(Player, NewState.Souls, NewState.SoulsPerSecond, NewState.PrestigeFragments)
```

#### D. Mettre à jour la boucle de production

**Localisation :** Dans la fonction `StartProductionLoop<public>()`

**Remplacer la boucle existante par:**

```verse
loop:
    Sleep(1.0)  # 1 tick par seconde

    # Met à jour le système de combos
    Combo.UpdateCombos(1.0)

    # Pour chaque joueur, ajoute la production
    AllPlayers := GetPlayspace().GetPlayers()
    for (Player : AllPlayers):
        if (State := PlayerStates[Player]):
            # Vérifie les events actifs
            Events.UpdateEvents(Player, 1.0)

            # Applique le multiplicateur d'event de production
            ProductionMultiplier := Events.GetProductionMultiplier(Player)
            AdjustedSoulsPerSecond := State.SoulsPerSecond * ProductionMultiplier

            if (AdjustedSoulsPerSecond > 0.0):
                # Accumule les fractions
                set State.SoulsFractionalAccumulator += AdjustedSoulsPerSecond

                # Quand on atteint 1.0 ou plus, on ajoute les souls entières
                if (State.SoulsFractionalAccumulator >= 1.0):
                    if (SoulsToAdd := Floor[State.SoulsFractionalAccumulator]):
                        State.AddSouls(SoulsToAdd)

                        # Statistiques : enregistre la production
                        if (StatsManager := Statistics.GetPlayerStats(Player)):
                            if (Stats := StatsManager):
                                Stats.RecordProduction(SoulsToAdd)

                        # Garde la fraction restante
                        FloatSoulsToAdd := SoulsToAdd * 1.0
                        set State.SoulsFractionalAccumulator -= FloatSoulsToAdd

                        # Sauvegarde automatique
                        PersistenceManager.UpdateSouls(Player, State.Souls)
                        PersistenceManager.UpdateFractionalAccumulator(Player, State.SoulsFractionalAccumulator)
                        PersistenceManager.UpdateTotalSoulsEarned(Player, State.TotalSoulsEarned)

            # Met à jour les statistiques (temps de jeu et records)
            Statistics.UpdateLoop(Player, State.Souls, State.SoulsPerSecond, 1.0)

            # Vérifie les achievements
            Achievements.CheckSoulsAchievements(Player, State.TotalSoulsEarned)
            Achievements.CheckProductionAchievements(Player, State.SoulsPerSecond)

            # Met à jour les quêtes
            Quests.UpdateQuestProgress(Player, quest_type.EARN_SOULS, State.TotalSoulsEarned)

            # Met à jour le leaderboard
            Leaderboard.UpdatePlayerEntry(Player, State.Souls, State.SoulsPerSecond, State.PrestigeFragments)
```

#### E. Mettre à jour HandleTotemClick

**Localisation :** Dans la fonction `HandleTotemClick<public>(Player : player)`

**Remplacer le contenu par:**

```verse
if (State := PlayerStates[Player]):
    # Obtient les multiplicateurs
    ClickMultiplier := Events.GetClickMultiplier(Player)
    ComboMultiplier := Combo.RecordClick(Player)

    # Calcule le gain du clic avec tous les multiplicateurs
    BaseGain := ClickHandler.ProcessClick(State.SoulsPerClick, State.PrestigeMultiplier)
    Gain := Floor[BaseGain * ClickMultiplier * ComboMultiplier]

    if (FinalGain := Gain):
        # Ajoute les âmes
        State.AddSouls(FinalGain)

        # Statistiques : enregistre le clic
        if (StatsManager := Statistics.GetPlayerStats(Player)):
            if (Stats := StatsManager):
                Stats.RecordClick(FinalGain)

        # Sauvegarde automatique
        PersistenceManager.UpdateSouls(Player, State.Souls)
        PersistenceManager.UpdateTotalSoulsEarned(Player, State.TotalSoulsEarned)

        # Vérifie les achievements
        if (StatsManager2 := Statistics.GetPlayerStats(Player)):
            if (Stats2 := StatsManager2):
                Achievements.CheckClickAchievements(Player, Stats2.TotalClicks)

        # Met à jour les quêtes
        if (StatsManager3 := Statistics.GetPlayerStats(Player)):
            if (Stats3 := StatsManager3):
                Quests.UpdateQuestProgress(Player, quest_type.CLICK_COUNT, Stats3.TotalClicks)

        Print("Player clicked - Gained {FinalGain} souls (Total: {State.Souls})")
else:
    Print("Player not initialized - initializing now...")
    InitPlayer(Player)
```

#### F. Mettre à jour BuyGenerator

**Localisation :** Dans la fonction `BuyGenerator<public>(Player : player, GeneratorIndex : int)`

**Après le code de recalcul de production, ajouter:**

```verse
# Statistiques : enregistre l'achat
if (StatsManager := Statistics.GetPlayerStats(Player)):
    if (Stats := StatsManager):
        Stats.RecordGeneratorPurchase(GeneratorIndex)

        # Vérifie si c'est le premier générateur
        FirstPurchase := if (Stats.TotalGeneratorsPurchased = 1) then true else false

        # Vérifie les achievements
        Achievements.CheckGeneratorAchievements(Player, State.GeneratorLevels, FirstPurchase)

        # Met à jour les quêtes
        Quests.UpdateQuestProgress(Player, quest_type.BUY_GENERATORS, Stats.TotalGeneratorsPurchased)
```

#### G. Mettre à jour BuyClickUpgrade

**Localisation :** Dans la fonction `BuyClickUpgrade<public>(Player : player)`

**Après la mise à jour de SoulsPerClick, ajouter:**

```verse
# Statistiques : enregistre l'achat
if (StatsManager := Statistics.GetPlayerStats(Player)):
    if (Stats := StatsManager):
        Stats.RecordClickUpgrade()

        FirstUpgrade := if (Stats.TotalUpgradesPurchased = 1) then true else false

        # Vérifie les achievements
        Achievements.CheckUpgradeAchievements(Player, Stats.TotalUpgradesPurchased, FirstUpgrade)

        # Met à jour les quêtes
        Quests.UpdateQuestProgress(Player, quest_type.BUY_UPGRADES, Stats.TotalUpgradesPurchased)
```

#### H. Mettre à jour BuyGlobalUpgrade

**Localisation :** Dans la fonction `BuyGlobalUpgrade<public>(Player : player, UpgradeIndex : int)`

**Après la mise à jour du multiplicateur global, ajouter:**

```verse
# Statistiques : enregistre l'achat
if (StatsManager := Statistics.GetPlayerStats(Player)):
    if (Stats := StatsManager):
        Stats.RecordGlobalUpgrade()

        FirstUpgrade := if (Stats.TotalUpgradesPurchased = 1) then true else false

        # Vérifie les achievements
        Achievements.CheckUpgradeAchievements(Player, Stats.TotalUpgradesPurchased, FirstUpgrade)

        # Met à jour les quêtes
        Quests.UpdateQuestProgress(Player, quest_type.BUY_UPGRADES, Stats.TotalUpgradesPurchased)
```

#### I. Mettre à jour ActivatePrestige

**Localisation :** Dans la fonction `ActivatePrestige<public>(Player : player)`

**Après le code de prestige, ajouter:**

```verse
# Statistiques : enregistre le prestige
if (StatsManager := Statistics.GetPlayerStats(Player)):
    if (Stats := StatsManager):
        Stats.RecordPrestige(FragmentsGained)

        # Vérifie les achievements
        Achievements.CheckPrestigeAchievements(Player, State.PrestigeFragments, Stats.TotalPrestiges)

# Reset le combo
Combo.ResetPlayerCombo(Player)
```

---

### 2. TotemClicker_Devices.verse

#### A. Ajouter les devices éditables

**Localisation :** Après les devices existants (PrestigeButton)

**Ajouter:**

```verse
# ============================================
# NOUVEAUX DEVICES - LEADERBOARD
# ============================================

@editable
LeaderboardSoulsBillboard : billboard_device = billboard_device{}

@editable
LeaderboardProductionBillboard : billboard_device = billboard_device{}

@editable
LeaderboardPrestigeBillboard : billboard_device = billboard_device{}

# ============================================
# NOUVEAUX DEVICES - ACHIEVEMENTS
# ============================================

@editable
AchievementsBillboard : billboard_device = billboard_device{}

# ============================================
# NOUVEAUX DEVICES - STATISTIQUES
# ============================================

@editable
StatisticsBillboard : billboard_device = billboard_device{}

# ============================================
# NOUVEAUX DEVICES - QUÊTES
# ============================================

@editable
QuestsBillboard : billboard_device = billboard_device{}

@editable
ClaimQuestsButton : button_device = button_device{}

# ============================================
# NOUVEAUX DEVICES - EVENTS
# ============================================

@editable
EventBillboard : billboard_device = billboard_device{}

# ============================================
# NOUVEAUX DEVICES - COMBO
# ============================================

@editable
ComboBillboard : billboard_device = billboard_device{}
```

#### B. Ajouter une boucle de mise à jour des billboards

**Localisation :** Dans la fonction `OnBegin<override>()`

**Après `spawn { Core.StartProductionLoop() }`, ajouter:**

```verse
# Démarre la boucle de mise à jour des billboards
spawn:
    UpdateBillboards()
```

#### C. Créer la fonction UpdateBillboards

**Localisation :** Après la fonction `OnPrestigeClicked`

**Ajouter:**

```verse
# ============================================
# MISE À JOUR DES BILLBOARDS
# ============================================

# Met à jour tous les billboards (appelé en boucle)
UpdateBillboards()<suspends> : void =
    loop:
        Sleep(2.0)  # Mise à jour toutes les 2 secondes

        # Met à jour les leaderboards
        LeaderboardSoulsText := Core.Leaderboard.GenerateTopSoulsText(Core.UI)
        LeaderboardSoulsBillboard.SetText(LeaderboardSoulsText)

        LeaderboardProductionText := Core.Leaderboard.GenerateTopProductionText(Core.UI)
        LeaderboardProductionBillboard.SetText(LeaderboardProductionText)

        LeaderboardPrestigeText := Core.Leaderboard.GenerateTopPrestigeText(Core.UI)
        LeaderboardPrestigeBillboard.SetText(LeaderboardPrestigeText)

        # Met à jour les billboards pour chaque joueur
        AllPlayers := GetPlayspace().GetPlayers()
        for (Player : AllPlayers):
            # Achievements
            AchievementsText := Core.Achievements.GenerateAchievementsText(Player)
            # Note : Pour un billboard par joueur, vous devrez créer plusieurs billboards
            # Pour l'instant, affiche les achievements du premier joueur
            if (AllPlayers.Length > 0):
                if (FirstPlayer := AllPlayers[0]):
                    FirstAchievementsText := Core.Achievements.GenerateAchievementsText(FirstPlayer)
                    AchievementsBillboard.SetText(FirstAchievementsText)

            # Statistiques
            StatsText := Core.Statistics.GenerateStatsText(Player, Core.UI)
            # Pour l'instant, affiche les stats du premier joueur
            if (AllPlayers.Length > 0):
                if (FirstPlayer := AllPlayers[0]):
                    FirstStatsText := Core.Statistics.GenerateStatsText(FirstPlayer, Core.UI)
                    StatisticsBillboard.SetText(FirstStatsText)

            # Quêtes
            QuestsText := Core.Quests.GenerateQuestsText(Player)
            if (AllPlayers.Length > 0):
                if (FirstPlayer := AllPlayers[0]):
                    FirstQuestsText := Core.Quests.GenerateQuestsText(FirstPlayer)
                    QuestsBillboard.SetText(FirstQuestsText)

            # Event actif
            EventText := Core.Events.GenerateEventText(Player)
            if (AllPlayers.Length > 0):
                if (FirstPlayer := AllPlayers[0]):
                    FirstEventText := Core.Events.GenerateEventText(FirstPlayer)
                    EventBillboard.SetText(FirstEventText)

            # Combo
            ComboText := Core.Combo.GenerateComboText(Player)
            if (AllPlayers.Length > 0):
                if (FirstPlayer := AllPlayers[0]):
                    FirstComboText := Core.Combo.GenerateComboText(FirstPlayer)
                    ComboBillboard.SetText(FirstComboText)

# Gère le clic sur le bouton de réclamation des quêtes
OnClaimQuestsClicked(Agent : agent) : void =
    if (Player := player[Agent]):
        spawn { ClaimQuestRewards(Player) }

# Réclame toutes les récompenses de quêtes
ClaimQuestRewards(Player : player)<suspends> : void =
    TotalReward := Core.Quests.ClaimAllRewards(Player)

    if (TotalReward > 0):
        # Ajoute les âmes au joueur
        if (State := Core.GetPlayerState(Player)):
            if (PlayerState := State):
                PlayerState.AddSouls(TotalReward)

                # Sauvegarde
                Core.PersistenceManager.UpdateSouls(Player, PlayerState.Souls)

                Print("Recompenses de quetes reclamees: {TotalReward} ames!")
    else:
        Print("Aucune recompense a reclamer")
```

#### D. Connecter l'event du bouton de quêtes

**Localisation :** Dans la fonction `ConnectDeviceEvents()`

**Ajouter après `PrestigeButton.InteractedWithEvent.Subscribe(OnPrestigeClicked)`:**

```verse
# Quêtes
ClaimQuestsButton.InteractedWithEvent.Subscribe(OnClaimQuestsClicked)
```

---

## ✅ CHECKLIST D'INTÉGRATION

- [ ] Modifier TotemClicker_Core.verse (sections A à I)
- [ ] Modifier TotemClicker_Devices.verse (sections A à D)
- [ ] Compiler le projet (vérifier qu'il n'y a pas d'erreurs)
- [ ] Placer les 8 billboards dans votre île UEFN
- [ ] Placer le bouton "Claim Quests" dans votre île
- [ ] Assigner tous les devices dans l'éditeur UEFN
- [ ] Tester le jeu !

---

## 🎮 TEST RAPIDE

Pour vérifier que tout fonctionne :

1. **Leaderboard** : Jouez avec plusieurs joueurs, vérifiez le classement
2. **Achievements** : Cliquez plusieurs fois, vérifiez que "Premier Clic" se débloque
3. **Statistiques** : Vérifiez que le nombre de clics augmente
4. **Quêtes** : Cliquez 50 fois, réclamez la récompense
5. **Events** : Attendez 3 minutes, un event devrait apparaître
6. **Combo** : Cliquez rapidement, vérifiez le multiplicateur

---

**Bon courage pour l'intégration ! 🚀**
