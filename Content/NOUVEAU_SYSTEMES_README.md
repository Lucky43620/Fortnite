# 🎮 TOTEM CLICKER - NOUVEAUX SYSTÈMES

## 📋 Vue d'ensemble

Votre jeu Totem Clicker a été amélioré avec **6 nouveaux systèmes** majeurs qui rendent le jeu beaucoup plus riche et engageant !

---

## 🆕 Systèmes Ajoutés

### 1. 📊 **LEADERBOARD** (TotemClicker_Leaderboard.verse)
**Description :** Classement des joueurs en temps réel

**Fonctionnalités :**
- Top 5 joueurs par nombre d'âmes
- Top 5 joueurs par production/seconde
- Top 5 joueurs par fragments de prestige
- Mise à jour automatique

**À configurer dans UEFN :**
- 3 billboard_device (un pour chaque classement)

---

### 2. 🏆 **ACHIEVEMENTS** (TotemClicker_Achievements.verse)
**Description :** 20 succès à débloquer

**Catégories d'achievements :**
- **Progression** : Premier Clic, Cent Âmes, Premier Million, Milliardaire
- **Générateurs** : Premier Générateur, Collectionneur, Empire Totémique
- **Production** : Production Automatique, Usine à Âmes, Megafactory
- **Prestige** : Premier Prestige, Maître du Prestige, Légende Éternelle
- **Clics** : Clicker Amateur/Professionnel/Maître
- **Upgrades** : Premier Upgrade, Optimiseur, Perfectionniste

**Sauvegarde :** Oui, les achievements persistent entre sessions

---

### 3. 📈 **STATISTIQUES** (TotemClicker_Statistics.verse)
**Description :** Tracking détaillé de toutes les actions

**Stats trackées :**
- Total de clics effectués
- Âmes gagnées par clics vs production
- Temps de jeu total
- Générateurs achetés
- Upgrades achetés
- Prestiges effectués
- **Records personnels** :
  - Maximum d'âmes atteint
  - Maximum de production/sec
  - Temps le plus rapide pour atteindre 1M âmes

**Sauvegarde :** Oui, toutes les stats sont sauvegardées

---

### 4. 🎯 **QUÊTES** (TotemClicker_Quests.verse)
**Description :** 15 quêtes avec récompenses

**Types de quêtes :**
- **Clics** : Cliquer 50/200/1000 fois
- **Âmes** : Gagner 5K/100K/10M âmes
- **Générateurs** : Acheter 1/10/50 générateurs
- **Upgrades** : Acheter 5/20/50 upgrades
- **Production** : Atteindre 10/1K/100K âmes/sec

**Récompenses :** Chaque quête donne des âmes bonus
**Répétables :** Oui ! Après avoir réclamé la récompense, la quête redémarre

**À configurer dans UEFN :**
- 1 billboard_device pour afficher les quêtes
- 1 button_device pour réclamer les récompenses

---

### 5. ⚡ **EVENTS TEMPORAIRES** (TotemClicker_Events.verse)
**Description :** Bonus aléatoires toutes les 3 minutes

**Types d'events :**
| Event | Effet | Durée |
|-------|-------|-------|
| Double Clic | x2 puissance de clic | 30s |
| Double Production | x2 production | 45s |
| Pluie d'Âmes | Bonus instantané (10% des âmes) | Instant |
| Moment Chanceux | x5 production | 15s |
| Mega Clic | x10 puissance de clic | 20s |

**Automatique :** Les events se déclenchent automatiquement toutes les 3 minutes

**À configurer dans UEFN :**
- 1 billboard_device pour afficher l'event actif

---

### 6. 🔥 **COMBO DE CLICS** (TotemClicker_Combo.verse)
**Description :** Multiplicateur pour clics rapides

**Fonctionnement :**
- Cliquer dans les 0.5 secondes = combo continue
- Formule : Multiplicateur = 1 + (Nombre de clics * 0.1)
- **Maximum : x5.0** (atteint à 40+ clics rapides)
- Se reset après 2 secondes sans clic

**Exemples :**
- 10 clics rapides = x2.0
- 20 clics rapides = x3.0
- 40+ clics rapides = x5.0

**À configurer dans UEFN :**
- 1 billboard_device pour afficher le combo actuel

---

## 🔧 CONFIGURATION DANS UEFN

### Devices à ajouter dans votre île :

#### **Billboards (8 au total)**
1. Leaderboard Souls (Top âmes)
2. Leaderboard Production (Top production)
3. Leaderboard Prestige (Top prestige)
4. Achievements (Liste des succès)
5. Statistiques (Stats du joueur)
6. Quêtes (Liste des quêtes)
7. Event Actif (Event en cours)
8. Combo (Combo de clics)

