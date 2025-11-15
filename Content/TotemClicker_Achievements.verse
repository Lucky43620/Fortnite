# =========================================================================
# TotemClicker_Achievements.verse
# =========================================================================
# Rôle : Système d'achievements/trophées pour récompenser les joueurs
# Gestion des déblocages et de la progression
# =========================================================================

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Définition d'un achievement
achievement_data := struct:
    ID : int
    Name : string
    Description : string
    Icon : string  # Pour référence future (icône personnalisée)
    IsUnlocked : logic

# Gestionnaire des achievements
totem_achievements_manager := class():

    # Liste de tous les achievements disponibles
    var AchievementDefinitions : []achievement_data = array{}

    # Achievements débloqués par joueur
    var PlayerAchievements : [player][]logic = map{}

    # Initialise tous les achievements du jeu
    Initialize<public>() : void =
        set AchievementDefinitions = array{
            # Achievements de progression
            achievement_data{ID := 0, Name := "Premier Clic", Description := "Cliquer sur le totem pour la premiere fois", Icon := "click", IsUnlocked := false},
            achievement_data{ID := 1, Name := "Cent Ames", Description := "Obtenir 100 ames", Icon := "souls", IsUnlocked := false},
            achievement_data{ID := 2, Name := "Millier d'Ames", Description := "Obtenir 1,000 ames", Icon := "souls", IsUnlocked := false},
            achievement_data{ID := 3, Name := "Premier Million", Description := "Obtenir 1,000,000 ames", Icon := "souls", IsUnlocked := false},
            achievement_data{ID := 4, Name := "Milliardaire", Description := "Obtenir 1,000,000,000 ames", Icon := "souls", IsUnlocked := false},

            # Achievements de générateurs
            achievement_data{ID := 5, Name := "Premier Generateur", Description := "Acheter votre premier generateur", Icon := "generator", IsUnlocked := false},
            achievement_data{ID := 6, Name := "Collectionneur", Description := "Acheter au moins 1 de chaque generateur", Icon := "generator", IsUnlocked := false},
            achievement_data{ID := 7, Name := "Empire Totemique", Description := "Avoir 10 generateurs de niveau 10+", Icon := "generator", IsUnlocked := false},

            # Achievements de production
            achievement_data{ID := 8, Name := "Production Automatique", Description := "Atteindre 100 ames/sec", Icon := "production", IsUnlocked := false},
            achievement_data{ID := 9, Name := "Usine a Ames", Description := "Atteindre 10,000 ames/sec", Icon := "production", IsUnlocked := false},
            achievement_data{ID := 10, Name := "Megafactory", Description := "Atteindre 1,000,000 ames/sec", Icon := "production", IsUnlocked := false},

            # Achievements de prestige
            achievement_data{ID := 11, Name := "Premier Prestige", Description := "Effectuer votre premier prestige", Icon := "prestige", IsUnlocked := false},
            achievement_data{ID := 12, Name := "Maitre du Prestige", Description := "Effectuer 10 prestiges", Icon := "prestige", IsUnlocked := false},
            achievement_data{ID := 13, Name := "Legende Eternelle", Description := "Avoir 100 fragments de prestige", Icon := "prestige", IsUnlocked := false},

            # Achievements de clics
            achievement_data{ID := 14, Name := "Clicker Amateur", Description := "Effectuer 100 clics", Icon := "click", IsUnlocked := false},
            achievement_data{ID := 15, Name := "Clicker Professionnel", Description := "Effectuer 1,000 clics", Icon := "click", IsUnlocked := false},
            achievement_data{ID := 16, Name := "Maitre Clicker", Description := "Effectuer 10,000 clics", Icon := "click", IsUnlocked := false},

            # Achievements d'upgrades
            achievement_data{ID := 17, Name := "Premier Upgrade", Description := "Acheter votre premier upgrade", Icon := "upgrade", IsUnlocked := false},
            achievement_data{ID := 18, Name := "Optimiseur", Description := "Acheter 25 upgrades", Icon := "upgrade", IsUnlocked := false},
            achievement_data{ID := 19, Name := "Perfectionniste", Description := "Acheter tous les upgrades disponibles", Icon := "upgrade", IsUnlocked := false}
        }

        Print("Achievements initialized")

    # Initialise un joueur dans le système d'achievements
    InitializePlayer<public>(Player : player) : void =
        if (PlayerAchievements[Player]):
            Print("Player achievements already initialized")
        else:
            # Crée un tableau de 20 achievements (tous débloqués = false)
            NewAchievements := array{
                false, false, false, false, false, false, false, false, false, false,
                false, false, false, false, false, false, false, false, false, false
            }
            if (set PlayerAchievements[Player] = NewAchievements) {}
            Print("Player achievements initialized")

    # Restaure les achievements d'un joueur depuis la sauvegarde
    RestorePlayerAchievements<public>(Player : player, SavedAchievements : []logic) : void =
        if (set PlayerAchievements[Player] = SavedAchievements) {}
        Print("Player achievements restored")

    # Vérifie et débloque un achievement si les conditions sont remplies
    CheckAndUnlockAchievement<public>(Player : player, AchievementID : int) : logic =
        if (Achievements := PlayerAchievements[Player]):
            if (IsUnlocked := Achievements[AchievementID]):
                if (IsUnlocked = false):
                    # Débloque l'achievement
                    var NewAchievements : []logic = array{}
                    for (Index := 0..Achievements.Length):
                        if (Index = AchievementID):
                            set NewAchievements = NewAchievements + array{true}
                        else if (Current := Achievements[Index]):
                            set NewAchievements = NewAchievements + array{Current}

                    if (set PlayerAchievements[Player] = NewAchievements) {}

                    # Affiche un message
                    if (AchievementDef := AchievementDefinitions[AchievementID]):
                        Print("ACHIEVEMENT DEVERROUILLE!")

                    return true  # Nouveau déblocage
                else:
                    return false  # Déjà débloqué

        return false

    # Vérifie les achievements liés aux âmes
    CheckSoulsAchievements<public>(Player : player, TotalSouls : int) : void =
        if (TotalSouls >= 100):
            CheckAndUnlockAchievement(Player, 1)  # Cent Âmes
        if (TotalSouls >= 1000):
            CheckAndUnlockAchievement(Player, 2)  # Millier d'Âmes
        if (TotalSouls >= 1000000):
            CheckAndUnlockAchievement(Player, 3)  # Premier Million
        if (TotalSouls >= 1000000000):
            CheckAndUnlockAchievement(Player, 4)  # Milliardaire

    # Vérifie les achievements liés à la production
    CheckProductionAchievements<public>(Player : player, SoulsPerSecond : float) : void =
        if (SoulsPerSecond >= 100.0):
            CheckAndUnlockAchievement(Player, 8)  # Production Automatique
        if (SoulsPerSecond >= 10000.0):
            CheckAndUnlockAchievement(Player, 9)  # Usine à Âmes
        if (SoulsPerSecond >= 1000000.0):
            CheckAndUnlockAchievement(Player, 10)  # Megafactory

    # Vérifie les achievements liés aux générateurs
    CheckGeneratorAchievements<public>(Player : player, GeneratorLevels : []int, FirstPurchase : logic) : void =
        if (FirstPurchase = true):
            CheckAndUnlockAchievement(Player, 5)  # Premier Générateur

        # Vérifie si tous les générateurs ont au moins niveau 1 (Collectionneur)
        var AllOwned : logic = true
        for (Level : GeneratorLevels):
            if (Level = 0):
                set AllOwned = false

        if (AllOwned = true):
            CheckAndUnlockAchievement(Player, 6)  # Collectionneur

        # Vérifie si 10 générateurs sont niveau 10+ (Empire Totémique)
        var Count10Plus : int = 0
        for (Level : GeneratorLevels):
            if (Level >= 10):
                set Count10Plus += 1

        if (Count10Plus >= 10):
            CheckAndUnlockAchievement(Player, 7)  # Empire Totémique

    # Vérifie les achievements liés au prestige
    CheckPrestigeAchievements<public>(Player : player, PrestigeFragments : int, PrestigeCount : int) : void =
        if (PrestigeCount >= 1):
            CheckAndUnlockAchievement(Player, 11)  # Premier Prestige
        if (PrestigeCount >= 10):
            CheckAndUnlockAchievement(Player, 12)  # Maître du Prestige
        if (PrestigeFragments >= 100):
            CheckAndUnlockAchievement(Player, 13)  # Légende Éternelle

    # Vérifie les achievements liés aux clics
    CheckClickAchievements<public>(Player : player, TotalClicks : int) : void =
        if (TotalClicks >= 1):
            CheckAndUnlockAchievement(Player, 0)  # Premier Clic
        if (TotalClicks >= 100):
            CheckAndUnlockAchievement(Player, 14)  # Clicker Amateur
        if (TotalClicks >= 1000):
            CheckAndUnlockAchievement(Player, 15)  # Clicker Professionnel
        if (TotalClicks >= 10000):
            CheckAndUnlockAchievement(Player, 16)  # Maître Clicker

    # Vérifie les achievements liés aux upgrades
    CheckUpgradeAchievements<public>(Player : player, TotalUpgrades : int, FirstUpgrade : logic) : void =
        if (FirstUpgrade = true):
            CheckAndUnlockAchievement(Player, 17)  # Premier Upgrade

        if (TotalUpgrades >= 25):
            CheckAndUnlockAchievement(Player, 18)  # Optimiseur

        # Pour "Perfectionniste", vérifier si tous les upgrades sont achetés
        # (30 click upgrades + 50 global upgrades = 80 total)
        if (TotalUpgrades >= 80):
            CheckAndUnlockAchievement(Player, 19)  # Perfectionniste

    # Obtient le nombre d'achievements débloqués pour un joueur
    GetUnlockedCount<public>(Player : player) : int =
        var Count : int = 0

        if (Achievements := PlayerAchievements[Player]):
            for (IsUnlocked : Achievements):
                if (IsUnlocked = true):
                    set Count += 1

        return Count

    # Obtient le tableau des achievements débloqués
    GetPlayerAchievements<public>(Player : player) : []logic =
        if (Achievements := PlayerAchievements[Player]):
            return Achievements

        # Retourne un tableau vide si pas trouvé
        return array{
            false, false, false, false, false, false, false, false, false, false,
            false, false, false, false, false, false, false, false, false, false
        }

    # Génère le texte d'affichage des achievements
    GenerateAchievementsText<public>(Player : player) : string =
        UnlockedCount := GetUnlockedCount(Player)
        TotalCount := AchievementDefinitions.Length

        var Text : string = "=== ACHIEVEMENTS ===\n"
        set Text = "{Text}Debloques: {UnlockedCount}/{TotalCount}\n\n"

        if (Achievements := PlayerAchievements[Player]):
            for (Index := 0..AchievementDefinitions.Length):
                if:
                    AchievementDef := AchievementDefinitions[Index]
                    IsUnlocked := Achievements[Index]
                then:
                    if (IsUnlocked = true):
                        set Text = "{Text}[X] {AchievementDef.Name}\n"
                    else:
                        set Text = "{Text}[ ] {AchievementDef.Name}\n"

        return Text

# =========================================================================
# NOTES D'UTILISATION
# =========================================================================
#
# Ce système gère 20 achievements répartis en catégories :
# - Progression (âmes)
# - Générateurs
# - Production
# - Prestige
# - Clics
# - Upgrades
#
# Les achievements se débloquent automatiquement quand les conditions
# sont remplies (vérifié via les fonctions Check...)
#
# Les achievements sont sauvegardés dans le système de persistance
#
# =========================================================================
