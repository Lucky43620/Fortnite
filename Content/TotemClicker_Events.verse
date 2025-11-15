# =========================================================================
# TotemClicker_Events.verse
# =========================================================================
# Rôle : Système d'events temporaires et bonus aléatoires
# Donne des boosts temporaires aux joueurs pour rendre le jeu plus dynamique
# =========================================================================

using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/Diagnostics }

# Type d'event
event_type := enum:
    DOUBLE_CLICK       # x2 puissance de clic
    DOUBLE_PRODUCTION  # x2 production
    SOUL_RAIN          # Bonus d'âmes instantané
    LUCKY_MOMENT       # x5 production pendant un court moment
    MEGA_CLICK         # x10 puissance de clic

# Définition d'un event actif
active_event := class:
    var Type : event_type = event_type.DOUBLE_CLICK
    var Duration : float = 30.0  # Durée en secondes
    var RemainingTime : float = 30.0
    var Multiplier : float = 2.0
    var IsActive : logic = false

# Gestionnaire des events
totem_events_manager := class():

    # Events actifs par joueur
    var PlayerActiveEvents : [player]active_event = map{}

    # Seed pour génération aléatoire (utilise un système simple)
    var RandomSeed : int = 42

    # Initialise le système d'events
    Initialize<public>() : void =
        Print("Events system initialized")

    # Initialise un joueur
    InitializePlayer<public>(Player : player) : void =
        if (PlayerActiveEvents[Player]):
            Print("Player events already initialized")
        else:
            NewEvent := active_event{}
            set NewEvent.IsActive = false
            if (set PlayerActiveEvents[Player] = NewEvent) {}
            Print("Player events initialized")

    # Démarre un event aléatoire pour un joueur
    TriggerRandomEvent<public>(Player : player) : void =
        if (Event := PlayerActiveEvents[Player]):
            # Ne déclenche pas si un event est déjà actif
            if (Event.IsActive = true):
                Print("Event already active, skipping")
                return

            # Choisit un type d'event pseudo-aléatoire (0-4)
            set RandomSeed = (RandomSeed * 1103515245 + 12345)
            var RandomValue : int = 0
            if (ModResult := Mod[RandomSeed, 5]):
                set RandomValue = ModResult

            var SelectedType : event_type = event_type.DOUBLE_CLICK
            var EventDuration : float = 30.0
            var EventMultiplier : float = 2.0
            var EventName : string = "Event"

            if (RandomValue = 0):
                set SelectedType = event_type.DOUBLE_CLICK
                set EventDuration = 30.0
                set EventMultiplier = 2.0
                set EventName = "DOUBLE CLIC x2"
            else if (RandomValue = 1):
                set SelectedType = event_type.DOUBLE_PRODUCTION
                set EventDuration = 45.0
                set EventMultiplier = 2.0
                set EventName = "DOUBLE PRODUCTION x2"
            else if (RandomValue = 2):
                set SelectedType = event_type.SOUL_RAIN
                set EventDuration = 1.0  # Instantané
                set EventMultiplier = 1.0
                set EventName = "PLUIE D'AMES"
            else if (RandomValue = 3):
                set SelectedType = event_type.LUCKY_MOMENT
                set EventDuration = 15.0
                set EventMultiplier = 5.0
                set EventName = "MOMENT CHANCEUX x5"
            else:
                set SelectedType = event_type.MEGA_CLICK
                set EventDuration = 20.0
                set EventMultiplier = 10.0
                set EventName = "MEGA CLIC x10"

            # Active l'event
            set Event.Type = SelectedType
            set Event.Duration = EventDuration
            set Event.RemainingTime = EventDuration
            set Event.Multiplier = EventMultiplier
            set Event.IsActive = true

            Print("=================================")
            Print("EVENT ACTIVE: {EventName}")
            Print("Duree: {EventDuration} secondes")
            Print("=================================")

    # Met à jour les events actifs (appelé chaque seconde)
    UpdateEvents<public>(Player : player, DeltaTime : float) : void =
        if (Event := PlayerActiveEvents[Player]):
            if (Event.IsActive = true):
                set Event.RemainingTime -= DeltaTime

                if (Event.RemainingTime <= 0.0):
                    # Event terminé
                    set Event.IsActive = false
                    set Event.RemainingTime = 0.0
                    Print("Event termine pour le joueur")

    # Vérifie si un event est actif pour un joueur
    HasActiveEvent<public>(Player : player) : logic =
        if (Event := PlayerActiveEvents[Player]):
            return Event.IsActive
        return false

    # Obtient le multiplicateur de clic actuel
    GetClickMultiplier<public>(Player : player) : float =
        if (Event := PlayerActiveEvents[Player]):
            if (Event.IsActive = true):
                if:
                    Event.Type = event_type.DOUBLE_CLICK
                then:
                    return Event.Multiplier
                else if:
                    Event.Type = event_type.MEGA_CLICK
                then:
                    return Event.Multiplier

        return 1.0  # Pas de bonus

    # Obtient le multiplicateur de production actuel
    GetProductionMultiplier<public>(Player : player) : float =
        if (Event := PlayerActiveEvents[Player]):
            if (Event.IsActive = true):
                if:
                    Event.Type = event_type.DOUBLE_PRODUCTION
                then:
                    return Event.Multiplier
                else if:
                    Event.Type = event_type.LUCKY_MOMENT
                then:
                    return Event.Multiplier

        return 1.0  # Pas de bonus

    # Vérifie si c'est un event Soul Rain
    IsSoulRainActive<public>(Player : player) : logic =
        if (Event := PlayerActiveEvents[Player]):
            if:
                Event.IsActive = true
                Event.Type = event_type.SOUL_RAIN
            then:
                return true

        return false

    # Calcule le bonus de Soul Rain (âmes instantanées)
    CalculateSoulRainBonus<public>(PlayerCurrentSouls : int) : int =
        # Donne 10% des âmes actuelles (min 1000, max 100000)
        BonusFloat := PlayerCurrentSouls * 0.1
        var Bonus : int = 1000

        if (BonusInt := Floor[BonusFloat]):
            set Bonus = BonusInt

        if (Bonus < 1000):
            set Bonus = 1000
        else if (Bonus > 100000):
            set Bonus = 100000

        return Bonus

    # Génère le texte d'affichage de l'event actif
    GenerateEventText<public>(Player : player) : string =
        if (Event := PlayerActiveEvents[Player]):
            if (Event.IsActive = true):
                var EventName : string = "Event Actif"

                if (Event.Type = event_type.DOUBLE_CLICK):
                    set EventName = "DOUBLE CLIC x2"
                else if (Event.Type = event_type.DOUBLE_PRODUCTION):
                    set EventName = "DOUBLE PRODUCTION x2"
                else if (Event.Type = event_type.SOUL_RAIN):
                    set EventName = "PLUIE D'AMES"
                else if (Event.Type = event_type.LUCKY_MOMENT):
                    set EventName = "MOMENT CHANCEUX x5"
                else if (Event.Type = event_type.MEGA_CLICK):
                    set EventName = "MEGA CLIC x10"

                if (SecondsLeft := Floor[Event.RemainingTime]):
                    return "=== EVENT ACTIF ===\n{EventName}\nTemps restant: {SecondsLeft}s"

        return "Aucun event actif"

    # Démarre automatiquement des events aléatoires (appelé périodiquement)
    # Cette fonction doit être appelée depuis le Core avec spawn
    StartAutoEvents<public>()<suspends> : void =
        loop:
            # Attend 3 minutes avant le prochain event
            Sleep(180.0)

            # Déclenche l'event pour tous les joueurs actifs
            # Note: GetPlayspace() doit être appelé depuis un creative_device
            Print("Event auto-trigger (call TriggerRandomEvent manually from Core)")

# =========================================================================
# NOTES D'UTILISATION
# =========================================================================
#
# Ce système gère 5 types d'events temporaires :
# 1. DOUBLE CLICK : x2 puissance de clic pendant 30s
# 2. DOUBLE PRODUCTION : x2 production pendant 45s
# 3. SOUL RAIN : Bonus d'âmes instantané (10% des âmes actuelles)
# 4. LUCKY MOMENT : x5 production pendant 15s
# 5. MEGA CLICK : x10 puissance de clic pendant 20s
#
# Les events se déclenchent automatiquement toutes les 2-5 minutes
# Un seul event peut être actif à la fois par joueur
#
# Pour afficher dans UEFN :
# 1. Créez un billboard_device pour afficher l'event actif
# 2. Le système se met à jour automatiquement
#
# =========================================================================