#### **Buttons (2 au total)**
1. Bouton "Réclamer Récompenses de Quêtes"
2. Bouton "Afficher Stats/Achievements" (optionnel)

---

## 💾 SYSTÈME DE SAUVEGARDE

**Tout est automatiquement sauvegardé !**

Le fichier `TotemClicker_Persistence.verse` a été mis à jour pour sauvegarder :
- ✅ Achievements débloqués (20)
- ✅ Statistiques complètes (14 stats)
- ✅ Progression des quêtes (15 quêtes)
- ✅ Toutes les données existantes (souls, générateurs, upgrades, prestige)

**Format de sauvegarde :**
```
totem_player_data:
  - Souls, SoulsPerClick, SoulsPerSecond
  - GeneratorLevels (20)
  - ClickUpgradeLevel, GlobalMultiplier
  - GlobalUpgradesPurchased (50)
  - PrestigeFragments, PrestigeMultiplier
  - AchievementsUnlocked (20)  <-- NOUVEAU
  - StatTotalClicks, StatSoulsFromClicks, ...  <-- NOUVEAU
  - QuestsCompleted (15), QuestsProgress (15)  <-- NOUVEAU
```

---

## 📝 PROCHAINES ÉTAPES

### Étape 1 : Mise à jour du Core
Le fichier `TotemClicker_Core.verse` doit être modifié pour :
1. Initialiser les nouveaux systèmes
2. Les appeler dans les bonnes fonctions
3. Charger/sauvegarder les nouvelles données

**Je vais créer ce fichier pour vous !**

### Étape 2 : Mise à jour des Devices
Le fichier `TotemClicker_Devices.verse` doit être modifié pour :
1. Ajouter les devices éditables (billboards, buttons)
2. Connecter les events
3. Mettre à jour l'affichage

**Je vais créer ce fichier pour vous !**

### Étape 3 : Configuration dans l'éditeur UEFN
1. Ouvrez votre projet dans UEFN
2. Placez les billboard_device et button_device dans votre île
3. Sélectionnez le `totem_clicker_device`
4. Assignez chaque device aux slots correspondants
5. Testez !

---

## 🎯 EXEMPLES D'UTILISATION

### Afficher les achievements d'un joueur
```verse
AchievementsText := Achievements.GenerateAchievementsText(Player)
AchievementsBillboard.SetText(AchievementsText)
```

### Vérifier si une quête est complétée
```verse
Quests.UpdateQuestProgress(Player, quest_type.CLICK_COUNT, TotalClicks)
```

### Obtenir le multiplicateur de combo
```verse
ComboMult := ComboManager.RecordClick(Player)
SoulsGained := BaseSouls * ComboMult
```

### Déclencher un event manuel
```verse
EventsManager.TriggerRandomEvent(Player)
```

---

## 📊 IMPACT SUR LE GAMEPLAY

### Avant
- Cliquer pour gagner des âmes
- Acheter des générateurs
- Faire des upgrades
- Prestige

### Après
- **+ Leaderboard** : Compétition entre joueurs
- **+ Achievements** : 20 objectifs à long terme
- **+ Statistiques** : Voir sa progression détaillée
- **+ Quêtes** : 15 objectifs avec récompenses
- **+ Events** : Bonus surprises toutes les 3min
- **+ Combos** : Récompense pour clics rapides

### Résultat
🎮 **Un jeu beaucoup plus engageant et addictif !**

---

## ⚠️ NOTES IMPORTANTES

1. **Compatibilité** : Tous les nouveaux systèmes sont compatibles avec votre code existant
2. **Performance** : Les systèmes sont optimisés pour ne pas ralentir le jeu
3. **Extensibilité** : Vous pouvez facilement ajouter plus d'achievements, quêtes, etc.
4. **Sauvegarde** : Tout est automatiquement sauvegardé via le système de persistance UEFN

---

## 🐛 TROUBLESHOOTING

### Les achievements ne se débloquent pas
➡️ Vérifiez que `Achievements.Initialize()` est appelé au démarrage

### Les quêtes ne se mettent pas à jour
➡️ Vérifiez que `Quests.UpdateQuestProgress()` est appelé dans les bonnes fonctions

### Le leaderboard n'affiche rien
➡️ Vérifiez que `Leaderboard.UpdatePlayerEntry()` est appelé régulièrement

### Les events ne se déclenchent pas
➡️ Vérifiez que `spawn { Events.StartAutoEvents() }` est appelé au démarrage

---

## 📞 SUPPORT

Si vous avez des questions ou des problèmes :
1. Vérifiez que tous les fichiers .verse sont bien dans le dossier Content
2. Vérifiez qu'il n'y a pas d'erreurs de compilation
3. Relisez ce README pour la configuration

---

**Bon jeu ! 🎮🔥**
