# Guide Wireshark - Détection de scans Nmap

## Table des matières
1. [Tâche 0 : IP Protocol Scan](#tache-0)
2. [Tâche 1 : TCP SYN Scan](#tache-1)
3. [Tâche 2 : TCP Connect Scan](#tache-2)
4. [Tâche 3 : TCP FIN Scan](#tache-3)
5. [Tâche 4 : TCP Ping Sweeps](#tache-4)
6. [Tâche 5 : UDP Port Scan](#tache-5)
7. [Tâche 6 : UDP Ping Sweeps](#tache-6)
8. [Tâche 7 : ICMP Ping Sweep](#tache-7)
9. [Tâche 8 : ARP Scanning](#tache-8)
10. [Référence des flags TCP](#flags-tcp)
11. [Démarche de test générale](#test-kali)

---

## Tâche 0 : IP Protocol Scan {#tache-0}

### Objectif
Détecter les paquets envoyés par `nmap -sO <target>`

### Principe
- Nmap teste différents protocoles IP (ICMP, TCP, UDP, etc.)
- Le filtre `icmp` capture spécifiquement les paquets ICMP (protocole IP numéro 1)
- Ces paquets sont générés quand nmap teste le protocole ICMP

### Filtre requis
```
icmp
```

### Explication détaillée du filtre
Le filtre `icmp` est équivalent à `ip.proto == 1` car :
- **ICMP = protocole IP numéro 1**
- Nmap -sO teste tous les protocoles IP mais ICMP est le plus commun à capturer
- Les autres protocoles peuvent ne pas générer de réponses visibles

### Test pratique
```bash
# Terminal 1 : Wireshark avec filtre icmp
# Terminal 2 :
sudo nmap -sO 8.8.8.8
```

### Protocoles IP testés par nmap -sO (référence complète)
| Protocole | Numéro | Description | Filtre Wireshark |
|-----------|---------|-------------|------------------|
| ICMP | 1 | Internet Control Message Protocol | `ip.proto == 1` ou `icmp` |
| IGMP | 2 | Internet Group Management Protocol | `ip.proto == 2` |
| TCP | 6 | Transmission Control Protocol | `ip.proto == 6` ou `tcp` |
| UDP | 17 | User Datagram Protocol | `ip.proto == 17` ou `udp` |
| IPv6-ICMP | 58 | ICMPv6 | `ip.proto == 58` |
| GRE | 47 | Generic Routing Encapsulation | `ip.proto == 47` |
| ESP | 50 | Encapsulating Security Payload | `ip.proto == 50` |
| AH | 51 | Authentication Header | `ip.proto == 51` |
| SCTP | 132 | Stream Control Transmission Protocol | `ip.proto == 132` |

### Pourquoi utiliser `icmp` uniquement ?
- ICMP est le protocole le plus susceptible de générer des réponses visibles
- Les autres protocoles peuvent être bloqués par les firewalls
- ICMP est suffisant pour détecter l'activité de scan IP protocol

---

## Tâche 1 : TCP SYN Scan {#tache-1}

### Objectif
Détecter les paquets envoyés par `nmap -sS <target>`

### Principe
- Envoie des paquets TCP avec uniquement le flag SYN
- Window size caractéristique ≤ 1024 (signature nmap)
- Technique de scan "half-open" (pas de connexion complète)

### Filtre requis
```
tcp.syn == 1 and tcp.ack == 0 and tcp.window_size <= 1024
```

### Explication détaillée du filtre

**`tcp.syn == 1`** : Flag SYN activé
- Valeur binaire : 1 (activé) ou 0 (désactivé)
- SYN = bit 1 du champ flags TCP

**`tcp.ack == 0`** : Flag ACK désactivé
- Valeur binaire : 0 (désactivé)
- ACK = bit 4 du champ flags TCP
- Garantit qu'on capture les SYN purs, pas les SYN+ACK

**`tcp.window_size <= 1024`** : Taille de fenêtre
- Valeurs typiques nmap SYN scan : 1024, 512, 256
- Valeurs typiques connexions normales : 64240, 65535, 8192+
- Cette condition distingue nmap des connexions légitimes

### Test pratique
```bash
# Terminal 1 : Wireshark avec filtre complet
# Terminal 2 :
sudo nmap -sS 8.8.8.8
```

### Signatures distinctives de nmap -sS
- **Window size** : 1024 (signature caractéristique)
- **MSS** : 1460 (Maximum Segment Size)
- **Flags** : SYN uniquement (0x02 en hex)
- **Séquence** : 0
- **Ports source** : Aléatoires et élevés (>32768)

---

## Tâche 2 : TCP Connect Scan {#tache-2}

### Objectif
Détecter les paquets envoyés par `nmap -sT <target>`

### Principe
- Utilise la fonction connect() du système d'exploitation
- Établit une connexion TCP complète (3-way handshake)
- Window size normale du système (pas la signature nmap)

### Filtre requis
```
tcp.syn == 1 and tcp.ack == 0 and tcp.window_size > 1024
```

### Explication détaillée du filtre

**`tcp.syn == 1`** : Flag SYN activé
- Même principe que la tâche 1
- Capture les paquets d'initiation de connexion

**`tcp.ack == 0`** : Flag ACK désactivé
- Filtre les paquets SYN initiaux (pas les SYN+ACK de réponse)

**`tcp.window_size > 1024`** : Taille de fenêtre normale
- **Valeurs typiques système** : 64240, 65535, 29200, 32768
- **Valeurs nmap -sS** : 1024 (artificielle)
- **Seuil 1024** : Distingue les connexions système des scans nmap

### Test pratique
```bash
# Terminal 1 : Wireshark avec filtre complet
# Terminal 2 :
sudo nmap -sT 8.8.8.8
```

### Signatures distinctives de nmap -sT vs nmap -sS

| Caractéristique | nmap -sS | nmap -sT |
|----------------|----------|----------|
| Window size | 1024 | 64240+ |
| Options TCP | Minimales | Complètes (MSS, SACK_PERM, TSval, WS) |
| Connexion | Half-open | Full connect |
| Détectable par | tcp.window_size <= 1024 | tcp.window_size > 1024 |

---

## Tâche 3 : TCP FIN Scan {#tache-3}

### Objectif
Détecter les paquets envoyés par `nmap -sF <target>`

### Principe
- Envoie des paquets TCP avec uniquement le flag FIN
- Technique de scan furtif qui exploite la RFC 793
- Les ports fermés répondent avec RST, les ports ouverts ignorent

### Filtre requis
```
tcp.flags == 0x01
```

### Explication détaillée du filtre

**`tcp.flags == 0x01`** : Valeur exacte des flags TCP
- **0x01 en hexadécimal = 1 en décimal = 00000001 en binaire**
- Seul le bit 0 (FIN) est activé
- Tous les autres flags sont à 0

### Décomposition binaire des flags TCP
| Flag | Bit | Binaire | Hex | Décimal |
|------|-----|---------|-----|---------|
| FIN  | 0   | 00000001 | 0x01 | 1 |
| SYN  | 1   | 00000010 | 0x02 | 2 |
| RST  | 2   | 00000100 | 0x04 | 4 |
| PSH  | 3   | 00001000 | 0x08 | 8 |
| ACK  | 4   | 00010000 | 0x10 | 16 |
| URG  | 5   | 00100000 | 0x20 | 32 |

### Test pratique
```bash
# Terminal 1 : Wireshark avec filtre tcp.flags == 0x01
# Terminal 2 :
sudo nmap -sF 8.8.8.8
```

### Signatures distinctives de nmap -sF
- **Flags** : FIN uniquement (0x01)
- **Window size** : 1024
- **Séquence** : 1 (pas 0 comme SYN)
- **Longueur** : 0 (pas de données)
- **Réponses attendues** : RST pour ports fermés, rien pour ports ouverts

---

## Tâche 4 : TCP Ping Sweeps {#tache-4}

### Objectif
Détecter les paquets envoyés par `nmap -sn -PS/-PA <subnet>`

### Principe
- `-PS` : TCP SYN ping sweep (découverte d'hôtes avec SYN)
- `-PA` : TCP ACK ping sweep (découverte d'hôtes avec ACK)
- Utilisé pour identifier les hôtes actifs sur un réseau

### Filtre requis
```
tcp.syn== 1 and tcp.ack== 1
```

### Explication détaillée du filtre

**`tcp.syn== 1 and tcp.ack== 1`** : SYN+ACK simultanés
- **Cas d'usage** : Capture les réponses SYN+ACK des serveurs
- **Valeur hex** : 0x12 (SYN=0x02 + ACK=0x10)
- **Signification** : Hôte répond positivement au ping TCP

### Analyse des deux types de ping TCP

**TCP SYN Ping (-PS)** :
- Nmap envoie : SYN (0x02)
- Hôte répond : SYN+ACK (0x12) si port ouvert
- Hôte répond : RST (0x04) si port fermé

**TCP ACK Ping (-PA)** :
- Nmap envoie : ACK (0x10)  
- Hôte répond : RST (0x04) si vivant

### Ports de destination par défaut

**Ports testés par -PS** :
- Port 80 (HTTP)
- Port 443 (HTTPS)
- Port 22 (SSH)
- Port 21 (FTP)

**Ports testés par -PA** :
- Port 80 (HTTP)
- Ports aléatoires élevés

### Test pratique
```bash
# Terminal 1 : Wireshark avec filtre tcp.syn== 1 and tcp.ack== 1
# Terminal 2 :
sudo nmap -sn -PS 192.168.1.0/24
sudo nmap -sn -PA 192.168.1.0/24
```

### Signatures distinctives des ping sweeps
- **Window size** : Variable selon l'OS cible
- **Réponses rapides** : Millisecondes entre requête et réponse
- **Pattern** : Balayage séquentiel d'adresses IP

---

## Tâche 5 : UDP Port Scan {#tache-5}

### Objectif
Détecter les paquets envoyés par `nmap -sU <target>`

### Principe
- Envoie des paquets UDP vides vers différents ports
- Les ports fermés génèrent des réponses ICMP "Port unreachable"
- Les ports ouverts ne répondent généralement pas

### Filtre requis
```
icmp.type == 3 and icmp.code == 3
```

### Explication détaillée du filtre

**`icmp.type == 3`** : ICMP Destination Unreachable
- **Type 3** = Message d'erreur ICMP
- Indique que la destination n'est pas accessible

### Types ICMP principaux (référence complète)
| Type | Nom | Description | Contexte d'usage |
|------|-----|-------------|------------------|
| **0** | **Echo Reply** | **Réponse ping** | **Réponse aux ping normaux** |
| 1 | Unassigned | Non assigné | Obsolète |
| 2 | Unassigned | Non assigné | Obsolète |
| **3** | **Destination Unreachable** | **Destination inaccessible** | **Ports/hôtes fermés** |
| 4 | Source Quench | Contrôle de flux | Obsolète (RFC 6633) |
| 5 | Redirect | Redirection | Optimisation routage |
| 6 | Alternate Host Address | Adresse alternative | Obsolète |
| 7 | Unassigned | Non assigné | Non utilisé |
| **8** | **Echo Request** | **Requête ping** | **Ping sweep, test connectivité** |
| 9 | Router Advertisement | Annonce routeur | Découverte routeurs |
| 10 | Router Solicitation | Demande routeur | Recherche routeurs |
| **11** | **Time Exceeded** | **TTL expiré** | **Traceroute, boucles** |
| 12 | Parameter Problem | Problème paramètre | En-têtes malformés |
| 13 | Timestamp Request | Requête timestamp | Synchronisation |
| 14 | Timestamp Reply | Réponse timestamp | Synchronisation |

**`icmp.code == 3`** : Port Unreachable
- **Code 3** = Sous-type spécifique "Port unreachable"
- Généré quand un port UDP est fermé

### Codes ICMP Type 3 (Destination Unreachable)
| Code | Signification | Description |
|------|---------------|-------------|
| 0 | Network Unreachable | Réseau inaccessible |
| 1 | Host Unreachable | Hôte inaccessible |
| 2 | Protocol Unreachable | Protocole non supporté |
| **3** | **Port Unreachable** | **Port UDP fermé** |
| 4 | Fragmentation needed | Fragmentation requise |
| 5 | Source route failed | Routage source échoué |
| 6 | Network unknown | Réseau inconnu |
| 7 | Host unknown | Hôte inconnu |

### Test pratique
```bash
# Terminal 1 : Wireshark avec filtre icmp.type == 3 and icmp.code == 3
# Terminal 2 :
sudo nmap -sU 8.8.8.8
```

### Signatures distinctives de nmap -sU
- **Messages ICMP** : "Destination unreachable (Port unreachable)"
- **Direction** : Du serveur vers l'attaquant
- **Timing** : Réponses espacées (UDP scan est lent)
- **Ports testés** : 1-1000 par défaut, puis ports populaires

---

## Tâche 6 : UDP Ping Sweeps {#tache-6}

### Objectif
Détecter les paquets envoyés par `nmap -sn -PU <subnet>`

### Principe
- Envoie des paquets UDP vers des ports fermés
- Objectif : découverte d'hôtes actifs
- Les hôtes répondent avec ICMP Port Unreachable si vivants

### Filtre requis
```
udp and udp.dstport == 7
```

### Explication détaillée du filtre

**`udp`** : Protocole UDP
- Filtre tous les paquets UDP (protocole IP 17)
- Équivalent à `ip.proto == 17`

**`udp.dstport == 7`** : Port de destination 7
- **Port 7** = Service Echo (RFC 862)
- Service rarement activé sur les systèmes modernes
- Choix stratégique de nmap pour éviter les services actifs

### Ports UDP utilisés par nmap -PU

**Ports par défaut** :
| Port | Service | Raison du choix |
|------|---------|----------------|
| **7** | Echo | Rarement activé, réponse ICMP garantie |
| 9 | Discard | Service obsolète |
| 13 | Daytime | Service obsolète |
| 37 | Time | Service obsolète |
| 123 | NTP | Peut être filtré |
| 161 | SNMP | Peut être actif |

### Test pratique
```bash
# Terminal 1 : Wireshark avec filtre udp and udp.dstport == 7
# Terminal 2 :
sudo nmap -sn -PU 192.168.1.0/24
```

### Signatures distinctives de nmap -PU
- **Longueur UDP** : 8 bytes (header UDP seulement, pas de données)
- **Port source** : Aléatoire et élevé (>32768)
- **Port destination** : 7 (Echo) principalement
- **Réponse attendue** : ICMP Port Unreachable si hôte vivant

---

## Tâche 7 : ICMP Ping Sweep {#tache-7}

### Objectif
Détecter les paquets envoyés par `nmap -sn -PE <subnet>`

### Principe
- Envoie des requêtes ICMP Echo Request vers chaque IP du subnet
- Capture les requêtes ET les réponses pour une analyse complète
- Technique classique et efficace de découverte d'hôtes

### Filtre requis
```
icmp.type == 8 or icmp.type == 0
```

### Explication détaillée du filtre

**`icmp.type == 8`** : ICMP Echo Request
- **Type 8** = Requête de ping (envoyée par nmap)
- Paquet sortant de votre machine vers les cibles

**`icmp.type == 0`** : ICMP Echo Reply  
- **Type 0** = Réponse de ping (envoyée par les cibles)
- Paquet entrant des cibles vers votre machine

### Types ICMP complets (référence)
| Type | Nom | Description | Direction |
|------|-----|-------------|-----------|
| **0** | **Echo Reply** | **Réponse ping** | **Cible → Vous** |
| 3 | Destination Unreachable | Erreur de routage | Routeur → Vous |
| 4 | Source Quench | Contrôle de flux | Routeur → Vous |
| 5 | Redirect | Redirection | Routeur → Vous |
| **8** | **Echo Request** | **Requête ping** | **Vous → Cible** |
| 9 | Router Advertisement | Annonce routeur | Routeur → Réseau |
| 10 | Router Solicitation | Demande routeur | Hôte → Réseau |
| 11 | Time Exceeded | TTL expiré | Routeur → Vous |
| 12 | Parameter Problem | Problème paramètre | Routeur → Vous |
| 13 | Timestamp Request | Requête timestamp | Hôte → Hôte |
| 14 | Timestamp Reply | Réponse timestamp | Hôte → Hôte |

### Test pratique
```bash
# Terminal 1 : Wireshark avec filtre icmp.type == 8 or icmp.type == 0
# Terminal 2 :
sudo nmap -sn -PE 192.168.1.0/24
```

### Signatures distinctives de nmap -PE
- **Echo Request (type 8)** : Paquets sortants de votre IP
- **Echo Reply (type 0)** : Réponses des hôtes vivants
- **ID ICMP** : Spécifique à nmap (souvent 0x1d0b ou similaire)
- **Séquence** : Commence à 0, incrémente
- **TTL** : Variable selon l'OS cible (54, 64, 128, 255)

---

## Tâche 8 : ARP Scanning {#tache-8}

### Objectif
Détecter les paquets envoyés par `arp-scan -l`

### Principe
- Envoie des requêtes ARP "Who has X.X.X.X?" pour chaque IP du réseau local
- Fonctionne uniquement sur le même segment réseau (couche 2)
- Très efficace car ARP ne peut pas être filtré par les firewalls

### Filtre requis
```
arp.dst.hw_mac == 00:00:00:00:00:00
```

### Explication détaillée du filtre

**`arp.dst.hw_mac == 00:00:00:00:00:00`** : Adresse MAC de destination nulle
- **00:00:00:00:00:00** = Adresse MAC inconnue/vide
- Signature des requêtes ARP : "Je cherche qui a cette IP"
- Différent du broadcast (ff:ff:ff:ff:ff:ff)

### Structure du protocole ARP

**Opcodes ARP** :
| Opcode | Valeur | Type | Description |
|--------|--------|------|-------------|
| **1** | 0x0001 | **Request** | **"Who has IP X?"** |
| **2** | 0x0002 | **Reply** | **"IP X is at MAC Y"** |
| 3 | 0x0003 | RARP Request | Reverse ARP Request |
| 4 | 0x0004 | RARP Reply | Reverse ARP Reply |

**Champs ARP importants** :
| Champ | Requête ARP | Réponse ARP |
|-------|-------------|-------------|
| Opcode | 1 (Request) | 2 (Reply) |
| Sender MAC | MAC de l'expéditeur | MAC du répondeur |
| Sender IP | IP de l'expéditeur | IP du répondeur |
| Target MAC | **00:00:00:00:00:00** | MAC de l'expéditeur original |
| Target IP | IP recherchée | IP de l'expéditeur original |

### Test pratique
```bash
# Terminal 1 : Wireshark avec filtre arp.dst.hw_mac == 00:00:00:00:00:00
# Terminal 2 :
sudo arp-scan -l
# Ou pour un subnet spécifique :
sudo arp-scan 192.168.1.0/24
```

### Signatures distinctives de arp-scan
- **Opcode** : 1 (Request)
- **Target MAC** : 00:00:00:00:00:00 (MAC inconnue)
- **Destination Ethernet** : ff:ff:ff:ff:ff:ff (Broadcast)
- **Timing** : Requêtes rapides et séquentielles
- **Pattern** : Balayage ordonné des IPs (192.168.1.1, 192.168.1.2, etc.)

### Différence avec ping ICMP
- **ARP** : Couche 2 (Ethernet), ne traverse pas les routeurs
- **ICMP** : Couche 3 (IP), peut traverser les routeurs
- **ARP** : Plus difficile à bloquer ou filtrer
- **ARP** : Limité au réseau local uniquement

---

## Référence des flags TCP {#flags-tcp}

### Tableau des flags

| Flag | Bit | Valeur hex | Filtre individuel |
|------|-----|------------|-------------------|
| FIN  | 0   | 0x01       | tcp.flags.fin == 1 |
| SYN  | 1   | 0x02       | tcp.flags.syn == 1 |
| RST  | 2   | 0x04       | tcp.flags.reset == 1 |
| PSH  | 3   | 0x08       | tcp.flags.push == 1 |
| ACK  | 4   | 0x10       | tcp.flags.ack == 1 |
| URG  | 5   | 0x20       | tcp.flags.urg == 1 |

### Différence importante : Bit vs Valeur complète

**Test d'un bit spécifique** : `tcp.flags.fin == 1`
- Match tous les paquets contenant FIN (même avec d'autres flags)

**Test de valeur complète** : `tcp.flags == 0x001`
- Match uniquement FIN seul, sans autres flags

| Paquet | Flags | Hex | `tcp.flags.fin == 1` | `tcp.flags == 0x001` |
|--------|-------|-----|---------------------|---------------------|
| FIN seul | FIN | 0x01 | ✅ | ✅ |
| FIN + ACK | FIN, ACK | 0x11 | ✅ | ❌ |

---

## Démarche de test générale {#test-kali}

### Préparation
1. Ouvrir deux terminaux
2. Lancer Wireshark en root : `sudo wireshark`
3. Sélectionner l'interface réseau
4. Appliquer le filtre approprié selon la tâche

### Étapes de test
1. **Démarrer la capture** dans Wireshark
2. **Exécuter la commande nmap/arp-scan** dans le second terminal
3. **Observer les paquets** capturés
4. **Vérifier** que le filtre capture bien les bons paquets
5. **Analyser** les champs spécifiques (flags, protocoles, types)

### Résumé des filtres par tâche

| Tâche | Commande | Filtre Wireshark | Explication courte |
|-------|----------|------------------|-------------------|
| 0 | `nmap -sO` | `icmp` | Capture protocole ICMP (IP proto 1) |
| 1 | `nmap -sS` | `tcp.syn == 1 and tcp.ack == 0 and tcp.window_size <= 1024` | SYN pur avec window ≤ 1024 |
| 2 | `nmap -sT` | `tcp.syn == 1 and tcp.ack == 0 and tcp.window_size > 1024` | SYN système avec window normale |
| 3 | `nmap -sF` | `tcp.flags == 0x01` | Flag FIN uniquement |
| 4 | `nmap -sn -PS/-PA` | `tcp.syn== 1 and tcp.ack== 1` | Réponses SYN+ACK (0x12) |
| 5 | `nmap -sU` | `icmp.type == 3 and icmp.code == 3` | ICMP Port Unreachable |
| 6 | `nmap -sn -PU` | `udp and udp.dstport == 7` | UDP vers port Echo (7) |
| 7 | `nmap -sn -PE` | `icmp.type == 8 or icmp.type == 0` | ICMP ping requête/réponse |
| 8 | `arp-scan -l` | `arp.dst.hw_mac == 00:00:00:00:00:00` | ARP avec MAC destination nulle |

### Référence rapide des valeurs numériques

**Protocoles IP** :
- ICMP = 1, TCP = 6, UDP = 17

**Flags TCP (hex)** :
- FIN = 0x01, SYN = 0x02, RST = 0x04, ACK = 0x10

**Types ICMP** :
- Echo Reply = 0, Dest Unreachable = 3, Echo Request = 8

**Codes ICMP Type 3** :
- Port Unreachable = 3

**Ports UDP ping** :
- Echo = 7, Discard = 9, NTP = 123

**ARP Opcodes** :
- Request = 1, Reply = 2

**MAC spéciales** :
- Null = 00:00:00:00:00:00, Broadcast = ff:ff:ff:ff:ff:ff