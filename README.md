# 🚀 InterpolationApp - Sonde Fuel Oil

InterpolationApp est une application Android développée en Kotlin. Elle embarque une WebView qui charge une page HTML locale (`sounding.html`) depuis les assets de l'application. L'utilisateur peut capturer la vue de la WebView en image et l'enregistrer dans la galerie.

## ✨ Fonctionnalités

- 🌐 Affiche une page HTML embarquée via WebView (`sounding.html`)
- 📸 Capture l'écran de la WebView au format PNG
- 💾 Enregistrement dans `Pictures/FuelSonde/`
- 🔐 Gestion automatique des permissions d’écriture (Android < Q)
- 🛠️ Icône personnalisée : pompe à essence

---

## 📁 Structure du projet

app/
├── src/
│ └── main/
│ ├── java/com/example/interpolationapp/MainActivity.kt
│ ├── res/
│ │ ├── layout/activity_main.xml
│ │ ├── mipmap-*/pump_icon.png
│ ├── assets/sounding.html
│ └── AndroidManifest.xml

## ⚙️ Configuration

### 1. Autorisations

Pour Android 9 (API 28) et moins, l'app demande la permission d'accéder au stockage :

<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="28" />
2. Icône de l'application
L’icône est placée dans tous les dossiers mipmap-* sous le nom pump_icon.png et utilisée via :

xml
Copy
Edit
<application
    android:icon="@mipmap/pump_icon"
🧪 Test rapide
Lance l'app dans un émulateur ou appareil réel.

Une fois la page HTML affichée, clique sur le bouton ou déclenche le script JS AndroidInterface.captureWebView().

Vérifie que l'image est bien enregistrée dans Pictures/FuelSonde/.

📜 Technologies utilisées
Kotlin

WebView

HTML/JS embarqué

MediaStore API (Android Q+)

Gestion des permissions

🧑‍💻 Auteur
Projet réalisé par DM/Michael Raharison à Madagascar 🇲🇬

Contact : michaeldm034@gmail.com / +261 32 49 084 09

📃 Licence
Ce projet est open-source et distribué sous licence MIT.
