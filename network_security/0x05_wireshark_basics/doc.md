# Documentation Wireshark - Détection de scans réseau

## Table des matières
1. [Bases des protocoles IP](#protocoles-ip)
2. [Flags TCP](#flags-tcp)
3. [Filtres de détection](#filtres-detection)
4. [Démarche de test](#test-kali)
5. [Concepts avancés](#concepts-avances)

## Protocoles IP couramment testés par nmap -sO {#protocoles-ip}

| Protocole | Numéro | Description |
|-----------|---------|-------------|
| ICMP | 1 | Internet Control Message Protocol |
| IGMP | 2 | Internet Group Management Protocol |
| TCP | 6 | Transmission Control Protocol |
| UDP | 17 | User Datagram Protocol |
| GRE | 47 | Generic Routing Encapsulation |
| ESP | 50 | Encapsulating Security Payload |
| AH | 51 | Authentication Header |

### Filtre IP Protocol scan
```
ip.proto == 1
```

## Flags TCP {#flags-tcp}

### Valeurs hexadécimales des flags TCP

| Flag | Bit | Valeur hex | Filtre Wireshark |
|------|-----|------------|------------------|
| FIN  | 0   | 0x01       | tcp.flags.fin == 1 |
| SYN  | 1   | 0x02       | tcp.flags.syn == 1 |
| RST  | 2   | 0x04       | tcp.flags.reset == 1 |
| PSH  | 3   | 0x08       | tcp.flags.push == 1 |
| ACK  | 4   | 0x10       | tcp.flags.ack == 1 |
| URG  | 5   | 0x20       | tcp.flags.urg == 1 |
| ECE  | 6   | 0x40       | tcp.flags.ecn == 1 |
| CWR  | 7   | 0x80       | tcp.flags.cwr == 1 |
| NS   | 8   | 0x100      | tcp.flags.ns == 1 |

## Filtres de détection {#filtres-detection}

### Scans TCP Nmap

| Scan Nmap | Flags envoyés | Valeur hex | Filtre Wireshark |
|-----------|---------------|------------|------------------|
| NULL scan (-sN) | Aucun flag | 0x000 | tcp.flags == 0x000 |
| FIN scan (-sF) | FIN | 0x001 | tcp.flags == 0x001 |
| Xmas scan (-sX) | FIN + PSH + URG | 0x029 | tcp.flags == 0x029 |
| SYN scan (-sS) | SYN | 0x002 | tcp.flags == 0x002 |
| ACK scan (-sA) | ACK | 0x010 | tcp.flags == 0x010 |

### Filtres avancés
```
# Tous les protocoles IP testés par nmap -sO
ip.proto == 1 or ip.proto == 2 or ip.proto == 6 or ip.proto == 17 or ip.proto == 47 or ip.proto == 50 or ip.proto == 51

# Détecter les scans TCP SYN
tcp.flags.syn == 1 and tcp.flags.ack == 0

# Détecter tous les scans TCP suspects
tcp.flags == 0x000 or tcp.flags == 0x001 or tcp.flags == 0x029
```

## Démarche de test avec Kali Linux {#test-kali}

### 1. Préparation
```bash
# Ouvrir deux terminaux
# Terminal 1 : pour Wireshark
# Terminal 2 : pour nmap
```

### 2. Lancement de Wireshark
```bash
sudo wireshark
```

### 3. Configuration de la capture
1. Sélectionner l'interface réseau (eth0, wlan0, etc.)
2. Appliquer le filtre approprié
3. Démarrer la capture

### 4. Tests par type de scan

#### Test IP Protocol scan (-sO)
```bash
# Filtre Wireshark : ip.proto == 1
sudo nmap -sO 8.8.8.8
```

#### Test SYN scan (-sS)
```bash
# Filtre Wireshark : tcp.flags == 0x002
sudo nmap -sS 8.8.8.8
```

#### Test FIN scan (-sF)
```bash
# Filtre Wireshark : tcp.flags == 0x001
sudo nmap -sF 8.8.8.8
```

### 5. Analyse des résultats
- Observer les paquets capturés
- Vérifier les adresses source/destination
- Confirmer que les flags correspondent au type de scan

## Concepts avancés {#concepts-avances}

### Différence entre tcp.flags.fin == 1 et tcp.flags == 0x001

#### Test d'un bit vs valeur complète

**`tcp.flags.fin == 1`** (Test d'un bit spécifique)
- Vérifie uniquement que le bit FIN est activé
- Match tous les paquets contenant FIN, même avec d'autres flags

**`tcp.flags == 0x001`** (Test de la valeur complète)
- Vérifie que la valeur entière des flags = 1
- Match uniquement FIN seul, sans autres flags

#### Exemple pratique

| Paquet | Flags | Hex | `tcp.flags.fin == 1` | `tcp.flags == 0x001` |
|--------|-------|-----|---------------------|---------------------|
| FIN seul | FIN | 0x01 | ✅ | ✅ |
| FIN + ACK | FIN, ACK | 0x11 | ✅ | ❌ |
| FIN + PSH | FIN, PSH | 0x09 | ✅ | ❌ |

#### Utilisation recommandée

- **`tcp.flags.fin == 1`** : Analyser tous les paquets FIN (trafic normal + scans)
- **`tcp.flags == 0x001`** : Détecter uniquement les scans nmap -sF (signatures anormales)